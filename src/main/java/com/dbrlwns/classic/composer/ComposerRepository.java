package com.dbrlwns.classic.composer;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface ComposerRepository extends JpaRepository<Composer, Long> {

    Optional<Composer> findBySlug(String slug);

    boolean existsBySlug(String slug);
}
