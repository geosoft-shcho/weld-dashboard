import 'dart:convert';

import 'package:flutter/services.dart';

import 'video_frame_mark.dart';

const String POSE_FRAME_MARK_ASSET = 'docs/mock-pose.json';
const String TORCH_FRAME_MARK_ASSET = 'docs/mock-torch.json';

/// 포즈·토치 목업을 한 번 읽어 재생 파일의 로컬 초 구간으로 바꾼다.
Future<List<VideoFrameMark>> loadMockVideoFrameMarks() async {
  final pose = await rootBundle.loadString(POSE_FRAME_MARK_ASSET);
  final torch = await rootBundle.loadString(TORCH_FRAME_MARK_ASSET);
  return [...parseVideoFrameMarks(pose), ...parseVideoFrameMarks(torch)];
}

List<VideoFrameMark> parseVideoFrameMarks(String source) {
  final decoded = jsonDecode(source);
  if (decoded is! Map) {
    throw const FormatException('좌표 목업 형식이 아닙니다.');
  }
  final data = decoded['data'];
  if (data is! Map) {
    throw const FormatException('좌표 목업에 data 가 없습니다.');
  }
  final result = data['lsfResult'];
  final value = result is Map ? result['value'] : null;
  final sequence = value is Map ? value['sequence'] : null;
  if (sequence is! List) {
    throw const FormatException('좌표 목업에 sequence 가 없습니다.');
  }
  final name = _text(data['label']);
  final frameRate = _number(data['frameRate']);
  final names = _names(data['keypointSchema']);
  final links = _links(data['skeleton']);
  final marks = <VideoFrameMark>[];
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
    final spanStart = _seconds(start);
    final spanStop = _seconds(spanEnd);
    marks.add(
      VideoBoxMark(
        name: name,
        left: _unit(item['x']),
        top: _unit(item['y']),
        width: _unit(item['width']),
        height: _unit(item['height']),
        start: spanStart,
        end: spanStop,
      ),
    );
    final named = _points(item['keypoints'], names);
    if (named.isEmpty) {
      continue;
    }
    marks.add(
      VideoSkeletonMark(
        name: name,
        points: named.points,
        bones: _bones(links, named.names),
        start: spanStart,
        end: spanStop,
      ),
    );
  }
  return marks;
}

double _itemTime(Object? item) {
  if (item is! Map) {
    return 0;
  }
  return _number(item['time']);
}

class _NamedPoints {
  const _NamedPoints(this.points, this.names);

  final List<VideoFramePoint> points;
  final Map<String, int> names;

  bool get isEmpty => points.isEmpty;
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
  final points = <VideoFramePoint>[];
  final names = <String, int>{};
  final ordered = schema.isEmpty ? byName.keys.toList() : schema;
  for (final name in ordered) {
    final item = byName[name];
    if (item == null) {
      continue;
    }
    names[name] = points.length;
    points.add(VideoFramePoint(x: _unit(item['x']), y: _unit(item['y'])));
  }
  return _NamedPoints(points, names);
}

List<VideoSkeletonBone> _bones(
  List<List<String>> links,
  Map<String, int> names,
) {
  final bones = <VideoSkeletonBone>[];
  for (final link in links) {
    final start = names[link[0]];
    final end = names[link[1]];
    if (start == null || end == null) {
      continue;
    }
    bones.add(VideoSkeletonBone(startIndex: start, endIndex: end));
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

String _text(Object? value) {
  final text = value?.toString().trim() ?? '';
  return text.isEmpty ? 'mark' : text;
}

double _number(Object? value) {
  if (value is num) {
    return value.toDouble();
  }
  return 0;
}

double _unit(Object? value) => _number(value) / 100;

Duration _seconds(double seconds) {
  return Duration(microseconds: (seconds * 1000000).round());
}
