import 'package:get_it/get_it.dart';

import '../../../data/datasources/remote/dashboard_service_data_source.dart';
import '../../../data/repositories/remote_catalog_repository.dart';
import '../../../data/repositories/remote_collection_catalog_repository.dart';
import '../../../data/repositories/remote_pass_waveform_repository.dart';
import '../../../data/repositories/remote_work_detail_repository.dart';
import '../../../data/repositories/remote_work_history_repository.dart';
import '../../../domain/repositories/catalog_repository.dart';
import '../../../domain/repositories/collection_catalog_repository.dart';
import '../../../domain/repositories/pass_waveform_repository.dart';
import '../../../domain/repositories/work_detail_repository.dart';
import '../../../domain/repositories/work_history_repository.dart';
import '../../../domain/use_cases/load_catalog_use_case.dart';
import '../../../domain/use_cases/load_collection_catalog_use_case.dart';
import '../../../domain/use_cases/load_pass_waveform_catalog_use_case.dart';
import '../../../domain/use_cases/load_work_detail_catalog_use_case.dart';
import '../../../domain/use_cases/load_work_history_catalog_use_case.dart';
import '../../../domain/use_cases/list_work_history_page_use_case.dart';
import '../../../domain/use_cases/load_work_history_masters_use_case.dart';
import '../../../domain/use_cases/query_collection_board_use_case.dart';
import '../../../domain/use_cases/query_pass_profile_use_case.dart';
import '../../../domain/use_cases/query_quality_issue_use_case.dart';
import '../../../domain/use_cases/query_work_detail_use_case.dart';
import '../../../domain/use_cases/query_work_history_use_case.dart';
import '../../../domain/use_cases/resolve_latest_pass_profile_use_case.dart';
import '../../../domain/use_cases/resolve_latest_quality_issue_use_case.dart';
import '../../features/app_shell/shell_view_model.dart';
import '../../features/collection_monitoring/collection_monitoring_view_model.dart';
import '../../features/pass_profile/pass_profile_args.dart';
import '../../features/pass_profile/pass_profile_view_model.dart';
import '../../features/quality_issue/quality_issue_args.dart';
import '../../features/quality_issue/quality_issue_view_model.dart';
import '../../features/work_detail/work_detail_view_model.dart';
import '../../features/work_history/work_history_view_model.dart';
import '../../navigation/app_coordinator.dart';

final locator = GetIt.instance;

void setupLocator({required bool pdfrxReady}) {
  locator.registerLazySingleton(() => DashboardServiceDataSource());
  locator.registerLazySingleton<CatalogRepository>(
    () => RemoteCatalogRepository(locator()),
  );
  locator.registerLazySingleton(() => LoadCatalogUseCase(locator()));
  locator.registerLazySingleton<CollectionCatalogRepository>(
    () => RemoteCollectionCatalogRepository(locator()),
  );
  locator.registerLazySingleton(() => LoadCollectionCatalogUseCase(locator()));
  locator.registerFactory(() => QueryCollectionBoardUseCase());
  locator.registerLazySingleton<WorkHistoryRepository>(
    () => RemoteWorkHistoryRepository(locator()),
  );
  locator.registerLazySingleton(() => LoadWorkHistoryCatalogUseCase(locator()));
  locator.registerLazySingleton(() => LoadWorkHistoryMastersUseCase(locator()));
  locator.registerLazySingleton(() => ListWorkHistoryPageUseCase(locator()));
  locator.registerFactory(() => QueryWorkHistoryUseCase());
  locator.registerLazySingleton<WorkDetailRepository>(
    () => RemoteWorkDetailRepository(locator()),
  );
  locator.registerLazySingleton(() => LoadWorkDetailCatalogUseCase(locator()));
  locator.registerFactory(() => QueryWorkDetailUseCase());
  locator.registerLazySingleton<PassWaveformRepository>(
    () => RemotePassWaveformRepository(locator()),
  );
  locator.registerLazySingleton(
    () => LoadPassWaveformCatalogUseCase(locator()),
  );
  locator.registerFactory(() => QueryPassProfileUseCase());
  locator.registerFactory(() => QueryQualityIssueUseCase());
  locator.registerFactory(() => ResolveLatestPassProfileUseCase());
  locator.registerFactory(() => ResolveLatestQualityIssueUseCase());
  locator.registerFactoryParam<WorkDetailViewModel, String, void>(
    (historyId, _) => WorkDetailViewModel(
      loadWorkDetailCatalogUseCase: locator(),
      queryWorkDetailUseCase: locator(),
      historyId: historyId,
    ),
  );
  locator.registerFactoryParam<PassProfileViewModel, PassProfileArgs, void>(
    (args, _) => PassProfileViewModel(
      loadPassWaveformCatalogUseCase: locator(),
      queryPassProfileUseCase: locator(),
      commonKey: args.commonKey,
      historyId: args.historyId,
      passId: args.passId,
    ),
  );
  locator.registerFactoryParam<QualityIssueViewModel, QualityIssueArgs, void>(
    (args, _) => QualityIssueViewModel(
      loadPassWaveformCatalogUseCase: locator(),
      queryQualityIssueUseCase: locator(),
      commonKey: args.commonKey,
      historyId: args.historyId,
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
      loadCollectionCatalogUseCase: locator(),
      queryCollectionBoardUseCase: locator(),
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
