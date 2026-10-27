import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/entities/asset_lookup_row.dart';
import '../../../domain/entities/asset_upload.dart';
import '../../../domain/entities/camera_recording.dart';
import '../../../domain/entities/equipment.dart';
import '../../../domain/entities/work_history_item.dart';
import '../../../domain/entities/work_history_query.dart';
import '../../../domain/use_cases/list_asset_lookup_page_use_case.dart';
import '../../../domain/use_cases/list_equipment_lookup_use_case.dart';
import '../../../domain/use_cases/list_upload_formats_use_case.dart';
import '../../../domain/use_cases/list_work_history_page_use_case.dart';
import '../../../domain/use_cases/upload_asset_queue_use_case.dart';
import '../../../domain/use_cases/upload_asset_use_case.dart';

class AssetLookupViewModel extends ChangeNotifier {
  AssetLookupViewModel({
    required ListAssetLookupPageUseCase listAssetLookupPageUseCase,
    required ListEquipmentLookupUseCase listEquipmentLookupUseCase,
    required ListWorkHistoryPageUseCase listWorkHistoryPageUseCase,
    required ListUploadFormatsUseCase listUploadFormatsUseCase,
    required UploadAssetUseCase uploadAssetUseCase,
    required UploadAssetQueueUseCase uploadAssetQueueUseCase,
  }) : _listAssetLookupPageUseCase = listAssetLookupPageUseCase,
       _listEquipmentLookupUseCase = listEquipmentLookupUseCase,
       _listWorkHistoryPageUseCase = listWorkHistoryPageUseCase,
       _listUploadFormatsUseCase = listUploadFormatsUseCase,
       _uploadAssetUseCase = uploadAssetUseCase,
       _uploadAssetQueueUseCase = uploadAssetQueueUseCase;

  static const int pageSize = WorkHistoryQuery.BATCH_SIZE;

  final ListAssetLookupPageUseCase _listAssetLookupPageUseCase;
  final ListEquipmentLookupUseCase _listEquipmentLookupUseCase;
  final ListWorkHistoryPageUseCase _listWorkHistoryPageUseCase;
  final ListUploadFormatsUseCase _listUploadFormatsUseCase;
  final UploadAssetUseCase _uploadAssetUseCase;
  final UploadAssetQueueUseCase _uploadAssetQueueUseCase;

  String _kindCode = '';
  String _fileNameText = '';
  String _equipmentId = '';
  String _jobId = '';
  String _passId = '';
  bool _unattachedOnly = false;
  List<Equipment> _equipment = const [];
  List<WorkHistoryItem> _jobs = const [];
  String _jobsNextPageToken = '';
  List<JobPassOption> _passes = const [];
  List<AssetLookupRow> _rows = const [];
  String _nextPageToken = '';
  int _totalCount = 0;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasError = false;
  String _errorMessage = '';
  int _loadVersion = 0;
  int _moreVersion = 0;
  Timer? _fileNameDebounce;

  String get kindCode => _kindCode;
  String get fileNameText => _fileNameText;
  String get equipmentId => _equipmentId;
  String get jobId => _jobId;
  String get passId => _passId;
  bool get unattachedOnly => _unattachedOnly;
  List<Equipment> get equipment => _equipment;
  List<WorkHistoryItem> get jobs => _jobs;
  List<JobPassOption> get passes => _passes;
  bool get doesHaveMoreJobs => _jobsNextPageToken.isNotEmpty;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  int get totalCount => _totalCount;
  bool get doesHaveMore => _nextPageToken.isNotEmpty;

  List<AssetLookupRow> get visibleRows => _rows;

  bool get _sharedOnly => _passId == jobCommonPassToken;

  int get _passNo {
    if (_passId.isEmpty || _sharedOnly) {
      return 0;
    }
    for (final pass in _passes) {
      if (pass.passId == _passId) {
        return pass.passNo;
      }
    }
    return 0;
  }

  String equipmentNameOf(String equipmentId) {
    if (equipmentId.isEmpty) {
      return '—';
    }
    for (final item in _equipment) {
      if (item.equipmentId == equipmentId) {
        return item.equipmentName.isEmpty
            ? item.equipmentCode
            : item.equipmentName;
      }
    }
    return equipmentId;
  }

  String passLabelOf(AssetLookupRow row) {
    if (row.attachmentPassId.isEmpty) {
      return '';
    }
    if (row.attachmentPassId == jobCommonPassToken) {
      return '공용';
    }
    for (final pass in _passes) {
      if (pass.passId == row.attachmentPassId) {
        return '${pass.passNo}패스';
      }
    }
    return row.attachmentPassId;
  }

  Future<void> load() async {
    final version = ++_loadVersion;
    _moreVersion++;
    _isLoading = true;
    _isLoadingMore = false;
    _hasError = false;
    _errorMessage = '';
    notifyListeners();
    try {
      final equipment = await _listEquipmentLookupUseCase.execute();
      final jobs = await _listWorkHistoryPageUseCase.execute(
        query: WorkHistoryQuery.initial(),
        pageSize: 200,
        pageToken: '',
      );
      if (version != _loadVersion) {
        return;
      }
      _equipment = equipment;
      _jobs = jobs.items;
      _jobsNextPageToken = jobs.nextPageToken;
      await _reloadRows(version);
    } catch (error) {
      if (version != _loadVersion) {
        return;
      }
      _hasError = true;
      _errorMessage = error.toString();
      _rows = const [];
    } finally {
      if (version == _loadVersion) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> didTapLoadMoreJobs() async {
    if (_jobsNextPageToken.isEmpty || _isLoading) {
      return;
    }
    final version = _loadVersion;
    try {
      final page = await _listWorkHistoryPageUseCase.execute(
        query: WorkHistoryQuery.initial(),
        pageSize: 200,
        pageToken: _jobsNextPageToken,
      );
      if (version != _loadVersion) {
        return;
      }
      final existing = {for (final job in _jobs) job.jobId};
      _jobs = [
        ..._jobs,
        for (final job in page.items)
          if (!existing.contains(job.jobId)) job,
      ];
      _jobsNextPageToken = page.nextPageToken;
      notifyListeners();
    } catch (error) {
      if (version != _loadVersion) {
        return;
      }
      _hasError = true;
      _errorMessage = error.toString();
      notifyListeners();
    }
  }

  void didChangeFileName(String value) {
    if (_fileNameText == value) {
      return;
    }
    _fileNameText = value;
    notifyListeners();
    _fileNameDebounce?.cancel();
    _fileNameDebounce = Timer(const Duration(milliseconds: 400), () {
      _reloadListAssets();
    });
  }

  void didSelectKind(String kindCode) {
    if (_kindCode == kindCode) {
      return;
    }
    _kindCode = kindCode;
    _reloadListAssets();
  }

  void didSelectEquipment(String equipmentId) {
    if (_equipmentId == equipmentId) {
      return;
    }
    _equipmentId = equipmentId;
    _reloadListAssets();
  }

  void didToggleUnattachedOnly(bool value) {
    if (_unattachedOnly == value) {
      return;
    }
    _unattachedOnly = value;
    _reloadListAssets();
  }

  Future<void> didSelectJob(String jobId) async {
    if (_jobId == jobId) {
      return;
    }
    _jobId = jobId;
    _passId = '';
    _passes = passesOf(jobId);
    if (jobId.isNotEmpty) {
      _unattachedOnly = false;
    }
    final version = ++_loadVersion;
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    notifyListeners();
    try {
      await _reloadRows(version);
    } catch (error) {
      if (version != _loadVersion) {
        return;
      }
      _hasError = true;
      _errorMessage = error.toString();
      _rows = const [];
    } finally {
      if (version == _loadVersion) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> didSelectPass(String passId) async {
    if (_passId == passId) {
      return;
    }
    _passId = passId;
    final version = ++_loadVersion;
    _isLoading = true;
    _hasError = false;
    notifyListeners();
    try {
      await _reloadRows(version);
    } catch (error) {
      if (version != _loadVersion) {
        return;
      }
      _hasError = true;
      _errorMessage = error.toString();
      _rows = const [];
    } finally {
      if (version == _loadVersion) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> didScrollNearEnd() async {
    if (!doesHaveMore || _isLoading || _isLoadingMore) {
      return;
    }
    final version = ++_moreVersion;
    final loadVersion = _loadVersion;
    final pageToken = _nextPageToken;
    _isLoadingMore = true;
    notifyListeners();
    try {
      final page = await _listAssetLookupPageUseCase.execute(
        kindCode: _kindCode,
        query: _fileNameText,
        equipmentId: _equipmentId,
        unattachedOnly: _unattachedOnly,
        jobId: _jobId,
        passNo: _passNo,
        sharedOnly: _sharedOnly,
        pageSize: pageSize,
        pageToken: pageToken,
      );
      if (version != _moreVersion || loadVersion != _loadVersion) {
        return;
      }
      final existing = {for (final row in _rows) row.assetId};
      _rows = [
        ..._rows,
        for (final row in page.rows)
          if (!existing.contains(row.assetId)) row,
      ];
      _nextPageToken = page.nextPageToken;
      _totalCount = page.totalCount;
    } catch (_) {
      // 이어 받기 실패는 이미 받은 목록을 유지한다.
    } finally {
      if (version == _moreVersion) {
        _isLoadingMore = false;
        notifyListeners();
      }
    }
  }

  Future<AssetUploadFormats> loadUploadFormats() {
    return _listUploadFormatsUseCase.execute();
  }

  List<JobPassOption> passesOf(String jobId) {
    for (final job in _jobs) {
      if (job.jobId == jobId) {
        return job.passes;
      }
    }
    return const [];
  }

  Future<CameraRecordingFile?> pickUploadFile() {
    return _uploadAssetUseCase.pickFile();
  }

  Future<List<CameraRecordingFile>> pickUploadFiles() {
    return _uploadAssetUseCase.pickFiles();
  }

  Future<AssetUploadResult> uploadAssetFile({
    required String jobId,
    required String passId,
    required String equipmentId,
    required DateTime? timeOrigin,
    required CameraRecordingFile file,
    String subject = '',
    String situation = '',
  }) {
    return _uploadAssetUseCase.uploadFile(
      jobId: jobId,
      passId: passId,
      equipmentId: equipmentId,
      timeOrigin: timeOrigin,
      file: file,
      subject: subject,
      situation: situation,
    );
  }

  Future<AssetUploadBatchResult> uploadAssetQueue({
    required String jobId,
    required String passId,
    required String equipmentId,
    required List<AssetUploadQueueEntry> entries,
    required void Function(AssetUploadQueueItem item) onItemUpdated,
    String subject = '',
    String situation = '',
  }) {
    return _uploadAssetQueueUseCase.execute(
      jobId: jobId,
      passId: passId,
      equipmentId: equipmentId,
      entries: entries,
      onItemUpdated: onItemUpdated,
      subject: subject,
      situation: situation,
    );
  }

  Future<void> _reloadListAssets() async {
    final version = ++_loadVersion;
    _moreVersion++;
    _isLoading = true;
    _hasError = false;
    notifyListeners();
    try {
      await _reloadRows(version);
    } catch (error) {
      if (version != _loadVersion) {
        return;
      }
      _hasError = true;
      _errorMessage = error.toString();
      _rows = const [];
    } finally {
      if (version == _loadVersion) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> _reloadRows(int version) async {
    final page = await _listAssetLookupPageUseCase.execute(
      kindCode: _kindCode,
      query: _fileNameText,
      equipmentId: _equipmentId,
      unattachedOnly: _unattachedOnly,
      jobId: _jobId,
      passNo: _passNo,
      sharedOnly: _sharedOnly,
      pageSize: pageSize,
      pageToken: '',
    );
    if (version != _loadVersion) {
      return;
    }
    _rows = page.rows;
    _nextPageToken = page.nextPageToken;
    _totalCount = page.totalCount;
  }

  @override
  void dispose() {
    _fileNameDebounce?.cancel();
    _loadVersion++;
    _moreVersion++;
    super.dispose();
  }
}

String assetStatusText(
  AssetLookupRow row, {
  required String passLabel,
  required bool isJobScoped,
}) {
  final labels = <String>[];
  if (isJobScoped) {
    if (passLabel.isNotEmpty) {
      labels.add(passLabel);
    }
    if (row.isAttached) {
      labels.add('첨부');
    }
  } else if (row.isUnattached) {
    labels.add('작업 미지정');
  } else if (row.isAttached) {
    labels.add('첨부');
  }
  if (row.isDerived) {
    labels.add('파생');
  } else if (row.childCount > 0) {
    labels.add('파생 ${row.childCount}');
  }
  if (labels.isEmpty) {
    return '—';
  }
  return labels.join(' · ');
}
