import '../../domain/entities/work_history_project_filter.dart';
import '../datasources/generated/mediatag/work/v1/work.pb.dart' as work_pb;
import 'proto_id.dart';

WorkHistoryProjectFilter projectFilterFromProto(
  work_pb.ProjectFilter project,
) {
  return WorkHistoryProjectFilter(
    projectId: idText(project.project.projectId),
    projectNo: project.project.projectNo,
    projectName: project.project.projectName,
    siteName: project.project.siteName,
    customer: project.project.customer,
    jobCount: project.jobCount,
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
