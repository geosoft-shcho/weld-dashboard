# 첨부 탭 ProgressRing → ProgressBar

## 목표
첨부 탭 액션바 아래 ProgressRing을 없애고, 상단 ProgressBar로 `_isWorking`과 첨부 로딩을 함께 알린다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md` (가이드라인 저장소는 워킹 트리 밖에서 읽기만)
3. `lib/src/presentation/features/job_lookup/widgets/job_attachment_tab.dart`
4. 없음

## 현재 상태
- `_run` / `_didTapDetach`가 `_isWorking = true`로 두면 액션바 아래에 `Center(child: ProgressRing())`가 들어간다.
- 상단에는 `isLoadingAttachments`용 `ProgressBar`가 있다.

## 바꿀 것
1. ListView 안 `_isWorking` ProgressRing 블록을 제거한다.
2. 상단 ProgressBar 조건을 `_isWorking || _viewModel.isLoadingAttachments`로 바꿔, 떼기·붙이기·재로드 중에도 ProgressBar만으로 로딩을 알린다.
3. `_isWorking`으로 버튼을 막는 동작은 유지한다.

## 유지할 것
- 목록 하단 `isLoadingMoreAttachments` ProgressRing(더보기)
- ContentDialog 에러 표시
- ViewModel 로딩 플래그

## 이번 작업에서 만들지 않음
- 새 로딩 위젯/상태관리
- 다른 탭 ProgressRing 정리

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
- 액션바 아래 ProgressRing이 없다
- `_isWorking` 또는 첨부 로딩 중 상단 ProgressBar만 보인다
