import 'package:flutter/foundation.dart';

import '../../../domain/entities/catalog_snapshot.dart';
import '../../../domain/entities/preview_state.dart';
import '../../../domain/use_cases/load_catalog_use_case.dart';

class ShellViewModel extends ChangeNotifier {
  ShellViewModel({
    required LoadCatalogUseCase loadCatalogUseCase,
    required bool pdfrxReady,
  }) : _loadCatalogUseCase = loadCatalogUseCase,
       _pdfrxReady = pdfrxReady;

  final LoadCatalogUseCase _loadCatalogUseCase;
  final bool _pdfrxReady;

  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  CatalogSnapshot? _catalog;
  PreviewState _previewState = PreviewState.live;

  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  CatalogSnapshot? get catalog => _catalog;
  PreviewState get previewState => _previewState;
  bool get pdfrxReady => _pdfrxReady;

  Future<void> loadCatalog() async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    notifyListeners();
    try {
      _catalog = await _loadCatalogUseCase.execute(pdfrxReady: _pdfrxReady);
    } catch (error) {
      _hasError = true;
      _errorMessage = error.toString();
      _catalog = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void didSelectPreviewState(PreviewState previewState) {
    if (_previewState == previewState) {
      return;
    }
    _previewState = previewState;
    notifyListeners();
  }
}
