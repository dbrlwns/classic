package com.dbrlwns.classic.external.youtube;

import com.sun.net.httpserver.HttpServer;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.web.client.RestClient;

import java.net.InetSocketAddress;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.atomic.AtomicReference;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * 회귀 테스트.
 *
 * RestClient.uri(String) 은 인자를 URI 템플릿으로 보고 한 번 더 인코딩한다.
 * 이미 퍼센트 인코딩된 문자열을 그렇게 넘기면 %3A 가 %253A 로 이중 인코딩되고,
 * 유튜브는 깨진 url 파라미터를 받아 모든 영상에 404 를 준다.
 * 실제로 그 버그를 겪었으므로 나가는 요청을 직접 받아서 검증한다.
 */
class OEmbedUrlEncodingTest {

    private static final String VIDEO_ID = "8OZCyp-LcGw";

    private HttpServer server;
    private final AtomicReference<String> receivedUri = new AtomicReference<>();

    @BeforeEach
    void startServer() throws Exception {
        server = HttpServer.create(new InetSocketAddress(0), 0);
        server.createContext("/oembed", exchange -> {
            receivedUri.set(exchange.getRequestURI().toString());
            byte[] body = ("{\"title\":\"제목\",\"author_name\":\"채널\","
                    + "\"thumbnail_url\":\"https://example.test/t.jpg\"}")
                    .getBytes(StandardCharsets.UTF_8);
            exchange.getResponseHeaders().add("Content-Type", "application/json");
            exchange.sendResponseHeaders(200, body.length);
            exchange.getResponseBody().write(body);
            exchange.close();
        });
        server.start();
    }

    @AfterEach
    void stopServer() {
        server.stop(0);
    }

    private String endpoint() {
        return "http://localhost:" + server.getAddress().getPort() + "/oembed";
    }

    @Test
    void 요청_url_파라미터가_이중_인코딩되지_않는다() {
        RestClient client = RestClient.builder().build();

        client.get()
                .uri(YouTubeOEmbedClient.buildRequestUri(endpoint(), VIDEO_ID))
                .retrieve()
                .toBodilessEntity();

        String received = receivedUri.get();

        // %25 가 보이면 퍼센트 기호가 또 인코딩된 것이다
        assertThat(received).doesNotContain("%25");

        // 서버가 디코딩했을 때 원래 watch URL 이 나와야 한다
        String urlParam = received.substring(received.indexOf("url=") + 4, received.indexOf("&format="));
        String decoded = java.net.URLDecoder.decode(urlParam, StandardCharsets.UTF_8);
        assertThat(decoded).isEqualTo("https://www.youtube.com/watch?v=" + VIDEO_ID);
    }

    @Test
    void 잘못된_방식은_이중_인코딩된다() {
        // 왜 uri(URI) 를 써야 하는지 기록으로 남긴다.
        RestClient client = RestClient.builder().build();

        client.get()
                .uri(YouTubeOEmbedClient.buildRequestUri(endpoint(), VIDEO_ID).toString())  // String 으로 넘기면
                .retrieve()
                .toBodilessEntity();

        assertThat(receivedUri.get()).contains("%25");   // 이렇게 깨진다
    }
}
