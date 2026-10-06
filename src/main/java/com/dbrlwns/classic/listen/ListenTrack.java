package com.dbrlwns.classic.listen;

/**
 * 이어 듣기 화면이 브라우저로 넘기는 한 곡.
 *
 * 엔티티를 그대로 내보내지 않는다. 화면이 쓰는 값만 담아야 직렬화 결과가
 * 예측 가능하고, 연관관계를 따라가다 지연 로딩이 터지는 일도 없다.
 */
public record ListenTrack(
        String slug,
        String title,
        String composerName,
        String composerSlug,
        Integer year,
        String catalog,
        String summary,
        String performer,
        String videoId,
        Integer startSeconds,
        Integer endSeconds
) {
}
