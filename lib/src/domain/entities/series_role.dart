enum SeriesRole {
  master,
  beginner,
  robot;

  static SeriesRole? fromCsv(String raw) {
    switch (raw.trim()) {
      case 'master':
        return SeriesRole.master;
      case 'beginner':
        return SeriesRole.beginner;
      case 'robot':
        return SeriesRole.robot;
      default:
        return null;
    }
  }
}
