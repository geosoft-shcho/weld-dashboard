abstract class AskSessionStore {
  Future<String> readSessionId({required String jobId});

  Future<void> writeSessionId({
    required String jobId,
    required String sessionId,
  });

  Future<void> clearSessionId({required String jobId});
}
