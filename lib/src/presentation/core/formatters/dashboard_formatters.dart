class DashboardFormatters {
  static String count(int value) {
    final digits = value.abs().toString();
    final buffer = StringBuffer();
    if (value < 0) {
      buffer.write('-');
    }
    for (var index = 0; index < digits.length; index++) {
      if (index > 0 && (digits.length - index) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(digits[index]);
    }
    return buffer.toString();
  }

  static String percent(double? value) {
    if (value == null) {
      return '—';
    }
    return '${value.toStringAsFixed(1)}%';
  }

  static String date(DateTime? value) {
    if (value == null) {
      return '—';
    }
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '${value.year}-$month-$day';
  }

  static String dateTime(DateTime? value) {
    if (value == null) {
      return '—';
    }
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    final second = value.second.toString().padLeft(2, '0');
    return '${value.year}-$month-$day $hour:$minute:$second';
  }

  static String snapshot(DateTime value) {
    return dateTime(value);
  }

  static String clockTime(DateTime value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  static String clockMinutes(num minutes) {
    var total = minutes.round();
    if (total >= 1440) {
      return '24:00';
    }
    if (total < 0) {
      total = 0;
    }
    final hour = (total ~/ 60).toString().padLeft(2, '0');
    final minute = (total % 60).toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  static String mediaClock(num seconds) {
    var total = seconds.floor();
    if (total < 0) {
      total = 0;
    }
    final minute = (total ~/ 60).toString().padLeft(2, '0');
    final second = (total % 60).toString().padLeft(2, '0');
    return '$minute:$second';
  }

  static String durationLabel(int durationSec) {
    final minutes = durationSec / 60;
    if (minutes >= 1) {
      return '${minutes.round()}분';
    }
    final seconds = durationSec < 1 ? 1 : durationSec;
    return '$seconds초';
  }
}
