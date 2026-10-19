import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/entities/equipment.dart';
import '../../../domain/use_cases/load_work_history_masters_use_case.dart';

class EquipmentLookupViewModel extends ChangeNotifier {
  EquipmentLookupViewModel({
    required LoadWorkHistoryMastersUseCase loadWorkHistoryMastersUseCase,
  }) : _loadWorkHistoryMastersUseCase = loadWorkHistoryMastersUseCase;

  final LoadWorkHistoryMastersUseCase _loadWorkHistoryMastersUseCase;

  String _queryText = '';
  String _lineName = '';
  bool _includeInactive = false;
  List<Equipment> _equipment = const [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  int _loadVersion = 0;

  String get queryText => _queryText;
  String get lineName => _lineName;
  bool get includeInactive => _includeInactive;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;

  List<String> get lineNames {
    final names = <String>{
      for (final item in _equipment)
        if (item.lineName.isNotEmpty) item.lineName,
    };
    final sorted = names.toList()..sort();
    return sorted;
  }

  List<Equipment> get visibleEquipment {
    final query = _queryText.trim().toLowerCase();
    return [
      for (final item in _equipment)
        if ((_includeInactive || !item.isInactive) &&
            (_lineName.isEmpty || item.lineName == _lineName) &&
            (query.isEmpty || _matchesQuery(item, query)))
          item,
    ];
  }

  Future<void> load() async {
    final version = ++_loadVersion;
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    notifyListeners();
    try {
      final catalog = await _loadWorkHistoryMastersUseCase.execute();
      if (version != _loadVersion) {
        return;
      }
      _equipment = catalog.equipments;
    } catch (error) {
      if (version != _loadVersion) {
        return;
      }
      _hasError = true;
      _errorMessage = error.toString();
      _equipment = const [];
    } finally {
      if (version == _loadVersion) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  void didChangeQueryText(String value) {
    if (_queryText == value) {
      return;
    }
    _queryText = value;
    notifyListeners();
  }

  void didSelectLine(String lineName) {
    if (_lineName == lineName) {
      return;
    }
    _lineName = lineName;
    notifyListeners();
  }

  void didToggleIncludeInactive(bool value) {
    if (_includeInactive == value) {
      return;
    }
    _includeInactive = value;
    notifyListeners();
  }

  bool _matchesQuery(Equipment item, String query) {
    return item.equipmentCode.toLowerCase().contains(query) ||
        item.equipmentName.toLowerCase().contains(query) ||
        item.lineName.toLowerCase().contains(query) ||
        item.description.toLowerCase().contains(query);
  }

  @override
  void dispose() {
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
