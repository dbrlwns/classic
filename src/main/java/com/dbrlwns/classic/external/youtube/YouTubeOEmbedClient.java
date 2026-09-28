package com.dbrlwns.classic.external.youtube;

import com.fasterxml.jackson.databind.JsonNode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.client.HttpStatusCodeException;
import org.springframework.web.client.RestClient;

import java.net.URI;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

/**
 * 유튜브 oEmbed 로 제목/채널명/썸네일을 가져온다. API 키가 필요 없다.
 *
 * 주의 1: oEmbed 는 재생 길이를 주지 않는다. 수동 입력이다.
 *
 * 주의 2: oEmbed 가 200 을 준다고 해서 내 사이트에서 재생된다는 뜻은 아니다.
 * 퍼가기 금지 영상도 oEmbed 는 정상 응답한다. 임베드 가능 여부는 등록 화면의
 * 미리보기 플레이어로 사람이 직접 확인해야 한다.
 *
 * 주의 3: 여기서 URI 를 직접 만들어 uri(URI) 로 넘기는 이유가 있다.
 * uri(String) 은 인자를 URI 템플릿으로 보고 한 번 더 인코딩하므로,
 * 이미 퍼센트 인코딩된 문자열을 넘기면 %3A 가 %253A 로 이중 인코딩된다.
 * 그러면 유튜브가 깨진 url 파라미터를 받아 모든 영상에 404 를 준다.
 * uri(URI) 는 템플릿 처리를 건너뛴다. OEmbedUrlEncodingTest 가 이걸 지킨다.
 */
@Component
public class YouTubeOEmbedClient {

    private static final Logger log = LoggerFactory.getLogger(YouTubeOEmbedClient.class);
    private static final String OEMBED_ENDPOINT = "https://www.youtube.com/oembed";

    private final RestClient restClient;

    public YouTubeOEmbedClient(RestClient.Builder builder) {
        this.restClient = builder.build();
    }

    /**
     * 요청 URI 를 만든다. 테스트에서 엔드포인트를 바꿔 끼울 수 있도록 분리했다.
     */
    static URI buildRequestUri(String endpoint, String videoId) {
        String watchUrl = YouTubeUrlParser.watchUrl(videoId);
        return URI.create(endpoint
                + "?url=" + URLEncoder.encode(watchUrl, StandardCharsets.UTF_8)
                + "&format=json");
    }

    public OEmbedLookup fetch(String videoId) {
        URI uri = buildRequestUri(OEMBED_ENDPOINT, videoId);
        try {
            JsonNode body = restClient.get()
                    .uri(uri)          // String 이 아니라 URI. 이중 인코딩 방지
                    .retrieve()
                    .body(JsonNode.class);

            if (body == null) {
                return OEmbedLookup.failed("빈 응답을 받았습니다");
            }
            return OEmbedLookup.found(new YouTubeVideoInfo(
                    videoId,
                    body.path("title").asText(null),
                    body.path("author_name").asText(null),
                    body.path("thumbnail_url").asText(null)
            ));
        } catch (HttpStatusCodeException e) {
            int status = e.getStatusCode().value();
            log.info("oEmbed lookup failed for videoId={}: HTTP {}", videoId, status);
            return OEmbedLookup.failed(describeStatus(status));
        } catch (Exception e) {
            log.info("oEmbed lookup failed for videoId={}: {}", videoId, e.getMessage());
            return OEmbedLookup.failed("유튜브에 연결하지 못했습니다 (" + e.getClass().getSimpleName() + ")");
        }
    }

    private String describeStatus(int status) {
        return switch (status) {
            case 401, 403 -> "유튜브가 정보 제공을 거부했습니다 (HTTP " + status + ")";
            case 404 -> "유튜브에 영상 정보가 없습니다 (연령 제한이나 지역 제한 영상일 수 있습니다)";
            case 429 -> "요청이 너무 많습니다. 잠시 후 다시 시도하세요";
            default -> "정보를 불러오지 못했습니다 (HTTP " + status + ")";
        };
    }
}
