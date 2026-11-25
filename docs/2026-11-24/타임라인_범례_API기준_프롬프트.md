# 타임라인 범례 API(summary·asset) 기준

## 목표
타임라인 막대·범례를 API의 `summary.asset_count`·`asset`만으로 **수집 / 기록 없음** 두 가지로 판정한다. 오류·유실·지연 등 그 외 범례 표시·색 우선순위 로직은 타임라인에서 제거한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `lib/src/domain/use_cases/present_collection_nodes_use_case.dart`
4. `lib/src/data/repositories/remote_collection_catalog_repository.dart`
5. `lib/src/domain/entities/connection_status.dart`
6. `lib/src/presentation/features/collection_monitoring/widgets/collection_timeline_host.dart`
7. `lib/src/presentation/features/collection_monitoring/widgets/collection_event_timeline_mapper.dart`
8. `lib/src/presentation/features/collection_monitoring/widgets/timeline_status_style.dart`
9. `protos/mediatag/work/v1/work.proto` (`CollectionNode.summary` / `asset`)

## 현재 상태
- 판정: `(assetCount ?? 0) > 0 || isAssetNode` → connected (이미 summary·asset 계열).
- 범례: 수집 · 기록 없음 · 오류.
- mapper/`TimelineStatusStyle`에 유실·미동기·error 색 분기가 남아 범례와 어긋날 수 있다.

## 바꿀 것
1. 상태 판정 유지·명시: `summary.asset_count > 0` 또는 Asset 노드(`asset` → `isAssetNode`) → `connected`(수집), 아니면 `disconnected`(기록 없음). Present·remote catalog만.
2. `_Legend`: **수집 · 기록 없음**만.
3. `collection_event_timeline_mapper`의 `colorOf`/`statusOf`: `connectionStatus`의 수집/기록 없음만 반영. `isLossWarning`·`isDesynced` 우선 분기 제거.
4. `TimelineStatusStyle.of`: 유실 border·미동기 dashed 제거. `error`는 exhaustive용으로 기록 없음과 같은 회색 처리(Present는 error를 넣지 않음).
5. ConnectionStatus enum의 `error` 값·parse는 다른 경로를 위해 유지하되, 타임라인 범례·Present 매핑에서는 쓰지 않는다.

## 유지할 것
- KPI 카드의 커버리지/손실 표시
- 일자 창 segment 필터·빈 목록 UX
- generated proto

## 이번 작업에서 만들지 않음
- ConnectionStatus에서 error 제거(광범위 breaking)
- coverage 기반 막대 색
- 새 상태 enum

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
- 범례 두 항목만: 수집 · 기록 없음
- Asset·assetCount>0 → 수집, 그 외 summary 노드 0 → 기록 없음
- 타임라인 막대 색이 유실/지연으로 덮이지 않음
