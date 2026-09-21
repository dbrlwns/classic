package com.dbrlwns.classic.composer;

import com.dbrlwns.classic.support.MarkdownRenderer;
import com.dbrlwns.classic.work.WorkRepository;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.server.ResponseStatusException;

@Controller
public class ComposerController {

    private final ComposerRepository composerRepository;
    private final WorkRepository workRepository;
    private final MarkdownRenderer markdownRenderer;

    public ComposerController(ComposerRepository composerRepository,
                              WorkRepository workRepository,
                              MarkdownRenderer markdownRenderer) {
        this.composerRepository = composerRepository;
        this.workRepository = workRepository;
        this.markdownRenderer = markdownRenderer;
    }

    @GetMapping("/composers")
    public String list(Model model) {
        model.addAttribute("composers", composerRepository.findAll());
        return "composers/list";
    }

    @GetMapping("/composers/{slug}")
    public String detail(@PathVariable String slug, Model model) {
        Composer composer = composerRepository.findBySlug(slug)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "작곡가를 찾을 수 없습니다"));

        model.addAttribute("composer", composer);
        model.addAttribute("bioHtml", markdownRenderer.toHtml(composer.getBio()));
        model.addAttribute("works", workRepository.findPublishedByComposerSlug(slug));
        return "composers/detail";
    }
}
