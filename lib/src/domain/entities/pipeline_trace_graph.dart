import 'tool_run.dart';
import 'upload_trace.dart';

enum PipelineNodeVisual {
  idle,
  done,
  active,
  queued,
  running,
  failed,
  skipped,
}

class PipelineStageDef {
  const PipelineStageDef({
    required this.id,
    required this.label,
    required this.nodeIds,
  });

  final String id;
  final String label;
  final List<String> nodeIds;
}

class PipelineNodeDef {
  const PipelineNodeDef({required this.id, required this.label});

  final String id;
  final String label;
}

/// Trace 이벤트 골격 + 받기 이전 하드코딩 선행 단계.
/// `collect`는 TraceService 이벤트가 없다. 받기 이후 last_event면 통과(done)로만 그린다.
const pipelineStages = <PipelineStageDef>[
  PipelineStageDef(
    id: 'collect',
    label: '현장/수집',
    nodeIds: ['collect.field', 'collect.capture'],
  ),
  PipelineStageDef(
    id: 'receive',
    label: '받기',
    nodeIds: ['receive.started', 'receive.screened', 'receive.done'],
  ),
  PipelineStageDef(
    id: 'register',
    label: '등록',
    nodeIds: [
      'register.stored',
      'register.asset',
      'register.attached',
      'register.duplicates',
    ],
  ),
  PipelineStageDef(
    id: 'postprocess',
    label: '후처리',
    nodeIds: [
      'postprocess.run',
      'postprocess.props',
      'postprocess.duration',
      'postprocess.report',
      'postprocess.normalize',
      'postprocess.waveform',
      'postprocess.placed',
    ],
  ),
  PipelineStageDef(id: 'tool', label: '도구', nodeIds: ['tool.run']),
  PipelineStageDef(id: 'embed', label: '임베딩', nodeIds: ['embed.done']),
  PipelineStageDef(
    id: 'done',
    label: '완료',
    nodeIds: ['done.searchable', 'done.stored'],
  ),
];

const pipelineNodeLabels = <String, String>{
  'collect.field': '현장',
  'collect.capture': '수집',
  'receive.started': '받기 시작',
  'receive.screened': '검사',
  'receive.done': '받기 완료',
  'register.stored': '저장',
  'register.asset': 'Asset',
  'register.attached': '첨부',
  'register.duplicates': '중복',
  'postprocess.run': '후처리 run',
  'postprocess.props': '속성',
  'postprocess.duration': '길이',
  'postprocess.report': '성적서',
  'postprocess.normalize': '표준화',
  'postprocess.waveform': '파형',
  'postprocess.placed': '배치',
  'tool.run': '도구 run',
  'embed.done': '임베딩',
  'done.searchable': '검색 가능',
  'done.stored': '저장만',
};

String pipelineEventLabel(String name) {
  return pipelineNodeLabels[name] ?? name;
}

/// 노드별 아이콘 키(UI에서 FluentIcons로 매핑).
String pipelineNodeIconKey(String nodeId) {
  switch (nodeId) {
    case 'collect.field':
      return 'field';
    case 'collect.capture':
      return 'capture';
    case 'receive.started':
      return 'download';
    case 'receive.screened':
      return 'shield';
    case 'receive.done':
      return 'check_receive';
    case 'register.stored':
      return 'save';
    case 'register.asset':
      return 'document';
    case 'register.attached':
      return 'link';
    case 'register.duplicates':
      return 'duplicate';
    case 'postprocess.run':
      return 'processing';
    case 'postprocess.props':
      return 'settings';
    case 'postprocess.duration':
      return 'clock';
    case 'postprocess.report':
      return 'report';
    case 'postprocess.normalize':
      return 'normalize';
    case 'postprocess.waveform':
      return 'waveform';
    case 'postprocess.placed':
      return 'place';
    case 'tool.run':
      return 'tool';
    case 'embed.done':
      return 'embed';
    case 'done.searchable':
      return 'search';
    case 'done.stored':
      return 'archive';
    default:
      return 'circle';
  }
}

String pipelineStageOf(String eventName) {
  final event = eventName.trim();
  if (event.isEmpty) {
    return '';
  }
  final dot = event.indexOf('.');
  return dot <= 0 ? event : event.substring(0, dot);
}

bool pipelineTraceTouchesStage(TraceSnapshot trace, String stageId) {
  if (pipelineStageOf(trace.lastEvent) == stageId) {
    return true;
  }
  for (final event in trace.events) {
    if (pipelineStageOf(event.name) == stageId) {
      return true;
    }
  }
  return false;
}

bool pipelineListHasToolStage(Iterable<TraceSnapshot> traces) {
  for (final trace in traces) {
    if (pipelineTraceTouchesStage(trace, 'tool')) {
      return true;
    }
  }
  return false;
}

bool pipelineListHasEmbedStage(Iterable<TraceSnapshot> traces) {
  for (final trace in traces) {
    if (pipelineTraceTouchesStage(trace, 'embed')) {
      return true;
    }
  }
  return false;
}

/// 순서만으로 완료를 추론하지 않는 선택 단계(이벤트 증거가 필요).
bool _isEvidenceOnlyStage(String stageId) =>
    stageId == 'embed' || stageId == 'tool';

Map<String, int> pipelineStageCounts(Iterable<TraceSnapshot> traces) {
  final counts = <String, int>{
    for (final stage in pipelineStages) stage.id: 0,
  };
  for (final trace in traces) {
    final stage = trace.stageId;
    if (stage.isEmpty) {
      continue;
    }
    // Trace에 올라온 건은 현장/수집을 지난 것으로 센다(하드코딩 선행 단계).
    counts['collect'] = (counts['collect'] ?? 0) + 1;
    counts[stage] = (counts[stage] ?? 0) + 1;
  }
  return counts;
}

Map<String, bool> pipelineStageHasFailed(Iterable<TraceSnapshot> traces) {
  final failed = <String, bool>{
    for (final stage in pipelineStages) stage.id: false,
  };
  for (final trace in traces) {
    if (trace.status != UploadTraceStatus.failed) {
      continue;
    }
    final stage = trace.stageId;
    if (stage.isNotEmpty) {
      failed[stage] = true;
    }
  }
  return failed;
}

/// 상태 배지(짧게). idle은 빈 문자열.
String pipelineNodeStatusLabel(PipelineNodeVisual visual) {
  switch (visual) {
    case PipelineNodeVisual.idle:
      return '';
    case PipelineNodeVisual.done:
      return '완료';
    case PipelineNodeVisual.active:
      return '현재';
    case PipelineNodeVisual.queued:
      return '대기';
    case PipelineNodeVisual.running:
      return '진행';
    case PipelineNodeVisual.failed:
      return '실패';
    case PipelineNodeVisual.skipped:
      return '건너뜀';
  }
}

bool pipelineNodeIsLive(PipelineNodeVisual visual) {
  return visual == PipelineNodeVisual.active ||
      visual == PipelineNodeVisual.running ||
      visual == PipelineNodeVisual.queued;
}

/// 여정이 거친 노드 ID(알려진 pipeline 노드만, 출현 순).
/// events가 없으면 lastEvent만 넣는다(이전 구간은 UI가 visual로 잇는다).
List<String> pipelinePathNodeIds(TraceSnapshot trace) {
  final known = <String>{
    for (final stage in pipelineStages) ...stage.nodeIds,
  };
  final path = <String>[];
  final seen = <String>{};
  for (final event in trace.events) {
    final name = event.name.trim();
    if (!known.contains(name) || seen.contains(name)) {
      continue;
    }
    path.add(name);
    seen.add(name);
  }
  final last = trace.lastEvent.trim();
  if (last.isNotEmpty && known.contains(last) && !seen.contains(last)) {
    path.add(last);
  }
  return path;
}

/// 골격 인접 이벤트 연결.
class PipelineTraceEdge {
  const PipelineTraceEdge({required this.fromId, required this.toId});

  final String fromId;
  final String toId;

  String get key => '$fromId>$toId';
}

/// visible 단계의 이벤트 노드를 왼쪽→오른쪽 순으로 펼친다.
List<String> pipelineSkeletonNodeIds(List<PipelineStageDef> stages) {
  return [for (final stage in stages) ...stage.nodeIds];
}

/// 펼친 노드의 인접 쌍(가이드 연결선).
List<PipelineTraceEdge> pipelineSkeletonEdges(List<PipelineStageDef> stages) {
  final nodes = pipelineSkeletonNodeIds(stages);
  if (nodes.length < 2) {
    return const [];
  }
  return [
    for (var i = 0; i < nodes.length - 1; i++)
      PipelineTraceEdge(fromId: nodes[i], toId: nodes[i + 1]),
  ];
}

/// 한 여정 path의 연속 쌍. 골격 비인접(점프)도 포함한다.
List<PipelineTraceEdge> pipelinePathEdges(
  TraceSnapshot trace, {
  required Set<String> visibleNodeIds,
}) {
  final path = [
    for (final id in pipelinePathNodeIds(trace))
      if (visibleNodeIds.contains(id)) id,
  ];
  if (path.length < 2) {
    return const [];
  }
  return [
    for (var i = 0; i < path.length - 1; i++)
      PipelineTraceEdge(fromId: path[i], toId: path[i + 1]),
  ];
}

/// 활성 연결: 실제 이벤트 path 연속 쌍만.
/// 선택 시 그 여정, 미선택 시 visibleTraces path 합집합.
Set<String> pipelineHighlightEdgeKeys({
  required TraceSnapshot? selected,
  required Iterable<TraceSnapshot> traces,
  required List<PipelineStageDef> stages,
}) {
  final visibleNodeIds = pipelineSkeletonNodeIds(stages).toSet();
  if (selected != null) {
    return {
      for (final edge in pipelinePathEdges(
        selected,
        visibleNodeIds: visibleNodeIds,
      ))
        edge.key,
    };
  }
  final keys = <String>{};
  for (final trace in traces) {
    for (final edge in pipelinePathEdges(
      trace,
      visibleNodeIds: visibleNodeIds,
    )) {
      keys.add(edge.key);
    }
  }
  return keys;
}

/// 활성 path 엣지 목록(점프 포함). 페인터가 골격과 따로 그린다.
List<PipelineTraceEdge> pipelineActivePathEdges({
  required TraceSnapshot? selected,
  required Iterable<TraceSnapshot> traces,
  required List<PipelineStageDef> stages,
}) {
  final visibleNodeIds = pipelineSkeletonNodeIds(stages).toSet();
  if (selected != null) {
    return pipelinePathEdges(selected, visibleNodeIds: visibleNodeIds);
  }
  final seen = <String>{};
  final edges = <PipelineTraceEdge>[];
  for (final trace in traces) {
    for (final edge in pipelinePathEdges(
      trace,
      visibleNodeIds: visibleNodeIds,
    )) {
      if (seen.add(edge.key)) {
        edges.add(edge);
      }
    }
  }
  return edges;
}

/// 활성 엣지 중 한쪽이라도 live면 흐름 입자 대상.
bool pipelineEdgeIsLive({
  required String fromId,
  required String toId,
  required TraceSnapshot? selected,
  required Iterable<TraceSnapshot> traces,
}) {
  return pipelineNodeIsLive(
        pipelineNodeVisual(
          nodeId: fromId,
          selected: selected,
          traces: traces,
        ),
      ) ||
      pipelineNodeIsLive(
        pipelineNodeVisual(
          nodeId: toId,
          selected: selected,
          traces: traces,
        ),
      );
}

/// 단계 사이 본선에 쓸 단계 ID(왼쪽→오른쪽).
/// 선택 시 그 여정이 도달한 단계까지. 미선택 시 집계상 non-idle 단계.
List<String> pipelineHighlightStageIds({
  required TraceSnapshot? selected,
  required Iterable<TraceSnapshot> traces,
  required List<PipelineStageDef> stages,
}) {
  if (selected != null) {
    final lastOrder = _stageOrder(selected.stageId);
    if (lastOrder < 0) {
      return const [];
    }
    return [
      for (final stage in stages)
        if (_stageOrder(stage.id) <= lastOrder) stage.id,
    ];
  }
  return [
    for (final stage in stages)
      if (pipelineStageVisual(
            stageId: stage.id,
            selected: null,
            traces: traces,
          ) !=
          PipelineNodeVisual.idle)
        stage.id,
  ];
}

/// 단계(큰 원) 시각. 미선택은 visibleTraces 합산(대기>진행>실패>완료>idle).
PipelineNodeVisual pipelineStageVisual({
  required String stageId,
  required TraceSnapshot? selected,
  required Iterable<TraceSnapshot> traces,
}) {
  final stageOrder = _stageOrder(stageId);
  if (stageOrder < 0) {
    return PipelineNodeVisual.idle;
  }
  if (selected != null) {
    final lastOrder = _stageOrder(selected.stageId);
    if (lastOrder < 0) {
      return PipelineNodeVisual.idle;
    }
    if (stageOrder < lastOrder) {
      if (_isEvidenceOnlyStage(stageId) &&
          !pipelineTraceTouchesStage(selected, stageId)) {
        return PipelineNodeVisual.skipped;
      }
      return PipelineNodeVisual.done;
    }
    if (stageOrder > lastOrder) {
      return PipelineNodeVisual.idle;
    }
    return _currentStageVisual(selected);
  }

  var hasFailed = false;
  var hasQueued = false;
  var hasRunning = false;
  var hasDone = false;
  for (final trace in traces) {
    final lastOrder = _stageOrder(trace.stageId);
    if (lastOrder < 0) {
      continue;
    }
    if (lastOrder > stageOrder) {
      if (_isEvidenceOnlyStage(stageId) &&
          !pipelineTraceTouchesStage(trace, stageId)) {
        continue;
      }
      hasDone = true;
      continue;
    }
    if (lastOrder < stageOrder) {
      continue;
    }
    if (trace.status == UploadTraceStatus.failed) {
      hasFailed = true;
    } else if (trace.status == UploadTraceStatus.running) {
      final run = trace.run;
      if (run != null && run.status == ToolRunStatus.queued) {
        hasQueued = true;
      } else {
        hasRunning = true;
      }
    } else {
      hasDone = true;
    }
  }
  // 진행 중인 업로드가 옛 실패에 가려지지 않게 대기/진행을 실패보다 앞선다.
  if (hasQueued) {
    return PipelineNodeVisual.queued;
  }
  if (hasRunning) {
    return PipelineNodeVisual.running;
  }
  if (hasFailed) {
    return PipelineNodeVisual.failed;
  }
  if (hasDone) {
    return PipelineNodeVisual.done;
  }
  return PipelineNodeVisual.idle;
}

PipelineNodeVisual _currentStageVisual(TraceSnapshot trace) {
  if (trace.status == UploadTraceStatus.failed) {
    return PipelineNodeVisual.failed;
  }
  if (trace.status == UploadTraceStatus.running) {
    final run = trace.run;
    if (run != null && run.status == ToolRunStatus.queued) {
      return PipelineNodeVisual.queued;
    }
    if (run != null && run.status == ToolRunStatus.running) {
      return PipelineNodeVisual.running;
    }
    return PipelineNodeVisual.active;
  }
  return PipelineNodeVisual.done;
}

PipelineNodeVisual pipelineNodeVisual({
  required String nodeId,
  required TraceSnapshot? selected,
  required Iterable<TraceSnapshot> traces,
}) {
  if (selected != null) {
    return _visualForSelected(nodeId: nodeId, trace: selected);
  }
  // 미선택: 대기/진행 → 실패 → 완료 순(진행 중 업로드가 옛 실패에 가려지지 않게).
  for (final trace in traces) {
    if (trace.status == UploadTraceStatus.running &&
        trace.lastEvent == nodeId) {
      final run = trace.run;
      if (run != null && run.status == ToolRunStatus.queued) {
        return PipelineNodeVisual.queued;
      }
      if (run != null && run.status == ToolRunStatus.running) {
        return PipelineNodeVisual.running;
      }
      return PipelineNodeVisual.active;
    }
  }
  for (final trace in traces) {
    if (trace.status == UploadTraceStatus.failed &&
        (trace.lastEvent == nodeId ||
            pipelineStageOf(trace.lastEvent) == pipelineStageOf(nodeId))) {
      return PipelineNodeVisual.failed;
    }
  }
  for (final trace in traces) {
    if (trace.lastEvent == nodeId ||
        trace.events.any((event) => event.name == nodeId)) {
      return PipelineNodeVisual.done;
    }
  }
  for (final trace in traces) {
    final nodeStage = pipelineStageOf(nodeId);
    final lastOrder = _stageOrder(trace.stageId);
    final nodeOrder = _stageOrder(nodeStage);
    if (lastOrder > nodeOrder && nodeOrder >= 0) {
      if (_isEvidenceOnlyStage(nodeStage) &&
          !pipelineTraceTouchesStage(trace, nodeStage)) {
        continue;
      }
      return PipelineNodeVisual.done;
    }
  }
  return PipelineNodeVisual.idle;
}

PipelineNodeVisual _visualForSelected({
  required String nodeId,
  required TraceSnapshot trace,
}) {
  TraceEventSnapshot? matched;
  for (final event in trace.events) {
    if (event.name == nodeId) {
      matched = event;
      break;
    }
  }
  if (matched != null) {
    final status = matched.status.toLowerCase();
    if (status == 'failed') {
      return PipelineNodeVisual.failed;
    }
    if (status == 'skipped') {
      return PipelineNodeVisual.skipped;
    }
    if (status.contains('queue')) {
      return PipelineNodeVisual.queued;
    }
    if (status.contains('run') && status != 'ok' && status != 'succeeded') {
      return PipelineNodeVisual.running;
    }
    if (trace.lastEvent == nodeId &&
        trace.status == UploadTraceStatus.running) {
      final run = trace.run;
      if (run != null && run.status == ToolRunStatus.queued) {
        return PipelineNodeVisual.queued;
      }
      if (run != null && run.status == ToolRunStatus.running) {
        return PipelineNodeVisual.running;
      }
      return PipelineNodeVisual.active;
    }
    return PipelineNodeVisual.done;
  }
  if (trace.lastEvent == nodeId) {
    if (trace.status == UploadTraceStatus.failed) {
      return PipelineNodeVisual.failed;
    }
    if (trace.status == UploadTraceStatus.running) {
      final run = trace.run;
      if (run != null && run.status == ToolRunStatus.queued) {
        return PipelineNodeVisual.queued;
      }
      if (run != null && run.status == ToolRunStatus.running) {
        return PipelineNodeVisual.running;
      }
      return PipelineNodeVisual.active;
    }
    return PipelineNodeVisual.done;
  }
  // last_event가 이 노드보다 뒤 stage면 이전 노드는 done으로 본다.
  // embed/tool은 이벤트 증거가 없으면 skipped(거짓 완료 금지).
  final nodeStage = pipelineStageOf(nodeId);
  final lastStage = trace.stageId;
  final nodeOrder = _stageOrder(nodeStage);
  final lastOrder = _stageOrder(lastStage);
  if (lastOrder > nodeOrder && nodeOrder >= 0) {
    if (_isEvidenceOnlyStage(nodeStage) &&
        !pipelineTraceTouchesStage(trace, nodeStage)) {
      return PipelineNodeVisual.skipped;
    }
    return PipelineNodeVisual.done;
  }
  if (lastOrder == nodeOrder &&
      _nodeIndex(nodeId) >= 0 &&
      _nodeIndex(trace.lastEvent) > _nodeIndex(nodeId)) {
    return PipelineNodeVisual.done;
  }
  return PipelineNodeVisual.idle;
}

int _stageOrder(String stageId) {
  for (var i = 0; i < pipelineStages.length; i++) {
    if (pipelineStages[i].id == stageId) {
      return i;
    }
  }
  return -1;
}

int _nodeIndex(String nodeId) {
  final stage = pipelineStageOf(nodeId);
  for (final def in pipelineStages) {
    if (def.id != stage) {
      continue;
    }
    return def.nodeIds.indexOf(nodeId);
  }
  return -1;
}

/// ListTraces/GetTrace의 `Trace.run`만으로 본 큐별 병목(실행·대기 수).
class TraceQueueBottleneck {
  const TraceQueueBottleneck({
    required this.queue,
    required this.running,
    required this.waiting,
  });

  final String queue;
  final int running;
  final int waiting;
}

/// in-progress `run.queue`를 큐 이름순으로 집계한다. GetQueue를 쓰지 않는다.
List<TraceQueueBottleneck> traceQueueBottlenecks(
  Iterable<TraceSnapshot> traces,
) {
  final runningByQueue = <String, int>{};
  final waitingByQueue = <String, int>{};
  for (final trace in traces) {
    final run = trace.run;
    if (run == null || !run.isInProgress) {
      continue;
    }
    final queue = run.queue.trim();
    if (queue.isEmpty) {
      continue;
    }
    if (run.status == ToolRunStatus.running) {
      runningByQueue[queue] = (runningByQueue[queue] ?? 0) + 1;
    } else {
      waitingByQueue[queue] = (waitingByQueue[queue] ?? 0) + 1;
    }
  }
  final names = {...runningByQueue.keys, ...waitingByQueue.keys}.toList()
    ..sort();
  return [
    for (final name in names)
      TraceQueueBottleneck(
        queue: name,
        running: runningByQueue[name] ?? 0,
        waiting: waitingByQueue[name] ?? 0,
      ),
  ];
}

/// 같은 `run.queue`의 in-progress Trace를 `created_at` 오래된 순(없으면 뒤에).
List<TraceSnapshot> tracesInSameQueueOldestFirst(
  Iterable<TraceSnapshot> traces,
  String queueName,
) {
  final name = queueName.trim();
  if (name.isEmpty) {
    return const [];
  }
  final matched = [
    for (final trace in traces)
      if (trace.run != null &&
          trace.run!.isInProgress &&
          trace.run!.queue.trim() == name)
        trace,
  ];
  matched.sort((a, b) {
    final aAt = a.run?.createdAt;
    final bAt = b.run?.createdAt;
    if (aAt == null && bAt == null) {
      return a.traceId.compareTo(b.traceId);
    }
    if (aAt == null) {
      return 1;
    }
    if (bAt == null) {
      return -1;
    }
    final byTime = aAt.compareTo(bAt);
    if (byTime != 0) {
      return byTime;
    }
    return a.traceId.compareTo(b.traceId);
  });
  return matched;
}
