import 'dart:convert';

import 'video_overlay_frame.dart';

const double POSE_PERCENT_SCALE = 100;

/// content_url 포즈 본문을 프레임으로 바꾼다.
/// 확인한 본문은 `data.lsfResult.value.sequence`이고, 좌표는 0~100이다.
List<VideoOverlayFrame> parsePoseOverlay(String source) {
  if (source.trim().isEmpty) {
    return const [];
  }
  Object? decoded;
  try {
    decoded = jsonDecode(source);
  } catch (_) {
    return const [];
  }
  if (decoded is! Map) {
    return const [];
  }
  final data = decoded['data'];
  if (data is! Map) {
    return const [];
  }
  final result = data['lsfResult'];
  final value = result is Map ? result['value'] : null;
  final sequence = value is Map ? value['sequence'] : null;
  if (sequence is! List) {
    return const [];
  }
  final frameRate = _number(data['frameRate']);
  final names = _names(data['keypointSchema']);
  final links = _links(data['skeleton']);
  final frames = <VideoOverlayFrame>[];
  for (var index = 0; index < sequence.length; index++) {
    final item = sequence[index];
    if (item is! Map || item['enabled'] != true) {
      continue;
    }
    final start = _number(item['time']);
    final next = index + 1 < sequence.length
        ? _itemTime(sequence[index + 1])
        : start;
    final spanEnd = next > start
        ? next
        : start + (frameRate > 0 ? 1 / frameRate : 1 / 24);
    final named = _points(item['keypoints'], names);
    final boxes = _boxes(item);
    if (boxes.isEmpty && named.points.isEmpty) {
      continue;
    }
    frames.add(
      VideoOverlayFrame(
        start: _seconds(start),
        end: _seconds(spanEnd),
        boxes: boxes,
        points: named.points,
        bones: _bones(links, named.indexesByName),
      ),
    );
  }
  return frames;
}

List<VideoOverlayBox> _boxes(Map item) {
  if (item['x'] == null ||
      item['y'] == null ||
      item['width'] == null ||
      item['height'] == null) {
    return const [];
  }
  return [
    VideoOverlayBox(
      left: _unit(item['x']),
      top: _unit(item['y']),
      width: _unit(item['width']),
      height: _unit(item['height']),
    ),
  ];
}

class _NamedPoints {
  const _NamedPoints(this.points, this.indexesByName);

  final List<VideoOverlayPoint> points;
  final Map<String, int> indexesByName;
}

_NamedPoints _points(Object? raw, List<String> schema) {
  final byName = <String, Map>{};
  if (raw is List) {
    for (final item in raw) {
      if (item is Map && item['name'] != null) {
        byName[item['name'].toString()] = item;
      }
    }
  }
  final points = <VideoOverlayPoint>[];
  final indexesByName = <String, int>{};
  final ordered = schema.isEmpty ? byName.keys.toList() : schema;
  for (final name in ordered) {
    final item = byName[name];
    if (item == null) {
      continue;
    }
    indexesByName[name] = points.length;
    points.add(VideoOverlayPoint(x: _unit(item['x']), y: _unit(item['y'])));
  }
  return _NamedPoints(points, indexesByName);
}

List<VideoOverlayBone> _bones(
  List<List<String>> links,
  Map<String, int> indexesByName,
) {
  final bones = <VideoOverlayBone>[];
  for (final link in links) {
    final start = indexesByName[link[0]];
    final end = indexesByName[link[1]];
    if (start == null || end == null) {
      continue;
    }
    bones.add(VideoOverlayBone(startIndex: start, endIndex: end));
  }
  return bones;
}

List<String> _names(Object? raw) {
  if (raw is! List) {
    return const [];
  }
  return [for (final item in raw) item.toString()];
}

List<List<String>> _links(Object? raw) {
  if (raw is! List) {
    return const [];
  }
  final links = <List<String>>[];
  for (final pair in raw) {
    if (pair is List && pair.length >= 2) {
      links.add([pair[0].toString(), pair[1].toString()]);
    }
  }
  return links;
}

double _itemTime(Object? item) {
  if (item is! Map) {
    return 0;
  }
  return _number(item['time']);
}

double _number(Object? value) {
  if (value is num) {
    return value.toDouble();
  }
  return 0;
}

double _unit(Object? value) => _number(value) / POSE_PERCENT_SCALE;

Duration _seconds(double seconds) {
  return Duration(microseconds: (seconds * 1000000).round());
}
