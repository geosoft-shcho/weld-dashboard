import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../core/di/locator.dart';
import '../../core/widgets/catalog_lookup_table.dart';
import '../../core/widgets/lookup_search_field.dart';
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
        child: _content(viewModel),
      ),
    );
  }

  Widget _content(EquipmentLookupViewModel viewModel) {
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
    final lineName = viewModel.lineNames.contains(viewModel.lineName)
        ? viewModel.lineName
        : '';
    return CatalogLookupFrame(
      actionLabel: '새 장비',
      filters: [
        InfoLabel(
          label: '검색',
          child: SizedBox(
            width: 240,
            child: LookupSearchField(
              value: viewModel.queryText,
              hintText: '코드 · 이름 · 라인',
              onChanged: viewModel.didChangeQueryText,
            ),
          ),
        ),
        InfoLabel(
          label: '라인',
          child: ComboBox<String>(
            value: lineName,
            items: [
              const ComboBoxItem(value: '', child: Text('전체')),
              for (final name in viewModel.lineNames)
                ComboBoxItem(value: name, child: Text(name)),
            ],
            onChanged: (value) {
              if (value != null) {
                viewModel.didSelectLine(value);
              }
            },
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
        headers: const ['장비 코드', '이름', '라인', '쓰인 작업'],
        columnFlexes: const [16, 18, 12, 10],
        emptyTitle: '조건에 맞는 장비가 없습니다',
        rows: [
          for (final item in viewModel.visibleEquipment)
            [
              item.equipmentCode.isEmpty ? '—' : item.equipmentCode,
              equipmentNameCell(item),
              item.lineName.isEmpty ? '—' : item.lineName,
              '${item.jobCount}건',
            ],
        ],
      ),
    );
  }
}
