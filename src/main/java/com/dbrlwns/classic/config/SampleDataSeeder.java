package com.dbrlwns.classic.config;

import com.dbrlwns.classic.composer.Composer;
import com.dbrlwns.classic.composer.ComposerRepository;
import com.dbrlwns.classic.work.Work;
import com.dbrlwns.classic.work.WorkRepository;
import org.springframework.boot.ApplicationRunner;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * 개발 편의용 샘플 데이터.
 *
 * 음원은 일부러 넣지 않는다. 유튜브 영상 ID 를 임의로 박아두면 죽은 링크가 되기 쉽고,
 * 무엇보다 관리 화면에서 URL 을 붙여넣고 미리보기로 확인하는 흐름이 이 앱의 핵심 작업이라
 * 처음부터 그 경로로 한 번은 지나가 보는 편이 낫다.
 */
@Configuration
@ConditionalOnProperty(name = "app.seed-sample-data", havingValue = "true")
public class SampleDataSeeder {

    @Bean
    public ApplicationRunner seedSampleData(ComposerRepository composerRepository,
                                            WorkRepository workRepository) {
        return args -> {
            if (composerRepository.count() > 0) {
                return;
            }

            Composer debussy = composerRepository.save(new Composer(
                    "클로드 드뷔시",
                    "Claude Debussy",
                    "debussy",
                    1862,
                    1918,
                    "프랑스의 작곡가. 화성을 기능이 아니라 색채로 다루면서 20세기 음악의 문을 열었다."
            ));

            Composer satie = composerRepository.save(new Composer(
                    "에릭 사티",
                    "Erik Satie",
                    "satie",
                    1866,
                    1925,
                    "프랑스의 작곡가. 장식을 걷어낸 단순한 선율로 당대의 낭만주의와 거리를 두었다."
            ));

            Work clairDeLune = new Work(debussy, "달빛", "clair-de-lune");
            clairDeLune.setTitleOriginal("Clair de lune");
            clairDeLune.setCatalog("L. 75 No. 3");
            clairDeLune.setYearComposed(1890);
            clairDeLune.setSummary("스무 살 남짓의 드뷔시가 쓰고, 십오 년을 묵힌 뒤에야 세상에 내놓은 곡.");
            clairDeLune.setStory("""
                    드뷔시는 1890년 무렵 이 곡을 포함한 《베르가마스크 모음곡》을 썼지만,
                    출판은 1905년에야 이루어졌다. 그 사이 그는 자신의 음악을 한 번 갈아엎었고,
                    출판 직전 곡의 제목과 내용을 손봤다.

                    제목은 폴 베를렌의 시에서 왔다. 시 속의 달빛은 낭만적인 배경이 아니라,
                    가면을 쓴 사람들이 춤추는 정원 위로 무심하게 쏟아지는 빛이다.

                    > 첫 마디의 화음은 어디로도 해결되지 않는다.
                    > 그냥 놓여 있다가, 다음 화음으로 미끄러진다.

                    이 곡을 들을 때 기억해 둘 것은, 드뷔시 본인은 '인상주의'라는 딱지를 몹시 싫어했다는 점이다.
                    """);
            clairDeLune.setPublished(true);
            workRepository.save(clairDeLune);

            Work gymnopedie = new Work(satie, "짐노페디 1번", "gymnopedie-no-1");
            gymnopedie.setTitleOriginal("Gymnopédie No. 1");
            gymnopedie.setYearComposed(1888);
            gymnopedie.setSummary("같은 음형이 스물여섯 번 반복되는 동안 아무 일도 일어나지 않는 곡.");
            gymnopedie.setStory("""
                    사티는 스물두 살에 이 곡을 썼다. 당시 그는 몽마르트르의 카바레에서 피아노를 치고 있었다.

                    악보에 적힌 지시어는 `Lent et douloureux` — 느리고 고통스럽게 — 였지만,
                    정작 음악은 고통을 표현하지 않는다. 왼손은 같은 자리를 계속 오가고,
                    오른손 선율은 시작한 곳으로 되돌아온다.

                    훗날 드뷔시가 이 곡을 관현악으로 편곡하면서 더 널리 알려졌다.
                    """);
            gymnopedie.setPublished(true);
            workRepository.save(gymnopedie);
        };
    }
}
