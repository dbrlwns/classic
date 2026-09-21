package com.dbrlwns.classic.external.youtube;

/**
 * oEmbed 응답에서 실제로 쓰는 것만 담는다. oEmbed 는 재생 길이를 주지 않는다.
 */
public record YouTubeVideoInfo(
        String videoId,
        String title,
        String authorName,
        String thumbnailUrl
) {
}
