# GetQueue 앞줄 고정 표시

## 목표
적재 파이프라인 폴링 중에는 클릭·RUNNING 여부와 관계없이 **대기열 앞줄**이 유지된다. 포커스 queue가 있으면 그걸 쓰고, 없으면 **`postprocess`** 를 기본으로 GetQueue 한다. `postprocess.*`가 빨리 끝나도 패널이 사라지지 않는다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `lib/src/presentation/features/collection_monitoring/pipeline_trace_view_model.dart`
4. `lib/src/presentation/features/collection_monitoring/widgets/pipeline_trace_tab_body.dart`
5. `docs/2026-11-17/GetQueue_화면검증.md`
6. `docs/2026-11-17/README.md` §3

## 현재 상태
- `_queueNameForFront`는 선택+queue 또는 RUNNING+`run.queue`일 때만 이름이 잡힌다.
- 조건이 비면 `_clearQueueFront()`로 패널이 사라진다.
- `_QueueFrontPanel`은 이미 선택 블록 밖(`doesShowQueueFront`).

## 바꿀 것
1. `_queueNameForFront`: 선택 `run.queue` → RUNNING+queue 첫 줄 → 없으면 **`postprocess`**.
2. 포커스 없어도 GetQueue·매칭 유지. 유휴여도 클리어하지 않음.
3. `doesShowQueueFront`는 기본 postprocess 포함으로 미선택·빠른 완료에도 true.
4. ● `selectedRunId`는 포커스 run만(없으면 빈 문자열).
5. 테스트·검증 문서 갱신. `./scripts/agent_check.sh` + GetQueue 테스트.

## 유지할 것
- `_QueueFrontPanel` 위젯 위치. RunService GetQueue만. 선택 요약은 선택 시에만.
- generated·스테퍼 점등 변경 없음.

## 이번 작업에서 만들지 않음
- work 대기열 동시 표시·탭 UI
- 새 화면·상태관리·카드
- tus/업로드 변경

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다. 파일 분리는 책임이 분명할 때만 한다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- `./scripts/agent_check.sh` + `test/pipeline_trace_view_model_get_queue_test.dart` 통과
- 미선택·DONE만·postprocess 순간 완료 후에도 앞줄 패널 보임
- 선택/RUNNING+queue 있으면 그 queue·● 강조 유지
