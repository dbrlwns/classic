package com.dbrlwns.classic.work;

import com.dbrlwns.classic.recording.Recording;
import com.dbrlwns.classic.support.MarkdownRenderer;
import com.dbrlwns.classic.support.MetaText;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.http.HttpStatus;

import java.security.Principal;
import java.util.List;
import java.util.Optional;

@Controller
public class WorkController {

    private final WorkRepository workRepository;
    private final MarkdownRenderer markdownRenderer;

    public WorkController(WorkRepository workRepository, MarkdownRenderer markdownRenderer) {
        this.workRepository = workRepository;
        this.markdownRenderer = markdownRenderer;
    }

    @GetMapping("/")
    public String home(Model model) {
        model.addAttribute("works", workRepository.findPublishedWithComposer());
        return "works/list";
    }

    /**
     * 곡 상세.
     *
     * 초안(published = false)은 로그인한 관리자에게만 보인다. 그 외에는 404 다.
     *
     * Principal 은 익명 요청에서 null 이다. 스프링 시큐리티가 익명 사용자에게도
     * Authentication 을 붙이지만, HttpServletRequest.getUserPrincipal() 은
     * 익명 토큰을 null 로 돌려주기 때문에 이 판정은 "로그인했는가" 와 같다.
     *
     * 목록 쿼리들은 published = true 로 걸러지므로 초안이 탐색 경로로 새어
     * 나가지는 않는다. 주소를 직접 쳤을 때만, 관리자에게만 열린다.
     */
    @GetMapping("/works/{slug}")
    public String detail(@PathVariable String slug, Principal principal, Model model) {
        Work work = workRepository.findBySlugWithDetails(slug)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "곡을 찾을 수 없습니다"));

        boolean draft = !work.isPublished();
        if (draft && principal == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "아직 공개되지 않은 곡입니다");
        }

        Optional<Recording> recording = work.pickPlayableRecording();

        // 하단의 "이 작곡가의 다른 곡". 많아야 3개까지만 보여준다.
        // 개수 제한을 쿼리가 아니라 여기서 하는 이유는, 페치 조인과 페이징을
        // 같이 쓰면 Hibernate 가 메모리에서 잘라내며 경고를 내기 때문이다.
        List<Work> siblings = workRepository
                .findSiblingsByComposer(work.getComposer().getId(), work.getId())
                .stream()
                .limit(3)
                .toList();

        model.addAttribute("work", work);
        model.addAttribute("draft", draft);
        // 초안 주소가 어쩌다 새어 나가도 검색에는 잡히지 않게 한다.
        // layout 의 head 조각이 이 값을 보고 robots 메타를 넣는다.
        model.addAttribute("noindex", draft);
        model.addAttribute("storyHtml", markdownRenderer.toHtml(work.getStory()));

        // 공유 카드. 한 줄 소개가 있으면 그걸 쓰고, 없으면 스토리 첫머리를 자른다.
        // 둘 다 없으면 MetaAdvice 의 사이트 기본 설명이 그대로 남는다.
        model.addAttribute("ogType", "article");
        model.addAttribute("ogTitle", work.getTitle() + " · " + work.getComposer().getName());
        String description = MetaText.summarize(work.getSummary());
        if (description == null) {
            description = MetaText.summarize(work.getStory());
        }
        if (description != null) {
            model.addAttribute("metaDescription", description);
        }
        model.addAttribute("recording", recording.orElse(null));
        model.addAttribute("siblings", siblings);
        return "works/detail";
    }
}
