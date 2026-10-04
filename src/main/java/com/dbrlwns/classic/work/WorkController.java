package com.dbrlwns.classic.work;

import com.dbrlwns.classic.recording.Recording;
import com.dbrlwns.classic.support.MarkdownRenderer;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.http.HttpStatus;

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

    @GetMapping("/works/{slug}")
    public String detail(@PathVariable String slug, Model model) {
        Work work = workRepository.findBySlugWithDetails(slug)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "곡을 찾을 수 없습니다"));

        if (!work.isPublished()) {
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
        model.addAttribute("storyHtml", markdownRenderer.toHtml(work.getStory()));
        model.addAttribute("recording", recording.orElse(null));
        model.addAttribute("siblings", siblings);
        return "works/detail";
    }
}
