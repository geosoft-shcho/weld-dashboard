import 'package:flutter/foundation.dart';

import 'video_frame_mark.dart';

void debugVideoFrameMark(int markIndex, VideoFrameMark mark) {
  final body = switch (mark) {
    VideoBoxMark box =>
      'box ${box.name} '
          'left=${box.left} top=${box.top} '
          'width=${box.width} height=${box.height}',
    VideoSkeletonMark skeleton =>
      'skeleton ${skeleton.name} '
          '${[
            for (var index = 0; index < skeleton.points.length; index++)
              '$index:${skeleton.points[index].x},${skeleton.points[index].y}',
          ].join(' ')}',
  };
  debugPrint('[frame-mark] $markIndex $body');
}
