package com.dbrlwns.classic.composer;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;

@Entity
@Table(name = "composer")
public class Composer {

    /**
     * 한국 저작권법상 저작재산권은 사후 70년이지만, 2013-07-01 개정 이전에
     * 이미 만료된 저작물은 보호가 부활하지 않는다. 구법(50년) 기준으로
     * 1962년 말 이전에 사망한 작곡가의 작품은 이미 만료된 상태이므로
     * 퍼블릭 도메인으로 본다.
     */
    public static final int PUBLIC_DOMAIN_DEATH_YEAR_THRESHOLD = 1962;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank
    @Column(nullable = false)
    private String name;

    private String nameEn;

    @NotBlank
    @Column(nullable = false, unique = true)
    private String slug;

    private Integer bornYear;

    private Integer diedYear;

    @Column(columnDefinition = "TEXT")
    private String bio;

    protected Composer() {
    }

    public Composer(String name, String nameEn, String slug, Integer bornYear, Integer diedYear, String bio) {
        this.name = name;
        this.nameEn = nameEn;
        this.slug = slug;
        this.bornYear = bornYear;
        this.diedYear = diedYear;
        this.bio = bio;
    }

    /**
     * 작곡(악곡) 자체가 퍼블릭 도메인인지 여부. 음원(녹음)의 저작인접권은 별개다.
     */
    public boolean isPublicDomain() {
        return diedYear != null && diedYear <= PUBLIC_DOMAIN_DEATH_YEAR_THRESHOLD;
    }

    public String getLifespan() {
        if (bornYear == null && diedYear == null) {
            return "";
        }
        return (bornYear == null ? "?" : bornYear) + "–" + (diedYear == null ? "" : diedYear);
    }

    public Long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getNameEn() {
        return nameEn;
    }

    public void setNameEn(String nameEn) {
        this.nameEn = nameEn;
    }

    public String getSlug() {
        return slug;
    }

    public void setSlug(String slug) {
        this.slug = slug;
    }

    public Integer getBornYear() {
        return bornYear;
    }

    public void setBornYear(Integer bornYear) {
        this.bornYear = bornYear;
    }

    public Integer getDiedYear() {
        return diedYear;
    }

    public void setDiedYear(Integer diedYear) {
        this.diedYear = diedYear;
    }

    public String getBio() {
        return bio;
    }

    public void setBio(String bio) {
        this.bio = bio;
    }
}
