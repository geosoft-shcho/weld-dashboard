import 'package:flutter/services.dart';

import 'csv_parser.dart';

class CsvAssetDataSource {
  CsvAssetDataSource(this._assetBundle);

  final AssetBundle _assetBundle;

  static const List<String> CATALOG_ASSET_PATHS = [
    'assets/data/equipment.csv',
    'assets/data/projects.csv',
    'assets/data/collection_assignments.csv',
    'assets/data/collection_events.csv',
    'assets/data/collection_status.csv',
    'assets/data/work_orders.csv',
    'assets/data/joints.csv',
    'assets/data/workers.csv',
    'assets/data/work_history.csv',
    'assets/data/work_attachments.csv',
    'assets/data/passes.csv',
    'assets/data/waveform_normalized.csv',
    'assets/data/quality_results.csv',
    'assets/data/quality_links.csv',
  ];

  static const String EQUIPMENT_PATH = 'assets/data/equipment.csv';
  static const String PROJECTS_PATH = 'assets/data/projects.csv';
  static const String WORKERS_PATH = 'assets/data/workers.csv';
  static const String ASSIGNMENTS_PATH =
      'assets/data/collection_assignments.csv';
  static const String EVENTS_PATH = 'assets/data/collection_events.csv';
  static const String STATUS_PATH = 'assets/data/collection_status.csv';

  static const String WORK_ORDERS_PATH = 'assets/data/work_orders.csv';
  static const String JOINTS_PATH = 'assets/data/joints.csv';
  static const String WORK_HISTORY_PATH = 'assets/data/work_history.csv';
  static const String PASSES_PATH = 'assets/data/passes.csv';
  static const String WORK_ATTACHMENTS_PATH =
      'assets/data/work_attachments.csv';
  static const String WAVEFORM_PATH = 'assets/data/waveform_normalized.csv';
  static const String QUALITY_RESULTS_PATH =
      'assets/data/quality_results.csv';
  static const String QUALITY_LINKS_PATH = 'assets/data/quality_links.csv';

  Future<Map<String, int>> loadRowCounts() async {
    final countsByAsset = <String, int>{};
    for (final assetPath in CATALOG_ASSET_PATHS) {
      final raw = await _assetBundle.loadString(assetPath);
      countsByAsset[assetPath] = _rowCount(raw);
    }
    return countsByAsset;
  }

  Future<List<Map<String, String>>> loadEquipmentRows() {
    return _loadRows(EQUIPMENT_PATH);
  }

  Future<List<Map<String, String>>> loadProjectRows() {
    return _loadRows(PROJECTS_PATH);
  }

  Future<List<Map<String, String>>> loadWorkerRows() {
    return _loadRows(WORKERS_PATH);
  }

  Future<List<Map<String, String>>> loadAssignmentRows() {
    return _loadRows(ASSIGNMENTS_PATH);
  }

  Future<List<Map<String, String>>> loadEventRows() {
    return _loadRows(EVENTS_PATH);
  }

  Future<List<Map<String, String>>> loadStatusRows() {
    return _loadRows(STATUS_PATH);
  }

  Future<List<Map<String, String>>> loadWorkOrderRows() {
    return _loadRows(WORK_ORDERS_PATH);
  }

  Future<List<Map<String, String>>> loadJointRows() {
    return _loadRows(JOINTS_PATH);
  }

  Future<List<Map<String, String>>> loadWorkHistoryRows() {
    return _loadRows(WORK_HISTORY_PATH);
  }

  Future<List<Map<String, String>>> loadPassRows() {
    return _loadRows(PASSES_PATH);
  }

  Future<List<Map<String, String>>> loadWorkAttachmentRows() {
    return _loadRows(WORK_ATTACHMENTS_PATH);
  }

  Future<List<Map<String, String>>> loadWaveformRows() {
    return _loadRows(WAVEFORM_PATH);
  }

  Future<List<Map<String, String>>> loadQualityResultRows() {
    return _loadRows(QUALITY_RESULTS_PATH);
  }

  Future<List<Map<String, String>>> loadQualityLinkRows() {
    return _loadRows(QUALITY_LINKS_PATH);
  }

  Future<List<Map<String, String>>> _loadRows(String assetPath) async {
    final raw = await _assetBundle.loadString(assetPath);
    return CsvParser.rows(raw);
  }

  int _rowCount(String raw) {
    return CsvParser.rows(raw).length;
  }
}
