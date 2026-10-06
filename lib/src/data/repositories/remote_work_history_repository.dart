import '../../domain/entities/equipment.dart';
import '../../domain/entities/work_history_catalog.dart';
import '../../domain/entities/work_history_item.dart';
import '../../domain/entities/work_history_page.dart';
import '../../domain/entities/work_history_project_filter.dart';
import '../../domain/entities/work_history_query.dart';
import '../../domain/entities/worker.dart';
import '../../domain/repositories/work_history_repository.dart';
import '../datasources/generated/google/protobuf/timestamp.pb.dart';
import '../datasources/generated/mediatag/work/v1/work.pb.dart' as work_pb;
import '../datasources/remote/media_tag_data_source.dart';

class RemoteWorkHistoryRepository implements WorkHistoryRepository {
  RemoteWorkHistoryRepository(this._mediaTag);

  final MediaTagDataSource _mediaTag;

  static const int _maxPageSize = 200;

  @override
  Future<WorkHistoryCatalog> loadMasters() async {
    final filters = await _mediaTag.workService.listJobFilters(
      work_pb.ListJobFiltersRequest(),
    );
    return WorkHistoryCatalog(
      items: const [],
      projects: [
        for (final project in filters.projects)
          WorkHistoryProjectFilter(
            projectNo: project.project.projectNo,
            projectName: project.project.projectName,
            units: [
              for (final unit in project.units)
                WorkHistoryUnitFilter(
                  unitNo: unit.unitNo,
                  itemCodes: unit.itemCodes,
                  items: [
                    for (final item in unit.items)
                      WorkHistoryItemFilter(
                        itemCode: item.itemCode,
                        jointNos: item.jointNos,
                        joints: [
                          for (final joint in item.joints)
                            WorkHistoryJointFilter(
                              jointNo: joint.jointNo,
                              passNos: joint.passNos,
                            ),
                        ],
                      ),
                  ],
                ),
            ],
          ),
      ],
      workers: [
        for (final item in filters.workers)
          Worker(workerId: item.workerId, workerName: item.workerName),
      ],
      equipments: [
        for (final item in filters.equipment)
          Equipment(
            equipmentId: item.equipmentId,
            equipmentName: item.equipmentName,
            lineName: item.lineName,
          ),
      ],
    );
  }

  @override
  Future<WorkHistoryPage> listPage({
    required WorkHistoryQuery query,
    required int pageSize,
    required String pageToken,
  }) async {
    if (pageSize <= 0) {
      return _listAll(query);
    }
    final response = await _mediaTag.workService.listJobs(
      _request(query, pageSize: pageSize, pageToken: pageToken),
    );
    return _pageFrom(response);
  }

  @override
  Future<WorkHistoryCatalog> loadCatalog({WorkHistoryQuery? query}) async {
    final masters = await loadMasters();
    final page = await listPage(
      query: query ?? WorkHistoryQuery.initial(),
      pageSize: 0,
      pageToken: '',
    );
    return WorkHistoryCatalog(
      items: page.items,
      projects: masters.projects,
      workers: masters.workers,
      equipments: masters.equipments,
    );
  }

  Future<WorkHistoryPage> _listAll(WorkHistoryQuery query) async {
    final items = <WorkHistoryItem>[];
    var pageToken = '';
    var totalCount = 0;
    while (true) {
      final response = await _mediaTag.workService.listJobs(
        _request(query, pageSize: _maxPageSize, pageToken: pageToken),
      );
      items.addAll(_itemsFrom(response));
      totalCount = response.totalCount;
      pageToken = response.nextPageToken;
      if (pageToken.isEmpty) {
        return WorkHistoryPage(
          items: items,
          totalCount: totalCount,
          nextPageToken: '',
        );
      }
    }
  }

  work_pb.ListJobsRequest _request(
    WorkHistoryQuery query, {
    required int pageSize,
    required String pageToken,
  }) {
    final request = work_pb.ListJobsRequest(
      projectNo: query.projectNo,
      commonKey: query.commonKey.trim(),
      itemCode: query.itemCode,
      unitNo: query.unitNo,
      jointNo: query.jointNo,
      passNo: query.passNo,
      workerId: query.workerId,
      equipmentId: query.equipmentId,
      pageSize: pageSize,
      pageToken: pageToken,
    );
    final fromDate = query.fromDate;
    if (fromDate != null) {
      request.startedFrom = Timestamp.fromDateTime(_dayStart(fromDate));
    }
    final toDate = query.toDate;
    if (toDate != null) {
      request.startedTo = Timestamp.fromDateTime(
        _dayStart(toDate).add(const Duration(days: 1)),
      );
    }
    return request;
  }

  WorkHistoryPage _pageFrom(work_pb.ListJobsResponse response) {
    return WorkHistoryPage(
      items: _itemsFrom(response),
      totalCount: response.totalCount,
      nextPageToken: response.nextPageToken,
    );
  }

  List<WorkHistoryItem> _itemsFrom(work_pb.ListJobsResponse response) {
    return [for (final summary in response.jobs) _itemFrom(summary)];
  }

  WorkHistoryItem _itemFrom(work_pb.JobSummary summary) {
    final job = summary.job;
    return WorkHistoryItem(
      jobId: job.jobId,
      commonKey: job.commonKey,
      projectNo: job.projectNo,
      unitNo: job.unitNo,
      itemCode: job.itemCode,
      itemName: job.itemName,
      jointNo: job.jointNo,
      hasReport: summary.hasReport,
      workerId: job.workerId,
      workerName: summary.workerName,
      equipmentId: '',
      equipmentName: summary.equipmentNames.join(', '),
      workedAt: job.hasStartedAt()
          ? job.startedAt.toDateTime().toLocal()
          : null,
      passCount: summary.passCount,
      attachmentCount: summary.attachmentCount,
    );
  }

  DateTime _dayStart(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }
}
