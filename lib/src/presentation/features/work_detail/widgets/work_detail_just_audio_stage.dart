import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:just_audio/just_audio.dart';
import 'package:waveform_visualizer/waveform_visualizer.dart';

import '../../../core/formatters/dashboard_formatters.dart';
import '../../../core/themes/app_theme.dart';
import 'audio_waveform_data.dart';
import 'work_detail_material_scope.dart';
import 'work_detail_waveform_loader.dart';

const int WAVEFORM_MAX_DATA_POINTS = 80;
const int WAVEFORM_BAR_COUNT = 56;

class WorkDetailJustAudioStage extends StatefulWidget {
  const WorkDetailJustAudioStage({super.key, required this.assetPath});

  final String assetPath;

  @override
  State<WorkDetailJustAudioStage> createState() =>
      _WorkDetailJustAudioStageState();
}

class _WorkDetailJustAudioStageState extends State<WorkDetailJustAudioStage> {
  final AudioPlayer _player = AudioPlayer();
  final WaveformController _waveformController = WaveformController(
    maxDataPoints: WAVEFORM_MAX_DATA_POINTS,
    updateInterval: const Duration(milliseconds: 33),
    smoothingFactor: 0.2,
  );
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isPlaying = false;
  bool _isReady = false;
  bool _hasWaveform = false;
  String _errorMessage = '';
  AudioWaveformData? _waveform;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant WorkDetailJustAudioStage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assetPath != widget.assetPath) {
      _load();
    }
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _waveformController.dispose();
    _player.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    await _positionSubscription?.cancel();
    await _playerStateSubscription?.cancel();
    _waveformController.reset();
    setState(() {
      _isReady = false;
      _hasWaveform = false;
      _errorMessage = '';
      _position = Duration.zero;
      _duration = Duration.zero;
      _isPlaying = false;
      _waveform = null;
    });
    try {
      final duration = await _player.setAsset(widget.assetPath);
      _positionSubscription = _player.positionStream.listen(_didChangePosition);
      _playerStateSubscription = _player.playerStateStream.listen(
        _didChangePlayerState,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _duration = duration ?? Duration.zero;
        _isReady = true;
      });
      unawaited(_loadWaveform());
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = error.toString();
      });
    }
  }

  void _didChangePosition(Duration position) {
    if (!mounted) {
      return;
    }
    setState(() {
      _position = position;
    });
    if (_isPlaying) {
      _didPushAmplitude(position);
    }
  }

  void _didChangePlayerState(PlayerState state) {
    if (!mounted) {
      return;
    }
    final wasPlaying = _isPlaying;
    setState(() {
      _isPlaying = state.playing;
    });
    if (wasPlaying && !state.playing) {
      _didSeedWaveform();
    }
  }

  Future<void> _loadWaveform() async {
    final audioAssetPath = widget.assetPath;
    try {
      final waveform = await loadWorkDetailWaveform(
        audioAssetPath: audioAssetPath,
        waveformAssetPath: AudioWaveformData.assetPathFor(audioAssetPath),
      );
      if (!mounted || widget.assetPath != audioAssetPath) {
        return;
      }
      _waveform = waveform;
      _didSeedWaveform();
      setState(() {
        _hasWaveform = true;
      });
    } catch (_) {
      if (!mounted || widget.assetPath != audioAssetPath) {
        return;
      }
      setState(() {
        _hasWaveform = true;
      });
    }
  }

  void _didSeedWaveform() {
    final waveform = _waveform;
    if (waveform == null) {
      return;
    }
    _waveformController.reset();
    for (final amplitude in waveform.sampledAmplitudes(
      _waveformController.maxDataPoints,
    )) {
      _waveformController.updateAmplitude(amplitude);
    }
  }

  void _didPushAmplitude(Duration position) {
    final waveform = _waveform;
    if (waveform == null) {
      return;
    }
    _waveformController.updateAmplitude(waveform.amplitudeAt(position));
  }

  Future<void> _didTapPlayPause() async {
    if (!_isReady) {
      return;
    }
    if (_isPlaying) {
      await _player.pause();
      return;
    }
    if (_duration.inMilliseconds > 0 &&
        _position >= _duration - const Duration(milliseconds: 200)) {
      await _player.seek(Duration.zero);
    }
    await _player.play();
  }

  Future<void> _didSeek(double seconds) async {
    if (!_isReady) {
      return;
    }
    final position = Duration(milliseconds: (seconds * 1000).round());
    await _player.seek(position);
    if (_isPlaying) {
      _didPushAmplitude(position);
    } else {
      _didSeedWaveform();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Text(
          '오디오를 열 수 없습니다.\n$_errorMessage',
          textAlign: TextAlign.center,
        ),
      );
    }
    if (!_isReady) {
      return const Center(child: ProgressRing());
    }
    final durationSeconds = _duration.inMilliseconds / 1000;
    final positionSeconds = _position.inMilliseconds / 1000;
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapDown: (details) {
                    final ratio =
                        details.localPosition.dx / constraints.maxWidth;
                    _didSeek(durationSeconds * ratio.clamp(0, 1));
                  },
                  child: !_hasWaveform
                      ? const Center(child: ProgressRing())
                      : WorkDetailMaterialScope(
                          child: WaveformWidget(
                            controller: _waveformController,
                            height: constraints.maxHeight,
                            width: constraints.maxWidth,
                            style: const WaveformStyle(
                              waveColor: AppTheme.ACCENT_STEEL,
                              backgroundColor: AppTheme.SURFACE,
                              waveformStyle: WaveformDrawStyle.bars,
                              showGradient: false,
                              barCount: WAVEFORM_BAR_COUNT,
                              barSpacing: 2,
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                );
              },
            ),
          ),
        ),
        Row(
          children: [
            Button(
              onPressed: _didTapPlayPause,
              child: Text(_isPlaying ? '일시정지' : '재생'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Slider(
                min: 0,
                max: durationSeconds <= 0 ? 1 : durationSeconds,
                value: positionSeconds.clamp(
                  0,
                  durationSeconds <= 0 ? 1 : durationSeconds,
                ),
                onChanged: _didSeek,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${DashboardFormatters.mediaClock(positionSeconds)} / ${DashboardFormatters.mediaClock(durationSeconds)}',
            ),
          ],
        ),
      ],
    );
  }
}
