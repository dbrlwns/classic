/*
 * 목록형 / 격자형 전환.
 *
 * 레이아웃은 CSS 가 ul[data-view] 를 보고 결정한다. 이 스크립트는 그 값만 바꾼다.
 *
 * 선택은 localStorage 에 둔다. 보는 사람마다 다른 취향이고 서버가 알 필요가 없다.
 * 비공개 브라우징이나 사이트 데이터 차단 상태에서는 읽기·쓰기가 던질 수 있으므로
 * 모두 try/catch 로 감싸고, 저장이 안 되더라도 화면은 정상 동작하게 둔다.
 *
 * 이 파일은 ul 보다 앞에서 실행된다. 저장된 값을 ul 이 파싱되기 전에 적용해야
 * 목록형으로 한 번 그려진 뒤 격자형으로 바뀌는 깜빡임이 생기지 않는다.
 */
(function () {
    'use strict';

    var STORAGE_KEY = 'classic.worklist.view';
    var VALID = ['list', 'grid'];

    function read() {
        try {
            var saved = window.localStorage.getItem(STORAGE_KEY);
            return VALID.indexOf(saved) >= 0 ? saved : null;
        } catch (e) {
            return null;
        }
    }

    function write(view) {
        try {
            window.localStorage.setItem(STORAGE_KEY, view);
        } catch (e) {
            // 저장하지 못해도 이번 화면은 그대로 동작한다.
        }
    }

    function apply(view) {
        // 목록 자체와, 폭을 넓히기 위한 컨테이너 양쪽에 붙인다.
        ['work-list', 'works-main'].forEach(function (id) {
            var element = document.getElementById(id);
            if (element) {
                element.setAttribute('data-view', view);
            }
        });
        document.querySelectorAll('[data-view-set]').forEach(function (button) {
            button.setAttribute('aria-pressed', String(button.dataset.viewSet === view));
        });
    }

    var saved = read();

    // ul 이 아직 파싱되지 않았을 수 있다. 있으면 바로 적용하고,
    // 없으면 DOM 이 준비된 뒤에 적용한다.
    function init() {
        if (saved) {
            apply(saved);
        }
        document.querySelectorAll('[data-view-set]').forEach(function (button) {
            button.addEventListener('click', function () {
                var view = button.dataset.viewSet;
                apply(view);
                write(view);
            });
        });
    }

    if (saved) {
        // 깜빡임 방지. 이 시점에 ul 이 있으면 그려지기 전에 속성이 박힌다.
        apply(saved);
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();
