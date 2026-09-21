package com.dbrlwns.classic.recording;

import com.dbrlwns.classic.work.Work;
import jakarta.persistence.*;

import java.time.Instant;

/**
 * 한 곡의 특정 연주/음원.
 *
 * 주의: Recording 은 "같은 것의 다른 버전"이다(서로 교체 가능).
 * 악장처럼 "전체의 부분"을 Recording 여러 개로 표현하지 않는다.
 */
@Entity
@Table(name = "recording")
public class Recording {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "work_id", nullable = false)
    private Work work;

    /** "Glenn Gould (1981)" 처럼 연주자와 녹음 연도를 함께 적는다. */
    private String performer;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private SourceType sourceType = SourceType.YOUTUBE;

    /** SourceType.YOUTUBE 일 때의 영상 ID */
    @Column(length = 20)
    private String youtubeId;

    /** SourceType.SELF_HOSTED 일 때의 파일 경로 또는 URL */
    private String audioUrl;

    /** 긴 영상에서 특정 구간만 재생할 때 사용 (초) */
    private Integer startOffset;

    private Integer endOffset;

    /**
     * 재생 길이(초). 지금은 안 쓰더라도 처음부터 채워둔다.
     * 나중에 타임스탬프 주석을 붙일 때 소급 입력하면 고통스럽다.
     */
    private Integer durationSeconds;

    @Column(name = "is_default", nullable = false)
    private boolean isDefault = false;

    /** "Public Domain", "CC BY-SA 4.0", "YouTube 임베드" 등 */
    private String license;

    /** 이 음원을 가져온 곳. 표기 의무를 지키려면 입력 시점에 남겨야 한다. */
    private String sourceUrl;

    /** 표기해야 할 문구가 있으면 여기에 */
    private String attribution;

    /**
     * 재생 가능 여부. 1단계에서는 배치 없이 수동 토글로 쓴다.
     * 영상이 삭제(에러 100)되거나 퍼가기 금지(에러 101/150)면 직접 내린다.
     */
    @Column(nullable = false)
    private boolean available = true;

    @Column(nullable = false)
    private Instant createdAt = Instant.now();

    protected Recording() {
    }

    public Recording(Work work, SourceType sourceType) {
        this.work = work;
        this.sourceType = sourceType;
    }

    public boolean isYoutube() {
        return sourceType == SourceType.YOUTUBE;
    }

    public Long getId() {
        return id;
    }

    public Work getWork() {
        return work;
    }

    public void setWork(Work work) {
        this.work = work;
    }

    public String getPerformer() {
        return performer;
    }

    public void setPerformer(String performer) {
        this.performer = performer;
    }

    public SourceType getSourceType() {
        return sourceType;
    }

    public void setSourceType(SourceType sourceType) {
        this.sourceType = sourceType;
    }

    public String getYoutubeId() {
        return youtubeId;
    }

    public void setYoutubeId(String youtubeId) {
        this.youtubeId = youtubeId;
    }

    public String getAudioUrl() {
        return audioUrl;
    }

    public void setAudioUrl(String audioUrl) {
        this.audioUrl = audioUrl;
    }

    public Integer getStartOffset() {
        return startOffset;
    }

    public void setStartOffset(Integer startOffset) {
        this.startOffset = startOffset;
    }

    public Integer getEndOffset() {
        return endOffset;
    }

    public void setEndOffset(Integer endOffset) {
        this.endOffset = endOffset;
    }

    public Integer getDurationSeconds() {
        return durationSeconds;
    }

    public void setDurationSeconds(Integer durationSeconds) {
        this.durationSeconds = durationSeconds;
    }

    public boolean isDefault() {
        return isDefault;
    }

    public void setDefault(boolean aDefault) {
        isDefault = aDefault;
    }

    public String getLicense() {
        return license;
    }

    public void setLicense(String license) {
        this.license = license;
    }

    public String getSourceUrl() {
        return sourceUrl;
    }

    public void setSourceUrl(String sourceUrl) {
        this.sourceUrl = sourceUrl;
    }

    public String getAttribution() {
        return attribution;
    }

    public void setAttribution(String attribution) {
        this.attribution = attribution;
    }

    public boolean isAvailable() {
        return available;
    }

    public void setAvailable(boolean available) {
        this.available = available;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }
}
