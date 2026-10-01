//
//  Generated code. Do not modify.
//  source: mediatag/compose/v1/compose.proto
//

import "package:connectrpc/connect.dart" as connect;
import "compose.pb.dart" as mediatagcomposev1compose;
import "compose.connect.spec.dart" as specs;

extension type MediaComposeServiceClient (connect.Transport _transport) {
  /// 타임라인 + 전 트랙 + 클립(+ 클립이 가리키는 Asset)을 한 번에. 아직 편집 안 한 작업이면
  /// 빈 draft 타임라인을 준다(행은 만들지 않음). pass_id를 주면 그 패스 구간과 겹치는 클립만 준다.
  Future<mediatagcomposev1compose.GetTimelineResponse> getTimeline(
    mediatagcomposev1compose.GetTimelineRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.MediaComposeService.getTimeline,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<mediatagcomposev1compose.ListTimelinesResponse> listTimelines(
    mediatagcomposev1compose.ListTimelinesRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.MediaComposeService.listTimelines,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// name, description, labels
  Future<mediatagcomposev1compose.UpdateTimelineResponse> updateTimeline(
    mediatagcomposev1compose.UpdateTimelineRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.MediaComposeService.updateTimeline,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 현재 상태가 from_status일 때만 바꾼다. 아니면 Aborted(다른 요청이 먼저 바꿈).
  Future<mediatagcomposev1compose.ChangeTimelineStatusResponse> changeTimelineStatus(
    mediatagcomposev1compose.ChangeTimelineStatusRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.MediaComposeService.changeTimelineStatus,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 편집 초기화: 타임라인과 트랙·클립을 지운다(작업·첨부는 그대로).
  Future<mediatagcomposev1compose.DeleteTimelineResponse> deleteTimeline(
    mediatagcomposev1compose.DeleteTimelineRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.MediaComposeService.deleteTimeline,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<mediatagcomposev1compose.CreateTrackResponse> createTrack(
    mediatagcomposev1compose.CreateTrackRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.MediaComposeService.createTrack,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// name, order, visible
  Future<mediatagcomposev1compose.UpdateTrackResponse> updateTrack(
    mediatagcomposev1compose.UpdateTrackRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.MediaComposeService.updateTrack,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 트랙의 클립도 함께 지워진다.
  Future<mediatagcomposev1compose.DeleteTrackResponse> deleteTrack(
    mediatagcomposev1compose.DeleteTrackRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.MediaComposeService.deleteTrack,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 같은 트랙 클립과 구간이 겹치면 FailedPrecondition. source.asset_id가 이 작업에
  /// 첨부되지 않았으면 같은 트랜잭션에서 작업 공용으로 첨부한다.
  Future<mediatagcomposev1compose.CreateClipResponse> createClip(
    mediatagcomposev1compose.CreateClipRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.MediaComposeService.createClip,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 오류 조건·자동 첨부는 CreateClip과 같다. 검수는 update_mask "provenance.reviewed".
  Future<mediatagcomposev1compose.UpdateClipResponse> updateClip(
    mediatagcomposev1compose.UpdateClipRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.MediaComposeService.updateClip,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<mediatagcomposev1compose.DeleteClipResponse> deleteClip(
    mediatagcomposev1compose.DeleteClipRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.MediaComposeService.deleteClip,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
/// 통제 어휘(어휘 = 분류 축, 값 = 그 축의 선택지). 모든 공사가 같이 쓴다. 값은 지우지 않고
/// deprecated로 숨긴다.
extension type LabelServiceClient (connect.Transport _transport) {
  /// 전체 어휘와 값. 어휘 수가 적어 페이지를 두지 않는다.
  Future<mediatagcomposev1compose.ListLabelVocabsResponse> listLabelVocabs(
    mediatagcomposev1compose.ListLabelVocabsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.LabelService.listLabelVocabs,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<mediatagcomposev1compose.CreateLabelVocabResponse> createLabelVocab(
    mediatagcomposev1compose.CreateLabelVocabRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.LabelService.createLabelVocab,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<mediatagcomposev1compose.CreateLabelValueResponse> createLabelValue(
    mediatagcomposev1compose.CreateLabelValueRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.LabelService.createLabelValue,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// name·deprecated·description만 바꿀 수 있다. 이름을 바꿔도 Clip은 value_id로
  /// 가리키므로 따로 갱신할 게 없다.
  Future<mediatagcomposev1compose.UpdateLabelValueResponse> updateLabelValue(
    mediatagcomposev1compose.UpdateLabelValueRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.LabelService.updateLabelValue,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
