package com.dbrlwns.classic.external.youtube;

import com.fasterxml.jackson.databind.JsonNode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Optional;

/**
 * 유튜브 oEmbed 로 제목/채널명/썸네일을 가져온다. API 키가 필요 없다.
 *
 * 주의: oEmbed 가 200 을 준다고 해서 내 사이트에서 재생된다는 뜻은 아니다.
 * 퍼가기 금지 영상도 oEmbed 는 정상 응답한다. 임베드 가능 여부는 등록 화면의
 * 미리보기 플레이어로 사람이 직접 확인해야 한다.
 */
@Component
public class YouTubeOEmbedClient {

    private static final Logger log = LoggerFactory.getLogger(YouTubeOEmbedClient.class);
    private static final String OEMBED_ENDPOINT = "https://www.youtube.com/oembed";

    private final RestClient restClient;

    public YouTubeOEmbedClient(RestClient.Builder builder) {
        this.restClient = builder.build();
    }

    public Optional<YouTubeVideoInfo> fetch(String videoId) {
        String watchUrl = YouTubeUrlParser.watchUrl(videoId);
        String requestUrl = OEMBED_ENDPOINT
                + "?url=" + URLEncoder.encode(watchUrl, StandardCharsets.UTF_8)
                + "&format=json";
        try {
            JsonNode body = restClient.get()
                    .uri(requestUrl)
                    .retrieve()
                    .body(JsonNode.class);

            if (body == null) {
                return Optional.empty();
            }
            return Optional.of(new YouTubeVideoInfo(
                    videoId,
                    body.path("title").asText(null),
                    body.path("author_name").asText(null),
                    body.path("thumbnail_url").asText(null)
            ));
        } catch (Exception e) {
            // 영상이 없거나 비공개면 404 가 온다. 등록 자체를 막지는 않는다.
            log.info("oEmbed lookup failed for videoId={}: {}", videoId, e.getMessage());
            return Optional.empty();
        }
    }
}
