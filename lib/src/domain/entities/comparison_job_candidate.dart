import 'worker_kind.dart';

class ComparisonJobCandidate {
  const ComparisonJobCandidate({
    required this.jobId,
    this.jobKey = '',
    required this.workerName,
    this.workerKind = WorkerKind.unknown,
    required this.startedAt,
    required this.passCount,
  });

  final String jobId;
  final String jobKey;
  final String workerName;
  final WorkerKind workerKind;
  final DateTime? startedAt;
  final int passCount;
}

class ComparisonJobPage {
  const ComparisonJobPage({required this.jobs, required this.nextPageToken});

  final List<ComparisonJobCandidate> jobs;
  final String nextPageToken;
}

class ComparisonJobNotFoundException implements Exception {
  const ComparisonJobNotFoundException();

  @override
  String toString() => '비교 작업을 불러오지 못했습니다.';
}
