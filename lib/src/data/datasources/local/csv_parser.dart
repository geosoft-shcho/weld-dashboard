class CsvParser {
  static List<Map<String, String>> rows(String raw) {
    final records = _parseRecords(raw);
    if (records.isEmpty) {
      return const [];
    }
    final headers = records.first;
    return [
      for (final record in records.skip(1))
        {
          for (var index = 0; index < headers.length; index++)
            headers[index]: index < record.length ? record[index] : '',
        },
    ];
  }

  static List<List<String>> _parseRecords(String raw) {
    final records = <List<String>>[];
    var row = <String>[];
    final cell = StringBuffer();
    var isQuoted = false;
    var index = 0;
    while (index < raw.length) {
      final char = raw[index];
      if (isQuoted) {
        if (char == '"') {
          if (index + 1 < raw.length && raw[index + 1] == '"') {
            cell.write('"');
            index += 2;
            continue;
          }
          isQuoted = false;
          index += 1;
          continue;
        }
        cell.write(char);
        index += 1;
        continue;
      }
      if (char == '"') {
        isQuoted = true;
        index += 1;
        continue;
      }
      if (char == ',') {
        row.add(cell.toString());
        cell.clear();
        index += 1;
        continue;
      }
      if (char == '\r') {
        index += 1;
        continue;
      }
      if (char == '\n') {
        row.add(cell.toString());
        cell.clear();
        if (_doesHaveValue(row)) {
          records.add(row);
        }
        row = <String>[];
        index += 1;
        continue;
      }
      cell.write(char);
      index += 1;
    }
    if (isQuoted || cell.isNotEmpty || row.isNotEmpty) {
      row.add(cell.toString());
      if (_doesHaveValue(row)) {
        records.add(row);
      }
    }
    return records;
  }

  static bool _doesHaveValue(List<String> row) {
    return row.any((value) => value.trim().isNotEmpty);
  }
}
