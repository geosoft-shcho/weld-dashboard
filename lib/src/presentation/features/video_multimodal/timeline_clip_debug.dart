import 'package:flutter/foundation.dart';

import 'video_multimodal_view_model.dart';

void debugLaneClip(
  TimelineSampleClip clip, [
  List<TimelineSampleClip> sources = const [],
]) {
  final sourceText = [
    for (final source in sources)
      '${source.clipId} ${source.startSeconds}s~${source.endSeconds}s',
  ].join(', ');
  debugPrint(
    '[timeline] ${clip.laneKey} ${clip.startSeconds}s~${clip.endSeconds}s '
    '{clipId: ${clip.clipId}, laneLabel: ${clip.laneLabel}, '
    'text: ${clip.text}, showsAiBadge: ${clip.showsAiBadge}, '
    'isDashed: ${clip.isDashed}}'
    '${sourceText.isEmpty ? '' : ' sources: $sourceText'}',
  );
}

void debugLaneClipResize(
  TimelineSampleClip clip,
  double fromStart,
  double fromEnd,
) {
  debugPrint(
    '[timeline] resize ${clip.laneKey} '
    '${fromStart}s~${fromEnd}s -> ${clip.startSeconds}s~${clip.endSeconds}s '
    '{clipId: ${clip.clipId}, laneLabel: ${clip.laneLabel}, text: ${clip.text}}',
  );
}
