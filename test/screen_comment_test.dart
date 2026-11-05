import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/domain/entities/asset_upload.dart';
import 'package:weld_dashboard/src/domain/entities/camera_recording.dart';
import 'package:weld_dashboard/src/domain/entities/screen_comment.dart';
import 'package:weld_dashboard/src/domain/entities/tool_run.dart';
import 'package:weld_dashboard/src/domain/repositories/asset_upload_repository.dart';
import 'package:weld_dashboard/src/domain/repositories/camera_recording_repository.dart';
import 'package:weld_dashboard/src/domain/repositories/tool_run_repository.dart';
import 'package:weld_dashboard/src/domain/use_cases/create_screen_comment_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/delete_screen_comment_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/list_screen_comments_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/prepare_camera_recording_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/update_screen_comment_use_case.dart';
import 'package:weld_dashboard/src/presentation/features/video_multimodal/screen_comment_list_view_model.dart';
import 'package:weld_dashboard/src/domain/use_cases/read_camera_preview_handle_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/release_camera_recording_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/start_camera_recording_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/stop_camera_recording_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/tool_run_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/upload_asset_use_case.dart';
import 'package:weld_dashboard/src/presentation/features/video_multimodal/camera_recording_view_model.dart';

void main() {
  test('screen comment stt labels', () {
    expect(screenCommentSttLabel(ScreenCommentSttKind.missing), '맡기지 못함');
    expect(screenCommentSttLabel(ScreenCommentSttKind.queued), '처리 중');
    expect(screenCommentSttLabel(ScreenCommentSttKind.failed), '실패');
    expect(screenCommentSttLabel(ScreenCommentSttKind.succeeded), '완료');
    const comment = ScreenComment(
      commentId: '1',
      body: '',
      sttLabel: '실패',
      sttMessage: '인식된 말소리가 없어 STT 클립을 만들지 않았습니다',
    );
    expect(comment.sttLabel, '실패');
    expect(comment.sttMessage, '인식된 말소리가 없어 STT 클립을 만들지 않았습니다');
  });

  test('comment playback reads the selected clip and its time', () {
    final playback = screenCommentPlayback([
      {
        'selected': [
          {'clip_id': 18664},
        ],
        'range': {'start_ns': 284782016000000, 'end_ns': 284782016000000},
      },
    ]);
    expect(playback.clipId, '18664');
    expect(playback.playheadNs, 284782016000000);

    final quality = screenCommentPlayback([
      {'screen': 'quality', 't_ms': 0, 'job_id': 1219},
    ]);
    expect(quality.clipId, '');
    expect(quality.playheadNs, isNull);
  });

  test(
    'uploaded recording creates one screen comment after placement',
    () async {
      final upload = _CommentUpload();
      final camera = _IdleCamera();
      final context = [
        {'t_ms': 0, 'screen': 'multimodal', 'job_id': 128},
      ];
      final viewModel = CameraRecordingViewModel(
        prepareCameraRecordingUseCase: PrepareCameraRecordingUseCase(camera),
        startCameraRecordingUseCase: StartCameraRecordingUseCase(camera),
        stopCameraRecordingUseCase: StopCameraRecordingUseCase(camera),
        releaseCameraRecordingUseCase: ReleaseCameraRecordingUseCase(camera),
        readCameraPreviewHandleUseCase: ReadCameraPreviewHandleUseCase(camera),
        uploadAssetUseCase: UploadAssetUseCase(upload),
        toolRunUseCase: ToolRunUseCase(_IdleTools()),
        createScreenCommentUseCase: CreateScreenCommentUseCase(upload),
        jobId: '128',
        onUploaded: () async {},
        onRecordingPlaced:
            ({required String assetId, required bool isVideo}) async {},
        capturesScreenComment: true,
        takeScreenCommentContext: () => context,
      );
      viewModel.phase = CameraRecordingPhase.stopped;
      viewModel.recording = CameraRecording(
        recordedAt: DateTime.utc(2026, 11, 5),
        video: CameraRecordingFile(
          bytes: Uint8List.fromList([1]),
          mimeType: 'video/webm',
          fileName: 'video.webm',
        ),
        audio: CameraRecordingFile(
          bytes: Uint8List.fromList([2]),
          mimeType: 'audio/webm',
          fileName: 'audio.webm',
        ),
      );
      viewModel.commentBody = '설명';

      await viewModel.didTapUpload();

      expect(upload.createCount, 1);
      expect(upload.createdContext, context);
      expect(upload.createdAudioAssetId, '77');
      expect(upload.createdVideoAssetId, '55');
      expect(upload.createdBody, '설명');
      expect(viewModel.noticeText, contains('업로드가 완료'));
    },
  );

  test(
    'recording without screen comment capture does not create a comment',
    () async {
      final upload = _CommentUpload();
      final camera = _IdleCamera();
      final viewModel = CameraRecordingViewModel(
        prepareCameraRecordingUseCase: PrepareCameraRecordingUseCase(camera),
        startCameraRecordingUseCase: StartCameraRecordingUseCase(camera),
        stopCameraRecordingUseCase: StopCameraRecordingUseCase(camera),
        releaseCameraRecordingUseCase: ReleaseCameraRecordingUseCase(camera),
        readCameraPreviewHandleUseCase: ReadCameraPreviewHandleUseCase(camera),
        uploadAssetUseCase: UploadAssetUseCase(upload),
        toolRunUseCase: ToolRunUseCase(_IdleTools()),
        createScreenCommentUseCase: CreateScreenCommentUseCase(upload),
        jobId: '128',
        onUploaded: () async {},
        onRecordingPlaced:
            ({required String assetId, required bool isVideo}) async {},
      );
      viewModel.phase = CameraRecordingPhase.stopped;
      viewModel.recording = CameraRecording(
        recordedAt: DateTime.utc(2026, 11, 5),
        video: CameraRecordingFile(
          bytes: Uint8List.fromList([1]),
          mimeType: 'video/webm',
          fileName: 'video.webm',
        ),
        audio: CameraRecordingFile(
          bytes: Uint8List.fromList([2]),
          mimeType: 'audio/webm',
          fileName: 'audio.webm',
        ),
      );

      await viewModel.didTapUpload();

      expect(upload.createCount, 0);
    },
  );

  test('quality recording sends the opened pass and one context row', () async {
    final upload = _CommentUpload();
    final camera = _IdleCamera();
    final context = [
      {'t_ms': 0, 'screen': 'quality', 'job_id': 128, 'pass_id': 9},
    ];
    final viewModel = CameraRecordingViewModel(
      prepareCameraRecordingUseCase: PrepareCameraRecordingUseCase(camera),
      startCameraRecordingUseCase: StartCameraRecordingUseCase(camera),
      stopCameraRecordingUseCase: StopCameraRecordingUseCase(camera),
      releaseCameraRecordingUseCase: ReleaseCameraRecordingUseCase(camera),
      readCameraPreviewHandleUseCase: ReadCameraPreviewHandleUseCase(camera),
      uploadAssetUseCase: UploadAssetUseCase(upload),
      toolRunUseCase: ToolRunUseCase(_IdleTools()),
      createScreenCommentUseCase: CreateScreenCommentUseCase(upload),
      jobId: '128',
      passId: '9',
      onUploaded: () async {},
      onRecordingPlaced:
          ({required String assetId, required bool isVideo}) async {},
      capturesScreenComment: true,
      takeScreenCommentContext: () => context,
    );
    viewModel.phase = CameraRecordingPhase.stopped;
    viewModel.recording = CameraRecording(
      recordedAt: DateTime.utc(2026, 11, 5),
      video: CameraRecordingFile(
        bytes: Uint8List.fromList([1]),
        mimeType: 'video/webm',
        fileName: 'video.webm',
      ),
      audio: CameraRecordingFile(
        bytes: Uint8List.fromList([2]),
        mimeType: 'audio/webm',
        fileName: 'audio.webm',
      ),
    );

    await viewModel.didTapUpload();

    expect(upload.createCount, 1);
    expect(upload.createdPassId, '9');
    expect(upload.createdContext, context);
    expect(upload.createdContext.single['screen'], 'quality');
  });

  test(
    'save updates that comment body and delete removes only the comment',
    () async {
      final upload = _CommentUpload();
      final viewModel = ScreenCommentListViewModel(
        listScreenCommentsUseCase: ListScreenCommentsUseCase(upload),
        updateScreenCommentUseCase: UpdateScreenCommentUseCase(upload),
        deleteScreenCommentUseCase: DeleteScreenCommentUseCase(upload),
        jobId: '128',
      );

      await viewModel.loadComments();
      await viewModel.updateBody(commentId: '1', body: '고친 글');

      expect(upload.updatedCommentId, '1');
      expect(upload.updatedBody, '고친 글');
      expect(upload.createCount, 0);
      expect(viewModel.comments.single.body, '고친 글');

      await viewModel.deleteComment(commentId: '1');

      expect(upload.deleteCount, 1);
      expect(upload.deletedCommentId, '1');
      expect(upload.createCount, 0);
      expect(viewModel.comments, isEmpty);
    },
  );
}

class _CommentUpload implements AssetUploadRepository {
  int createCount = 0;
  List<Map<String, Object?>> createdContext = const [];
  String createdAudioAssetId = '';
  String createdVideoAssetId = '';
  String createdBody = '';
  String createdPassId = '';
  String updatedCommentId = '';
  String updatedBody = '';
  String deletedCommentId = '';
  int deleteCount = 0;
  List<ScreenComment> stored = const [
    ScreenComment(commentId: '1', body: '설명', sttLabel: '처리 중'),
  ];

  @override
  Future<ScreenComment> createScreenComment({
    required String jobId,
    String passId = '',
    required String audioAssetId,
    String videoAssetId = '',
    String body = '',
    required DateTime startedAt,
    required List<Map<String, Object?>> context,
  }) async {
    createCount += 1;
    createdAudioAssetId = audioAssetId;
    createdVideoAssetId = videoAssetId;
    createdBody = body;
    createdPassId = passId;
    createdContext = context;
    return const ScreenComment(commentId: '1', body: '설명', sttLabel: '처리 중');
  }

  @override
  Future<List<ScreenComment>> listScreenComments({
    required String jobId,
  }) async {
    return stored;
  }

  @override
  Future<ScreenComment> updateScreenComment({
    required String commentId,
    required String body,
  }) async {
    updatedCommentId = commentId;
    updatedBody = body;
    final next = ScreenComment(
      commentId: commentId,
      body: body.trim(),
      sttLabel: '처리 중',
    );
    stored = [next];
    return next;
  }

  @override
  Future<void> deleteScreenComment({required String commentId}) async {
    deleteCount += 1;
    deletedCommentId = commentId;
    stored = const [];
  }

  @override
  Future<AssetUploadResult> upload({
    required String jobId,
    required DateTime timeOrigin,
    required CameraRecordingFile file,
  }) async {
    return AssetUploadResult(
      assetId: file.mimeType.startsWith('audio') ? '77' : '55',
      fileName: file.fileName,
      runId: '',
    );
  }

  @override
  Future<AssetUploadFormats> listUploadFormats() => throw UnimplementedError();

  @override
  Future<CameraRecordingFile?> pickFile() => throw UnimplementedError();

  @override
  Future<List<CameraRecordingFile>> pickFiles() => throw UnimplementedError();

  @override
  Future<AssetUploadResult> registerUploaded({
    required String uploadId,
    required String jobId,
    required String passId,
    required String equipmentId,
    required DateTime? timeOrigin,
    String subject = '',
    String situation = '',
    String fallbackFileName = '',
  }) => throw UnimplementedError();

  @override
  Future<String> retryPostprocess({required String assetId}) =>
      throw UnimplementedError();

  @override
  Future<AssetUploadResult> uploadFile({
    required String jobId,
    required String passId,
    required String equipmentId,
    required DateTime? timeOrigin,
    required CameraRecordingFile file,
    String subject = '',
    String situation = '',
    void Function(double progressPercent)? onProgress,
  }) => throw UnimplementedError();
}

class _IdleCamera implements CameraRecordingRepository {
  @override
  Object? get previewHandle => null;

  @override
  Future<void> prepare() async {}

  @override
  Future<void> release() async {}

  @override
  Future<void> start() async {}

  @override
  Future<CameraRecording> stop() => throw UnimplementedError();
}

class _IdleTools implements ToolRunRepository {
  @override
  Future<ToolRunSnapshot> cancelRun({required String runId}) =>
      throw UnimplementedError();

  @override
  Future<ToolRunSnapshot> getRun({required String runId}) =>
      throw UnimplementedError();

  @override
  Future<List<InferenceTool>> listEnabledTools({
    bool includeDisabled = false,
  }) => throw UnimplementedError();

  @override
  Future<List<ToolRunSnapshot>> listJobRuns({required String jobId}) =>
      throw UnimplementedError();

  @override
  Future<ToolRunSnapshot> startRun({
    required String toolId,
    required ToolRunTargetKind kind,
    required String targetId,
  }) => throw UnimplementedError();
}
