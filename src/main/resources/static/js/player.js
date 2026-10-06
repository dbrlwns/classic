/*
 * 재생기 어댑터.
 *
 * !! 플레이어를 숨기거나 오디오만 분리해 재생하지 말 것 !!
 * IFrame Player API 를 쓰는 순간 YouTube API Services Terms 의 적용을 받는다.
 * 약관은 플레이어를 가리는 것과 오디오를 분리하는 것을 금지한다.
 * "스토리를 읽으며 듣는" UX 를 다듬다 보면 영상을 숨기고 얇은 재생 바만
 * 남기고 싶어지는데, 그건 할 수 없다. 영상 영역은 그대로 노출한다.
 *
 * 유튜브 iframe 과 <audio> 는 API 가 전혀 다르다. 화면 코드가 그 차이를 알게 두면
 * 나중에 타임스탬프 주석을 붙일 때 플레이어 코드를 처음부터 다시 쓰게 된다.
 * 지금은 재생 버튼밖에 안 쓰더라도 인터페이스는 처음부터 갖춰둔다.
 *
 *   const player = Classic.createPlayer(el, { sourceType, youtubeId, audioUrl, startOffset, endOffset });
 *   player.on('ready',  () => ...);
 *   player.on('tick',   (seconds) => ...);   // 주석 하이라이트가 붙을 자리
 *   player.on('ended',  () => ...);
 *   player.on('error',  (info) => ...);
 *   player.play(); player.pause(); player.seek(42); player.getCurrentTime();
 */
(function (global) {
    'use strict';

    var TICK_INTERVAL_MS = 250;

    // 임베드를 youtube-nocookie.com 으로 띄운다. 방문자가 재생을 누르지 않아도
    // 심어지던 추적 쿠키가 크게 줄어든다. 기능은 www.youtube.com 과 동일하다.
    // 쿠키가 완전히 사라지는 것은 아니므로(재생하면 일부 저장된다) 배포 시
    // 쿠키 고지는 별도로 판단해야 한다.
    var YOUTUBE_EMBED_HOST = 'https://www.youtube-nocookie.com';

    // 유튜브 IFrame API 는 재생 시간 이벤트를 주지 않는다. 폴링해야 한다.
    var YOUTUBE_ERRORS = {
        2: '잘못된 영상 ID 입니다',
        5: 'HTML5 플레이어에서 재생할 수 없는 영상입니다',
        100: '영상이 삭제되었거나 비공개입니다',
        101: '이 영상은 퍼가기(임베드)가 허용되지 않습니다',
        150: '이 영상은 퍼가기(임베드)가 허용되지 않습니다'
    };

    function EventBus() {
        this.handlers = {};
    }

    EventBus.prototype.on = function (event, handler) {
        (this.handlers[event] = this.handlers[event] || []).push(handler);
        return this;
    };

    EventBus.prototype.emit = function (event, payload) {
        (this.handlers[event] || []).forEach(function (handler) {
            handler(payload);
        });
    };

    function startTicking(adapter) {
        stopTicking(adapter);
        adapter._timer = global.setInterval(function () {
            adapter.bus.emit('tick', adapter.getCurrentTime());
        }, TICK_INTERVAL_MS);
    }

    function stopTicking(adapter) {
        if (adapter._timer) {
            global.clearInterval(adapter._timer);
            adapter._timer = null;
        }
    }

    // ---------- YouTube ----------

    var youtubeApiPromise = null;

    function loadYouTubeApi() {
        if (youtubeApiPromise) {
            return youtubeApiPromise;
        }
        youtubeApiPromise = new Promise(function (resolve) {
            if (global.YT && global.YT.Player) {
                resolve(global.YT);
                return;
            }
            var previous = global.onYouTubeIframeAPIReady;
            global.onYouTubeIframeAPIReady = function () {
                if (typeof previous === 'function') {
                    previous();
                }
                resolve(global.YT);
            };
            var script = document.createElement('script');
            script.src = 'https://www.youtube.com/iframe_api';
            document.head.appendChild(script);
        });
        return youtubeApiPromise;
    }

    function YouTubeAdapter(element, options) {
        this.bus = new EventBus();
        this.element = element;
        this.options = options;
        this.player = null;
        this._timer = null;
        this._ready = false;
    }

    YouTubeAdapter.prototype.load = function () {
        var self = this;
        loadYouTubeApi().then(function (YT) {
            self.player = new YT.Player(self.element, {
                host: YOUTUBE_EMBED_HOST,
                videoId: self.options.youtubeId,
                playerVars: {
                    start: self.options.startOffset || 0,
                    end: self.options.endOffset || undefined,
                    rel: 0,
                    playsinline: 1
                    // modestbranding 은 2023-08 부터 효과가 없어 제거했다.
                    // 로고를 가리는 방향 자체가 YouTube 약관과 충돌한다.
                },
                events: {
                    onReady: function () {
                        self._ready = true;
                        // 준비 전에 들어온 loadVideo 요청이 있으면 지금 처리한다.
                        if (self._pendingLoad) {
                            var pending = self._pendingLoad;
                            self._pendingLoad = null;
                            self.loadVideo(pending);
                        }
                        self.bus.emit('ready');
                    },
                    onStateChange: function (event) {
                        if (event.data === YT.PlayerState.PLAYING) {
                            startTicking(self);
                        } else {
                            stopTicking(self);
                        }
                        if (event.data === YT.PlayerState.ENDED) {
                            self.bus.emit('ended');
                        }
                    },
                    onError: function (event) {
                        stopTicking(self);
                        self.bus.emit('error', {
                            code: event.data,
                            message: YOUTUBE_ERRORS[event.data] || '영상을 재생할 수 없습니다'
                        });
                    }
                }
            });
        });
        return this;
    };

    /**
     * 같은 플레이어에 다른 영상을 올린다. 이어 듣기가 이걸로 다음 곡을 넣는다.
     *
     * loadVideoById 는 항목마다 시작·끝 지점을 받는다. 유튜브 네이티브
     * 플레이리스트(loadPlaylist)는 그게 안 되므로, 긴 영상에서 한 악장만
     * 재생하는 용도를 살리려면 이쪽이어야 한다.
     *
     * 아직 준비 전이면 요청을 들고 있다가 onReady 에서 처리한다.
     */
    YouTubeAdapter.prototype.loadVideo = function (options) {
        if (!this._ready) {
            this._pendingLoad = options;
            return;
        }
        this.player.loadVideoById({
            videoId: options.youtubeId,
            startSeconds: options.startOffset || 0,
            endSeconds: options.endOffset || undefined
        });
    };

    YouTubeAdapter.prototype.play = function () {
        if (this._ready) { this.player.playVideo(); }
    };

    YouTubeAdapter.prototype.pause = function () {
        if (this._ready) { this.player.pauseVideo(); }
    };

    YouTubeAdapter.prototype.seek = function (seconds) {
        if (this._ready) { this.player.seekTo(seconds, true); }
    };

    YouTubeAdapter.prototype.getCurrentTime = function () {
        return this._ready ? this.player.getCurrentTime() : 0;
    };

    YouTubeAdapter.prototype.getDuration = function () {
        return this._ready ? this.player.getDuration() : 0;
    };

    YouTubeAdapter.prototype.on = function (event, handler) {
        this.bus.on(event, handler);
        return this;
    };

    // ---------- 직접 호스팅 오디오 ----------

    function AudioAdapter(element, options) {
        this.bus = new EventBus();
        this.element = element;
        this.options = options;
        this.audio = null;
        this._timer = null;
    }

    AudioAdapter.prototype.load = function () {
        var self = this;
        var audio = document.createElement('audio');
        audio.src = this.options.audioUrl;
        audio.controls = true;
        audio.preload = 'metadata';
        audio.style.width = '100%';

        audio.addEventListener('loadedmetadata', function () {
            if (self.options.startOffset) {
                audio.currentTime = self.options.startOffset;
            }
            self.bus.emit('ready');
        });
        // <audio> 는 timeupdate 를 주지만, 유튜브 쪽과 간격을 맞추려고 동일하게 폴링한다.
        audio.addEventListener('play', function () { startTicking(self); });
        audio.addEventListener('pause', function () { stopTicking(self); });
        audio.addEventListener('ended', function () {
            stopTicking(self);
            self.bus.emit('ended');
        });
        audio.addEventListener('error', function () {
            stopTicking(self);
            self.bus.emit('error', { code: 0, message: '음원을 불러오지 못했습니다' });
        });

        this.element.innerHTML = '';
        this.element.appendChild(audio);
        this.audio = audio;
        return this;
    };

    AudioAdapter.prototype.loadVideo = function (options) {
        this.options = options;
        if (this.audio) {
            this.audio.src = options.audioUrl;
            this.audio.load();
        }
    };

    AudioAdapter.prototype.play = function () { this.audio.play(); };
    AudioAdapter.prototype.pause = function () { this.audio.pause(); };
    AudioAdapter.prototype.seek = function (seconds) { this.audio.currentTime = seconds; };
    AudioAdapter.prototype.getCurrentTime = function () { return this.audio ? this.audio.currentTime : 0; };
    AudioAdapter.prototype.getDuration = function () { return this.audio ? this.audio.duration : 0; };
    AudioAdapter.prototype.on = function (event, handler) {
        this.bus.on(event, handler);
        return this;
    };

    // ---------- factory ----------

    function createPlayer(element, options) {
        var adapter = options.sourceType === 'SELF_HOSTED'
            ? new AudioAdapter(element, options)
            : new YouTubeAdapter(element, options);
        return adapter.load();
    }

    global.Classic = global.Classic || {};
    global.Classic.createPlayer = createPlayer;
    global.Classic.formatTime = function (seconds) {
        if (!seconds && seconds !== 0) { return '0:00'; }
        var total = Math.floor(seconds);
        var m = Math.floor(total / 60);
        var s = total % 60;
        return m + ':' + (s < 10 ? '0' : '') + s;
    };
})(window);
