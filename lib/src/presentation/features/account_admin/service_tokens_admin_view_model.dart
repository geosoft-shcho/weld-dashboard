import 'package:connectrpc/connect.dart';
import 'package:fluent_ui/fluent_ui.dart';

import '../../../domain/entities/account_admin.dart';
import '../../../domain/repositories/account_admin_repository.dart';

class ServiceTokensAdminViewModel extends ChangeNotifier {
  ServiceTokensAdminViewModel({required AccountAdminRepository repository})
    : _repository = repository;

  final AccountAdminRepository _repository;

  List<ServiceTokenRow> _tokens = const [];
  bool _hasLoaded = false;
  bool _isLoading = false;
  String _errorMessage = '';

  List<ServiceTokenRow> get tokens => _tokens;
  bool get hasLoaded => _hasLoaded;
  bool get isLoading => _isLoading;
  bool get hasError => _errorMessage.isNotEmpty;
  String get errorMessage => _errorMessage;

  Future<void> load() async {
    if (_isLoading) {
      return;
    }
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _tokens = await _repository.listServiceTokens();
      _hasLoaded = true;
    } catch (error) {
      _errorMessage = _messageOf(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<CreatedServiceToken?> createToken({required String name}) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw StateError('연동 이름을 넣으세요.');
    }
    final created = await _repository.createServiceToken(name: trimmed);
    await load();
    return created;
  }

  Future<String?> revokeToken({required ServiceTokenRow token}) async {
    try {
      await _repository.revokeServiceToken(tokenId: token.tokenId);
      await load();
      return null;
    } catch (error) {
      return _messageOf(error);
    }
  }

  String _messageOf(Object error) {
    if (error is ConnectException) {
      return error.message.isNotEmpty ? error.message : error.toString();
    }
    return error.toString();
  }
}
