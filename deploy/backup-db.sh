#!/usr/bin/env bash
# Moirai — Railway Postgres 백업
#
# Postgres 컨테이너 안에서 pg_dump를 실행하고 결과만 로컬로 받아온다.
# TCP 프록시를 켜지 않으므로 DB가 인터넷에 노출되지 않고, 로컬에
# pg_dump를 설치할 필요도 없다 (서버와 클라이언트 버전이 항상 일치).
#
# 사전 준비 (각 1회):
#   brew install railway
#   railway login
#   railway link                       # 프로젝트 루트에서 프로젝트 선택
#   railway ssh -s Postgres -- echo ok # SSH 키 등록 절차를 먼저 통과시켜 둔다
#
# 사용법:
#   deploy/backup-db.sh
#   BACKUP_DIR=~/moirai-backups deploy/backup-db.sh
#   KEEP=30 deploy/backup-db.sh

set -euo pipefail

SERVICE="${SERVICE:-Postgres}"
BACKUP_DIR="${BACKUP_DIR:-./backups}"
KEEP="${KEEP:-14}"

command -v railway >/dev/null \
    || { echo "railway CLI가 없습니다. brew install railway" >&2; exit 1; }

mkdir -p "$BACKUP_DIR"

stamp="$(date +%Y%m%d-%H%M%S)"
out="$BACKUP_DIR/moirai-$stamp.sql.gz"
tmp="$(mktemp "${TMPDIR:-/tmp}/moirai-dump.XXXXXX")"
trap 'rm -f "$tmp"' EXIT

echo "덤프 중... (service=$SERVICE)"
railway ssh -s "$SERVICE" -- \
    sh -c 'pg_dump -U "$PGUSER" -d "$PGDATABASE" --no-owner --no-privileges' \
    > "$tmp"

# 끝까지 내려왔는지 확인한다. 중간에 끊긴 덤프나 CLI 안내 메시지만 담긴
# 파일은 복구에 쓸 수 없는데, 크기만 보면 성공한 것처럼 보인다.
if ! grep -q 'PostgreSQL database dump complete' "$tmp"; then
    echo "덤프가 완전하지 않습니다. 저장하지 않고 중단합니다." >&2
    echo "--- 받은 내용 앞부분 ---" >&2
    head -5 "$tmp" >&2
    exit 1
fi

tables="$(grep -c '^COPY public\.' "$tmp" || true)"

gzip -c "$tmp" > "$out"
echo "저장됨: $out ($(du -h "$out" | cut -f1), 테이블 $tables개)"

# 오래된 백업 정리 — 최근 $KEEP 개만 남긴다.
cd "$BACKUP_DIR"
ls -1t moirai-*.sql.gz 2>/dev/null | tail -n "+$((KEEP + 1))" | while read -r old; do
    echo "삭제: $old"
    rm -f "$old"
done
