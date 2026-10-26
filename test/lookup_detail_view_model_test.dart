import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/domain/entities/asset_lookup_row.dart';
import 'package:weld_dashboard/src/domain/entities/equipment.dart';
import 'package:weld_dashboard/src/domain/entities/job_draft.dart';
import 'package:weld_dashboard/src/domain/entities/lookup_page.dart';
import 'package:weld_dashboard/src/domain/entities/project_item_draft.dart';
import 'package:weld_dashboard/src/domain/entities/work_history_catalog.dart';
import 'package:weld_dashboard/src/domain/entities/work_history_item.dart';
import 'package:weld_dashboard/src/domain/entities/work_history_page.dart';
import 'package:weld_dashboard/src/domain/entities/work_history_project_filter.dart';
import 'package:weld_dashboard/src/domain/entities/work_history_query.dart';
import 'package:weld_dashboard/src/domain/entities/worker.dart';
import 'package:weld_dashboard/src/domain/repositories/asset_lookup_repository.dart';
import 'package:weld_dashboard/src/domain/repositories/equipment_lookup_repository.dart';
import 'package:weld_dashboard/src/domain/repositories/project_lookup_repository.dart';
import 'package:weld_dashboard/src/domain/repositories/work_history_repository.dart';
import 'package:weld_dashboard/src/domain/repositories/worker_lookup_repository.dart';
import 'package:weld_dashboard/src/domain/use_cases/create_project_items_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/delete_project_item_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/delete_project_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/get_equipment_lookup_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/get_project_lookup_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/get_worker_lookup_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/list_asset_lookup_page_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/list_work_history_page_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/update_project_item_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/update_project_use_case.dart';
import 'package:weld_dashboard/src/presentation/features/equipment_lookup/equipment_lookup_detail_view_model.dart';
import 'package:weld_dashboard/src/presentation/features/project_lookup/project_lookup_detail_view_model.dart';
import 'package:weld_dashboard/src/presentation/features/worker_lookup/worker_lookup_detail_view_model.dart';

void main() {
  test('공사 상세는 단건 조회만으로 공사와 작업 수를 불러온다', () async {
    final repository = _FakeProjectLookupRepository(
      project: const WorkHistoryProjectFilter(
        projectId: '7',
        projectNo: 'TP129',
        projectName: '공사',
        siteName: '현장',
        customer: '발주처',
        jobCount: 3,
        units: [
          WorkHistoryUnitFilter(
            unitNo: '05',
            itemCodes: ['LD-A'],
            items: [
              WorkHistoryItemFilter(
                itemCode: 'LD-A',
                itemName: '품목',
                projectItemId: '11',
                jointNos: ['J-1'],
              ),
            ],
          ),
        ],
      ),
    );
    final viewModel = ProjectLookupDetailViewModel(
      projectId: '7',
      getProjectLookupUseCase: GetProjectLookupUseCase(repository),
      updateProjectUseCase: UpdateProjectUseCase(repository),
      deleteProjectUseCase: DeleteProjectUseCase(repository),
      createProjectItemsUseCase: CreateProjectItemsUseCase(repository),
      updateProjectItemUseCase: UpdateProjectItemUseCase(repository),
      deleteProjectItemUseCase: DeleteProjectItemUseCase(repository),
    );

    await viewModel.load();

    expect(repository.getProjectCallCount, 1);
    expect(repository.listProjectsCallCount, 0);
    expect(viewModel.hasError, isFalse);
    expect(viewModel.project?.projectNo, 'TP129');
    expect(viewModel.project?.jobCount, 3);
    expect(viewModel.project?.units.single.items.single.itemCode, 'LD-A');
  });

  test('공사 상세는 없는 공사를 기존 문구로 알린다', () async {
    final repository = _FakeProjectLookupRepository(project: null);
    final viewModel = ProjectLookupDetailViewModel(
      projectId: '404',
      getProjectLookupUseCase: GetProjectLookupUseCase(repository),
      updateProjectUseCase: UpdateProjectUseCase(repository),
      deleteProjectUseCase: DeleteProjectUseCase(repository),
      createProjectItemsUseCase: CreateProjectItemsUseCase(repository),
      updateProjectItemUseCase: UpdateProjectItemUseCase(repository),
      deleteProjectItemUseCase: DeleteProjectItemUseCase(repository),
    );

    await viewModel.load();

    expect(repository.getProjectCallCount, 1);
    expect(viewModel.hasError, isTrue);
    expect(viewModel.errorMessage, '공사를 찾지 못했습니다.');
    expect(viewModel.project, isNull);
  });

  test('작업자 상세는 단건 조회와 맡은 작업 목록을 불러온다', () async {
    final workerRepository = _FakeWorkerLookupRepository(
      worker: const Worker(
        workerId: '21',
        workerName: '김작업',
        employeeNo: 'E-21',
        isInactive: true,
        jobCount: 1,
      ),
    );
    final workHistoryRepository = _FakeWorkHistoryRepository(
      jobs: [_job('101')],
    );
    final viewModel = WorkerLookupDetailViewModel(
      workerId: '21',
      getWorkerLookupUseCase: GetWorkerLookupUseCase(workerRepository),
      listWorkHistoryPageUseCase: ListWorkHistoryPageUseCase(
        workHistoryRepository,
      ),
    );

    await viewModel.load();

    expect(workerRepository.getWorkerCallCount, 1);
    expect(workerRepository.listWorkersCallCount, 0);
    expect(viewModel.worker?.jobCount, 1);
    expect(viewModel.worker?.isInactive, isTrue);
    expect(viewModel.jobs.map((job) => job.jobId), ['101']);
  });

  test('장비 상세는 단건 조회와 쓰인 작업·기록한 에셋을 불러온다', () async {
    final equipmentRepository = _FakeEquipmentLookupRepository(
      equipment: const Equipment(
        equipmentId: '31',
        equipmentName: '장비 31',
        equipmentCode: 'EQ-31',
        isInactive: true,
        jobCount: 1,
        assetCount: 1,
      ),
    );
    final viewModel = EquipmentLookupDetailViewModel(
      equipmentId: '31',
      getEquipmentLookupUseCase: GetEquipmentLookupUseCase(equipmentRepository),
      listWorkHistoryPageUseCase: ListWorkHistoryPageUseCase(
        _FakeWorkHistoryRepository(jobs: [_job('102')]),
      ),
      listAssetLookupPageUseCase: ListAssetLookupPageUseCase(
        _FakeAssetLookupRepository(),
      ),
    );

    await viewModel.load();

    expect(equipmentRepository.getEquipmentCallCount, 1);
    expect(equipmentRepository.listEquipmentCallCount, 0);
    expect(viewModel.equipment?.jobCount, 1);
    expect(viewModel.equipment?.assetCount, 1);
    expect(viewModel.equipment?.isInactive, isTrue);
    expect(viewModel.jobs.map((job) => job.jobId), ['102']);
    expect(viewModel.assets.map((asset) => asset.assetId), ['501']);
  });
}

WorkHistoryItem _job(String jobId) {
  return WorkHistoryItem(
    jobId: jobId,
    commonKey: 'COMMON-$jobId',
    projectNo: 'TP129',
    unitNo: '05',
    itemCode: 'LD-A',
    itemName: '품목',
    jointNo: 'J-1',
    workerId: '21',
    workerName: '김작업',
    equipmentId: '31',
    equipmentName: '장비 31',
    workedAt: DateTime(2026, 10, 22),
    passCount: 1,
    attachmentCount: 0,
  );
}

class _FakeProjectLookupRepository implements ProjectLookupRepository {
  _FakeProjectLookupRepository({required this.project});

  final WorkHistoryProjectFilter? project;
  int getProjectCallCount = 0;
  int listProjectsCallCount = 0;

  @override
  Future<WorkHistoryProjectFilter?> getProject({
    required String projectId,
  }) async {
    getProjectCallCount++;
    return project;
  }

  @override
  Future<LookupPage<WorkHistoryProjectFilter>> listProjects({
    required String query,
    required int pageSize,
    required String pageToken,
  }) async {
    listProjectsCallCount++;
    throw StateError('상세에서 목록을 조회하면 안 됩니다.');
  }

  @override
  Future<String> createProject({
    required String projectNo,
    required String projectName,
    required String siteName,
    required String customer,
  }) async {
    return '';
  }

  @override
  Future<void> createProjectItems({
    required String projectId,
    required List<ProjectItemDraft> items,
  }) async {}

  @override
  Future<void> updateProject({
    required String projectId,
    required String projectName,
    required String siteName,
    required String customer,
    required List<String> changedFields,
  }) async {}

  @override
  Future<void> deleteProject({required String projectId}) async {}

  @override
  Future<void> updateProjectItem({
    required String projectItemId,
    required String itemName,
  }) async {}

  @override
  Future<void> deleteProjectItem({required String projectItemId}) async {}
}

class _FakeWorkerLookupRepository implements WorkerLookupRepository {
  _FakeWorkerLookupRepository({required this.worker});

  final Worker? worker;
  int getWorkerCallCount = 0;
  int listWorkersCallCount = 0;

  @override
  Future<Worker?> getWorker({required String workerId}) async {
    getWorkerCallCount++;
    return worker;
  }

  @override
  Future<LookupPage<Worker>> listWorkers({
    required bool includeInactive,
    required String query,
    required int pageSize,
    required String pageToken,
  }) async {
    listWorkersCallCount++;
    throw StateError('상세에서 목록을 조회하면 안 됩니다.');
  }
}

class _FakeEquipmentLookupRepository implements EquipmentLookupRepository {
  _FakeEquipmentLookupRepository({required this.equipment});

  final Equipment? equipment;
  int getEquipmentCallCount = 0;
  int listEquipmentCallCount = 0;

  @override
  Future<Equipment?> getEquipment({required String equipmentId}) async {
    getEquipmentCallCount++;
    return equipment;
  }

  @override
  Future<LookupPage<Equipment>> listEquipment({
    required bool includeInactive,
    required String query,
    required int pageSize,
    required String pageToken,
  }) async {
    listEquipmentCallCount++;
    throw StateError('상세에서 목록을 조회하면 안 됩니다.');
  }
}

class _FakeWorkHistoryRepository implements WorkHistoryRepository {
  _FakeWorkHistoryRepository({required this.jobs});

  final List<WorkHistoryItem> jobs;

  @override
  Future<WorkHistoryCatalog> loadMasters() {
    throw StateError('호출하면 안 됩니다.');
  }

  @override
  Future<WorkHistoryPage> listPage({
    required WorkHistoryQuery query,
    required int pageSize,
    required String pageToken,
  }) async {
    return WorkHistoryPage(
      items: jobs,
      totalCount: jobs.length,
      nextPageToken: '',
    );
  }

  @override
  Future<WorkHistoryCatalog> loadCatalog({WorkHistoryQuery? query}) {
    throw StateError('호출하면 안 됩니다.');
  }

  @override
  Future<String> createJob(JobDraft draft) {
    throw StateError('호출하면 안 됩니다.');
  }
}

class _FakeAssetLookupRepository implements AssetLookupRepository {
  @override
  Future<AssetLookupPage> listAssets({
    required String kindCode,
    required String query,
    required String equipmentId,
    required bool unattachedOnly,
    String jobId = '',
    String projectId = '',
    String projectItemId = '',
    String workerId = '',
    String unitNo = '',
    String itemCode = '',
    String jointNo = '',
    int passNo = 0,
    bool sharedOnly = false,
    DateTime? startedFrom,
    DateTime? startedTo,
    required int pageSize,
    required String pageToken,
  }) async {
    return const AssetLookupPage(
      rows: [
        AssetLookupRow(
          assetId: '501',
          kindCode: 'VIDEO',
          fileName: 'clip.mp4',
          equipmentId: '31',
          sizeBytes: 10,
          durationNs: null,
          isDerived: false,
          isAttached: true,
        ),
      ],
      nextPageToken: '',
      totalCount: 1,
    );
  }

  @override
  Future<List<JobPassOption>> listJobPasses({required String jobId}) async {
    return const [];
  }

  @override
  Future<AssetLookupRow?> getAsset({required String assetId}) async {
    return null;
  }

  @override
  Future<void> updateAsset({
    required String assetId,
    required String subject,
    required String situation,
    required List<String> changedFields,
  }) async {}
}
