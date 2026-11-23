/// 작성자 칸 표시. 비어 있으면 사람이 아닌 일(후처리·도구·로그인 전 행).
String authorDisplayLabel(String displayName) {
  final trimmed = displayName.trim();
  return trimmed.isEmpty ? '시스템' : trimmed;
}
