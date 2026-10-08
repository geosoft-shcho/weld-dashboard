//
//  Generated code. Do not modify.
//  source: mediatag/work/v1/work.proto
//

import "package:connectrpc/connect.dart" as connect;
import "work.pb.dart" as mediatagworkv1work;

/// 사용처: 대시보드(s0 수집 현황, s2 작업 이력·필터, s3 파형 비교, s3/s4 컨텍스트), 컴포즈(열 작업 고르기).
abstract final class WorkService {
  /// Fully-qualified name of the WorkService service.
  static const name = 'mediatag.work.v1.WorkService';

  static const listProjects = connect.Spec(
    '/$name/ListProjects',
    connect.StreamType.unary,
    mediatagworkv1work.ListProjectsRequest.new,
    mediatagworkv1work.ListProjectsResponse.new,
  );

  /// 공사를 만든다. project.project_no는 필수이고 발급 후 불변. 같은 번호가 있으면 AlreadyExists.
  static const createProject = connect.Spec(
    '/$name/CreateProject',
    connect.StreamType.unary,
    mediatagworkv1work.CreateProjectRequest.new,
    mediatagworkv1work.CreateProjectResponse.new,
  );

  static const listWorkers = connect.Spec(
    '/$name/ListWorkers',
    connect.StreamType.unary,
    mediatagworkv1work.ListWorkersRequest.new,
    mediatagworkv1work.ListWorkersResponse.new,
  );

  /// 작업자를 만든다. worker.worker_name 필수.
  static const createWorker = connect.Spec(
    '/$name/CreateWorker',
    connect.StreamType.unary,
    mediatagworkv1work.CreateWorkerRequest.new,
    mediatagworkv1work.CreateWorkerResponse.new,
  );

  /// update_mask: worker_name, team, is_master
  static const updateWorker = connect.Spec(
    '/$name/UpdateWorker',
    connect.StreamType.unary,
    mediatagworkv1work.UpdateWorkerRequest.new,
    mediatagworkv1work.UpdateWorkerResponse.new,
  );

  /// 작업을 맡은 작업자는 FailedPrecondition.
  static const deleteWorker = connect.Spec(
    '/$name/DeleteWorker',
    connect.StreamType.unary,
    mediatagworkv1work.DeleteWorkerRequest.new,
    mediatagworkv1work.DeleteWorkerResponse.new,
  );

  static const listEquipment = connect.Spec(
    '/$name/ListEquipment',
    connect.StreamType.unary,
    mediatagworkv1work.ListEquipmentRequest.new,
    mediatagworkv1work.ListEquipmentResponse.new,
  );

  /// 장비를 만든다. equipment.equipment_name 필수. equipment_code가 겹치면 AlreadyExists.
  static const createEquipment = connect.Spec(
    '/$name/CreateEquipment',
    connect.StreamType.unary,
    mediatagworkv1work.CreateEquipmentRequest.new,
    mediatagworkv1work.CreateEquipmentResponse.new,
  );

  /// update_mask: equipment_name, line_name, equipment_code
  static const updateEquipment = connect.Spec(
    '/$name/UpdateEquipment',
    connect.StreamType.unary,
    mediatagworkv1work.UpdateEquipmentRequest.new,
    mediatagworkv1work.UpdateEquipmentResponse.new,
  );

  /// 그 장비로 기록한 Asset이 있으면 FailedPrecondition.
  static const deleteEquipment = connect.Spec(
    '/$name/DeleteEquipment',
    connect.StreamType.unary,
    mediatagworkv1work.DeleteEquipmentRequest.new,
    mediatagworkv1work.DeleteEquipmentResponse.new,
  );

  /// 공사의 호기에 품목을 배정한다(묶음). 작업을 만들기 전에 품목을 미리 등록할 때 쓴다. 이미 있는 배정은 그대로 두고
  /// (이름도 안 바꾼다) 그 줄을 돌려준다. project_id·unit_no·item_code·item_name 필수, 없는 공사면 InvalidArgument.
  static const createProjectItems = connect.Spec(
    '/$name/CreateProjectItems',
    connect.StreamType.unary,
    mediatagworkv1work.CreateProjectItemsRequest.new,
    mediatagworkv1work.CreateProjectItemsResponse.new,
  );

  /// 배정 줄의 품목 이름을 고친다(item.project_item_id·item_name 필수). 그 배정을 가리키는 작업 모두의 item_name이 바뀐다.
  static const updateProjectItem = connect.Spec(
    '/$name/UpdateProjectItem',
    connect.StreamType.unary,
    mediatagworkv1work.UpdateProjectItemRequest.new,
    mediatagworkv1work.UpdateProjectItemResponse.new,
  );

  /// 배정에 쓰인 품목(코드·이름)을 중복 없이. 품목을 넣을 때 이름을 다시 고르는 추천 목록으로 쓴다.
  static const listItems = connect.Spec(
    '/$name/ListItems',
    connect.StreamType.unary,
    mediatagworkv1work.ListItemsRequest.new,
    mediatagworkv1work.ListItemsResponse.new,
  );

  /// 작업 목록(ListJobs) 필터의 드롭다운 값을 한 번에: 공사(호기·품목 포함)·작업자·장비.
  static const listJobFilters = connect.Spec(
    '/$name/ListJobFilters',
    connect.StreamType.unary,
    mediatagworkv1work.ListJobFiltersRequest.new,
    mediatagworkv1work.ListJobFiltersResponse.new,
  );

  /// 작업 목록. 행마다 표시용 이름·개수를 붙여 준다(행별 추가 조회 불필요).
  static const listJobs = connect.Spec(
    '/$name/ListJobs',
    connect.StreamType.unary,
    mediatagworkv1work.ListJobsRequest.new,
    mediatagworkv1work.ListJobsResponse.new,
  );

  /// 공사 이름·현장·발주처를 고친다(update_mask: project_name, site_name, customer). 공사 번호는 못 바꾼다.
  static const updateProject = connect.Spec(
    '/$name/UpdateProject',
    connect.StreamType.unary,
    mediatagworkv1work.UpdateProjectRequest.new,
    mediatagworkv1work.UpdateProjectResponse.new,
  );

  /// 작업이 하나라도 있는 공사는 FailedPrecondition.
  static const deleteProject = connect.Spec(
    '/$name/DeleteProject',
    connect.StreamType.unary,
    mediatagworkv1work.DeleteProjectRequest.new,
    mediatagworkv1work.DeleteProjectResponse.new,
  );

  /// 작업을 만든다. 필수: job.project_no(또는 project_id)·unit_no·item_code(공백 없이, 정규화된 값 — '05'·'TFPB')·joint_no·started_at, 그리고 item_name(이미 배정된 품목이면 안 줘도 되고, 줘도 저장된 이름을 따른다).
  /// job_id·job_key·common_key는 서버가 정하고 보낸 값은 무시한다. 공사·작업자가 없으면 InvalidArgument.
  /// passes를 주면 패스도 함께 만든다 — 하나라도 틀리면 작업도 만들어지지 않는다. 나중에 더할 때는 CreatePass.
  static const createJob = connect.Spec(
    '/$name/CreateJob',
    connect.StreamType.unary,
    mediatagworkv1work.CreateJobRequest.new,
    mediatagworkv1work.CreateJobResponse.new,
  );

  /// 작업을 고친다(update_mask에 든 칸만). job_id는 그대로이고, 공사·호기·품목·이음부·시작 시각이 바뀌면 common_key·job_key를
  /// 다시 만든다 — 성적서는 품목(common_key)에 붙어 있어 바뀐 품목의 성적서를 보게 된다. 필수 칸은 비울 수 없다.
  static const updateJob = connect.Spec(
    '/$name/UpdateJob',
    connect.StreamType.unary,
    mediatagworkv1work.UpdateJobRequest.new,
    mediatagworkv1work.UpdateJobResponse.new,
  );

  /// 작업과 그 패스를 지운다. 첨부·타임라인·매칭된 성적서 세트가 있으면 FailedPrecondition(먼저 떼거나 지운다).
  static const deleteJob = connect.Spec(
    '/$name/DeleteJob',
    connect.StreamType.unary,
    mediatagworkv1work.DeleteJobRequest.new,
    mediatagworkv1work.DeleteJobResponse.new,
  );

  /// 패스를 만든다. pass.job_id·pass_no(1 이상)는 필수. 같은 번호의 패스가 있으면 AlreadyExists.
  static const createPass = connect.Spec(
    '/$name/CreatePass',
    connect.StreamType.unary,
    mediatagworkv1work.CreatePassRequest.new,
    mediatagworkv1work.CreatePassResponse.new,
  );

  /// 패스를 고친다(update_mask: pass_no, started_at, ended_at).
  static const updatePass = connect.Spec(
    '/$name/UpdatePass',
    connect.StreamType.unary,
    mediatagworkv1work.UpdatePassRequest.new,
    mediatagworkv1work.UpdatePassResponse.new,
  );

  /// 패스를 지운다. 그 패스에 붙어 있던 첨부는 작업 공용이 된다.
  static const deletePass = connect.Spec(
    '/$name/DeletePass',
    connect.StreamType.unary,
    mediatagworkv1work.DeletePassRequest.new,
    mediatagworkv1work.DeletePassResponse.new,
  );

  /// 작업 + 패스 + 작업자 + 쓰인 장비
  static const getJob = connect.Spec(
    '/$name/GetJob',
    connect.StreamType.unary,
    mediatagworkv1work.GetJobRequest.new,
    mediatagworkv1work.GetJobResponse.new,
  );

  /// 수집 현황 계층을 한 단계씩 조회한다. 장비가 기록한 자료(원본과 원본을 대신하는 표준화본·잘라 낸 PDF)만 센다 —
  /// 도구 결과물(STT·포즈·잘라 낸 이미지·추출 JSON)은 작업 첨부(ListJobAssets)·타임라인에서 본다.
  static const listCollectionNodes = connect.Spec(
    '/$name/ListCollectionNodes',
    connect.StreamType.unary,
    mediatagworkv1work.ListCollectionNodesRequest.new,
    mediatagworkv1work.ListCollectionNodesResponse.new,
  );

  /// 패스 하나의 센서 파형. comparison_pass_id를 주면 그 패스의 파형도 함께 준다.
  /// 파형은 표준화 파생 CSV(operation=timeseries_normalize)에서 패스 구간만큼 잘라 낸다.
  static const getPassWaveform = connect.Spec(
    '/$name/GetPassWaveform',
    connect.StreamType.unary,
    mediatagworkv1work.GetPassWaveformRequest.new,
    mediatagworkv1work.GetPassWaveformResponse.new,
  );
}
