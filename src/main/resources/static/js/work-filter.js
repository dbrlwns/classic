/*
 * 관리 대시보드의 곡 거르기.
 *
 * 서버로 보내지 않고 이미 그려진 행을 숨겼다 보였다 한다. 곡이 수십 개
 * 수준이라 왕복 없이 한 글자마다 반응하는 쪽이 훨씬 쓸 만하다. 수백 개가
 * 되면 표를 통째로 그리는 것 자체가 문제가 되므로, 그때는 이 방식도 같이
 * 서버 쪽으로 옮겨야 한다.
 *
 * 비교에 쓰는 값은 전부 행의 data- 속성에서 읽는다. 화면의 글자를 긁어
 * 비교하면 뱃지 문구 하나 바꿀 때마다 조용히 깨진다.
 */
(function () {
    'use strict';

    var table = document.getElementById('work-table');
    var search = document.getElementById('work-search');
    if (!table || !search) {
        return;
    }

    var result = document.getElementById('filter-result');
    var emptyRow = document.getElementById('filter-empty');
    var chips = Array.prototype.slice.call(document.querySelectorAll('.filter-chips button'));
    // tr[data-flags] 로 고르지 않는다. 타임리프가 빈 값 속성을 지우기 때문에
    // 빠진 것이 없는 곡에는 그 속성이 없다. class 로 골라야 전부 잡힌다.
    var rows = Array.prototype.slice.call(table.querySelectorAll('tbody tr.work-row'));

    var activeFlag = '';   // 빈 문자열이 "전체"

    function flagsOf(row) {
        var raw = row.getAttribute('data-flags');   // 빠진 것이 없으면 아예 없다
        return raw ? raw.split(' ') : [];
    }

    /** 칩에 붙는 개수. 검색어와 무관하게 전체 기준으로 센다. */
    function paintCounts() {
        chips.forEach(function (chip) {
            var flag = chip.dataset.filter;
            var count = flag
                ? rows.filter(function (row) { return flagsOf(row).indexOf(flag) >= 0; }).length
                : rows.length;

            var slot = chip.querySelector('span');
            if (slot) { slot.textContent = count; }

            // 해당하는 곡이 없는 칩은 눌러도 빈 표가 나온다. 눌리지 않게 둔다.
            chip.disabled = count === 0 && flag !== '';
        });
    }

    function apply() {
        var needle = search.value.trim().toLowerCase();
        var shown = 0;

        rows.forEach(function (row) {
            var matchesFlag = !activeFlag || flagsOf(row).indexOf(activeFlag) >= 0;
            var matchesText = !needle
                || row.dataset.title.indexOf(needle) >= 0
                || row.dataset.slug.indexOf(needle) >= 0;

            var visible = matchesFlag && matchesText;
            row.style.display = visible ? '' : 'none';
            if (visible) { shown++; }
        });

        if (emptyRow) {
            emptyRow.style.display = shown === 0 ? '' : 'none';
        }
        if (result) {
            // 거르지 않은 상태에서는 아무 말도 하지 않는다. 표가 곧 답이다.
            result.textContent = (activeFlag || needle)
                ? shown + '곡 / 전체 ' + rows.length + '곡'
                : '';
        }
    }

    chips.forEach(function (chip) {
        chip.addEventListener('click', function () {
            activeFlag = chip.dataset.filter;
            chips.forEach(function (other) {
                other.setAttribute('aria-pressed', String(other === chip));
            });
            apply();
        });
    });

    search.addEventListener('input', apply);

    // 검색칸에서 Esc 로 비운다. 입력칸 안에서는 폼 제출이 아니라 비우기가 자연스럽다.
    search.addEventListener('keydown', function (event) {
        if (event.key === 'Escape' && search.value) {
            event.preventDefault();
            search.value = '';
            apply();
        }
    });

    paintCounts();
    apply();
})();
