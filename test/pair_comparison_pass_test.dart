import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/domain/entities/weld_pass.dart';
import 'package:weld_dashboard/src/domain/use_cases/pair_comparison_pass.dart';

void main() {
  final targets = [
    _pass('t1', 1),
    _pass('t2', 2),
    _pass('t3', 3),
  ];
  final comparisons = [
    _pass('c1', 1),
    _pass('c2', 2),
    _pass('c3', 5),
  ];

  test('pairs the first target pass with the first comparison pass', () {
    expect(
      pairComparisonPassId(
        targetPasses: targets,
        selectedPassId: 't1',
        comparisonPasses: comparisons,
      ),
      'c1',
    );
  });

  test('pairs the last target pass with the last comparison pass', () {
    expect(
      pairComparisonPassId(
        targetPasses: targets,
        selectedPassId: 't3',
        comparisonPasses: comparisons,
      ),
      'c3',
    );
  });

  test('pairs a middle pass by the same pass number', () {
    expect(
      pairComparisonPassId(
        targetPasses: targets,
        selectedPassId: 't2',
        comparisonPasses: [
          _pass('c1', 1),
          _pass('c2', 2),
          _pass('c3', 9),
        ],
      ),
      'c2',
    );
  });
}

WeldPass _pass(String passId, int passNo) {
  return WeldPass(
    passId: passId,
    commonKey: 'key',
    passNo: passNo,
    passName: '',
    masterProfileId: '',
    controlWorkerId: '',
  );
}
