package com.dbrlwns.classic.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * 1인 운영이므로 회원가입이 없다. 관리자 계정 하나를 설정값으로 받는다.
 *
 * <p>값이 제대로 들어왔는지 여기서 검사한다. 스프링 부트가 대신 해 주지 않기
 * 때문이다. {@code @ConfigurationProperties} 바인딩은 풀리지 않은 자리표시자를
 * 오류로 보지 않고 <b>글자 그대로 통과시킨다</b>. 그래서 운영 설정에
 * {@code password: ${ADMIN_PASSWORD}} 라고 적어 두고 환경변수를 빠뜨리면,
 * 부팅이 실패하는 대신 비밀번호가 문자열 "${ADMIN_PASSWORD}" 가 된다.
 *
 * <p>실제로 그렇게 떴고, 그 문자열로 로그인까지 됐다. 설정 파일은 깃에 들어가므로
 * 저장소를 읽을 수 있는 사람은 누구나 그 비밀번호를 안다. 기본값으로 뜨는 것보다
 * 더 나쁘다 — 겉보기에는 안전해 보이기 때문이다.
 */
@ConfigurationProperties(prefix = "app.admin")
public record AdminAccountProperties(String username, String password) {

    public AdminAccountProperties {
        requireResolved("app.admin.username", username);
        requireResolved("app.admin.password", password);
    }

    private static void requireResolved(String key, String value) {
        if (value == null || value.isBlank()) {
            throw new IllegalStateException(key + " 가 비어 있습니다.");
        }
        // "${...}" 가 남아 있다는 것은 환경변수가 없어 치환되지 않았다는 뜻이다.
        if (value.contains("${")) {
            throw new IllegalStateException(
                    key + " 의 환경변수가 설정되지 않았습니다. 값이 치환되지 않고 그대로 남아 있습니다: "
                            + value + " — 이대로 두면 이 문자열이 곧 비밀번호가 됩니다.");
        }
    }
}
