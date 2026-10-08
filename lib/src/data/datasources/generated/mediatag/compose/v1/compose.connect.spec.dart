//
//  Generated code. Do not modify.
//  source: mediatag/compose/v1/compose.proto
//

import "package:connectrpc/connect.dart" as connect;
import "compose.pb.dart" as mediatagcomposev1compose;

abstract final class MediaComposeService {
  /// Fully-qualified name of the MediaComposeService service.
  static const name = 'mediatag.compose.v1.MediaComposeService';

  /// 타임라인 + 전 트랙 + 클립(+ 클립이 가리키는 Asset)을 한 번에. 아직 편집 안 한 작업이면
  /// 빈 draft 타임라인을 준다(행은 만들지 않음). pass_id를 주면 그 패스 구간과 겹치는 클립만 준다.
  static const getTimeline = connect.Spec(
    '/$name/GetTimeline',
    connect.StreamType.unary,
    mediatagcomposev1compose.GetTimelineRequest.new,
    mediatagcomposev1compose.GetTimelineResponse.new,
  );

  static const listTimelines = connect.Spec(
    '/$name/ListTimelines',
    connect.StreamType.unary,
    mediatagcomposev1compose.ListTimelinesRequest.new,
    mediatagcomposev1compose.ListTimelinesResponse.new,
  );

  /// name, description, labels
  static const updateTimeline = connect.Spec(
    '/$name/UpdateTimeline',
    connect.StreamType.unary,
    mediatagcomposev1compose.UpdateTimelineRequest.new,
    mediatagcomposev1compose.UpdateTimelineResponse.new,
  );

  /// 현재 상태가 from_status일 때만 바꾼다. 아니면 Aborted(다른 요청이 먼저 바꿈).
  static const changeTimelineStatus = connect.Spec(
    '/$name/ChangeTimelineStatus',
    connect.StreamType.unary,
    mediatagcomposev1compose.ChangeTimelineStatusRequest.new,
    mediatagcomposev1compose.ChangeTimelineStatusResponse.new,
  );

  /// 편집 초기화: 타임라인과 트랙·클립을 지운다(작업·첨부는 그대로).
  static const deleteTimeline = connect.Spec(
    '/$name/DeleteTimeline',
    connect.StreamType.unary,
    mediatagcomposev1compose.DeleteTimelineRequest.new,
    mediatagcomposev1compose.DeleteTimelineResponse.new,
  );

  static const createTrack = connect.Spec(
    '/$name/CreateTrack',
    connect.StreamType.unary,
    mediatagcomposev1compose.CreateTrackRequest.new,
    mediatagcomposev1compose.CreateTrackResponse.new,
  );

  /// name, order, visible
  static const updateTrack = connect.Spec(
    '/$name/UpdateTrack',
    connect.StreamType.unary,
    mediatagcomposev1compose.UpdateTrackRequest.new,
    mediatagcomposev1compose.UpdateTrackResponse.new,
  );

  /// 트랙의 클립도 함께 지워진다.
  static const deleteTrack = connect.Spec(
    '/$name/DeleteTrack',
    connect.StreamType.unary,
    mediatagcomposev1compose.DeleteTrackRequest.new,
    mediatagcomposev1compose.DeleteTrackResponse.new,
  );

  /// 같은 트랙 클립과 구간이 겹치면 FailedPrecondition. source.asset_id가 이 작업에
  /// 첨부되지 않았으면 같은 트랜잭션에서 작업 공용으로 첨부한다.
  static const createClip = connect.Spec(
    '/$name/CreateClip',
    connect.StreamType.unary,
    mediatagcomposev1compose.CreateClipRequest.new,
    mediatagcomposev1compose.CreateClipResponse.new,
  );

  /// 오류 조건·자동 첨부는 CreateClip과 같다. 검수는 update_mask "provenance.reviewed".
  static const updateClip = connect.Spec(
    '/$name/UpdateClip',
    connect.StreamType.unary,
    mediatagcomposev1compose.UpdateClipRequest.new,
    mediatagcomposev1compose.UpdateClipResponse.new,
  );

  static const deleteClip = connect.Spec(
    '/$name/DeleteClip',
    connect.StreamType.unary,
    mediatagcomposev1compose.DeleteClipRequest.new,
    mediatagcomposev1compose.DeleteClipResponse.new,
  );
}
/// 라벨(통제 어휘). 모든 공사가 같이 쓴다. 지우지 않고 deprecated로 숨긴다.
abstract final class LabelService {
  /// Fully-qualified name of the LabelService service.
  static const name = 'mediatag.compose.v1.LabelService';

  /// 라벨 전부. 라벨은 한 그루의 트리다: 상위가 없는 것(parent_value_id = 0)이 맨 위 분류(루트)이고 그 아래로 값이 달린다
  /// (에셋 트리와 같은 모양). 평평한 목록으로 주니 parent_value_id로 엮는다. 수가 적어 페이지를 두지 않는다.
  static const listLabels = connect.Spec(
    '/$name/ListLabels',
    connect.StreamType.unary,
    mediatagcomposev1compose.ListLabelsRequest.new,
    mediatagcomposev1compose.ListLabelsResponse.new,
  );

  /// 라벨을 만든다. name 필수. parent_value_id를 주면 그 아래에, 안 주면 맨 위 분류(루트)로 만든다.
  static const createLabelValue = connect.Spec(
    '/$name/CreateLabelValue',
    connect.StreamType.unary,
    mediatagcomposev1compose.CreateLabelValueRequest.new,
    mediatagcomposev1compose.CreateLabelValueResponse.new,
  );

  /// name·deprecated·description만 바꿀 수 있다. 이름을 바꿔도 Clip은 value_id로
  /// 가리키므로 따로 갱신할 게 없다.
  static const updateLabelValue = connect.Spec(
    '/$name/UpdateLabelValue',
    connect.StreamType.unary,
    mediatagcomposev1compose.UpdateLabelValueRequest.new,
    mediatagcomposev1compose.UpdateLabelValueResponse.new,
  );
}
