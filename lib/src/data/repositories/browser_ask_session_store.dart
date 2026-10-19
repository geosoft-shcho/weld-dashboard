import '../../domain/repositories/ask_session_store.dart';
import '../datasources/ask_session_local_storage.dart';

class BrowserAskSessionStore implements AskSessionStore {
  static const String _KEY_PREFIX = 'ask_session:';

  String _key(String jobId) => '$_KEY_PREFIX$jobId';

  @override
  Future<String> readSessionId({required String jobId}) async {
    final id = jobId.trim();
    if (id.isEmpty) {
      return '';
    }
    return readAskSessionValue(_key(id))?.trim() ?? '';
  }

  @override
  Future<void> writeSessionId({
    required String jobId,
    required String sessionId,
  }) async {
    final id = jobId.trim();
    final session = sessionId.trim();
    if (id.isEmpty || session.isEmpty) {
      return;
    }
    writeAskSessionValue(_key(id), session);
  }

  @override
  Future<void> clearSessionId({required String jobId}) async {
    final id = jobId.trim();
    if (id.isEmpty) {
      return;
    }
    removeAskSessionValue(_key(id));
  }
}
