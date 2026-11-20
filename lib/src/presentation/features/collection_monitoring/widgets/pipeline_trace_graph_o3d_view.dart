import 'package:fluent_ui/fluent_ui.dart';
import 'package:o3d/o3d.dart';

import '../../../core/themes/app_theme.dart';
import '../pipeline_trace_view_model.dart';
import 'pipeline_o3d_full_bridge.dart';

/// pipeline.glb + 아이소 카메라 + Trace(ViewModel) → Node/Stage/Pipe 재질.
class PipelineTraceGraphO3dView extends StatefulWidget {
  const PipelineTraceGraphO3dView({super.key, required this.viewModel});

  final PipelineTraceViewModel viewModel;

  @override
  State<PipelineTraceGraphO3dView> createState() =>
      _PipelineTraceGraphO3dViewState();
}

class _CameraPreset {
  const _CameraPreset({
    required this.label,
    required this.theta,
    required this.phi,
    required this.radius,
    required this.targetX,
    required this.targetY,
    required this.targetZ,
  });

  final String label;
  final double theta;
  final double phi;
  final double radius;
  final double targetX;
  final double targetY;
  final double targetZ;
}

class _PipelineTraceGraphO3dViewState extends State<PipelineTraceGraphO3dView> {
  final O3DController _controller = O3DController();
  bool _playing = true;
  bool _autoRotate = false;
  int _presetIndex = 0;
  String _lastPayload = '';

  /// 첨부 구도: 대각 백본이 프레임을 가로지르는 아이소.
  static const _presets = <_CameraPreset>[
    _CameraPreset(
      label: '전체',
      theta: 12,
      phi: 82,
      radius: 18,
      targetX: 0.0,
      targetY: 1.4,
      targetZ: 0.0,
    ),
    _CameraPreset(
      label: 'CI',
      theta: 10,
      phi: 83,
      radius: 11,
      targetX: -3.6,
      targetY: 1.4,
      targetZ: 0.0,
    ),
    _CameraPreset(
      label: 'CD',
      theta: 10,
      phi: 83,
      radius: 10,
      targetX: 3.8,
      targetY: 1.4,
      targetZ: 0.0,
    ),
    _CameraPreset(
      label: '백본',
      theta: 8,
      phi: 86,
      radius: 14,
      targetX: 0.0,
      targetY: 0.55,
      targetZ: 0.0,
    ),
    _CameraPreset(
      label: '측면',
      theta: 38,
      phi: 72,
      radius: 17,
      targetX: 0.0,
      targetY: 1.4,
      targetZ: 0.0,
    ),
  ];

  PipelineTraceViewModel get viewModel => widget.viewModel;

  @override
  void initState() {
    super.initState();
    viewModel.addListener(_onVm);
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncVisualStatus());
  }

  @override
  void dispose() {
    viewModel.removeListener(_onVm);
    super.dispose();
  }

  void _onVm() {
    _syncVisualStatus();
    if (mounted) {
      setState(() {});
    }
  }

  void _syncVisualStatus() {
    final payload = pipelineO3dVisualPayloadJson(
      selected: viewModel.selected,
      traces: viewModel.visibleTraces,
      stages: viewModel.visibleStages,
    );
    if (payload == _lastPayload) {
      return;
    }
    _runWhenBridgeReady(() {
      _controller.customJsCode(pipelineO3dApplyStatusJs(payload));
      _lastPayload = payload;
    });
  }

  Future<void> _runWhenBridgeReady(void Function() action) async {
    for (var attempt = 0; attempt < 25; attempt++) {
      try {
        action();
        return;
      } catch (_) {
        await Future<void>.delayed(const Duration(milliseconds: 120));
        if (!mounted) {
          return;
        }
      }
    }
  }

  void _applyPreset(_CameraPreset p) {
    _runWhenBridgeReady(() {
      _controller.cameraTarget(p.targetX, p.targetY, p.targetZ);
      _controller.cameraOrbit(p.theta, p.phi, p.radius);
    });
  }

  void _togglePlay() {
    setState(() {
      _playing = !_playing;
    });
    _runWhenBridgeReady(() {
      if (_playing) {
        _controller.animationName = 'idle';
        _controller.play();
      } else {
        _controller.pause();
      }
    });
  }

  void _toggleAutoRotate() {
    setState(() {
      _autoRotate = !_autoRotate;
    });
    _runWhenBridgeReady(() {
      _controller.autoRotate = _autoRotate;
    });
  }

  void _cyclePreset() {
    setState(() {
      _presetIndex = (_presetIndex + 1) % _presets.length;
    });
    _applyPreset(_presets[_presetIndex]);
  }

  @override
  Widget build(BuildContext context) {
    final preset = _presets[_presetIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'O3D · pipeline'
                  ' · ${preset.label}'
                  ' · 진행 ${viewModel.runningCount}'
                  ' · 완료 ${viewModel.doneCount}'
                  ' · 실패 ${viewModel.failedCount}'
                  '  · 점멸=진행 · 청록=완료 · 적점멸=실패 · 클릭=흐름 스윕',
                  style: const TextStyle(
                    color: AppTheme.STATUS_OFF,
                    fontSize: 11,
                  ),
                ),
              ),
              Tooltip(
                message: _playing ? '전체 애니 일시정지' : '전체 애니 재생',
                child: IconButton(
                  icon: Icon(
                    _playing ? FluentIcons.pause : FluentIcons.play,
                    size: 14,
                  ),
                  onPressed: _togglePlay,
                ),
              ),
              Tooltip(
                message: _autoRotate ? '자동 회전 끄기' : '자동 회전',
                child: IconButton(
                  icon: Icon(
                    FluentIcons.sync,
                    size: 14,
                    color: _autoRotate ? AppTheme.ACCENT_STEEL : null,
                  ),
                  onPressed: _toggleAutoRotate,
                ),
              ),
              Tooltip(
                message:
                    '카메라: ${_presets[(_presetIndex + 1) % _presets.length].label}',
                child: IconButton(
                  icon: const Icon(FluentIcons.video, size: 14),
                  onPressed: _cyclePreset,
                ),
              ),
              Text(
                preset.label,
                style: const TextStyle(
                  color: AppTheme.STATUS_OFF,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.SURFACE_RAISED,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: AppTheme.STATUS_OFF.withValues(alpha: 0.35),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: O3D.asset(
              // id를 고정하지 않는다: o3d가 마운트마다 유니크 id로
              // `const o3d<id>`를 전역 선언하므로, 재마운트(2D↔O3D·핫리로드) 시
              // 동일 식별자 재선언으로 인한 SyntaxError를 피한다.
              src: 'assets/glb/pipeline/pipeline.glb',
              controller: _controller,
              cameraOrbit: CameraOrbit(
                preset.theta,
                preset.phi,
                preset.radius,
              ),
              cameraTarget: CameraTarget(
                preset.targetX,
                preset.targetY,
                preset.targetZ,
              ),
              fieldOfView: '30deg',
              cameraControls: true,
              disablePan: false,
              autoRotate: _autoRotate,
              autoRotateDelay: 0,
              autoPlay: true,
              animationName: 'idle',
              interactionPrompt: InteractionPrompt.none,
              backgroundColor: const Color(0xFF1C1F24),
              ar: false,
            ),
          ),
        ),
      ],
    );
  }
}
