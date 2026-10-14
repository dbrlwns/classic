# Railway 배포

`git push` 하면 배포된다. Postgres 는 Railway 가 관리형으로 붙여 준다.

처음이면 **20~30분**. 대부분 웹 화면에서 클릭이고, 손으로 치는 건 환경변수뿐이다.

---

## 1. 프로젝트 만들기

1. railway.com 에 GitHub 으로 로그인
2. **New Project → Deploy from GitHub repo → `dbrlwns/classic`**
3. 저장소에 `Dockerfile` 이 있으므로 Railway 가 그걸로 빌드한다.
   Nixpacks 자동 감지에 맡기지 않는 이유는 JDK 버전을 못박기 위해서다.

> 첫 빌드는 **실패하는 게 정상이다.** DB 와 환경변수가 아직 없다.
> 3번까지 하고 다시 배포한다.

---

## 2. Postgres 붙이기

같은 프로젝트 안에서 **New → Database → Add PostgreSQL**.

테이블은 만들지 않는다. **Flyway 가 앱 첫 기동 때 V1·V2 를 실행한다.**

---

## 3. 환경변수 (여기가 유일하게 까다롭다)

앱 서비스 → **Variables** 탭에 아래를 넣는다.

```
SPRING_PROFILES_ACTIVE = prod

DATABASE_URL      = jdbc:postgresql://${{Postgres.PGHOST}}:${{Postgres.PGPORT}}/${{Postgres.PGDATABASE}}
DATABASE_USERNAME = ${{Postgres.PGUSER}}
DATABASE_PASSWORD = ${{Postgres.PGPASSWORD}}

ADMIN_USERNAME = 원하는_아이디
ADMIN_PASSWORD = 긴_비밀번호
```

`${{Postgres.PGHOST}}` 는 Railway 의 **참조 변수** 문법이다. DB 서비스의 값을
가져다 쓴다. DB 비밀번호가 바뀌어도 따라간다.

> **Railway 가 주는 `DATABASE_URL` 을 그대로 쓰면 안 된다.**
> Railway 는 `postgresql://user:pass@host:port/db` 형식으로 주는데,
> Spring 의 JDBC 드라이버는 `jdbc:postgresql://host:port/db` 를 기대한다.
> 그래서 위처럼 조각(PGHOST 등)으로 직접 조립한다.
> 이걸 모르고 그대로 넣으면 `Driver claims to not accept jdbcUrl` 이 난다.

**넣지 말아야 할 것**

- `PORT` — Railway 가 알아서 넣는다. 직접 넣으면 어긋난다
- `SERVER_ADDRESS` — **절대 넣지 않는다.** 127.0.0.1 로 가두면 Railway 프록시가
  컨테이너 밖에서 못 들어와 `no healthy upstream` 이 뜬다.
  이건 직접 띄우는 서버에서만 쓰는 값이다(`deploy/moirai.env.example`)

---

## 4. 확인

**Deployments → 로그**에서 이게 보여야 한다.

```
Migrating schema "public" to version "1 - schema"
Migrating schema "public" to version "2 - seed catalog"
Started ClassicApplication
```

**Settings → Networking → Generate Domain** 으로 임시 주소를 받는다.
`xxx.up.railway.app` 으로 열어서 곡 38개가 보이면 성공이다.

```
/              곡 목록
/admin         관리 화면 (위에서 정한 아이디로 로그인)
```

---

## 5. 도메인 연결

Settings → Networking → **Custom Domain** 에 `moirai.date` 을 넣으면
Railway 가 레코드 두 개를 알려준다. **둘 다** 넣어야 한다.

| Type | Name | Content |
|---|---|---|
| CNAME | `@` | `xxxx.up.railway.app` |
| TXT | `_railway-verify` | Railway 가 보여주는 값 |

CNAME 은 트래픽이 어디로 갈지 정하고, TXT 는 "이 도메인이 정말 내 것"임을
증명한다. **TXT 가 없으면 CNAME 이 초록이어도 Railway 가 요청을 받지 않는다.**
실제로 여기서 한 번 막혔다.

Cloudflare 를 쓴다면:

- **프록시는 회색 구름(DNS only)** 으로 둔다. 주황색이면 Cloudflare 가 TLS 를
  가로채서 Railway 가 인증서를 발급하지 못하고, SSL 모드가 Flexible 이면
  리다이렉트 무한 루프가 생긴다.
- 루트 도메인에 CNAME 을 걸어도 된다. Cloudflare 가 **플래트닝**해서 A 레코드로
  응답한다. 그래서 `nslookup -type=CNAME` 에는 안 보이고 A 레코드만 보이는데,
  이게 정상이다.
- TXT 의 Name 칸에는 `_railway-verify` 만 넣는다. 전체 주소를 붙여넣으면
  Cloudflare 가 도메인을 또 붙여 `_railway-verify.moirai.date.moirai.date` 가 된다.

인증서는 Railway 가 알아서 발급·갱신한다. certbot 이 필요 없다.

> 맥에서 `curl` 이 "Could not resolve host" 라고 하는데 `nslookup` 은 되는 경우,
> 시스템 DNS 캐시에 실패했던 결과가 남은 것이다.
> `sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder`

도메인이 붙은 뒤 확인:

```bash
curl -s https://moirai.date/works/bolero | grep 'og:url'
# https://moirai.date/works/bolero 로 나와야 한다
```

---

## 6. 그 뒤의 배포

```bash
git push
```

끝이다. Railway 가 알아서 빌드하고 교체한다.

**스키마를 바꿨다면** V 파일을 새로 쓴 상태여야 한다. 엔티티만 고치고
배포하면 `validate` 가 막아서 앱이 뜨지 않는다 — 그게 이 구조의 의도다.

---

## 7. 요금

Hobby 는 **$5/월 구독료 + 사용량**이다. $5 사용량 크레딧이 포함되고,
넘으면 초과분이 추가 청구된다. 크레딧은 이월되지 않는다.

| 항목 | 요율 |
|---|---|
| RAM | $10 / GB / 월 |
| CPU | $20 / vCPU / 월 |
| 송신 | $0.05 / GB |

이 앱의 실측 메모리는 **RSS 약 385MB** 다(Dockerfile 의 -Xmx384m 기준).
힙을 256m 으로 줄여도 377MB 라 거의 안 줄어든다 — 대부분이 힙이 아니라
JVM 자체 오버헤드이기 때문이다.

    앱     0.385GB x $10  =  약 $3.9/월
    DB     0.2GB 안팎     =  약 $2/월
    CPU    대체로 유휴    =  $1 미만
    ------------------------------------
    합계                     대략 $6~8/월

즉 **$5 구독료에 월 $1~3 정도가 더 붙는 그림**이다. 트래픽이 거의 없는
상태 기준이고, 실제 숫자는 첫 달 청구서를 봐야 안다.

> **Settings → Usage Limits 에서 상한을 걸 수 있다.** 다만 상한에 닿으면
> 배포가 전부 내려간다. 사이트가 멈춘다는 뜻이므로, 경고용으로 여유 있게
> 잡는 편이 낫다.

## 8. 백업

Railway 대시보드의 Postgres 서비스에서 백업을 켠다.
그와 별개로, 가끔 직접 받아 두는 편이 안전하다.

```bash
# Postgres 서비스 → Variables 의 DATABASE_PUBLIC_URL 을 쓴다
pg_dump '<DATABASE_PUBLIC_URL>' -Fp | gzip > moirai-$(date +%F).sql.gz
```

맥에 `pg_dump` 가 없으면(기본으로 깔려 있지 않다):

```bash
brew install libpq
brew link --force libpq      # pg_dump, psql 을 PATH 에 건다
pg_dump --version            # 확인
```

`libpq` 는 서버 없이 클라이언트 도구만 설치한다. **클라이언트 버전이 서버보다
낮으면** pg_dump 가 "server version mismatch" 로 거부하므로, 최신으로 깐다.

> 스토리가 DB 에만 있다. **복구해 본 적 없는 백업은 백업이 아니다.**

---

## 막혔을 때

| 증상 | 원인 |
|---|---|
| `Driver claims to not accept jdbcUrl` | `DATABASE_URL` 을 `jdbc:` 로 시작하게 조립했는지 |
| `no healthy upstream` | `SERVER_ADDRESS` 를 넣었거나, 앱이 `PORT` 를 안 따름 |
| `Schema-validation: missing table` | Flyway 가 안 돌았다. DB 접속정보 확인 |
| `Unsupported Database` | Flyway DB 모듈 의존성 (현재 추가되어 있음) |
| `og:url` 이 http | `forward-headers-strategy` (현재 켜져 있음) |
| 빌드 실패 | Deployments → Build Logs. JDK 버전은 Dockerfile 이 못박는다 |

---

## 나중에 Oracle 로 옮긴다면

앱은 평범한 jar + Postgres 라 옮기기 쉽다.

1. `pg_dump` 로 데이터를 받는다
2. `docs/deploy-oracle.md` 를 따라 서버를 만든다
3. `psql` 로 밀어 넣는다

`deploy/` 의 systemd·nginx 설정은 그대로 쓸 수 있다.
