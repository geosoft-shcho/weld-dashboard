# 에셋 관리 필터·진입 API

## 목표
에셋 관리 최초 진입은 ListAssets만으로 표를 채우고, ListEquipment·ListJobs는 필터용으로 pageSize 20부터 지연·페이지네이션한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `lib/src/presentation/features/asset_lookup/asset_lookup_view_model.dart` `load`
4. `lib/src/domain/use_cases/list_equipment_lookup_use_case.dart` `execute` / `executePage`
5. `lib/src/presentation/features/asset_lookup/asset_lookup_screen.dart` 필터·작업 더 보기

## 현재 상태
- `load()`가 ListEquipment 전량(200 반복) → ListJobs(200) → ListAssets(20) 순차 호출
- 작업만「더 보기」가 있고 pageSize는 200
- 장비는 콤보·표 이름·올리기에 쓰이지만 표 필수 데이터는 아님

## 바꿀 것
1. `load` 분리: 표 로딩·에러는 ListAssets만. Equipment/Jobs는 표와 병렬 또는 이후 pageSize 20 첫 페이지. 카탈로그 실패해도 표 유지.
2. ListJobs pageSize 200 → 20. `didTapLoadMoreJobs` / 작업 더 보기 유지.
3. ListEquipment `execute()` 전량 순회를 에셋 목록 진입에 쓰지 않음. `executePage(pageSize: 20)` + nextPageToken + 장비 더 보기.
4. 표 장비 칸: 캐시 없으면 equipmentId 폴백.
5. 올리기는 진입 전량 장비를 전제하지 않음(같은 20 페이지 카탈로그).

## 유지할 것
- ListAssets pageSize 20·무한 스크롤
- 종류/후처리/파일명/미지정 필터의 ListAssets 쿼리 의미
- 에셋 상세·DeleteAsset
- ListJobFilters 캐스케이드는 이번 범위 밖

## 이번 작업에서 만들지 않음
- ListJobFilters + 공사/호기/품목 좁히기
- 새 검색 콤보 위젯·상태관리

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
- 최초 진입: ListAssets가 표에 먼저 뜨고 Equipment/Jobs는 pageSize 20
- 장비 전량 루프가 에셋 목록 `load` 경로에 없음
