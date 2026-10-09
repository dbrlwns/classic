package com.dbrlwns.classic.admin;

import com.dbrlwns.classic.composer.Composer;
import com.dbrlwns.classic.composer.ComposerRepository;
import com.dbrlwns.classic.recording.Recording;
import com.dbrlwns.classic.work.Work;
import com.dbrlwns.classic.work.WorkRepository;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminController {

    private final ComposerRepository composerRepository;
    private final WorkRepository workRepository;

    public AdminController(ComposerRepository composerRepository, WorkRepository workRepository) {
        this.composerRepository = composerRepository;
        this.workRepository = workRepository;
    }

    @GetMapping
    public String dashboard(Model model) {
        List<Work> works = workRepository.findAllWithDetails();

        // 재시작하면(create-drop) 관리 화면에서 넣은 음원은 사라진다.
        // 지우기 전에 영상 ID 를 data.sql 로 옮겨 적을 수 있도록 한데 모아 보여준다.
        List<Recording> youtubeRecordings = works.stream()
                .flatMap(work -> work.getRecordings().stream())
                .filter(Recording::isYoutube)
                .filter(recording -> recording.getYoutubeId() != null)
                .toList();

        model.addAttribute("composerCount", composerRepository.count());
        model.addAttribute("works", works);
        model.addAttribute("youtubeRecordings", youtubeRecordings);
        return "admin/dashboard";
    }

    // ---------- 작곡가 ----------

    @GetMapping("/composers")
    public String composerList(Model model) {
        model.addAttribute("composers", composerRepository.findAll());
        return "admin/composer-list";
    }

    @GetMapping("/composers/new")
    public String composerNew(Model model) {
        model.addAttribute("form", new ComposerForm());
        return "admin/composer-form";
    }

    @GetMapping("/composers/{id}/edit")
    public String composerEdit(@PathVariable Long id, Model model) {
        Composer composer = composerRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));
        model.addAttribute("form", ComposerForm.from(composer));
        return "admin/composer-form";
    }

    @PostMapping("/composers/save")
    public String composerSave(@Valid @ModelAttribute("form") ComposerForm form,
                               BindingResult bindingResult,
                               RedirectAttributes redirectAttributes) {
        // 추가할 때는 전부와, 수정할 때는 자기 자신을 뺀 나머지와 비교한다.
        boolean slugTaken = form.getId() == null
                ? composerRepository.existsBySlug(form.getSlug())
                : composerRepository.existsBySlugAndIdNot(form.getSlug(), form.getId());
        if (slugTaken) {
            bindingResult.rejectValue("slug", "duplicate", "이미 쓰고 있는 슬러그입니다");
        }
        if (bindingResult.hasErrors()) {
            return "admin/composer-form";
        }

        if (form.getId() == null) {
            composerRepository.save(form.toNewComposer());
        } else {
            Composer composer = composerRepository.findById(form.getId())
                    .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));
            form.applyTo(composer);
            composerRepository.save(composer);
        }
        redirectAttributes.addFlashAttribute("message", "작곡가를 저장했습니다");
        return "redirect:/admin/composers";
    }

    // ---------- 곡 ----------

    @GetMapping("/works/new")
    public String workNew(Model model) {
        model.addAttribute("form", new WorkForm());
        model.addAttribute("composers", composerRepository.findAll());
        return "admin/work-form";
    }

    @GetMapping("/works/{id}/edit")
    public String workEdit(@PathVariable Long id, Model model) {
        Work work = workRepository.findByIdWithDetails(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));
        model.addAttribute("form", WorkForm.from(work));
        model.addAttribute("composers", composerRepository.findAll());
        model.addAttribute("work", work);
        model.addAttribute("recordings", work.getRecordings());
        return "admin/work-form";
    }

    @PostMapping("/works/save")
    public String workSave(@Valid @ModelAttribute("form") WorkForm form,
                           BindingResult bindingResult,
                           Model model,
                           RedirectAttributes redirectAttributes) {
        boolean slugTaken = form.getId() == null
                ? workRepository.existsBySlug(form.getSlug())
                : workRepository.existsBySlugAndIdNot(form.getSlug(), form.getId());
        if (slugTaken) {
            bindingResult.rejectValue("slug", "duplicate", "이미 쓰고 있는 슬러그입니다");
        }
        if (bindingResult.hasErrors()) {
            model.addAttribute("composers", composerRepository.findAll());
            // 수정 중에 걸렸다면 아래 음원 목록도 같이 돌려줘야 한다.
            // 이걸 빼면 오류 메시지는 뜨는데 붙여 둔 음원이 사라진 것처럼 보인다.
            if (form.getId() != null) {
                workRepository.findByIdWithDetails(form.getId()).ifPresent(existing -> {
                    model.addAttribute("work", existing);
                    model.addAttribute("recordings", existing.getRecordings());
                });
            }
            return "admin/work-form";
        }

        Work work;
        if (form.getId() == null) {
            Composer composer = composerRepository.findById(form.getComposerId())
                    .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "작곡가를 찾을 수 없습니다"));
            work = new Work(composer, form.getTitle(), form.getSlug());
        } else {
            work = workRepository.findById(form.getId())
                    .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));
            if (!work.getComposer().getId().equals(form.getComposerId())) {
                work.setComposer(composerRepository.findById(form.getComposerId())
                        .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST)));
            }
        }
        form.applyTo(work);
        Work saved = workRepository.save(work);

        redirectAttributes.addFlashAttribute("message", "곡을 저장했습니다");
        return "redirect:/admin/works/" + saved.getId() + "/edit";
    }

    @PostMapping("/works/{id}/delete")
    public String workDelete(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        workRepository.deleteById(id);
        redirectAttributes.addFlashAttribute("message", "곡을 삭제했습니다");
        return "redirect:/admin";
    }
}
