import '../entities/timeseries_waveform_load.dart';
import '../entities/waveform_series_bundle.dart';
import '../timeseries_csv_parser.dart';
import 'get_job_timeline_use_case.dart';

class LoadTimeseriesWaveformUseCase {
  LoadTimeseriesWaveformUseCase(this._getJobTimelineUseCase);

  final GetJobTimelineUseCase _getJobTimelineUseCase;

  static const emptySeries = WaveformSeriesBundle(
    masterProfileId: '',
    master: [],
    beginner: [],
    robot: [],
  );

  Future<TimeseriesWaveformLoad> execute({required String contentUrl}) async {
    if (contentUrl.isEmpty) {
      return TimeseriesWaveformLoad.empty;
    }
    final body = await _getJobTimelineUseCase.readContent(url: contentUrl);
    final parsed = TimeseriesCsvParser.parse(body);
    final series = parsed.points.isEmpty
        ? emptySeries
        : WaveformSeriesBundle(
            masterProfileId: '',
            master: const [],
            beginner: const [],
            robot: parsed.points,
          );
    return TimeseriesWaveformLoad(
      series: series,
      bodyLength: body.length,
      lineCount: parsed.lineCount,
      headers: parsed.headers,
      pointCount: parsed.points.length,
      rawPointCount: parsed.rawPointCount,
      matchedTimeHeader: parsed.matchedTimeHeader,
      matchedCurrentHeader: parsed.matchedCurrentHeader,
      matchedVoltageHeader: parsed.matchedVoltageHeader,
      matchedSpeedHeader: parsed.matchedSpeedHeader,
      matchedRpmHeader: parsed.matchedRpmHeader,
    );
  }
}
