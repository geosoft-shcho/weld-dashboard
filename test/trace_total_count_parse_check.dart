import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/data/datasources/generated/mediatag/trace/v1/trace.pb.dart';
import 'package:weld_dashboard/src/data/datasources/generated/mediatag/trace/v1/trace.pbenum.dart';
import 'package:weld_dashboard/src/data/repositories/remote_trace_repository.dart';

void main() {
  test('ListTracesRequest encodes status filter', () {
    final req = ListTracesRequest(
      pageSize: 1,
      status: TraceStatus.TRACE_STATUS_FAILED,
    );
    expect(req.hasStatus(), isTrue);
    final json = req.toProto3Json() as Map;
    expect(json['status'], 'TRACE_STATUS_FAILED');
    expect(json['pageSize'], 1);
  });

  test('ListTracesResponse parses string totalCount', () {
    final res = ListTracesResponse()
      ..mergeFromProto3Json({
        'traces': [
          {
            'traceId': '182',
            'status': 'TRACE_STATUS_FAILED',
            'lastEvent': 'receive.abandoned',
          },
          {
            'traceId': '203',
            'status': 'TRACE_STATUS_DONE',
            'lastEvent': 'done.stored',
          },
        ],
        'nextPageToken': '92',
        'totalCount': '171',
      });
    expect(res.totalCount.toInt(), 171);
    expect(res.traces.length, 2);
    expect(traceStatusFrom(res.traces[0].status), isNot(null));
  });

  test('page traces length must not replace totalCount', () {
    final res = ListTracesResponse()
      ..mergeFromProto3Json({
        'traces': List.generate(
          80,
          (i) => {'traceId': '$i', 'status': 'TRACE_STATUS_DONE'},
        ),
        'totalCount': '171',
      });
    expect(res.traces.length, 80);
    expect(res.totalCount.toInt(), 171);
    expect(res.traces.length, isNot(res.totalCount.toInt()));
  });
}
