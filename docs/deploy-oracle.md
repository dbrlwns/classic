# Oracle Cloud 배포

Ampere A1(ARM64) 인스턴스 한 대에 앱과 PostgreSQL 을 함께 올린다.

처음이면 **반나절**은 잡는 게 맞다. 막히는 자리는 대부분 정해져 있고,
아래에 "여기서 막힌다" 로 표시해 뒀다.

---

## 0. 미리 알아둘 것

**ARM64 다.** Ampere A1 은 aarch64 이므로 JDK 도 ARM 용을 깔아야 한다.
x86 용을 받으면 `cannot execute binary file` 이 난다.

**방화벽이 두 겹이다.** Oracle 콘솔의 VCN 보안 목록과, 인스턴스 안의
iptables 양쪽을 열어야 한다. **여기서 제일 많이 막힌다.** 한쪽만 열고
"왜 안 되지" 하는 경우가 대부분이다.

**무료 한도는 2 OCPU / 12GB 다.** 2026년에 4/24 에서 줄었다. 이 앱 하나에는
차고 넘친다.

---

## 1. 인스턴스 만들기

- 홈 리전을 **춘천(ap-chuncheon-1)** 으로. 한국 독자 대상이면 지연이 가장 짧다.
  홈 리전은 **나중에 못 바꾼다.**
- Shape: `VM.Standard.A1.Flex`, OCPU 2 / 메모리 12GB
- 이미지: Ubuntu 24.04 (ARM)
- SSH 공개키 등록 — 맥이면 `~/.ssh/id_ed25519.pub`, 없으면
  `ssh-keygen -t ed25519` 로 만든다

> **"Out of host capacity" 가 뜨면** 당신 잘못이 아니라 리전에 ARM 물량이
> 없는 것이다. 몇 시간 뒤 다시 시도하거나, OCPU 를 1 로 줄여 보거나,
> 다른 가용 도메인(AD-1/2/3)을 골라 본다.

접속 확인:

```bash
ssh ubuntu@<공인IP>
```

---

## 2. 방화벽 (여기서 막힌다)

**(a) Oracle 콘솔** — 인스턴스 > 서브넷 > 보안 목록 > 인그레스 규칙 추가

| 소스 | 포트 |
|---|---|
| 0.0.0.0/0 | 80 |
| 0.0.0.0/0 | 443 |

**(b) 인스턴스 안** — Ubuntu 이미지는 22 번 말고 전부 막혀 있다.

```bash
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 80 -j ACCEPT
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 443 -j ACCEPT
sudo netfilter-persistent save      # 재부팅해도 남게
```

확인: `sudo iptables -L INPUT -n --line-numbers` 에 80/443 이 보여야 한다.

---

## 3. 기본 패키지

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y openjdk-21-jdk-headless postgresql nginx certbot python3-certbot-nginx

java -version        # aarch64 인지 확인
```

---

## 4. PostgreSQL

```bash
sudo -u postgres psql
```

```sql
CREATE USER moirai WITH PASSWORD '긴_비밀번호';
CREATE DATABASE moirai OWNER moirai;
\q
```

테이블은 만들지 않는다. **Flyway 가 앱 기동 때 V1·V2 를 실행한다.**

접속 확인:

```bash
psql -U moirai -h 127.0.0.1 -d moirai -c '\dt'   # 아직 비어 있는 게 정상
```

---

## 5. 앱 자리 만들기

```bash
sudo useradd --system --home /opt/moirai --shell /usr/sbin/nologin moirai
sudo mkdir -p /opt/moirai/logs /etc/moirai
sudo chown -R moirai:moirai /opt/moirai
```

환경변수 파일:

```bash
sudo cp deploy/moirai.env.example /etc/moirai/moirai.env
sudo nano /etc/moirai/moirai.env          # 값 채우기
sudo chown root:moirai /etc/moirai/moirai.env
sudo chmod 640 /etc/moirai/moirai.env
```

> `ADMIN_PASSWORD` 를 비우면 앱이 **일부러** 뜨지 않는다. 기본 비밀번호로
> 조용히 뜨는 것보다 낫다고 판단한 결과다.

---

## 6. jar 올리고 띄우기

맥에서:

```bash
./gradlew bootJar
scp build/libs/*-SNAPSHOT.jar ubuntu@<공인IP>:/tmp/moirai.jar
```

서버에서:

```bash
sudo mv /tmp/moirai.jar /opt/moirai/moirai.jar
sudo chown moirai:moirai /opt/moirai/moirai.jar

sudo cp deploy/moirai.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now moirai
sudo systemctl status moirai
```

로그에서 이게 보여야 한다:

```
Migrating schema "public" to version "1 - schema"
Migrating schema "public" to version "2 - seed catalog"
Started ClassicApplication
```

```bash
journalctl -u moirai -f          # 로그 따라 보기
curl -I http://127.0.0.1:8080/   # 200 이어야 한다
```

> 아직 **바깥에서는 안 열린다.** 앱이 127.0.0.1 에만 붙어 있기 때문이고,
> 의도한 것이다. nginx 를 거치게 한다.

---

## 7. nginx

```bash
sudo cp deploy/nginx-moirai.conf /etc/nginx/sites-available/moirai
sudo nano /etc/nginx/sites-available/moirai      # server_name 을 실제 도메인으로
sudo ln -s /etc/nginx/sites-available/moirai /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t                                    # 문법 검사. 반드시 먼저
sudo systemctl reload nginx
```

이제 `http://<공인IP>` 로 열려야 한다. 안 열리면 **2번 방화벽을 다시 본다.**

---

## 8. 도메인과 HTTPS

도메인 DNS 에 A 레코드로 공인 IP 를 걸고, 퍼진 뒤에:

```bash
dig +short moirai.kr             # 공인 IP 가 나와야 한다
sudo certbot --nginx -d moirai.kr -d www.moirai.kr
```

certbot 이 443 블록을 만들고 80 을 리다이렉트로 바꿔 준다.
자동 갱신은 `systemctl status certbot.timer` 로 확인.

확인:

```bash
curl -s https://moirai.kr/works/bolero | grep 'og:url'
# https:// 로 나와야 한다. http:// 면 nginx 의 X-Forwarded-Proto 를 확인한다
```

---

## 9. 백업

```bash
sudo cp deploy/backup-db.sh /usr/local/bin/moirai-backup
sudo chmod +x /usr/local/bin/moirai-backup
sudo /usr/local/bin/moirai-backup        # 한 번 돌려 본다
sudo crontab -e
#   15 4 * * * /usr/local/bin/moirai-backup >> /var/log/moirai-backup.log 2>&1
```

> **같은 서버에 있는 백업은 반쪽이다.** 디스크가 날아가면 같이 날아간다.
> 스토리가 DB 에만 있으므로, 가끔 맥으로 받아 두는 것까지 해야 한다.
> 그리고 **복구해 본 적 없는 백업은 백업이 아니다.** 한 번은 복구해 보라.

---

## 10. 배포 반복

여기까지 하면 그 뒤로는 jar 만 바꿔 끼우면 된다.

```bash
./gradlew bootJar
scp build/libs/*-SNAPSHOT.jar ubuntu@<공인IP>:/tmp/moirai.jar
ssh ubuntu@<공인IP> 'sudo mv /tmp/moirai.jar /opt/moirai/moirai.jar \
    && sudo chown moirai:moirai /opt/moirai/moirai.jar \
    && sudo systemctl restart moirai'
```

**스키마를 바꿨다면** V 파일을 새로 쓴 상태여야 한다. 엔티티만 고치고
배포하면 `validate` 가 막아서 앱이 뜨지 않는다 — 그게 이 구조의 의도다.

익숙해지면 GitHub Actions 로 옮긴다. 그 전에 손으로 몇 번 해 보는 편이
무엇이 자동화되는지 알게 되어 낫다.

---

## 막혔을 때 보는 순서

| 증상 | 먼저 볼 곳 |
|---|---|
| 앱이 안 뜸 | `journalctl -u moirai -n 50` |
| `Unsupported Database` | Flyway DB 모듈 의존성 |
| `Schema-validation: missing table` | Flyway 가 안 돌았다. DB 접속정보 확인 |
| 앱은 뜨는데 밖에서 안 열림 | 방화벽 두 겹 (2번) |
| 502 Bad Gateway | 앱이 죽었거나 8080 이 아님. `curl 127.0.0.1:8080` |
| `og:url` 이 http | nginx 의 `X-Forwarded-Proto` |
| 인증서 발급 실패 | DNS 가 아직 안 퍼졌거나 80 이 막힘 |
