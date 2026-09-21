package com.dbrlwns.classic.support;

import java.text.Normalizer;
import java.util.Locale;

public final class Slugs {

    private Slugs() {
    }

    /**
     * 제목에서 URL 슬러그를 만든다. 한글은 그대로 두면 URL 인코딩이 지저분해지므로
     * 관리 화면에서 영문 슬러그를 직접 입력하는 것을 기본으로 하고, 이 메서드는 초안용이다.
     */
    public static String from(String raw) {
        if (raw == null || raw.isBlank()) {
            return "";
        }
        String normalized = Normalizer.normalize(raw, Normalizer.Form.NFD)
                .replaceAll("\\p{InCombiningDiacriticalMarks}+", "");
        return normalized.toLowerCase(Locale.ROOT)
                .replaceAll("[^a-z0-9가-힣\\s-]", "")
                .trim()
                .replaceAll("\\s+", "-")
                .replaceAll("-{2,}", "-");
    }
}
