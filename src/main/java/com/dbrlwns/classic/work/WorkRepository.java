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
     * 메인 목록. 작곡 연도순으로 준다.
     *
     * 등록순이었을 때는 지금 우연히 바흐-모차르트-베토벤 순으로 보일 뿐,
     * 곡을 추가하면 섞인다. 연도순으로 놓으면 목록을 훑는 것만으로
     * 시대가 흐르고, 작곡가 페이지의 정렬과도 일관된다.
     * 연도를 모르는 곡은 뒤로 보내고 제목순으로 묶는다.
     *
     * 카드마다 대표 음원의 썸네일을 띄우므로 recordings 까지 끌어온다.
     * 여기서 빠뜨리면 뷰를 그릴 때 LazyInitializationException 이다.
     */
    @Query("select distinct w from Work w join fetch w.composer left join fetch w.recordings "
            + "where w.published = true "
            + "order by w.yearComposed asc nulls last, w.title asc")
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

    /**
     * 작곡가의 곡을 작곡 연도순으로 준다.
     *
     * 제목 가나다순은 아무 의미가 없는 순서였다. 연도순으로 놓으면 그 작곡가가
     * 어떻게 변해갔는지가 목록 자체로 읽힌다.
     * 연도를 모르는 곡은 뒤로 보내고 제목순으로 묶는다.
     */
    @Query("select distinct w from Work w join fetch w.composer left join fetch w.recordings "
            + "where w.composer.slug = :slug and w.published = true "
            + "order by w.yearComposed asc nulls last, w.title asc")
    List<Work> findPublishedByComposerSlug(String slug);

    /**
     * 곡 상세 하단의 "이 작곡가의 다른 곡".
     *
     * 이전/다음 대신 같은 작곡가의 곡을 묶어 보여준다. 제목순의 이전/다음은
     * 자의적인 순서라 "다음 곡"에 필연성이 없는 반면, "같은 작곡가"는
     * 묶음의 이유가 분명하다.
     *
     * 개수 제한은 호출하는 쪽에서 한다. 페치 조인과 페이징을 같이 쓰면
     * Hibernate 가 메모리에서 잘라내며 경고를 낸다.
     */
    @Query("select distinct w from Work w join fetch w.composer left join fetch w.recordings "
            + "where w.composer.id = :composerId and w.id <> :excludeWorkId and w.published = true "
            + "order by w.yearComposed asc nulls last, w.title asc")
    List<Work> findSiblingsByComposer(Long composerId, Long excludeWorkId);
}
