import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/asset_lookup_kind.dart';
import '../../../domain/entities/asset_lookup_row.dart';
import '../../../domain/entities/work_history_item.dart';
import '../../core/di/locator.dart';
import '../../core/formatters/dashboard_formatters.dart';
import '../../core/widgets/catalog_lookup_table.dart';
import '../../core/widgets/lookup_search_field.dart';
import 'asset_lookup_view_model.dart';

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
        child: _content(viewModel),
      ),
    );
  }

  Widget _content(AssetLookupViewModel viewModel) {
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
      actionLabel: '업로드',
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
              hintText: '부분 일치',
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
      body: _AssetTable(viewModel: viewModel),
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

class _AssetTable extends StatefulWidget {
  const _AssetTable({required this.viewModel});

  final AssetLookupViewModel viewModel;

  @override
  State<_AssetTable> createState() => _AssetTableState();
}

class _AssetTableState extends State<_AssetTable> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }
    if (_scrollController.position.extentAfter < 120) {
      widget.viewModel.didScrollNearEnd();
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    final rows = viewModel.visibleRows;
    const headers = ['번호', '종류', '파일', '장비', '크기', '길이', '상태'];
    const flexes = [8, 10, 24, 14, 10, 8, 12];
    final isJobScoped = viewModel.jobId.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _header(headers, flexes),
        if (rows.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: InfoBar(
              title: Text('조건에 맞는 에셋이 없습니다'),
              severity: InfoBarSeverity.warning,
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: rows.length + 1,
              itemBuilder: (context, index) {
                if (index == rows.length) {
                  if (!viewModel.isLoadingMore) {
                    return const SizedBox(height: 8);
                  }
                  return const Padding(
                    padding: EdgeInsets.all(12),
                    child: Center(child: ProgressRing(strokeWidth: 2)),
                  );
                }
                final row = rows[index];
                return _cells([
                  row.assetId,
                  AssetLookupKindOption.labelOf(row.kindCode),
                  row.fileName,
                  viewModel.equipmentNameOf(row.equipmentId),
                  DashboardFormatters.byteSize(row.sizeBytes),
                  DashboardFormatters.durationFromNs(row.durationNs),
                  assetStatusText(
                    row,
                    passLabel: viewModel.passLabelOf(row),
                    isJobScoped: isJobScoped,
                  ),
                ], flexes);
              },
            ),
          ),
      ],
    );
  }

  Widget _header(List<String> headers, List<int> flexes) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Color(0xFF32363C),
        border: Border(bottom: BorderSide(color: Color(0xFF3E424A))),
      ),
      child: _cells(headers, flexes, isHeader: true),
    );
  }

  Widget _cells(List<String> cells, List<int> flexes, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          for (var index = 0; index < cells.length; index++)
            Expanded(
              flex: flexes[index],
              child: Text(
                cells[index].isEmpty ? '—' : cells[index],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isHeader ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

String _jobLabel(WorkHistoryItem job) {
  final joint = job.jointNo.isEmpty ? '' : ' · ${job.jointNo}';
  return '${job.commonKey}$joint · ${DashboardFormatters.dateTime(job.workedAt)}';
}
