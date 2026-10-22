import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/asset_lookup_kind.dart';
import '../../core/di/locator.dart';
import '../../core/formatters/dashboard_formatters.dart';
import '../../core/themes/app_theme.dart';
import '../../core/widgets/lookup_detail_scaffold.dart';
import '../../core/widgets/pass_context_bar.dart';
import '../../navigation/app_coordinator.dart';
import 'equipment_lookup_detail_view_model.dart';

class EquipmentLookupDetailScreen extends StatelessWidget {
  const EquipmentLookupDetailScreen({super.key, required this.equipmentId});

  final String equipmentId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          locator<EquipmentLookupDetailViewModel>(param1: equipmentId)..load(),
      child: const _EquipmentLookupDetailBody(),
    );
  }
}

enum _EquipmentDetailTab { jobs, assets }

class _EquipmentLookupDetailBody extends StatefulWidget {
  const _EquipmentLookupDetailBody();

  @override
  State<_EquipmentLookupDetailBody> createState() =>
      _EquipmentLookupDetailBodyState();
}

class _EquipmentLookupDetailBodyState
    extends State<_EquipmentLookupDetailBody> {
  _EquipmentDetailTab _selectedTab = _EquipmentDetailTab.jobs;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<EquipmentLookupDetailViewModel>();
    final coordinator = context.read<AppCoordinator>();
    final equipment = viewModel.equipment;
    return LookupDetailScaffold(
      title: equipment?.equipmentName.isNotEmpty == true
          ? equipment!.equipmentName
          : '장비 상세',
      subtitle: equipment == null ? '' : 'id ${equipment.equipmentId}',
      onBack: coordinator.didTapBackFromLookupDetail,
      actions: [
        Button(onPressed: null, child: const Text('고치기')),
        const SizedBox(width: 8),
        Button(onPressed: null, child: const Text('지우기')),
      ],
      body: _body(context, viewModel, coordinator),
    );
  }

  Widget _body(
    BuildContext context,
    EquipmentLookupDetailViewModel viewModel,
    AppCoordinator coordinator,
  ) {
    if (viewModel.isLoading && viewModel.equipment == null) {
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
    final equipment = viewModel.equipment;
    if (equipment == null) {
      return const InfoBar(
        title: Text('장비 없음'),
        severity: InfoBarSeverity.warning,
      );
    }
    return ListView(
      children: [
        PassContextBar.entries(
          entries: [
            ('장비 코드', equipment.equipmentCode),
            ('쓰인 작업', '${equipment.jobCount}건'),
            ('기록한 에셋', '${equipment.assetCount}건'),
            ('숨김', equipment.isInactive ? '숨김 — 고르는 목록에서 빠짐' : '아니오'),
          ],
        ),
        if (equipment.description.isNotEmpty) ...[
          const LookupDetailSectionTitle('비고'),
          Text(equipment.description),
        ],
        const SizedBox(height: 12),
        _EquipmentDetailTabsBar(
          selectedTab: _selectedTab,
          jobCount: equipment.jobCount,
          assetCount: equipment.assetCount,
          onSelectTab: (tab) => setState(() => _selectedTab = tab),
        ),
        const SizedBox(height: 12),
        if (_selectedTab == _EquipmentDetailTab.jobs)
          LookupDetailPlainTable(
            headers: const ['공통키', '이음부', '작업일시'],
            emptyText: '예시 데이터에 없음',
            rows: [
              for (final job in viewModel.jobs)
                [
                  job.commonKey,
                  job.jointNo,
                  DashboardFormatters.dateTime(job.workedAt),
                ],
            ],
            onRowTap: (index) {
              coordinator.didTapOpenWorkDetail(
                context,
                jobId: viewModel.jobs[index].jobId,
              );
            },
          )
        else
          LookupDetailPlainTable(
            headers: const ['번호', '종류', '파일'],
            emptyText: '기록한 에셋이 없습니다',
            rows: [
              for (final asset in viewModel.assets)
                [
                  asset.assetId,
                  AssetLookupKindOption.labelOf(asset.kindCode),
                  asset.fileName,
                ],
            ],
            onRowTap: (index) {
              coordinator.didTapOpenAssetDetail(
                viewModel.assets[index].assetId,
              );
            },
          ),
      ],
    );
  }
}

class _EquipmentDetailTabsBar extends StatelessWidget {
  const _EquipmentDetailTabsBar({
    required this.selectedTab,
    required this.jobCount,
    required this.assetCount,
    required this.onSelectTab,
  });

  final _EquipmentDetailTab selectedTab;
  final int jobCount;
  final int assetCount;
  final ValueChanged<_EquipmentDetailTab> onSelectTab;

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
            _tab(_EquipmentDetailTab.jobs, '쓰인 작업 $jobCount'),
            _tab(_EquipmentDetailTab.assets, '기록한 에셋 $assetCount'),
          ],
        ),
      ),
    );
  }

  Widget _tab(_EquipmentDetailTab tab, String label) {
    return Transform.translate(
      offset: const Offset(0, 1),
      child: _EquipmentDetailTabItem(
        label: label,
        isSelected: tab == selectedTab,
        onPressed: () => onSelectTab(tab),
      ),
    );
  }
}

class _EquipmentDetailTabItem extends StatelessWidget {
  const _EquipmentDetailTabItem({
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
