package com.dbrlwns.classic.external.youtube;

/**
 * oEmbed 조회 결과. 실패 이유를 같이 들고 다닌다.
 *
 * 예전에는 Optional.empty() 만 돌려줘서 화면이 "삭제되었거나 비공개"라고
 * 단정해 버렸다. 실제로는 타임아웃인지 404인지 알 수 없는 상태였고,
 * 정작 원인은 우리 쪽 URL 인코딩 버그였다. 이유를 끝까지 들고 간다.
 */
public record OEmbedLookup(YouTubeVideoInfo info, String failureReason) {

    public static OEmbedLookup found(YouTubeVideoInfo info) {
        return new OEmbedLookup(info, null);
    }

    public static OEmbedLookup failed(String reason) {
        return new OEmbedLookup(null, reason);
    }

    public boolean isFound() {
        return info != null;
    }
}
