# 녹화 패널 축소 시 Y 이동

## 목표
`CameraRecordingOverlay`를 축소하면, 숨겨진 본문 높이만큼 `top`(Y)을 내려 헤더가 아래로 붙고, 다시 펼치면 같은 만큼 올린다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `lib/src/presentation/features/video_multimodal/widgets/camera_recording_dialog.dart`
4. `lib/src/presentation/features/video_multimodal/video_multimodal_view_model.dart`
5. `lib/src/presentation/features/video_multimodal/video_multimodal_screen.dart`
6. 계약·화면안: 없음

## 현재 상태
- `Positioned(top: offsetY)`로 고정되어 축소해도 top이 그대로라 패널이 위쪽에 남는다.
- 토글은 `_isMinimized` / `didToggleCameraRecordingMinimized`만 바꾼다.

## 바꿀 것
1. `CameraRecordingOverlay`에 본문 대략 높이 상수 `EXPANDED_BODY_HEIGHT`(미리보기·패딩·버튼 한 줄 기준)를 둔다.
2. `CameraRecordingScope` 토글 시: 축소면 `offsetY += EXPANDED_BODY_HEIGHT`, 펼치면 뺀다(기존 clamp 유지).
3. `didToggleCameraRecordingMinimized`에 `expandedBodyHeight`를 받아 동일하게 Y를 조정한다. 화면에서 `CameraRecordingOverlay.EXPANDED_BODY_HEIGHT`를 넘긴다.

## 유지할 것
- 드래그 이동·열기/닫기·최소화 UI
- InfoBar 등 가변 높이의 정밀 측정은 하지 않음

## 이번 작업에서 만들지 않음
- LayoutBuilder로 실제 높이 측정
- 새 위젯·디자인 시스템

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
- 축소 시 패널이 아래로 내려가고, 펼치면 이전 top 근처로 돌아온다
