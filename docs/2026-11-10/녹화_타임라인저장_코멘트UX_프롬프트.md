# 녹화 저장·코멘트 화면 설계 방향

## 목표
녹화 업로드와 CreateComment를 ‘파일 올리기 + 숨은 부수효과’가 아니라 ‘이 순간을 타임라인에 저장’ 한 흐름으로 맞춘다. 카드는 촬영만, 저장 다이얼로그에서 메타·코멘트를 함께 받고 완료 상태를 한 번에 보여 준다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `lib/src/presentation/features/asset_lookup/asset_upload_dialog.dart`
4. `lib/src/presentation/features/video_multimodal/widgets/camera_recording_dialog.dart`
5. `lib/src/presentation/features/video_multimodal/camera_recording_view_model.dart`
6. `lib/src/domain/entities/asset_upload.dart`
7. 계약·화면안: 없음

## 현재 상태
- 녹화 카드에 코멘트 글 칸이 있고 CTA는 「녹화 파일 업로드」다.
- 업로드는 에셋 올리기 다이얼로그, CreateComment는 다이얼로그 성공 후 ViewModel에서 조용히 호출된다.
- 주제·상황·장비·시각은 다이얼로그, 코멘트 body만 카드에 있어 저장 입력이 둘로 갈라진다.

## 바꿀 것
1. `AssetUploadBatchResult`에 `screenCommentBody`(기본 `''`)를 추가한다. 다이얼로그가 성공 결과를 닫을 때 화면 코멘트 칸 값을 넣는다.
2. `showAssetUploadDialog`에 `timelineSaveMode`(기본 `false`), `showScreenCommentField`(기본 `false`)를 추가한다.
   - `timelineSaveMode`: 제목·주 버튼을 「타임라인에 올리기」/「저장」(올리는 중… 유지), 완료 버튼은 「완료」 유지.
   - `showScreenCommentField`: 화면 코멘트(선택) 입력 칸을 공통 필드에 추가.
   - 에셋 조회·작업 첨부 호출부는 인자 생략으로 기존과 동일.
3. `camera_recording_dialog.dart`
   - 카드에서 코멘트 `LookupSearchField` 제거.
   - CTA를 「타임라인에 올리기」(완료 시 「저장 완료」).
   - `showAssetUploadDialog`에 `timelineSaveMode: true`, `showScreenCommentField: viewModel.capturesScreenComment` 전달.
4. `camera_recording_view_model.dart`
   - `didFinishAssetUpload`에서 `batch.screenCommentBody`로 CreateComment body를 쓴다.
   - 완료 문구: 배치·코멘트 성공 시 「타임라인에 올렸습니다.」(+ 코멘트 등록 시 「코멘트도 등록되었습니다」), 부분/실패는 기존처럼 구분. 「다시 업로드」 문구는 「다시 타임라인에 올리기」로 맞춤.
   - 정지 후 안내 문구도 타임라인에 올리기에 맞춘다.
5. `test/screen_comment_test.dart`: 배치에 `screenCommentBody`를 넣어 CreateComment body를 검증한다.

## 유지할 것
- 업로드 큐·metadata·후처리·타임라인 배치·CreateComment 호출 순서
- 에셋 조회/작업 첨부 올리기 UX
- `capturesScreenComment == false`면 코멘트 칸·CreateComment 없음

## 이번 작업에서 만들지 않음
- CreateComment 2단계 마법사
- 사이드 목록에서만 코멘트 작성
- 에셋 다이얼로그 전체 리디자인·새 디자인 시스템

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
- `./scripts/agent_check.sh test/screen_comment_test.dart` 통과
- 녹화 카드에 코멘트 입력란이 없고 CTA가 「타임라인에 올리기」다
- 녹화에서 연 다이얼로그에(해당 시) 화면 코멘트가 있고 저장 문구가 맞다
- 에셋 조회 올리기는 회귀 없이 동작한다
