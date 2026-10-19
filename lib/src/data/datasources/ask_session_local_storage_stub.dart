final Map<String, String> _memory = {};

String? readAskSessionValue(String key) => _memory[key];

void writeAskSessionValue(String key, String value) {
  _memory[key] = value;
}

void removeAskSessionValue(String key) {
  _memory.remove(key);
}
