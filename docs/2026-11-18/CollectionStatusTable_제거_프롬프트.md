# CollectionStatusTable 제거

## 목표
도달 불가능한 「현재 수집 상태」 표 위젯과 그 전용 UI 분기를 없앤다. 적재 파이프라인·일자별 타임라인·커맨드바·KPI 동작은 그대로 둔다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `lib/src/presentation/features/collection_monitoring/collection_monitoring_screen.dart`
3. `lib/src/presentation/features/collection_monitoring/widgets/collection_status_table.dart`
4. `lib/src/presentation/features/collection_monitoring/collection_monitoring_view_model.dart` (`didToggleDisconnectedOrErrorOnly`, `didSelectRow`)
5. `lib/src/domain/entities/collection_board_query.dart` / `lib/src/domain/use_cases/query_collection_board_use_case.dart`

## 현재 상태
- 탭 UI는 `0` 파이프라인 / `1` 타임라인만 노출. 「현재 수집 상태」 탭은 주석.
- `currentIndex`가 0·1이 아닐 때만 `CollectionStatusTable`로 떨어지나, UI에서 2를 고를 수 없어 사실상 미사용.
- `didToggleDisconnectedOrErrorOnly` / `doesShowDisconnectedOrErrorOnly`는 이 표의 「단절/오류만」 체크에서만 호출·표시. 기본값 `false`.
- `didSelectRow`는 타임라인 리프 선택(`didTapTimelineNode`)에서도 사용 → **유지**.
- `board.rows`·KPI 필터는 타임라인 보드 구성에도 쓰임 → **유지**. 단절/오류 where만 제거.

## 바꿀 것
1. **삭제** `lib/src/presentation/features/collection_monitoring/widgets/collection_status_table.dart`
2. `collection_monitoring_screen.dart`
   - `CollectionStatusTable` import·else 분기 제거
   - 주석 처리된 「현재 수집 상태」 탭·「삭제 금지」 주석 제거
   - 본문: `currentIndex == 0 ? PipelineTraceTabBody : CollectionTimelineHost` 만 남김
3. `collection_monitoring_view_model.dart`: `didToggleDisconnectedOrErrorOnly` 제거 (`didSelectRow` 유지)
4. `collection_board_query.dart`: `doesShowDisconnectedOrErrorOnly` 필드·`initial`·`copyWith` 제거
5. `query_collection_board_use_case.dart`: `doesShowDisconnectedOrErrorOnly` where 필터 블록만 제거

## 유지할 것
- 파이프라인/타임라인 탭, `PipelineTrace*`, `CollectionTimelineHost`, KPI, 커맨드바
- `didSelectRow` / `selectedEquipmentId` / `board.rows` / KPI 카드 필터
- work_history의 동명 `didSelectRow` (다른 VM)

## 이번 작업에서 만들지 않음
- 타임라인·파이프라인 UI 변경, `isDisconnectedOrError` row 헬퍼 전역 삭제(다른 표시에 쓰일 수 있으면 유지), 광범위 리팩터

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
- 수집 모니터링: 적재 파이프라인 / 일자별 타임라인만 동작, 상태 표·단절필터 UI 없음
- 타임라인 장비 선택·KPI·새로고침이 깨지지 않음
