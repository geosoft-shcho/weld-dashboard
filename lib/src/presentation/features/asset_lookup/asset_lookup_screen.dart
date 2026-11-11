import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/asset_lookup_kind.dart';
import '../../core/di/locator.dart';
import '../../core/formatters/dashboard_formatters.dart';
import '../../core/widgets/catalog_lookup_table.dart';
import '../../core/widgets/query_failure_pane.dart';
import '../../navigation/app_coordinator.dart';
import 'asset_lookup_view_model.dart';
import 'asset_upload_dialog.dart';
import 'widgets/asset_lookup_filters.dart';

class AssetLookupScreen extends StatelessWidget {
  const AssetLookupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator<AssetLookupViewModel>()..load(),
      child: const _AssetLookupBody(),
    );
  }
}

class _AssetLookupBody extends StatelessWidget {
  const _AssetLookupBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AssetLookupViewModel>();
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      content: Padding(
        padding: const EdgeInsets.all(16),
        child: _content(context, viewModel),
      ),
    );
  }

  Widget _content(BuildContext context, AssetLookupViewModel viewModel) {
    if (!viewModel.hasLoaded) {
      if (viewModel.isLoading) {
        return const Center(child: ProgressRing());
      }
      if (viewModel.hasError) {
        return QueryFailurePane(
          title: '조회 실패',
          message: viewModel.errorMessage,
          onRetry: viewModel.load,
        );
      }
    }
    return CatalogLookupFrame(
      tableHeader: LookupTableHeader(
        label: '에셋',
        count: viewModel.totalCount,
        actionText: '+ 올리기',
        onAction: () => _didTapUpload(context, viewModel),
      ),
      filters: const [AssetLookupFilters()],
      body: CatalogLookupTable(
        headers: const ['번호', '종류', '파일', '장비', '크기', '길이', '상태'],
        columnFlexes: const [8, 10, 24, 14, 10, 8, 12],
        emptyTitle: '조건에 맞는 에셋이 없습니다',
        isLoadingMore: viewModel.isLoadingMore,
        onNearEnd: viewModel.didScrollNearEnd,
        rows: [
          for (final row in viewModel.visibleRows)
            [
              row.assetId,
              AssetLookupKindOption.labelOf(row.kindCode),
              row.fileName,
              viewModel.equipmentNameOf(row.equipmentId),
              DashboardFormatters.byteSize(row.sizeBytes),
              DashboardFormatters.durationFromNs(row.durationNs),
              assetStatusText(
                row,
                passLabel: viewModel.passLabelOf(row),
                isJobScoped: viewModel.jobId.isNotEmpty,
              ),
            ],
        ],
        onRowTap: (index) {
          final row = viewModel.visibleRows[index];
          if (row.assetId.isEmpty) {
            return;
          }
          context.read<AppCoordinator>().didTapOpenAssetDetail(row.assetId);
        },
      ),
    );
  }
}

Future<void> _didTapUpload(
  BuildContext context,
  AssetLookupViewModel viewModel,
) async {
  final result = await showAssetUploadDialog(
    context,
    jobs: viewModel.jobs,
    equipment: viewModel.equipment,
    initialJobId: viewModel.jobId,
    initialPassId: viewModel.passId,
    lockJob: false,
    loadFormats: viewModel.loadUploadFormats,
    pickFiles: viewModel.pickUploadFiles,
    uploadQueue: viewModel.uploadAssetQueue,
    retryPostprocess: viewModel.retryPostprocess,
  );
  if (result == null || !result.hasSuccess || !context.mounted) {
    return;
  }
  await viewModel.load();
  if (!context.mounted) {
    return;
  }
  final notes = [...result.warningNotes, ...result.failureNotes];
  if (notes.isEmpty) {
    return;
  }
  await displayInfoBar(
    context,
    builder: (context, close) {
      return InfoBar(
        title: const Text('올리기 완료'),
        content: Text(notes.join('\n')),
        severity: InfoBarSeverity.warning,
        onClose: close,
      );
    },
  );
}
