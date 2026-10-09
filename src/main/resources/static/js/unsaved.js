/*
 * 저장하지 않은 글이 있을 때 떠나려 하면 경고한다.
 *
 * 아무것도 저장해 두지 않는다. 세션도 쿠키도 localStorage 도 쓰지 않는다.
 * 화면을 연 시점의 폼 내용을 기억해 뒀다가, 떠나려는 순간 지금 내용과
 * 비교할 뿐이다. 다르면 브라우저에게 "확인 좀 받아 달라" 고 말한다.
 *
 * 두 가지는 브라우저가 정하는 것이라 이쪽에서 어쩌지 못한다.
 *   - 문구를 바꿀 수 없다. 크롬도 사파리도 자기 문구만 띄운다.
 *     (예전에 피싱에 쓰여서 막혔다)
 *   - 사용자가 페이지를 한 번도 건드리지 않았으면 아예 뜨지 않는다.
 *     글을 쓰다 나가는 상황에서는 늘 건드린 뒤이므로 실제로는 문제없다.
 *
 * data-warn-unsaved 가 붙은 폼에만 적용된다.
 */
(function () {
    'use strict';

    var form = document.querySelector('form[data-warn-unsaved]');
    if (!form) {
        return;
    }

    /*
     * 폼 전체를 한 줄로 만든다. 필드를 하나하나 비교하지 않는 이유는,
     * 입력칸이 늘어날 때마다 이 파일을 같이 고쳐야 하기 때문이다.
     * 체크를 푼 체크박스는 FormData 에 아예 안 들어오므로 그 변화도 잡힌다.
     */
    function snapshot() {
        try {
            return new URLSearchParams(new FormData(form)).toString();
        } catch (e) {
            return null;   // 비교할 수 없으면 경고하지 않는다. 막는 것보다 낫다.
        }
    }

    var initial = snapshot();
    var leaving = false;

    /*
     * 이 화면의 어떤 폼이든 제출되면 떠나는 것이 의도된 행동이다.
     * 저장은 물론이고 삭제, 음원 추가, 대표 지정까지 전부 해당한다.
     * 삭제에는 이미 자기 확인창이 있어서, 여기서 또 물으면 두 번 묻게 된다.
     */
    document.addEventListener('submit', function () {
        leaving = true;
    });

    window.addEventListener('beforeunload', function (event) {
        if (leaving || initial === null) {
            return;
        }
        if (snapshot() === initial) {
            return;
        }
        event.preventDefault();
        event.returnValue = '';   // 크롬은 이 줄이 있어야 확인창을 띄운다
    });
})();
