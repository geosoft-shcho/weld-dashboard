import 'package:get_it/get_it.dart';

import '../../../data/repositories/browser_camera_recording_repository.dart';
import '../../../data/repositories/remote_asset_lookup_repository.dart';
import '../../../data/repositories/remote_equipment_lookup_repository.dart';
import '../../../data/repositories/remote_project_lookup_repository.dart';
import '../../../data/repositories/remote_worker_lookup_repository.dart';
import '../../../domain/repositories/asset_lookup_repository.dart';
import '../../../domain/repositories/equipment_lookup_repository.dart';
import '../../../domain/repositories/project_lookup_repository.dart';
import '../../../domain/repositories/worker_lookup_repository.dart';
import '../../../domain/use_cases/get_asset_lookup_use_case.dart';
import '../../../domain/use_cases/list_asset_lookup_page_use_case.dart';
import '../../../domain/use_cases/update_asset_use_case.dart';
import '../../../domain/use_cases/list_equipment_lookup_use_case.dart';
import '../../../domain/use_cases/list_job_passes_use_case.dart';
import '../../../domain/use_cases/create_project_items_use_case.dart';
import '../../../domain/use_cases/create_project_use_case.dart';
import '../../../domain/use_cases/delete_project_item_use_case.dart';
import '../../../domain/use_cases/delete_project_use_case.dart';
import '../../../domain/use_cases/update_project_item_use_case.dart';
import '../../../domain/use_cases/update_project_use_case.dart';
import '../../../domain/use_cases/get_equipment_lookup_use_case.dart';
import '../../../domain/use_cases/get_project_lookup_use_case.dart';
import '../../../domain/use_cases/get_worker_lookup_use_case.dart';
import '../../../domain/use_cases/list_project_lookup_use_case.dart';
import '../../../domain/use_cases/list_worker_lookup_use_case.dart';
import '../../features/asset_lookup/asset_lookup_detail_view_model.dart';
import '../../features/asset_lookup/asset_lookup_view_model.dart';
import '../../features/equipment_lookup/equipment_lookup_detail_view_model.dart';
import '../../features/equipment_lookup/equipment_lookup_view_model.dart';
import '../../features/job_lookup/job_lookup_detail_view_model.dart';
import '../../features/project_lookup/project_lookup_detail_view_model.dart';
import '../../features/project_lookup/project_lookup_view_model.dart';
import '../../features/worker_lookup/worker_lookup_detail_view_model.dart';
import '../../features/worker_lookup/worker_lookup_view_model.dart';
import '../../../domain/repositories/asset_upload_repository.dart';
import '../../../domain/repositories/camera_recording_repository.dart';
import '../../../domain/use_cases/download_camera_recording_file_use_case.dart';
import '../../../domain/use_cases/prepare_camera_recording_use_case.dart';
import '../../../domain/use_cases/read_camera_preview_handle_use_case.dart';
import '../../../domain/use_cases/release_camera_recording_use_case.dart';
import '../../../domain/use_cases/start_camera_recording_use_case.dart';
import '../../../domain/use_cases/stop_camera_recording_use_case.dart';
import '../../../domain/use_cases/list_upload_formats_use_case.dart';
import '../../../domain/use_cases/upload_asset_queue_use_case.dart';
import '../../../domain/use_cases/upload_asset_use_case.dart';
import '../../../data/datasources/remote/media_tag_data_source.dart';
import '../../../data/datasources/local/auth_session_local_data_source.dart';
import '../../../data/repositories/browser_ask_session_store.dart';
import '../../../data/repositories/hardcoded_auth_repository.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/use_cases/restore_auth_session_use_case.dart';
import '../../../domain/use_cases/sign_in_use_case.dart';
import '../../../domain/use_cases/sign_out_use_case.dart';
import '../../features/auth/auth_session_view_model.dart';
import '../../../data/repositories/remote_ask_repository.dart';
import '../../../data/repositories/remote_asset_upload_repository.dart';
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
import '../../../domain/repositories/ask_repository.dart';
import '../../../domain/repositories/ask_session_store.dart';
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
import '../../../domain/use_cases/ask_question_use_case.dart';
import '../../../domain/use_cases/get_session_history_use_case.dart';
import '../../../domain/use_cases/list_collected_nodes_use_case.dart';
import '../../../domain/use_cases/load_job_project_id_use_case.dart';
import '../../../domain/use_cases/get_report_set_use_case.dart';
import '../../../domain/use_cases/change_timeline_status_use_case.dart';
import '../../../domain/use_cases/create_clip_use_case.dart';
import '../../../domain/use_cases/create_track_use_case.dart';
import '../../../domain/use_cases/delete_clip_use_case.dart';
import '../../../domain/use_cases/delete_timeline_use_case.dart';
import '../../../domain/use_cases/delete_track_use_case.dart';
import '../../../domain/use_cases/get_clip_use_case.dart';
import '../../../domain/use_cases/get_job_timeline_use_case.dart';
import '../../../domain/use_cases/load_timeseries_waveform_use_case.dart';
import '../../../domain/use_cases/label_use_case.dart';
import '../../../domain/use_cases/tool_run_use_case.dart';
import '../../../domain/use_cases/update_clip_use_case.dart';
import '../../../domain/use_cases/update_timeline_use_case.dart';
import '../../../domain/use_cases/update_track_use_case.dart';
import '../../../domain/use_cases/list_quality_job_media_use_case.dart';
import '../../../domain/use_cases/list_quality_results_use_case.dart';
import '../../../domain/use_cases/list_report_sets_use_case.dart';
import '../../../domain/use_cases/update_report_field_use_case.dart';
import '../../../domain/use_cases/load_catalog_use_case.dart';
import '../../../domain/use_cases/load_collection_catalog_use_case.dart';
import '../../../domain/use_cases/list_comparison_jobs_use_case.dart';
import '../../../domain/use_cases/load_comparison_passes_use_case.dart';
import '../../../domain/use_cases/load_pass_waveform_catalog_use_case.dart';
import '../../../domain/use_cases/load_pass_waveform_use_case.dart';
import '../../../domain/use_cases/load_work_detail_catalog_use_case.dart';
import '../../../domain/use_cases/load_work_history_catalog_use_case.dart';
import '../../../domain/use_cases/list_history_work_attachments_use_case.dart';
import '../../../domain/use_cases/create_job_use_case.dart';
import '../../../domain/repositories/job_admin_repository.dart';
import '../../../domain/use_cases/job_admin_use_case.dart';
import '../../../data/repositories/remote_job_admin_repository.dart';
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
  locator.registerLazySingleton(() => AuthSessionLocalDataSource());
  locator.registerLazySingleton<AuthRepository>(
    () => HardcodedAuthRepository(locator()),
  );
  locator.registerLazySingleton(() => RestoreAuthSessionUseCase(locator()));
  locator.registerLazySingleton(() => SignInUseCase(locator()));
  locator.registerLazySingleton(() => SignOutUseCase(locator()));
  locator.registerLazySingleton(
    () => AuthSessionViewModel(
      restoreAuthSessionUseCase: locator(),
      signInUseCase: locator(),
      signOutUseCase: locator(),
    ),
  );
  locator.registerLazySingleton(() => MediaTagDataSource());
  locator.registerLazySingleton<AssetUploadRepository>(
    () => RemoteAssetUploadRepository(locator()),
  );
  locator.registerFactory(() => UploadAssetUseCase(locator()));
  locator.registerFactory(
    () => UploadAssetQueueUseCase(
      locator<AssetUploadRepository>(),
      locator<ToolRunRepository>(),
    ),
  );
  locator.registerLazySingleton(() => ListUploadFormatsUseCase(locator()));
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
  locator.registerLazySingleton(() => CreateJobUseCase(locator()));
  locator.registerLazySingleton<JobAdminRepository>(
    () => RemoteJobAdminRepository(locator()),
  );
  locator.registerLazySingleton(() => JobAdminUseCase(locator()));
  locator.registerLazySingleton<ProjectLookupRepository>(
    () => RemoteProjectLookupRepository(locator()),
  );
  locator.registerLazySingleton(() => ListProjectLookupUseCase(locator()));
  locator.registerLazySingleton(() => GetProjectLookupUseCase(locator()));
  locator.registerLazySingleton(() => CreateProjectUseCase(locator()));
  locator.registerLazySingleton(() => CreateProjectItemsUseCase(locator()));
  locator.registerLazySingleton(() => UpdateProjectUseCase(locator()));
  locator.registerLazySingleton(() => DeleteProjectUseCase(locator()));
  locator.registerLazySingleton(() => UpdateProjectItemUseCase(locator()));
  locator.registerLazySingleton(() => DeleteProjectItemUseCase(locator()));
  locator.registerLazySingleton<WorkerLookupRepository>(
    () => RemoteWorkerLookupRepository(locator()),
  );
  locator.registerLazySingleton(() => ListWorkerLookupUseCase(locator()));
  locator.registerLazySingleton(() => GetWorkerLookupUseCase(locator()));
  locator.registerLazySingleton<EquipmentLookupRepository>(
    () => RemoteEquipmentLookupRepository(locator()),
  );
  locator.registerLazySingleton(() => ListEquipmentLookupUseCase(locator()));
  locator.registerLazySingleton(() => GetEquipmentLookupUseCase(locator()));
  locator.registerLazySingleton<AssetLookupRepository>(
    () => RemoteAssetLookupRepository(locator()),
  );
  locator.registerLazySingleton(() => ListAssetLookupPageUseCase(locator()));
  locator.registerLazySingleton(() => ListJobPassesUseCase(locator()));
  locator.registerLazySingleton(() => GetAssetLookupUseCase(locator()));
  locator.registerLazySingleton(() => UpdateAssetUseCase(locator()));
  locator.registerFactory(
    () => ProjectLookupViewModel(
      listProjectLookupUseCase: locator(),
      createProjectUseCase: locator(),
      createProjectItemsUseCase: locator(),
    ),
  );
  locator.registerFactory(
    () => WorkerLookupViewModel(listWorkerLookupUseCase: locator()),
  );
  locator.registerFactory(
    () => EquipmentLookupViewModel(listEquipmentLookupUseCase: locator()),
  );
  locator.registerFactory(
    () => AssetLookupViewModel(
      listAssetLookupPageUseCase: locator(),
      listEquipmentLookupUseCase: locator(),
      listWorkHistoryPageUseCase: locator(),
      listUploadFormatsUseCase: locator(),
      uploadAssetUseCase: locator(),
      uploadAssetQueueUseCase: locator(),
    ),
  );
  locator.registerFactoryParam<ProjectLookupDetailViewModel, String, void>(
    (projectId, _) => ProjectLookupDetailViewModel(
      projectId: projectId,
      getProjectLookupUseCase: locator(),
      updateProjectUseCase: locator(),
      deleteProjectUseCase: locator(),
      createProjectItemsUseCase: locator(),
      updateProjectItemUseCase: locator(),
      deleteProjectItemUseCase: locator(),
    ),
  );
  locator.registerFactoryParam<WorkerLookupDetailViewModel, String, void>(
    (workerId, _) => WorkerLookupDetailViewModel(
      workerId: workerId,
      getWorkerLookupUseCase: locator(),
      listWorkHistoryPageUseCase: locator(),
    ),
  );
  locator.registerFactoryParam<EquipmentLookupDetailViewModel, String, void>(
    (equipmentId, _) => EquipmentLookupDetailViewModel(
      equipmentId: equipmentId,
      getEquipmentLookupUseCase: locator(),
      listWorkHistoryPageUseCase: locator(),
      listAssetLookupPageUseCase: locator(),
    ),
  );
  locator.registerFactoryParam<AssetLookupDetailViewModel, String, void>(
    (assetId, _) => AssetLookupDetailViewModel(
      assetId: assetId,
      getAssetLookupUseCase: locator(),
      listWorkHistoryPageUseCase: locator(),
      listEquipmentLookupUseCase: locator(),
      updateAssetUseCase: locator(),
      toolRunUseCase: locator(),
    ),
  );
  locator.registerFactoryParam<JobLookupDetailViewModel, String, void>(
    (jobId, _) => JobLookupDetailViewModel(
      jobId: jobId,
      loadWorkDetailCatalogUseCase: locator(),
      queryWorkDetailUseCase: locator(),
      listJobPassesUseCase: locator(),
      listAssetLookupPageUseCase: locator(),
      jobAdminUseCase: locator(),
      loadWorkHistoryMastersUseCase: locator(),
      listEquipmentLookupUseCase: locator(),
      listUploadFormatsUseCase: locator(),
      uploadAssetUseCase: locator(),
      uploadAssetQueueUseCase: locator(),
    ),
  );
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
  locator.registerFactory(
    () => LoadTimeseriesWaveformUseCase(locator()),
  );
  locator.registerFactory(() => GetClipUseCase(locator()));
  locator.registerFactory(() => CreateTrackUseCase(locator()));
  locator.registerFactory(() => UpdateTrackUseCase(locator()));
  locator.registerFactory(() => DeleteTrackUseCase(locator()));
  locator.registerFactory(() => CreateClipUseCase(locator()));
  locator.registerFactory(() => UpdateClipUseCase(locator()));
  locator.registerFactory(() => DeleteClipUseCase(locator()));
  locator.registerFactory(() => ChangeTimelineStatusUseCase(locator()));
  locator.registerFactory(() => UpdateTimelineUseCase(locator()));
  locator.registerFactory(() => DeleteTimelineUseCase(locator()));
  locator.registerLazySingleton<ToolRunRepository>(
    () => RemoteToolRunRepository(locator()),
  );
  locator.registerFactory(() => ToolRunUseCase(locator()));
  locator.registerLazySingleton<LabelRepository>(
    () => RemoteLabelRepository(locator()),
  );
  locator.registerFactory(() => LabelUseCase(locator()));
  locator.registerLazySingleton<AskRepository>(
    () => RemoteAskRepository(locator()),
  );
  locator.registerLazySingleton<AskSessionStore>(
    () => BrowserAskSessionStore(),
  );
  locator.registerFactory(() => AskQuestionUseCase(locator()));
  locator.registerFactory(() => GetSessionHistoryUseCase(locator()));
  locator.registerFactory(() => LoadJobProjectIdUseCase(locator()));
  locator.registerFactoryParam<
    CameraRecordingViewModel,
    CameraRecordingArgs,
    void
  >((args, _) {
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
      uploadAssetUseCase: locator(),
      toolRunUseCase: locator(),
      jobId: args.jobId,
      onUploaded: args.onUploaded,
      onRecordingPlaced: args.onRecordingPlaced,
      onUploadCompleted: args.onUploadCompleted,
    );
  });
  locator.registerFactoryParam<VideoMultimodalViewModel, String, void>(
    (jobId, _) => VideoMultimodalViewModel(
      listHistoryWorkAttachmentsUseCase: locator(),
      getJobTimelineUseCase: locator(),
      getClipUseCase: locator(),
      createTrackUseCase: locator(),
      updateTrackUseCase: locator(),
      deleteTrackUseCase: locator(),
      createClipUseCase: locator(),
      updateClipUseCase: locator(),
      deleteClipUseCase: locator(),
      changeTimelineStatusUseCase: locator(),
      updateTimelineUseCase: locator(),
      deleteTimelineUseCase: locator(),
      toolRunUseCase: locator(),
      labelUseCase: locator(),
      askQuestionUseCase: locator(),
      getSessionHistoryUseCase: locator(),
      askSessionStore: locator(),
      loadJobProjectIdUseCase: locator(),
      loadTimeseriesWaveformUseCase: locator(),
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
  locator.registerLazySingleton(() => UpdateReportFieldUseCase(locator()));
  locator.registerFactory(() => QueryQualityIssueUseCase());
  locator.registerFactory(() => ResolveLatestPassProfileUseCase());
  locator.registerFactory(() => ResolveLatestQualityIssueUseCase());
  locator.registerFactoryParam<WorkDetailViewModel, String, void>(
    (jobId, _) => WorkDetailViewModel(
      loadWorkDetailCatalogUseCase: locator(),
      queryWorkDetailUseCase: locator(),
      listReportSetsUseCase: locator(),
      getReportSetUseCase: locator(),
      jobAdminUseCase: locator(),
      updateReportFieldUseCase: locator(),
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
      listWorkHistoryPageUseCase: locator(),
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
      createJobUseCase: locator(),
    ),
  );
}
