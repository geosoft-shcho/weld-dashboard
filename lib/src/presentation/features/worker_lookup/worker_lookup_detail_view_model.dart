import 'package:fluent_ui/fluent_ui.dart';

import '../../../domain/entities/work_history_item.dart';
import '../../../domain/entities/work_history_query.dart';
import '../../../domain/entities/worker.dart';
import '../../../domain/entities/worker_kind.dart';
import '../../../domain/use_cases/delete_worker_use_case.dart';
import '../../../domain/use_cases/get_worker_lookup_use_case.dart';
import '../../../domain/use_cases/list_work_history_page_use_case.dart';
import '../../../domain/use_cases/update_worker_use_case.dart';

class WorkerLookupDetailViewModel extends ChangeNotifier {
  WorkerLookupDetailViewModel({
    required this.workerId,
    required GetWorkerLookupUseCase getWorkerLookupUseCase,
    required ListWorkHistoryPageUseCase listWorkHistoryPageUseCase,
    required UpdateWorkerUseCase updateWorkerUseCase,
    required DeleteWorkerUseCase deleteWorkerUseCase,
  }) : _getWorkerLookupUseCase = getWorkerLookupUseCase,
       _listWorkHistoryPageUseCase = listWorkHistoryPageUseCase,
       _updateWorkerUseCase = updateWorkerUseCase,
       _deleteWorkerUseCase = deleteWorkerUseCase;

  final String workerId;
  final GetWorkerLookupUseCase _getWorkerLookupUseCase;
  final ListWorkHistoryPageUseCase _listWorkHistoryPageUseCase;
  final UpdateWorkerUseCase _updateWorkerUseCase;
  final DeleteWorkerUseCase _deleteWorkerUseCase;

  Worker? _worker;
  List<WorkHistoryItem> _jobs = const [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';

  Worker? get worker => _worker;
  List<WorkHistoryItem> get jobs => _jobs;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;

  Future<void> updateWorker({
    required String workerName,
    required WorkerKind workerKind,
    required String employeeNo,
    required String description,
    required bool isInactive,
  }) async {
    final current = _worker;
    if (current == null) {
      return;
    }
    final changedFields = [
      if (workerName != current.workerName) 'worker_name',
      if (workerKind != current.workerKind) 'worker_type',
      if (employeeNo != current.employeeNo) 'employee_no',
      if (description != current.description) 'description',
      if (isInactive != current.isInactive) 'inactive',
    ];
    if (changedFields.isEmpty) {
      throw _FormFailure('바뀐 칸이 없습니다.');
    }
    await _updateWorkerUseCase.execute(
      workerId: workerId,
      workerName: workerName,
      workerKind: workerKind,
      employeeNo: employeeNo,
      description: description,
      isInactive: isInactive,
      changedFields: changedFields,
    );
    await load();
  }

  Future<void> deleteWorker() {
    return _deleteWorkerUseCase.execute(workerId: workerId);
  }

  Future<void> load() async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    notifyListeners();
    try {
      _worker = await _getWorkerLookupUseCase.execute(workerId: workerId);
      if (_worker == null) {
        _hasError = true;
        _errorMessage = '작업자를 찾지 못했습니다.';
        _jobs = const [];
        return;
      }
      final page = await _listWorkHistoryPageUseCase.execute(
        query: WorkHistoryQuery.initial().copyWith(workerId: workerId),
        pageSize: 50,
        pageToken: '',
      );
      _jobs = page.items;
    } catch (error) {
      _hasError = true;
      _errorMessage = error.toString();
      _worker = null;
      _jobs = const [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

class _FormFailure implements Exception {
  _FormFailure(this.message);

  final String message;

  @override
  String toString() => message;
}
