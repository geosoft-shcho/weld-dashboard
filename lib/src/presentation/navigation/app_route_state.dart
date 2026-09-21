import 'app_coordinator.dart';

enum AppPane {
  collection,
  history,
  pass,
  quality,
}

/// Parsed dashboard location. Shell UI still reads [AppCoordinator]; this only
/// maps path ↔ coordinator fields for browser history.
class AppRouteState {
  const AppRouteState({
    required this.pane,
    this.stack = WorkHistoryStack.list,
    this.historyId = '',
    this.commonKey = '',
    this.passId = '',
    this.linkId = '',
    this.qualityViaDetail = false,
  });

  final AppPane pane;
  final WorkHistoryStack stack;
  final String historyId;
  final String commonKey;
  final String passId;
  final String linkId;

  /// When [stack] is [WorkHistoryStack.qualityIssue], true means previous
  /// screen was detail (not pass profile).
  final bool qualityViaDetail;

  static const String collectionPath = '/collection';
  static const String historyPath = '/history';
  static const String passPath = '/pass';
  static const String qualityPath = '/quality';

  String toLocation() {
    switch (pane) {
      case AppPane.collection:
        return collectionPath;
      case AppPane.pass:
        return _locationWithQuery(passPath, {
          if (commonKey.isNotEmpty) 'commonKey': commonKey,
          if (historyId.isNotEmpty) 'historyId': historyId,
          if (passId.isNotEmpty) 'passId': passId,
        });
      case AppPane.quality:
        return _locationWithQuery(qualityPath, {
          if (commonKey.isNotEmpty) 'commonKey': commonKey,
          if (historyId.isNotEmpty) 'historyId': historyId,
          if (passId.isNotEmpty) 'passId': passId,
          if (linkId.isNotEmpty) 'linkId': linkId,
        });
      case AppPane.history:
        switch (stack) {
          case WorkHistoryStack.list:
            return historyPath;
          case WorkHistoryStack.detail:
            final id = historyId.isEmpty ? '_' : Uri.encodeComponent(historyId);
            return '$historyPath/detail/$id';
          case WorkHistoryStack.passProfile:
            return _locationWithQuery('$historyPath/pass', {
              if (commonKey.isNotEmpty) 'commonKey': commonKey,
              if (historyId.isNotEmpty) 'historyId': historyId,
              if (passId.isNotEmpty) 'passId': passId,
            });
          case WorkHistoryStack.qualityIssue:
            return _locationWithQuery('$historyPath/quality', {
              if (commonKey.isNotEmpty) 'commonKey': commonKey,
              if (historyId.isNotEmpty) 'historyId': historyId,
              if (passId.isNotEmpty) 'passId': passId,
              if (linkId.isNotEmpty) 'linkId': linkId,
              if (qualityViaDetail) 'via': 'detail',
            });
        }
    }
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
    if (path == passPath) {
      return AppRouteState(
        pane: AppPane.pass,
        commonKey: query['commonKey'] ?? '',
        historyId: query['historyId'] ?? '',
        passId: query['passId'] ?? '',
      );
    }
    if (path == qualityPath) {
      return AppRouteState(
        pane: AppPane.quality,
        commonKey: query['commonKey'] ?? '',
        historyId: query['historyId'] ?? '',
        passId: query['passId'] ?? '',
        linkId: query['linkId'] ?? '',
      );
    }
    if (path == historyPath) {
      return const AppRouteState(pane: AppPane.history);
    }

    final detailMatch = RegExp(r'^/history/detail/([^/]+)$').firstMatch(path);
    if (detailMatch != null) {
      final raw = detailMatch.group(1)!;
      final historyId = raw == '_' ? '' : Uri.decodeComponent(raw);
      return AppRouteState(
        pane: AppPane.history,
        stack: WorkHistoryStack.detail,
        historyId: historyId,
      );
    }
    if (path == '$historyPath/pass') {
      return AppRouteState(
        pane: AppPane.history,
        stack: WorkHistoryStack.passProfile,
        commonKey: query['commonKey'] ?? '',
        historyId: query['historyId'] ?? '',
        passId: query['passId'] ?? '',
      );
    }
    if (path == '$historyPath/quality') {
      return AppRouteState(
        pane: AppPane.history,
        stack: WorkHistoryStack.qualityIssue,
        commonKey: query['commonKey'] ?? '',
        historyId: query['historyId'] ?? '',
        passId: query['passId'] ?? '',
        linkId: query['linkId'] ?? '',
        qualityViaDetail: query['via'] == 'detail',
      );
    }
    return null;
  }

  static String _locationWithQuery(String path, Map<String, String> query) {
    if (query.isEmpty) {
      return path;
    }
    return Uri(path: path, queryParameters: query).toString();
  }
}
