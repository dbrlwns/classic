/*
 * data-copy 속성의 값을 클립보드로 복사하는 버튼.
 *
 * 관리 화면에서 유튜브 영상 ID 를 data.sql 로 옮겨 적을 때 쓴다.
 * ddl-auto 가 create-drop 이라 재시작하면 관리 화면에서 넣은 음원은 사라진다.
 * 지우기 전에 ID 를 회수하는 통로다.
 */
(function () {
    'use strict';

    function flash(button, message) {
        var before = button.textContent;
        button.textContent = message;
        window.setTimeout(function () {
            button.textContent = before;
        }, 1200);
    }

    function copy(value, button) {
        // navigator.clipboard 는 https 나 localhost 에서만 동작한다.
        // 다른 호스트로 접속하면 undefined 이므로 대체 경로가 필요하다.
        if (navigator.clipboard && window.isSecureContext) {
            navigator.clipboard.writeText(value).then(
                function () { flash(button, '복사됨'); },
                function () { flash(button, '실패'); }
            );
            return;
        }

        var area = document.createElement('textarea');
        area.value = value;
        area.setAttribute('readonly', '');
        area.style.position = 'fixed';
        area.style.top = '-1000px';
        document.body.appendChild(area);
        area.select();
        try {
            flash(button, document.execCommand('copy') ? '복사됨' : '실패');
        } catch (e) {
            flash(button, '실패');
        }
        document.body.removeChild(area);
    }

    document.addEventListener('click', function (event) {
        var button = event.target.closest('.copy-btn');
        if (!button || !button.dataset.copy) {
            return;
        }
        copy(button.dataset.copy, button);
    });
})();
