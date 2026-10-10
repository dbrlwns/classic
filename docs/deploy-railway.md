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

Settings → Networking → **Custom Domain** 에 `moirai.kr` 을 넣으면
Railway 가 CNAME 값을 알려준다. 도메인 DNS 에 그 CNAME 을 건다.

인증서는 Railway 가 알아서 발급·갱신한다. certbot 이 필요 없다.

도메인이 붙은 뒤 확인:

```bash
curl -s https://moirai.kr/works/bolero | grep 'og:url'
# https://moirai.kr/works/bolero 로 나와야 한다
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

## 7. 백업

Railway 대시보드의 Postgres 서비스에서 백업을 켠다.
그와 별개로, 가끔 직접 받아 두는 편이 안전하다.

```bash
# Postgres 서비스 → Variables 의 DATABASE_PUBLIC_URL 을 쓴다
pg_dump '<DATABASE_PUBLIC_URL>' -Fp | gzip > moirai-$(date +%F).sql.gz
```

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
