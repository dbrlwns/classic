-- 개발용 시드 데이터.
--
-- 실행 조건 두 가지가 application.yml 에 있어야 한다.
--   spring.sql.init.mode: always
--   spring.jpa.defer-datasource-initialization: true   <- 이게 없으면 실패한다
--
-- 두 번째가 핵심이다. 기본값이면 Hibernate 가 테이블을 만들기 전에 이 파일이
-- 먼저 돌아서 "table not found" 로 죽는다. defer 를 켜야 스키마 생성 뒤에 실행된다.
--
-- 이 파일은 매 기동마다 실행된다. 지금은 ddl-auto: create-drop 이라 스키마가
-- 매번 새로 만들어지므로 중복이 쌓이지 않는다. 운영 프로파일에서는
-- spring.sql.init.mode: never 로 꺼 둔다(application-prod.yml).
--
-- id 를 직접 지정하지 않는다. IDENTITY 컬럼에 값을 박으면 시퀀스가 어긋나
-- 이후 관리 화면에서 추가할 때 충돌한다. 연관관계는 slug 로 찾아 붙인다.

-- ---------------------------------------------------------------------------
-- 작곡가
--
-- 전원 1962년 이전 사망이라 악곡은 퍼블릭 도메인이다.
-- 음원(연주 녹음)의 저작인접권은 별개이므로 유튜브 공식 채널 임베드를 쓴다.
-- 소개 글은 사실만 참고해 직접 썼다. 라이너 노트나 평론 문장을 옮기지 않는다.
-- ---------------------------------------------------------------------------

INSERT INTO composer (name, name_en, slug, born_year, died_year, bio) VALUES
('요한 제바스티안 바흐', 'Johann Sebastian Bach', 'bach', 1685, 1750,
 '독일의 작곡가. 대위법을 끝까지 밀어붙여 서양 음악의 문법을 정리했다. 생전에는 작곡가보다 오르간 연주자로 더 알려져 있었고, 그의 작품이 본격적으로 재발견된 것은 죽고 나서 한참 뒤의 일이다.'),

('볼프강 아마데우스 모차르트', 'Wolfgang Amadeus Mozart', 'mozart', 1756, 1791,
 '오스트리아의 작곡가. 서른다섯 해를 사는 동안 육백 곡이 넘는 작품을 남겼다. 오페라와 협주곡 양쪽에서 고전주의의 기준을 세웠다.'),

('루트비히 판 베토벤', 'Ludwig van Beethoven', 'beethoven', 1770, 1827,
 '독일의 작곡가. 귀가 멀어가는 동안 교향곡의 규모와 형식을 다시 썼다. 고전주의의 마지막이자 낭만주의의 출발점으로 불린다.'),

('프란츠 슈베르트', 'Franz Schubert', 'schubert', 1797, 1828,
 '오스트리아의 작곡가. 서른한 살에 죽기까지 육백 편이 넘는 가곡을 썼다. 시와 선율을 같은 무게로 다룬 첫 세대다.'),

('프레데리크 쇼팽', 'Frederic Chopin', 'chopin', 1810, 1849,
 '폴란드의 작곡가. 거의 모든 작품을 피아노 한 대를 위해 썼다. 스무 살에 조국을 떠난 뒤 다시 돌아가지 못했다.'),

('표트르 일리치 차이콥스키', 'Pyotr Ilyich Tchaikovsky', 'tchaikovsky', 1840, 1893,
 '러시아의 작곡가. 발레 음악을 독립된 예술로 끌어올렸다. 서유럽의 형식과 러시아의 선율 사이에서 평생 줄다리기를 했다.'),

('에드바르 그리그', 'Edvard Grieg', 'grieg', 1843, 1907,
 '노르웨이의 작곡가. 북유럽의 민속 선율을 예술음악의 어법으로 옮겼다. 큰 편성보다 소품과 가곡에서 더 자기다웠다.'),

('클로드 드뷔시', 'Claude Debussy', 'debussy', 1862, 1918,
 '프랑스의 작곡가. 화성을 기능이 아니라 색채로 다루면서 20세기 음악의 문을 열었다. 정작 본인은 "인상주의"라는 딱지를 몹시 싫어했다.'),

('에릭 사티', 'Erik Satie', 'satie', 1866, 1925,
 '프랑스의 작곡가. 장식을 걷어낸 단순한 선율로 당대의 낭만주의와 거리를 두었다. 악보에 농담 같은 연주 지시어를 적어 넣곤 했다.'),

('세르게이 라흐마니노프', 'Sergei Rachmaninoff', 'rachmaninoff', 1873, 1943,
 '러시아의 작곡가이자 피아니스트. 손이 매우 커서 보통 연주자가 짚기 힘든 화음을 썼다. 혁명 이후 미국으로 망명해 연주로 생계를 이었다.'),

('모리스 라벨', 'Maurice Ravel', 'ravel', 1875, 1937,
 '프랑스의 작곡가. 관현악법의 정밀함으로 이름을 남겼다. 스트라빈스키가 그를 "스위스 시계공"이라 부른 일화가 유명하다.'),

('장 시벨리우스', 'Jean Sibelius', 'sibelius', 1865, 1957,
 '핀란드의 작곡가. 조국의 풍경과 신화를 관현악으로 옮겼다. 쉰을 넘긴 뒤 삼십 년 가까이 거의 아무것도 발표하지 않았다.');


-- ---------------------------------------------------------------------------
-- 곡
--
-- 데모용 두 곡. composer_id 는 slug 로 찾아 붙인다.
-- 음원은 일부러 넣지 않았다. 관리 화면에서 유튜브 URL 을 붙여넣고
-- 미리보기로 재생을 확인하는 흐름이 이 앱의 핵심 작업이라, 한 번은 지나가 보는 게 낫다.
-- ---------------------------------------------------------------------------

INSERT INTO work (composer_id, title, title_original, catalog, year_composed, slug, summary, story, published, created_at)
SELECT id, '달빛', 'Clair de lune', 'L. 75 No. 3', 1890, 'clair-de-lune',
       '스무 살 남짓의 드뷔시가 쓰고, 십오 년을 묵힌 뒤에야 세상에 내놓은 곡.',
       '드뷔시는 1890년 무렵 이 곡을 포함한 《베르가마스크 모음곡》을 썼지만, 출판은 1905년에야 이루어졌다. 그 사이 그는 자신의 음악을 한 번 갈아엎었고, 출판 직전 곡의 제목과 내용을 손봤다.

제목은 폴 베를렌의 시에서 왔다. 시 속의 달빛은 낭만적인 배경이 아니라, 가면을 쓴 사람들이 춤추는 정원 위로 무심하게 쏟아지는 빛이다.

> 첫 마디의 화음은 어디로도 해결되지 않는다.
> 그냥 놓여 있다가, 다음 화음으로 미끄러진다.

이 곡을 들을 때 기억해 둘 것은, 드뷔시 본인은 "인상주의"라는 딱지를 몹시 싫어했다는 점이다.',
       TRUE, CURRENT_TIMESTAMP
FROM composer WHERE slug = 'debussy';

INSERT INTO work (composer_id, title, title_original, catalog, year_composed, slug, summary, story, published, created_at)
SELECT id, '짐노페디 1번', 'Gymnopedie No. 1', NULL, 1888, 'gymnopedie-no-1',
       '같은 음형이 스물여섯 번 반복되는 동안 아무 일도 일어나지 않는 곡.',
       '사티는 스물두 살에 이 곡을 썼다. 당시 그는 몽마르트르의 카바레에서 피아노를 치고 있었다.

악보에 적힌 지시어는 `Lent et douloureux` — 느리고 고통스럽게 — 였지만, 정작 음악은 고통을 표현하지 않는다. 왼손은 같은 자리를 계속 오가고, 오른손 선율은 시작한 곳으로 되돌아온다.

훗날 드뷔시가 이 곡을 관현악으로 편곡하면서 더 널리 알려졌다.',
       TRUE, CURRENT_TIMESTAMP
FROM composer WHERE slug = 'satie';


-- ---------------------------------------------------------------------------
-- 곡 초안 (published = FALSE)
--
-- 스토리는 비워 두었다. summary 와 story 는 편집자가 쓸 자리다.
-- 여기 들어있는 것은 찾아보기 귀찮은 메타데이터뿐이다 - 원어 제목,
-- 작품 번호, 작곡 연도. 스토리를 쓰고 published 를 켜면 사이트에 올라간다.
--
-- published = FALSE 이므로 목록(/)에는 보이지 않는다. /admin 에서만 보인다.
-- 이게 정상이다. 초안 상태다.
--
-- 다악장 작품은 악장 자체를 하나의 Work 로 등록한다(concept.md 참조).
-- "월광 소나타 1악장"이 하나의 Work 다.
--
-- 작품 번호와 연도는 출발점으로 넣은 것이다. 스토리를 쓰면서 한 번 확인할 것.
-- 판본에 따라 다르게 표기되는 것들이 있다(예: 차이콥스키 사계 Op.37a / Op.37b).
-- ---------------------------------------------------------------------------

INSERT INTO work (composer_id, title, title_original, catalog, year_composed, slug, published, created_at)
SELECT c.id, d.title, d.title_original, d.catalog, d.year_composed, d.slug, FALSE, CURRENT_TIMESTAMP
FROM composer c
JOIN (
    -- 바흐
    SELECT 'bach' AS composer_slug, '골드베르크 변주곡 아리아' AS title, 'Goldberg Variations: Aria' AS title_original, 'BWV 988' AS catalog, 1741 AS year_composed, 'goldberg-aria' AS slug UNION ALL
    SELECT 'bach', '무반주 첼로 조곡 1번 프렐류드', 'Cello Suite No. 1: Prelude', 'BWV 1007', 1720, 'cello-suite-1-prelude' UNION ALL
    SELECT 'bach', 'G선상의 아리아', 'Air on the G String', 'BWV 1068', 1730, 'air-on-the-g-string' UNION ALL

    -- 모차르트
    SELECT 'mozart', '터키 행진곡', 'Rondo alla Turca', 'K. 331', 1783, 'rondo-alla-turca' UNION ALL
    SELECT 'mozart', '레퀴엠 라크리모사', 'Requiem: Lacrimosa', 'K. 626', 1791, 'requiem-lacrimosa' UNION ALL
    SELECT 'mozart', '아이네 클라이네 나흐트무지크 1악장', 'Eine kleine Nachtmusik: Allegro', 'K. 525', 1787, 'eine-kleine-nachtmusik-1' UNION ALL

    -- 베토벤
    SELECT 'beethoven', '월광 소나타 1악장', 'Piano Sonata No. 14: Adagio sostenuto', 'Op. 27 No. 2', 1801, 'moonlight-sonata-1' UNION ALL
    SELECT 'beethoven', '엘리제를 위하여', 'Fur Elise', 'WoO 59', 1810, 'fur-elise' UNION ALL
    SELECT 'beethoven', '교향곡 7번 2악장', 'Symphony No. 7: Allegretto', 'Op. 92', 1812, 'symphony-7-allegretto' UNION ALL

    -- 슈베르트
    SELECT 'schubert', '아베 마리아', 'Ellens dritter Gesang', 'D. 839', 1825, 'ave-maria' UNION ALL
    SELECT 'schubert', '송어', 'Die Forelle', 'D. 550', 1817, 'die-forelle' UNION ALL
    SELECT 'schubert', '즉흥곡 3번', 'Impromptu No. 3', 'Op. 90 No. 3 / D. 899', 1827, 'impromptu-op90-3' UNION ALL

    -- 쇼팽
    SELECT 'chopin', '야상곡 2번', 'Nocturne No. 2', 'Op. 9 No. 2', 1832, 'nocturne-op9-2' UNION ALL
    SELECT 'chopin', '빗방울 전주곡', 'Prelude No. 15 (Raindrop)', 'Op. 28 No. 15', 1839, 'raindrop-prelude' UNION ALL
    SELECT 'chopin', '혁명 연습곡', 'Etude (Revolutionary)', 'Op. 10 No. 12', 1831, 'revolutionary-etude' UNION ALL

    -- 차이콥스키
    SELECT 'tchaikovsky', '백조의 호수 정경', 'Swan Lake: Scene', 'Op. 20', 1876, 'swan-lake-scene' UNION ALL
    SELECT 'tchaikovsky', '호두까기인형 꽃의 왈츠', 'The Nutcracker: Waltz of the Flowers', 'Op. 71', 1892, 'waltz-of-the-flowers' UNION ALL
    SELECT 'tchaikovsky', '사계 10월 가을의 노래', 'The Seasons: October', 'Op. 37a', 1876, 'seasons-october' UNION ALL

    -- 그리그
    SELECT 'grieg', '페르 귄트 아침의 기분', 'Peer Gynt: Morning Mood', 'Op. 46', 1875, 'morning-mood' UNION ALL
    SELECT 'grieg', '페르 귄트 산왕의 궁전에서', 'Peer Gynt: In the Hall of the Mountain King', 'Op. 46', 1875, 'hall-of-the-mountain-king' UNION ALL
    SELECT 'grieg', '서정 소품집 아리에타', 'Lyric Pieces: Arietta', 'Op. 12 No. 1', 1867, 'arietta' UNION ALL

    -- 드뷔시 (달빛은 위에 별도로 있다)
    SELECT 'debussy', '아라베스크 1번', 'Deux Arabesques No. 1', 'L. 66', 1891, 'arabesque-1' UNION ALL
    SELECT 'debussy', '아마빛 머리의 소녀', 'La fille aux cheveux de lin', 'L. 117', 1910, 'la-fille-aux-cheveux-de-lin' UNION ALL
    SELECT 'debussy', '꿈', 'Reverie', 'L. 68', 1890, 'reverie' UNION ALL

    -- 사티 (짐노페디 1번은 위에 별도로 있다)
    SELECT 'satie', '짐노페디 3번', 'Gymnopedie No. 3', NULL, 1888, 'gymnopedie-no-3' UNION ALL
    SELECT 'satie', '그노시엔느 1번', 'Gnossienne No. 1', NULL, 1890, 'gnossienne-no-1' UNION ALL
    SELECT 'satie', '너를 원해', 'Je te veux', NULL, 1897, 'je-te-veux' UNION ALL

    -- 라흐마니노프
    SELECT 'rachmaninoff', '피아노 협주곡 2번 2악장', 'Piano Concerto No. 2: Adagio sostenuto', 'Op. 18', 1901, 'piano-concerto-2-adagio' UNION ALL
    SELECT 'rachmaninoff', '파가니니 주제 변주곡 18변주', 'Rhapsody on a Theme of Paganini: Variation 18', 'Op. 43', 1934, 'paganini-variation-18' UNION ALL
    SELECT 'rachmaninoff', '보칼리제', 'Vocalise', 'Op. 34 No. 14', 1912, 'vocalise' UNION ALL

    -- 라벨
    SELECT 'ravel', '죽은 왕녀를 위한 파반느', 'Pavane pour une infante defunte', 'M. 19', 1899, 'pavane-infante-defunte' UNION ALL
    SELECT 'ravel', '볼레로', 'Bolero', 'M. 81', 1928, 'bolero' UNION ALL
    SELECT 'ravel', '물의 유희', 'Jeux d''eau', 'M. 30', 1901, 'jeux-deau' UNION ALL

    -- 시벨리우스
    SELECT 'sibelius', '핀란디아', 'Finlandia', 'Op. 26', 1899, 'finlandia' UNION ALL
    SELECT 'sibelius', '슬픈 왈츠', 'Valse triste', 'Op. 44 No. 1', 1904, 'valse-triste' UNION ALL
    SELECT 'sibelius', '투오넬라의 백조', 'The Swan of Tuonela', 'Op. 22 No. 2', 1895, 'swan-of-tuonela'
) d ON d.composer_slug = c.slug;


-- ---------------------------------------------------------------------------
-- 한 줄 소개 (초고)
--
-- 목록 카드에 나오는 문장이다. 고쳐 쓰는 것을 전제로 쓴 초고다.
--
-- 쓸 때 지킨 원칙: 널리 퍼진 이야기 중 근거가 약한 것은 사실로 쓰지 않고,
-- "그렇게 알려졌지만 근거는 이렇다"로 돌려 썼다. 클래식은 낭만적인 전설이
-- 사실처럼 굳은 분야라 확인 없이 옮기면 틀린 이야기를 퍼뜨리게 된다.
--
-- AI 가 쓴 문장은 저작권 보호를 받지 못한다. 거꾸로 말하면 이 상태로는
-- 이 글이 누구의 것도 아니다. 손을 봐야 저작권이 생긴다.
-- ---------------------------------------------------------------------------

UPDATE work SET summary = '불면증에 걸린 백작을 위해 썼다는 이야기가 따라붙지만, 근거는 바흐가 죽고 반세기 뒤에 나온 전기 한 권뿐이다.'
  WHERE slug = 'goldberg-aria';

UPDATE work SET summary = '백 년이 넘도록 연습곡 취급을 받았다. 열세 살 카잘스가 헌책방에서 악보를 집어들기 전까지.'
  WHERE slug = 'cello-suite-1-prelude';

UPDATE work SET summary = '원래는 관현악 조곡의 한 악장이다. "G선상의"라는 제목은 150년 뒤 어느 바이올리니스트가 편곡하면서 붙었다.'
  WHERE slug = 'air-on-the-g-string';

UPDATE work SET summary = '당시 유럽이 유행처럼 흉내 낸 "터키 풍"이다. 실제 터키 음악과는 거의 관계가 없다.'
  WHERE slug = 'rondo-alla-turca';

UPDATE work SET summary = '모차르트가 쓴 것은 여덟 마디까지다. 그 뒤를 이어 쓴 사람은 제자였다.'
  WHERE slug = 'requiem-lacrimosa';

UPDATE work SET summary = '모차르트 생전에 출판되지 않았다. 왜 썼는지, 누구를 위해 썼는지 아직 모른다.'
  WHERE slug = 'eine-kleine-nachtmusik-1';

UPDATE work SET summary = '"월광"은 베토벤이 붙인 제목이 아니다. 그가 죽은 뒤 어느 평론가가 호수의 달빛에 비유한 것이 굳었다.'
  WHERE slug = 'moonlight-sonata-1';

UPDATE work SET summary = '"엘리제"가 누구인지 아직 모른다. 자필 악보가 사라져 이름의 철자조차 확실하지 않다.'
  WHERE slug = 'fur-elise';

UPDATE work SET summary = '초연에서 이 악장만 앙코르를 받았다. 그래서 지금도 따로 떼어 연주되는 일이 잦다.'
  WHERE slug = 'symphony-7-allegretto';

UPDATE work SET summary = '원래 가사는 기도문이 아니다. 월터 스콧의 서사시에 나오는 처녀가 부르는 노래였다.'
  WHERE slug = 'ave-maria';

UPDATE work SET summary = '가곡으로 먼저 쓰고, 2년 뒤 자기 선율을 피아노 오중주의 변주곡 주제로 다시 썼다.'
  WHERE slug = 'die-forelle';

UPDATE work SET summary = '"즉흥곡"이라는 제목은 출판사가 붙였다. 즉흥으로 연주하라는 뜻이 아니다.'
  WHERE slug = 'impromptu-op90-3';

UPDATE work SET summary = '스무 살의 쇼팽이 폴란드를 떠난 직후에 쓴 곡이다. 그는 다시 돌아가지 못했다.'
  WHERE slug = 'nocturne-op9-2';

UPDATE work SET summary = '"빗방울"은 쇼팽이 붙인 제목이 아니다. 그는 스물네 곡의 전주곡에 번호만 매겼다.'
  WHERE slug = 'raindrop-prelude';

UPDATE work SET summary = '바르샤바 봉기가 진압됐다는 소식을 들은 무렵에 썼다고 전해진다. 쇼팽 본인은 그런 말을 남기지 않았다.'
  WHERE slug = 'revolutionary-etude';

UPDATE work SET summary = '초연은 실패했다. 지금의 명성은 차이콥스키가 죽은 뒤 다시 올린 무대에서 시작됐다.'
  WHERE slug = 'swan-lake-scene';

UPDATE work SET summary = '차이콥스키는 이 발레를 내키지 않아 하며 썼다. 정작 그의 작품 중 가장 많이 연주된다.'
  WHERE slug = 'waltz-of-the-flowers';

UPDATE work SET summary = '잡지 연재물이었다. 매달 한 곡씩, 열두 달 분량을 주문받아 썼다.'
  WHERE slug = 'seasons-october';

UPDATE work SET summary = '노르웨이의 아침이 아니다. 입센의 희곡에서 주인공이 사하라 사막에서 맞는 아침이다.'
  WHERE slug = 'morning-mood';

UPDATE work SET summary = '그리그는 편지에서 이 곡을 "소똥 냄새와 지독한 노르웨이 티"가 난다고 깎아내렸다.'
  WHERE slug = 'hall-of-the-mountain-king';

UPDATE work SET summary = '서정 소품집 예순여섯 곡의 첫 곡. 그리그는 마지막 권의 마지막 곡에서 이 선율로 되돌아왔다.'
  WHERE slug = 'arietta';

UPDATE work SET summary = '스물아홉에 쓴 초기작이다. 그가 나중에 깨뜨릴 낭만주의의 어법이 아직 남아 있다.'
  WHERE slug = 'arabesque-1';

UPDATE work SET summary = '제목은 르콩트 드 리슬의 시에서 왔다. 드뷔시는 그 시를 가사로 쓰는 대신 피아노에 옮겼다.'
  WHERE slug = 'la-fille-aux-cheveux-de-lin';

UPDATE work SET summary = '드뷔시는 이 곡을 싫어했다. 출판사에 내지 말라고 했지만 판권은 이미 넘어가 있었다.'
  WHERE slug = 'reverie';

UPDATE work SET summary = '세 곡 중 가장 늦게 알려졌다. 드뷔시가 관현악으로 옮긴 것은 1번과 3번이다.'
  WHERE slug = 'gymnopedie-no-3';

UPDATE work SET summary = '박자표도 마디선도 없다. 대신 "빛나게", "물어보듯" 같은 지시어가 적혀 있다.'
  WHERE slug = 'gnossienne-no-1';

UPDATE work SET summary = '카바레에서 부르던 왈츠다. 사티는 생계를 위해 이런 곡을 썼고, 그 사실을 숨기지 않았다.'
  WHERE slug = 'je-te-veux';

UPDATE work SET summary = '3년 가까이 아무것도 쓰지 못한 끝에 나왔다. 그는 이 곡을 자신을 치료한 의사에게 헌정했다.'
  WHERE slug = 'piano-concerto-2-adagio';

UPDATE work SET summary = '파가니니의 주제를 거꾸로 뒤집어 만든 선율이다. 같은 음을 쓰는데 전혀 다르게 들린다.'
  WHERE slug = 'paganini-variation-18';

UPDATE work SET summary = '가사가 없다. 처음부터 모음 하나로만 부르도록 썼다.'
  WHERE slug = 'vocalise';

UPDATE work SET summary = '특정 왕녀를 추모한 곡이 아니다. 라벨은 제목의 말소리가 좋아서 골랐다고 했다.'
  WHERE slug = 'pavane-infante-defunte';

UPDATE work SET summary = '라벨은 이 곡을 "음악이 없는 관현악곡"이라 불렀다. 그의 작품 중 가장 유명해졌다.'
  WHERE slug = 'bolero';

UPDATE work SET summary = '물이 떨어지는 소리를 피아노로 옮겼다. 드뷔시가 같은 영역에 들어서기 몇 해 전이다.'
  WHERE slug = 'jeux-deau';

UPDATE work SET summary = '러시아의 검열을 피하려고 연주회마다 제목을 바꿔 가며 올렸다.'
  WHERE slug = 'finlandia';

UPDATE work SET summary = '연극 음악의 한 토막이다. 무대에서는 죽어가는 어머니가 환상 속에서 춤추는 장면에 붙었다.'
  WHERE slug = 'valse-triste';

UPDATE work SET summary = '투오넬라는 핀란드 신화에서 죽음의 나라다. 그 강을 떠다니는 백조를 잉글리시 호른이 노래한다.'
  WHERE slug = 'swan-of-tuonela';


-- ---------------------------------------------------------------------------
-- 음원 (유튜브)
--
-- >>> 여기에 영상 ID 만 채우면 된다. <<<
--
-- 아래 표에서 두 번째 칸(빈 문자열)에 11자 영상 ID 를 넣고 재시작한다.
-- 예:  SELECT 'fur-elise', 'rEGOihjqO9w', 'Alice Sara Ott (2019)' UNION ALL
--
-- 빈 문자열인 줄은 건너뛴다(맨 아래 WHERE 절). 그래서 한 번에 다 채울 필요 없이
-- 하나씩 늘려가면 된다.
--
-- ID 는 유튜브 주소의 v= 뒤에 오는 11자다.
--   https://www.youtube.com/watch?v=rEGOihjqO9w
--                                   ^^^^^^^^^^^
--
-- 넣기 전에 확인할 것:
--   - 공식 채널인가 (오케스트라 공식, 레이블, 아티스트 공식). 팬 재업로드는 쓰지 않는다.
--   - 퍼가기가 열려 있는가. 관리 화면 미리보기로 실제 재생해 보는 게 가장 확실하다.
--     oEmbed 가 제목을 가져와도 퍼가기 금지(에러 101/150)일 수 있다.
-- ---------------------------------------------------------------------------

INSERT INTO recording (work_id, source_type, youtube_id, performer, license, source_url, is_default, available, created_at)
SELECT w.id, 'YOUTUBE', v.video_id,
       NULLIF(v.performer, ''),
       'YouTube 임베드',
       'https://www.youtube.com/watch?v=' || v.video_id,
       TRUE, TRUE, CURRENT_TIMESTAMP
FROM work w
JOIN (
    --     곡 slug                        영상 ID (11자)   연주자
    SELECT 'clair-de-lune' AS work_slug,  '' AS video_id, '' AS performer UNION ALL
    SELECT 'gymnopedie-no-1',             '',             '' UNION ALL

    SELECT 'goldberg-aria',               '',             '' UNION ALL
    SELECT 'cello-suite-1-prelude',       '',             '' UNION ALL
    SELECT 'air-on-the-g-string',         '',             '' UNION ALL

    SELECT 'rondo-alla-turca',            '',             '' UNION ALL
    SELECT 'requiem-lacrimosa',           '',             '' UNION ALL
    SELECT 'eine-kleine-nachtmusik-1',    '',             '' UNION ALL

    SELECT 'moonlight-sonata-1',          '',             '' UNION ALL
    SELECT 'fur-elise',                   '',             '' UNION ALL
    SELECT 'symphony-7-allegretto',       '',             '' UNION ALL

    SELECT 'ave-maria',                   '',             '' UNION ALL
    SELECT 'die-forelle',                 '',             '' UNION ALL
    SELECT 'impromptu-op90-3',            '',             '' UNION ALL

    SELECT 'nocturne-op9-2',              '',             '' UNION ALL
    SELECT 'raindrop-prelude',            '',             '' UNION ALL
    SELECT 'revolutionary-etude',         '',             '' UNION ALL

    SELECT 'swan-lake-scene',             '',             '' UNION ALL
    SELECT 'waltz-of-the-flowers',        '',             '' UNION ALL
    SELECT 'seasons-october',             '',             '' UNION ALL

    SELECT 'morning-mood',                '',             '' UNION ALL
    SELECT 'hall-of-the-mountain-king',   '',             '' UNION ALL
    SELECT 'arietta',                     '',             '' UNION ALL

    SELECT 'arabesque-1',                 '',             '' UNION ALL
    SELECT 'la-fille-aux-cheveux-de-lin', '',             '' UNION ALL
    SELECT 'reverie',                     '',             '' UNION ALL

    SELECT 'gymnopedie-no-3',             '',             '' UNION ALL
    SELECT 'gnossienne-no-1',             '',             '' UNION ALL
    SELECT 'je-te-veux',                  '',             '' UNION ALL

    SELECT 'piano-concerto-2-adagio',     '',             '' UNION ALL
    SELECT 'paganini-variation-18',       '',             '' UNION ALL
    SELECT 'vocalise',                    '',             '' UNION ALL

    SELECT 'pavane-infante-defunte',      '',             '' UNION ALL
    SELECT 'bolero',                      '',             '' UNION ALL
    SELECT 'jeux-deau',                   '',             '' UNION ALL

    SELECT 'finlandia',                   '',             '' UNION ALL
    SELECT 'valse-triste',                '',             '' UNION ALL
    SELECT 'swan-of-tuonela',             '',             ''
) v ON v.work_slug = w.slug
WHERE v.video_id <> '';   -- 빈 줄은 건너뛴다
