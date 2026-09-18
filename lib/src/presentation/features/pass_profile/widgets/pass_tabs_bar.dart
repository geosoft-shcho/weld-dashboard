import 'package:fluent_ui/fluent_ui.dart';

import '../../../../domain/entities/weld_pass.dart';
import '../../../core/themes/app_theme.dart';
import '../../../core/widgets/section_empty_placeholder.dart';

/// Windows-style pass tabs: full-width bottom rule + selected underline.
class PassTabsBar extends StatelessWidget {
  const PassTabsBar({
    super.key,
    required this.passes,
    required this.selectedPassId,
    required this.onSelectPass,
  });

  final List<WeldPass> passes;
  final String selectedPassId;
  final ValueChanged<String> onSelectPass;

  static final Color _LINE = AppTheme.STATUS_OFF.withValues(alpha: 0.45);

  @override
  Widget build(BuildContext context) {
    if (passes.isEmpty) {
      return const SectionEmptyPlaceholder(
        title: '표시할 패스가 없습니다',
        message: '이 공통키에 연결된 패스(루트·채움·캡)가 없습니다.',
      );
    }
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: _LINE, width: 1)),
        ),
        child: Wrap(
          spacing: 16,
          runSpacing: 0,
          crossAxisAlignment: WrapCrossAlignment.end,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 4, bottom: 6),
              child: Text(
                '패스',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.04 * 11,
                  color: AppTheme.STATUS_OFF,
                  height: 1.25,
                ),
              ),
            ),
            for (final pass in passes)
              Transform.translate(
                offset: const Offset(0, 1),
                child: _PassTab(
                  label: 'P${pass.passNo} ${pass.passName}',
                  isSelected: pass.passId == selectedPassId,
                  onPressed: () => onSelectPass(pass.passId),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PassTab extends StatelessWidget {
  const _PassTab({
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return HoverButton(
      onPressed: onPressed,
      builder: (context, states) {
        final isHovered = states.isHovered;
        final color = isSelected || isHovered
            ? AppTheme.INK
            : AppTheme.STATUS_OFF;
        return DecoratedBox(
          decoration: BoxDecoration(
            border: isSelected
                ? const Border(
                    bottom: BorderSide(color: AppTheme.INK, width: 2),
                  )
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 6),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        );
      },
    );
  }
}
