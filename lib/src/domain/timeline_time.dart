const int NANOSECONDS_PER_SECOND = 1000000000;

/// 화면 픽셀용 초. 저장값은 나노초 문자열 그대로 둔다.
double secondsFromNanoseconds(String nanoseconds) {
  final value = BigInt.tryParse(nanoseconds);
  if (value == null || value.isNegative) {
    return 0;
  }
  final scale = BigInt.from(NANOSECONDS_PER_SECOND);
  final whole = value ~/ scale;
  final fraction = value.remainder(scale);
  return whole.toDouble() + fraction.toDouble() / NANOSECONDS_PER_SECOND;
}

/// 화면 초를 저장용 나노초 문자열로 바꾼다. 0 이하는 `0`이다.
String nanosecondsFromSeconds(double seconds) {
  if (seconds.isNaN || seconds.isInfinite || seconds <= 0) {
    return '0';
  }
  final scale = BigInt.from(NANOSECONDS_PER_SECOND);
  final whole = BigInt.from(seconds.truncate());
  var fractionNanos = ((seconds - seconds.truncate()) * NANOSECONDS_PER_SECOND)
      .round();
  var total = whole * scale;
  if (fractionNanos >= NANOSECONDS_PER_SECOND) {
    fractionNanos -= NANOSECONDS_PER_SECOND;
    total += scale;
  }
  if (fractionNanos > 0) {
    total += BigInt.from(fractionNanos);
  }
  return total.toString();
}

bool isOpenNanosecondInterval(String startNanoseconds, String endNanoseconds) {
  final start = BigInt.tryParse(startNanoseconds);
  final end = BigInt.tryParse(endNanoseconds);
  if (start == null || end == null) {
    return false;
  }
  return end > start;
}
