/*
 * 라이트/다크 토글.
 *
 * 테마를 정하는 일은 이미 layout.html 의 머리말 스크립트가 끝냈다.
 * 여기서 하는 일은 셋이다.
 *   - 버튼의 아이콘과 라벨을 지금 테마에 맞춘다
 *   - 누르면 테마를 뒤집고 localStorage 에 적는다
 *   - 사용자가 직접 고른 적이 없으면 운영체제 설정 변화를 따라간다
 *
 * 저장 키를 쓰는 곳은 머리말 스크립트와 여기 둘뿐이다. 값을 바꾸려면
 * 양쪽을 같이 고쳐야 한다.
 */
(function () {
    'use strict';

    var STORAGE_KEY = 'moirai-theme';
    var root = document.documentElement;
    var button = document.getElementById('theme-toggle');

    if (!button) {
        return;
    }

    var systemDark = window.matchMedia('(prefers-color-scheme: dark)');

    function current() {
        return root.getAttribute('data-theme') === 'dark' ? 'dark' : 'light';
    }

    /**
     * 버튼은 "지금 무엇인지" 가 아니라 "누르면 무엇이 되는지" 를 말한다.
     * 아이콘도 같다 — 밝은 화면에서는 초승달(어두워진다), 어두운 화면에서는 해.
     */
    function paint() {
        var now = current();
        var label = now === 'dark' ? '밝은 화면으로 바꾸기' : '어두운 화면으로 바꾸기';

        button.setAttribute('data-mode', now);
        button.setAttribute('aria-label', label);
        button.setAttribute('title', label);
    }

    function apply(theme, fromUser) {
        root.setAttribute('data-theme', theme);
        root.setAttribute('data-theme-source', fromUser ? 'user' : 'system');
        paint();
    }

    button.addEventListener('click', function () {
        var next = current() === 'dark' ? 'light' : 'dark';
        apply(next, true);
        try {
            localStorage.setItem(STORAGE_KEY, next);
        } catch (e) {
            // 저장이 막혀도 이번 화면에서는 바뀐다. 새로 고치면 운영체제 설정으로 돌아간다.
        }
    });

    /*
     * 운영체제에서 밤 모드로 넘어갈 때 따라간다.
     * 단, 사용자가 이 버튼으로 직접 고른 적이 있으면 그 선택이 우선이다.
     * 그렇지 않으면 해 질 녘에 사용자가 고른 설정이 말없이 뒤집힌다.
     *
     * addEventListener 는 사파리 14 부터다. 그 아래는 addListener 만 있다.
     */
    function onSystemChange(event) {
        if (root.getAttribute('data-theme-source') === 'user') {
            return;
        }
        apply(event.matches ? 'dark' : 'light', false);
    }

    if (systemDark.addEventListener) {
        systemDark.addEventListener('change', onSystemChange);
    } else if (systemDark.addListener) {
        systemDark.addListener(onSystemChange);
    }

    paint();
})();
