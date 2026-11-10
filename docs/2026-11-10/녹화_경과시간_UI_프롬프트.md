# 녹화 중 경과 시간 UI

## 목표
`didTapStart`로 녹화가 시작된 뒤 정지할 때까지, 카메라 녹화 패널에 경과 시간(예: `0:05`, `1:03`)이 초 단위로 보이도록 한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md` (가이드라인 저장소는 워킹 트리 밖에서 읽기만)
3. `lib/src/presentation/features/video_multimodal/camera_recording_view_model.dart`
4. `lib/src/presentation/features/video_multimodal/widgets/camera_recording_dialog.dart`
5. 계약·화면안: 없음

## 현재 상태
- `didTapStart` 성공 시 `phase = recording`, `noticeText = '녹화 중입니다.'`만 설정. 경과 시간·타이머 없음.
- 오버레이는 `noticeText` InfoBar와 미리보기·시작/정지 버튼만 표시.

## 바꿀 것
1. `camera_recording_view_model.dart`
   - 녹화 시작 시각·`Timer.periodic(1s)`로 경과 초를 갱신한다.
   - `String get recordingElapsedLabel` — `recording`일 때만 `M:SS` 또는 1시간 이상이면 `H:MM:SS`(예: `0:05`, `12:03`, `1:02:03`). 그 외 단계는 빈 문자열.
   - `didTapStart` 성공 직후 타이머 시작. `didTapStop`·시작 실패·`prepare`·`dispose`에서 타이머를 반드시 끈다.
   - `noticeText`는 `'녹화 중입니다.'` 유지(매초 InfoBar 문구를 바꾸지 않음). 경과 시간은 별도 getter로만 노출.
2. `camera_recording_dialog.dart`
   - `phase == recording`이고 `recordingElapsedLabel`이 비어 있지 않으면, 미리보기 아래(코멘트 필드 위)에 `● 녹화 중  {elapsed}` 한 줄을 표시한다. 기존 Fluent 텍스트 스타일만 쓰고 카드/새 디자인 시스템을 넣지 않는다.

## 유지할 것
- 시작/정지/업로드/코멘트·타임라인 배치 흐름
- 최소화·드래그·InfoBar 구조
- release에서 불필요한 추상 시계 계층 없음(`Timer` 직접 사용)

## 이번 작업에서 만들지 않음
- 녹화 파일 duration과 UI 경과 시간의 정합 검증
- 업로드 중 경과 시간
- 새 위젯 파일·테스트 파일(기존 camera 테스트가 깨지면 최소 수정만)

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
- 관련 테스트가 있으면 `./scripts/agent_check.sh <test 경로…>` 통과
- 시작 후 패널에 `● 녹화 중 0:00`부터 초가 올라간다
- 정지·닫기(dispose)·다시 prepare 시 타이머가 멈추고 라벨이 사라진다
- InfoBar는 매초 문구가 바뀌지 않는다
