import 'package:fluent_ui/fluent_ui.dart';

import '../../../domain/entities/work_history_item.dart';
import '../../../domain/entities/work_history_query.dart';
import '../../../domain/entities/worker.dart';
import '../../../domain/use_cases/list_work_history_page_use_case.dart';
import '../../../domain/use_cases/list_worker_lookup_use_case.dart';

class WorkerLookupDetailViewModel extends ChangeNotifier {
  WorkerLookupDetailViewModel({
    required this.workerId,
    required ListWorkerLookupUseCase listWorkerLookupUseCase,
    required ListWorkHistoryPageUseCase listWorkHistoryPageUseCase,
  }) : _listWorkerLookupUseCase = listWorkerLookupUseCase,
       _listWorkHistoryPageUseCase = listWorkHistoryPageUseCase;

  final String workerId;
  final ListWorkerLookupUseCase _listWorkerLookupUseCase;
  final ListWorkHistoryPageUseCase _listWorkHistoryPageUseCase;

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

  Future<void> load() async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    notifyListeners();
    try {
      Worker? match;
      var token = '';
      do {
        final page = await _listWorkerLookupUseCase.execute(
          includeInactive: true,
          pageToken: token,
        );
        for (final worker in page.items) {
          if (worker.workerId == workerId) {
            match = worker;
            break;
          }
        }
        if (match != null) {
          break;
        }
        token = page.nextPageToken;
      } while (token.isNotEmpty);
      _worker = match;
      if (match == null) {
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
