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
    expect(
      pipelineStageVisual(
        stageId: 'embed',
        selected: null,
        traces: traces,
      ),
      PipelineNodeVisual.done,
    );

    final stages = [
      for (final stage in pipelineStages)
        if (stage.id != 'tool') stage,
    ];
    expect(
      pipelineHighlightStageIds(
        selected: null,
        traces: traces,
        stages: stages,
      ),
      containsAll(['collect', 'receive', 'postprocess', 'embed', 'done']),
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
}
