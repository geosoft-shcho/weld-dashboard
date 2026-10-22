import 'package:fluent_ui/fluent_ui.dart';

import '../../../core/themes/app_theme.dart';
import '../job_lookup_detail_view_model.dart';

/// Windows-style job detail tabs: full-width bottom rule + selected underline.
/// PassTabsBar와 같은 시각 규칙을 작업 상세 탭에 적용한 것이다.
class JobDetailTabsBar extends StatelessWidget {
  const JobDetailTabsBar({
    super.key,
    required this.selectedTab,
    required this.passCount,
    required this.attachmentCount,
    required this.onSelectTab,
  });

  final JobLookupDetailTab selectedTab;
  final int passCount;
  final int attachmentCount;
  final ValueChanged<JobLookupDetailTab> onSelectTab;

  static final Color _LINE = AppTheme.STATUS_OFF.withValues(alpha: 0.45);

  @override
  Widget build(BuildContext context) {
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
            _tab(JobLookupDetailTab.info, '기본 정보'),
            _tab(JobLookupDetailTab.passes, '패스 $passCount'),
            _tab(JobLookupDetailTab.attachments, '첨부 $attachmentCount'),
          ],
        ),
      ),
    );
  }

  Widget _tab(JobLookupDetailTab tab, String label) {
    return Transform.translate(
      offset: const Offset(0, 1),
      child: _JobTab(
        label: label,
        isSelected: tab == selectedTab,
        onPressed: () => onSelectTab(tab),
      ),
    );
  }
}

class _JobTab extends StatelessWidget {
  const _JobTab({
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
