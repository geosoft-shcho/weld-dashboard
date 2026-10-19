import '../../domain/entities/worker_kind.dart';
import '../datasources/generated/mediatag/work/v1/work.pbenum.dart' as work_pb;

WorkerKind workerKindFromProto(work_pb.WorkerType type) {
  switch (type) {
    case work_pb.WorkerType.WORKER_TYPE_MASTER:
      return WorkerKind.master;
    case work_pb.WorkerType.WORKER_TYPE_GENERAL:
      return WorkerKind.general;
    case work_pb.WorkerType.WORKER_TYPE_ROBOT:
      return WorkerKind.robot;
    case work_pb.WorkerType.WORKER_TYPE_UNSPECIFIED:
      return WorkerKind.unknown;
  }
  return WorkerKind.unknown;
}

work_pb.WorkerType workerKindToProto(WorkerKind kind) {
  switch (kind) {
    case WorkerKind.master:
      return work_pb.WorkerType.WORKER_TYPE_MASTER;
    case WorkerKind.general:
      return work_pb.WorkerType.WORKER_TYPE_GENERAL;
    case WorkerKind.robot:
      return work_pb.WorkerType.WORKER_TYPE_ROBOT;
    case WorkerKind.unknown:
      return work_pb.WorkerType.WORKER_TYPE_UNSPECIFIED;
  }
}
