import 'dart:convert';

import 'video_caption.dart';

final RegExp _CUE_TIME = RegExp(
  r'(?:(\d{2}):)?(\d{2}):(\d{2})[.,](\d{3})\s*-->\s*(?:(\d{2}):)?(\d{2}):(\d{2})[.,](\d{3})',
);

/// 자막 본문을 영상 자막으로 바꾼다.
/// JSON이면 `data.text` 한 줄, 그 외에는 WebVTT 또는 SRT다.
List<VideoCaption> parseSubtitleCues(String source) {
  final trimmed = source.trimLeft();
  if (trimmed.isEmpty) {
    return const [];
  }
  if (trimmed.startsWith('{') || trimmed.startsWith('[')) {
    return _cuesFromSubtitleJson(trimmed);
  }
  final lines = source.replaceAll('\r\n', '\n').split('\n');
  final cues = <VideoCaption>[];
  var index = 0;
  while (index < lines.length) {
    final match = _CUE_TIME.firstMatch(lines[index].trim());
    if (match == null) {
      index += 1;
      continue;
    }
    final textLines = <String>[];
    index += 1;
    while (index < lines.length && lines[index].trim().isNotEmpty) {
      textLines.add(lines[index].trim());
      index += 1;
    }
    final text = textLines.join('\n').trim();
    if (text.isEmpty) {
      continue;
    }
    cues.add(
      VideoCaption(
        text: text,
        start: _clock(match, isStart: true),
        end: _clock(match, isStart: false),
      ),
    );
  }
  return cues;
}

List<VideoCaption> _cuesFromSubtitleJson(String source) {
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
  final rawText = data['text'];
  if (rawText is! String) {
    return const [];
  }
  final text = rawText.trim();
  final start = _seconds(data['start']);
  final end = _seconds(data['end']);
  if (text.isEmpty || end <= start) {
    return const [];
  }
  return [VideoCaption(text: text, start: start, end: end)];
}

Duration _seconds(Object? value) {
  if (value is! num) {
    return Duration.zero;
  }
  return Duration(microseconds: (value.toDouble() * 1000000).round());
}

Duration _clock(RegExpMatch match, {required bool isStart}) {
  final hourIndex = isStart ? 1 : 5;
  final minuteIndex = isStart ? 2 : 6;
  final secondIndex = isStart ? 3 : 7;
  final milliIndex = isStart ? 4 : 8;
  final hours = int.parse(match.group(hourIndex) ?? '0');
  final minutes = int.parse(match.group(minuteIndex)!);
  final seconds = int.parse(match.group(secondIndex)!);
  final millis = int.parse(match.group(milliIndex)!);
  return Duration(
    hours: hours,
    minutes: minutes,
    seconds: seconds,
    milliseconds: millis,
  );
}
