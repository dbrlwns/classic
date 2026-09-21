package com.dbrlwns.classic.admin;

import com.dbrlwns.classic.composer.Composer;
import jakarta.validation.constraints.NotBlank;

public class ComposerForm {

    private Long id;

    @NotBlank(message = "이름은 필수입니다")
    private String name;

    private String nameEn;

    @NotBlank(message = "슬러그는 필수입니다")
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
