import 'package:fluent_ui/fluent_ui.dart';

import '../themes/app_theme.dart';

/// Shared empty state for pass/quality section widgets (s3 · s4).
class SectionEmptyPlaceholder extends StatelessWidget {
  const SectionEmptyPlaceholder({
    super.key,
    required this.title,
    this.message,
    this.minHeight,
  });

  final String title;
  final String? message;
  final double? minHeight;

  static const Color _BORDER = Color(0xFF3E424A);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: minHeight == null
          ? null
          : BoxConstraints(minHeight: minHeight!),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.SURFACE_RAISED,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: _BORDER),
      ),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.INK,
            ),
          ),
          if (message != null && message!.trim().isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              message!,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.STATUS_OFF,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
