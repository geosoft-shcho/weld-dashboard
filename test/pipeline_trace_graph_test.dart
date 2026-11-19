import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/domain/entities/pipeline_trace_graph.dart';
import 'package:weld_dashboard/src/domain/entities/upload_trace.dart';

void main() {
  test('stage counts and tool column visibility', () {
    final traces = [
      const TraceSnapshot(
        traceId: '1',
        lastEvent: 'receive.done',
        status: UploadTraceStatus.running,
        errorMessage: '',
      ),
      const TraceSnapshot(
        traceId: '2',
        lastEvent: 'postprocess.run',
        status: UploadTraceStatus.failed,
        errorMessage: 'x',
      ),
      const TraceSnapshot(
        traceId: '3',
        lastEvent: 'done.searchable',
        status: UploadTraceStatus.done,
        errorMessage: '',
      ),
    ];
    final counts = pipelineStageCounts(traces);
    expect(counts['collect'], 3);
    expect(counts['receive'], 1);
    expect(counts['postprocess'], 1);
    expect(counts['done'], 1);
    expect(pipelineListHasToolStage(traces), isFalse);
    expect(pipelineStageHasFailed(traces)['postprocess'], isTrue);
  });

  test('hardcoded collect stage is first and done after receive', () {
    expect(pipelineStages.first.id, 'collect');
    expect(pipelineStages.first.label, '현장/수집');
    const running = TraceSnapshot(
      traceId: '1',
      lastEvent: 'receive.done',
      status: UploadTraceStatus.running,
      errorMessage: '',
    );
    expect(
      pipelineStageVisual(
        stageId: 'collect',
        selected: running,
        traces: const [running],
      ),
      PipelineNodeVisual.done,
    );
    expect(
      pipelineNodeVisual(
        nodeId: 'collect.field',
        selected: running,
        traces: const [running],
      ),
      PipelineNodeVisual.done,
    );
  });

  test('selected node visual marks current and past', () {
    const selected = TraceSnapshot(
      traceId: '9',
      lastEvent: 'register.asset',
      status: UploadTraceStatus.running,
      errorMessage: '',
      events: [
        TraceEventSnapshot(name: 'receive.started', status: 'ok'),
        TraceEventSnapshot(name: 'receive.done', status: 'ok'),
        TraceEventSnapshot(name: 'register.stored', status: 'ok'),
        TraceEventSnapshot(name: 'register.asset', status: 'running'),
      ],
    );
    expect(
      pipelineNodeVisual(
        nodeId: 'receive.done',
        selected: selected,
        traces: const [selected],
      ),
      PipelineNodeVisual.done,
    );
    expect(
      pipelineNodeVisual(
        nodeId: 'register.asset',
        selected: selected,
        traces: const [selected],
      ),
      PipelineNodeVisual.running,
    );
    expect(
      pipelineNodeVisual(
        nodeId: 'embed.done',
        selected: selected,
        traces: const [selected],
      ),
      PipelineNodeVisual.idle,
    );
  });

  test('aggregate stage visual shows failed running and done', () {
    final traces = [
      const TraceSnapshot(
        traceId: '1',
        lastEvent: 'receive.done',
        status: UploadTraceStatus.running,
        errorMessage: '',
      ),
      const TraceSnapshot(
        traceId: '2',
        lastEvent: 'postprocess.run',
        status: UploadTraceStatus.failed,
        errorMessage: 'x',
      ),
      const TraceSnapshot(
        traceId: '3',
        lastEvent: 'done.stored',
        status: UploadTraceStatus.done,
        errorMessage: '',
      ),
    ];
    expect(
      pipelineStageVisual(
        stageId: 'receive',
        selected: null,
        traces: traces,
      ),
      PipelineNodeVisual.running,
    );
    expect(
      pipelineStageVisual(
        stageId: 'postprocess',
        selected: null,
        traces: traces,
      ),
      PipelineNodeVisual.failed,
    );
    expect(
      pipelineStageVisual(
        stageId: 'done',
        selected: null,
        traces: traces,
      ),
      PipelineNodeVisual.done,
    );
    // done.stored만 있고 embed 이벤트 없으면 임베딩 칸은 거짓 완료가 아니다.
    expect(
      pipelineStageVisual(
        stageId: 'embed',
        selected: null,
        traces: traces,
      ),
      PipelineNodeVisual.idle,
    );
    expect(pipelineListHasEmbedStage(traces), isFalse);

    final stages = [
      for (final stage in pipelineStages)
        if (stage.id != 'tool' && stage.id != 'embed') stage,
    ];
    expect(
      pipelineHighlightStageIds(
        selected: null,
        traces: traces,
        stages: stages,
      ),
      containsAll(['collect', 'receive', 'postprocess', 'done']),
    );
    expect(
      pipelineStageVisual(
        stageId: 'collect',
        selected: null,
        traces: traces,
      ),
      PipelineNodeVisual.done,
    );
  });

  test('embed lights only with embed evidence', () {
    const storedOnly = TraceSnapshot(
      traceId: '3',
      lastEvent: 'done.stored',
      status: UploadTraceStatus.done,
      errorMessage: '',
    );
    expect(
      pipelineStageVisual(
        stageId: 'embed',
        selected: storedOnly,
        traces: const [storedOnly],
      ),
      PipelineNodeVisual.skipped,
    );
    expect(
      pipelineNodeVisual(
        nodeId: 'embed.done',
        selected: storedOnly,
        traces: const [storedOnly],
      ),
      PipelineNodeVisual.skipped,
    );

    const withEmbed = TraceSnapshot(
      traceId: '4',
      lastEvent: 'done.searchable',
      status: UploadTraceStatus.done,
      errorMessage: '',
      events: [
        TraceEventSnapshot(name: 'embed.done', status: 'ok'),
        TraceEventSnapshot(name: 'done.searchable', status: 'ok'),
      ],
    );
    expect(
      pipelineStageVisual(
        stageId: 'embed',
        selected: null,
        traces: const [withEmbed],
      ),
      PipelineNodeVisual.done,
    );
    expect(pipelineListHasEmbedStage(const [withEmbed]), isTrue);
  });

  test('aggregate prefers live over failed on same stage', () {
    final traces = [
      const TraceSnapshot(
        traceId: 'old',
        lastEvent: 'register.asset',
        status: UploadTraceStatus.failed,
        errorMessage: 'x',
      ),
      const TraceSnapshot(
        traceId: '76',
        lastEvent: 'register.stored',
        status: UploadTraceStatus.running,
        errorMessage: '',
      ),
    ];
    expect(
      pipelineStageVisual(
        stageId: 'register',
        selected: null,
        traces: traces,
      ),
      PipelineNodeVisual.running,
    );
    expect(
      pipelineNodeVisual(
        nodeId: 'register.stored',
        selected: null,
        traces: traces,
      ),
      PipelineNodeVisual.active,
    );
    expect(pipelineStages[2].nodeIds, contains('register.duplicates'));
  });

  test('path nodes follow events; selected stage path to last', () {
    const running = TraceSnapshot(
      traceId: '9',
      lastEvent: 'register.asset',
      status: UploadTraceStatus.running,
      errorMessage: '',
      events: [
        TraceEventSnapshot(name: 'receive.started', status: 'ok'),
        TraceEventSnapshot(name: 'receive.done', status: 'ok'),
        TraceEventSnapshot(name: 'register.stored', status: 'ok'),
        TraceEventSnapshot(name: 'register.asset', status: 'running'),
      ],
    );
    expect(
      pipelinePathNodeIds(running),
      [
        'receive.started',
        'receive.done',
        'register.stored',
        'register.asset',
      ],
    );
    expect(
      pipelineHighlightStageIds(
        selected: running,
        traces: const [running],
        stages: pipelineStages,
      ),
      ['collect', 'receive', 'register'],
    );
    expect(pipelineNodeStatusLabel(PipelineNodeVisual.running), '진행');
    expect(pipelineNodeIsLive(PipelineNodeVisual.active), isTrue);
  });

  test('active edges follow event path only; jumps light without skipped links', () {
    final stages = [
      for (final stage in pipelineStages)
        if (stage.id != 'tool' && stage.id != 'embed') stage,
    ];
    final edges = pipelineSkeletonEdges(stages);
    expect(
      edges.map((e) => e.key),
      contains('receive.done>register.stored'),
    );
    expect(
      edges.map((e) => e.key),
      contains('register.stored>register.asset'),
    );

    // 받기 → 등록.저장 → 후처리.속성 → 완료 (중간 이벤트 생략)
    const jumped = TraceSnapshot(
      traceId: '42',
      lastEvent: 'done.searchable',
      status: UploadTraceStatus.done,
      errorMessage: '',
      events: [
        TraceEventSnapshot(name: 'receive.done', status: 'ok'),
        TraceEventSnapshot(name: 'register.stored', status: 'ok'),
        TraceEventSnapshot(name: 'postprocess.props', status: 'ok'),
        TraceEventSnapshot(name: 'done.searchable', status: 'ok'),
      ],
    );
    final keys = pipelineHighlightEdgeKeys(
      selected: jumped,
      traces: const [jumped],
      stages: stages,
    );
    expect(keys, contains('receive.done>register.stored'));
    expect(keys, contains('register.stored>postprocess.props'));
    expect(keys, contains('postprocess.props>done.searchable'));
    // 골격 중간선은 path에 없으므로 비활성
    expect(keys, isNot(contains('register.stored>register.asset')));
    expect(keys, isNot(contains('postprocess.run>postprocess.props')));
    expect(keys, isNot(contains('done.searchable>done.stored')));

    final active = pipelineActivePathEdges(
      selected: jumped,
      traces: const [jumped],
      stages: stages,
    );
    expect(
      active.map((e) => e.key).toList(),
      [
        'receive.done>register.stored',
        'register.stored>postprocess.props',
        'postprocess.props>done.searchable',
      ],
    );

    const running = TraceSnapshot(
      traceId: '9',
      lastEvent: 'register.asset',
      status: UploadTraceStatus.running,
      errorMessage: '',
      events: [
        TraceEventSnapshot(name: 'receive.started', status: 'ok'),
        TraceEventSnapshot(name: 'receive.done', status: 'ok'),
        TraceEventSnapshot(name: 'register.stored', status: 'ok'),
        TraceEventSnapshot(name: 'register.asset', status: 'running'),
      ],
    );
    expect(
      pipelineEdgeIsLive(
        fromId: 'register.stored',
        toId: 'register.asset',
        selected: running,
        traces: const [running],
      ),
      isTrue,
    );
  });
}
