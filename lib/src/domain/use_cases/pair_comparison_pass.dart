import '../entities/weld_pass.dart';

/// 대상 패스와 비교 작업 패스를 처음·끝·같은 pass_no로 짝짓는다.
String pairComparisonPassId({
  required List<WeldPass> targetPasses,
  required String selectedPassId,
  required List<WeldPass> comparisonPasses,
}) {
  if (comparisonPasses.isEmpty || selectedPassId.isEmpty) {
    return '';
  }
  WeldPass? selected;
  for (final pass in targetPasses) {
    if (pass.passId == selectedPassId) {
      selected = pass;
      break;
    }
  }
  if (selected == null) {
    return '';
  }
  final targets = [...targetPasses]
    ..sort((left, right) => left.passNo.compareTo(right.passNo));
  final comparisons = [...comparisonPasses]
    ..sort((left, right) => left.passNo.compareTo(right.passNo));
  final index = targets.indexWhere((pass) => pass.passId == selected!.passId);
  if (index <= 0) {
    return comparisons.first.passId;
  }
  if (index == targets.length - 1) {
    return comparisons.last.passId;
  }
  for (final pass in comparisons) {
    if (pass.passNo == selected.passNo) {
      return pass.passId;
    }
  }
  return '';
}
