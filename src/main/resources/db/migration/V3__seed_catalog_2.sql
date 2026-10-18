-- 두 번째 카탈로그: 작곡가 27명 추가(바흐 등 기존 작곡가 곡 포함), 곡 60개.
--
-- 곡은 전부 published = FALSE 로 들어간다. 녹음(영상)과 글이 붙은 곡만 관리
-- 화면에서 공개한다. 영상 ID 는 여기서 정하지 않는다 — 관리 화면의 YouTube
-- 조회로 곡마다 붙인다.
-- 작곡가 소개와 곡 한 줄 소개는 맨 아래에서 채운다(초고).
--
-- 전원 1962년 이전 사망이라 악곡은 퍼블릭 도메인이다.
-- 연도·카탈로그가 불확실한 곡(토카타와 푸가, 캐논)은 NULL 로 뒀다.
-- 이 파일은 실행된 뒤 수정하지 않는다. 곡을 고치는 곳은 관리 화면이다.

INSERT INTO composer (name, name_en, slug, born_year, died_year) VALUES
('안토니오 비발디', 'Antonio Vivaldi', 'vivaldi', 1678, 1741),
('게오르크 프리드리히 헨델', 'George Frideric Handel', 'handel', 1685, 1759),
('요한 파헬벨', 'Johann Pachelbel', 'pachelbel', 1653, 1706),
('요제프 하이든', 'Joseph Haydn', 'haydn', 1732, 1809),
('로베르트 슈만', 'Robert Schumann', 'schumann', 1810, 1856),
('펠릭스 멘델스존', 'Felix Mendelssohn', 'mendelssohn', 1809, 1847),
('프란츠 리스트', 'Franz Liszt', 'liszt', 1811, 1886),
('요하네스 브람스', 'Johannes Brahms', 'brahms', 1833, 1897),
('니콜로 파가니니', 'Niccolo Paganini', 'paganini', 1782, 1840),
('주세페 베르디', 'Giuseppe Verdi', 'verdi', 1813, 1901),
('조아키노 로시니', 'Gioachino Rossini', 'rossini', 1792, 1868),
('자코모 푸치니', 'Giacomo Puccini', 'puccini', 1858, 1924),
('조르주 비제', 'Georges Bizet', 'bizet', 1838, 1875),
('카미유 생상스', 'Camille Saint-Saens', 'saint-saens', 1835, 1921),
('자크 오펜바흐', 'Jacques Offenbach', 'offenbach', 1819, 1880),
('요한 슈트라우스 2세', 'Johann Strauss II', 'strauss-ii', 1825, 1899),
('베드르지흐 스메타나', 'Bedrich Smetana', 'smetana', 1824, 1884),
('안토닌 드보르자크', 'Antonin Dvorak', 'dvorak', 1841, 1904),
('모데스트 무소륵스키', 'Modest Mussorgsky', 'mussorgsky', 1839, 1881),
('니콜라이 림스키코르사코프', 'Nikolai Rimsky-Korsakov', 'rimsky-korsakov', 1844, 1908),
('알렉산드르 보로딘', 'Alexander Borodin', 'borodin', 1833, 1887),
('가브리엘 포레', 'Gabriel Faure', 'faure', 1845, 1924),
('에드워드 엘가', 'Edward Elgar', 'elgar', 1857, 1934),
('구스타브 홀스트', 'Gustav Holst', 'holst', 1874, 1934),
('구스타프 말러', 'Gustav Mahler', 'mahler', 1860, 1911),
('조지 거슈윈', 'George Gershwin', 'gershwin', 1898, 1937),
('세르게이 프로코피예프', 'Sergei Prokofiev', 'prokofiev', 1891, 1953);

INSERT INTO work (composer_id, title, title_original, catalog, year_composed, slug, published, created_at)
SELECT c.id, d.title, d.title_original, d.catalog, d.year_composed, d.slug, TRUE, CURRENT_TIMESTAMP
FROM composer c
JOIN (
    SELECT 'bach' AS composer_slug, '예수, 인류 소망의 기쁨' AS title, 'Jesu, Joy of Man''s Desiring' AS title_original, 'BWV 147' AS catalog, 1723 AS year_composed, 'jesu-joy' AS slug UNION ALL
    SELECT 'bach', '토카타와 푸가 d단조', 'Toccata and Fugue in D minor', 'BWV 565', NULL, 'toccata-fugue-d-minor' UNION ALL
    SELECT 'bach', '평균율 1권 프렐류드 1번', 'The Well-Tempered Clavier I: Prelude No. 1', 'BWV 846', 1722, 'wtc1-prelude-1' UNION ALL
    SELECT 'bach', '브란덴부르크 협주곡 3번', 'Brandenburg Concerto No. 3', 'BWV 1048', 1721, 'brandenburg-3' UNION ALL
    SELECT 'vivaldi', '사계 봄 1악장', 'The Four Seasons: Spring, Allegro', 'RV 269', 1723, 'spring-allegro' UNION ALL
    SELECT 'vivaldi', '사계 겨울 2악장', 'The Four Seasons: Winter, Largo', 'RV 297', 1723, 'winter-largo' UNION ALL
    SELECT 'handel', '할렐루야', 'Messiah: Hallelujah', 'HWV 56', 1741, 'hallelujah' UNION ALL
    SELECT 'handel', '라르고', 'Serse: Ombra mai fu', 'HWV 17', 1738, 'ombra-mai-fu' UNION ALL
    SELECT 'pachelbel', '캐논', 'Canon in D', NULL, NULL, 'canon-in-d' UNION ALL
    SELECT 'haydn', '교향곡 94번 놀람 2악장', 'Symphony No. 94: Andante', 'Hob. I:94', 1791, 'surprise-symphony-andante' UNION ALL
    SELECT 'mozart', '피가로의 결혼 서곡', 'The Marriage of Figaro: Overture', 'K. 492', 1786, 'figaro-overture' UNION ALL
    SELECT 'mozart', '교향곡 40번 1악장', 'Symphony No. 40: Molto allegro', 'K. 550', 1788, 'symphony-40-1' UNION ALL
    SELECT 'mozart', '밤의 여왕 아리아', 'The Magic Flute: Der Holle Rache', 'K. 620', 1791, 'queen-of-the-night' UNION ALL
    SELECT 'mozart', '피아노 협주곡 21번 2악장', 'Piano Concerto No. 21: Andante', 'K. 467', 1785, 'piano-concerto-21-andante' UNION ALL
    SELECT 'beethoven', '교향곡 5번 1악장', 'Symphony No. 5: Allegro con brio', 'Op. 67', 1808, 'symphony-5-1' UNION ALL
    SELECT 'beethoven', '교향곡 9번 4악장 환희의 송가', 'Symphony No. 9: Ode to Joy', 'Op. 125', 1824, 'ode-to-joy' UNION ALL
    SELECT 'beethoven', '비창 소나타 2악장', 'Piano Sonata No. 8 Pathetique: Adagio cantabile', 'Op. 13', 1799, 'pathetique-adagio' UNION ALL
    SELECT 'beethoven', '교향곡 6번 1악장', 'Symphony No. 6 Pastoral: Allegro ma non troppo', 'Op. 68', 1808, 'symphony-6-1' UNION ALL
    SELECT 'schubert', '미완성 교향곡 1악장', 'Symphony No. 8 Unfinished: Allegro moderato', 'D. 759', 1822, 'unfinished-symphony-1' UNION ALL
    SELECT 'schubert', '보리수', 'Der Lindenbaum', 'D. 911', 1827, 'der-lindenbaum' UNION ALL
    SELECT 'schumann', '트로이메라이', 'Traumerei', 'Op. 15 No. 7', 1838, 'traumerei' UNION ALL
    SELECT 'mendelssohn', '결혼 행진곡', 'A Midsummer Night''s Dream: Wedding March', 'Op. 61', 1842, 'wedding-march' UNION ALL
    SELECT 'mendelssohn', '바이올린 협주곡 e단조 1악장', 'Violin Concerto in E minor: Allegro molto appassionato', 'Op. 64', 1844, 'violin-concerto-e-minor-1' UNION ALL
    SELECT 'chopin', '강아지 왈츠', 'Waltz Op. 64 No. 1 (Minute Waltz)', 'Op. 64 No. 1', 1847, 'minute-waltz' UNION ALL
    SELECT 'chopin', '즉흥환상곡', 'Fantaisie-Impromptu', 'Op. 66', 1834, 'fantaisie-impromptu' UNION ALL
    SELECT 'chopin', '이별의 곡', 'Etude Op. 10 No. 3 (Tristesse)', 'Op. 10 No. 3', 1832, 'etude-op10-3' UNION ALL
    SELECT 'liszt', '라 캄파넬라', 'La campanella', 'S. 141 No. 3', 1851, 'la-campanella' UNION ALL
    SELECT 'liszt', '사랑의 꿈 3번', 'Liebestraum No. 3', 'S. 541 No. 3', 1850, 'liebestraum-3' UNION ALL
    SELECT 'brahms', '헝가리 무곡 5번', 'Hungarian Dance No. 5', 'WoO 1 No. 5', 1869, 'hungarian-dance-5' UNION ALL
    SELECT 'brahms', '자장가', 'Wiegenlied', 'Op. 49 No. 4', 1868, 'brahms-lullaby' UNION ALL
    SELECT 'brahms', '교향곡 3번 3악장', 'Symphony No. 3: Poco allegretto', 'Op. 90', 1883, 'symphony-3-poco-allegretto' UNION ALL
    SELECT 'paganini', '카프리스 24번', 'Caprice No. 24', 'Op. 1 No. 24', 1817, 'caprice-24' UNION ALL
    SELECT 'verdi', '축배의 노래', 'La traviata: Brindisi', NULL, 1853, 'brindisi' UNION ALL
    SELECT 'verdi', '아이다 개선 행진곡', 'Aida: Triumphal March', NULL, 1871, 'triumphal-march' UNION ALL
    SELECT 'rossini', '윌리엄 텔 서곡', 'William Tell: Overture', NULL, 1829, 'william-tell-overture' UNION ALL
    SELECT 'puccini', '오 나의 아버지', 'Gianni Schicchi: O mio babbino caro', NULL, 1918, 'o-mio-babbino-caro' UNION ALL
    SELECT 'puccini', '공주는 잠 못 이루고', 'Turandot: Nessun dorma', NULL, 1926, 'nessun-dorma' UNION ALL
    SELECT 'bizet', '카르멘 서곡', 'Carmen: Prelude', NULL, 1875, 'carmen-prelude' UNION ALL
    SELECT 'bizet', '하바네라', 'Carmen: Habanera', NULL, 1875, 'habanera' UNION ALL
    SELECT 'saint-saens', '백조', 'The Carnival of the Animals: The Swan', NULL, 1886, 'the-swan' UNION ALL
    SELECT 'saint-saens', '죽음의 무도', 'Danse macabre', 'Op. 40', 1874, 'danse-macabre' UNION ALL
    SELECT 'offenbach', '천국과 지옥 서곡', 'Orpheus in the Underworld: Overture (Can-can)', NULL, 1858, 'can-can' UNION ALL
    SELECT 'strauss-ii', '푸른 도나우', 'An der schonen blauen Donau', 'Op. 314', 1867, 'blue-danube' UNION ALL
    SELECT 'smetana', '몰다우', 'Vltava', 'JB 1:112', 1874, 'vltava' UNION ALL
    SELECT 'dvorak', '신세계로부터 2악장', 'Symphony No. 9 From the New World: Largo', 'Op. 95', 1893, 'new-world-largo' UNION ALL
    SELECT 'dvorak', '유모레스크 7번', 'Humoresque No. 7', 'Op. 101 No. 7', 1894, 'humoresque-7' UNION ALL
    SELECT 'mussorgsky', '전람회의 그림 키예프의 대문', 'Pictures at an Exhibition: The Great Gate of Kiev', NULL, 1874, 'great-gate-of-kiev' UNION ALL
    SELECT 'rimsky-korsakov', '왕벌의 비행', 'Flight of the Bumblebee', NULL, 1900, 'flight-of-the-bumblebee' UNION ALL
    SELECT 'borodin', '폴로베츠인의 춤', 'Prince Igor: Polovtsian Dances', NULL, 1887, 'polovtsian-dances' UNION ALL
    SELECT 'tchaikovsky', '피아노 협주곡 1번 1악장', 'Piano Concerto No. 1: Allegro non troppo', 'Op. 23', 1875, 'piano-concerto-1-allegro' UNION ALL
    SELECT 'tchaikovsky', '1812년 서곡', '1812 Overture', 'Op. 49', 1880, 'overture-1812' UNION ALL
    SELECT 'tchaikovsky', '잠자는 숲속의 미녀 왈츠', 'The Sleeping Beauty: Waltz', 'Op. 66', 1889, 'sleeping-beauty-waltz' UNION ALL
    SELECT 'rachmaninoff', '종소리 전주곡', 'Prelude in C-sharp minor', 'Op. 3 No. 2', 1892, 'prelude-c-sharp-minor' UNION ALL
    SELECT 'faure', '파반느', 'Pavane', 'Op. 50', 1887, 'faure-pavane' UNION ALL
    SELECT 'elgar', '사랑의 인사', 'Salut d''amour', 'Op. 12', 1888, 'salut-damour' UNION ALL
    SELECT 'elgar', '님로드', 'Enigma Variations: Nimrod', 'Op. 36', 1899, 'nimrod' UNION ALL
    SELECT 'holst', '행성 목성', 'The Planets: Jupiter', 'Op. 32', 1916, 'jupiter' UNION ALL
    SELECT 'mahler', '교향곡 5번 아다지에토', 'Symphony No. 5: Adagietto', NULL, 1902, 'symphony-5-adagietto' UNION ALL
    SELECT 'gershwin', '랩소디 인 블루', 'Rhapsody in Blue', NULL, 1924, 'rhapsody-in-blue' UNION ALL
    SELECT 'prokofiev', '로미오와 줄리엣 기사들의 춤', 'Romeo and Juliet: Dance of the Knights', 'Op. 64', 1935, 'dance-of-the-knights'
) d ON d.composer_slug = c.slug;


-- ---------------------------------------------------------------------------
-- 작곡가 소개와 곡 한 줄 소개 (초고)
--
-- 쓸 때 지킨 원칙은 V2 와 같다. 널리 퍼졌지만 근거가 약한 이야기는 사실로
-- 쓰지 않고 '전해진다'로 돌렸다. 연도와 인명은 공개 자료와 대조해 고쳐 쓰는
-- 것을 전제로 한 초고다. AI 가 쓴 문장은 저작권 보호를 받지 못하므로 손을
-- 봐야 이 글이 누군가의 것이 된다.
-- ---------------------------------------------------------------------------

-- 작곡가
UPDATE composer SET bio = '이탈리아 베네치아의 작곡가이자 바이올리니스트. 사제 서품을 받았고 머리색 때문에 ''붉은 머리 사제''로 불렸다. 고아 소녀들을 가르치는 음악원에서 일하며 협주곡을 오백 곡 가까이 남겼다.' WHERE slug = 'vivaldi' AND bio IS NULL;
UPDATE composer SET bio = '독일에서 태어나 영국에서 활동한 작곡가. 이탈리아에서 오페라를 익힌 뒤 런던에 자리 잡았고 1727년 영국 시민이 되었다. 오페라가 인기를 잃은 뒤에는 영어 오라토리오로 방향을 틀었다.' WHERE slug = 'handel' AND bio IS NULL;
UPDATE composer SET bio = '독일의 오르간 연주자이자 작곡가. 뉘른베르크를 비롯한 여러 도시의 교회에서 일했고 코랄 전주곡과 푸가를 많이 썼다. 지금은 캐논 한 곡으로 이름이 알려져 있지만, 생전의 평판은 오르간 음악에서 나왔다.' WHERE slug = 'pachelbel' AND bio IS NULL;
UPDATE composer SET bio = '오스트리아의 작곡가. 에스테르하지 가문의 궁정 악장으로 삼십 년 가까이 일하며 교향곡을 백 곡 넘게 썼다. 교향곡과 현악 사중주의 틀을 다듬어 ''교향곡의 아버지''로 불린다. 모차르트와 가까웠고 한동안 베토벤을 가르쳤다.' WHERE slug = 'haydn' AND bio IS NULL;
UPDATE composer SET bio = '독일의 작곡가이자 음악 평론가. 손가락을 다쳐 피아니스트의 길을 접고 작곡과 비평으로 옮겼다고 알려져 있다. 1834년 음악 잡지를 창간했고, 1840년 피아니스트 클라라 비크와 결혼했다.' WHERE slug = 'schumann' AND bio IS NULL;
UPDATE composer SET bio = '독일의 작곡가이자 지휘자. 어린 나이부터 작품을 썼고, 1829년 바흐의 마태 수난곡을 백 년 만에 다시 무대에 올려 바흐 재발견의 계기를 만들었다. 서른여덟에 세상을 떴다.' WHERE slug = 'mendelssohn' AND bio IS NULL;
UPDATE composer SET bio = '헝가리 출신의 피아니스트이자 작곡가. 당대 최고의 연주자로 유럽 전역을 순회했고, 악보 없이 연주하는 방식으로도 이름을 날렸다. 교향시라는 장르를 만들어 냈으며 말년에는 성직자의 길에 들어섰다.' WHERE slug = 'liszt' AND bio IS NULL;
UPDATE composer SET bio = '독일 함부르크에서 태어나 빈에서 활동한 작곡가. 완벽주의가 심해 첫 교향곡을 이십 년 넘게 붙들고 있다가 마흔셋에 내놓았다. 바흐와 베토벤의 형식을 낭만주의 안에서 이어 갔다.' WHERE slug = 'brahms' AND bio IS NULL;
UPDATE composer SET bio = '이탈리아의 바이올리니스트이자 작곡가. 전례 없는 기교로 유럽을 놀라게 했고, 악마와 거래했다는 소문이 따라다녔다. 무반주 바이올린을 위한 24개의 카프리스는 지금도 기교의 시험대로 꼽힌다.' WHERE slug = 'paganini' AND bio IS NULL;
UPDATE composer SET bio = '이탈리아의 오페라 작곡가. 1842년 나부코의 성공으로 이름을 얻었고, 이탈리아 통일 운동의 시대와 겹쳐 국민적 인물이 되었다. 리골레토, 라 트라비아타, 아이다를 거쳐 일흔이 넘어서도 오텔로와 팔스타프를 썼다.' WHERE slug = 'verdi' AND bio IS NULL;
UPDATE composer SET bio = '이탈리아의 오페라 작곡가. 세비야의 이발사 같은 희극 오페라로 유럽을 휩쓸었으나, 1829년 윌리엄 텔을 마지막으로 오페라 작곡을 그만두었다. 이후 사십 년 가까이 살며 미식가로도 유명했다.' WHERE slug = 'rossini' AND bio IS NULL;
UPDATE composer SET bio = '이탈리아의 오페라 작곡가. 라 보엠, 토스카, 나비부인으로 베르디 이후 이탈리아 오페라의 중심에 섰다. 마지막 작품 투란도트를 끝내지 못하고 세상을 떠났고, 뒷부분은 제자 알파노가 마무리했다.' WHERE slug = 'puccini' AND bio IS NULL;
UPDATE composer SET bio = '프랑스의 작곡가. 아홉 살에 파리 음악원에 들어갔고, 1875년 오페라 카르멘을 초연했다. 반응은 엇갈렸고 그는 몇 달 뒤 서른여섯에 세상을 떠났다. 카르멘이 걸작으로 자리 잡은 것은 그 이후다.' WHERE slug = 'bizet' AND bio IS NULL;
UPDATE composer SET bio = '프랑스의 작곡가이자 오르간 연주자. 열 살에 피아노 독주회를 열었다. 교향곡, 협주곡, 오페라, 실내악을 가리지 않고 썼고 프랑스 음악계에서 오랫동안 중심 인물이었다.' WHERE slug = 'saint-saens' AND bio IS NULL;
UPDATE composer SET bio = '독일 쾰른에서 태어나 프랑스에서 활동한 작곡가. 첼리스트로 출발해 파리에서 오페레타라는 장르를 개척했다. 천국과 지옥, 호프만의 이야기가 대표작이다.' WHERE slug = 'offenbach' AND bio IS NULL;
UPDATE composer SET bio = '오스트리아 빈의 작곡가이자 지휘자. 왈츠와 폴카로 ''왈츠의 왕''이라 불렸다. 이름이 같은 아버지 요한 슈트라우스 1세도 작곡가였다. 박쥐 같은 오페레타도 남겼다.' WHERE slug = 'strauss-ii' AND bio IS NULL;
UPDATE composer SET bio = '체코의 작곡가로, 체코 국민 음악의 시조로 꼽힌다. 오페라 팔려 간 신부와 연작 교향시 나의 조국을 썼다. 1874년 무렵 청력을 잃었고, 나의 조국은 귀가 들리지 않는 상태에서 완성했다.' WHERE slug = 'smetana' AND bio IS NULL;
UPDATE composer SET bio = '체코의 작곡가. 푸줏간 집안에서 태어났다. 보헤미아 민속 음악을 바탕으로 교향곡과 실내악을 썼고, 1892년부터 삼 년간 뉴욕의 음악원 원장으로 미국에서 지냈다. 신세계로부터는 그 시기의 작품이다.' WHERE slug = 'dvorak' AND bio IS NULL;
UPDATE composer SET bio = '러시아의 작곡가로 ''러시아 5인조'' 가운데 한 사람. 관청에서 일하며 작곡했고, 민중의 말투를 음악에 옮긴 오페라 보리스 고두노프를 남겼다. 쉰이 되기 전에 세상을 떠났고 작품 다수가 미완이라 림스키코르사코프가 손질해 알렸다.' WHERE slug = 'mussorgsky' AND bio IS NULL;
UPDATE composer SET bio = '러시아의 작곡가로 ''5인조'' 가운데 한 사람. 해군 장교 출신이다. 관현악 편성의 대가여서 셰에라자데 같은 화려한 곡을 남겼고, 동료 작곡가들이 남긴 미완성 작품을 여러 편 마무리했다.' WHERE slug = 'rimsky-korsakov' AND bio IS NULL;
UPDATE composer SET bio = '러시아의 작곡가로 ''5인조'' 가운데 한 사람. 본업은 화학자로, 의학 학교에서 가르치며 틈틈이 작곡했다. 오페라 이고르 공은 끝내지 못했고, 림스키코르사코프와 글라주노프가 완성했다.' WHERE slug = 'borodin' AND bio IS NULL;
UPDATE composer SET bio = '프랑스의 작곡가이자 오르간 연주자. 파리 마들렌 성당의 오르간 연주자를 지냈고 1905년 파리 음악원 원장이 되었다. 가곡과 실내악, 레퀴엠으로 알려져 있다.' WHERE slug = 'faure' AND bio IS NULL;
UPDATE composer SET bio = '영국의 작곡가. 음악 교육을 정식으로 받지 못한 채 악기점을 하던 아버지 곁에서 음악을 익혔다. 1899년 수수께끼 변주곡으로 이름을 얻었고, 영국 관현악 음악의 위상을 끌어올렸다.' WHERE slug = 'elgar' AND bio IS NULL;
UPDATE composer SET bio = '영국의 작곡가. 오랫동안 여학교 음악 교사로 일하며 작곡했다. 1916년 무렵 완성한 관현악 모음곡 행성이 대표작으로, 이 곡 하나로 이름이 알려졌다.' WHERE slug = 'holst' AND bio IS NULL;
UPDATE composer SET bio = '보헤미아에서 태어나 빈에서 활동한 오스트리아 작곡가이자 지휘자. 빈 궁정 오페라 극장의 감독을 지냈다. 낮에는 지휘로 생계를 꾸리고 여름 휴가에 작곡하는 생활을 했다. 교향곡 아홉 곡과 가곡을 남겼다.' WHERE slug = 'mahler' AND bio IS NULL;
UPDATE composer SET bio = '미국의 작곡가. 뉴욕 브루클린의 러시아계 유대인 이민 가정에서 태어났다. 재즈와 클래식을 한데 엮어 랩소디 인 블루, 오페라 포기와 베스를 썼다. 서른여덟에 세상을 떠났다.' WHERE slug = 'gershwin' AND bio IS NULL;
UPDATE composer SET bio = '러시아의 작곡가이자 피아니스트. 혁명 뒤 서방에서 지내다 1930년대에 소련으로 돌아왔다. 로미오와 줄리엣, 피터와 늑대를 썼다. 1953년 3월 5일, 스탈린과 같은 날 세상을 떠났다.' WHERE slug = 'prokofiev' AND bio IS NULL;

-- 곡
UPDATE work SET summary = '원래는 바흐의 칸타타 BWV 147에 나오는 코랄이다. 지금 흔히 듣는 피아노 독주 편곡은 20세기에 영국의 피아니스트 마이라 헤스가 만들었다.' WHERE slug = 'jesu-joy' AND summary IS NULL;
UPDATE work SET summary = '자필 악보가 남아 있지 않다. 정말 바흐가 쓴 곡인지를 두고 학계의 의견이 갈린다. 오르간 곡이지만 1940년 영화 〈판타지아〉의 오케스트라 편곡으로 더 널리 알려졌다.' WHERE slug = 'toccata-fugue-d-minor' AND summary IS NULL;
UPDATE work SET summary = '곡 전체가 화음을 펼친 음형만으로 이루어져 있다. 1853년 구노가 이 위에 선율을 얹어 〈아베 마리아〉를 만들었다.' WHERE slug = 'wtc1-prelude-1' AND summary IS NULL;
UPDATE work SET summary = '바이올린, 비올라, 첼로를 각각 세 대씩 세운 현악 합주곡이다. 2악장은 악보에 화음 두 개만 적혀 있어서 그 사이를 연주자가 채운다.' WHERE slug = 'brandenburg-3' AND summary IS NULL;
UPDATE work SET summary = '〈사계〉의 각 곡에는 계절을 묘사한 소네트가 붙어 있다. 봄 1악장에서는 새소리와 시냇물, 먹구름 속의 천둥이 악기로 그려진다.' WHERE slug = 'spring-allegro' AND summary IS NULL;
UPDATE work SET summary = '독주 바이올린이 선율을 노래하는 동안 현악기가 피치카토로 창밖의 빗방울을 흉내 낸다. 소네트에는 난롯가에서 비를 바라보는 장면이 적혀 있다.' WHERE slug = 'winter-largo' AND summary IS NULL;
UPDATE work SET summary = '오라토리오 《메시아》의 합창으로, 헨델은 이 곡 전체를 3주 남짓 만에 썼다. 영국에서는 이 곡이 시작되면 청중이 일어서는 관습이 있다. 왕이 감동해 일어섰다는 이야기가 전해지지만 근거는 약하다.' WHERE slug = 'hallelujah' AND summary IS NULL;
UPDATE work SET summary = '오페라 《세르세》의 첫 아리아로, 페르시아 왕이 플라타너스 그늘에 바치는 노래다. ''라르고''라는 이름으로 알려졌지만 헨델이 적은 빠르기는 라르게토다.' WHERE slug = 'ombra-mai-fu' AND summary IS NULL;
UPDATE work SET summary = '여덟 음짜리 저음이 곡 내내 스물여덟 번 되풀이되고, 그 위에서 바이올린 셋이 같은 선율을 차례로 쫓아간다. 원래는 지그와 짝을 이루는 곡이었다.' WHERE slug = 'canon-in-d' AND summary IS NULL;
UPDATE work SET summary = '잔잔하게 흐르다가 갑자기 한 번 터지는 강한 화음으로 ''놀람''이라는 별명을 얻었다. 졸던 청중을 깨우려 했다는 이야기가 유명하지만, 하이든이 한 말로 전해지는 건 새로운 효과로 놀라게 하고 싶었다는 쪽이다.' WHERE slug = 'surprise-symphony-andante' AND summary IS NULL;
UPDATE work SET summary = '오페라의 선율이 서곡에는 하나도 나오지 않는다. 오로지 속도와 에너지만으로 막을 연다.' WHERE slug = 'figaro-overture' AND summary IS NULL;
UPDATE work SET summary = '모차르트의 교향곡 마흔한 곡 가운데 단조는 25번과 이 곡 두 곡뿐이다. 1788년 여름, 39번부터 41번까지 세 곡이 몇 주 안에 쓰였다.' WHERE slug = 'symphony-40-1' AND summary IS NULL;
UPDATE work SET summary = '《마술피리》 2막의 복수 아리아로, 소프라노가 높은 F까지 올라가는 것으로 악명 높다. 1791년 빈 초연 때 이 배역은 모차르트의 처형 요제파 호퍼가 맡았다고 전해진다.' WHERE slug = 'queen-of-the-night' AND summary IS NULL;
UPDATE work SET summary = '1967년 스웨덴 영화 〈엘비라 마디간〉에 쓰이면서 ''엘비라 마디간''이라는 별명이 붙었다. 모차르트가 붙인 이름이 아니다.' WHERE slug = 'piano-concerto-21-andante' AND summary IS NULL;
UPDATE work SET summary = '처음 네 음을 ''운명이 문을 두드리는 소리''라고 부르는 건 제자 쉰들러가 전한 말이다. 쉰들러의 증언은 믿기 어렵다는 것이 지금의 평가다.' WHERE slug = 'symphony-5-1' AND summary IS NULL;
UPDATE work SET summary = '실러의 시를 합창으로 부르는 마지막 악장으로, 주요 교향곡에 합창을 넣은 첫 사례다. 선율만 따로 유럽연합의 공식 찬가로 쓰인다.' WHERE slug = 'ode-to-joy' AND summary IS NULL;
UPDATE work SET summary = '''비창''은 월광과 달리 베토벤이 직접 붙인 제목이다. 출판 때 악보 표지에 〈그랑드 소나타 파테티크〉라고 적었다.' WHERE slug = 'pathetique-adagio' AND summary IS NULL;
UPDATE work SET summary = '''전원''은 베토벤이 직접 붙인 제목이고, 1악장에는 ''시골에 도착했을 때 느끼는 유쾌한 감정''이라는 부제가 달려 있다. 5번과 같은 1808년 12월 22일 연주회에서 초연되었다.' WHERE slug = 'symphony-6-1' AND summary IS NULL;
UPDATE work SET summary = '슈베르트는 두 악장을 완성하고 3악장은 스케치만 남긴 채 멈췄다. 왜 멈췄는지는 알려져 있지 않다. 악보는 친구에게 맡겨진 채 사십 년 넘게 잠들어 있다가 1865년에야 초연되었다.' WHERE slug = 'unfinished-symphony-1' AND summary IS NULL;
UPDATE work SET summary = '연가곡집 《겨울 나그네》 24곡 중 5번이다. 빌헬름 뮐러의 시에 붙인 곡이며, 슈베르트가 죽기 한 해 전에 나왔다.' WHERE slug = 'der-lindenbaum' AND summary IS NULL;
UPDATE work SET summary = '《어린이 정경》 13곡 중 7번이다. 어린이가 치라고 쓴 곡이 아니라 어른이 어린 시절을 돌아보는 곡이라고 슈만이 직접 밝혔다.' WHERE slug = 'traumerei' AND summary IS NULL;
UPDATE work SET summary = '《한여름 밤의 꿈》 부수 음악의 한 곡이다. 1858년 영국 빅토리아 공주의 결혼식에서 쓰이면서 결혼식 행진곡으로 굳었다.' WHERE slug = 'wedding-march' AND summary IS NULL;
UPDATE work SET summary = '독주 바이올린이 서주 없이 첫 마디부터 선율을 노래하며 시작한다. 악장 사이에 쉬지 않고 이어지고, 카덴차도 연주자에게 맡기지 않고 악보에 적어 두었다.' WHERE slug = 'violin-concerto-e-minor-1' AND summary IS NULL;
UPDATE work SET summary = '''1분 왈츠''의 ''분''은 시간이 아니라 ''작다''는 뜻이라는 설이 있다. 개가 제 꼬리를 쫓는 걸 보고 썼다는 ''강아지'' 이야기는 쇼팽이 남긴 말이 아니다.' WHERE slug = 'minute-waltz' AND summary IS NULL;
UPDATE work SET summary = '쇼팽은 생전에 이 곡을 출판하지 않았다. 사후인 1855년 친구 폰타나가 내놓으면서 지금의 제목이 붙었다.' WHERE slug = 'fantaisie-impromptu' AND summary IS NULL;
UPDATE work SET summary = '연습곡이지만 선율이 노래에 가깝다. 쇼팽이 이런 선율은 다시 쓰지 못할 거라고 말했다는 일화가 전해진다. ''이별의 곡''은 후대에 붙은 별명이다.' WHERE slug = 'etude-op10-3' AND summary IS NULL;
UPDATE work SET summary = '파가니니의 바이올린 협주곡 2번 3악장의 ''작은 종'' 주제를 리스트가 피아노로 옮겼다. 지금 연주되는 것은 1851년 개정판이다.' WHERE slug = 'la-campanella' AND summary IS NULL;
UPDATE work SET summary = '리스트가 먼저 같은 선율의 가곡을 쓰고, 그것을 피아노 독주로 고쳤다. 〈사랑의 꿈〉 세 곡이 모두 가곡을 피아노로 옮긴 것이다.' WHERE slug = 'liebestraum-3' AND summary IS NULL;
UPDATE work SET summary = '브람스가 작곡한 곡이 아니라 헝가리 집시 음악을 편곡한 것이다. 5번은 민속 선율로 알고 가져온 곡이 실은 켈러 벨러의 작품이어서 작곡가 표기를 두고 말이 있었다.' WHERE slug = 'hungarian-dance-5' AND summary IS NULL;
UPDATE work SET summary = '1868년 빈에서 알고 지내던 베르타 파버가 아이를 낳자 축하하며 보낸 곡이다.' WHERE slug = 'brahms-lullaby' AND summary IS NULL;
UPDATE work SET summary = '교향곡의 느린 악장 자리에 놓인 짧은 3악장으로, 첼로가 먼저 선율을 낸다. 1961년 영화 〈굿바이 어게인〉에 쓰이면서 대중에게 알려졌다.' WHERE slug = 'symphony-3-poco-allegretto' AND summary IS NULL;
UPDATE work SET summary = '주제와 열한 개의 변주, 종결부로 이루어진 무반주 바이올린 곡이다. 리스트, 브람스, 라흐마니노프가 같은 주제로 변주곡을 다시 썼다.' WHERE slug = 'caprice-24' AND summary IS NULL;
UPDATE work SET summary = '《라 트라비아타》 1막의 술자리 노래다. 1853년 베네치아 초연은 실패했고, 이듬해 고쳐 올린 무대에서 성공했다.' WHERE slug = 'brindisi' AND summary IS NULL;
UPDATE work SET summary = '수에즈 운하 개통을 기념해 쓴 곡이라는 말이 흔하지만 사실이 아니다. 카이로에 새로 짓는 오페라 극장을 위해 맡은 작품이고, 초연은 1871년 카이로에서 열렸다.' WHERE slug = 'triumphal-march' AND summary IS NULL;
UPDATE work SET summary = '서곡의 마지막 부분인 질주 대목이 특히 유명하다. 로시니는 1829년 이 오페라를 끝으로 서른일곱에 오페라 작곡을 그만두었다.' WHERE slug = 'william-tell-overture' AND summary IS NULL;
UPDATE work SET summary = '세 편의 단막 오페라 《일 트리티코》 중 《잔니 스키키》에 나온다. 딸이 연인과의 결혼을 허락해 달라고 아버지에게 조르는 아리아로, 3분이 채 되지 않는다.' WHERE slug = 'o-mio-babbino-caro' AND summary IS NULL;
UPDATE work SET summary = '푸치니는 《투란도트》를 끝내지 못하고 1924년에 세상을 떠났다. 1926년 초연에서 토스카니니는 푸치니가 쓴 데까지만 지휘하고 멈췄다고 전해진다.' WHERE slug = 'nessun-dorma' AND summary IS NULL;
UPDATE work SET summary = '서곡은 오페라 마지막 막에 나오는 투우 장면의 행진과 카르멘의 비극을 예고하는 선율을 이어 붙인 것이다.' WHERE slug = 'carmen-prelude' AND summary IS NULL;
UPDATE work SET summary = '하바네라는 쿠바에서 유행한 춤곡 리듬이다. 비제는 이 선율을 민요로 알고 가져왔는데 사실은 스페인 작곡가 이라디에르의 곡이어서, 나중에 악보에 출처를 밝혔다.' WHERE slug = 'habanera' AND summary IS NULL;
UPDATE work SET summary = '《동물의 사육제》 14곡 중 한 곡이다. 생상스는 이 모음곡을 생전에 출판하지 못하게 했지만 〈백조〉만은 예외로 두었다.' WHERE slug = 'the-swan' AND summary IS NULL;
UPDATE work SET summary = '한밤중 열두 시를 알리는 종소리로 시작한다. 죽음이 바이올린을 켠다는 설정이라 독주 바이올린이 E현을 반음 낮춰 불협화음을 낸다. 새벽 닭 울음은 오보에가 흉내 낸다.' WHERE slug = 'danse-macabre' AND summary IS NULL;
UPDATE work SET summary = '흔히 듣는 〈천국과 지옥〉 서곡은 오펜바흐가 쓴 것이 아니라 1860년 빈 공연 때 지휘자 카를 빈더가 오페레타의 선율을 이어 붙인 것이다.' WHERE slug = 'can-can' AND summary IS NULL;
UPDATE work SET summary = '처음에는 남성 합창단을 위한 곡이었다. 초연 반응은 신통치 않았고, 같은 해 파리 만국박람회에서 관현악 버전이 성공했다. 1968년 영화 〈2001 스페이스 오디세이〉에도 쓰였다.' WHERE slug = 'blue-danube' AND summary IS NULL;
UPDATE work SET summary = '연작 교향시 《나의 조국》 6곡 중 2번이다. 강의 두 발원지에서 시작해 프라하를 지나 흘러가는 모습을 그렸다. 스메타나는 이 곡을 쓸 때 이미 청력을 잃은 뒤였다.' WHERE slug = 'vltava' AND summary IS NULL;
UPDATE work SET summary = '드보르자크는 흑인 영가를 인용한 것이 아니라 그 정신을 살려 직접 선율을 썼다고 말했다. 제자 피셔가 1922년 가사를 붙여 〈꿈속의 고향〉이라는 노래로도 불린다.' WHERE slug = 'new-world-largo' AND summary IS NULL;
UPDATE work SET summary = '''유모레스크''는 변덕스럽고 가벼운 소품을 가리키는 장르 이름이다. 연작 여덟 곡 중 7번이 가장 많이 연주된다. 1894년 여름 보헤미아의 시골에서 썼다.' WHERE slug = 'humoresque-7' AND summary IS NULL;
UPDATE work SET summary = '요절한 화가 친구 하르트만의 유작 전시회에서 영감을 받아 쓴 피아노 모음곡의 마지막 곡이다. 그가 설계한 키예프의 대문은 실제로는 지어지지 않았다. 관현악 버전은 1922년 라벨의 편곡이다.' WHERE slug = 'great-gate-of-kiev' AND summary IS NULL;
UPDATE work SET summary = '오페라 《술탄 황제 이야기》에서 왕자가 벌로 변해 날아가는 장면의 간주곡이다. 원래는 오페라 한 장면을 잇는 짧은 곡이었다.' WHERE slug = 'flight-of-the-bumblebee' AND summary IS NULL;
UPDATE work SET summary = '오페라 《이고르 공》 2막의 춤곡이다. 보로딘이 오페라를 끝내지 못하고 세상을 떠나 림스키코르사코프와 글라주노프가 마무리했다. 1953년 뮤지컬 〈키스멧〉의 노래에 선율이 쓰이기도 했다.' WHERE slug = 'polovtsian-dances' AND summary IS NULL;
UPDATE work SET summary = '차이콥스키가 모스크바 음악원의 니콜라이 루빈시테인에게 먼저 보여 주었다가 연주할 수 없는 곡이라는 혹평을 들었다고 한다. 초연은 1875년 보스턴에서 열렸다.' WHERE slug = 'piano-concerto-1-allegro' AND summary IS NULL;
UPDATE work SET summary = '1812년 나폴레옹 군의 침공을 물리친 일을 기념하는 곡으로, 악보에 대포 소리가 지정되어 있다. 차이콥스키 본인은 이 곡이 시끄럽고 예술적 가치가 없다고 평했다.' WHERE slug = 'overture-1812' AND summary IS NULL;
UPDATE work SET summary = '발레 《잠자는 숲속의 미녀》 1막의 왈츠다. 1959년 디즈니 애니메이션에서 이 선율에 가사를 붙여 〈Once Upon a Dream〉이 되었다.' WHERE slug = 'sleeping-beauty-waltz' AND summary IS NULL;
UPDATE work SET summary = '라흐마니노프가 열아홉 살에 쓴 곡이다. 연주회마다 이 곡을 앙코르로 요구받아 훗날 몹시 싫증을 냈다고 한다.' WHERE slug = 'prelude-c-sharp-minor' AND summary IS NULL;
UPDATE work SET summary = '원래 관현악곡이고 합창은 선택 사항이다. 합창이 부르는 가사는 몽테스키우 백작이 썼고, 곡은 엘리자베트 그레퓔 백작부인에게 바쳐졌다.' WHERE slug = 'faure-pavane' AND summary IS NULL;
UPDATE work SET summary = '1888년 엘가가 약혼녀 캐럴라인 앨리스 로버츠에게 약혼 선물로 준 곡이다. 원제는 독일어 〈Liebesgruss〉이고 프랑스어 제목으로 출판되었다.' WHERE slug = 'salut-damour' AND summary IS NULL;
UPDATE work SET summary = '《수수께끼 변주곡》 9번으로, 엘가의 친구이자 출판사 편집자인 옌스를 그렸다. 독일어로 ''사냥꾼''이라는 성에서 성서 속 사냥꾼 니므롯의 이름을 땄다. 영국의 전몰자 추모 행사에서 자주 연주된다.' WHERE slug = 'nimrod' AND summary IS NULL;
UPDATE work SET summary = '《행성》 4번 〈쾌락의 신〉의 중간 선율을 홀스트가 나중에 영국의 애국 찬가 〈I Vow to Thee, My Country〉에 가져다 썼다.' WHERE slug = 'jupiter' AND summary IS NULL;
UPDATE work SET summary = '하프와 현악기만으로 연주한다. 영화 〈베니스에서의 죽음〉에 쓰이면서 널리 알려졌다. 아내 알마에게 보낸 사랑 고백이라는 해석은 지휘자 멩엘베르흐의 증언에서 나온 것이다.' WHERE slug = 'symphony-5-adagietto' AND summary IS NULL;
UPDATE work SET summary = '1924년 연주회 소식을 신문에서 보고서 급히 쓰기 시작한 곡이다. 첫머리의 클라리넷 글리산도는 연습 중 클라리넷 주자가 장난으로 넣은 것을 거슈윈이 살렸다고 전해진다.' WHERE slug = 'rhapsody-in-blue' AND summary IS NULL;
UPDATE work SET summary = '1935년에 완성한 발레 《로미오와 줄리엣》의 곡이다. 소련 극장에서 공연이 미뤄져 1938년 체코 브르노에서 초연되었다.' WHERE slug = 'dance-of-the-knights' AND summary IS NULL;

-- ---------------------------------------------------------------------------
-- 녹음 (유튜브 임베드)
--
-- 영상 ID(11자)를 아래 ''에 채우면 그 곡에 기본 녹음으로 붙는다. 비워 둔
-- 행은 건너뛴다(WHERE video_id <> ''). 영상 ID 는 기억에 의존해 채우지 않았다.
--
-- 이 파일은 push 해서 한 번 적용되고 나면 고칠 수 없다(체크섬). 채울 ID 는
-- push 전에 넣을 것. 나중에 붙이는 영상은 관리 화면에서 넣는다.
-- 연주자를 적으면 그대로 들어가고, 비우면 NULL 이다.
-- ---------------------------------------------------------------------------

INSERT INTO recording (work_id, source_type, youtube_id, performer, license, source_url, is_default, available, created_at)
SELECT w.id, 'YOUTUBE', v.video_id,
       NULLIF(v.performer, ''),
       'YouTube 임베드',
       'https://www.youtube.com/watch?v=' || v.video_id,
       TRUE, TRUE, CURRENT_TIMESTAMP
FROM work w
JOIN (
    --     곡 slug                              영상 ID (11자)   연주자
    SELECT 'jesu-joy' AS work_slug,                 'S6OgZCCoXWc' AS video_id,   '' AS performer UNION ALL
    SELECT 'toccata-fugue-d-minor',                 'ho9rZjlsyYY',               '' UNION ALL
    SELECT 'wtc1-prelude-1',                        'Dkt75juxvxw',               '' UNION ALL
    SELECT 'brandenburg-3',                         'EFRfcWKYZWc',               '' UNION ALL

    SELECT 'spring-allegro',                        'mFWQgxXM_b8',               '' UNION ALL
    SELECT 'winter-largo',                          'xc_yKk0k5XE',               '' UNION ALL

    SELECT 'hallelujah',                            'usfiAsWR4qU',               '' UNION ALL
    SELECT 'ombra-mai-fu',                          'TBMf3mcIGkw',               '' UNION ALL

    SELECT 'canon-in-d',                            'NlprozGcs80',               '' UNION ALL

    SELECT 'surprise-symphony-andante',             'lLjwkamp3lI',               '' UNION ALL

    SELECT 'figaro-overture',                       'ikQNFqVkNNc',               '' UNION ALL
    SELECT 'symphony-40-1',                         'l45DAuXYSIs',               '' UNION ALL
    SELECT 'queen-of-the-night',                    'RPUdN3xdpEA',               '' UNION ALL
    SELECT 'piano-concerto-21-andante',             'df-eLzao63I',               '' UNION ALL

    SELECT 'symphony-5-1',                          'evr7pgSsVoo',               '' UNION ALL
    SELECT 'ode-to-joy',                            'Wod-MudLNPA',               '' UNION ALL
    SELECT 'pathetique-adagio',                     '_6w2bmpZdxY',               '' UNION ALL
    SELECT 'symphony-6-1',                          'iMJPZ-mu-Ts',               '' UNION ALL

    SELECT 'unfinished-symphony-1',                 '5zNI5FgGzjA',               '' UNION ALL
    SELECT 'der-lindenbaum',                        'NKC2Q2ZEnVE',               '' UNION ALL

    SELECT 'traumerei',                             'cnSvUjwvZZs',               '' UNION ALL

    SELECT 'wedding-march',                         'l7_m1om82o4',               '' UNION ALL
    SELECT 'violin-concerto-e-minor-1',             'tT1qhGP1qSs',               '' UNION ALL

    SELECT 'minute-waltz',                          'YwAAosTb9O4',               '' UNION ALL
    SELECT 'fantaisie-impromptu',                   'fBA-38mzabs',               '' UNION ALL
    SELECT 'etude-op10-3',                          '8KopXqfZVXI',               '' UNION ALL

    SELECT 'la-campanella',                         '6ruHDWSNvB8',               '' UNION ALL
    SELECT 'liebestraum-3',                         'XvGQyJ-bzbo',               '' UNION ALL

    SELECT 'hungarian-dance-5',                     '3X9LvC9WkkQ',               '' UNION ALL
    SELECT 'brahms-lullaby',                        't894eGoymio',               '' UNION ALL
    SELECT 'symphony-3-poco-allegretto',            '1trE3ms3AGo',               '' UNION ALL

    SELECT 'caprice-24',                            'PZ307sM0t-0',               '' UNION ALL

    SELECT 'brindisi',                              'pu7zWrIMV_g',               '' UNION ALL
    SELECT 'triumphal-march',                       'AssDQbaIP_I',               '' UNION ALL

    SELECT 'william-tell-overture',                 'c7O91GDWGPU',               '' UNION ALL

    SELECT 'o-mio-babbino-caro',                    '0Wlcr2bIKmk',               '' UNION ALL
    SELECT 'nessun-dorma',                          'dTkTObFQ_40',               '' UNION ALL

    SELECT 'carmen-prelude',                        'Afo76Yfib-0',               '' UNION ALL
    SELECT 'habanera',                              'EcFJTc28soQ',               '' UNION ALL

    SELECT 'the-swan',                              '9cNQFB0TDfY',               '' UNION ALL
    SELECT 'danse-macabre',                         'YyknBTm_YyM',               '' UNION ALL

    SELECT 'can-can',                               '4Diu2N8TGKA',               '' UNION ALL

    SELECT 'blue-danube',                           'cKkDMiGUbUw',               '' UNION ALL

    SELECT 'vltava',                                '3ZJwlDPWEkg',               '' UNION ALL

    SELECT 'new-world-largo',                       'vnvcjEWeJq0',               '' UNION ALL
    SELECT 'humoresque-7',                          'mOmNVj1HDKQ',               '' UNION ALL

    SELECT 'great-gate-of-kiev',                    '6tKdf8isVPI',               '' UNION ALL

    SELECT 'flight-of-the-bumblebee',               'aYAJopwEYv8',               '' UNION ALL

    SELECT 'polovtsian-dances',                     '5yIiHzMN1kQ',               '' UNION ALL

    SELECT 'piano-concerto-1-allegro',              'yI4Cpo29dao',               '' UNION ALL
    SELECT 'overture-1812',                         'VbxgYlcNxE8',               '' UNION ALL
    SELECT 'sleeping-beauty-waltz',                 '2Sb8WCPjPDs',               '' UNION ALL

    SELECT 'prelude-c-sharp-minor',                 'wXQCPAR0EHo',               '' UNION ALL

    SELECT 'faure-pavane',                          'mpgyTl8yqbw',               '' UNION ALL

    SELECT 'salut-damour',                          'ecM7_3rs5gU',               '' UNION ALL
    SELECT 'nimrod',                                'CbfUl9Pxnas',               '' UNION ALL

    SELECT 'jupiter',                               'Gu77Vtja30c',               '' UNION ALL

    SELECT 'symphony-5-adagietto',                  'Les39aIKbzE',               '' UNION ALL

    SELECT 'rhapsody-in-blue',                      'GbJede-o6gM',               '' UNION ALL

    SELECT 'dance-of-the-knights',                  'bBsKplb2E6Q',               ''
) v ON v.work_slug = w.slug
WHERE v.video_id <> '';


-- ---------------------------------------------------------------------------
-- 곡 스토리 (초고)
--
-- 곡 페이지에 실리는 긴 글이다. 비어 있을 때만 쓴다. 근거가 약한 이야기는
-- 사실로 쓰지 않고 '전해진다'로 돌렸지만, 연도·인명·일화는 공개 전에 한 번
-- 대조해서 고쳐 쓰는 것을 전제로 한 초고다.
-- ---------------------------------------------------------------------------

UPDATE work SET story = '바흐가 라이프치히에서 1723년에 고쳐 펴낸 칸타타 BWV 147 《마음과 입과 행동과 생명으로》는 두 부분으로 나뉜다. 이 곡은 그 두 부분을 각각 맺는 같은 코랄이다. 선율은 바흐가 지은 것이 아니라 17세기의 코랄에서 가져온 것이고, 바흐는 그 아래에 새 반주를 깔았다.

반주의 3연음은 쉬지 않고 흐르고 선율은 그 위에서 천천히 걷는다. 한 곡 안에서 두 속도가 따로 움직인다.

지금 흔히 듣는 피아노 독주는 칸타타 원곡이 아니다. 20세기 영국의 피아니스트 마이라 헤스가 1926년에 편곡해 퍼뜨린 것이다.' WHERE slug = 'jesu-joy' AND story IS NULL;

UPDATE work SET story = '가장 유명한 오르간 곡이지만 가장 확실하지 않은 바흐 작품이기도 하다. 바흐의 자필 악보는 남아 있지 않고 후대의 필사본만 전한다. 1980년대 이후 일부 학자가 바흐의 곡이 아닐 수 있다고, 원래 바이올린 곡이었을 가능성도 있다고 주장했다. 아직 결론은 나지 않았다.

곡은 분명하다. 한 음에서 시작해 오르간 전체를 휘젓는 첫 악구, 그 뒤에 이어지는 빠른 푸가. 이 곡을 ''무서운 음악''으로 기억하게 된 데는 영화의 영향이 크다. 1940년 디즈니의 〈판타지아〉는 지휘자 스토코프스키의 관현악 편곡으로 영화의 첫 곡을 삼았다.

바흐가 썼는지 확실치 않은 곡이 오늘날 바흐의 얼굴이 되어 있다.' WHERE slug = 'toccata-fugue-d-minor' AND story IS NULL;

UPDATE work SET story = '《평균율 클라비어곡집》 1권은 1722년에 완성한 곡집이다. 열두 음 모두를 으뜸음으로 삼아 장조와 단조의 프렐류드와 푸가를 한 쌍씩, 모두 스물네 쌍을 담았다. 그 첫 곡이 C장조 프렐류드다.

선율이 없다. 화음을 한 음씩 펼친 같은 음형을 한 마디에 두 번씩 되풀이하는 서른다섯 마디가 전부다.

1853년 프랑스의 구노는 이 반주를 그대로 두고 그 위에 선율을 얹었다. 나중에 그 선율에 〈아베 마리아〉 가사가 붙었다. 바흐의 화음이 새 선율을 받쳐 줄 만큼 이미 완결되어 있었다는 뜻이다.' WHERE slug = 'wtc1-prelude-1' AND story IS NULL;

UPDATE work SET story = '《브란덴부르크 협주곡》 여섯 곡은 바흐가 1721년 브란덴부르크 변경백에게 바친 악보집이다. 그중 3번은 편성이 독특하다. 바이올린, 비올라, 첼로를 세 대씩 세 그룹으로 나누고 저음 악기를 더했다. 세 그룹이 같은 악구를 서로 주고받는다.

2악장은 느린 악장이라고 부르기도 어렵다. 악보에 화음이 두 개만 적혀 있다. 그 사이를 어떻게 채울지는 연주자가 정한다. 짧은 즉흥 악구를 넣기도 하고, 다른 곡의 느린 악장을 끼우기도 하고, 두 화음만 치고 넘어가기도 한다.

> 바흐는 이 악장을 비워 두었다.
> 왜 비워 두었는지는 전해지지 않는다.' WHERE slug = 'brandenburg-3' AND story IS NULL;

UPDATE work SET story = '《사계》는 네 곡의 바이올린 협주곡이고, 곡마다 그 계절을 그린 소네트가 악보에 붙어 있다. 소네트의 작자가 비발디 본인이라는 설이 있다. 이 곡들은 1725년 무렵 암스테르담에서 출판된 협주곡집 《화성과 창의의 시도》의 첫 네 곡이다.

봄 1악장은 소네트의 순서를 그대로 소리로 옮긴다. 봄이 왔다고 새들이 노래하고, 샘물이 흐르고, 먹구름이 몰려와 천둥이 치고, 폭풍이 지나면 새들이 돌아온다. 새소리는 독주와 위쪽 바이올린들이 트릴로 흉내 낸다.

묘사를 음악의 틀 안에 넣은 초기의 사례로 자주 꼽힌다.' WHERE slug = 'spring-allegro' AND story IS NULL;

UPDATE work SET story = '겨울 2악장은 《사계》에서 가장 짧고 가장 조용하다. 악보에 붙은 소네트는 난롯가에서 평온한 날을 보내며 창밖에 내리는 비를 바라보는 장면을 그린다.

음악이 그 장면을 정확히 옮긴다. 독주 바이올린이 길고 따뜻한 선율을 노래하고, 위쪽 바이올린들은 현을 손가락으로 퉁기는 피치카토로 빗방울을 흉내 낸다.

앞뒤 악장이 이가 부딪히고 발을 구르는 추위라면 이 악장은 그 추위에서 잠깐 벗어난 방 안이다. 빠른 악장 사이에 느린 악장을 끼우는 협주곡의 틀이 장면 전환을 겸한다.' WHERE slug = 'winter-largo' AND story IS NULL;

UPDATE work SET story = '《메시아》는 1741년 8월 말부터 9월 중순까지 3주 남짓 만에 썼다고 전해진다. 1742년 4월 더블린에서 초연되었고 자선 공연이었다. 성경 말씀을 오락 무대에 올린다는 반발이 있어서 런던 초연은 이듬해로 미뤄졌다.

할렐루야는 마지막 곡이 아니다. 3부로 이루어진 오라토리오에서 2부를 맺는 합창이다.

영국에는 이 합창이 시작되면 청중이 일어서는 관습이 있다. 1743년 런던 공연에서 국왕 조지 2세가 감동해 일어섰기 때문이라고 하지만, 그 일을 당시에 기록한 문서는 확인되지 않는다.' WHERE slug = 'hallelujah' AND story IS NULL;

UPDATE work SET story = '1738년 런던에서 초연된 오페라 《세르세》의 첫 아리아다. 페르시아의 왕 세르세가 플라타너스 그늘 아래에서 노래한다. 나무 그늘이 이렇게 사랑스럽고 부드러웠던 적은 없었다는 내용이다. 오페라의 첫머리를 여는 노래가 나무에 바치는 찬가라는 점이 이 오페라의 반쯤 희극적인 성격을 알려 준다.

헨델이 악보에 적은 빠르기는 라르고가 아니라 라르게토다. ''헨델의 라르고''라는 이름은 후대 편곡으로 퍼졌다.

오페라는 한동안 인기를 얻지 못했고 오랫동안 잊혔다. 이 아리아가 오페라보다 오래 살아남았다.' WHERE slug = 'ombra-mai-fu' AND story IS NULL;

UPDATE work SET story = '파헬벨의 캐논은 오늘날 가장 자주 연주되는 바로크 곡 중 하나지만, 원래는 〈캐논과 지그〉라는 한 쌍의 곡이었다. 지그는 거의 연주되지 않는다. 언제 썼는지도 정확하지 않다. 1680년 무렵으로 추정할 뿐이다.

구조는 단순하다. 여덟 음의 저음이 곡 내내 스물여덟 번 되풀이되고, 그 위에서 바이올린 셋이 같은 선율을 차례로 쫓아간다. 선율은 돌아올 때마다 조금씩 빨라지고 잘게 쪼개진다.

이 곡이 대중에게 널리 알려진 것은 20세기 후반이다. 1968년 파야르 실내관현악단의 음반 이후로 퍼졌다고 알려져 있다.' WHERE slug = 'canon-in-d' AND story IS NULL;

UPDATE work SET story = '하이든은 1791년과 1794년 두 차례 런던에 가서 교향곡 열두 곡을 썼다. 94번은 첫 방문 때의 곡이고 1792년 3월 런던에서 초연되었다. 별명은 2악장에서 나왔다.

2악장은 아주 단순한 선율을 약하게 시작해 반복한다. 그러다 갑자기 모든 악기가 최강음으로 한 번 터진다.

졸고 있던 청중을 깨우려는 장난이라는 이야기가 유명하다. 하이든이 한 말로 전해지는 것은 다르다. 새로운 효과로 청중을 놀라게 하고 싶었다는 쪽이다.

> 놀람은 이 악장에서 가장 짧은 부분이다.
> 그 뒤에는 변주가 이어진다.' WHERE slug = 'surprise-symphony-andante' AND story IS NULL;

UPDATE work SET story = '《피가로의 결혼》은 보마르셰의 희곡에서 왔다. 이 희곡은 귀족을 조롱한다는 이유로 빈에서 상연이 금지된 상태였다. 대본가 다 폰테는 회고록에서 정치적인 대목을 덜어 낸 대본으로 황제 요제프 2세의 허락을 받아 냈다고 적었다. 오페라는 1786년 5월 빈에서 초연되었다.

서곡에는 오페라의 선율이 하나도 나오지 않는다. 낮게 소곤대듯 시작한 현악기가 속도를 올리고 관악기가 합류하면서 폭발한다. 하루 사이에 벌어지는 소동을 그린 오페라의 예고편이다.' WHERE slug = 'figaro-overture' AND story IS NULL;

UPDATE work SET story = '1788년 여름, 모차르트는 교향곡 세 곡(39, 40, 41번)을 몇 주 사이에 썼다. 왜 썼는지는 알려져 있지 않다. 위촉이나 연주 기록이 확실하지 않아서 세 곡이 생전에 연주되었는지도 분명치 않다.

40번은 그중 단조의 곡이다. 모차르트의 교향곡 마흔한 곡 가운데 단조는 25번과 이 곡 둘뿐이다.

1악장은 반주가 한 마디 먼저 시작되고 그 위로 바이올린이 첫 선율을 얹는다. 처음 들으면 이미 진행 중인 음악 한가운데에 들어선 느낌이다. 모차르트는 나중에 클라리넷을 더한 개정판도 만들었다.' WHERE slug = 'symphony-40-1' AND story IS NULL;

UPDATE work SET story = '《마술피리》는 1791년 9월 빈 교외의 극장에서 초연되었고, 모차르트는 그 두 달 뒤 세상을 떠났다. 밤의 여왕의 두 번째 아리아 〈지옥의 복수가 내 마음속에 끓고〉는 딸 파미나에게 단검을 쥐여 주며 복수를 명하는 장면이다.

이 곡이 어려운 까닭은 높은 F까지 올라가는 빠르고 정확한 음형 때문이다. 초연에서 이 배역을 맡은 사람은 모차르트의 처형 요제파 호퍼였다. 작곡가가 아는 가수의 음역에 맞춰 쓴 곡이다.

분노를 표현하는 방법으로 모차르트는 크게 지르는 소리 대신 가장 높고 가장 정밀한 소리를 골랐다.' WHERE slug = 'queen-of-the-night' AND story IS NULL;

UPDATE work SET story = '협주곡 21번은 1785년 3월 빈에서 모차르트가 직접 피아노를 치며 초연했다. 2악장은 현악기에 약음기를 끼우고, 피아노가 느리고 단순한 선율을 노래한다.

''엘비라 마디간''이라는 별명은 모차르트와 무관하다. 1967년 스웨덴 영화 〈엘비라 마디간〉이 이 악장을 쓰면서 붙었다. 영화는 19세기 말 덴마크 군인과 곡예사의 비극을 그렸고, 그 뒤로 이 선율에는 영화의 장면이 따라붙었다.

모차르트의 악보에는 사랑이 무엇이라고 적혀 있지 않다. 안단테라고만 적혀 있다.' WHERE slug = 'piano-concerto-21-andante' AND story IS NULL;

UPDATE work SET story = '''운명이 문을 두드리는 소리''라는 설명은 베토벤의 제자였던 안톤 쉰들러가 전한 이야기다. 쉰들러는 베토벤의 사후에 전기를 썼는데, 대화 수첩에 글을 써넣어 꾸미는 등의 위조가 나중에 밝혀졌다. 이 일화를 그대로 믿는 연구자는 드물다.

음악 자체는 분명하다. 네 음으로 이루어진 짧은 동기가 악장 전체를 끌고 간다. 동기가 끝나면 쉼표가 놓이고, 같은 동기가 한 단계 아래에서 되풀이된다.

초연은 1808년 12월 22일 빈에서 네 시간 가까이 이어진 연주회였다. 같은 날 교향곡 6번도 초연되었다. 난방이 안 된 극장에서 연주자들이 충분히 연습하지 못했다고 전해진다.' WHERE slug = 'symphony-5-1' AND story IS NULL;

UPDATE work SET story = '교향곡 9번은 1824년 5월 빈에서 초연되었다. 4악장에서 처음으로 합창과 독창이 등장한다. 교향곡에 사람의 목소리를 넣은 것은 큰 사건이었다. 가사는 실러의 시 〈환희에 부쳐〉에서 베토벤이 골라 엮은 것이다.

선율은 저음 현악기가 소리 없이 낮게 시작하고, 악기가 하나씩 늘어난 뒤에야 노래가 들어온다.

초연 때 베토벤은 청력을 거의 잃은 상태였다. 지휘는 따로 있었고 그는 무대에서 박자를 확인했다. 연주가 끝나고도 박수를 알아채지 못하자 독창자가 그를 청중 쪽으로 돌려세웠다는 이야기가 전해진다.

이 선율은 1985년 유럽 공동체(지금의 유럽연합)의 공식 찬가가 되었다. 가사 없이 연주한다.' WHERE slug = 'ode-to-joy' AND story IS NULL;

UPDATE work SET story = '''비창''은 월광과 달리 베토벤이 직접 붙인 제목이다. 소나타 8번은 1799년 빈에서 출판되었고, 악보 표지에 〈그랑드 소나타 파테티크〉라고 적혀 있었다.

2악장은 소나타 한가운데에 놓인 느린 악장이다. 왼손이 일정한 걸음으로 반주하는 동안 오른손이 노래한다. 노래가 한 번 나온 뒤 다른 선율이 지나가고 다시 노래로 돌아오는 구조가 거듭된다.

이 선율을 알아본 대중음악도 있다. 1983년 빌리 조엘은 〈This Night〉의 선율을 이 악장에서 가져왔다고 밝혔다.' WHERE slug = 'pathetique-adagio' AND story IS NULL;

UPDATE work SET story = '''전원''은 베토벤이 직접 붙인 제목이다. 그는 이 교향곡의 스케치에 ''묘사라기보다는 감정의 표현''이라고 적었다고 전해진다. 1악장에는 ''시골에 도착했을 때 느끼는 유쾌한 감정''이라는 부제가 달려 있다.

베토벤은 빈 교외의 숲과 들판을 오래 걸었다. 이 악장에는 사건이 없다. 같은 짧은 악구가 조금씩 높이를 바꿔 반복되며 편안하게 진행된다.

5번과 같은 1808년 12월 22일 연주회에서 초연되었다. 같은 날 같은 연주회에 운명과 전원이 함께 올랐다.' WHERE slug = 'symphony-6-1' AND story IS NULL;

UPDATE work SET story = '1822년 슈베르트는 교향곡 B단조에 착수해 두 악장을 완성했다. 3악장은 피아노 스케치와 관현악 몇 마디만 남기고 멈췄다. 왜 멈췄는지는 알려져 있지 않고, 설은 여럿이다.

악보는 슈베르트가 친구 안젤름 휘텐브레너에게 건넸고, 그가 오랫동안 간직하고 있었다. 1865년 지휘자 헤르베크가 찾아내 그해 12월 빈에서 초연했다. 슈베르트가 죽고 서른일곱 해가 지난 뒤였다.

1악장은 저음 현악기가 낮게 먼저 시작하고, 이어 오보에와 클라리넷이 노래한다. 끝나지 않은 곡이라는 별명이 붙었지만, 남은 두 악장은 어느 쪽도 부족해 들리지 않는다.' WHERE slug = 'unfinished-symphony-1' AND story IS NULL;

UPDATE work SET story = '《겨울 나그네》는 빌헬름 뮐러의 시 스물네 편에 붙인 연가곡집이다. 슈베르트가 1827년에 썼고 그는 이듬해에 세상을 떠났다. 실연한 청년이 한겨울에 마을을 떠나 걷는 이야기다. 〈보리수〉는 그 5번이다.

노랫말은 성문 앞 우물가의 보리수를 떠올린다. 나무 그늘에서 단꿈을 꾸고 껍질에 사랑의 말을 새기던 기억이다. 청년은 한밤에 그 곁을 지나고, 나무가 ''여기 와서 쉬라''고 부르는 것 같다. 그는 눈을 꼭 감고 지나친다.

한국에서 ''성문 앞 우물 곁에''로 아는 노래는 슈베르트의 원곡이 아니라 질허가 합창용으로 단순하게 편곡한 것이다.' WHERE slug = 'der-lindenbaum' AND story IS NULL;

UPDATE work SET story = '《어린이 정경》은 1838년에 쓴 열세 곡의 피아노 소품집이다. 슈만은 클라라에게 보낸 편지에서 이 곡집을 어른이 어른을 위해 쓴, 어린 시절을 돌아보는 음악이라고 설명했다. 아이에게 쳐 주려는 곡이 아니다.

트로이메라이는 열세 곡 중 7번, 한가운데에 놓인다. 제목은 ''꿈''이라는 뜻의 독일어다. 선율이 한 걸음씩 올라갔다 가라앉기를 되풀이하고, 곡 전체가 느슨한 한 번의 호흡처럼 흐른다.

피아노 소품이지만 연주하기는 쉽지 않다. 느리고 단순한 곡일수록 소리의 높낮이를 속일 수가 없다.' WHERE slug = 'traumerei' AND story IS NULL;

UPDATE work SET story = '멘델스존은 열일곱 살이던 1826년 셰익스피어의 《한여름 밤의 꿈》에 붙인 서곡을 썼다. 열여섯 해 뒤인 1842년 프로이센 왕 프리드리히 빌헬름 4세의 위촉으로 나머지 부수 음악을 썼다. 결혼 행진곡은 이때 쓴 곡으로, 극중 두 쌍의 결혼을 축하하는 장면에서 나온다.

이 곡이 결혼식의 곡이 된 계기로 자주 거론되는 일은 1858년 1월이다. 영국의 공주 빅토리아가 프로이센의 왕자와 결혼하는 식에서 이 곡이 퇴장 행진곡으로 연주되었다. 입장곡은 바그너의 《로엔그린》에서 가져온 결혼의 합창이었다.

한 장면 속의 행진이 한 나라의 결혼식으로 퍼졌다.' WHERE slug = 'wedding-march' AND story IS NULL;

UPDATE work SET story = '1838년 멘델스존은 친구인 바이올리니스트 페르디난트 다비드에게 협주곡을 쓰겠다고 편지했다. 곡은 6년 뒤인 1844년에 완성되었고 1845년 3월 라이프치히에서 다비드의 독주로 초연되었다.

이 곡에는 관례를 거스르는 점이 세 가지 있다. 오케스트라가 먼저 길게 주제를 소개하는 관례를 버리고, 독주 바이올린이 둘째 마디부터 선율을 노래한다. 카덴차는 연주자의 즉흥에 맡기지 않고 작곡가가 직접 악보에 적어 전개부 끝에 넣었다. 그리고 세 악장이 쉬지 않고 이어진다.

연주자가 지켜 주어야 할 자리를 작곡가가 먼저 정해 둔 협주곡이다.' WHERE slug = 'violin-concerto-e-minor-1' AND story IS NULL;

UPDATE work SET story = 'Op. 64 No. 1의 ''Minute''은 시계의 분(分)이 아니라 프랑스어로 ''아주 작은''을 뜻하는 말로 읽어야 한다는 설이 있다. 실제 연주 시간은 대체로 1분 반에서 2분이다.

''강아지 왈츠''라는 이름은 쇼팽의 연인 조르주 상드가 기르던 개가 제 꼬리를 쫓는 모습을 보고 쓴 곡이라는 이야기에서 나왔다. 이 이야기는 쇼팽이 남긴 말이 아니다. 곡이 출판된 1847년은 쇼팽과 상드가 결별하는 해이기도 하다.

한 손은 쉬지 않고 돌고, 다른 손은 가볍게 날아오른다. 빠르게 쳐야 하는 곡이라기보다 가볍게 쳐야 하는 곡이다.' WHERE slug = 'minute-waltz' AND story IS NULL;

UPDATE work SET story = '1834년에 쓴 곡인데 쇼팽은 생전에 이 곡을 출판하지 않았다. 악보는 그가 죽은 뒤인 1855년 친구 율리안 폰타나가 유작으로 펴냈고, 〈환상 즉흥곡〉이라는 제목도 그가 붙였다. 쇼팽은 죽기 전에 미발표 원고를 태워 달라고 부탁했다고 전해지고, 폰타나는 그 부탁을 따르지 않았다.

곡은 한 손이 네 개로, 다른 손이 세 개로 박을 나누는 데서 오는 어긋남이 핵심이다. 두 손이 서로 다른 속도로 흐르는 느낌을 만든다. 격렬한 바깥 부분 사이에 느리고 노래하는 중간부가 끼어 있다.

출판하지 않은 이유는 전해지지 않는다.' WHERE slug = 'fantaisie-impromptu' AND story IS NULL;

UPDATE work SET story = '《12개의 연습곡 Op. 10》은 1833년에 출판되었고 리스트에게 헌정되었다. 그중 3번은 느린 선율이 중심이지만 연습곡이다. 한 손으로 선율과 반주를 함께 치며 소리의 균형을 잡는 것이 과제다. 중간부에 이르면 갑자기 빨라지고 거칠어진다.

쇼팽이 제자에게 이렇게 아름다운 선율은 다시 쓰지 못할 거라고 말했다는 일화가 전해진다. 출처가 후대의 회고여서 곧이곧대로 믿기는 어렵다.

''이별의 곡''이라는 제목은 쇼팽이 붙인 것이 아니다. 영어권에서는 1939년의 노래 〈So Deep Is the Night〉로 이 선율이 알려졌다.' WHERE slug = 'etude-op10-3' AND story IS NULL;

UPDATE work SET story = '파가니니의 바이올린 협주곡 2번(1826) 마지막 악장의 론도는 작은 종이 울리는 듯한 음색 때문에 ''라 캄파넬라(작은 종)''라고 불렸다. 리스트는 1832년 파리에서 파가니니의 연주를 듣고 피아노로 같은 경지에 오르겠다고 결심했다고 전해진다.

이 곡을 처음 피아노로 옮긴 것이 1838년 판이고, 지금 연주되는 것은 1851년에 고쳐 《파가니니 대연습곡》 3번으로 낸 판이다.

어려운 부분은 높은 음 하나를 계속 두드리는 동안 손이 넓은 간격을 뛰어다니는 대목이다. 종소리를 흉내 내려면 그 한 음이 끝까지 맑아야 한다.' WHERE slug = 'la-campanella' AND story IS NULL;

UPDATE work SET story = '《사랑의 꿈》 세 곡은 원래 노래였다. 리스트는 1840년대 중반에 시인 울란트와 프라일리그라트의 시에 가곡을 붙였고, 1850년 그중 세 곡을 피아노 독주용으로 고쳐 펴냈다. 세 곡 중 널리 연주되는 것은 3번이다.

3번의 시는 프라일리그라트의 〈오 사랑하라, 사랑할 수 있는 동안〉이다. 사랑할 수 있는 동안 사랑하라는 말로 시작하고, 언젠가 사랑하던 이의 무덤 앞에서 후회할 날이 온다는 경고로 이어진다.

피아노 곡은 가사 없이 선율만 남았지만, 처음부터 그 경고 아래에서 쓰인 음악이다.' WHERE slug = 'liebestraum-3' AND story IS NULL;

UPDATE work SET story = '브람스는 1850년대에 헝가리 바이올리니스트 레메니와 순회 연주를 하며 집시풍 음악을 익혔다. 《헝가리 무곡》 21곡은 1869년부터 펴낸 피아노 연탄곡집이다. 브람스는 이 곡들에 작품 번호를 붙이지 않았다. 자기 창작이 아니라 편곡이라고 보았기 때문이다.

5번은 헝가리 작곡가 켈러 벨러의 차르다시에서 가져온 선율이다. 브람스는 이 선율을 민요로 알았다고 한다.

느리게 꺾였다가 갑자기 빨라지는 템포의 변화가 이 곡의 성격이다. 한 박자 안에서도 속도가 변한다.' WHERE slug = 'hungarian-dance-5' AND story IS NULL;

UPDATE work SET story = '1868년 브람스는 빈에서 알고 지낸 베르타 파버가 아들을 낳자 축하하는 뜻으로 이 노래를 보냈다. 브람스는 젊은 시절 함부르크에서 여성 합창단을 지도할 때 베르타를 알았다.

가사 첫 줄은 ''잘 자라, 편히 자라''라는 뜻이다. 선율은 베르타가 즐겨 부르던 빈의 왈츠 선율 일부를 바탕으로 했다고 전해진다. 반주에서는 그 선율이 느리게 늘어져 흐르고, 한 마디 안에서 흔들리는 요람의 박자가 된다.

곡은 3분이 채 되지 않는다. 한 아이를 위해 쓴 곡이 모든 아이의 자장가가 되었다.' WHERE slug = 'brahms-lullaby' AND story IS NULL;

UPDATE work SET story = '교향곡 3번은 1883년 12월 빈에서 한스 리히터의 지휘로 초연되었다. 리히터는 이 곡을 ''브람스의 에로이카''라고 불렀다고 한다. 브람스의 교향곡 중에서 유일하게 조용히 끝나는 곡이기도 하다.

3악장은 이 교향곡에서 가장 사적인 대목이다. 흔히 스케르초가 놓이는 자리에 빠른 춤곡 대신 느리고 쓸쓸한 노래가 놓였다. 첼로가 먼저 선율을 부르고, 호른이 이어받는다.

이 선율은 1961년 영화 〈굿바이 어게인〉에 쓰이면서 클래식 밖의 청중에게도 알려졌다.' WHERE slug = 'symphony-3-poco-allegretto' AND story IS NULL;

UPDATE work SET story = '《24개의 카프리스》는 무반주 바이올린을 위한 곡집이다. 24번은 마지막 곡으로, 짧은 주제와 열한 개의 변주, 종결부로 이루어져 있다. 주제는 단조의 단순한 선율이다.

이 선율은 다른 작곡가들에게 변주할 주제가 되었다. 리스트, 브람스, 라흐마니노프가 같은 주제로 곡을 썼다. 라흐마니노프의 《파가니니 주제 변주곡》은 이 사이트에도 있다.

파가니니는 생전에 악마와 거래했다는 소문이 따라다녔다. 한 대의 바이올린으로 낼 수 있는 소리의 수를 넓혀 놓은 사람이 그런 소문을 얻는 건 당연한 일이었다.' WHERE slug = 'caprice-24' AND story IS NULL;

UPDATE work SET story = '《라 트라비아타》는 뒤마 피스의 소설 《춘희》를 원작으로 한다. 1853년 3월 베네치아의 라 페니체 극장에서 초연되었으나 실패했다. 폐병으로 죽어 가는 여주인공을 맡은 소프라노가 건강한 체격이어서 청중이 웃었다는 이야기가 전해진다. 이듬해 다른 극장에서 고쳐 올린 무대에서 성공을 거뒀다.

〈축배의 노래〉는 1막 파티 장면에서 알프레도가 부른다. 그가 건배를 제안하는 노래이고, 곧 비올레타가 받아서 함께 부른다. 두 사람이 처음으로 같은 선율을 나눠 갖는 곡이다.

흥겨운 잔치의 노래지만, 이 오페라의 결말을 알고 들으면 다르게 들린다.' WHERE slug = 'brindisi' AND story IS NULL;

UPDATE work SET story = '《아이다》가 수에즈 운하 개통을 기념하려고 쓴 오페라라는 말이 흔하지만 사실이 아니다. 이집트 총독의 위촉으로 카이로에 새로 지은 오페라 극장에 올릴 작품이었고, 초연은 1871년 12월 카이로에서 열렸다. 베르디는 처음에는 위촉을 거절했다가 큰 보수 제안을 받고 수락했다고 전해진다.

〈개선 행진곡〉은 2막 장면에서 이집트 군대가 전쟁에서 이기고 돌아올 때 나온다. 베르디는 초연을 위해 긴 직선형 트럼펫을 따로 만들게 했다.

이 곡은 승리를 노래하지만 오페라 속에서 승리는 곧 누군가의 패배다.' WHERE slug = 'triumphal-march' AND story IS NULL;

UPDATE work SET story = '《윌리엄 텔》은 1829년 파리 오페라 극장에서 초연된 로시니의 마지막 오페라다. 로시니는 이때 서른일곱이었고 1868년에 죽을 때까지 서른아홉 해를 더 살았지만 오페라를 쓰지 않았다.

서곡은 네 부분으로 이루어진다. 새벽, 폭풍, 목동의 노래, 그리고 질주하는 마지막. 목동의 노래는 잉글리시 호른이 부르고 이어 플루트가 받는다.

마지막의 말발굽 소리 같은 질주는 미국의 서부극 〈론 레인저〉의 주제로 쓰이면서 더 널리 알려졌다. 서곡이 오페라 전체보다 오래 살아남은 경우다.' WHERE slug = 'william-tell-overture' AND story IS NULL;

UPDATE work SET story = '푸치니의 《잔니 스키키》는 세 편의 단막 오페라 《일 트리티코》 중 한 편으로, 1918년 12월 뉴욕 메트로폴리탄 오페라에서 초연되었다. 잔니 스키키는 단테의 《신곡》 지옥편에 나오는 인물이기도 하다.

이 아리아는 딸 라우레타가 부른다. 사랑하는 청년과 결혼하게 해 달라고 아버지에게 조르는 노래다. 허락해 주지 않으면 아르노 강에 몸을 던지겠다고 말한다.

3분이 채 되지 않는 이 노래는 오페라의 가장 진지한 대목이 아니다. 희극 오페라 한가운데에서 딸이 아버지를 설득하는 장면이다.' WHERE slug = 'o-mio-babbino-caro' AND story IS NULL;

UPDATE work SET story = '푸치니는 《투란도트》를 완성하지 못하고 1924년 11월에 세상을 떠났다. 1926년 4월 밀라노 라 스칼라에서 열린 초연에서 지휘자 토스카니니는 푸치니가 쓴 데까지만 연주하고 지휘봉을 내려놓았다고 전해진다. 그 뒤는 제자 알파노가 마무리한 판이다.

〈공주는 잠 못 이루고〉는 3막에서 왕자 칼라프가 부른다. 투란도트 공주가 밤새 그의 이름을 알아내라고 명령한 밤이다. 노래는 ''나는 이기리라''로 끝난다.

1990년 월드컵 때 파바로티가 부른 이 노래가 대회의 방송 주제곡으로 쓰이면서 오페라 밖에서도 유명해졌다.' WHERE slug = 'nessun-dorma' AND story IS NULL;

UPDATE work SET story = '《카르멘》은 1875년 3월 파리의 오페라코미크에서 초연되었다. 반응은 엇갈렸고, 비제는 석 달 뒤인 6월 서른여섯 살에 세상을 떠났다. 카르멘이 걸작으로 자리 잡은 것은 그의 사후다.

서곡은 오페라의 장면을 한데 모아 놓았다. 먼저 마지막 막의 투우장 앞 군중의 흥청거림, 다음으로 투우사의 행진 선율이 나오고, 끝에 이르러 분위기가 갑자기 바뀐다. 마지막에 오는 어두운 주제는 카르멘의 운명을 상징하는 선율이다.

즐거운 음악으로 시작해 불길한 예감으로 끝나는 서곡이다.' WHERE slug = 'carmen-prelude' AND story IS NULL;

UPDATE work SET story = '카르멘이 1막에서 처음 등장해 부르는 노래로, 가사는 ''사랑은 길들일 수 없는 새''로 시작한다. 하바네라는 쿠바에서 유행한 춤곡의 리듬이다.

비제는 이 선율을 민요로 알고 가져왔다고 한다. 실은 스페인 작곡가 이라디에르가 만든 노래 〈엘 아레글리토〉였고, 비제는 나중에 그 사실을 알고 악보에 출처를 밝혔다.

카르멘은 이 노래로 병사 돈 호세를 유혹하고, 노래의 마지막에 꽃을 던진다. 사랑은 규칙을 모르고 누구도 길들일 수 없다는 가사가 이 인물의 마지막까지 이어진다.' WHERE slug = 'habanera' AND story IS NULL;

UPDATE work SET story = '《동물의 사육제》는 1886년 사육제 기간에 친구들 앞에서 연주하려고 쓴 열네 곡의 모음곡이다. 생상스는 이 곡이 장난으로 쓴 곡이라서 진지한 작곡가의 명성에 흠이 될까 걱정했다고 전해진다. 그래서 생전에는 출판을 허락하지 않았다.

예외는 〈백조〉였다. 이 곡만은 생전에 출판을 허락했다. 나머지 열세 곡은 그가 세상을 떠난 뒤인 1922년에야 출판되었다.

첼로 한 대가 긴 선율을 노래하고, 두 대의 피아노가 잔물결 같은 반주를 깐다. 1905년 발레리나 파블로바가 이 곡에 맞춰 〈빈사의 백조〉를 추면서 곡의 인상이 더 굳었다.' WHERE slug = 'the-swan' AND story IS NULL;

UPDATE work SET story = '《죽음의 무도》는 앙리 카잘리스의 시에서 왔다. 한밤중에 죽음이 무덤에서 해골들을 불러 모아 새벽이 올 때까지 춤추게 한다는 이야기다. 생상스는 먼저 이 시에 붙인 노래를 썼고, 1874년 그것을 관현악 교향시로 고쳤다.

곡은 하프가 열두 번 울리는 자정의 종소리로 시작한다. 죽음이 연주하는 독주 바이올린은 E현을 반음 낮춰 일부러 불협화음을 낸다. 뼈가 부딪히는 소리는 실로폰이 맡는다. 관현악에서 실로폰이 눈에 띄게 쓰인 초기의 사례로 꼽힌다. 새벽 닭 울음은 오보에가 흉내 낸다.

1875년 초연에서 청중의 반응은 좋지 않았다고 한다.' WHERE slug = 'danse-macabre' AND story IS NULL;

UPDATE work SET story = '《지옥의 오르페우스》는 1858년 파리의 부프 파리지앵에서 초연된 오펜바흐의 오페레타다. 그리스 신화를 비틀고 당시 파리의 윤리를 조롱한 작품이다.

지금 흔히 듣는 서곡은 오펜바흐가 쓴 것이 아니다. 1860년 빈 공연 때 지휘자 카를 빈더가 오페레타의 선율을 모아 이어 붙인 것이다. 오펜바흐의 원래 서곡은 훨씬 짧았다.

캉캉으로 알려진 선율은 오페레타의 마지막 장면에 나오는 춤이다. 이 춤은 당시 파리에서 점잖지 못한 춤으로 여겨졌다.' WHERE slug = 'can-can' AND story IS NULL;

UPDATE work SET story = '〈푸른 도나우〉는 처음에는 관현악곡이 아니라 남성 합창과 피아노를 위한 곡이었다. 1867년 2월 빈 남성 합창협회가 초연했다. 1866년 프로이센과의 전쟁에서 오스트리아가 패한 직후라, 빈 사람들을 위로하려는 가사가 붙어 있었다. 초연 반응은 시원치 않았다.

그해 요한 슈트라우스가 파리 만국박람회에서 관현악 버전으로 연주하자 크게 성공했다. 지금은 가사 없는 관현악곡으로만 연주된다.

빈 신년 음악회는 이 곡으로 끝나는 것이 관례이고, 1968년 영화 〈2001 스페이스 오디세이〉에서 우주선이 움직이는 장면에 쓰이기도 했다.' WHERE slug = 'blue-danube' AND story IS NULL;

UPDATE work SET story = '〈몰다우〉는 스메타나가 1874년 말에 쓴 곡으로, 연작 교향시 《나의 조국》 여섯 곡 중 두 번째다. 스메타나는 그해 가을 청력을 완전히 잃었고, 이 연작은 소리를 듣지 못하는 상태에서 완성했다.

음악은 강의 여정을 따라간다. 두 개의 작은 샘에서 시작한 물이 합쳐지고, 숲의 사냥 소리와 농가의 결혼식 춤을 지나고, 달빛 아래 요정의 춤을 지나 급류를 건너 프라하에 이르러 비셰흐라드 요새 앞을 지나간다.

주된 선율은 이스라엘의 국가 〈하티크바〉와 닮았다. 두 선율은 모두 옛 유럽 민요에서 온 것으로 알려져 있다.' WHERE slug = 'vltava' AND story IS NULL;

UPDATE work SET story = '드보르자크는 1892년부터 3년 동안 뉴욕의 국립음악원 원장으로 지냈다. 교향곡 9번 〈신세계로부터〉는 그 시기인 1893년에 쓴 곡으로, 같은 해 12월 카네기 홀에서 초연되었다.

2악장의 유명한 선율은 잉글리시 호른이 부른다. 드보르자크는 흑인 영가나 인디언 선율을 인용한 것이 아니라 그 정신을 살려 직접 선율을 썼다고 말했다. 제자 해리 벌리가 흑인 영가를 불러 주었다고 알려져 있다.

1922년 제자 윌리엄 아람스 피셔가 이 선율에 가사를 붙여 〈꿈속의 고향〉이라는 노래로 불리기도 한다. 원곡에는 가사가 없다.' WHERE slug = 'new-world-largo' AND story IS NULL;

UPDATE work SET story = '《유모레스크》 Op. 101은 1894년 여름에 쓴 여덟 곡의 피아노 소품집이다. 드보르자크는 그해 여름 미국에서 돌아와 보헤미아의 시골 별장에서 지냈다. 7번은 그중 가장 널리 연주된다.

''유모레스크''는 변덕스럽고 가벼운 기분을 가리키는 소품의 이름이다. 반드시 웃긴 곡이라는 뜻은 아니다. 이 곡도 가벼운 익살과 쓸쓸한 선율이 번갈아 나온다.

곡은 장조로 시작하지만 뜻밖에 단조의 그늘이 드리운다. 이 변덕이 곡의 이름값이다.' WHERE slug = 'humoresque-7' AND story IS NULL;

UPDATE work SET story = '화가 빅토르 하르트만이 서른아홉에 세상을 떠나자 친구 무소륵스키는 그의 유작 전시회를 찾았다. 그 전시를 본 인상을 1874년 피아노 모음곡 《전람회의 그림》으로 썼다. 곡집은 그림 사이를 걷는 사람의 걸음, 〈프롬나드〉를 사이에 두고 이어진다.

〈키예프의 대문〉은 마지막 그림이다. 하르트만이 키예프의 성문 설계 공모에 낸 도안이었고, 그 대문은 실제로 지어지지 않았다.

피아노 원곡은 무소륵스키가 죽은 뒤인 1886년에 출판되었다. 지금 오케스트라로 자주 듣는 것은 1922년 라벨의 편곡이다.' WHERE slug = 'great-gate-of-kiev' AND story IS NULL;

UPDATE work SET story = '푸시킨의 동화를 바탕으로 한 오페라 《술탄 황제 이야기》는 1900년 모스크바에서 초연되었다. 이 곡은 막과 막 사이의 짧은 간주곡이다. 왕자 귀돈이 백조 공주의 마법으로 땅벌이 되어 날아가 못된 이모들을 쏘는 장면을 잇는다.

반음계로 오르내리는 빠른 음형이 윙윙거리는 날갯짓을 흉내 낸다. 림스키코르사코프는 이 곡을 연주 솜씨를 뽐내는 곡으로 쓰지 않았다. 단순한 간주곡이었다.

이후 여러 악기용으로 편곡되었고, 1930년대 라디오 드라마 〈그린 호넷〉의 주제로도 쓰였다.' WHERE slug = 'flight-of-the-bumblebee' AND story IS NULL;

UPDATE work SET story = '보로딘은 본업이 화학자였다. 오페라 《이고르 공》을 1869년에 시작해 십팔 년 동안 틈틈이 썼지만 1887년 세상을 떠날 때까지 끝내지 못했다. 림스키코르사코프와 글라주노프가 남은 부분을 정리하고 완성했다. 글라주노프는 서곡을 기억에 의존해 복원했다고 전해진다. 오페라는 1890년 상트페테르부르크에서 초연되었다.

〈폴로베츠인의 춤〉은 2막에서 포로가 된 이고르 공 앞에서 적진의 유목민들이 추는 춤이다. 느리고 동양적인 선율로 시작해 점점 거칠고 빨라진다.

1909년 파리에서 발레 뤼스가 이 춤을 무대에 올려 유럽에 알렸다. 1953년 뮤지컬 〈키스멧〉의 노래 〈Stranger in Paradise〉에도 이 선율이 쓰였다.' WHERE slug = 'polovtsian-dances' AND story IS NULL;

UPDATE work SET story = '1874년 크리스마스 이브, 차이콥스키는 모스크바 음악원의 니콜라이 루빈시테인에게 새 피아노 협주곡을 들려주었다. 차이콥스키 본인의 서술에 따르면 루빈시테인은 곡이 연주할 수 없고 쓸모없다고 혹평했다. 차이콥스키는 한 음도 고치지 않겠다고 답했고, 헌정 대상을 한스 폰 뷜로로 바꿨다.

초연은 1875년 10월 미국 보스턴에서 뷜로의 독주로 열렸다. 루빈시테인은 나중에 이 곡을 인정하고 직접 연주하기도 했다.

도입부의 큰 주제는 악장의 나머지 부분에서 다시 쓰이지 않는다. 그렇게 호화롭게 시작하고 한 번만 쓰고 버린 서주다.' WHERE slug = 'piano-concerto-1-allegro' AND story IS NULL;

UPDATE work SET story = '〈1812년 서곡〉은 1812년 나폴레옹의 러시아 침공을 물리친 일을 기념하는 곡이다. 모스크바의 구세주 그리스도 대성당 봉헌과 박람회를 위해 위촉받아 1880년에 썼고, 1882년 8월 모스크바에서 초연되었다.

악보에는 대포 소리가 지정되어 있다. 프랑스 국가 〈라 마르세예즈〉와 러시아 제국 국가가 서로 부딪히는 선율로 인용된다. 차이콥스키는 이 곡이 시끄럽고 예술적 가치가 없으며 열정 없이 썼다고 편지에 적었다.

오늘날 미국에서는 독립기념일 야외 연주회에서 대포와 불꽃놀이와 함께 연주되는 곡이 되었다.' WHERE slug = 'overture-1812' AND story IS NULL;

UPDATE work SET story = '발레 《잠자는 숲속의 미녀》는 1890년 1월 상트페테르부르크 마린스키 극장에서 초연되었다. 안무는 마리우스 프티파가 맡았다. 이 왈츠는 1막, 오로라 공주의 생일 잔치에서 정원 사람들이 꽃다발을 들고 추는 춤이다.

차이콥스키 발레 음악의 특징은 춤곡이 교향곡처럼 짜여 있다는 점이다. 이 왈츠도 단순한 반주가 아니라 선율이 앞에 선다.

1959년 디즈니는 애니메이션 〈잠자는 숲속의 공주〉에서 이 왈츠 선율에 가사를 붙여 〈Once Upon a Dream〉을 만들었다.' WHERE slug = 'sleeping-beauty-waltz' AND story IS NULL;

UPDATE work SET story = '라흐마니노프는 1892년 모스크바 음악원을 졸업하던 해, 열아홉 살에 이 곡을 썼다. 다섯 곡으로 이루어진 《환상적 소품집》 Op. 3의 두 번째 곡이다.

곡은 낮은 음 세 개의 무거운 걸음으로 시작한다. 가운데 부분에서 음악은 거칠게 부풀어 오르고, 마지막에 다시 낮게 가라앉는다. ''종소리 전주곡''이라는 별명이 붙었다.

이 곡은 너무 유명해져서 그의 짐이 되었다. 미국 순회 연주에서 청중이 어느 곡이든 이 곡을 앙코르로 요구했고, 라흐마니노프는 이 곡에 싫증을 냈다고 전해진다. 출판사에 곡을 넘길 때 받은 값이 일시불이어서 인기에 따른 수입도 얻지 못했다.' WHERE slug = 'prelude-c-sharp-minor' AND story IS NULL;

UPDATE work SET story = '파반느는 16세기 궁정에서 추던 느리고 장중한 춤이다. 포레는 1887년 이 옛 춤의 이름을 빌려 관현악곡을 썼다. 합창은 선택 사항이어서 합창 없이 연주되는 경우가 대부분이다.

곡은 엘리자베트 그레퓔 백작부인에게 헌정되었다. 포레를 후원한 파리 사교계의 중심 인물이다. 합창이 부르는 가사는 사촌인 시인 로베르 드 몽테스키우가 나중에 썼다.

플루트가 먼저 단순하고 조용한 선율을 부르고, 현악기의 피치카토가 조용히 발걸음을 이어 간다. 옛 춤의 걸음걸이만 남기고 장식은 걷어 냈다.' WHERE slug = 'faure-pavane' AND story IS NULL;

UPDATE work SET story = '엘가는 1888년 약혼녀 캐럴라인 앨리스 로버츠에게 이 곡을 약혼 선물로 주었다. 두 사람은 이듬해 결혼했다. 원래 악보에 적은 제목은 독일어 〈Liebesgruss〉였다.

엘가는 이 곡을 출판사 쇼트에 두 기니를 받고 넘겼다고 전해진다. 곡은 크게 성공했지만 그가 인세로 큰돈을 번 것은 아니었다.

선율은 단순하고 짧다. 바이올린과 피아노를 위한 소품으로 시작했고 관현악을 비롯한 여러 편성으로 편곡되었다.' WHERE slug = 'salut-damour' AND story IS NULL;

UPDATE work SET story = '《수수께끼 변주곡》(1899)은 엘가가 친구들을 한 사람씩 그려 낸 열네 곡의 변주곡이다. 각 변주에는 친구의 이니셜이나 별명이 붙어 있다. ''수수께끼''란 변주의 바탕이 된 주제 뒤에 감춰진 또 하나의 선율이 있다고 엘가가 말한 데서 나왔다. 그 선율이 무엇인지는 엘가가 밝히지 않아 지금도 알려지지 않았다.

〈님로드〉는 9번이다. 엘가의 출판사 편집자 아우구스트 옌스를 그렸다. 옌스는 독일어로 ''사냥꾼''이라는 뜻이고, 성서에 나오는 사냥꾼의 이름이 님로드다. 낙담해 있던 엘가를 격려해 준 사람이다. 엘가는 이 곡이 베토벤의 느린 악장을 두고 밤새 나눈 대화를 떠올린 것이라고 설명했다.

영국에서는 전몰자 추모 행사에서 늘 연주된다.' WHERE slug = 'nimrod' AND story IS NULL;

UPDATE work SET story = '《행성》은 홀스트가 1914년부터 1916년까지 쓴 일곱 곡의 관현악 모음곡이다. 1918년 9월 런던에서 지인들을 불러 비공개 초연을 했다. 곡은 점성술의 행성 성격을 따랐고 지구는 빠져 있다.

〈목성〉은 부제가 ''쾌락을 가져오는 자''다. 활기차고 떠들썩한 대목이 이어지다가, 중간에 느리고 당당한 선율이 나온다. 홀스트는 이 선율을 1921년 애국 찬가 〈I Vow to Thee, My Country〉의 곡조로 직접 고쳐 썼다.

가사가 붙은 뒤에는 영국의 교회와 학교에서 널리 불리게 되었다.' WHERE slug = 'jupiter' AND story IS NULL;

UPDATE work SET story = '말러는 교향곡 5번을 1901년부터 1902년에 걸쳐 썼다. 4악장 아다지에토는 현악기와 하프만으로 연주하는 곡이다. 말러는 이 곡을 쓴 해 아내가 될 알마를 만났고 1902년 3월 결혼했다.

이 악장이 알마에게 보낸 사랑의 고백이라는 이야기는 지휘자 멩엘베르흐가 자기 악보에 적어 둔 메모에서 나왔다. 말러 본인이 그렇게 말했다는 기록은 확인되지 않는다.

이 곡은 1971년 비스콘티의 영화 〈베니스에서의 죽음〉에 쓰였다. 1968년 로버트 케네디의 장례식에서도 연주되었다. 지휘자에 따라 연주 시간이 7분대에서 12분대까지 벌어진다.' WHERE slug = 'symphony-5-adagietto' AND story IS NULL;

UPDATE work SET story = '1924년 1월, 거슈윈은 신문에서 자신이 폴 화이트먼의 연주회를 위해 협주곡을 쓰고 있다는 기사를 읽었다. 아직 쓰지도 않은 곡이었다. 그는 곡을 쓰기로 했고 약 5주 만에 피아노 악보를 마쳤다. 관현악 편곡은 페르데 그로페가 맡았다.

연주회는 2월 12일 뉴욕 에올리언 홀에서 열렸다. 거슈윈이 직접 피아노를 쳤고, 악보에 다 적지 못한 부분은 즉흥으로 채웠다. 청중석에 라흐마니노프와 스트라빈스키가 있었다고 전해진다.

첫머리의 클라리넷 글리산도는 연습 중 클라리넷 주자 로스 고먼이 장난으로 길게 끌어올린 것을 거슈윈이 마음에 들어 악보에 넣었다고 한다.' WHERE slug = 'rhapsody-in-blue' AND story IS NULL;

UPDATE work SET story = '프로코피예프는 발레 《로미오와 줄리엣》을 1935년에 완성했다. 모스크바 볼쇼이 극장과의 계약이 취소되어 곡은 소련에서 한동안 무대에 오르지 못했다. 처음 초연된 곳은 1938년 체코의 브르노였고, 소련 초연은 1940년 레닌그라드의 키로프 극장에서 열렸다.

〈기사들의 춤〉은 1막에서 적대하는 두 가문, 몬태규와 캐풀렛 사람들이 무도회에서 나오는 장면이다. 낮은 금관과 현악기가 무겁고 느린 행진을 이끈다. 걸음은 우아하지만 위협적이다.

이 선율은 영국과 미국의 텔레비전 프로그램 〈디 애프렌티스〉의 주제로 쓰이며 클래식 밖의 청중에게도 알려졌다.' WHERE slug = 'dance-of-the-knights' AND story IS NULL;
