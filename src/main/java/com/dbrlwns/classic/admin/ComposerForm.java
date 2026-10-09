package com.dbrlwns.classic.admin;

import com.dbrlwns.classic.composer.Composer;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;

public class ComposerForm {

    private Long id;

    @NotBlank(message = "이름은 필수입니다")
    private String name;

    private String nameEn;

    /*
     * 슬러그는 URL 의 일부다. 공백이나 한글, 슬래시가 들어가면 그 페이지는
     * 열리지 않는다(슬래시는 경로로 해석되어 400 이 난다). 저장은 되는데
     * 페이지만 조용히 죽으므로, 들어오기 전에 막는다.
     *
     * 소문자·숫자 덩어리를 하이픈으로 이은 형태만 받는다.
     * 하이픈으로 시작하거나 끝나는 것, 하이픈이 연달아 오는 것도 걸러진다.
     */
    @NotBlank(message = "슬러그는 필수입니다")
    @Pattern(regexp = "^[a-z0-9]+(?:-[a-z0-9]+)*$",
             message = "영문 소문자, 숫자, 하이픈만 쓸 수 있습니다 (예: clair-de-lune)")
    private String slug;

    private Integer bornYear;
    private Integer diedYear;
    private String bio;

    public static ComposerForm from(Composer composer) {
        ComposerForm form = new ComposerForm();
        form.id = composer.getId();
        form.name = composer.getName();
        form.nameEn = composer.getNameEn();
        form.slug = composer.getSlug();
        form.bornYear = composer.getBornYear();
        form.diedYear = composer.getDiedYear();
        form.bio = composer.getBio();
        return form;
    }

    public void applyTo(Composer composer) {
        composer.setName(name);
        composer.setNameEn(nameEn);
        composer.setSlug(slug);
        composer.setBornYear(bornYear);
        composer.setDiedYear(diedYear);
        composer.setBio(bio);
    }

    public Composer toNewComposer() {
        return new Composer(name, nameEn, slug, bornYear, diedYear, bio);
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getNameEn() { return nameEn; }
    public void setNameEn(String nameEn) { this.nameEn = nameEn; }
    public String getSlug() { return slug; }
    public void setSlug(String slug) { this.slug = slug; }
    public Integer getBornYear() { return bornYear; }
    public void setBornYear(Integer bornYear) { this.bornYear = bornYear; }
    public Integer getDiedYear() { return diedYear; }
    public void setDiedYear(Integer diedYear) { this.diedYear = diedYear; }
    public String getBio() { return bio; }
    public void setBio(String bio) { this.bio = bio; }
}
