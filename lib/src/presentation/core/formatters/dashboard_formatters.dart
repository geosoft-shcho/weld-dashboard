import '../../../domain/entities/worker_kind.dart';

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

  static String workerKindLabel(WorkerKind kind) => kind.label;

  /// 하위 호환. 새 코드는 [workerKindLabel]을 쓴다.
  static String masterRole(bool? isMaster) {
    if (isMaster == null) {
      return WorkerKind.unknown.label;
    }
    return isMaster ? WorkerKind.master.label : WorkerKind.general.label;
  }

  static String unitNo(String value) {
    if (value == '00') {
      return '구분 없음';
    }
    final number = int.tryParse(value);
    if (number == null) {
      return value;
    }
    return '$number호기';
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

  static String byteSize(int bytes) {
    if (bytes < 0) {
      return '—';
    }
    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    var size = bytes.toDouble();
    var unitIndex = 0;
    while (size >= 1024 && unitIndex < units.length - 1) {
      size /= 1024;
      unitIndex++;
    }
    if (unitIndex == 0) {
      return '$bytes B';
    }
    final digits = size >= 10 ? 0 : 1;
    return '${size.toStringAsFixed(digits)} ${units[unitIndex]}';
  }

  static String durationFromNs(int? durationNs) {
    if (durationNs == null || durationNs <= 0) {
      return '—';
    }
    final totalSeconds = durationNs ~/ 1000000000;
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    final minuteText = minutes.toString().padLeft(2, '0');
    final secondText = seconds.toString().padLeft(2, '0');
    if (hours > 0) {
      return '$hours:$minuteText:$secondText';
    }
    return '$minutes:$secondText';
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
