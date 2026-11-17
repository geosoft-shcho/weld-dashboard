//
//  Generated code. Do not modify.
//  source: mediatag/trace/v1/trace.proto
//

import "package:connectrpc/connect.dart" as connect;
import "trace.pb.dart" as mediatagtracev1trace;
import "trace.connect.spec.dart" as specs;

extension type TraceServiceClient (connect.Transport _transport) {
  /// 최근 여정 목록, 새것부터. 진행 중 화면은 status = RUNNING으로 1~2초 폴링한다.
  Future<mediatagtracev1trace.ListTracesResponse> listTraces(
    mediatagtracev1trace.ListTracesRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.TraceService.listTraces,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 여정 한 건과 이벤트 전부(오래된 것부터). 없으면 NotFound.
  Future<mediatagtracev1trace.GetTraceResponse> getTrace(
    mediatagtracev1trace.GetTraceRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.TraceService.getTrace,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
