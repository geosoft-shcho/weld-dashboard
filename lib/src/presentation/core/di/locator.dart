import 'package:get_it/get_it.dart';

import '../../../data/repositories/browser_camera_recording_repository.dart';
import '../../../domain/repositories/camera_recording_repository.dart';
import '../../../domain/use_cases/download_camera_recording_file_use_case.dart';
import '../../../domain/use_cases/prepare_camera_recording_use_case.dart';
import '../../../domain/use_cases/read_camera_preview_handle_use_case.dart';
import '../../../domain/use_cases/release_camera_recording_use_case.dart';
import '../../../domain/use_cases/start_camera_recording_use_case.dart';
import '../../../domain/use_cases/stop_camera_recording_use_case.dart';
import '../../../data/datasources/remote/media_tag_data_source.dart';
import '../../../data/repositories/remote_catalog_repository.dart';
import '../../../data/repositories/remote_collection_catalog_repository.dart';
import '../../../data/repositories/remote_pass_waveform_repository.dart';
import '../../../data/repositories/remote_quality_job_media_repository.dart';
import '../../../data/repositories/remote_quality_result_repository.dart';
import '../../../data/repositories/remote_report_set_repository.dart';
import '../../../data/repositories/remote_job_timeline_repository.dart';
import '../../../data/repositories/remote_label_repository.dart';
import '../../../data/repositories/remote_tool_run_repository.dart';
import '../../../data/repositories/remote_work_detail_repository.dart';
import '../../../data/repositories/remote_work_history_repository.dart';
import '../../../domain/repositories/catalog_repository.dart';
import '../../../domain/repositories/collection_catalog_repository.dart';
import '../../../domain/repositories/pass_waveform_repository.dart';
import '../../../domain/repositories/quality_job_media_repository.dart';
import '../../../domain/repositories/quality_result_repository.dart';
import '../../../domain/repositories/report_set_repository.dart';
import '../../../domain/repositories/job_timeline_repository.dart';
import '../../../domain/repositories/label_repository.dart';
import '../../../domain/repositories/tool_run_repository.dart';
import '../../../domain/repositories/work_detail_repository.dart';
import '../../../domain/repositories/work_history_repository.dart';
import '../../../domain/use_cases/list_collected_nodes_use_case.dart';
import '../../../domain/use_cases/get_report_set_use_case.dart';
import '../../../domain/use_cases/change_timeline_status_use_case.dart';
import '../../../domain/use_cases/create_clip_use_case.dart';
import '../../../domain/use_cases/create_track_use_case.dart';
import '../../../domain/use_cases/delete_clip_use_case.dart';
import '../../../domain/use_cases/delete_track_use_case.dart';
import '../../../domain/use_cases/get_job_timeline_use_case.dart';
import '../../../domain/use_cases/label_use_case.dart';
import '../../../domain/use_cases/tool_run_use_case.dart';
import '../../../domain/use_cases/update_clip_use_case.dart';
import '../../../domain/use_cases/update_track_use_case.dart';
import '../../../domain/use_cases/list_quality_job_media_use_case.dart';
import '../../../domain/use_cases/list_quality_results_use_case.dart';
import '../../../domain/use_cases/list_report_sets_use_case.dart';
import '../../../domain/use_cases/load_catalog_use_case.dart';
import '../../../domain/use_cases/load_collection_catalog_use_case.dart';
import '../../../domain/use_cases/list_comparison_jobs_use_case.dart';
import '../../../domain/use_cases/load_comparison_passes_use_case.dart';
import '../../../domain/use_cases/load_pass_waveform_catalog_use_case.dart';
import '../../../domain/use_cases/load_pass_waveform_use_case.dart';
import '../../../domain/use_cases/load_work_detail_catalog_use_case.dart';
import '../../../domain/use_cases/load_work_history_catalog_use_case.dart';
import '../../../domain/use_cases/list_history_work_attachments_use_case.dart';
import '../../../domain/use_cases/list_work_history_page_use_case.dart';
import '../../../domain/use_cases/load_work_history_masters_use_case.dart';
import '../../../domain/use_cases/present_collection_nodes_use_case.dart';
import '../../../domain/use_cases/query_collection_board_use_case.dart';
import '../../../domain/use_cases/query_pass_profile_use_case.dart';
import '../../../domain/use_cases/query_quality_issue_use_case.dart';
import '../../../domain/use_cases/query_work_detail_use_case.dart';
import '../../../domain/use_cases/query_work_history_use_case.dart';
import '../../../domain/use_cases/resolve_latest_pass_profile_use_case.dart';
import '../../../domain/use_cases/resolve_latest_quality_issue_use_case.dart';
import '../../features/app_shell/shell_view_model.dart';
import '../../features/collection_monitoring/collection_monitoring_view_model.dart';
import '../../features/video_multimodal/camera_recording_view_model.dart';
import '../../features/video_multimodal/video_multimodal_view_model.dart';
import '../../features/pass_profile/pass_profile_args.dart';
import '../../features/pass_profile/pass_profile_view_model.dart';
import '../../features/quality_issue/quality_issue_args.dart';
import '../../features/quality_issue/quality_issue_view_model.dart';
import '../../features/work_detail/work_detail_view_model.dart';
import '../../features/work_history/work_history_view_model.dart';
import '../../navigation/app_coordinator.dart';

final locator = GetIt.instance;

void setupLocator({required bool pdfrxReady}) {
  locator.registerLazySingleton(() => MediaTagDataSource());
  locator.registerLazySingleton<CatalogRepository>(
    () => RemoteCatalogRepository(),
  );
  locator.registerLazySingleton(() => LoadCatalogUseCase(locator()));
  locator.registerLazySingleton<CollectionCatalogRepository>(
    () => RemoteCollectionCatalogRepository(locator()),
  );
  locator.registerLazySingleton(() => LoadCollectionCatalogUseCase(locator()));
  locator.registerLazySingleton(() => ListCollectedNodesUseCase(locator()));
  locator.registerFactory(() => QueryCollectionBoardUseCase());
  locator.registerFactory(() => PresentCollectionNodesUseCase());
  locator.registerLazySingleton<WorkHistoryRepository>(
    () => RemoteWorkHistoryRepository(locator()),
  );
  locator.registerLazySingleton(() => LoadWorkHistoryCatalogUseCase(locator()));
  locator.registerLazySingleton(() => LoadWorkHistoryMastersUseCase(locator()));
  locator.registerLazySingleton(() => ListWorkHistoryPageUseCase(locator()));
  locator.registerFactory(() => QueryWorkHistoryUseCase());
  locator.registerLazySingleton<WorkDetailRepository>(
    () => RemoteWorkDetailRepository(locator<MediaTagDataSource>()),
  );
  locator.registerLazySingleton(() => LoadWorkDetailCatalogUseCase(locator()));
  locator.registerFactory(() => QueryWorkDetailUseCase());
  locator.registerFactory(() => ListHistoryWorkAttachmentsUseCase(locator()));
  locator.registerLazySingleton<JobTimelineRepository>(
    () => RemoteJobTimelineRepository(locator()),
  );
  locator.registerFactory(() => GetJobTimelineUseCase(locator()));
  locator.registerFactory(() => CreateTrackUseCase(locator()));
  locator.registerFactory(() => UpdateTrackUseCase(locator()));
  locator.registerFactory(() => DeleteTrackUseCase(locator()));
  locator.registerFactory(() => CreateClipUseCase(locator()));
  locator.registerFactory(() => UpdateClipUseCase(locator()));
  locator.registerFactory(() => DeleteClipUseCase(locator()));
  locator.registerFactory(() => ChangeTimelineStatusUseCase(locator()));
  locator.registerLazySingleton<ToolRunRepository>(
    () => RemoteToolRunRepository(locator()),
  );
  locator.registerFactory(() => ToolRunUseCase(locator()));
  locator.registerLazySingleton<LabelRepository>(
    () => RemoteLabelRepository(locator()),
  );
  locator.registerFactory(() => LabelUseCase(locator()));
  locator.registerFactory(() {
    final CameraRecordingRepository repository =
        BrowserCameraRecordingRepository();
    return CameraRecordingViewModel(
      prepareCameraRecordingUseCase: PrepareCameraRecordingUseCase(repository),
      startCameraRecordingUseCase: StartCameraRecordingUseCase(repository),
      stopCameraRecordingUseCase: StopCameraRecordingUseCase(repository),
      downloadCameraRecordingFileUseCase: DownloadCameraRecordingFileUseCase(
        repository,
      ),
      releaseCameraRecordingUseCase: ReleaseCameraRecordingUseCase(repository),
      readCameraPreviewHandleUseCase: ReadCameraPreviewHandleUseCase(
        repository,
      ),
    );
  });
  locator.registerFactoryParam<VideoMultimodalViewModel, String, void>(
    (jobId, _) => VideoMultimodalViewModel(
      listHistoryWorkAttachmentsUseCase: locator(),
      getJobTimelineUseCase: locator(),
      createTrackUseCase: locator(),
      updateTrackUseCase: locator(),
      deleteTrackUseCase: locator(),
      createClipUseCase: locator(),
      updateClipUseCase: locator(),
      deleteClipUseCase: locator(),
      changeTimelineStatusUseCase: locator(),
      toolRunUseCase: locator(),
      labelUseCase: locator(),
      jobId: jobId,
    ),
  );
  locator.registerLazySingleton<PassWaveformRepository>(
    () => RemotePassWaveformRepository(locator()),
  );
  locator.registerLazySingleton(
    () => LoadPassWaveformCatalogUseCase(locator()),
  );
  locator.registerLazySingleton(() => LoadPassWaveformUseCase(locator()));
  locator.registerLazySingleton(() => ListComparisonJobsUseCase(locator()));
  locator.registerLazySingleton(() => LoadComparisonPassesUseCase(locator()));
  locator.registerFactory(() => QueryPassProfileUseCase());
  locator.registerLazySingleton<QualityResultRepository>(
    () => RemoteQualityResultRepository(locator()),
  );
  locator.registerLazySingleton(() => ListQualityResultsUseCase(locator()));
  locator.registerLazySingleton<QualityJobMediaRepository>(
    () => RemoteQualityJobMediaRepository(locator()),
  );
  locator.registerLazySingleton(() => ListQualityJobMediaUseCase(locator()));
  locator.registerLazySingleton<ReportSetRepository>(
    () => RemoteReportSetRepository(locator()),
  );
  locator.registerLazySingleton(() => ListReportSetsUseCase(locator()));
  locator.registerLazySingleton(() => GetReportSetUseCase(locator()));
  locator.registerFactory(() => QueryQualityIssueUseCase());
  locator.registerFactory(() => ResolveLatestPassProfileUseCase());
  locator.registerFactory(() => ResolveLatestQualityIssueUseCase());
  locator.registerFactoryParam<WorkDetailViewModel, String, void>(
    (jobId, _) => WorkDetailViewModel(
      loadWorkDetailCatalogUseCase: locator(),
      queryWorkDetailUseCase: locator(),
      listReportSetsUseCase: locator(),
      getReportSetUseCase: locator(),
      jobId: jobId,
    ),
  );
  locator.registerFactoryParam<PassProfileViewModel, PassProfileArgs, void>(
    (args, _) => PassProfileViewModel(
      loadPassWaveformCatalogUseCase: locator(),
      loadPassWaveformUseCase: locator(),
      listComparisonJobsUseCase: locator(),
      loadComparisonPassesUseCase: locator(),
      queryPassProfileUseCase: locator(),
      commonKey: args.commonKey,
      jobId: args.jobId,
      passId: args.passId,
    ),
  );
  locator.registerFactoryParam<QualityIssueViewModel, QualityIssueArgs, void>(
    (args, _) => QualityIssueViewModel(
      loadPassWaveformCatalogUseCase: locator(),
      loadPassWaveformUseCase: locator(),
      listComparisonJobsUseCase: locator(),
      loadComparisonPassesUseCase: locator(),
      queryQualityIssueUseCase: locator(),
      listQualityResultsUseCase: locator(),
      listQualityJobMediaUseCase: locator(),
      getReportSetUseCase: locator(),
      commonKey: args.commonKey,
      jobId: args.jobId,
      passId: args.passId,
      linkId: args.linkId,
    ),
  );
  locator.registerLazySingleton(() => AppCoordinator());
  locator.registerFactory(
    () => ShellViewModel(
      loadCatalogUseCase: locator(),
      loadPassWaveformCatalogUseCase: locator(),
      resolveLatestPassProfileUseCase: locator(),
      resolveLatestQualityIssueUseCase: locator(),
      pdfrxReady: pdfrxReady,
    ),
  );
  locator.registerFactory(
    () => CollectionMonitoringViewModel(
      listCollectedNodesUseCase: locator(),
      presentCollectionNodesUseCase: locator(),
      onAfterBoardLoaded: locator<AppCoordinator>().didRefreshDashboardData,
    ),
  );
  locator.registerFactory(
    () => WorkHistoryViewModel(
      loadWorkHistoryMastersUseCase: locator(),
      listWorkHistoryPageUseCase: locator(),
    ),
  );
}
