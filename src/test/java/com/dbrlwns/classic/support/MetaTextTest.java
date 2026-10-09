package com.dbrlwns.classic.support;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * 공유 카드와 검색 결과에 나가는 글이라, 기호가 섞여 나가면 바로 눈에 띈다.
 * 정규식으로 처리하는 부분이라 경계를 테스트로 묶어 둔다.
 */
class MetaTextTest {

    @Test
    @DisplayName("비어 있으면 null — 호출한 쪽이 기본 설명으로 넘어갈 수 있게")
    void blankReturnsNull() {
        assertThat(MetaText.summarize(null)).isNull();
        assertThat(MetaText.summarize("")).isNull();
        assertThat(MetaText.summarize("   \n  ")).isNull();
    }

    @Test
    @DisplayName("Markdown 기호를 걷어낸다")
    void stripsMarkdown() {
        assertThat(MetaText.summarize("**음악이 없는 관현악곡**이라고 했다"))
                .isEqualTo("음악이 없는 관현악곡이라고 했다");
        assertThat(MetaText.summarize("> 인용된 문장"))
                .isEqualTo("인용된 문장");
        assertThat(MetaText.summarize("## 제목"))
                .isEqualTo("제목");
        assertThat(MetaText.summarize("[링크 글자](https://example.com) 뒤"))
                .isEqualTo("링크 글자 뒤");
    }

    @Test
    @DisplayName("줄바꿈과 연속 공백은 한 칸으로 — 메타 태그는 한 줄이어야 한다")
    void collapsesWhitespace() {
        assertThat(MetaText.summarize("첫 문단\n\n둘째   문단"))
                .isEqualTo("첫 문단 둘째 문단");
    }

    @Test
    @DisplayName("한도 안이면 그대로 두고 말줄임표를 붙이지 않는다")
    void shortTextUntouched() {
        assertThat(MetaText.summarize("짧은 소개", 160)).isEqualTo("짧은 소개");
    }

    @Test
    @DisplayName("한도를 넘으면 자르고 말줄임표를 붙인다")
    void truncates() {
        String long5 = "가나다라마 ".repeat(40).trim();   // 240자
        String result = MetaText.summarize(long5, 60);
        assertThat(result).endsWith("…");
        assertThat(result.length()).isLessThanOrEqualTo(61);
    }

    @Test
    @DisplayName("자를 때 단어 중간을 쪼개지 않는다")
    void cutsAtWordBoundary() {
        String text = "라벨은 이 곡을 두고 음악이 없는 관현악곡이라고 했다 그리고 그 말은 사실이었다";
        String result = MetaText.summarize(text, 30);
        assertThat(result).endsWith("…");
        // 잘린 자리 바로 앞이 공백이 아니어야 한다(공백+말줄임표는 보기 나쁘다)
        assertThat(result).doesNotContain(" …");
        // 원문의 앞부분과 이어져야 한다
        assertThat(text).startsWith(result.substring(0, result.length() - 1));
    }

    @Test
    @DisplayName("공백이 거의 없는 긴 글은 글자 수로 자른다")
    void noSpaceFallsBackToLength() {
        String result = MetaText.summarize("가".repeat(300), 50);
        assertThat(result).hasSize(51).endsWith("…");
    }
}
