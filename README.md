# Cadenza

클래식 곡에 얽힌 이야기를 읽고, 그 자리에서 곡을 듣는 서비스.

제품 정의와 설계 근거는 **[docs/concept.md](docs/concept.md)** 에 있습니다.
설계 결정을 바꾸기 전에 먼저 읽으세요.

## 요구사항

**JDK 21.** 없으면 `./gradlew` 가 이렇게 멈춥니다.

```
Cannot find a Java installation on your machine ... matching: {languageVersion=21, ...}
```

macOS 기준 설치:

```bash
brew install --cask temurin@21
/usr/libexec/java_home -V          # 설치 확인
```

`settings.gradle` 에 foojay toolchain resolver 를 넣어둬서 JDK 21 이 없으면
Gradle 이 직접 받아오기는 합니다. 다만 그건 Gradle 전용이라 IDE 는 따로
JDK 를 찾으므로, IntelliJ 등에서 열 거면 위처럼 설치해 두는 편이 낫습니다.

## 실행

```bash
./gradlew bootRun
```

- 사이트: http://localhost:8080
- 관리: http://localhost:8080/admin (기본 `admin` / `admin`)
- H2 콘솔: http://localhost:8080/h2-console (JDBC URL `jdbc:h2:mem:classic`)

관리자 계정은 환경변수로 바꿉니다.

```bash
ADMIN_USERNAME=... ADMIN_PASSWORD=... ./gradlew bootRun
```

## 첫 실행 후 해볼 것

샘플로 드뷔시와 사티, 곡 2개가 들어갑니다. **음원은 일부러 비어 있습니다.**
유튜브 URL 을 붙여넣고 미리보기로 확인하는 흐름이 이 앱의 핵심 작업이라, 직접 한 번 지나가 보는 게 낫습니다.

1. `/admin` 로그인
2. 곡 하나를 열어 **음원 추가**
3. 공식 채널의 유튜브 URL 을 붙여넣고 **정보 불러오기 · 미리보기**
4. 미리보기에서 **실제로 재생되는지 확인** — oEmbed 가 응답해도 퍼가기 금지(101/150)일 수 있습니다
5. 저장하고 `/works/<slug>` 에서 읽으며 듣기

## 구조

```
com/dbrlwns/classic/
├─ composer/          작곡가
├─ work/              곡 (스토리가 붙는 단위)
├─ recording/         음원 (YOUTUBE 임베드 / SELF_HOSTED)
├─ external/youtube/  oEmbed 연동, URL 파서
├─ admin/             콘텐츠 입력 화면 (Spring 에는 Django admin 이 없다)
├─ support/           Markdown 렌더러, 슬러그
└─ config/            보안, 샘플 데이터
```

`src/main/resources/static/js/player.js` 는 유튜브 iframe 과 `<audio>` 를
같은 인터페이스로 감싼 어댑터입니다. 지금은 재생만 쓰지만
`getCurrentTime()` / `seek()` 가 노출돼 있어, 나중에 타임스탬프 주석을 붙일 때
플레이어 코드를 다시 쓰지 않아도 됩니다.

## 저작권 방침 (요약)

악곡과 음원은 **별개의 권리**입니다.

- 악곡: 1962년 말 이전 사망 작곡가는 퍼블릭 도메인
- 음원: 연주·음반 권리가 따로 붙음. **악곡이 PD 라도 상업 녹음은 호스팅 금지**
- 상업 녹음과 보호 중인 곡은 **유튜브 공식 채널 임베드만**
- 오디오를 추출해 서버에 저장하지 않음
- 스토리 본문은 사실만 참고해 직접 작성 (라이너 노트·평론은 보호 대상)

자세한 근거는 [docs/concept.md](docs/concept.md#저작권-구조--설계의-전제) 참고.

## 스키마 관리

`ddl-auto: update` 는 쓰지 않습니다. 컬럼을 추가만 하고 rename/삭제/타입변경을
반영하지 않아 스키마가 조용히 썩습니다. 이 프로젝트는 **스토리 원고가 DB에만 존재**하므로
특히 위험합니다.

- 개발 중 (현재): `create-drop`
- 진짜 콘텐츠를 넣는 날부터: Flyway + `ddl-auto: validate` (`application-prod.yml`)
