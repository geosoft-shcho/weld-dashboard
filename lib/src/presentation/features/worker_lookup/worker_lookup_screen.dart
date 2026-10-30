import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/worker_kind.dart';
import '../../core/di/locator.dart';
import '../../core/widgets/catalog_lookup_table.dart';
import '../../core/widgets/lookup_search_field.dart';
import '../../core/widgets/query_failure_pane.dart';
import '../../navigation/app_coordinator.dart';
import 'worker_create_dialog.dart';
import 'worker_lookup_view_model.dart';

class WorkerLookupScreen extends StatelessWidget {
  const WorkerLookupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator<WorkerLookupViewModel>()..load(),
      child: const _WorkerLookupBody(),
    );
  }
}

class _WorkerLookupBody extends StatelessWidget {
  const _WorkerLookupBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<WorkerLookupViewModel>();
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      content: Padding(
        padding: const EdgeInsets.all(16),
        child: _content(context, viewModel),
      ),
    );
  }

  Widget _content(BuildContext context, WorkerLookupViewModel viewModel) {
    if (viewModel.isLoading && viewModel.visibleWorkers.isEmpty) {
      return const Center(child: ProgressRing());
    }
    if (viewModel.hasError) {
      return QueryFailurePane(
        title: '조회 실패',
        message: viewModel.errorMessage,
        onRetry: viewModel.load,
      );
    }
    return CatalogLookupFrame(
      tableHeader: LookupTableHeader(
        label: '작업자',
        count: viewModel.totalCount,
        actionText: '+ 새 작업자',
        onAction: () => _didTapNewWorker(context, viewModel),
      ),
      filters: [
        InfoLabel(
          label: '검색',
          child: SizedBox(
            width: 220,
            child: LookupSearchField(
              value: viewModel.queryText,
              hintText: '이름 · 사번 · 비고',
              onChanged: viewModel.didChangeQueryText,
            ),
          ),
        ),
        InfoLabel(
          label: '종류',
          child: ComboBox<WorkerKindFilter>(
            value: viewModel.kind,
            items: const [
              ComboBoxItem(value: WorkerKindFilter.all, child: Text('전체')),
              ComboBoxItem(value: WorkerKindFilter.master, child: Text('명장')),
              ComboBoxItem(value: WorkerKindFilter.general, child: Text('일반')),
              ComboBoxItem(value: WorkerKindFilter.robot, child: Text('로봇')),
              ComboBoxItem(value: WorkerKindFilter.unknown, child: Text('모름')),
            ],
            onChanged: (value) {
              if (value != null) {
                viewModel.didSelectKind(value);
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Checkbox(
            checked: viewModel.includeInactive,
            content: const Text('숨긴 작업자도'),
            onChanged: (value) {
              if (value != null) {
                viewModel.didToggleIncludeInactive(value);
              }
            },
          ),
        ),
      ],
      body: CatalogLookupTable(
        headers: const ['이름', '사번', '종류', '작업'],
        columnFlexes: const [16, 12, 10, 8],
        emptyTitle: '조건에 맞는 작업자가 없습니다',
        isLoadingMore: viewModel.isLoadingMore,
        onNearEnd: viewModel.didScrollNearEnd,
        rows: [
          for (final worker in viewModel.visibleWorkers)
            [
              workerNameCell(worker),
              worker.employeeNo.isEmpty ? '—' : worker.employeeNo,
              worker.workerKind.label,
              '${worker.jobCount}건',
            ],
        ],
        onRowTap: (index) {
          final worker = viewModel.visibleWorkers[index];
          context.read<AppCoordinator>().didTapOpenWorkerDetail(
            worker.workerId,
          );
        },
      ),
    );
  }
}

Future<void> _didTapNewWorker(
  BuildContext context,
  WorkerLookupViewModel viewModel,
) async {
  final workerId = await showWorkerCreateDialog(context, viewModel);
  if (workerId == null || workerId.isEmpty || !context.mounted) {
    return;
  }
  await viewModel.load();
  if (!context.mounted) {
    return;
  }
  context.read<AppCoordinator>().didTapOpenWorkerDetail(workerId);
}
