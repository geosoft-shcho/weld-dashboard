class ComparisonJobCandidate {
  const ComparisonJobCandidate({
    required this.jobId,
    required this.workerName,
    this.isMaster,
    required this.startedAt,
    required this.passCount,
  });

  final String jobId;
  final String workerName;
  final bool? isMaster;
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
