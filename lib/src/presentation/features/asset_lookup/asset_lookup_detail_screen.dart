import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/asset_lookup_kind.dart';
import '../../../domain/entities/asset_lookup_row.dart';
import '../../core/di/locator.dart';
import '../../core/formatters/dashboard_formatters.dart';
import '../../core/themes/app_theme.dart';
import '../../core/widgets/lookup_detail_scaffold.dart';
import '../../navigation/app_coordinator.dart';
import 'asset_lookup_detail_view_model.dart';

class AssetLookupDetailScreen extends StatelessWidget {
  const AssetLookupDetailScreen({super.key, required this.assetId});

  final String assetId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          locator<AssetLookupDetailViewModel>(param1: assetId)..load(),
      child: const _AssetLookupDetailBody(),
    );
  }
}

class _AssetLookupDetailBody extends StatelessWidget {
  const _AssetLookupDetailBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AssetLookupDetailViewModel>();
    final coordinator = context.read<AppCoordinator>();
    final asset = viewModel.asset;
    final kindLabel = asset == null
        ? '에셋'
        : AssetLookupKindOption.labelOf(asset.kindCode);
    return LookupDetailScaffold(
      title: asset == null ? '에셋 상세' : '$kindLabel ${asset.assetId}',
      subtitle: '',
      onBack: coordinator.didTapBackFromLookupDetail,
      actions: [Button(onPressed: null, child: const Text('지우기'))],
      body: _body(context, viewModel, coordinator),
    );
  }

  Widget _body(
    BuildContext context,
    AssetLookupDetailViewModel viewModel,
    AppCoordinator coordinator,
  ) {
    if (viewModel.isLoading && viewModel.asset == null) {
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
    final asset = viewModel.asset;
    if (asset == null) {
      return const InfoBar(
        title: Text('에셋 없음'),
        severity: InfoBarSeverity.warning,
      );
    }
    return ListView(
      children: [
        Text(
          asset.fileName,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        _previewPlaceholder(asset),
        const LookupDetailSectionTitle('정보'),
        LookupDetailKvGrid(
          entries: [
            ('장비', viewModel.equipmentNameOf(asset.equipmentId)),
            for (final field in asset.displayFields)
              (field.label, field.value),
            ('크기', DashboardFormatters.byteSize(asset.sizeBytes)),
            (
              '길이',
              DashboardFormatters.durationFromNs(asset.durationNs),
            ),
            ('파생', '${asset.childCount}개'),
          ],
        ),
        if (asset.propertiesJson.isNotEmpty)
          Expander(
            header: const Text('원래 properties 보기'),
            content: SelectableText(
              asset.propertiesJson,
              style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
            ),
          ),
        const SizedBox(height: 8),
        if (asset.provenanceSummary.isNotEmpty)
          InfoBar(
            title: const Text('만든 경위'),
            content: Text(
              '${asset.provenanceSummary}'
              '${asset.parentAssetId.isEmpty ? '' : '\n부모 ${asset.parentAssetId}'}',
            ),
            severity: InfoBarSeverity.info,
          )
        else
          Text(
            '원본 업로드(만든 경위 없음)',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.55),
            ),
          ),
        LookupDetailSectionTitle(
          '붙은 작업',
          trailing: viewModel.jobs.isEmpty
              ? Button(onPressed: null, child: const Text('작업에 붙이기'))
              : null,
        ),
        LookupDetailPlainTable(
          headers: const ['공통키', '이음부', '작업일시', '패스'],
          emptyText: '작업 미지정',
          rows: [
            for (final job in viewModel.jobs)
              [
                job.commonKey,
                job.jointNo,
                DashboardFormatters.dateTime(job.workedAt),
                '—',
              ],
          ],
          onRowTap: (index) {
            coordinator.didTapOpenWorkDetail(
              context,
              jobId: viewModel.jobs[index].jobId,
            );
          },
        ),
      ],
    );
  }

  Widget _previewPlaceholder(AssetLookupRow asset) {
    final label = switch (asset.kindCode) {
      'video' => '영상 미리 보기',
      'audio' => '음성 미리 보기',
      'timeseries' => '시계열 미리 보기',
      'pose' => '포즈 미리 보기',
      'image' => '이미지 미리 보기',
      'document' => '문서 미리 보기',
      'pointCloud' => '깊이 — 브라우저 재생 불가',
      _ => '미리 보기 없음',
    };
    return Container(
      height: 150,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppTheme.SURFACE_RAISED,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFF3E424A)),
      ),
      child: Text(
        label,
        style: const TextStyle(color: AppTheme.STATUS_OFF),
      ),
    );
  }
}
