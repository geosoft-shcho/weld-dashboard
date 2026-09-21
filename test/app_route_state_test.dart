import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/presentation/navigation/app_coordinator.dart';
import 'package:weld_dashboard/src/presentation/navigation/app_route_state.dart';

void main() {
  group('AppRouteState', () {
    test('encodes and parses collection', () {
      const state = AppRouteState(pane: AppPane.collection);
      expect(state.toLocation(), '/collection');
      expect(
        AppRouteState.tryParse(Uri.parse('/collection'))?.pane,
        AppPane.collection,
      );
    });

    test('encodes and parses history detail', () {
      const state = AppRouteState(
        pane: AppPane.history,
        stack: WorkHistoryStack.detail,
        historyId: 'H001',
      );
      expect(state.toLocation(), '/history/detail/H001');
      final parsed = AppRouteState.tryParse(Uri.parse(state.toLocation()));
      expect(parsed?.stack, WorkHistoryStack.detail);
      expect(parsed?.historyId, 'H001');
    });

    test('encodes quality via detail', () {
      const state = AppRouteState(
        pane: AppPane.history,
        stack: WorkHistoryStack.qualityIssue,
        commonKey: 'ck',
        historyId: 'H1',
        passId: 'P1',
        linkId: 'L1',
        qualityViaDetail: true,
      );
      final location = state.toLocation();
      expect(location, contains('via=detail'));
      final parsed = AppRouteState.tryParse(Uri.parse(location));
      expect(parsed?.qualityViaDetail, isTrue);
      expect(parsed?.linkId, 'L1');
    });

    test('unknown path returns null', () {
      expect(AppRouteState.tryParse(Uri.parse('/unknown')), isNull);
    });
  });
}
