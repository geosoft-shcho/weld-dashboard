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
        jobId: 'H001',
      );
      expect(state.toLocation(), '/history/detail/H001');
      final parsed = AppRouteState.tryParse(Uri.parse(state.toLocation()));
      expect(parsed?.stack, WorkHistoryStack.detail);
      expect(parsed?.jobId, 'H001');
    });

    test('encodes quality via detail', () {
      const state = AppRouteState(
        pane: AppPane.history,
        stack: WorkHistoryStack.qualityIssue,
        commonKey: 'ck',
        jobId: 'H1',
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

    test('encodes and parses video multimodal without a media url', () {
      const state = AppRouteState(
        pane: AppPane.history,
        stack: WorkHistoryStack.videoMultimodal,
        jobId: 'H001',
      );
      expect(state.toLocation(), '/history/detail/H001/multimodal');
      final parsed = AppRouteState.tryParse(Uri.parse(state.toLocation()));
      expect(parsed?.stack, WorkHistoryStack.videoMultimodal);
      expect(parsed?.jobId, 'H001');
      expect(parsed?.toLocation().contains('file'), isFalse);
    });

    test('encodes lookup panes', () {
      expect(
        const AppRouteState(pane: AppPane.projects).toLocation(),
        '/projects',
      );
      expect(
        const AppRouteState(pane: AppPane.workers).toLocation(),
        '/workers',
      );
      expect(
        const AppRouteState(pane: AppPane.equipment).toLocation(),
        '/equipment',
      );
      expect(
        const AppRouteState(pane: AppPane.assets).toLocation(),
        '/assets',
      );
      expect(
        AppRouteState.tryParse(Uri.parse('/projects'))?.pane,
        AppPane.projects,
      );
      expect(
        AppRouteState.tryParse(Uri.parse('/assets'))?.pane,
        AppPane.assets,
      );
    });

    test('encodes and parses lookup detail paths', () {
      expect(
        const AppRouteState(
          pane: AppPane.projects,
          lookupDetailId: 'P1',
        ).toLocation(),
        '/projects/P1',
      );
      expect(
        const AppRouteState(
          pane: AppPane.workers,
          lookupDetailId: 'W1',
        ).toLocation(),
        '/workers/W1',
      );
      expect(
        const AppRouteState(
          pane: AppPane.equipment,
          lookupDetailId: 'E1',
        ).toLocation(),
        '/equipment/E1',
      );
      expect(
        const AppRouteState(
          pane: AppPane.assets,
          lookupDetailId: 'A1',
        ).toLocation(),
        '/assets/A1',
      );

      final project = AppRouteState.tryParse(Uri.parse('/projects/P1'));
      expect(project?.pane, AppPane.projects);
      expect(project?.lookupDetailId, 'P1');

      final worker = AppRouteState.tryParse(Uri.parse('/workers/W1'));
      expect(worker?.pane, AppPane.workers);
      expect(worker?.lookupDetailId, 'W1');

      final equipment = AppRouteState.tryParse(Uri.parse('/equipment/E1'));
      expect(equipment?.pane, AppPane.equipment);
      expect(equipment?.lookupDetailId, 'E1');

      final asset = AppRouteState.tryParse(Uri.parse('/assets/A1'));
      expect(asset?.pane, AppPane.assets);
      expect(asset?.lookupDetailId, 'A1');
    });

    test('unknown path returns null', () {
      expect(AppRouteState.tryParse(Uri.parse('/unknown')), isNull);
    });
  });
}
