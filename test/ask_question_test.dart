import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/data/datasources/generated/tacittag/rag/v2/rag.pb.dart'
    as rag_pb;
import 'package:weld_dashboard/src/data/repositories/ask_requests.dart';
import 'package:weld_dashboard/src/domain/entities/ask_answer.dart';
import 'package:weld_dashboard/src/domain/entities/job_timeline.dart';
import 'package:weld_dashboard/src/domain/entities/label_vocab.dart';
import 'package:weld_dashboard/src/domain/entities/tool_run.dart';
import 'package:weld_dashboard/src/domain/entities/work_detail_catalog.dart';
import 'package:weld_dashboard/src/domain/entities/work_attachment.dart';
import 'package:weld_dashboard/src/domain/repositories/ask_repository.dart';
import 'package:weld_dashboard/src/domain/repositories/job_timeline_repository.dart';
import 'package:weld_dashboard/src/domain/repositories/label_repository.dart';
import 'package:weld_dashboard/src/domain/repositories/tool_run_repository.dart';
import 'package:weld_dashboard/src/domain/repositories/work_detail_repository.dart';
import 'package:weld_dashboard/src/domain/use_cases/ask_question_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/change_timeline_status_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/create_clip_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/create_track_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/delete_clip_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/delete_timeline_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/delete_track_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/get_job_timeline_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/label_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/list_history_work_attachments_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/load_job_project_id_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/tool_run_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/update_clip_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/update_timeline_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/update_track_use_case.dart';
import 'package:weld_dashboard/src/presentation/features/video_multimodal/video_multimodal_view_model.dart';

void main() {
  test('ask request sends project, question, and a later session', () {
    final first = buildAskQuestionRequest(projectId: '42', question: '용접 장면');
    expect(first.projectId, '42');
    expect(first.question, '용접 장면');
    expect(first.sessionId, isEmpty);
    expect(first.topK, 0);
    expect(first.mediaId, isEmpty);

    final next = buildAskQuestionRequest(
      projectId: '42',
      question: '다음은',
      sessionId: 's1',
    );
    expect(next.sessionId, 's1');
  });

  test('ask answer keeps the reply text and citation times', () {
    final answer = askAnswerFrom(
      rag_pb.AskQuestionResponse(
        answer: '15초에 있습니다.',
        sessionId: 's1',
        citations: [
          rag_pb.Citation(startSec: 15.52, endSec: 23.44),
          rag_pb.Citation(startSec: 30, endSec: 31),
        ],
      ),
    );
    expect(answer.answer, '15초에 있습니다.');
    expect(answer.sessionId, 's1');
    expect(answer.citations, hasLength(2));
    expect(answer.citations.first.startSeconds, 15.52);
    expect(answer.citations.first.endSeconds, 23.44);
  });

  test('empty question and missing project skip the server', () async {
    final asks = _ScriptedAsk();
    final useCase = AskQuestionUseCase(asks);
    expect(
      () => useCase.execute(projectId: '42', question: '  '),
      throwsA(
        isA<AskException>().having(
          (error) => error.message,
          'message',
          '질문을 입력하세요.',
        ),
      ),
    );
    expect(
      () => useCase.execute(projectId: '', question: '용접 장면'),
      throwsA(
        isA<AskException>().having(
          (error) => error.message,
          'message',
          '공사 번호를 찾지 못했습니다.',
        ),
      ),
    );
    expect(asks.calls, isEmpty);
  });

  test('a question shows the answer and reuses the session', () async {
    final asks = _ScriptedAsk();
    final viewModel = _viewModel(asks, projectId: '42');

    await viewModel.didSendAsk('   ');
    expect(viewModel.askTurns, isEmpty);

    await viewModel.didSendAsk('  용접 장면  ');
    expect(asks.calls.single.projectId, '42');
    expect(asks.calls.single.question, '용접 장면');
    expect(asks.calls.single.sessionId, isEmpty);
    expect(viewModel.askTurns.first.text, '용접 장면');
    expect(viewModel.askTurns.last.text, '15초에 있습니다.');
    expect(viewModel.askTurns.last.citations.single.startSeconds, 15.52);
    expect(viewModel.askTurns.last.citations.single.endSeconds, 23.44);
    expect(viewModel.isAsking, isFalse);

    asks.next = const AskAnswer(answer: '그 다음입니다.', sessionId: 's2');
    await viewModel.didSendAsk('다음은');
    expect(asks.calls.last.sessionId, 's1');
    expect(viewModel.askTurns.last.text, '그 다음입니다.');
  });

  test('a failed question keeps the session and shows the message', () async {
    final asks = _ScriptedAsk();
    final viewModel = _viewModel(asks, projectId: '42');
    await viewModel.didSendAsk('용접 장면');

    asks.error = const AskException('검색에 실패했습니다.');
    await viewModel.didSendAsk('다시');
    expect(viewModel.askTurns.last.text, '검색에 실패했습니다.');
    expect(viewModel.askTurns.last.citations, isEmpty);

    asks.error = null;
    asks.next = const AskAnswer(answer: '이어서 답합니다.', sessionId: 's1');
    await viewModel.didSendAsk('이어서');
    expect(asks.calls.last.sessionId, 's1');
  });

  test('a missing project id does not call AskQuestion', () async {
    final asks = _ScriptedAsk();
    final viewModel = _viewModel(asks, projectId: '');
    await viewModel.didSendAsk('용접 장면');
    expect(asks.calls, isEmpty);
    expect(viewModel.askTurns.last.text, '공사 번호를 찾지 못했습니다.');
  });
}

VideoMultimodalViewModel _viewModel(
  _ScriptedAsk asks, {
  required String projectId,
}) {
  final timeline = _IdleTimeline();
  final workDetail = _ProjectWorkDetail(projectId);
  return VideoMultimodalViewModel(
    listHistoryWorkAttachmentsUseCase: ListHistoryWorkAttachmentsUseCase(
      workDetail,
    ),
    getJobTimelineUseCase: GetJobTimelineUseCase(timeline),
    createTrackUseCase: CreateTrackUseCase(timeline),
    updateTrackUseCase: UpdateTrackUseCase(timeline),
    deleteTrackUseCase: DeleteTrackUseCase(timeline),
    createClipUseCase: CreateClipUseCase(timeline),
    updateClipUseCase: UpdateClipUseCase(timeline),
    deleteClipUseCase: DeleteClipUseCase(timeline),
    changeTimelineStatusUseCase: ChangeTimelineStatusUseCase(timeline),
    updateTimelineUseCase: UpdateTimelineUseCase(timeline),
    deleteTimelineUseCase: DeleteTimelineUseCase(timeline),
    toolRunUseCase: ToolRunUseCase(_IdleToolRunRepository()),
    labelUseCase: LabelUseCase(_IdleLabelRepository()),
    askQuestionUseCase: AskQuestionUseCase(asks),
    loadJobProjectIdUseCase: LoadJobProjectIdUseCase(workDetail),
    jobId: '128',
  );
}

class _ScriptedAsk implements AskRepository {
  final List<({String projectId, String question, String sessionId})> calls =
      [];
  AskAnswer next = const AskAnswer(
    answer: '15초에 있습니다.',
    sessionId: 's1',
    citations: [AskCitation(startSeconds: 15.52, endSeconds: 23.44)],
  );
  AskException? error;

  @override
  Future<AskAnswer> askQuestion({
    required String projectId,
    required String question,
    String sessionId = '',
  }) async {
    calls.add((projectId: projectId, question: question, sessionId: sessionId));
    final failure = error;
    if (failure != null) {
      throw failure;
    }
    return next;
  }
}

class _ProjectWorkDetail implements WorkDetailRepository {
  _ProjectWorkDetail(this.projectId);

  final String projectId;

  @override
  Future<String> loadProjectId({required String jobId}) async {
    return projectId;
  }

  @override
  Future<WorkDetailCatalog> loadCatalog({String jobId = ''}) async {
    return const WorkDetailCatalog(items: [], attachments: []);
  }

  @override
  Future<List<WorkAttachment>> listAttachments({String jobId = ''}) async {
    return const [];
  }
}

class _IdleTimeline implements JobTimelineRepository {
  @override
  Future<JobTimeline> getTimeline({required String jobId}) async {
    return JobTimeline.empty;
  }

  @override
  Future<void> createTrack({
    required String jobId,
    required String name,
    int? order,
    bool? isVisible,
  }) async {}

  @override
  Future<void> updateTrack({
    required String trackId,
    String? name,
    int? order,
    bool? isVisible,
  }) async {}

  @override
  Future<void> deleteTrack({required String trackId}) async {}

  @override
  Future<void> createClip({
    required String trackId,
    required TimelineClipKind kind,
    required String startNs,
    required String endNs,
    String assetId = '',
    String labelValueId = '',
    String description = '',
    bool omitsKind = false,
    List<String> inputClipIds = const [],
  }) async {}

  @override
  Future<void> updateClip({
    required String clipId,
    String? trackId,
    String? startNs,
    String? endNs,
    String? assetId,
    String? labelValueId,
    String? description,
    bool? isReviewed,
  }) async {}

  @override
  Future<void> deleteClip({required String clipId}) async {}

  @override
  Future<void> changeTimelineStatus({
    required String jobId,
    required JobTimelineStatus fromStatus,
    required JobTimelineStatus toStatus,
  }) async {}

  @override
  Future<void> updateTimeline({
    required String jobId,
    String? name,
    String? description,
  }) async {}

  @override
  Future<void> deleteTimeline({required String jobId}) async {}

  @override
  Future<String> readContent({required String url}) async {
    return '';
  }
}

class _IdleLabelRepository implements LabelRepository {
  @override
  Future<List<LabelNode>> listLabels() async => const [];

  @override
  Future<LabelNode> createValue({
    required String name,
    String parentValueId = '',
  }) {
    throw StateError('unused');
  }

  @override
  Future<LabelNode> renameValue({
    required String valueId,
    required String name,
  }) {
    throw StateError('unused');
  }

  @override
  Future<void> deprecateValue({required String valueId}) {
    throw StateError('unused');
  }
}

class _IdleToolRunRepository implements ToolRunRepository {
  @override
  Future<List<InferenceTool>> listEnabledTools() async => const [];

  @override
  Future<List<ToolRunSnapshot>> listJobRuns({required String jobId}) async {
    return const [];
  }

  @override
  Future<ToolRunSnapshot> startRun({
    required String toolId,
    required ToolRunTargetKind kind,
    required String targetId,
  }) {
    throw StateError('unused');
  }

  @override
  Future<ToolRunSnapshot> getRun({required String runId}) {
    throw StateError('unused');
  }

  @override
  Future<ToolRunSnapshot> cancelRun({required String runId}) {
    throw StateError('unused');
  }
}
