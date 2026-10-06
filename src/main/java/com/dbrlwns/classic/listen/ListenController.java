package com.dbrlwns.classic.listen;

import com.dbrlwns.classic.recording.Recording;
import com.dbrlwns.classic.work.Work;
import com.dbrlwns.classic.work.WorkRepository;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;
import java.util.Optional;

/**
 * 이어 듣기.
 *
 * 플레이어 하나를 한 자리에 두고, 곡이 끝나면 다음 곡을 그 플레이어에 넣는다.
 * 목록 카드마다 재생을 거는 방식이 아닌 이유는, 다음 곡으로 넘어갈 때 화면이
 * 제멋대로 움직이거나 화면 밖에서 소리가 나기 때문이다. 후자는 사실상
 * 백그라운드 재생이 되어 YouTube 약관의 경계에 걸린다.
 *
 * 플레이어는 늘 보이는 자리에 있어야 한다. 약관이 금지하는 것은 플레이어를
 * 가리거나 오디오만 분리하는 것이다(docs/concept.md 의 "YouTube 약관" 절).
 */
@Controller
public class ListenController {

    private final WorkRepository workRepository;

    public ListenController(WorkRepository workRepository) {
        this.workRepository = workRepository;
    }

    @GetMapping("/listen")
    public String listen(Model model) {
        // 메인과 같은 연도순. 1720년부터 훑어 내려가는 것이 이 사이트에서
        // 가장 의미 있는 재생 순서다.
        List<ListenTrack> tracks = workRepository.findPublishedWithComposer().stream()
                .map(this::toTrack)
                .flatMap(Optional::stream)
                .toList();

        model.addAttribute("tracks", tracks);
        return "listen";
    }

    /**
     * 유튜브 음원이 붙어 있는 곡만 재생 목록에 넣는다.
     * 직접 호스팅 음원은 이어 듣기에서 다루지 않는다. 지금 쓰는 음원이 없고,
     * 섞으면 전환 로직이 두 갈래가 된다.
     */
    private Optional<ListenTrack> toTrack(Work work) {
        Recording recording = work.getPlayableRecording();
        if (recording == null || !recording.isYoutube() || recording.getYoutubeId() == null) {
            return Optional.empty();
        }
        return Optional.of(new ListenTrack(
                work.getSlug(),
                work.getTitle(),
                work.getComposer().getName(),
                work.getComposer().getSlug(),
                work.getYearComposed(),
                work.getCatalog(),
                work.getSummary(),
                recording.getPerformer(),
                recording.getYoutubeId(),
                recording.getStartOffset(),
                recording.getEndOffset()
        ));
    }
}
