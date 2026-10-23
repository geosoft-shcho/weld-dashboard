import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/asset_lookup_kind.dart';
import '../../../domain/entities/asset_lookup_row.dart';
import '../../../domain/entities/work_history_item.dart';
import '../../core/di/locator.dart';
import '../../core/formatters/dashboard_formatters.dart';
import '../../core/widgets/catalog_lookup_table.dart';
import '../../core/widgets/lookup_search_field.dart';
import '../../navigation/app_coordinator.dart';
import 'asset_lookup_view_model.dart';
import 'asset_upload_dialog.dart';

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
    if (viewModel.isLoading &&
        viewModel.visibleRows.isEmpty &&
        !viewModel.hasError) {
      return const Center(child: ProgressRing());
    }
    if (viewModel.hasError && viewModel.visibleRows.isEmpty) {
      return InfoBar(
        title: const Text('조회 실패'),
        content: Text(viewModel.errorMessage),
        action: Button(onPressed: viewModel.load, child: const Text('재시도')),
        severity: InfoBarSeverity.error,
      );
    }
    final jobId = viewModel.jobs.any((job) => job.jobId == viewModel.jobId)
        ? viewModel.jobId
        : '';
    final passId = _selectedPassId(viewModel);
    final equipmentId =
        viewModel.equipment.any(
          (item) => item.equipmentId == viewModel.equipmentId,
        )
        ? viewModel.equipmentId
        : '';
    return CatalogLookupFrame(
      tableHeader: LookupTableHeader(
        label: '에셋',
        count: viewModel.totalCount,
        actionText: '+ 올리기',
        onAction: () => _didTapUpload(context, viewModel),
      ),
      filters: [
        InfoLabel(
          label: '종류',
          child: ComboBox<String>(
            value: viewModel.kindCode,
            items: [
              for (final kind in AssetLookupKindOption.kinds)
                ComboBoxItem(value: kind.code, child: Text(kind.label)),
            ],
            onChanged: (value) {
              if (value != null) {
                viewModel.didSelectKind(value);
              }
            },
          ),
        ),
        InfoLabel(
          label: '파일 이름',
          child: SizedBox(
            width: 200,
            child: LookupSearchField(
              value: viewModel.fileNameText,
              hintText: '파일 이름 · 원본 위치 · 번호',
              onChanged: viewModel.didChangeFileName,
            ),
          ),
        ),
        InfoLabel(
          label: '장비',
          child: ComboBox<String>(
            value: equipmentId,
            items: [
              const ComboBoxItem(value: '', child: Text('전체')),
              for (final item in viewModel.equipment)
                ComboBoxItem(
                  value: item.equipmentId,
                  child: Text(
                    item.equipmentName.isEmpty
                        ? item.equipmentCode
                        : item.equipmentName,
                  ),
                ),
            ],
            onChanged: (value) {
              if (value != null) {
                viewModel.didSelectEquipment(value);
              }
            },
          ),
        ),
        InfoLabel(
          label: '작업',
          child: ComboBox<String>(
            value: jobId,
            items: [
              const ComboBoxItem(value: '', child: Text('전체')),
              for (final job in viewModel.jobs)
                ComboBoxItem(value: job.jobId, child: Text(_jobLabel(job))),
            ],
            onChanged: (value) {
              if (value != null) {
                viewModel.didSelectJob(value);
              }
            },
          ),
        ),
        if (viewModel.doesHaveMoreJobs)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Button(
              onPressed: viewModel.didTapLoadMoreJobs,
              child: const Text('작업 더 보기'),
            ),
          ),
        InfoLabel(
          label: '패스',
          child: ComboBox<String>(
            value: passId,
            items: [
              const ComboBoxItem(value: '', child: Text('전체')),
              const ComboBoxItem(
                value: jobCommonPassToken,
                child: Text('작업 공용'),
              ),
              for (final pass in viewModel.passes)
                ComboBoxItem(
                  value: pass.passId,
                  child: Text('${pass.passNo}패스'),
                ),
            ],
            onChanged: jobId.isEmpty
                ? null
                : (value) {
                    if (value != null) {
                      viewModel.didSelectPass(value);
                    }
                  },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Checkbox(
            checked: viewModel.unattachedOnly,
            content: const Text('작업 미지정만'),
            onChanged: jobId.isNotEmpty
                ? null
                : (value) {
                    if (value != null) {
                      viewModel.didToggleUnattachedOnly(value);
                    }
                  },
          ),
        ),
      ],
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

String _selectedPassId(AssetLookupViewModel viewModel) {
  if (viewModel.passId == jobCommonPassToken) {
    return jobCommonPassToken;
  }
  if (viewModel.passes.any((pass) => pass.passId == viewModel.passId)) {
    return viewModel.passId;
  }
  return '';
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
    pickFile: viewModel.pickUploadFile,
    uploadFile:
        ({
          required jobId,
          required passId,
          required equipmentId,
          required timeOrigin,
          required file,
        }) => viewModel.uploadAssetFile(
          jobId: jobId,
          passId: passId,
          equipmentId: equipmentId,
          timeOrigin: timeOrigin,
          file: file,
        ),
  );
  if (result == null || !context.mounted) {
    return;
  }
  await viewModel.load();
  if (!context.mounted) {
    return;
  }
  final notes = [
    ...result.warnings,
    for (final id in result.duplicateAssetIds) '같은 내용의 에셋 $id가 이미 있습니다',
  ];
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

String _jobLabel(WorkHistoryItem job) {
  final joint = job.jointNo.isEmpty ? '' : ' · ${job.jointNo}';
  return '${job.commonKey}$joint · ${DashboardFormatters.dateTime(job.workedAt)}';
}
