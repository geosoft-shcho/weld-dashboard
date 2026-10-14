const double minimumVideoPlaybackRate = 0.0625;
const double maximumVideoPlaybackRate = 16;

double supportedVideoPlaybackRate(double requestedRate) {
  if (!requestedRate.isFinite ||
      requestedRate < minimumVideoPlaybackRate ||
      requestedRate > maximumVideoPlaybackRate) {
    return 1;
  }
  return requestedRate;
}
