# KPI 적재 진행 ListTraces 취합 수정

## 목표
적재 진행·실패 카드가 `ListTraces`의 `total_count`(status별 page_size=1)로 RUNNING·DONE·FAILED를 취합해 표시한다. 페이지의 `traces.length`로 세지 않는다.

## 현재 상태
- RUNNING·FAILED만 조회하고 value는 RUNNING만 표시한다.
- 전체 목록 응답(`totalCount=171`, 대부분 DONE)과 카드(진행 0)가 어긋나 보인다.

## 바꿀 것
1. DONE `total_count`도 조회해 `CollectionKpi`에 넣는다.
2. 카드: value=진행(RUNNING), subtitle=`완료 {DONE} · 실패 {FAILED}`.
3. status별 건수 조회 실패는 보드 전체 실패로 만들지 않는다(해당 건수만 0 유지).

## 유지할 것
- page_size=1 + total_count 방식(가이드 §2)
- traces 배열 길이로 집계하지 않음

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다. 파일 분리는 책임이 분명할 때만 한다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- `./scripts/agent_check.sh` 통과
- 관련 테스트 통과
