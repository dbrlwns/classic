#!/usr/bin/env bash
#
# 매일 DB 를 덤프하고 오래된 것을 지운다.
#
#   sudo cp backup-db.sh /usr/local/bin/moirai-backup
#   sudo chmod +x /usr/local/bin/moirai-backup
#   sudo crontab -e
#       15 4 * * * /usr/local/bin/moirai-backup >> /var/log/moirai-backup.log 2>&1
#
# 중요: 이 백업은 같은 서버에 있다. 디스크가 날아가면 백업도 같이 날아간다.
# 스토리 38편이 DB 에만 있으므로, 주기적으로 받은 파일을 다른 곳으로
# 옮겨 두는 것까지 해야 진짜 백업이다.
#
# 그리고 복구해 본 적 없는 백업은 백업이 아니다. 한 번은 해 보라:
#   createdb -U postgres moirai_restore_test
#   gunzip -c /var/backups/moirai/moirai-2026-10-10.sql.gz | psql -U postgres -d moirai_restore_test
#   psql -U postgres -d moirai_restore_test -c 'select count(*) from work'

set -euo pipefail

BACKUP_DIR=/var/backups/moirai
KEEP_DAYS=14
DB_NAME=moirai
DB_USER=moirai

mkdir -p "$BACKUP_DIR"

STAMP=$(date +%Y-%m-%d-%H%M)
TARGET="$BACKUP_DIR/moirai-$STAMP.sql.gz"

# -Fp 는 평문 SQL. 작은 DB 라 복구가 단순한 쪽이 낫다.
# .pgpass 에 비밀번호를 두거나 peer 인증을 쓴다. 명령줄에 적으면 ps 에 보인다.
pg_dump -U "$DB_USER" -h 127.0.0.1 -Fp "$DB_NAME" | gzip > "$TARGET"

# 덤프가 비었는지 확인한다. 실패해도 gzip 은 성공해서 빈 파일이 남을 수 있다.
SIZE=$(stat -c %s "$TARGET")
if [ "$SIZE" -lt 1024 ]; then
    echo "[$(date -Is)] 덤프가 너무 작다($SIZE 바이트). 실패로 본다: $TARGET" >&2
    exit 1
fi

echo "[$(date -Is)] 백업 완료 $TARGET ($SIZE 바이트)"

# 오래된 것 정리
find "$BACKUP_DIR" -name 'moirai-*.sql.gz' -mtime +"$KEEP_DAYS" -delete
echo "[$(date -Is)] $KEEP_DAYS 일 지난 백업 정리됨. 현재 $(ls -1 "$BACKUP_DIR" | wc -l)개 보관"
