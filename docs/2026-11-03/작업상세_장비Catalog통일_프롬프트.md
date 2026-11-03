# 작업 상세 장비를 WorkHistoryCatalog로 통일

## 목표
작업 상세 로드에서 `WorkService/ListEquipment`를 호출하지 않고, `ListJobFilters` 결과인 `WorkHistoryCatalog.equipments`만 쓰도록 한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `lib/src/presentation/features/job_lookup/job_lookup_detail_view_model.dart` `_loadMasters` / `_loadEquipment` / `equipment` getter
4. `lib/src/data/repositories/remote_work_history_repository.dart` `loadMasters` (이미 `equipments` 매핑)
5. `lib/src/presentation/core/di/locator.dart` JobLookupDetailViewModel 등록
6. 계약·화면안: 없음

## 현재 상태
- `load()`가 `_loadMasters()`(ListJobFilters)와 `_loadEquipment()`(ListEquipment 전부)를 병렬 호출.
- `equipment` getter는 `_equipment`를 반환하고, 첨부 탭 올리기 다이얼로그에 넘김.
- `WorkHistoryCatalog.equipments`는 ListJobFilters의 equipment로 이미 채워짐.

## 바꿀 것
1. **ViewModel**
   - `ListEquipmentLookupUseCase` 의존성·`_loadEquipment`·`_equipment` 필드 제거.
   - `List<Equipment> get equipment => _masters?.equipments ?? const [];`
   - `load()`의 `Future.wait`는 `_loadMasters()`와 `_loadJobDetail()`만.
2. **locator** — JobLookupDetailViewModel 생성에서 `listEquipmentLookupUseCase` 인자 제거.
3. `ListEquipmentLookupUseCase` 자체·에셋 상세 등 다른 화면 호출은 유지.

## 유지할 것
- ListJobFilters 기반 projects/workers
- GetJob 상세 로드
- 첨부 탭 ListAssets 지연·페이징
- 올리기 다이얼로그에 `equipment` 넘기는 호출부(소스만 catalog로 바뀜)

## 이번 작업에서 만들지 않음
- ListEquipment API·UseCase 삭제
- 에셋 관리/업로드의 ListEquipment 경로 변경
- ListJobFilters proto 변경

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다. 파일 분리는 책임이 분명할 때만 한다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- 작업 상세 최초 로드에 ListEquipment 요청 없음
- 올리기 다이얼로그 장비 콤보가 Catalog 장비로 채워짐
- analyze 통과
