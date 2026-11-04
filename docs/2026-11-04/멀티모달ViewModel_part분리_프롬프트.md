# VideoMultimodalViewModel 기능별 part 분리

## 목표
`video_multimodal_view_model.dart`(~3950줄)를 기능·목적별 파일로 나눈다. **클래스는 하나**(`VideoMultimodalViewModel`)로 유지하고 Dart `part`/`part of`만 쓴다. 화면·테스트·locator 시그니처와 동작은 바꾸지 않는다.

## 바꿀 것
`part`로만 분리. 메인에 선언·필드·얇은 게터·`dispose`를 두고, 메서드 본문을 아래 part로 이동만 한다.

- `video_multimodal_view_model_open_job.dart`
- `video_multimodal_view_model_playback.dart`
- `video_multimodal_view_model_overlay.dart`
- `video_multimodal_view_model_monitor_chart.dart`
- `video_multimodal_view_model_ask.dart`
- `video_multimodal_view_model_labels.dart`
- `video_multimodal_view_model_inference.dart`
- `video_multimodal_view_model_timeline_write.dart`
- `video_multimodal_view_model_side_chrome.dart`

## 유지할 것
- 단일 타입·DI·공개 API
- 기존 보조 파일
- `login_screen.dart` 비커밋

## 이번 작업에서 만들지 않음
- 다중 ViewModel·DI 분리
- 메서드 이름 정리·로직 리팩터

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다. 파일 분리는 책임이 분명할 때만 한다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- `dart analyze` on `video_multimodal`
- job_timeline_edit / ask·label·tool 스모크 통과

## 회고 (구현 결과)
Dart `part`는 **같은 클래스 본문을 파일로 쪼갤 수 없다**. part 안의 메서드는 라이브러리 최상위가 되어 ViewModel 멤버가 되지 않는다.

시도한 대안:
- `extension`: `notifyListeners`(protected) 호출 불가, static 상수 한정자 이슈
- `mixin on VideoMultimodalViewModel` + 동일 클래스 `with`: 순환 인터페이스
- `VideoMultimodalViewModelBase` + `mixin on Base` + `class VM = Base with …`: 가능하나, Base에 남은 getter가 mixin 메서드를 호출하거나, mixin 간 호출(`Ask`→`didSeek`) 때문에 `on Base, OtherMixin` 의존 사슬이 필요. 추출 스크립트가 multi-line record 반환 타입을 잘못 잘라 회귀를 만들었다.

이번 작업에서는 세션에서 잃어버린 ViewModel 변경(openJob·라벨 캐시·선택 시 ReadContent·PosePlaybackLog 등)을 **단일 파일로 복구**하고 analyze/스모크를 통과시켰다. 파일 분리는 `Base`+기능 mixin+`class VM = Base with …` 및 getter 전용 mixin(`on`에 의존 mixin 명시)으로 후속 작업하는 것이 맞다.
