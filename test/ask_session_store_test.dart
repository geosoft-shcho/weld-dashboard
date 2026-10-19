import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/data/repositories/browser_ask_session_store.dart';

void main() {
  test('browser ask session store keeps a session id by job', () async {
    final store = BrowserAskSessionStore();
    await store.clearSessionId(jobId: 'job-a');
    await store.writeSessionId(jobId: 'job-a', sessionId: 's1');
    expect(await store.readSessionId(jobId: 'job-a'), 's1');
    expect(await store.readSessionId(jobId: 'job-b'), '');
    await store.clearSessionId(jobId: 'job-a');
    expect(await store.readSessionId(jobId: 'job-a'), '');
  });

  test('empty job or session id is ignored', () async {
    final store = BrowserAskSessionStore();
    await store.writeSessionId(jobId: '', sessionId: 's1');
    await store.writeSessionId(jobId: 'job-a', sessionId: '');
    expect(await store.readSessionId(jobId: ''), '');
    expect(await store.readSessionId(jobId: 'job-a'), '');
  });
}
