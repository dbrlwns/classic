package com.dbrlwns.classic.admin;

import com.dbrlwns.classic.external.youtube.YouTubeOEmbedClient;
import com.dbrlwns.classic.external.youtube.YouTubeUrlParser;
import com.dbrlwns.classic.external.youtube.YouTubeVideoInfo;
import com.dbrlwns.classic.recording.Recording;
import com.dbrlwns.classic.recording.RecordingRepository;
import com.dbrlwns.classic.recording.SourceType;
import com.dbrlwns.classic.work.Work;
import com.dbrlwns.classic.work.WorkRepository;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Map;
import java.util.Optional;

@Controller
@RequestMapping("/admin")
public class RecordingAdminController {

    private final WorkRepository workRepository;
    private final RecordingRepository recordingRepository;
    private final YouTubeOEmbedClient oEmbedClient;

    public RecordingAdminController(WorkRepository workRepository,
                                    RecordingRepository recordingRepository,
                                    YouTubeOEmbedClient oEmbedClient) {
        this.workRepository = workRepository;
        this.recordingRepository = recordingRepository;
        this.oEmbedClient = oEmbedClient;
    }

    /**
     * 등록 화면에서 URL 을 붙여넣는 순간 제목/채널/썸네일을 채워주기 위한 엔드포인트.
     * 응답이 와도 임베드 가능 여부는 알 수 없으므로 화면에서 미리보기로 확인해야 한다.
     */
    @GetMapping("/youtube/lookup")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> lookup(@RequestParam String url) {
        Optional<String> videoId = YouTubeUrlParser.extractVideoId(url);
        if (videoId.isEmpty()) {
            return ResponseEntity.badRequest().body(Map.of("error", "유튜브 URL 에서 영상 ID를 찾지 못했습니다"));
        }

        Optional<YouTubeVideoInfo> info = oEmbedClient.fetch(videoId.get());
        Integer start = YouTubeUrlParser.extractStartSeconds(url).orElse(null);

        return ResponseEntity.ok(Map.of(
                "videoId", videoId.get(),
                "title", info.map(YouTubeVideoInfo::title).orElse(""),
                "authorName", info.map(YouTubeVideoInfo::authorName).orElse(""),
                "thumbnailUrl", info.map(YouTubeVideoInfo::thumbnailUrl).orElse(""),
                "startOffset", start == null ? "" : start,
                "found", info.isPresent()
        ));
    }

    @PostMapping("/works/{workId}/recordings")
    @Transactional
    public String addRecording(@PathVariable Long workId,
                               @ModelAttribute RecordingForm form,
                               RedirectAttributes redirectAttributes) {
        Work work = workRepository.findById(workId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));

        Recording recording = new Recording(work, form.getSourceType());

        if (form.getSourceType() == SourceType.YOUTUBE) {
            String videoId = YouTubeUrlParser.extractVideoId(form.getYoutubeUrl())
                    .orElseThrow(() -> new ResponseStatusException(
                            HttpStatus.BAD_REQUEST, "유튜브 URL 에서 영상 ID를 찾지 못했습니다"));
            recording.setYoutubeId(videoId);
            if (form.getSourceUrl() == null || form.getSourceUrl().isBlank()) {
                recording.setSourceUrl(YouTubeUrlParser.watchUrl(videoId));
            } else {
                recording.setSourceUrl(form.getSourceUrl());
            }
            if (form.getLicense() == null || form.getLicense().isBlank()) {
                recording.setLicense("YouTube 임베드");
            } else {
                recording.setLicense(form.getLicense());
            }
        } else {
            recording.setAudioUrl(form.getAudioUrl());
            recording.setSourceUrl(form.getSourceUrl());
            recording.setLicense(form.getLicense());
        }

        recording.setPerformer(form.getPerformer());
        recording.setStartOffset(form.getStartOffset());
        recording.setEndOffset(form.getEndOffset());
        recording.setDurationSeconds(form.getDurationSeconds());
        recording.setAttribution(form.getAttribution());
        recording.setAvailable(true);

        // 첫 음원은 자동으로 대표가 된다.
        boolean makeDefault = form.isDefault() || work.getRecordings().isEmpty();
        if (makeDefault) {
            work.getRecordings().forEach(existing -> existing.setDefault(false));
        }
        recording.setDefault(makeDefault);

        work.addRecording(recording);
        workRepository.save(work);

        redirectAttributes.addFlashAttribute("message", "음원을 추가했습니다. 미리보기로 재생되는지 꼭 확인하세요.");
        return "redirect:/admin/works/" + workId + "/edit";
    }

    @PostMapping("/recordings/{id}/default")
    @Transactional
    public String makeDefault(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        Recording recording = recordingRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));
        Work work = recording.getWork();
        work.getRecordings().forEach(r -> r.setDefault(false));
        recording.setDefault(true);
        workRepository.save(work);
        redirectAttributes.addFlashAttribute("message", "대표 음원을 바꿨습니다");
        return "redirect:/admin/works/" + work.getId() + "/edit";
    }

    @PostMapping("/recordings/{id}/toggle-available")
    @Transactional
    public String toggleAvailable(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        Recording recording = recordingRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));
        recording.setAvailable(!recording.isAvailable());
        recordingRepository.save(recording);
        redirectAttributes.addFlashAttribute("message",
                recording.isAvailable() ? "다시 재생 가능으로 표시했습니다" : "재생 불가로 내렸습니다");
        return "redirect:/admin/works/" + recording.getWork().getId() + "/edit";
    }

    @PostMapping("/recordings/{id}/delete")
    @Transactional
    public String delete(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        Recording recording = recordingRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));
        Long workId = recording.getWork().getId();
        recordingRepository.delete(recording);
        redirectAttributes.addFlashAttribute("message", "음원을 삭제했습니다");
        return "redirect:/admin/works/" + workId + "/edit";
    }
}
