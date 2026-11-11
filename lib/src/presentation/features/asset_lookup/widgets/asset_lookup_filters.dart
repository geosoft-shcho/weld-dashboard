import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../../domain/entities/asset_lookup_kind.dart';
import '../../../../domain/entities/asset_lookup_row.dart';
import '../../../../domain/entities/work_history_item.dart';
import '../../../core/formatters/dashboard_formatters.dart';
import '../../../core/widgets/lookup_search_field.dart';
import '../asset_lookup_view_model.dart';

/// 에셋 목록 [CatalogLookupFrame]용 필터 칸.
class AssetLookupFilters extends StatelessWidget {
  const AssetLookupFilters({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AssetLookupViewModel>();
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
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.end,
      children: [
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
          label: '후처리',
          child: ComboBox<String>(
            value: viewModel.postprocessStatusCode,
            items: [
              for (final status in AssetPostprocessStatusOption.statuses)
                ComboBoxItem(value: status.code, child: Text(status.label)),
            ],
            onChanged: (value) {
              if (value != null) {
                viewModel.didSelectPostprocessStatus(value);
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
          child: Button(
            onPressed: () => _didTapPickJob(context, viewModel),
            child: Text(_selectedJobLabel(viewModel, jobId)),
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

String _selectedJobLabel(AssetLookupViewModel viewModel, String jobId) {
  if (jobId.isEmpty) {
    return '전체';
  }
  for (final job in viewModel.jobs) {
    if (job.jobId == jobId) {
      return _jobLabel(job);
    }
  }
  return jobId;
}

String _jobLabel(WorkHistoryItem job) {
  final joint = job.jointNo.isEmpty ? '' : ' · ${job.jointNo}';
  return '${job.commonKey}$joint · ${DashboardFormatters.dateTime(job.workedAt)}';
}

Future<void> _didTapPickJob(
  BuildContext context,
  AssetLookupViewModel viewModel,
) async {
  var loadingMore = false;
  final selected = await showDialog<String>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return ContentDialog(
            title: const Text('작업 선택', style: TextStyle(fontSize: 16)),
            constraints: const BoxConstraints(maxWidth: 520, maxHeight: 560),
            content: SizedBox(
              width: 480,
              height: 360,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        ListTile.selectable(
                          selected: viewModel.jobId.isEmpty,
                          title: const Text('전체'),
                          onPressed: () => Navigator.of(dialogContext).pop(''),
                        ),
                        for (final job in viewModel.jobs)
                          ListTile.selectable(
                            selected: job.jobId == viewModel.jobId,
                            title: Text(_jobLabel(job)),
                            onPressed: () =>
                                Navigator.of(dialogContext).pop(job.jobId),
                          ),
                      ],
                    ),
                  ),
                  if (viewModel.doesHaveMoreJobs) ...[
                    const SizedBox(height: 8),
                    Button(
                      onPressed: loadingMore
                          ? null
                          : () async {
                              setDialogState(() => loadingMore = true);
                              await viewModel.didTapLoadMoreJobs();
                              if (context.mounted) {
                                setDialogState(() => loadingMore = false);
                              }
                            },
                      child: Text(
                        loadingMore
                            ? '불러오는 중…'
                            : '더 보기 (${viewModel.jobsLoadedPage}/${viewModel.jobsTotalPages})',
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              Button(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('닫기'),
              ),
            ],
          );
        },
      );
    },
  );
  if (selected == null || !context.mounted) {
    return;
  }
  await viewModel.didSelectJob(selected);
}
