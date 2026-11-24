# 일자 타임라인 segment 겹침·점 표시 수정

## 목표
일자별 수집 타임라인에서 공사(및 상위) 노드의 `segments`를 계속 막대로 쓰되, 선택일 창과 **실제로 겹치는 구간만** 보이게 한다. 창 밖 점(◆)을 00:00으로 끌어와 그리지 않는다. 긴 JOB이 하루를 가로지르면 잘린 구간 막대만 보이고, 겹침이 없는 날은 빈 칸으로 둔다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md` (가이드라인 저장소는 워킹 트리 밖에서 읽기만)
3. `lib/src/domain/use_cases/present_collection_nodes_use_case.dart`
4. `lib/src/data/repositories/remote_collection_catalog_repository.dart` (`_eventsFrom` 동일 clamp)
5. `protos/mediatag/work/v1/work.proto` (`CollectionNode.segments`, `TimeBasis`, `SegmentUnit`)
6. `docs/2026-11-23/수집 현황 KPI · 타임라인 변경 안내.md` (타임라인 단위 권장)
7. 계약·화면안: 위 proto·안내 문서

## 현재 상태
- `present_collection_nodes_use_case.dart`: segment를 일자 창에 맞게 자를 때, 점(`startedAt == endedAt`)도 `visibleStart = max(startedAt, windowStart)`로 올린 뒤 필터한다. 창 **이전** 점이 `windowStart`(보통 00:00)에 ◆로 남는다.
- `remote_collection_catalog_repository.dart`: 동일 clamp·필터 순서.
- 공사 조회 시 서버 `segments`(WORK+JOB)를 그리는 것·레벨별 `segment_unit`(공사·품목 JOB, 작업 PASS)은 이미 권장과 맞다.
- 공사 루트에서 일자 창은 서버 offset이 아니라 Present 클라이언트 필터다.

## 바꿀 것
1. **점**: 원본 `startedAt`이 `[windowStart, windowEnd)` 안일 때만 이벤트로 만든다. `eventAt`은 clamp하지 않고 `startedAt`을 쓴다. 창 밖 점은 버린다.
2. **구간**: 기존처럼 `visibleStart`/`visibleEnd`로 창에 맞게 자르고, 잘린 길이가 0이면 버린다. 하루를 가로지르는 JOB은 그날 잘린 막대만 남긴다.
3. `remote_collection_catalog_repository.dart`의 `_eventsFrom`도 같은 점·구간 규칙으로 맞춘다.
4. 위 동작을 고정하는 단위 테스트(`test/present_collection_nodes_use_case_test.dart`)를 추가한다.  
   - 창 이전 점 → 이벤트 없음  
   - 창 안 점 → 한 개, `eventAt == startedAt`  
   - 창을 가로지르는 구간 → 잘린 duration > 0

## 유지할 것
- 막대 데이터 소스는 `segments`(없으면 node `started_at`~`ended_at` 폴백).
- 공사·품목 기본 `WORK` + `JOB`, 작업 단계 `PASS` (`_applySegmentForLevel`).
- ListCollectionNodes 호출·캐시·일자 UI·리소스 뷰 구조.
- 긴 공사명 표시 개선(별 프롬프트) 동작.
- generated proto 직접 수정 금지.

## 이번 작업에서 만들지 않음
- COLLECTION basis 전용 화면·기록일 뷰 신규.
- 공사에서 segment 숨기기 / 외곽 `started_at`~`ended_at` 단일 막대.
- 공사 기본을 PASS로 바꾸기.
- 이벤트 없는 행(노드)을 목록에서 제거하기.
- KPI·CommandBar·inspector 리팩터.

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다. 파일 분리는 책임이 분명할 때만 한다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- `./scripts/agent_check.sh` 통과 (`dart analyze`)
- `./scripts/agent_check.sh test/present_collection_nodes_use_case_test.dart` 통과
- 선택일에 창 밖 점만 있는 공사(예: 공사테스트의 과거 ◆)는 해당 일자 리소스에 ◆가 안 남는다
- 선택일과 겹치는 구간 막대·창 안 점은 그대로 보인다
