package com.dbrlwns.classic.composer;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface ComposerRepository extends JpaRepository<Composer, Long> {

    Optional<Composer> findBySlug(String slug);

    boolean existsBySlug(String slug);

    /**
     * 수정할 때 쓰는 중복 검사. 자기 자신은 빼고 본다.
     * slug 에 unique 제약이 걸려 있어서, 이 검사 없이 남의 슬러그로 바꾸면
     * 화면에 오류가 뜨는 게 아니라 제약 위반으로 500 이 난다.
     */
    boolean existsBySlugAndIdNot(String slug, Long id);
}
