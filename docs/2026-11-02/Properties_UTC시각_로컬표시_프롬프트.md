# Properties 사이드 UTC 시각 로컬 표시

## 목표
멀티모달 Properties 패널에 서버 UTC로 찍힌 시각 필드를 기기 로컬 시각으로 보이게 한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `lib/src/presentation/features/video_multimodal/widgets/properties_side_body.dart`
4. `lib/src/data/repositories/clip_detail_mapping.dart`
5. 계약·화면안: 없음

## 현재 상태
- `PropertiesSideBody`는 `viewModel.clipDetailFields`를 `groupClipDetailFields`로 묶어 표만 그린다. 시각 포맷은 위젯에 없다.
- 값은 `clip_detail_mapping.dart`의 `_time`이 만든다.
- UTC 벽시계 필드: `embeddedAt`, `createdAt`, `updatedAt`, `asset.collectedAt`, `asset.recordedAt`
- `_time`은 `toLocal().toIso8601String()`이라 ISO 형태로 보여 UTC와 혼동되기 쉽다.
- `timelineStartNs` 등 ns 필드는 이번 범위 밖이다.

## 바꿀 것
1. `clip_detail_mapping.dart`의 `_time`: Timestamp를 로컬로 바꾼 뒤 `DashboardFormatters.dateTime`과 같은 `yyyy-MM-dd HH:mm:ss` 로컬 문자열로 표시한다. data 계층이 presentation을 import하지 않도록 동일 포맷을 `_time`에 둔다.
2. `_time`을 쓰는 위 다섯 필드만 영향. ns·기타 필드는 유지.
3. `_time` 관련 테스트가 있으면 로컬 표시 기대에 맞게 수정.

## 유지할 것
- Properties UI 구조
- GetClip 필드 목록·섹션 그룹핑
- 서버 저장은 UTC 유지(표시만 로컬)

## 이번 작업에서 만들지 않음
- 타임라인 ns → 벽시계 변환
- 패스/작업 다이얼로그 입력 변경
- 새 포맷터 패키지

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다. 파일 분리는 책임이 분명할 때만 한다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- Properties에서 `createdAt`/`updatedAt`/`embeddedAt`/`asset.collectedAt`/`asset.recordedAt`이 UTC `Z`/ISO가 아니라 로컬 `yyyy-MM-dd HH:mm:ss`로 보인다.
- ns 필드는 그대로다.
