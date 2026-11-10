# Properties targetAsset 필드 추가

## 목표
GetClip `targetAsset`을 Properties에 매핑할 때 `subject`, `situation`, `postprocess.status`를 추가해 사이드 패널에 주제·상황·후처리 상태가 보이게 한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `lib/src/data/repositories/clip_detail_mapping.dart`
4. `lib/src/presentation/features/video_multimodal/widgets/clip_detail_sections.dart`
5. `lib/src/presentation/features/video_multimodal/widgets/properties_side_body.dart`
6. `protos/mediatag/asset/v1/asset.proto` (Asset.subject/situation/postprocess)
7. 계약·화면안: 없음

## 현재 상태
- Properties는 `groupClipDetailFields(clipDetailFields)`로 GetClip 필드를 섹션 표시한다.
- `targetAsset` 매핑: assetId, kind, fileName, contentUrl만. subject/situation/postprocess 없음.
- 라벨 맵에 해당 키 없음.

## 바꿀 것
1. `clip_detail_mapping.dart`의 targetAsset 블록에 `subject`, `situation`, `postprocess.status`를 추가한다. postprocess가 없으면 상태 값은 `—`. status enum은 기존 `_enumLabel`에 `POSTPROCESS_STATUS_` 접두를 넣어 짧게 보이게 한다.
2. `clip_detail_sections.dart` `_FIELD_LABELS`에 `targetAsset.subject`→주제, `targetAsset.situation`→상황, `targetAsset.postprocess.status`→후처리 상태를 추가한다.
3. 관련 테스트가 있으면 맞춘다.

## 유지할 것
- PropertiesSideBody 레이아웃·섹션 그룹 방식
- asset(클립 파일) 매핑 범위(이번엔 targetAsset만)

## 이번 작업에서 만들지 않음
- asset 본문 필드 추가, 후처리 재시도 UI

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
- 관련 테스트가 있으면 통과
- Properties 대상 파일 섹션에 주제·상황·후처리 상태가 보인다
