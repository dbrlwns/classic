# Railway 등 컨테이너 플랫폼용 빌드.
#
# Nixpacks 자동 감지에 맡기지 않고 Dockerfile 을 둔다. 자동 감지는 JDK 버전을
# 알아서 고르는데, 이 프로젝트는 Java 21 이 필요하고 그게 어긋나면 빌드가
# 실패하거나 더 나쁘게는 엉뚱한 버전으로 빌드된다. 명시하는 쪽이 낫다.

# ---------- 1단계: jar 만들기 ----------
FROM eclipse-temurin:21-jdk AS build
WORKDIR /src

# 래퍼와 의존성 정의를 먼저 복사한다. 소스만 바뀌었을 때 의존성 내려받기를
# 다시 하지 않도록 레이어를 쪼개는 것이다.
COPY gradlew settings.gradle build.gradle ./
COPY gradle ./gradle
RUN chmod +x gradlew && ./gradlew dependencies --no-daemon || true

COPY src ./src
# 테스트는 CI 에서 돌린다. 배포 빌드에서 또 돌리면 느리기만 하다.
RUN ./gradlew bootJar --no-daemon -x test

# ---------- 2단계: 실행 ----------
# JDK 가 아니라 JRE 로 띄운다. 컴파일러가 필요 없고 이미지가 작아진다.
FROM eclipse-temurin:21-jre
WORKDIR /app

# root 로 돌리지 않는다.
RUN useradd --system --uid 10001 moirai
USER moirai

COPY --from=build /src/build/libs/*-SNAPSHOT.jar /app/moirai.jar

# 메모리를 비율이 아니라 숫자로 못박는다.
#
# 처음에 MaxRAMPercentage=75 로 뒀는데, 사용량만큼 과금하는 플랫폼에서는
# 위험하다. 컨테이너에 할당된 메모리가 크면 최대 힙도 따라 커지고, JVM 은
# 힙에 여유가 있으면 GC 를 미루며 페이지를 계속 건드린다. 쓰지도 않는
# 메모리에 요금이 붙는다(Railway 기준 RAM $10/GB/월).
#
# 실측: 이 앱은 힙을 384m 로 주나 256m 로 주나 RSS 가 385MB / 377MB 로
# 8MB 밖에 차이 나지 않는다. 대부분이 힙이 아니라 메타스페이스·코드 캐시·
# 스레드 스택 같은 JVM 자체 오버헤드라, 380MB 안팎이 사실상 바닥이다.
# 그래서 여유를 조금 둔 384m 로 고정한다. 더 줄여도 요금이 안 줄고
# OOM 위험만 생긴다.
#
# SerialGC 는 코어가 적고 힙이 작을 때 가장 가볍다. 병렬 GC 는 스레드마다
# 메모리를 더 쓴다.
ENV JAVA_OPTS="-Xmx384m -Xss512k -XX:+UseSerialGC -XX:MaxMetaspaceSize=128m"

# 포트는 플랫폼이 PORT 로 알려준다. EXPOSE 는 문서용일 뿐 실제 바인딩과 무관하다.
EXPOSE 8080

# exec 형태로 띄워야 JVM 이 PID 1 이 되어 SIGTERM 을 직접 받는다.
# sh 를 거치면 종료 신호가 JVM 까지 안 가서 강제 종료될 때까지 기다리게 된다.
ENTRYPOINT ["sh", "-c", "exec java $JAVA_OPTS -jar /app/moirai.jar"]
