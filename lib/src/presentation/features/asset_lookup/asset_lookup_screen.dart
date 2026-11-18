import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/asset_lookup_kind.dart';
import '../../../domain/entities/asset_lookup_row.dart';
import '../../core/browser_open_url.dart';
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
        label: '파일',
        count: viewModel.totalCount,
        actionText: '+ 업로드',
        onAction: () => _didTapUpload(context, viewModel),
      ),
      filters: const [AssetLookupFilters()],
      body: CatalogLookupTable(
        headers: const ['번호', '종류', '파일', '장비', '크기', '길이', '상태'],
        columnFlexes: const [8, 10, 22, 12, 10, 8, 12],
        actionsHeader: '동작',
        actionsFlex: 10,
        emptyTitle: '조건에 맞는 파일이 없습니다',
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
        actionsBuilder: (context, index) {
          final row = viewModel.visibleRows[index];
          return _AssetRowActions(
            row: row,
            onDownload: row.contentUrl.isEmpty
                ? null
                : () {
                    final name = row.fileName.trim().isEmpty
                        ? row.assetId
                        : row.fileName;
                    downloadBrowserUrl(row.contentUrl, fileName: name);
                  },
            onDelete: () => _didTapDelete(context, viewModel, row),
          );
        },
      ),
    );
  }
}

class _AssetRowActions extends StatelessWidget {
  const _AssetRowActions({
    required this.row,
    required this.onDownload,
    required this.onDelete,
  });

  final AssetLookupRow row;
  final VoidCallback? onDownload;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Tooltip(
          message: '내려받기',
          child: IconButton(
            icon: const Icon(FluentIcons.download, size: 14),
            onPressed: onDownload,
          ),
        ),
        Tooltip(
          message: '삭제',
          child: IconButton(
            icon: const Icon(FluentIcons.delete, size: 14),
            onPressed: row.assetId.isEmpty ? null : onDelete,
          ),
        ),
      ],
    );
  }
}

Future<void> _didTapDelete(
  BuildContext context,
  AssetLookupViewModel viewModel,
  AssetLookupRow row,
) async {
  var error = '';
  var busy = false;
  await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return ContentDialog(
            title: Text(
              '파일 ${row.assetId}를 지울까요?',
              style: const TextStyle(fontSize: 16),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('행과 저장된 파일이 지워집니다. 되돌릴 수 없습니다.'),
                if (error.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(error, style: TextStyle(color: Colors.red)),
                ],
              ],
            ),
            actions: [
              Button(
                onPressed: busy
                    ? null
                    : () => Navigator.of(dialogContext).pop(false),
                child: const Text('취소'),
              ),
              FilledButton(
                onPressed: busy
                    ? null
                    : () async {
                        setDialogState(() {
                          busy = true;
                          error = '';
                        });
                        try {
                          await viewModel.deleteAsset(assetId: row.assetId);
                          if (dialogContext.mounted) {
                            Navigator.of(dialogContext).pop(true);
                          }
                        } catch (e) {
                          setDialogState(() {
                            busy = false;
                            error = '$e';
                          });
                        }
                      },
                child: const Text('지우기'),
              ),
            ],
          );
        },
      );
    },
  );
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
