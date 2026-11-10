# Properties provenance 조건부 표시

## 목표
GetClip의 clip·asset provenance는 **있을 때만** Properties 필드로 넣고, 없으면 빈 `—` 행을 넣지 않는다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `lib/src/data/repositories/clip_detail_mapping.dart`
4. `lib/src/presentation/features/video_multimodal/widgets/clip_detail_sections.dart`
5. `test/clip_detail_test.dart`
6. 계약·화면안: 없음

## 현재 상태
- clip: provenance 없으면 confidence·reviewed·runId 등에 `—`를 항상 넣음 → 「만든 실행」에 빈 행.
- asset: provenance 없으면 asset.provenance.*에 `—`를 항상 넣음 → 「클립 파일」에 빈 경위 행.
- provenance가 있을 때의 필드 집합은 proto와 이미 맞음(ClipProvenance / Asset.Provenance).

## 바꿀 것
1. `clip_detail_mapping.dart`: `clip.hasProvenance()`(또는 기존 non-null)일 때만 clip provenance 필드 추가. else 분기 삭제.
2. asset도 `hasProvenance()`일 때만 asset.provenance.* 추가. else 분기 삭제.
3. `groupClipDetailFields`: 「만든 실행」이 전부 `—`이면 섹션 생략(관계와 동일 방어).
4. 테스트: provenance 없는 클립은 해당 키가 비어 있고 「만든 실행」 섹션이 없다.

## 유지할 것
- provenance가 있을 때 넣는 필드·라벨
- targetAsset subject/situation/postprocess 최근 추가분

## 이번 작업에서 만들지 않음
- provenance 필드 스키마 확장, 후처리 재시도 UI

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다. 파일 분리는 책임이 분명할 때만 한다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- `./scripts/agent_check.sh test/clip_detail_test.dart` 통과
- provenance 없으면 Properties에 경위/만든 실행 빈 행이 없다
