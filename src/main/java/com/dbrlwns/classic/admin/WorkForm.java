package com.dbrlwns.classic.admin;

import com.dbrlwns.classic.work.Work;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public class WorkForm {

    private Long id;

    @NotNull(message = "작곡가를 선택하세요")
    private Long composerId;

    @NotBlank(message = "제목은 필수입니다")
    private String title;

    private String titleOriginal;
    private String catalog;
    private Integer yearComposed;

    @NotBlank(message = "슬러그는 필수입니다")
    private String slug;

    private String summary;
    private String story;
    private boolean published;

    public static WorkForm from(Work work) {
        WorkForm form = new WorkForm();
        form.id = work.getId();
        form.composerId = work.getComposer().getId();
        form.title = work.getTitle();
        form.titleOriginal = work.getTitleOriginal();
        form.catalog = work.getCatalog();
        form.yearComposed = work.getYearComposed();
        form.slug = work.getSlug();
        form.summary = work.getSummary();
        form.story = work.getStory();
        form.published = work.isPublished();
        return form;
    }

    public void applyTo(Work work) {
        work.setTitle(title);
        work.setTitleOriginal(titleOriginal);
        work.setCatalog(catalog);
        work.setYearComposed(yearComposed);
        work.setSlug(slug);
        work.setSummary(summary);
        work.setStory(story);
        work.setPublished(published);
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getComposerId() { return composerId; }
    public void setComposerId(Long composerId) { this.composerId = composerId; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getTitleOriginal() { return titleOriginal; }
    public void setTitleOriginal(String titleOriginal) { this.titleOriginal = titleOriginal; }
    public String getCatalog() { return catalog; }
    public void setCatalog(String catalog) { this.catalog = catalog; }
    public Integer getYearComposed() { return yearComposed; }
    public void setYearComposed(Integer yearComposed) { this.yearComposed = yearComposed; }
    public String getSlug() { return slug; }
    public void setSlug(String slug) { this.slug = slug; }
    public String getSummary() { return summary; }
    public void setSummary(String summary) { this.summary = summary; }
    public String getStory() { return story; }
    public void setStory(String story) { this.story = story; }
    public boolean isPublished() { return published; }
    public void setPublished(boolean published) { this.published = published; }
}
