# 멀티모달 로딩 UI 완화

## 목표
클립 선택 시 Properties가 GetClip을 기다리는 동안에도 타임라인 요약을 바로 보여 주고, 페이지 진입 때 Assets 패널을 자동으로 열지 않으며 Assets/Labels는 각 패널 안에서만 로딩을 표시한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md` (가이드라인 저장소는 워킹 트리 밖에서 읽기만)
3. `lib/src/presentation/features/video_multimodal/widgets/properties_side_body.dart`
4. `lib/src/presentation/features/video_multimodal/widgets/assets_side_body.dart`
5. `lib/src/presentation/features/video_multimodal/widgets/labels_side_body.dart`
6. `lib/src/presentation/features/video_multimodal/video_multimodal_view_model.dart` (`_loadSideAssets`, `didTapToggleAssets`, `didSelectSampleClip`, `selectedClip`)
7. 계약·화면안: 없음

## 현재 상태
- Properties: `isClipDetailLoading`이면 패널 본문 전체를 `ProgressBar`로 가린다. GetTimeline에 이미 있는 `selectedClip`(트랙·캡션·구간)도 숨긴다.
- `_loadSideAssets`: 진입 백그라운드에서 `_side = assets`로 자동 오픈한 뒤 ListAssets를 기다린다.
- Assets: 행이 비고 `isLoadingAssetsPage`일 때 본문 중앙 스피너(이미 패널 단위).
- Labels: 열 때 `loadLabelSections`를 호출하고, 루트가 비면 소형 링을 보여 준다.

## 바꿀 것
1. Properties: 타임라인 클립이 고르면 GetClip 여부와 관계없이 요약 표(클립 번호, 트랙, 캡션, 구간)를 즉시 그린다. GetClip 중이면 요약 아래에만 얇은 ProgressBar와 “상세 불러오는 중”. 끝나면 기존 GetClip 섹션을 요약 아래에 이어서 표시한다. 선택·시크·Properties 사이드 열기는 유지한다.
2. `_loadSideAssets`에서 `_side = VideoMultimodalSide.assets`를 제거한다. 진입 시 ListAssets만 백그라운드로 받고 사이드는 none을 유지한다. Assets 토글 시 페이지가 비어 있으면 `_loadAssetsPage(1)`을 호출한다.
3. Labels: `isLoadingLabels`이고 루트가 비면 본문에 얇은 ProgressBar와 짧은 문구. 루트가 있으면 목록을 가리지 않는다. Assets 빈 목록 로딩 스피너는 유지한다.

## 유지할 것
- GetClip 캐시·epoch·시크·재생·차트·자막 백그라운드 prefetch
- `context.select` 리빌드 분리
- 툴바 `isLoading`(GetTimeline) 잠금
- MM-REACT/VIDEO 디버그 로그
- login_screen, generated, proto

## 이번 작업에서 만들지 않음
- GetClip prefetch / 800ms 안내 문구
- webm initialize 플레이스홀더
- ListLabels/ListAssets 서버 지연 자체 개선
- IndexedStack, 새 상태관리

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
- 클립 선택 직후 Properties에 요약이 보이고, GetClip 중에도 패널 전체가 스피너만으로 비지 않는다
- 멀티모달 진입 직후 사이드가 Assets로 자동 열리지 않는다
- Assets/Labels를 열었을 때만 해당 패널 본문에 로딩이 보인다
