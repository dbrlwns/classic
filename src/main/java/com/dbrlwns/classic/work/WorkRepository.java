package com.dbrlwns.classic.work;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface WorkRepository extends JpaRepository<Work, Long> {

    Optional<Work> findBySlug(String slug);

    /**
     * open-in-view: false 이므로 뷰를 그릴 때는 이미 영속성 컨텍스트가 닫혀 있다.
     * 화면에서 쓰는 연관관계는 조회 시점에 모두 끌어와야 한다.
     */
    @Query("select distinct w from Work w join fetch w.composer left join fetch w.recordings where w.slug = :slug")
    Optional<Work> findBySlugWithDetails(String slug);

    @Query("select distinct w from Work w join fetch w.composer left join fetch w.recordings where w.id = :id")
    Optional<Work> findByIdWithDetails(Long id);

    boolean existsBySlug(String slug);

    /**
     * 목록 화면은 카드마다 대표 음원의 썸네일을 띄우므로 recordings 까지 끌어온다.
     * 여기서 빠뜨리면 뷰를 그릴 때 LazyInitializationException 이다.
     */
    @Query("select distinct w from Work w join fetch w.composer left join fetch w.recordings "
            + "where w.published = true order by w.createdAt desc")
    List<Work> findPublishedWithComposer();

    @Query("select w from Work w join fetch w.composer order by w.createdAt desc")
    List<Work> findAllWithComposer();

    /**
     * 관리 대시보드용. 음원의 영상 ID 를 표에 뿌려서 data.sql 로 옮겨 적을 수 있게 한다.
     * create-drop 이라 재시작하면 관리 화면에서 넣은 음원은 사라지므로,
     * 지우기 전에 ID 를 회수할 창구가 필요하다.
     */
    @Query("select distinct w from Work w join fetch w.composer left join fetch w.recordings "
            + "order by w.createdAt desc")
    List<Work> findAllWithDetails();

    @Query("select distinct w from Work w join fetch w.composer left join fetch w.recordings "
            + "where w.composer.slug = :slug and w.published = true order by w.title asc")
    List<Work> findPublishedByComposerSlug(String slug);
}
