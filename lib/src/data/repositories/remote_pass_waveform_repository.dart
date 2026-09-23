import '../../domain/entities/pass_waveform_catalog.dart';
import '../../domain/entities/pass_joint_context.dart';
import '../../domain/entities/quality_link.dart';
import '../../domain/entities/quality_media.dart';
import '../../domain/entities/quality_media_tab.dart';
import '../../domain/entities/quality_result_group.dart';
import '../../domain/entities/quality_result_item.dart';
import '../../domain/entities/series_role.dart';
import '../../domain/entities/waveform_row.dart';
import '../../domain/entities/weld_pass.dart';
import '../../domain/entities/worker.dart';
import '../../domain/repositories/pass_waveform_repository.dart';
import '../datasources/generated/dashboard_service.pb.dart' as pb;
import '../datasources/remote/dashboard_service_data_source.dart';
import 'remote_work_history_repository.dart';

class RemotePassWaveformRepository implements PassWaveformRepository {
  RemotePassWaveformRepository(this._source);

  final DashboardServiceDataSource _source;

  @override
  Future<PassWaveformCatalog> loadCatalog({
    String commonKey = '',
    String historyId = '',
    String passId = '',
    String normalize = 'raw',
  }) async {
    final histories = await _source.client.listWorkHistory(
      pb.ListWorkHistoryRequest(
        historyId: historyId,
        commonKey: historyId.isEmpty ? commonKey : '',
      ),
    );
    final key = commonKey.isNotEmpty
        ? commonKey
        : (histories.items.isEmpty ? '' : histories.items.first.commonKey);
    final workers = await _source.client.listWorkers(pb.ListWorkersRequest());
    final passesResponse = await _source.client.listPasses(
      pb.ListPassesRequest(commonKey: key),
    );
    final passes = [
      for (final item in passesResponse.items)
        WeldPass(
          passId: item.passId,
          commonKey: item.commonKey,
          passNo: item.passNo,
          passName: item.passName,
          masterProfileId: item.masterProfileId,
          controlWorkerId: item.controlWorkerId,
        ),
    ];
    final selectedPassId = passId.isNotEmpty
        ? passId
        : (key.isNotEmpty && passes.isNotEmpty ? passes.first.passId : '');
    final waveforms = <WaveformRow>[];
    if (selectedPassId.isNotEmpty) {
      final response = await _source.client.getPassWaveform(
        pb.GetPassWaveformRequest(passId: selectedPassId, normalize: normalize),
      );
      for (final series in response.series) {
        final role = SeriesRole.fromCsv(series.role);
        if (role == null) continue;
        for (final point in series.points) {
          waveforms.add(
            WaveformRow(
              seriesId: '${selectedPassId}_${series.role}',
              passId: selectedPassId,
              commonKey: response.commonKey,
              seriesRole: role,
              masterProfileId: series.masterProfileId,
              workerId: series.workerId,
              robotId: series.robotId,
              timeMs: point.t,
              currentA: point.hasCurrentA() ? point.currentA : null,
              voltageV: point.hasVoltageV() ? point.voltageV : null,
              speedValue: point.hasWireFeedSpeedMpm()
                  ? point.wireFeedSpeedMpm
                  : null,
              rotationSpeedRpm: point.hasRotationSpeedRpm()
                  ? point.rotationSpeedRpm
                  : null,
            ),
          );
        }
      }
    }
    final linksResponse = await _source.client.listQualityLinks(
      pb.ListQualityLinksRequest(commonKey: key),
    );
    final resultsResponse = await _source.client.listQualityResults(
      pb.ListQualityResultsRequest(commonKey: key),
    );
    final contextResponse = key.isEmpty
        ? null
        : await _source.client.getContext(pb.GetContextRequest(commonKey: key));
    final context = contextResponse?.context;
    return PassWaveformCatalog(
      passes: passes,
      waveformRows: waveforms,
      links: [
        for (final item in linksResponse.items)
          QualityLink(
            linkId: item.linkId,
            commonKey: item.commonKey,
            qualityResultId: item.qualityResultId,
            passId: item.passId,
            segmentId: item.segmentId,
            startMs: item.segmentStartMs,
            endMs: item.segmentEndMs,
            note: item.note,
          ),
      ],
      qualityGroups: _qualityGroups(resultsResponse.items),
      historyItems: [
        for (final item in histories.items) workHistoryItemFrom(item),
      ],
      workers: [
        for (final item in workers.items)
          Worker(workerId: item.workerId, workerName: item.workerName),
      ],
      context: context == null
          ? null
          : PassJointContext(
              commonKey: context.commonKey,
              workOrderNo: context.workOrderNo,
              title: context.title,
              jointNo: context.jointNo,
              jointName: context.jointName,
              workerName: context.workerName,
              equipmentName: context.equipmentName,
            ),
    );
  }

  List<QualityResultGroup> _qualityGroups(List<pb.QualityResult> results) {
    final rowsById = <String, List<pb.QualityResult>>{};
    for (final result in results) {
      rowsById.putIfAbsent(result.qualityResultId, () => []).add(result);
    }
    return [for (final rows in rowsById.values) _qualityGroup(rows)];
  }

  QualityResultGroup _qualityGroup(List<pb.QualityResult> rows) {
    final first = rows.first;
    final media = <QualityMedia>[];
    final seen = <String>{};
    for (final row in rows) {
      for (final item in row.media) {
        final type = switch (item.mediaType) {
          'scan' => QualityMediaTab.pdf,
          'video' => QualityMediaTab.video,
          _ => null,
        };
        if (type == null ||
            !seen.add('${item.mediaType}:${item.filePath}:${item.url}')) {
          continue;
        }
        media.add(
          QualityMedia(
            type: type,
            url: item.url.trim().isEmpty
                ? ''
                : _source.resolveFileUrl(item.url.trim()),
            filePath: item.filePath,
            pageCount: item.pageCount,
          ),
        );
      }
    }
    final scan = media
        .where((item) => item.type == QualityMediaTab.pdf)
        .firstOrNull;
    final video = media
        .where((item) => item.type == QualityMediaTab.video)
        .firstOrNull;
    return QualityResultGroup(
      qualityResultId: first.qualityResultId,
      paperDocNo: first.paperDocNo,
      commonKey: first.commonKey,
      passId: first.passId,
      segmentId: first.segmentId,
      inspectedAt: first.inspectedAt,
      inspectorName: first.inspectorName,
      judgement: first.judgement,
      issueSummary: first.issueSummary,
      scanFile: scan?.url ?? '',
      scanPages: scan?.pageCount ?? 0,
      videoFile: video?.url ?? '',
      media: media,
      items: [
        for (final row in rows)
          QualityResultItem(
            itemName: row.itemName,
            itemResult: row.itemResult,
            itemNote: row.itemNote,
          ),
      ],
    );
  }
}
