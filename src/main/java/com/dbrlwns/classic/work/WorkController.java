package com.dbrlwns.classic.work;

import com.dbrlwns.classic.recording.Recording;
import com.dbrlwns.classic.support.MarkdownRenderer;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.http.HttpStatus;

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

        model.addAttribute("work", work);
        model.addAttribute("storyHtml", markdownRenderer.toHtml(work.getStory()));
        model.addAttribute("recording", recording.orElse(null));
        return "works/detail";
    }
}
