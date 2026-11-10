# 녹화 패널 기본 X 이동

## 목표
멀티모달에서 녹화 패널 기본 X를 `380`으로 두어 추론 패널`(24, 24)`과 겹치지 않게 한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `lib/src/presentation/features/video_multimodal/video_multimodal_view_model.dart`
3. 계약·화면안: 없음

## 현재 상태
- `_cameraRecordingOffsetX = 24`, `_inferenceOffsetX = 24`로 동일해 겹친다.

## 바꿀 것
1. `_cameraRecordingOffsetX` 초기값을 `380`으로 변경한다.

## 유지할 것
- 추론 패널 offset, 녹화 Y, 드래그 clamp, `CameraRecordingScope` 기본값

## 이번 작업에서 만들지 않음
- 동적 회피·축소 Y 이동

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
- 멀티모달 녹화 패널이 X=380에서 열린다
