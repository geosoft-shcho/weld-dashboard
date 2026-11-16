# 데스크탑 컨트롤 Row 오버플로

## 목표
좁은 stage(모니터 칸·창 축소)에서도 `MultimodalDesktopControls` 하단 Row가 RenderFlex overflow 나지 않게 한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `lib/src/presentation/features/video_multimodal/widgets/multimodal_desktop_controls.dart` (약 194행 Row)

## 현재 상태
- play·mute·시간 Text·Spacer·fullscreen이 고정 폭 Row라 ~150px에서 우측 overflow.
- stage 최소 폭을 강제하면 멀티 모니터 칸이 더 깨질 수 있음.

## 바꿀 것
1. 시간 `Text`를 `Flexible`로 감싸고 `maxLines: 1`, `overflow: TextOverflow.ellipsis`.
2. `Spacer` 제거(Flexible이 남는 폭을 맡음). 아이콘은 그대로.
3. stage 최소 영역 강제하지 않음.

## 유지할 것
- 재생·mute·fullscreen 동작
- 컨트롤 표시/숨김 타이머

## 이번 작업에서 만들지 않음
- 새 컨트롤 바·디자인 시스템
- stage 레이아웃 전면 개편

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
- 좁은 stage에서 Row overflow 없음
- 넓은 stage에서 시간·버튼 정상 표시
