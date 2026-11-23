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
    final visibleIds = [
      for (final row in viewModel.visibleRows)
        if (row.assetId.isNotEmpty) row.assetId,
    ];
    final selectedVisibleCount = visibleIds.where(viewModel.isSelected).length;
    final bool? allVisibleChecked = visibleIds.isEmpty
        ? false
        : selectedVisibleCount == 0
        ? false
        : selectedVisibleCount == visibleIds.length
        ? true
        : null;
    return CatalogLookupFrame(
      tableHeader: LookupTableHeader(
        label: '파일',
        count: viewModel.totalCount,
        actionText: '+ 업로드',
        onAction: () => _didTapUpload(context, viewModel),
        secondaryActionText: viewModel.selectedCount > 0
            ? '${viewModel.selectedCount}개 삭제'
            : null,
        onSecondaryAction: viewModel.selectedCount > 0
            ? () => _didTapDeleteSelected(context, viewModel)
            : null,
      ),
      filters: const [AssetLookupFilters()],
      body: CatalogLookupTable(
        headers: const ['번호', '종류', '파일', '장비', '업로드', '크기', '길이', '상태'],
        columnFlexes: const [7, 9, 18, 10, 14, 8, 7, 10],
        actionsHeader: '동작',
        actionsFlex: 10,
        leadingFlex: 3,
        leadingHeader: Align(
          alignment: Alignment.centerLeft,
          child: Checkbox(
            checked: allVisibleChecked,
            onChanged: visibleIds.isEmpty
                ? null
                : (value) => viewModel.didSetVisibleSelection(value == true),
          ),
        ),
        leadingBuilder: (context, index) {
          final row = viewModel.visibleRows[index];
          return Align(
            alignment: Alignment.centerLeft,
            child: Checkbox(
              checked: viewModel.isSelected(row.assetId),
              onChanged: row.assetId.isEmpty
                  ? null
                  : (value) => viewModel.didToggleSelected(row.assetId, value),
            ),
          );
        },
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
              DashboardFormatters.dateTime(row.collectedAt),
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

Future<void> _didTapDeleteSelected(
  BuildContext context,
  AssetLookupViewModel viewModel,
) async {
  final count = viewModel.selectedCount;
  if (count < 1) {
    return;
  }
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return ContentDialog(
        title: Text(
          '선택한 파일 $count개를 지울까요?',
          style: const TextStyle(fontSize: 16),
        ),
        content: const Text(
          '각 파일마다 삭제를 시도합니다. 지울 수 없는 파일은 건너뛰고, '
          '지울 수 있는 파일만 지웁니다. 되돌릴 수 없습니다.',
        ),
        actions: [
          Button(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('지우기'),
          ),
        ],
      );
    },
  );
  if (confirmed != true || !context.mounted) {
    return;
  }
  final result = await viewModel.deleteSelectedAssets();
  if (!context.mounted) {
    return;
  }
  await _showBulkDeleteInfoBar(context, result);
}

Future<void> _showBulkDeleteInfoBar(
  BuildContext context,
  ({int succeeded, List<String> failureNotes}) result,
) async {
  final summaryParts = <String>[
    '지움 ${result.succeeded}건',
    if (result.failureNotes.isNotEmpty) '건너뜀 ${result.failureNotes.length}건',
  ];
  await _showNotesDialog(
    context,
    title: '선택 삭제',
    summary: summaryParts.join(' · '),
    notes: result.failureNotes,
  );
}

Future<void> _showNotesDialog(
  BuildContext context, {
  required String title,
  required String summary,
  required List<String> notes,
}) async {
  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return ContentDialog(
        constraints: const BoxConstraints(maxWidth: 480, maxHeight: 560),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(summary),
            if (notes.isNotEmpty) ...[
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 280),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (var i = 0; i < notes.length; i++) ...[
                        if (i > 0) const SizedBox(height: 6),
                        Text(notes[i]),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('확인'),
          ),
        ],
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
  final warningCount = result.warningNotes.length;
  final failureCount = result.failureNotes.length;
  final notes = [...result.warningNotes, ...result.failureNotes];
  if (notes.isEmpty) {
    return;
  }
  final summaryParts = <String>[
    if (warningCount > 0) '경고 $warningCount건',
    if (failureCount > 0) '실패 $failureCount건',
  ];
  await _showNotesDialog(
    context,
    title: '올리기 완료',
    summary: summaryParts.join(' · '),
    notes: notes,
  );
}
