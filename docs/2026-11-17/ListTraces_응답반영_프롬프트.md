# ListTraces 요청·응답 정상화

## 목표
`TraceService/ListTraces`는 proto대로 `pageSize`만 보내도 되고, 서버가 준 `traces`가 UI에 빠지지 않고 반영되게 한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md` (가이드라인 저장소는 워킹 트리 밖에서 읽기만)
3. `protos/mediatag/trace/v1/trace.proto`
4. `lib/src/data/repositories/remote_trace_repository.dart`
5. `lib/src/presentation/features/collection_monitoring/pipeline_trace_view_model.dart`

## 현재 상태
- `RemoteTraceRepository.listTraces`: `ListTracesRequest(pageSize: size)`만 보냄. status 비움(=전부)은 proto와 일치.
- 서버에 Trace가 없으면 HTTP 200 `{}`. Trace가 있으면 `traces[]`가 온다(예: `TRACE_STATUS_DONE`, int64 문자열 id).
- ViewModel은 `listTraces(pageSize: 80)` 결과를 `_traces`에 넣고 filter=`all`이면 DONE도 `visibleTraces`에 남긴다.

## 바꿀 것
1. 실서버 JSON 형태 fixture로 `ListTracesResponse` → `TraceSnapshot` 매핑이 비지 않는지 단위 테스트로 고정.
2. 매핑을 테스트 가능한 함수로 두고, 파싱/매핑에서 목록이 떨어지는 구멍만 `remote_trace_repository` 쪽에서 고친다.
3. ViewModel이 목록 결과를 filter=`all`에서 DONE 포함해 칩·목록에 쓰는지 테스트로 확인. 막히는 분기만 제거.
4. `./scripts/agent_check.sh` (+관련 테스트) 통과.

## 유지할 것
- `ListTracesRequest`에 status를 넣지 않음(비움 = 전부). pageSize 80.
- TraceService Connect 경로·JsonCodec·생성 코드 직접 수정 금지.
- 폴링 시그니처로 불필요 `notifyListeners` 스킵하는 동작 유지.

## 이번 작업에서 만들지 않음
- 새 추상 계층·인터셉터·테넌트 헤더 인프라
- proto 재생성, RunService/업로드 흐름 변경
- 서버에 Trace를 심는 시드/목 데이터

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
- DevTools에서 `ListTraces` 응답에 `traces`가 있으면 적재 파이프라인 칩/그래프에 DONE 건수가 보인다
