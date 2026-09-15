import 'package:fluent_ui/fluent_ui.dart';

import '../../../../domain/entities/work_detail.dart';
import '../../../../domain/entities/work_detail_tab.dart';
import '../work_detail_view_model.dart';

class WorkDetailTabs extends StatelessWidget {
  const WorkDetailTabs({
    super.key,
    required this.viewModel,
    required this.detail,
  });

  final WorkDetailViewModel viewModel;
  final WorkDetail detail;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final tab in WorkDetailTab.values)
          Button(
            onPressed: () => viewModel.didSelectTab(tab),
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                viewModel.selectedTab == tab
                    ? const Color(0xFF3A4558)
                    : const Color(0xFF2A2D32),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(tab.label),
                if (tab != WorkDetailTab.overview) ...[
                  const SizedBox(width: 6),
                  Text(
                    '${detail.countByType(tab.attachmentType!)}',
                    style: const TextStyle(fontSize: 11),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}
