import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/data/datasources/local/csv_asset_data_source.dart';
import 'package:weld_dashboard/src/data/repositories/pass_waveform_repository_impl.dart';
import 'package:weld_dashboard/src/data/repositories/work_history_repository_impl.dart';
import 'package:weld_dashboard/src/domain/use_cases/query_pass_profile_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/query_quality_issue_use_case.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late PassWaveformRepositoryImpl repository;

  setUp(() {
    final csv = CsvAssetDataSource(rootBundle);
    repository = PassWaveformRepositoryImpl(
      workHistoryRepository: WorkHistoryRepositoryImpl(csv),
      csvAssetDataSource: csv,
    );
  });

  test('J-A-14 pass profile has 3 passes and series', () async {
    final catalog = await repository.loadCatalog();
    final board = QueryPassProfileUseCase().execute(
      catalog: catalog,
      commonKey: 'WO-2026-0312|J-A-14',
      historyId: 'H001',
    );
    expect(board.doesHaveCommonKey, isTrue);
    expect(board.passes.map((p) => p.passId), [
      'P-A14-1',
      'P-A14-2',
      'P-A14-3',
    ]);
    expect(board.selectedPass?.passId, 'P-A14-1');
    expect(board.series.doesHaveAnySeries, isTrue);
    expect(board.links, isNotEmpty);

    final fill = QueryPassProfileUseCase().execute(
      catalog: catalog,
      commonKey: 'WO-2026-0312|J-A-14',
      historyId: 'H001',
      passId: 'P-A14-2',
    );
    expect(fill.mastersForPass.length, greaterThanOrEqualTo(1));
    expect(fill.compareStats.currentBeginner.isComparable, isTrue);
  });

  test('J-A-14 quality issue has scan PDF and allLinks', () async {
    final catalog = await repository.loadCatalog();
    final board = QueryQualityIssueUseCase().execute(
      catalog: catalog,
      commonKey: 'WO-2026-0312|J-A-14',
      historyId: 'H001',
    );
    expect(board.doesHaveCommonKey, isTrue);
    expect(board.allLinks.length, 3);
    expect(board.selectedGroup?.scanFile, contains('connection_beam_ndt'));
    expect(board.selectedGroup?.scanPages, 8);
    expect(board.series.doesHaveAnySeries, isTrue);
    expect(board.selectedLink?.linkId, 'L001');
  });

  test('J-D-09 quality issue has meta only and empty scan', () async {
    final catalog = await repository.loadCatalog();
    final board = QueryQualityIssueUseCase().execute(
      catalog: catalog,
      commonKey: 'WO-2026-0412|J-D-09',
      historyId: 'H007',
    );
    expect(board.doesHaveCommonKey, isTrue);
    expect(board.allLinks, isEmpty);
    expect(board.links, isEmpty);
    expect(board.selectedGroup?.paperDocNo, 'PAP-260903-009');
    expect(board.selectedGroup?.scanFile.trim(), isEmpty);
    expect(board.series.doesHaveAnySeries, isFalse);
  });

  test('empty key stays empty without snapshot auto-pick', () async {
    final catalog = await repository.loadCatalog();
    final board = QueryPassProfileUseCase().execute(
      catalog: catalog,
      commonKey: '',
      historyId: '',
    );
    expect(board.commonKey, isEmpty);
    expect(board.doesHaveCommonKey, isFalse);
  });
}
