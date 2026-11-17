//
//  Generated code. Do not modify.
//  source: mediatag/trace/v1/trace.proto
//

import "package:connectrpc/connect.dart" as connect;
import "trace.pb.dart" as mediatagtracev1trace;

abstract final class TraceService {
  /// Fully-qualified name of the TraceService service.
  static const name = 'mediatag.trace.v1.TraceService';

  /// 최근 여정 목록, 새것부터. 진행 중 화면은 status = RUNNING으로 1~2초 폴링한다.
  static const listTraces = connect.Spec(
    '/$name/ListTraces',
    connect.StreamType.unary,
    mediatagtracev1trace.ListTracesRequest.new,
    mediatagtracev1trace.ListTracesResponse.new,
  );

  /// 여정 한 건과 이벤트 전부(오래된 것부터). 없으면 NotFound.
  static const getTrace = connect.Spec(
    '/$name/GetTrace',
    connect.StreamType.unary,
    mediatagtracev1trace.GetTraceRequest.new,
    mediatagtracev1trace.GetTraceResponse.new,
  );
}
