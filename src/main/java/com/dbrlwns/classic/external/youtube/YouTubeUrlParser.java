package com.dbrlwns.classic.external.youtube;

import java.util.Optional;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 붙여넣은 유튜브 URL 에서 영상 ID 를 뽑는다.
 * watch?v=, youtu.be/, /embed/, /shorts/, music.youtube.com, 그리고 ID 원문을 지원한다.
 */
public final class YouTubeUrlParser {

    private static final Pattern ID_PATTERN = Pattern.compile("^[A-Za-z0-9_-]{11}$");

    private static final Pattern[] URL_PATTERNS = {
            Pattern.compile("[?&]v=([A-Za-z0-9_-]{11})"),
            Pattern.compile("youtu\\.be/([A-Za-z0-9_-]{11})"),
            Pattern.compile("/embed/([A-Za-z0-9_-]{11})"),
            Pattern.compile("/shorts/([A-Za-z0-9_-]{11})"),
            Pattern.compile("/live/([A-Za-z0-9_-]{11})")
    };

    private YouTubeUrlParser() {
    }

    public static Optional<String> extractVideoId(String input) {
        if (input == null || input.isBlank()) {
            return Optional.empty();
        }
        String trimmed = input.trim();

        if (ID_PATTERN.matcher(trimmed).matches()) {
            return Optional.of(trimmed);
        }
        for (Pattern pattern : URL_PATTERNS) {
            Matcher matcher = pattern.matcher(trimmed);
            if (matcher.find()) {
                return Optional.of(matcher.group(1));
            }
        }
        return Optional.empty();
    }

    /**
     * URL 뒤의 t=90s / start=90 를 시작 지점(초)으로 읽는다.
     */
    public static Optional<Integer> extractStartSeconds(String input) {
        if (input == null || input.isBlank()) {
            return Optional.empty();
        }
        Matcher matcher = Pattern.compile("[?&](?:t|start)=(\\d+)h?(?:(\\d+)m)?(?:(\\d+)s)?").matcher(input);
        if (matcher.find()) {
            return Optional.of(Integer.parseInt(matcher.group(1)));
        }
        return Optional.empty();
    }

    public static String watchUrl(String videoId) {
        return "https://www.youtube.com/watch?v=" + videoId;
    }
}
