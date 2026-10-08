//
//  Generated code. Do not modify.
//  source: mediatag/work/v1/work.proto
//

import "package:connectrpc/connect.dart" as connect;
import "work.pb.dart" as mediatagworkv1work;
import "work.connect.spec.dart" as specs;

/// 사용처: 대시보드(s0 수집 현황, s2 작업 이력·필터, s3 파형 비교, s3/s4 컨텍스트), 컴포즈(열 작업 고르기).
extension type WorkServiceClient (connect.Transport _transport) {
  Future<mediatagworkv1work.ListProjectsResponse> listProjects(
    mediatagworkv1work.ListProjectsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.WorkService.listProjects,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 공사를 만든다. project.project_no는 필수이고 발급 후 불변. 같은 번호가 있으면 AlreadyExists.
  Future<mediatagworkv1work.CreateProjectResponse> createProject(
    mediatagworkv1work.CreateProjectRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.WorkService.createProject,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<mediatagworkv1work.ListWorkersResponse> listWorkers(
    mediatagworkv1work.ListWorkersRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.WorkService.listWorkers,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 작업자를 만든다. worker.worker_name 필수.
  Future<mediatagworkv1work.CreateWorkerResponse> createWorker(
    mediatagworkv1work.CreateWorkerRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.WorkService.createWorker,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// update_mask: worker_name, team, is_master
  Future<mediatagworkv1work.UpdateWorkerResponse> updateWorker(
    mediatagworkv1work.UpdateWorkerRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.WorkService.updateWorker,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 작업을 맡은 작업자는 FailedPrecondition.
  Future<mediatagworkv1work.DeleteWorkerResponse> deleteWorker(
    mediatagworkv1work.DeleteWorkerRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.WorkService.deleteWorker,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<mediatagworkv1work.ListEquipmentResponse> listEquipment(
    mediatagworkv1work.ListEquipmentRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.WorkService.listEquipment,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 장비를 만든다. equipment.equipment_name 필수. equipment_code가 겹치면 AlreadyExists.
  Future<mediatagworkv1work.CreateEquipmentResponse> createEquipment(
    mediatagworkv1work.CreateEquipmentRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.WorkService.createEquipment,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// update_mask: equipment_name, line_name, equipment_code
  Future<mediatagworkv1work.UpdateEquipmentResponse> updateEquipment(
    mediatagworkv1work.UpdateEquipmentRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.WorkService.updateEquipment,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 그 장비로 기록한 Asset이 있으면 FailedPrecondition.
  Future<mediatagworkv1work.DeleteEquipmentResponse> deleteEquipment(
    mediatagworkv1work.DeleteEquipmentRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.WorkService.deleteEquipment,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 공사의 호기에 품목을 배정한다(묶음). 작업을 만들기 전에 품목을 미리 등록할 때 쓴다. 이미 있는 배정은 그대로 두고
  /// (이름도 안 바꾼다) 그 줄을 돌려준다. project_id·unit_no·item_code·item_name 필수, 없는 공사면 InvalidArgument.
  Future<mediatagworkv1work.CreateProjectItemsResponse> createProjectItems(
    mediatagworkv1work.CreateProjectItemsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.WorkService.createProjectItems,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 배정 줄의 품목 이름을 고친다(item.project_item_id·item_name 필수). 그 배정을 가리키는 작업 모두의 item_name이 바뀐다.
  Future<mediatagworkv1work.UpdateProjectItemResponse> updateProjectItem(
    mediatagworkv1work.UpdateProjectItemRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.WorkService.updateProjectItem,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 배정에 쓰인 품목(코드·이름)을 중복 없이. 품목을 넣을 때 이름을 다시 고르는 추천 목록으로 쓴다.
  Future<mediatagworkv1work.ListItemsResponse> listItems(
    mediatagworkv1work.ListItemsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.WorkService.listItems,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 작업 목록(ListJobs) 필터의 드롭다운 값을 한 번에: 공사(호기·품목 포함)·작업자·장비.
  Future<mediatagworkv1work.ListJobFiltersResponse> listJobFilters(
    mediatagworkv1work.ListJobFiltersRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.WorkService.listJobFilters,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 작업 목록. 행마다 표시용 이름·개수를 붙여 준다(행별 추가 조회 불필요).
  Future<mediatagworkv1work.ListJobsResponse> listJobs(
    mediatagworkv1work.ListJobsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.WorkService.listJobs,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 공사 이름·현장·발주처를 고친다(update_mask: project_name, site_name, customer). 공사 번호는 못 바꾼다.
  Future<mediatagworkv1work.UpdateProjectResponse> updateProject(
    mediatagworkv1work.UpdateProjectRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.WorkService.updateProject,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 작업이 하나라도 있는 공사는 FailedPrecondition.
  Future<mediatagworkv1work.DeleteProjectResponse> deleteProject(
    mediatagworkv1work.DeleteProjectRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.WorkService.deleteProject,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 작업을 만든다. 필수: job.project_no(또는 project_id)·unit_no·item_code(공백 없이, 정규화된 값 — '05'·'TFPB')·joint_no·started_at, 그리고 item_name(이미 배정된 품목이면 안 줘도 되고, 줘도 저장된 이름을 따른다).
  /// job_id·job_key·common_key는 서버가 정하고 보낸 값은 무시한다. 공사·작업자가 없으면 InvalidArgument.
  /// passes를 주면 패스도 함께 만든다 — 하나라도 틀리면 작업도 만들어지지 않는다. 나중에 더할 때는 CreatePass.
  Future<mediatagworkv1work.CreateJobResponse> createJob(
    mediatagworkv1work.CreateJobRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.WorkService.createJob,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 작업을 고친다(update_mask에 든 칸만). job_id는 그대로이고, 공사·호기·품목·이음부·시작 시각이 바뀌면 common_key·job_key를
  /// 다시 만든다 — 성적서는 품목(common_key)에 붙어 있어 바뀐 품목의 성적서를 보게 된다. 필수 칸은 비울 수 없다.
  Future<mediatagworkv1work.UpdateJobResponse> updateJob(
    mediatagworkv1work.UpdateJobRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.WorkService.updateJob,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 작업과 그 패스를 지운다. 첨부·타임라인·매칭된 성적서 세트가 있으면 FailedPrecondition(먼저 떼거나 지운다).
  Future<mediatagworkv1work.DeleteJobResponse> deleteJob(
    mediatagworkv1work.DeleteJobRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.WorkService.deleteJob,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 패스를 만든다. pass.job_id·pass_no(1 이상)는 필수. 같은 번호의 패스가 있으면 AlreadyExists.
  Future<mediatagworkv1work.CreatePassResponse> createPass(
    mediatagworkv1work.CreatePassRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.WorkService.createPass,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 패스를 고친다(update_mask: pass_no, started_at, ended_at).
  Future<mediatagworkv1work.UpdatePassResponse> updatePass(
    mediatagworkv1work.UpdatePassRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.WorkService.updatePass,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 패스를 지운다. 그 패스에 붙어 있던 첨부는 작업 공용이 된다.
  Future<mediatagworkv1work.DeletePassResponse> deletePass(
    mediatagworkv1work.DeletePassRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.WorkService.deletePass,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 작업 + 패스 + 작업자 + 쓰인 장비
  Future<mediatagworkv1work.GetJobResponse> getJob(
    mediatagworkv1work.GetJobRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.WorkService.getJob,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 수집 현황 계층을 한 단계씩 조회한다. 장비가 기록한 자료(원본과 원본을 대신하는 표준화본·잘라 낸 PDF)만 센다 —
  /// 도구 결과물(STT·포즈·잘라 낸 이미지·추출 JSON)은 작업 첨부(ListJobAssets)·타임라인에서 본다.
  Future<mediatagworkv1work.ListCollectionNodesResponse> listCollectionNodes(
    mediatagworkv1work.ListCollectionNodesRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.WorkService.listCollectionNodes,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 패스 하나의 센서 파형. comparison_pass_id를 주면 그 패스의 파형도 함께 준다.
  /// 파형은 표준화 파생 CSV(operation=timeseries_normalize)에서 패스 구간만큼 잘라 낸다.
  Future<mediatagworkv1work.GetPassWaveformResponse> getPassWaveform(
    mediatagworkv1work.GetPassWaveformRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.WorkService.getPassWaveform,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
