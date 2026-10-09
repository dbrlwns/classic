package com.dbrlwns.classic.support;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

/**
 * 모든 화면이 쓰는 공유용 메타 값.
 *
 * <p>og:url 은 설정값이 아니라 <b>지금 들어온 요청</b>에서 뽑는다. 도메인을
 * 따로 적어 둘 필요가 없고, 로컬에서는 localhost 로 운영에서는 실제 주소로
 * 알아서 나온다.
 *
 * <p>프록시 뒤에 배포하면 이 값이 https 가 아니라 http 로 나올 수 있다.
 * 그때는 server.forward-headers-strategy=framework 를 켜서 X-Forwarded-Proto 를
 * 반영하게 한다. 지금은 로컬뿐이라 문제되지 않는다.
 *
 * <p>화면별 설명은 각 컨트롤러가 metaDescription 으로 덮어쓴다.
 * 안 덮으면 아래 기본값이 쓰인다.
 */
@ControllerAdvice
public class MetaAdvice {

    public static final String SITE_NAME = "Moirai";

    public static final String SITE_DESCRIPTION =
            "클래식 한 곡마다 그 곡이 어떻게 태어났는지를 적습니다. "
                    + "퍼블릭 도메인 악곡을 유튜브 음원과 함께 읽고 듣습니다.";

    @ModelAttribute("siteName")
    public String siteName() {
        return SITE_NAME;
    }

    @ModelAttribute("metaDescription")
    public String defaultDescription() {
        return SITE_DESCRIPTION;
    }

    /**
     * 관리 화면과 로그인은 색인될 이유가 없다.
     *
     * <p>화면마다 붙이지 않고 경로로 한 번에 판정한다. 관리 화면이 늘어날 때마다
     * 템플릿에 넣는 걸 깜빡할 자리를 없애기 위해서다.
     *
     * <p>곡 상세의 초안 미리보기처럼 컨트롤러가 직접 값을 넣는 곳은 그쪽이
     * 이긴다. ControllerAdvice 의 @ModelAttribute 가 핸들러보다 먼저 돌기 때문이다.
     */
    @ModelAttribute("noindex")
    public boolean noindex(HttpServletRequest request) {
        if (request == null) {
            return false;
        }
        String path = request.getRequestURI();
        return path.startsWith("/admin") || path.startsWith("/login");
    }

    @ModelAttribute("ogUrl")
    public String ogUrl(HttpServletRequest request) {
        // 정적 리소스나 오류 디스패치처럼 요청이 없을 수 있는 자리를 대비한다.
        if (request == null) {
            return null;
        }
        return ServletUriComponentsBuilder.fromCurrentRequest().build().toUriString();
    }
}
