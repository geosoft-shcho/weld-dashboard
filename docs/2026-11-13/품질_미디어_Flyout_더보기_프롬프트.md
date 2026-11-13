# 미디어 Flyout 더보기

## 목표
미디어 선택을 Fluent `Flyout`으로 바꾸고, **더보기**는 팝업을 닫지 않은 채 다음 `ListAssets` 페이지를 이어 받아 목록만 갱신한다. 미디어 항목을 고르면 그때 닫고 선택한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `lib/src/presentation/core/widgets/filter_flyout_button.dart` (`FlyoutController` + `FlyoutContent` 패턴)
4. `lib/src/presentation/features/quality_issue/widgets/quality_media_host.dart` (`_MediaStrip` ComboBox)
5. 계약·화면안: 없음

## 현재 상태
- `_MediaStrip`이 `ComboBox` + `__load_more__` 항목 사용 → 더보기 선택 시 팝업이 닫힘
- VM의 `hasMoreJobMedia` / `isLoadingMoreJobMedia` / `didTapLoadMoreJobMedia`는 이미 있음

## 바꿀 것
1. `quality_media_host.dart`만 수정. `_MediaStrip`을 **StatefulWidget**으로 바꾸고 ComboBox·sentinel 제거.
2. 기존 `FilterFlyoutButton`과 같은 방식: `FlyoutController` + `FlyoutTarget` + 트리거 `Button`(선택 라벨 + chevron). 트리거 요약은 선택 미디어 라벨(없으면 `미디어 선택` / `미디어 없음`).
3. `FlyoutContent` 안:
   - 스크롤 목록: 각 미디어 `Button`/`ListTile` — 탭 시 `onSelect` + `Flyout.of(context).close()`(또는 컨트롤러 close)
   - 하단: `hasMoreJobMedia`이면 **더보기** — 탭 시 `onLoadMoreJobMedia`만, **닫지 않음**. 로딩 중 ProgressRing·disable
4. 팝업이 열린 채 부모 rebuild(목록 append)에 반응하도록, State에 `ValueNotifier`로 entries/hasMore/loading 스냅샷을 두고 flyout 안은 `ValueListenableBuilder`로 그린다. `build`/`didUpdateWidget`에서 notifier를 갱신한다.
5. entries도 token도 없으면 트리거 대신 `미디어 없음` 텍스트 유지.

## 유지할 것
- VM·screen props (`hasMoreJobMedia`, `onLoadMoreJobMedia` 등)
- PDF/영상 호스트·선택 후 표시 동작
- pageSize 50·캐시 append

## 이번 작업에서 만들지 않음
- 새 public 위젯 파일·공통 Flyout 추상화
- FilterFlyoutButton 공용 API 확장
- VM/Repository 변경

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
- 더보기 후에도 Flyout이 열린 채 목록이 늘어난다
- 미디어 항목 선택 시에만 닫히고 호스트가 바뀐다
- token 없으면 더보기 숨김

## 구현 순서
1. 확인 후 `docs/2026-11-13/품질_미디어_Flyout_더보기_프롬프트.md` 저장
2. `_MediaStrip` Flyout 교체
3. `./scripts/agent_check.sh`
