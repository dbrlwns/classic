/*
 * 이어 듣기.
 *
 * 플레이어 하나를 한 자리에 두고, 곡이 끝나면 다음 곡을 그 플레이어에 넣는다.
 * 유튜브 네이티브 플레이리스트 대신 loadVideoById 로 직접 넘기는 이유는 두 가지다.
 *   - 항목마다 시작·끝 지점을 줄 수 있다(긴 영상에서 한 악장만 재생하는 용도)
 *   - 곡이 바뀔 때 옆의 제목·소개를 같이 바꿀 수 있다
 *
 * 플레이어는 늘 보이는 자리에 있다. 약관이 금지하는 것은 플레이어를 가리거나
 * 오디오만 분리하는 것이다.
 */
(function () {
    'use strict';

    var tracks = window.MOIRAI_TRACKS || [];
    if (!tracks.length) {
        return;
    }

    var index = 0;
    var player = null;
    var started = false;

    // 재생이 안 되는 영상(삭제, 퍼가기 금지)을 건너뛴 기록.
    // 전부 실패했을 때 무한 루프에 빠지지 않도록 센다.
    var skipped = {};

    var els = {
        frame: document.getElementById('listen-player'),
        title: document.getElementById('now-title'),
        meta: document.getElementById('now-meta'),
        summary: document.getElementById('now-summary'),
        performer: document.getElementById('now-performer'),
        link: document.getElementById('now-link'),
        notice: document.getElementById('listen-notice'),
        list: document.getElementById('listen-list'),
        prev: document.getElementById('listen-prev'),
        next: document.getElementById('listen-next'),
        restart: document.getElementById('listen-restart')
    };

    function text(element, value) {
        if (!element) { return; }
        element.textContent = value || '';
        element.style.display = value ? '' : 'none';
    }

    function notice(message) {
        if (!els.notice) { return; }
        els.notice.textContent = message || '';
        els.notice.style.display = message ? 'block' : 'none';
    }

    function renderNowPlaying() {
        var track = tracks[index];

        text(els.title, track.title);

        var meta = [track.composerName];
        if (track.catalog) { meta.push(track.catalog); }
        if (track.year) { meta.push(String(track.year)); }
        text(els.meta, meta.join(' · '));

        text(els.summary, track.summary);
        text(els.performer, track.performer);

        if (els.link) {
            els.link.setAttribute('href', '/works/' + track.slug);
        }

        // 목록에서 현재 곡 표시
        var rows = els.list ? els.list.querySelectorAll('[data-track-index]') : [];
        Array.prototype.forEach.call(rows, function (row) {
            var isCurrent = Number(row.dataset.trackIndex) === index;
            row.classList.toggle('is-current', isCurrent);
            row.setAttribute('aria-current', isCurrent ? 'true' : 'false');

            // 자동으로 넘어갔을 때 재생 중인 곡이 목록 밖에 있으면 보이지 않는다.
            // block: 'nearest' 라 이미 보이는 경우에는 움직이지 않는다.
            if (isCurrent) {
                row.scrollIntoView({ block: 'nearest' });
            }
        });

        if (els.prev) { els.prev.disabled = index === 0; }
        if (els.next) { els.next.disabled = index >= tracks.length - 1; }
    }

    function optionsFor(track) {
        return {
            sourceType: 'YOUTUBE',
            youtubeId: track.videoId,
            startOffset: track.startSeconds || 0,
            endOffset: track.endSeconds || 0
        };
    }

    function goTo(newIndex, autoplay) {
        if (newIndex < 0 || newIndex >= tracks.length) {
            return;
        }
        index = newIndex;
        notice('');
        renderNowPlaying();

        if (!player) {
            player = createPlayer();
            return;
        }
        player.loadVideo(optionsFor(tracks[index]));
        if (autoplay) {
            player.play();
        }
    }

    /**
     * 재생 불가 영상을 만나면 다음으로 넘긴다.
     * 남은 곡이 전부 실패하면 멈춘다. 그대로 두면 끝없이 돌게 된다.
     */
    function skipToNext(message) {
        skipped[index] = true;
        if (Object.keys(skipped).length >= tracks.length) {
            notice('재생할 수 있는 곡이 없습니다. 영상이 삭제되었거나 퍼가기가 막혀 있을 수 있습니다.');
            return;
        }
        if (index >= tracks.length - 1) {
            notice('마지막 곡입니다. ' + (message || ''));
            return;
        }
        notice(message + ' 다음 곡으로 넘어갑니다.');
        goTo(index + 1, true);
    }

    function createPlayer() {
        var holder = document.createElement('div');
        els.frame.innerHTML = '';
        els.frame.appendChild(holder);

        var created = Classic.createPlayer(holder, optionsFor(tracks[index]));

        created.on('ready', function () {
            if (started) {
                created.play();
            }
        });

        created.on('ended', function () {
            if (index >= tracks.length - 1) {
                notice('마지막 곡까지 들었습니다.');
                return;
            }
            goTo(index + 1, true);
        });

        created.on('error', function (info) {
            skipToNext(info.message + '.');
        });

        return created;
    }

    // ---------- 조작 ----------

    if (els.list) {
        els.list.addEventListener('click', function (event) {
            var row = event.target.closest('[data-track-index]');
            if (!row) { return; }
            started = true;
            goTo(Number(row.dataset.trackIndex), true);
        });
    }

    if (els.prev) {
        els.prev.addEventListener('click', function () {
            started = true;
            goTo(index - 1, true);
        });
    }

    if (els.next) {
        els.next.addEventListener('click', function () {
            started = true;
            goTo(index + 1, true);
        });
    }

    if (els.restart) {
        els.restart.addEventListener('click', function () {
            started = true;
            skipped = {};
            goTo(0, true);
        });
    }

    // 첫 화면. 모바일은 사용자 제스처 없이 자동재생이 막히므로 재생은 걸지 않는다.
    // 한 번 누르고 나면 그 뒤의 자동 전환은 동작한다.
    renderNowPlaying();
    player = createPlayer();
})();
