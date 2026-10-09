package com.dbrlwns.classic.support;

/**
 * 공유 카드와 검색 결과에 쓸 한 토막 설명을 만든다.
 *
 * <p>원문은 Markdown 이다. 그대로 쓰면 {@code **강조**} 나 {@code >} 같은 기호가
 * 검색 결과에 그대로 노출된다. 완전한 Markdown 파서를 돌릴 자리는 아니고,
 * 글 첫머리에 실제로 나오는 기호만 걷어내면 충분하다.
 */
public final class MetaText {

    /** 구글이 검색 결과에 보여주는 길이가 대략 여기까지다. */
    public static final int DEFAULT_LIMIT = 160;

    private MetaText() {
    }

    public static String summarize(String markdown, int limit) {
        if (markdown == null || markdown.isBlank()) {
            return null;
        }

        String text = markdown
                // 인용부호와 제목 표시는 줄 맨 앞에서만 의미가 있다
                .replaceAll("(?m)^\\s*[>#]+\\s*", "")
                // **강조** _기울임_ `코드`
                .replaceAll("[*_`]", "")
                // [글자](주소) 에서 글자만 남긴다
                .replaceAll("\\[([^\\]]*)]\\([^)]*\\)", "$1")
                // 줄바꿈과 연속 공백을 한 칸으로
                .replaceAll("\\s+", " ")
                .trim();

        if (text.isEmpty()) {
            return null;
        }
        if (text.length() <= limit) {
            return text;
        }

        // 단어 중간에서 자르지 않는다. 한글은 띄어쓰기 단위가 크므로
        // 마지막 공백이 너무 앞이면 그냥 글자 수로 자른다.
        String cut = text.substring(0, limit);
        int lastSpace = cut.lastIndexOf(' ');
        if (lastSpace > limit * 2 / 3) {
            cut = cut.substring(0, lastSpace);
        }
        return cut.stripTrailing() + "…";
    }

    public static String summarize(String markdown) {
        return summarize(markdown, DEFAULT_LIMIT);
    }
}
