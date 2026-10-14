import 'package:fluent_ui/fluent_ui.dart';

const int _SECONDS_PER_TRACK = 1;

Future<void> showVectorDbSavedDialog(
  BuildContext context, {
  required int changedTrackCount,
}) {
  final trackCount = changedTrackCount < 1 ? 1 : changedTrackCount;
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return _VectorDbSavedDialog(changedTrackCount: trackCount);
    },
  );
}

class _VectorDbSavedDialog extends StatefulWidget {
  const _VectorDbSavedDialog({required this.changedTrackCount});

  final int changedTrackCount;

  @override
  State<_VectorDbSavedDialog> createState() => _VectorDbSavedDialogState();
}

class _VectorDbSavedDialogState extends State<_VectorDbSavedDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _progress;

  @override
  void initState() {
    super.initState();
    _progress = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: widget.changedTrackCount * _SECONDS_PER_TRACK,
      ),
    );
    _progress.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() {});
      }
    });
    _progress.forward();
  }

  @override
  void dispose() {
    _progress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isComplete = _progress.isCompleted;
    return PopScope(
      canPop: isComplete,
      child: ContentDialog(
        title: const Text('안내'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('vector DB로 저장되었습니다'),
            const SizedBox(height: 12),
            AnimatedBuilder(
              animation: _progress,
              builder: (context, child) {
                return ProgressBar(value: _progress.value * 100);
              },
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: isComplete ? () => Navigator.pop(context) : null,
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
}
