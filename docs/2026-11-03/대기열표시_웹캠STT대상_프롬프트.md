# 3단계 — 대기열 표시 · 웹캠 STT 대상 UX

## 목표
후처리·도구 실행이 대기 중일 때 `ToolRun.queue` · `queue_position` · `queue_length`를 화면에 보여 주고, 웹캠 녹화 업로드 뒤에는 STT가 **음성 클립**을 대상으로 걸리도록 선택·유도를 맞춘다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `docs/2026-11-03/README.md` 「대기열」·「후처리 다시 걸기 · STT」
4. `docs/2026-11-03/웹캠 녹화 업로드와 STT 안내.md` §6
5. `lib/src/domain/entities/tool_run.dart`, `lib/src/data/repositories/tool_run_requests.dart` `toolRunSnapshotFrom`
6. `lib/src/domain/use_cases/upload_asset_queue_use_case.dart` `_waitForPostprocess`
7. `lib/src/domain/entities/asset_upload.dart` 상태 라벨
8. `lib/src/presentation/features/video_multimodal/video_multimodal_view_model.dart` `didStartInference` · `didPlaceUploadedRecording`
9. `lib/src/presentation/features/video_multimodal/camera_recording_view_model.dart` `_waitForPostprocess`
10. 계약·화면안: 없음

## 바꿀 것

### A. 대기열 표시
1. `ToolRunSnapshot`에 `queue`, `queuePosition`, `queueLength` 추가. `toolRunSnapshotFrom`에서 proto 매핑.
2. 업로드 후처리 대기: QUEUED일 때 메시지에 큐 표시.
3. 웹캠 업로드 대기: QUEUED일 때 noticeText에 큐 문구.
4. 추론 패널 queued: `_inferenceMessage`에 큐 이름·순번.

큐 표시 문구 규칙:
- `postprocess` → `후처리`
- `work` → `작업`
- 그 외 → raw `queue` (비면 생략)
- `queuePosition > 0`이면 ` · {position}/{length}` 붙임 (length 0이면 position만)

### B. 웹캠 STT 대상 UX
1. `didPlaceUploadedRecording`: 음성 배치 성공 후 해당 클립을 `_selectedClipId`로 선택.
2. `didStartInference(isSpeechToText: true)`: 영상/미선택이면 `녹화 음성` 클립 자동 선택. 없으면 안내 메시지. 깊이 가드 유지.
3. STT 자동 StartRun 금지.

## 유지할 것
- RetryPostprocess · 에셋 목록 후처리 필터 · 첨부 탭 지연 로드
- STT 자동 실행 금지
- GetQueue 모니터링 전용 화면 신설 없음

## 이번 작업에서 만들지 않음
- `GetQueue` / `workers_by_queue` 모니터링 화면
- STT 도구 자동 실행
- proto 재생성
- `login_screen.dart` 임시값 커밋

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다. 파일 분리는 책임이 분명할 때만 한다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- 업로드/웹캠/추론 대기 중 큐 이름·순번이 보임
- 웹캠 음성 배치 후(또는 STT 실행 시) 음성 클립이 대상으로 잡힘
- 영상만 선택된 STT는 유도 또는 안내 메시지
- analyze·관련 테스트 통과
