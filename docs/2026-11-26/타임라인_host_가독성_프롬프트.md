# 타임라인 host 가독성 리팩터

## 목표
`collection_timeline_host.dart`의 레이아웃·크럼·줌·범례를 역할별로 나누어 읽기 쉽게 한다. UI·동작은 그대로 둔다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `lib/src/presentation/features/collection_monitoring/widgets/collection_timeline_host.dart`
4. 계약·화면안: 없음

## 현재 상태
- `CollectionTimelineHost.build`에 상단 Row·보드 DecoratedBox·인스펙터 DecoratedBox가 한곳에 길게 있음
- 보드/인스펙터 패널 테두리·배경 코드가 동일하게 두 번 있음
- `_Toolbar`는 줌만 담당하는데 이름과 불일치
- `_DrillCrumbs` 루트/조상 버튼 구성이 비슷하게 반복됨
- `_viewRootLabelOf`는 인자를 쓰지 않고 항상 `'공사별'` 반환

## 바꿀 것 (이 파일만)
1. Host `build`를 짧게: `_ChromeBar` + `_BoardBody`
2. `_ChromeBar`: 기존 한 줄 `[Expanded(_DrillCrumbs)] · [_Legend] · [_ZoomControl]`
3. `_BoardBody`: 보드 + (너비≥720) 인스펙터. 공통 패널은 `_SurfacePanel`(DecoratedBox+padding)로 한 번만
4. `_Toolbar` → `_ZoomControl`로 이름 맞춤. `board` 대신 `zoomHours`+`onChanged`만 받도록 좁혀도 됨
5. `_DrillCrumbs`: 루트/조상 버튼을 `_CrumbButton`(label 위젯들 + onPressed)로 묶어 반복 축소
6. `_viewRootLabelOf` → `const _kViewRootLabel = '공사별'` (미사용 인자 제거)
7. 위젯 순서: Host → ChromeBar → BoardBody/SurfacePanel → DrillCrumbs/CrumbButton → Zoom → Legend → 라벨 헬퍼
8. 확인된 본 프롬프트를 `docs/2026-11-26/타임라인_host_가독성_프롬프트.md`에 저장 후 그 문서만 구현

## 유지할 것
- 드릴·줌·범례·보드·인스펙터 동작과 시각(패딩·색·720 분기)
- 다른 파일 수정 없음

## 이번 작업에서 만들지 않음
- 새 public 파일·패키지 분리
- 새 추상 계층·상태관리·디자인 시스템
- 크럼/줌 UX 변경

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
- 상단 한 줄·보드·인스펙터 표시 동일
- 변경 파일은 `collection_timeline_host.dart`와 프롬프트 문서만
