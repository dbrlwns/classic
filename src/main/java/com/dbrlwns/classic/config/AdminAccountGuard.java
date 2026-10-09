package com.dbrlwns.classic.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;

/**
 * 운영에서 개발용 기본 비밀번호로 뜨는 것을 막는다.
 *
 * <p>application.yml 의 {@code ${ADMIN_PASSWORD:admin}} 은 로컬에서 편하라고 둔
 * 것이다. 운영 프로파일은 기본값 없는 {@code ${ADMIN_PASSWORD}} 로 덮지만,
 * 누군가 환경변수에 그냥 "admin" 을 넣어 버리면 그 방어는 통과한다.
 * 그 경우를 여기서 끊는다.
 *
 * <p>prod 프로파일에서만 동작한다. 로컬에서는 admin/admin 이 그대로 편하다.
 */
@Configuration
@Profile("prod")
public class AdminAccountGuard {

    private static final String DEV_DEFAULT = "admin";

    public AdminAccountGuard(AdminAccountProperties properties) {
        if (DEV_DEFAULT.equals(properties.password())) {
            throw new IllegalStateException(
                    "운영에서는 개발용 기본 비밀번호를 쓸 수 없습니다. ADMIN_PASSWORD 를 다른 값으로 설정하세요.");
        }
    }
}
