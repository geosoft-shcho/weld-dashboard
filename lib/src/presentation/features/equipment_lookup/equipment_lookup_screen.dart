import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../core/di/locator.dart';
import '../../core/widgets/catalog_lookup_table.dart';
import '../../core/widgets/lookup_search_field.dart';
import '../../navigation/app_coordinator.dart';
import 'equipment_create_dialog.dart';
import 'equipment_lookup_view_model.dart';

class EquipmentLookupScreen extends StatelessWidget {
  const EquipmentLookupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator<EquipmentLookupViewModel>()..load(),
      child: const _EquipmentLookupBody(),
    );
  }
}

class _EquipmentLookupBody extends StatelessWidget {
  const _EquipmentLookupBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<EquipmentLookupViewModel>();
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      content: Padding(
        padding: const EdgeInsets.all(16),
        child: _content(context, viewModel),
      ),
    );
  }

  Widget _content(BuildContext context, EquipmentLookupViewModel viewModel) {
    if (viewModel.isLoading && viewModel.visibleEquipment.isEmpty) {
      return const Center(child: ProgressRing());
    }
    if (viewModel.hasError) {
      return InfoBar(
        title: const Text('조회 실패'),
        content: Text(viewModel.errorMessage),
        action: Button(onPressed: viewModel.load, child: const Text('재시도')),
        severity: InfoBarSeverity.error,
      );
    }
    return CatalogLookupFrame(
      tableHeader: LookupTableHeader(
        label: '장비',
        count: viewModel.totalCount,
        actionText: '+ 새 장비',
        onAction: () => _didTapNewEquipment(context, viewModel),
      ),
      filters: [
        InfoLabel(
          label: '검색',
          child: SizedBox(
            width: 240,
            child: LookupSearchField(
              value: viewModel.queryText,
              hintText: '코드 · 이름 · 비고',
              onChanged: viewModel.didChangeQueryText,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Checkbox(
            checked: viewModel.includeInactive,
            content: const Text('숨긴 장비도'),
            onChanged: (value) {
              if (value != null) {
                viewModel.didToggleIncludeInactive(value);
              }
            },
          ),
        ),
      ],
      body: CatalogLookupTable(
        headers: const ['장비 코드', '이름', '쓰인 작업', '기록한 에셋'],
        columnFlexes: const [16, 18, 10, 10],
        emptyTitle: '조건에 맞는 장비가 없습니다',
        isLoadingMore: viewModel.isLoadingMore,
        onNearEnd: viewModel.didScrollNearEnd,
        rows: [
          for (final item in viewModel.visibleEquipment)
            [
              item.equipmentCode.isEmpty ? '—' : item.equipmentCode,
              equipmentNameCell(item),
              '${item.jobCount}건',
              '${item.assetCount}건',
            ],
        ],
        onRowTap: (index) {
          final item = viewModel.visibleEquipment[index];
          context.read<AppCoordinator>().didTapOpenEquipmentDetail(
            item.equipmentId,
          );
        },
      ),
    );
  }
}

Future<void> _didTapNewEquipment(
  BuildContext context,
  EquipmentLookupViewModel viewModel,
) async {
  final equipmentId = await showEquipmentCreateDialog(context, viewModel);
  if (equipmentId == null || equipmentId.isEmpty || !context.mounted) {
    return;
  }
  await viewModel.load();
  if (!context.mounted) {
    return;
  }
  context.read<AppCoordinator>().didTapOpenEquipmentDetail(equipmentId);
}
