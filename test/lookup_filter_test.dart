import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/domain/entities/work_history_catalog.dart';
import 'package:weld_dashboard/src/domain/entities/work_history_page.dart';
import 'package:weld_dashboard/src/domain/entities/work_history_project_filter.dart';
import 'package:weld_dashboard/src/domain/entities/work_history_query.dart';
import 'package:weld_dashboard/src/domain/entities/worker.dart';
import 'package:weld_dashboard/src/domain/entities/worker_kind.dart';
import 'package:weld_dashboard/src/domain/repositories/work_history_repository.dart';
import 'package:weld_dashboard/src/domain/use_cases/load_work_history_masters_use_case.dart';
import 'package:weld_dashboard/src/presentation/features/project_lookup/project_lookup_view_model.dart';
import 'package:weld_dashboard/src/presentation/features/worker_lookup/worker_lookup_view_model.dart';

void main() {
  test('project lookup filters number, site, empty jobs, and summarizes units', () async {
    final viewModel = ProjectLookupViewModel(
      loadWorkHistoryMastersUseCase: LoadWorkHistoryMastersUseCase(
        _MastersRepository(),
      ),
    );
    await viewModel.load();
    expect(viewModel.visibleProjects, hasLength(2));

    viewModel.didChangeQueryText('부산');
    expect(viewModel.visibleProjects.single.projectNo, 'TP129');
    expect(
      projectUnitsText(viewModel.visibleProjects.single),
      '1호기 · 1품목',
    );
    expect(
      projectSiteCustomer(viewModel.visibleProjects.single),
      '부산 · HD',
    );

    viewModel.didChangeQueryText('');
    viewModel.didToggleEmptyJobsOnly(true);
    expect(viewModel.visibleProjects.single.projectNo, 'DEMO');
    expect(viewModel.visibleProjects.single.jobCount, 0);
  });

  test('worker lookup filters name, kind, and inactive', () async {
    final viewModel = WorkerLookupViewModel(
      loadWorkHistoryMastersUseCase: LoadWorkHistoryMastersUseCase(
        _MastersRepository(),
      ),
    );
    await viewModel.load();
    expect(viewModel.visibleWorkers, hasLength(3));

    viewModel.didSelectKind(WorkerKindFilter.general);
    expect(viewModel.visibleWorkers.single.workerName, '박일반');
    viewModel.didSelectKind(WorkerKindFilter.unknown);
    expect(viewModel.visibleWorkers.single.workerName, '한신입');
    viewModel.didSelectKind(WorkerKindFilter.all);
    viewModel.didChangeQueryText('김');
    expect(viewModel.visibleWorkers.single.workerName, '김명장');
    expect(viewModel.visibleWorkers.single.jobCount, 10);

    viewModel.didChangeQueryText('');
    viewModel.didToggleIncludeInactive(true);
    expect(
      viewModel.visibleWorkers.map((worker) => worker.workerName),
      contains('퇴사'),
    );
  });
}

class _MastersRepository implements WorkHistoryRepository {
  @override
  Future<WorkHistoryCatalog> loadMasters() async {
    return WorkHistoryCatalog(
      items: const [],
      projects: [
        WorkHistoryProjectFilter(
          projectNo: 'TP129',
          projectName: '컨테이너',
          siteName: '부산',
          customer: 'HD',
          jobCount: 5,
          units: [
            WorkHistoryUnitFilter(
              unitNo: '01',
              itemCodes: const ['LD-A'],
              items: [
                WorkHistoryItemFilter(
                  itemCode: 'LD-A',
                  itemName: 'LEG A',
                  jointNos: const [],
                ),
              ],
            ),
          ],
        ),
        const WorkHistoryProjectFilter(
          projectNo: 'DEMO',
          projectName: '데모',
          units: [],
        ),
      ],
      workers: const [
        Worker(
          workerId: '1',
          workerName: '김명장',
          workerKind: WorkerKind.master,
          jobCount: 10,
        ),
        Worker(
          workerId: '2',
          workerName: '박일반',
          workerKind: WorkerKind.general,
          jobCount: 3,
        ),
        Worker(workerId: '3', workerName: '한신입', jobCount: 1),
        Worker(
          workerId: '4',
          workerName: '퇴사',
          workerKind: WorkerKind.general,
          isInactive: true,
          jobCount: 0,
        ),
      ],
      equipments: const [],
    );
  }

  @override
  Future<WorkHistoryCatalog> loadCatalog({WorkHistoryQuery? query}) {
    throw UnimplementedError();
  }

  @override
  Future<WorkHistoryPage> listPage({
    required WorkHistoryQuery query,
    required int pageSize,
    required String pageToken,
  }) {
    throw UnimplementedError();
  }
}
