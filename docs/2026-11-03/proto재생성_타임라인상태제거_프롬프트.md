# Proto 재생성 + 타임라인 상태 제거

## 목표
서버 2026-11-02 계약에 맞게 proto를 다시 생성하고, 삭제된 타임라인 상태 흐름을 앱에서 완전히 빼서 빌드·타임라인 편집이 깨지지 않게 한다. 사용자는 상태 메뉴/RPC 없이 타임라인을 편집한다.

## 먼저 읽을 것
1. `README.md` 목적 절 · proto 생성 절차(`flutter pub get` → `buf generate`)
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. 이미 워킹트리에 있는 proto diff: `protos/mediatag/compose/v1/compose.proto`, `protos/mediatag/asset/v1/asset.proto`, `protos/mediatag/tool/v1/tool.proto`
4. `docs/2026-11-03/README.md` 「2026-11-02에 바뀐 것」지운 것 표
5. 상태 호출 경로: `lib/src/domain/use_cases/change_timeline_status_use_case.dart`, `lib/src/data/repositories/remote_job_timeline_repository.dart`, `lib/src/domain/entities/job_timeline.dart`, `lib/src/presentation/features/video_multimodal/widgets/multimodal_timeline_board.dart`

## 현재 상태
- proto 소스 3개는 이미 11-02 반영됨(미커밋). compose에서 `TimelineStatus`·`ChangeTimelineStatus`·`Timeline.labels`/`status`/`embedded_at` 삭제, asset에 `RetryPostprocess`·`Asset.postprocess`, tool에 `ToolRun.queue`·`workers_by_queue` 추가.
- 생성 코드(`lib/src/data/datasources/generated/`)는 옛 계약. `changeTimelineStatus` 등이 남아 있음.
- 앱: `JobTimeline.status`·`ChangeTimelineStatusUseCase`·repository/`ViewModel` 메서드·보드 `_statusMenu`(주석)가 남아 호출 경로가 살아 있음. UI 메뉴만 꺼 둔 상태.
- 수집 현황의 `TimelineStatus`(collection)는 별개 UI 상태 — 건드리지 않음.

## 바꿀 것
1. `flutter pub get` 후 루트에서 `buf generate`로 generated 갱신.
2. 타임라인 상태 제거:
   - `JobTimelineStatus` enum·`JobTimeline.status` 삭제
   - `ChangeTimelineStatusUseCase` 파일 삭제, DI(`locator.dart`) 등록 제거
   - repository 인터페이스·원격 구현·`buildChangeTimelineStatusRequest`·`jobTimelineStatusFromProto`·`protoTimelineStatusFrom` 제거
   - `jobTimelineFromResponse`에서 `status` 매핑 제거
   - ViewModel: `_changeTimelineStatusUseCase`, `timelineStatus`, `changeTimelineStatus`, `didChooseTimelineStatus` 제거
   - 보드: `_statusMenu`·관련 상태·라벨 헬퍼·주석 호출 제거
3. 테스트 픽스처/목에서 `changeTimelineStatus`·`JobTimelineStatus`·UseCase 주입·상태 기대 제거(`test/job_timeline_edit_test.dart` 등). 상태 전용 테스트는 삭제.
4. `dart analyze` / 관련 테스트로 컴파일 확인. generated는 손대지 않음.

## 유지할 것
- `Clip.embedded_at` 표시(클립 단위) — Timeline이 아님
- 수집 현황 `TimelineStatusStyle` / `TimelineStatusSwatch`
- `login_screen.dart` 등 이번과 무관한 로컬 변경
- RetryPostprocess·대기열 표시·웹캠 STT UX는 **구현하지 않음**(생성 코드에 필드만 생겨도 앱 연동은 다음 단계)

## 이번 작업에서 만들지 않음
- RetryPostprocess 실패 재시도 UI/UseCase
- `ToolRun.queue` / `queue_position` / `workers_by_queue` 화면 표시
- 웹캠 STT 음성 클립 자동 선택·유도
- proto 내용의 추가 편집(이미 반영된 워킹트리 파일 사용)

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다. 파일 분리는 책임이 분명할 때만 한다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- `buf generate` 후 generated에 `ChangeTimelineStatus` 없고 `RetryPostprocess`·`ToolRun.queue`는 존재
- 타임라인 보드에 상태 메뉴/호출 없음
- `ChangeTimelineStatus`를 앱이 호출하지 않음
- 관련 테스트·analyze 통과
- 사용자 검증 후 2단계(RetryPostprocess)로 진행
