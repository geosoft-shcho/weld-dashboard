import 'package:fluent_ui/fluent_ui.dart';

import '../../../../domain/entities/collection_event.dart';
import '../../../../domain/entities/connection_status.dart';
import '../../../core/themes/app_theme.dart';

class TimelineStatusStyle {
  const TimelineStatusStyle({
    required this.fill,
    required this.border,
    required this.isDashed,
  });

  final Color fill;
  final Color border;
  final bool isDashed;

  factory TimelineStatusStyle.of(CollectionEvent event) {
    Color fill;
    Color border;
    switch (event.connectionStatus) {
      case ConnectionStatus.connected:
        fill = AppTheme.STATUS_OK.withValues(alpha: 0.38);
        border = AppTheme.STATUS_OK;
      case ConnectionStatus.disconnected:
        fill = AppTheme.STATUS_OFF.withValues(alpha: 0.38);
        border = AppTheme.STATUS_OFF;
      case ConnectionStatus.error:
        fill = AppTheme.STATUS_ERROR.withValues(alpha: 0.38);
        border = AppTheme.STATUS_ERROR;
    }
    if (event.isLossWarning) {
      border = AppTheme.STATUS_WARN;
    }
    return TimelineStatusStyle(
      fill: fill,
      border: border,
      isDashed: event.isDesynced,
    );
  }

  BoxDecoration decoration({required bool isSelected}) {
    return BoxDecoration(
      color: fill,
      borderRadius: BorderRadius.circular(4),
      border: Border.all(
        color: isSelected ? AppTheme.ACCENT_STEEL : border,
        width: isSelected ? 2 : 1,
        style: isDashed ? BorderStyle.none : BorderStyle.solid,
      ),
    );
  }
}

class TimelineStatusSwatch extends StatelessWidget {
  const TimelineStatusSwatch({
    super.key,
    required this.color,
    this.isDashed = false,
  });

  final Color color;
  final bool isDashed;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(12, 12),
      painter: _SwatchPainter(color: color, isDashed: isDashed),
    );
  }
}

class DashedRRectPainter extends CustomPainter {
  const DashedRRectPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;
    const dash = 4.0;
    const gap = 3.0;
    final rect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(4),
    );
    final path = Path()..addRRect(rect);
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dash;
        canvas.drawPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          paint,
        );
        distance = next + gap;
      }
    }
  }

  @override
  bool shouldRepaint(DashedRRectPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class _SwatchPainter extends CustomPainter {
  const _SwatchPainter({required this.color, required this.isDashed});

  final Color color;
  final bool isDashed;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final fill = Paint()..color = color.withValues(alpha: 0.45);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(2)),
      fill,
    );
    final border = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    if (!isDashed) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(2)),
        border,
      );
      return;
    }
    const dash = 2.0;
    const gap = 1.5;
    var x = 0.0;
    while (x < size.width) {
      canvas.drawLine(
        Offset(x, 0),
        Offset((x + dash).clamp(0, size.width), 0),
        border,
      );
      canvas.drawLine(
        Offset(x, size.height),
        Offset((x + dash).clamp(0, size.width), size.height),
        border,
      );
      x += dash + gap;
    }
  }

  @override
  bool shouldRepaint(_SwatchPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.isDashed != isDashed;
  }
}

class TimelineStatusBlock extends StatelessWidget {
  const TimelineStatusBlock({
    super.key,
    required this.event,
    required this.isSelected,
    required this.child,
    this.onPressed,
  });

  final CollectionEvent event;
  final bool isSelected;
  final Widget child;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final style = TimelineStatusStyle.of(event);
    return HoverButton(
      onPressed: onPressed,
      builder: (context, states) {
        return CustomPaint(
          foregroundPainter: style.isDashed
              ? DashedRRectPainter(color: style.border)
              : null,
          child: DecoratedBox(
            decoration: style.decoration(isSelected: isSelected),
            child: child,
          ),
        );
      },
    );
  }
}
