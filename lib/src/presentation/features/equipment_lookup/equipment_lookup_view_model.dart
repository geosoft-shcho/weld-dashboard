import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/entities/equipment.dart';
import '../../../domain/use_cases/create_equipment_use_case.dart';
import '../../../domain/use_cases/list_equipment_lookup_use_case.dart';

class EquipmentLookupViewModel extends ChangeNotifier {
  EquipmentLookupViewModel({
    required ListEquipmentLookupUseCase listEquipmentLookupUseCase,
    required CreateEquipmentUseCase createEquipmentUseCase,
  }) : _listEquipmentLookupUseCase = listEquipmentLookupUseCase,
       _createEquipmentUseCase = createEquipmentUseCase;

  final ListEquipmentLookupUseCase _listEquipmentLookupUseCase;
  final CreateEquipmentUseCase _createEquipmentUseCase;

  String _queryText = '';
  bool _includeInactive = false;
  List<Equipment> _equipment = const [];
  String _nextPageToken = '';
  int _totalCount = 0;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasError = false;
  String _errorMessage = '';
  int _loadVersion = 0;
  Timer? _queryDebounce;

  String get queryText => _queryText;
  bool get includeInactive => _includeInactive;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  int get totalCount => _totalCount;
  bool get doesHaveMore => _nextPageToken.isNotEmpty;
  List<Equipment> get equipmentItems => _equipment;

  List<Equipment> get visibleEquipment {
    return [
      for (final item in _equipment)
        if (_includeInactive || !item.isInactive) item,
    ];
  }

  Future<void> load() => _reload(reset: true);

  Future<String> createEquipment({
    required String equipmentName,
    required String equipmentCode,
    required String description,
    required bool isInactive,
  }) {
    return _createEquipmentUseCase.execute(
      equipmentName: equipmentName,
      equipmentCode: equipmentCode,
      description: description,
      isInactive: isInactive,
    );
  }

  Future<void> didScrollNearEnd() async {
    if (_isLoading || _isLoadingMore || _nextPageToken.isEmpty) {
      return;
    }
    await _reload(reset: false);
  }

  void didChangeQueryText(String value) {
    if (_queryText == value) {
      return;
    }
    _queryText = value;
    notifyListeners();
    _queryDebounce?.cancel();
    _queryDebounce = Timer(const Duration(milliseconds: 400), () {
      _reload(reset: true);
    });
  }

  void didToggleIncludeInactive(bool value) {
    if (_includeInactive == value) {
      return;
    }
    _includeInactive = value;
    notifyListeners();
  }

  Future<void> _reload({required bool reset}) async {
    final version = reset ? ++_loadVersion : _loadVersion;
    if (reset) {
      _isLoading = true;
      _isLoadingMore = false;
      _hasError = false;
      _errorMessage = '';
      notifyListeners();
    } else {
      _isLoadingMore = true;
      notifyListeners();
    }
    try {
      final page = await _listEquipmentLookupUseCase.executePage(
        includeInactive: true,
        query: _queryText,
        pageToken: reset ? '' : _nextPageToken,
      );
      if (version != _loadVersion) {
        return;
      }
      _equipment = reset ? page.items : [..._equipment, ...page.items];
      _nextPageToken = page.nextPageToken;
      _totalCount = page.totalCount;
    } catch (error) {
      if (version != _loadVersion) {
        return;
      }
      _hasError = true;
      _errorMessage = error.toString();
      if (reset) {
        _equipment = const [];
        _nextPageToken = '';
        _totalCount = 0;
      }
    } finally {
      if (version == _loadVersion) {
        _isLoading = false;
        _isLoadingMore = false;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _queryDebounce?.cancel();
    _loadVersion++;
    super.dispose();
  }
}

String equipmentNameCell(Equipment item) {
  if (item.isInactive) {
    return '${item.equipmentName} · 숨김';
  }
  return item.equipmentName;
}
