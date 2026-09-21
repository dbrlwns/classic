package com.dbrlwns.classic.recording;

/**
 * 음원을 어디서 재생하는가.
 *
 * 저작권 판단을 앱 로직이 아니라 이 필드 하나로 격리한다.
 * YOUTUBE      - 임베드만 한다. 오디오를 서버에 저장하지 않는다.
 * SELF_HOSTED  - 퍼블릭 도메인/CC 음원만. license 와 attribution 을 반드시 채운다.
 */
public enum SourceType {
    YOUTUBE,
    SELF_HOSTED
}
