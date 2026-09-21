package com.dbrlwns.classic.admin;

import com.dbrlwns.classic.recording.Recording;
import com.dbrlwns.classic.recording.SourceType;

public class RecordingForm {

    private Long id;
    private Long workId;
    private String performer;
    private SourceType sourceType = SourceType.YOUTUBE;

    /** 유튜브 URL 을 그대로 붙여넣으면 서버에서 영상 ID 를 뽑는다. */
    private String youtubeUrl;

    private String audioUrl;
    private Integer startOffset;
    private Integer endOffset;
    private Integer durationSeconds;
    private boolean isDefault;
    private String license;
    private String sourceUrl;
    private String attribution;
    private boolean available = true;

    public static RecordingForm from(Recording recording) {
        RecordingForm form = new RecordingForm();
        form.id = recording.getId();
        form.workId = recording.getWork().getId();
        form.performer = recording.getPerformer();
        form.sourceType = recording.getSourceType();
        form.youtubeUrl = recording.getYoutubeId();
        form.audioUrl = recording.getAudioUrl();
        form.startOffset = recording.getStartOffset();
        form.endOffset = recording.getEndOffset();
        form.durationSeconds = recording.getDurationSeconds();
        form.isDefault = recording.isDefault();
        form.license = recording.getLicense();
        form.sourceUrl = recording.getSourceUrl();
        form.attribution = recording.getAttribution();
        form.available = recording.isAvailable();
        return form;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getWorkId() { return workId; }
    public void setWorkId(Long workId) { this.workId = workId; }
    public String getPerformer() { return performer; }
    public void setPerformer(String performer) { this.performer = performer; }
    public SourceType getSourceType() { return sourceType; }
    public void setSourceType(SourceType sourceType) { this.sourceType = sourceType; }
    public String getYoutubeUrl() { return youtubeUrl; }
    public void setYoutubeUrl(String youtubeUrl) { this.youtubeUrl = youtubeUrl; }
    public String getAudioUrl() { return audioUrl; }
    public void setAudioUrl(String audioUrl) { this.audioUrl = audioUrl; }
    public Integer getStartOffset() { return startOffset; }
    public void setStartOffset(Integer startOffset) { this.startOffset = startOffset; }
    public Integer getEndOffset() { return endOffset; }
    public void setEndOffset(Integer endOffset) { this.endOffset = endOffset; }
    public Integer getDurationSeconds() { return durationSeconds; }
    public void setDurationSeconds(Integer durationSeconds) { this.durationSeconds = durationSeconds; }
    public boolean isDefault() { return isDefault; }
    public void setDefault(boolean aDefault) { isDefault = aDefault; }
    public String getLicense() { return license; }
    public void setLicense(String license) { this.license = license; }
    public String getSourceUrl() { return sourceUrl; }
    public void setSourceUrl(String sourceUrl) { this.sourceUrl = sourceUrl; }
    public String getAttribution() { return attribution; }
    public void setAttribution(String attribution) { this.attribution = attribution; }
    public boolean isAvailable() { return available; }
    public void setAvailable(boolean available) { this.available = available; }
}
