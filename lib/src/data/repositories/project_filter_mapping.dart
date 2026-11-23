import '../../domain/entities/work_history_project_filter.dart';
import '../datasources/generated/mediatag/work/v1/work.pb.dart' as work_pb;
import 'proto_id.dart';

WorkHistoryProjectFilter projectFilterFromProto(
  work_pb.ProjectFilter project,
) {
  final proto = project.project;
  return WorkHistoryProjectFilter(
    projectId: idText(proto.projectId),
    projectNo: proto.projectNo,
    projectName: proto.projectName,
    siteName: proto.siteName,
    customer: proto.customer,
    jobCount: project.jobCount,
    createdByDisplayName:
        proto.hasCreatedBy() ? proto.createdBy.displayName : '',
    updatedByDisplayName:
        proto.hasUpdatedBy() ? proto.updatedBy.displayName : '',
    units: [
      for (final unit in project.units)
        WorkHistoryUnitFilter(
          unitNo: unit.unitNo,
          itemCodes: unit.itemCodes,
          items: [
            for (final item in unit.items)
              WorkHistoryItemFilter(
                itemCode: item.itemCode,
                itemName: item.itemName,
                projectItemId: idText(item.projectItemId),
                jointNos: item.jointNos,
                joints: [
                  for (final joint in item.joints)
                    WorkHistoryJointFilter(
                      jointNo: joint.jointNo,
                      passNos: joint.passNos,
                    ),
                ],
              ),
          ],
        ),
    ],
  );
}
