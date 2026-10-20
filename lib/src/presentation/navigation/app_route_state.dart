import 'app_coordinator.dart';

enum AppPane { collection, projects, workers, history, equipment, assets, pass, quality }

/// Parsed dashboard location. Shell UI still reads [AppCoordinator]; this only
/// maps path ↔ coordinator fields for browser history.
class AppRouteState {
  const AppRouteState({
    required this.pane,
    this.stack = WorkHistoryStack.list,
    this.jobId = '',
    this.commonKey = '',
    this.passId = '',
    this.linkId = '',
    this.qualityViaDetail = false,
    this.lookupDetailId = '',
  });

  final AppPane pane;
  final WorkHistoryStack stack;
  final String jobId;
  final String commonKey;
  final String passId;
  final String linkId;

  /// When [stack] is [WorkHistoryStack.qualityIssue], true means previous
  /// screen was detail (not pass profile).
  final bool qualityViaDetail;

  /// 공사·작업자·장비·에셋 조회의 상세 id. 비면 목록.
  final String lookupDetailId;

  static const String collectionPath = '/collection';
  static const String projectsPath = '/projects';
  static const String workersPath = '/workers';
  static const String historyPath = '/history';
  static const String equipmentPath = '/equipment';
  static const String assetsPath = '/assets';
  static const String passPath = '/pass';
  static const String qualityPath = '/quality';

  String toLocation() {
    switch (pane) {
      case AppPane.collection:
        return collectionPath;
      case AppPane.projects:
        return _lookupLocation(projectsPath);
      case AppPane.workers:
        return _lookupLocation(workersPath);
      case AppPane.equipment:
        return _lookupLocation(equipmentPath);
      case AppPane.assets:
        return _lookupLocation(assetsPath);
      case AppPane.pass:
        return _locationWithQuery(passPath, {
          if (commonKey.isNotEmpty) 'commonKey': commonKey,
          if (jobId.isNotEmpty) 'jobId': jobId,
          if (passId.isNotEmpty) 'passId': passId,
        });
      case AppPane.quality:
        return _locationWithQuery(qualityPath, {
          if (commonKey.isNotEmpty) 'commonKey': commonKey,
          if (jobId.isNotEmpty) 'jobId': jobId,
          if (passId.isNotEmpty) 'passId': passId,
          if (linkId.isNotEmpty) 'linkId': linkId,
        });
      case AppPane.history:
        switch (stack) {
          case WorkHistoryStack.list:
            return historyPath;
          case WorkHistoryStack.detail:
            final id = jobId.isEmpty ? '_' : Uri.encodeComponent(jobId);
            return '$historyPath/detail/$id';
          case WorkHistoryStack.videoMultimodal:
            final multimodalId = jobId.isEmpty
                ? '_'
                : Uri.encodeComponent(jobId);
            return '$historyPath/detail/$multimodalId/multimodal';
          case WorkHistoryStack.passProfile:
            return _locationWithQuery('$historyPath/pass', {
              if (commonKey.isNotEmpty) 'commonKey': commonKey,
              if (jobId.isNotEmpty) 'jobId': jobId,
              if (passId.isNotEmpty) 'passId': passId,
            });
          case WorkHistoryStack.qualityIssue:
            return _locationWithQuery('$historyPath/quality', {
              if (commonKey.isNotEmpty) 'commonKey': commonKey,
              if (jobId.isNotEmpty) 'jobId': jobId,
              if (passId.isNotEmpty) 'passId': passId,
              if (linkId.isNotEmpty) 'linkId': linkId,
              if (qualityViaDetail) 'via': 'detail',
            });
        }
    }
  }

  String _lookupLocation(String base) {
    if (lookupDetailId.isEmpty) {
      return base;
    }
    return '$base/${Uri.encodeComponent(lookupDetailId)}';
  }

  static AppRouteState? tryParse(Uri uri) {
    final path = uri.path.isEmpty ? '/' : uri.path;
    final query = uri.queryParameters;

    if (path == '/' || path.isEmpty) {
      return const AppRouteState(pane: AppPane.collection);
    }
    if (path == collectionPath) {
      return const AppRouteState(pane: AppPane.collection);
    }
    final projectDetail = _parseLookupDetail(path, projectsPath);
    if (projectDetail != null) {
      return AppRouteState(
        pane: AppPane.projects,
        lookupDetailId: projectDetail,
      );
    }
    if (path == projectsPath) {
      return const AppRouteState(pane: AppPane.projects);
    }
    final workerDetail = _parseLookupDetail(path, workersPath);
    if (workerDetail != null) {
      return AppRouteState(pane: AppPane.workers, lookupDetailId: workerDetail);
    }
    if (path == workersPath) {
      return const AppRouteState(pane: AppPane.workers);
    }
    final equipmentDetail = _parseLookupDetail(path, equipmentPath);
    if (equipmentDetail != null) {
      return AppRouteState(
        pane: AppPane.equipment,
        lookupDetailId: equipmentDetail,
      );
    }
    if (path == equipmentPath) {
      return const AppRouteState(pane: AppPane.equipment);
    }
    final assetDetail = _parseLookupDetail(path, assetsPath);
    if (assetDetail != null) {
      return AppRouteState(pane: AppPane.assets, lookupDetailId: assetDetail);
    }
    if (path == assetsPath) {
      return const AppRouteState(pane: AppPane.assets);
    }
    if (path == passPath) {
      return AppRouteState(
        pane: AppPane.pass,
        commonKey: query['commonKey'] ?? '',
        jobId: query['jobId'] ?? '',
        passId: query['passId'] ?? '',
      );
    }
    if (path == qualityPath) {
      return AppRouteState(
        pane: AppPane.quality,
        commonKey: query['commonKey'] ?? '',
        jobId: query['jobId'] ?? '',
        passId: query['passId'] ?? '',
        linkId: query['linkId'] ?? '',
      );
    }
    if (path == historyPath) {
      return const AppRouteState(pane: AppPane.history);
    }

    final multimodalMatch = RegExp(
      r'^/history/detail/([^/]+)/multimodal$',
    ).firstMatch(path);
    if (multimodalMatch != null) {
      final raw = multimodalMatch.group(1)!;
      final jobId = raw == '_' ? '' : Uri.decodeComponent(raw);
      return AppRouteState(
        pane: AppPane.history,
        stack: WorkHistoryStack.videoMultimodal,
        jobId: jobId,
      );
    }

    final detailMatch = RegExp(r'^/history/detail/([^/]+)$').firstMatch(path);
    if (detailMatch != null) {
      final raw = detailMatch.group(1)!;
      final jobId = raw == '_' ? '' : Uri.decodeComponent(raw);
      return AppRouteState(
        pane: AppPane.history,
        stack: WorkHistoryStack.detail,
        jobId: jobId,
      );
    }
    if (path == '$historyPath/pass') {
      return AppRouteState(
        pane: AppPane.history,
        stack: WorkHistoryStack.passProfile,
        commonKey: query['commonKey'] ?? '',
        jobId: query['jobId'] ?? '',
        passId: query['passId'] ?? '',
      );
    }
    if (path == '$historyPath/quality') {
      return AppRouteState(
        pane: AppPane.history,
        stack: WorkHistoryStack.qualityIssue,
        commonKey: query['commonKey'] ?? '',
        jobId: query['jobId'] ?? '',
        passId: query['passId'] ?? '',
        linkId: query['linkId'] ?? '',
        qualityViaDetail: query['via'] == 'detail',
      );
    }
    return null;
  }

  static String? _parseLookupDetail(String path, String base) {
    final match = RegExp(
      '^${RegExp.escape(base)}/([^/]+)\$',
    ).firstMatch(path);
    if (match == null) {
      return null;
    }
    final raw = match.group(1)!;
    return raw == '_' ? '' : Uri.decodeComponent(raw);
  }

  static String _locationWithQuery(String path, Map<String, String> query) {
    if (query.isEmpty) {
      return path;
    }
    return Uri(path: path, queryParameters: query).toString();
  }
}
