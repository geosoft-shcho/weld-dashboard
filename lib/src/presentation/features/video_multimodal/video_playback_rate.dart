const double minimumVideoPlaybackRate = 0.0625;
const double maximumVideoPlaybackRate = 16;

const List<double> timelinePlaybackRates = [0.5, 1, 1.5, 2];
const Duration playheadTickInterval = Duration(milliseconds: 32);

/// 브라우저 `playbackRate`로 넣을 수 없으면 true — 가이드 §6 스텝 시킹.
bool doesRequireStepSeek(double requestedRate) {
  if (!requestedRate.isFinite) {
    return true;
  }
  if (requestedRate <= 0) {
    return true;
  }
  return requestedRate < minimumVideoPlaybackRate ||
      requestedRate > maximumVideoPlaybackRate;
}

/// 브라우저에 넣을 배속. 스텝 시킹이면 null.
double? browserPlaybackRate(double requestedRate) {
  if (doesRequireStepSeek(requestedRate)) {
    return null;
  }
  return requestedRate;
}

double nextTimelinePlaybackRate(double currentRate) {
  var index = 0;
  for (var i = 0; i < timelinePlaybackRates.length; i++) {
    if ((timelinePlaybackRates[i] - currentRate).abs() < 1e-6) {
      index = i;
      break;
    }
  }
  return timelinePlaybackRates[(index + 1) % timelinePlaybackRates.length];
}

String formatTimelinePlaybackRateLabel(double rate) {
  if ((rate - 1).abs() < 1e-6) {
    return '×1';
  }
  var text = rate.toStringAsFixed(2);
  text = text.replaceFirst(RegExp(r'0+$'), '');
  text = text.replaceFirst(RegExp(r'\.$'), '');
  return '×$text';
}
