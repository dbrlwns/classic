package com.dbrlwns.classic.work;

import com.dbrlwns.classic.composer.Composer;
import com.dbrlwns.classic.recording.Recording;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;

import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * 곡(악곡). 스토리가 붙는 단위이며 저작권 판정의 단위이기도 하다.
 *
 * 다악장 작품은 1단계에서 다루지 않는다. "월광 소나타 1악장"처럼 악장 자체를
 * 하나의 Work로 등록한다. 전곡 묶음이 필요해지면 Movement 테이블이 아니라
 * Work 에 parentWork self FK 를 추가하는 방향으로 확장한다.
 */
@Entity
@Table(name = "work")
public class Work {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "composer_id", nullable = false)
    private Composer composer;

    @NotBlank
    @Column(nullable = false)
    private String title;

    /** 원어 제목. "Clair de lune", "Gymnopédie No.1" */
    private String titleOriginal;

    /** 작품 번호. "BWV 988", "Op. 27 No. 2" */
    private String catalog;

    private Integer yearComposed;

    @NotBlank
    @Column(nullable = false, unique = true)
    private String slug;

    /** 목록 카드에 쓰는 한 줄 소개 */
    @Column(length = 500)
    private String summary;

    /** 본문. Markdown 원문을 그대로 저장하고 렌더링은 읽을 때 한다. */
    @Column(columnDefinition = "TEXT")
    private String story;

    @Column(nullable = false)
    private boolean published = false;

    @Column(nullable = false)
    private Instant createdAt = Instant.now();

    private Instant updatedAt;

    @OneToMany(mappedBy = "work", cascade = CascadeType.ALL, orphanRemoval = true)
    @OrderBy("isDefault DESC, id ASC")
    private List<Recording> recordings = new ArrayList<>();

    protected Work() {
    }

    public Work(Composer composer, String title, String slug) {
        this.composer = composer;
        this.title = title;
        this.slug = slug;
    }

    /**
     * 화면에 노출할 음원. 1단계에서는 대표 음원 하나만 보여주고 나머지는 백업으로 둔다.
     * 대표가 없거나 재생 불가 상태이면 재생 가능한 다른 음원으로 넘어간다.
     */
    public Optional<Recording> pickPlayableRecording() {
        return recordings.stream()
                .filter(Recording::isAvailable)
                .filter(Recording::isDefault)
                .findFirst()
                .or(() -> recordings.stream().filter(Recording::isAvailable).findFirst());
    }

    public void addRecording(Recording recording) {
        recordings.add(recording);
        recording.setWork(this);
    }

    @PreUpdate
    void onUpdate() {
        this.updatedAt = Instant.now();
    }

    public Long getId() {
        return id;
    }

    public Composer getComposer() {
        return composer;
    }

    public void setComposer(Composer composer) {
        this.composer = composer;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getTitleOriginal() {
        return titleOriginal;
    }

    public void setTitleOriginal(String titleOriginal) {
        this.titleOriginal = titleOriginal;
    }

    public String getCatalog() {
        return catalog;
    }

    public void setCatalog(String catalog) {
        this.catalog = catalog;
    }

    public Integer getYearComposed() {
        return yearComposed;
    }

    public void setYearComposed(Integer yearComposed) {
        this.yearComposed = yearComposed;
    }

    public String getSlug() {
        return slug;
    }

    public void setSlug(String slug) {
        this.slug = slug;
    }

    public String getSummary() {
        return summary;
    }

    public void setSummary(String summary) {
        this.summary = summary;
    }

    public String getStory() {
        return story;
    }

    public void setStory(String story) {
        this.story = story;
    }

    public boolean isPublished() {
        return published;
    }

    public void setPublished(boolean published) {
        this.published = published;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }

    public Instant getUpdatedAt() {
        return updatedAt;
    }

    public List<Recording> getRecordings() {
        return recordings;
    }
}
