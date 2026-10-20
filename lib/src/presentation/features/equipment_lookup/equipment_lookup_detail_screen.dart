import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/asset_lookup_kind.dart';
import '../../core/di/locator.dart';
import '../../core/formatters/dashboard_formatters.dart';
import '../../core/widgets/lookup_detail_scaffold.dart';
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

class _EquipmentLookupDetailBody extends StatelessWidget {
  const _EquipmentLookupDetailBody();

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
        LookupDetailKvGrid(
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
        const LookupDetailSectionTitle('쓰인 작업'),
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
        ),
        const LookupDetailSectionTitle('기록한 에셋'),
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
            coordinator.didTapOpenAssetDetail(viewModel.assets[index].assetId);
          },
        ),
      ],
    );
  }
}
