import '../../domain/entities/pass_waveform_catalog.dart';
import '../../domain/entities/quality_link.dart';
import '../../domain/entities/quality_result_group.dart';
import '../../domain/entities/quality_result_item.dart';
import '../../domain/entities/weld_pass.dart';
import '../../domain/entities/waveform_row.dart';
import '../../domain/repositories/pass_waveform_repository.dart';
import '../../domain/repositories/work_history_repository.dart';
import '../datasources/local/csv_asset_data_source.dart';
import '../models/quality_link_dto.dart';
import '../models/quality_result_row_dto.dart';
import '../models/weld_pass_dto.dart';
import '../models/waveform_row_dto.dart';

class PassWaveformRepositoryImpl implements PassWaveformRepository {
  PassWaveformRepositoryImpl({
    required WorkHistoryRepository workHistoryRepository,
    required CsvAssetDataSource csvAssetDataSource,
  }) : _workHistoryRepository = workHistoryRepository,
       _csvAssetDataSource = csvAssetDataSource;

  final WorkHistoryRepository _workHistoryRepository;
  final CsvAssetDataSource _csvAssetDataSource;

  @override
  Future<PassWaveformCatalog> loadCatalog() async {
    final history = await _workHistoryRepository.loadCatalog();
    final passRows = await _csvAssetDataSource.loadPassRows();
    final waveformRows = await _csvAssetDataSource.loadWaveformRows();
    final linkRows = await _csvAssetDataSource.loadQualityLinkRows();
    final qualityRows = await _csvAssetDataSource.loadQualityResultRows();
    final passes = <WeldPass>[];
    for (final row in passRows) {
      final pass = WeldPassDto.fromRow(row).toDomain();
      if (pass != null) {
        passes.add(pass);
      }
    }
    final waveforms = <WaveformRow>[];
    for (final row in waveformRows) {
      final sample = WaveformRowDto.fromRow(row).toDomain();
      if (sample != null) {
        waveforms.add(sample);
      }
    }
    final links = <QualityLink>[];
    for (final row in linkRows) {
      final link = QualityLinkDto.fromRow(row).toDomain();
      if (link != null) {
        links.add(link);
      }
    }
    return PassWaveformCatalog(
      passes: passes,
      waveformRows: waveforms,
      links: links,
      qualityGroups: _groupsFrom(qualityRows),
      historyItems: history.items,
      workers: history.workers,
    );
  }

  List<QualityResultGroup> _groupsFrom(List<Map<String, String>> rows) {
    final order = <String>[];
    final seedsById = <String, QualityResultRowDto>{};
    final itemsById = <String, List<QualityResultItem>>{};
    for (final row in rows) {
      final dto = QualityResultRowDto.fromRow(row);
      if (dto.qualityResultId.isEmpty) {
        continue;
      }
      if (!seedsById.containsKey(dto.qualityResultId)) {
        order.add(dto.qualityResultId);
        seedsById[dto.qualityResultId] = dto;
        itemsById[dto.qualityResultId] = [];
      }
      itemsById[dto.qualityResultId]!.add(dto.toItem());
    }
    return [
      for (final id in order)
        seedsById[id]!.toGroupSeed(itemsById[id] ?? const []),
    ];
  }
}
