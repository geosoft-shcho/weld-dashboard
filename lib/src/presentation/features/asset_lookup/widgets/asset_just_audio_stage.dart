import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:just_audio/just_audio.dart';
import 'package:waveform_pro/waveform_pro.dart';

import '../../../../domain/use_cases/load_audio_waveform_use_case.dart';
import '../../../core/di/locator.dart';
import '../../../core/formatters/dashboard_formatters.dart';
import '../../../core/themes/app_theme.dart';
import '../../../core/widgets/waveform_material_scope.dart';

/// 에셋 상세 음성 미리보기: just_audio 재생 + waveform_pro 파형.
class AssetJustAudioStage extends StatefulWidget {
  const AssetJustAudioStage({super.key, required this.contentUrl});

  final String contentUrl;

  @override
  State<AssetJustAudioStage> createState() => _AssetJustAudioStageState();
}

class _AssetJustAudioStageState extends State<AssetJustAudioStage> {
  final AudioPlayer _player = AudioPlayer();
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;

  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isPlaying = false;
  bool _isReady = false;
  bool _isWaveformLoading = false;
  String _errorMessage = '';
  String _waveformError = '';
  List<double> _amplitudes = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant AssetJustAudioStage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.contentUrl != widget.contentUrl) {
      _load();
    }
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _player.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    await _positionSubscription?.cancel();
    await _playerStateSubscription?.cancel();
    setState(() {
      _isReady = false;
      _isWaveformLoading = false;
      _errorMessage = '';
      _waveformError = '';
      _position = Duration.zero;
      _duration = Duration.zero;
      _isPlaying = false;
      _amplitudes = const [];
    });
    try {
      final source = widget.contentUrl;
      final duration =
          source.startsWith('http://') || source.startsWith('https://')
          ? await _player.setUrl(source)
          : await _player.setAsset(source);
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

  Future<void> _loadWaveform() async {
    final contentUrl = widget.contentUrl;
    setState(() {
      _isWaveformLoading = true;
      _waveformError = '';
      _amplitudes = const [];
    });
    try {
      final load = await locator<LoadAudioWaveformUseCase>().execute(
        contentUrl: contentUrl,
      );
      if (!mounted || widget.contentUrl != contentUrl) {
        return;
      }
      setState(() {
        _amplitudes = load.amplitudes;
        _waveformError = load.errorMessage;
        _isWaveformLoading = false;
      });
    } catch (error) {
      if (!mounted || widget.contentUrl != contentUrl) {
        return;
      }
      setState(() {
        _amplitudes = const [];
        _waveformError = error.toString();
        _isWaveformLoading = false;
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
  }

  void _didChangePlayerState(PlayerState state) {
    if (!mounted) {
      return;
    }
    setState(() {
      _isPlaying = state.playing;
    });
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
    await _player.seek(
      Duration(milliseconds: (seconds * 1000).round()),
    );
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
    final durationSeconds = _duration.inMilliseconds / 1000.0;
    final positionSeconds = _position.inMilliseconds / 1000.0;
    final playheadSeconds = durationSeconds > 0
        ? positionSeconds.clamp(0.0, durationSeconds)
        : -1.0;
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: _buildWaveform(
              durationSeconds: durationSeconds,
              playheadSeconds: playheadSeconds,
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

  Widget _buildWaveform({
    required double durationSeconds,
    required double playheadSeconds,
  }) {
    if (_isWaveformLoading) {
      return const Center(child: ProgressRing());
    }
    if (_waveformError.isNotEmpty) {
      return Center(
        child: Text(
          _waveformError,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, color: AppTheme.STATUS_OFF),
        ),
      );
    }
    if (_amplitudes.isEmpty || durationSeconds <= 0) {
      return const Center(
        child: Text(
          '파형 데이터 없음',
          style: TextStyle(fontSize: 12, color: AppTheme.STATUS_OFF),
        ),
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final data = WaveformData(
          samples: _amplitudes,
          durationSeconds: durationSeconds,
        );
        return WaveformMaterialScope(
          child: WaveformTimeline(
            data: data,
            height: constraints.maxHeight,
            showTimeRuler: false,
            enableZoom: false,
            enableRegionSelection: false,
            enableMarkers: false,
            playheadPosition: playheadSeconds,
            playheadColor: AppTheme.ACCENT_STEEL,
            style: const WaveformStyle(
              renderMode: WaveformRenderMode.continuous,
              waveColor: AppTheme.ACCENT_STEEL,
              playedWaveColor: AppTheme.ACCENT_STEEL,
              backgroundColor: AppTheme.SURFACE,
              centerLineColor: Color(0x00000000),
              fillWaveform: false,
              waveStrokeWidth: 1.5,
            ),
            onTap: _didSeek,
          ),
        );
      },
    );
  }
}
