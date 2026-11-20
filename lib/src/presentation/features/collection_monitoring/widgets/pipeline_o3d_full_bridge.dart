import '../../../../domain/entities/pipeline_trace_graph.dart';
import '../../../../domain/entities/upload_trace.dart';
import 'pipeline_status_mapper.dart';

/// GLB 계약: collect.field → collect_field → node__/mat__
String pipelineO3dMeshKey(String nodeId) => nodeId.replaceAll('.', '_');

String pipelineO3dMaterialName(String nodeId) =>
    'mat__${pipelineO3dMeshKey(nodeId)}';

/// 백본 세그먼트 인덱스 → 흐름상 가까운 stage (메인 고속도로)
const pipelineO3dMainPipeStages = <String, String>{
  'mat__pipe__main_0': 'receive',
  'mat__pipe__main_1': 'register',
  'mat__pipe__main_2': 'postprocess',
  'mat__pipe__main_3': 'tool',
  'mat__pipe__main_4': 'embed',
  'mat__pipe__main_5': 'done',
};

/// Stage → 백본 분기 (Node와 별도 pipe)
const pipelineO3dBranchPipeStages = <String, String>{
  'mat__pipe__branch_collect': 'collect',
  'mat__pipe__branch_receive': 'receive',
  'mat__pipe__branch_embed': 'embed',
  'mat__pipe__branch_tool': 'tool',
  'mat__pipe__branch_postprocess': 'postprocess',
  'mat__pipe__branch_register': 'register',
  'mat__pipe__branch_done': 'done',
};

/// 좌→우 흐름 순서. 방향성 애니메이션·클릭 스윕의 위상 기준.
const pipelineO3dStageOrder = <String, int>{
  'collect': 0,
  'receive': 1,
  'register': 2,
  'postprocess': 3,
  'tool': 4,
  'embed': 5,
  'done': 6,
};

class PipelineO3dNodeStyle {
  const PipelineO3dNodeStyle({
    required this.status,
    required this.base,
    required this.emissive,
    required this.pulse,
  });

  final String status;
  final List<double> base;
  final List<double> emissive;
  final bool pulse;
}

/// 상태별 고대비 색 (idle 어둡게 / running·error 강하게).
PipelineO3dNodeStyle pipelineO3dStyleFor(PipelineNodeVisual visual) {
  final status = pipelineFlowStatus(visual);
  switch (status) {
    case 'running':
      return const PipelineO3dNodeStyle(
        status: 'running',
        base: [0.35, 0.75, 1.0, 1],
        emissive: [0.2, 0.85, 1.0],
        pulse: true,
      );
    case 'done':
      return const PipelineO3dNodeStyle(
        status: 'done',
        base: [0.1, 0.95, 0.75, 1],
        emissive: [0.05, 0.55, 0.4],
        pulse: false,
      );
    case 'error':
      return const PipelineO3dNodeStyle(
        status: 'error',
        base: [1.0, 0.15, 0.15, 1],
        emissive: [1.0, 0.05, 0.05],
        pulse: true,
      );
    case 'warning':
      return const PipelineO3dNodeStyle(
        status: 'warning',
        base: [1.0, 0.72, 0.12, 1],
        emissive: [0.95, 0.45, 0.0],
        pulse: true,
      );
    case 'skipped':
      return const PipelineO3dNodeStyle(
        status: 'skipped',
        base: [0.35, 0.37, 0.4, 0.35],
        emissive: [0, 0, 0],
        pulse: false,
      );
    default:
      return const PipelineO3dNodeStyle(
        status: 'idle',
        base: [0.22, 0.24, 0.28, 0.75],
        emissive: [0.0, 0.0, 0.0],
        pulse: false,
      );
  }
}

String _styleJson(String mat, PipelineO3dNodeStyle style, String kind, int order) {
  return '"$mat":{"s":"${style.status}",'
      '"k":"$kind",'
      '"o":$order,'
      '"c":[${style.base.join(',')}],'
      '"e":[${style.emissive.join(',')}],'
      '"p":${style.pulse}}';
}

PipelineO3dNodeStyle _pipeStyle(String fromStatus, String toStatus) {
  if (fromStatus == 'error' || toStatus == 'error') {
    return const PipelineO3dNodeStyle(
      status: 'error',
      base: [1.0, 0.2, 0.2, 1],
      emissive: [1.0, 0.1, 0.05],
      pulse: true,
    );
  }
  if (fromStatus == 'running' ||
      toStatus == 'running' ||
      fromStatus == 'warning' ||
      toStatus == 'warning') {
    return const PipelineO3dNodeStyle(
      status: 'running',
      base: [0.15, 0.65, 1.0, 1],
      emissive: [0.15, 0.9, 1.0],
      pulse: true,
    );
  }
  if (fromStatus == 'done' && toStatus == 'done') {
    return const PipelineO3dNodeStyle(
      status: 'done',
      base: [0.08, 0.85, 0.7, 1],
      emissive: [0.05, 0.5, 0.4],
      pulse: false,
    );
  }
  return const PipelineO3dNodeStyle(
    status: 'idle',
    base: [0.12, 0.16, 0.28, 0.55],
    emissive: [0.04, 0.08, 0.18],
    pulse: false,
  );
}

/// Stage + Node + Pipe 상태 (Trace ViewModel 스냅샷).
String pipelineO3dVisualPayloadJson({
  required TraceSnapshot? selected,
  required List<TraceSnapshot> traces,
  required List<PipelineStageDef> stages,
}) {
  final buf = StringBuffer('{');
  var first = true;

  void add(String mat, PipelineO3dNodeStyle style, String kind, int order) {
    if (!first) {
      buf.write(',');
    }
    first = false;
    buf.write(_styleJson(mat, style, kind, order));
  }

  final stageStatus = <String, String>{};
  for (final stage in stages) {
    final order = pipelineO3dStageOrder[stage.id] ?? 0;
    final visual = pipelineStageVisual(
      stageId: stage.id,
      selected: selected,
      traces: traces,
    );
    final style = pipelineO3dStyleFor(visual);
    stageStatus[stage.id] = style.status;
    add('mat__stage_${stage.id}', style, 'stage', order);

    for (final nodeId in stage.nodeIds) {
      final nodeVisual = pipelineNodeVisual(
        nodeId: nodeId,
        selected: selected,
        traces: traces,
      );
      add(
        pipelineO3dMaterialName(nodeId),
        pipelineO3dStyleFor(nodeVisual),
        'node',
        order,
      );
    }
  }

  for (final entry in pipelineO3dMainPipeStages.entries) {
    final st = stageStatus[entry.value] ?? 'idle';
    add(entry.key, _pipeStyle(st, st), 'pipe', pipelineO3dStageOrder[entry.value] ?? 0);
  }
  for (final entry in pipelineO3dBranchPipeStages.entries) {
    final st = stageStatus[entry.value] ?? 'idle';
    add(entry.key, _pipeStyle(st, st), 'pipe', pipelineO3dStageOrder[entry.value] ?? 0);
  }
  // 로컬 연결: 해당 stage 상태 따름
  for (final stage in stages) {
    final st = stageStatus[stage.id] ?? 'idle';
    final order = pipelineO3dStageOrder[stage.id] ?? 0;
    final localCount = (stage.nodeIds.length - 1).clamp(0, 32);
    for (var i = 0; i < localCount; i++) {
      add(
        'mat__pipe__local_${stage.id}_$i',
        _pipeStyle(st, st),
        'pipe',
        order,
      );
    }
  }

  buf.write('}');
  return buf.toString();
}

String pipelineO3dStageStatusPayloadJson({
  required TraceSnapshot? selected,
  required List<TraceSnapshot> traces,
  required List<PipelineStageDef> stages,
}) =>
    pipelineO3dVisualPayloadJson(
      selected: selected,
      traces: traces,
      stages: stages,
    );

String pipelineO3dStatusPayloadJson({
  required TraceSnapshot? selected,
  required List<TraceSnapshot> traces,
  required List<PipelineStageDef> stages,
}) =>
    pipelineO3dVisualPayloadJson(
      selected: selected,
      traces: traces,
      stages: stages,
    );

/// 상태별 명시적 점멸·흐름 발광 (model-viewer materials).
String pipelineO3dApplyStatusJs(String statusJson) {
  return '''
(function(){
  // 고정 변수명 대신 현재 연결된 model-viewer를 태그로 찾는다
  // (o3d가 마운트마다 유니크 id를 쓰므로 전역 const 이름에 의존하지 않는다).
  var mv = (function(){
    var els = document.querySelectorAll('model-viewer');
    for (var j = els.length - 1; j >= 0; j--) {
      if (els[j].isConnected) { return els[j]; }
    }
    return els.length ? els[els.length - 1] : null;
  })();
  if (!mv) { return; }
  // 클릭하면 흐름 스윕이 번진다(인터랙션). 재마운트에도 유지되도록 요소별 바인딩.
  if (!mv.__pipelineRippleBound) {
    mv.__pipelineRippleBound = true;
    mv.addEventListener('pointerdown', function() {
      window.__pipelineO3dRipple = window.__pipelineO3dT || 0;
    });
  }
  window.__pipelineO3dStates = $statusJson;
  function clamp01(x){ return x < 0 ? 0 : (x > 1 ? 1 : x); }
  // 매 동기화마다 apply를 교체해 hot reload·애니 보강이 즉시 반영되게 한다.
  window.__pipelineO3dApply = function() {
    var states = window.__pipelineO3dStates || {};
    var model = mv.model;
    if (!model || !model.materials) { return; }
    var mats = model.materials;
    var t = window.__pipelineO3dT || 0;

    // 클릭 인터랙션: 좌→우로 번지는 흐름 스윕 전선(front) 계산
    var rippleFront = null;
    var rt = window.__pipelineO3dRipple;
    if (rt != null) {
      var fr = (t - rt) * 4.5 - 1.0;
      if (fr <= 9.0) { rippleFront = fr; }
      else { window.__pipelineO3dRipple = null; }
    }

    for (var i = 0; i < mats.length; i++) {
      var m = mats[i];
      var st = states[m.name];
      if (!st) { continue; }
      var c = st.c.slice();
      var e = st.e.slice();
      var s = st.s;
      var k = st.k || 'node';
      var o = (typeof st.o === 'number') ? st.o : 0;
      var ph = o * 0.85; // 단계 순서에 따른 위상 → 좌→우 진행파
      if (s === 'running') {
        if (k === 'pipe') {
          // 흐름 방향으로 흐르는 광띠
          var streak = Math.pow(0.5 + 0.5 * Math.sin(t * 7 - ph * 1.4 - i * 0.2), 3);
          e = [
            clamp01(e[0] * (0.3 + 1.7 * streak)),
            clamp01(e[1] * (0.4 + 1.8 * streak)),
            clamp01(e[2] * (0.5 + 2.0 * streak))
          ];
          c[0] = clamp01(c[0] * (0.5 + 0.8 * streak));
          c[1] = clamp01(c[1] * (0.55 + 0.9 * streak));
          c[2] = clamp01(c[2] * (0.65 + 0.95 * streak));
        } else {
          // 아이콘·노드: 강한 심장박동 + 색 시머(진행 중임을 또렷이)
          var beat = Math.pow(0.5 + 0.5 * Math.sin(t * 5.5 - ph), 2);
          var boost = (k === 'stage') ? 2.6 : 2.0;
          var shimmer = 0.5 + 0.5 * Math.sin(t * 2.3 + o);
          e = [
            clamp01(e[0] * (0.25 + boost * beat) + 0.12 * shimmer),
            clamp01(e[1] * (0.3 + boost * beat) + 0.22 * beat),
            clamp01(e[2] * (0.4 + boost * beat) + 0.2 * (1 - shimmer))
          ];
          c[0] = clamp01(0.12 + c[0] * (0.5 + 0.7 * beat));
          c[1] = clamp01(0.3 + c[1] * (0.45 + 0.75 * beat));
          c[2] = clamp01(0.5 + c[2] * (0.4 + 0.85 * beat));
        }
      } else if (s === 'error') {
        var errOn = (Math.sin(t * 12) > 0) ? 1 : 0.12;
        var errBoost = (k === 'stage') ? 1.9 : 1.5;
        e = [clamp01(e[0] * errOn * errBoost), clamp01(e[1] * errOn), clamp01(e[2] * errOn)];
        c[0] = clamp01(c[0] * (0.35 + 0.75 * errOn));
        c[1] = clamp01(c[1] * errOn);
        c[2] = clamp01(c[2] * errOn);
      } else if (s === 'warning') {
        var w = 0.3 + 0.7 * (0.5 + 0.5 * Math.sin(t * 4.5 - ph * 0.5));
        e = [clamp01(e[0] * w * 1.4), clamp01(e[1] * w), clamp01(e[2] * w * 0.4)];
        c[0] = clamp01(c[0] * (0.55 + 0.55 * w));
      } else if (s === 'done') {
        // 완료: 밝게 정착 + 은은한 숨쉬기 (아이콘은 조금 더 밝게)
        var dg = (k === 'stage') ? 1.25 : 1.0;
        var breath = 0.9 + 0.14 * Math.sin(t * 1.3 - ph * 0.3);
        e = [clamp01(e[0] * breath * dg), clamp01(e[1] * breath * dg), clamp01(e[2] * breath * dg)];
      } else if (s === 'idle' || s === 'skipped') {
        if (k === 'stage' && s === 'idle') {
          // 대기 아이콘: 꺼지지 않고 느린 미세 글로우 (대기 중임을 표시)
          var wait = 0.08 + 0.06 * (0.5 + 0.5 * Math.sin(t * 1.6 - ph));
          e = [c[0] * wait, c[1] * wait, c[2] * wait];
        } else {
          e = [0, 0, 0];
        }
        if (s === 'skipped') { c[3] = 0.28; }
      }

      // 클릭 스윕(인터랙션): 전선이 지나가는 단계를 순간적으로 밝힌다
      if (rippleFront != null) {
        var d = o - rippleFront;
        var rip = Math.exp(-(d * d) / 0.5);
        if (rip > 0.01) {
          e[0] = clamp01(e[0] + rip * (0.4 + 0.8 * st.c[0]));
          e[1] = clamp01(e[1] + rip * (0.5 + 0.8 * st.c[1]));
          e[2] = clamp01(e[2] + rip * (0.6 + 0.8 * st.c[2]));
          c[0] = clamp01(c[0] + rip * 0.3);
          c[1] = clamp01(c[1] + rip * 0.35);
          c[2] = clamp01(c[2] + rip * 0.4);
        }
      }

      try {
        m.pbrMetallicRoughness.setBaseColorFactor(c);
        if (m.setEmissiveFactor) { m.setEmissiveFactor(e); }
      } catch (err) {}
    }
  };
  if (!window.__pipelineO3dBoot) {
    window.__pipelineO3dBoot = true;
    window.__pipelineO3dT = 0;
    function tick() {
      window.__pipelineO3dT += 0.016;
      if (window.__pipelineO3dApply) { window.__pipelineO3dApply(); }
      requestAnimationFrame(tick);
    }
    var start = function() {
      if (mv.model) { tick(); }
      else { mv.addEventListener('load', function(){ tick(); }, { once: true }); }
    };
    start();
  } else if (window.__pipelineO3dApply) {
    window.__pipelineO3dApply();
  }
})();
''';
}
