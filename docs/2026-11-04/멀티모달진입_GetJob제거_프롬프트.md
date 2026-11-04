# 멀티모달 진입 GetJob 제거

## 목표
멀티모달 페이지 진입(`openJob`) 경로에서 WorkService/GetJob를 호출하지 않는다. Ask에 필요한 `projectId`는 질의 전송 시점에만 로드한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `lib/src/presentation/features/video_multimodal/video_multimodal_view_model.dart` `openJob` · `_ensureProjectId` · Ask 전송
3. 계약·화면안: 없음

## 현재 상태
- `openJob` 백그라운드 `Future.wait`에 `_ensureProjectId()`가 포함되어 진입 시마다 GetJob가 돈다.
- Ask 전송 경로에도 `_projectId.isEmpty`일 때 `_ensureProjectId()`가 있다.

## 바꿀 것
1. `openJob`의 `Future.wait`에서 `_ensureProjectId()` 한 줄만 제거한다.
2. `_ensureProjectId`와 Ask 쪽 호출은 유지한다(Ask 첫 전송 때만 GetJob).
3. 진입 `[MM-LOAD]`에 GetJob 단계가 더 이상 나오지 않으면 된다(로그 API 변경 없음).

## 유지할 것
- GetTimeline 블로킹 + 나머지 백그라운드 병렬
- Ask·라벨·첨부·도구 복원
- `login_screen.dart` 비커밋

## 이번 작업에서 만들지 않음
- projectId를 Timeline/다른 API에서 가져오기
- Ask DI·UseCase 제거
- GetJob 전역 제거

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
- `ask_question_test` 등 Ask가 projectId를 쓰는 테스트 통과
- 진입 시 `[MM-LOAD]`에 GetJob 없음
- Ask 첫 전송 시 GetJob는 그대로 동작
