# 화면 코멘트 API 화면

## 현재까지 수정 범위
워킹 트리에 있는 화면 코멘트 작업이다. `login_screen.dart`의 로컬 로그인 값은 이 작업이 아니다.

- 생성: 멀티모달·품질·패스가 음성 업로드 뒤 `CreateComment` 1회. 멀티모달은 재생 바·선택 클립·트랙·재생·배속·패널 context. 품질·패스는 `t_ms`·`screen`·`job_id`·`pass_id` 한 줄과 녹화를 연 순간의 `pass_id`.
- 목록: 녹화 카드 안 `ListComments{jobId}`. 접힌 `코멘트 N`, 펼치면 상태 색과 내용. 자막 파일은 받지 않는다.
- 호출 계층: `ScreenComment`, Create/List use case, `AssetUploadRepository`, locator, `test/screen_comment_test.dart`.
- proto·생성 Dart의 Comment RPC는 이미 있다. 다시 생성하지 않는다.

## 목표
녹화 카드에서 코멘트 글을 고치고, 코멘트를 지울 수 있다. 녹화 파일은 그대로 남는다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md` (가이드라인 저장소는 워킹 트리 밖에서 읽기만)
3. `docs/2026-11-05/화면 코멘트(웹캠 녹화) 설계.md` §3 API·§4 목록
4. `protos/mediatag/asset/v1/asset.proto` `UpdateComment` · `DeleteComment`
5. `lib/src/presentation/features/video_multimodal/widgets/screen_comment_list.dart`
6. `lib/src/presentation/features/video_multimodal/screen_comment_list_view_model.dart`
7. `lib/src/data/repositories/remote_asset_upload_repository.dart`
8. `lib/src/domain/use_cases/create_screen_comment_use_case.dart`

## 현재 상태
- 목록 줄은 내용과 상태만 보여 준다. 고치기·지우기 버튼이 없다.
- repository에 update/delete가 없다. 생성 클라이언트에는 `updateComment` · `deleteComment`가 있다.
- 목록 ViewModel은 `ListScreenCommentsUseCase`만 부른다.

## 바꿀 것
1. `UpdateComment{commentId, body}`와 `DeleteComment{commentId}`를 repository와 use case로 연결한다. 빈 글은 서버 규칙대로 글을 지운다.
2. 코멘트를 펼친 안에 글 입력, 저장, 삭제를 둔다. 저장은 그 코멘트의 글만 보낸다. 삭제는 확인 후 코멘트만 지우고 목록을 다시 불러온다. 실패하면 그 줄에 짧은 실패 문구를 남긴다.
3. 목록의 접기, 상태 색, 작업 단위 `ListComments{jobId}`는 유지한다.

## 유지할 것
- CreateComment, 멀티모달 context 줄, 품질·패스 한 줄 context, 클립 배치
- 좋아요·싫어요·근거 영상 tag 클립
- `login_screen.dart`는 고치지 않는다

## 이번 작업에서 만들지 않음
- 녹화 버튼의 공통 헤더 이동
- 품질·패스의 미디어·구간·검사 행·범례 context
- 재생으로 화면 되살리기, 자막 파일 표시
- `ListComments{assetId}`, 패스별 목록 필터
- STT 실패 코드 문구, 화면을 다시 열 때 `ListRuns`로 실행 복귀
- proto 재생성

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
- `./scripts/agent_check.sh test/screen_comment_test.dart` 통과
- 저장이 `UpdateComment`로 그 코멘트의 글만 보내고, 목록 글이 바뀐다
- 삭제가 `DeleteComment` 한 번이고, 목록에서 빠지며 녹화 파일을 지우는 호출은 없다
- 생성·목록·멀티모달 context는 그대로다
