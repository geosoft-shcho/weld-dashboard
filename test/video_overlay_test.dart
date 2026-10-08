import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/domain/entities/job_timeline.dart';
import 'package:weld_dashboard/src/presentation/features/video_multimodal/video_overlay_clock.dart';
import 'package:weld_dashboard/src/presentation/features/video_multimodal/video_overlay_frame.dart';
import 'package:weld_dashboard/src/presentation/features/video_multimodal/video_overlay_json.dart';
import 'package:weld_dashboard/src/presentation/features/video_multimodal/video_subtitle_text.dart';

void main() {
  test('pose body keeps the box and the torch points', () {
    final frames = parsePoseOverlay('''
{
  "data": {
    "frameRate": 24,
    "keypointSchema": ["tip", "grip"],
    "skeleton": [["tip", "grip"]],
    "lsfResult": {
      "value": {
        "sequence": [
          {"time": 0, "enabled": false},
          {
            "time": 1,
            "enabled": true,
            "x": 50.4,
            "y": 28.8,
            "width": 35,
            "height": 71.1,
            "keypoints": [
              {"name": "tip", "x": 54.69, "y": 44.39},
              {"name": "grip", "x": 70.27, "y": 86.86}
            ]
          },
          {"time": 2, "enabled": false}
        ]
      }
    }
  }
}
''');

    expect(frames, hasLength(1));
    expect(frames.single.start, const Duration(seconds: 1));
    expect(frames.single.end, const Duration(seconds: 2));
    expect(frames.single.boxes.single.left, closeTo(0.504, 0.0001));
    expect(frames.single.boxes.single.top, closeTo(0.288, 0.0001));
    expect(frames.single.points, hasLength(2));
    expect(frames.single.points.first.x, closeTo(0.5469, 0.0001));
    expect(frames.single.bones.single.startIndex, 0);
    expect(frames.single.bones.single.endIndex, 1);
  });

  test('a broken pose body is empty', () {
    expect(parsePoseOverlay('not-json'), isEmpty);
    expect(parsePoseOverlay('{"data":{}}'), isEmpty);
  });

  test('one webvtt cue becomes a caption and json without text does not', () {
    final cues = parseSubtitleCues('''
WEBVTT

00:00:01.000 --> 00:00:04.000
안녕
''');
    expect(cues, hasLength(1));
    expect(cues.single.text, '안녕');
    expect(cues.single.start, const Duration(seconds: 1));
    expect(cues.single.end, const Duration(seconds: 4));

    final srt = parseSubtitleCues('''
1
00:00:01,000 --> 00:00:02,000
hello
''');
    expect(srt.single.text, 'hello');
    expect(srt.single.start, const Duration(seconds: 1));
    expect(parseSubtitleCues('{"cues":[]}'), isEmpty);
    expect(parseSubtitleCues('{"data":{"label":"speaker_1"}}'), isEmpty);
  });

  test('subtitle json shows data.text for the file interval', () {
    const text = '먼저 여기에 일정한 라인을 그려놨습니다. 폭은 5mm, 6mm, 7mm, 8mm, 9mm, 10mm';
    final cues = parseSubtitleCues('''
{
  "data": {
    "start": 15.52,
    "end": 23.44,
    "label": "speaker_1",
    "text": "$text"
  }
}
''');

    expect(cues, hasLength(1));
    expect(cues.single.text, text);
    expect(cues.single.start, const Duration(microseconds: 15520000));
    expect(cues.single.end, const Duration(microseconds: 23440000));

    final shifted = captionsOnVideo(
      videoStartSeconds: 0,
      videoEndSeconds: 40,
      overlays: const [
        TimelineOverlay(
          assetId: '40',
          kind: TimelineOverlayKind.subtitle,
          contentUrl: 'http://host/caption.json',
          timelineStartNs: '10000000000',
          timelineEndNs: '40000000000',
        ),
      ],
      cuesByAssetId: {'40': cues},
    );
    expect(shifted.single.text, text);
    expect(shifted.single.start, const Duration(microseconds: 25520000));
  });

  test(
    'a pose clip ten seconds later shows file time 1s at video local 11s',
    () {
      final frames = framesOnVideo(
        videoStartSeconds: 0,
        videoEndSeconds: 30,
        overlays: const [
          TimelineOverlay(
            assetId: '30',
            kind: TimelineOverlayKind.pose,
            contentUrl: 'http://host/pose.json',
            timelineStartNs: '10000000000',
            timelineEndNs: '20000000000',
          ),
        ],
        framesByAssetId: {
          '30': [
            VideoOverlayFrame(
              start: const Duration(seconds: 1),
              end: const Duration(seconds: 2),
              boxes: const [],
              points: const [VideoOverlayPoint(x: 0.5, y: 0.4)],
              bones: const [],
            ),
          ],
        },
      );

      expect(frames.single.start, const Duration(seconds: 11));
      expect(frames.single.end, const Duration(seconds: 12));
      expect(frames.single.points.single.x, 0.5);
    },
  );

  test('source start pulls the pose back onto the video clock', () {
    final frames = framesOnVideo(
      videoStartSeconds: 0,
      videoEndSeconds: 30,
      overlays: const [
        TimelineOverlay(
          assetId: '30',
          kind: TimelineOverlayKind.pose,
          contentUrl: 'http://host/pose.json',
          timelineStartNs: '0',
          timelineEndNs: '30000000000',
          sourceStartNs: '2000000000',
          sourceEndNs: '4000000000',
        ),
      ],
      framesByAssetId: {
        '30': const [
          VideoOverlayFrame(
            start: Duration(seconds: 3),
            end: Duration(seconds: 4),
            boxes: [],
            points: [VideoOverlayPoint(x: 0.2, y: 0.2)],
            bones: [],
          ),
          VideoOverlayFrame(
            start: Duration(seconds: 5),
            end: Duration(seconds: 6),
            boxes: [],
            points: [VideoOverlayPoint(x: 0.9, y: 0.9)],
            bones: [],
          ),
        ],
      },
    );

    expect(frames, hasLength(1));
    expect(frames.single.start, const Duration(seconds: 1));
    expect(frames.single.points.single.x, 0.2);
  });

  test('a video without overlays has no captions or frames', () {
    expect(
      captionsOnVideo(
        videoStartSeconds: 0,
        videoEndSeconds: 10,
        overlays: const [],
        cuesByAssetId: const {},
      ),
      isEmpty,
    );
    expect(
      framesOnVideo(
        videoStartSeconds: 0,
        videoEndSeconds: 10,
        overlays: const [],
        framesByAssetId: const {},
      ),
      isEmpty,
    );
  });
}
