//
//  Generated code. Do not modify.
//  source: tacittag/rag/v2/rag.proto
//

import "package:connectrpc/connect.dart" as connect;
import "rag.pb.dart" as tacittagragv2rag;

/// RagService — STT TEXT segment 검색 + LLM 답변.
/// Connect URL: {BFF_BASE_URL}/tacittag.rag.v2.RagService/{Method}
/// REST 매핑 (welding-pose):
///   AskQuestion       -> POST /api/v1/rag/ask
///   GetSessionHistory -> GET  /api/v1/rag/sessions/{sessionId}/messages
///   IndexProject      -> POST /api/v1/rag/index
abstract final class RagService {
  /// Fully-qualified name of the RagService service.
  static const name = 'tacittag.rag.v2.RagService';

  /// 프로젝트 TEXT layer에서 관련 구간 검색 후 LLM 답변 + citations 반환.
  /// session_id 생략 시 새 세션 생성. 동일 session_id로 후속 질문 시 LLM 컨텍스트 유지.
  static const askQuestion = connect.Spec(
    '/$name/AskQuestion',
    connect.StreamType.unary,
    tacittagragv2rag.AskQuestionRequest.new,
    tacittagragv2rag.AskQuestionResponse.new,
  );

  /// 세션 대화 기록 조회. 프론트가 화면에 지난 질문·답변을 렌더링할 때 사용.
  static const getSessionHistory = connect.Spec(
    '/$name/GetSessionHistory',
    connect.StreamType.unary,
    tacittagragv2rag.GetSessionHistoryRequest.new,
    tacittagragv2rag.GetSessionHistoryResponse.new,
  );

  /// TEXT layer를 Redis 벡터 인덱스에 upsert. watcher 자동 인덱싱 외 수동/재빌드용.
  static const indexProject = connect.Spec(
    '/$name/IndexProject',
    connect.StreamType.unary,
    tacittagragv2rag.IndexProjectRequest.new,
    tacittagragv2rag.IndexProjectResponse.new,
  );
}
