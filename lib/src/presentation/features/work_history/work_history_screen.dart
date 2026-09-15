import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/preview_state.dart';
import '../../core/di/locator.dart';
import '../../navigation/app_coordinator.dart';
import '../app_shell/shell_view_model.dart';
import 'work_history_view_model.dart';
import 'widgets/work_history_command_bar.dart';
import 'widgets/work_history_table.dart';

class WorkHistoryScreen extends StatelessWidget {
  const WorkHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator<WorkHistoryViewModel>()..loadBoard(),
      child: const _WorkHistoryBody(),
    );
  }
}

class _WorkHistoryBody extends StatelessWidget {
  const _WorkHistoryBody();

  @override
  Widget build(BuildContext context) {
    final previewState = context.watch<ShellViewModel>().previewState;
    final viewModel = context.watch<WorkHistoryViewModel>();
    final coordinator = context.watch<AppCoordinator>();
    final incomingEquipmentId = coordinator.pendingHistoryEquipmentId;
    final incomingWorkerId = coordinator.pendingHistoryWorkerId;
    if (incomingEquipmentId.isNotEmpty || incomingWorkerId.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) {
          return;
        }
        context.read<WorkHistoryViewModel>().didApplyIncomingFilter(
          equipmentId: incomingEquipmentId,
          workerId: incomingWorkerId,
        );
        coordinator.didConsumePendingHistoryFilter();
      });
    }
    return ScaffoldPage(
      header: const PageHeader(title: Text('작업 이력 조회')),
      content: Padding(
        padding: const EdgeInsets.all(16),
        child: _content(previewState, viewModel),
      ),
    );
  }

  Widget _content(PreviewState previewState, WorkHistoryViewModel viewModel) {
    switch (previewState) {
      case PreviewState.loading:
        return const Center(child: ProgressRing());
      case PreviewState.empty:
        return const InfoBar(
          title: Text('빈 상태'),
          content: Text('미리보기: 표시할 작업 이력이 없습니다.'),
          severity: InfoBarSeverity.warning,
        );
      case PreviewState.error:
        return InfoBar(
          title: const Text('CSV 로드 실패'),
          content: const Text('work_history.csv와 마스터 CSV를 확인하세요.'),
          action: Button(
            onPressed: viewModel.didTapReload,
            child: const Text('재시도'),
          ),
          severity: InfoBarSeverity.error,
        );
      case PreviewState.live:
        if (viewModel.isLoading && viewModel.board == null) {
          return const Center(child: ProgressRing());
        }
        if (viewModel.hasError) {
          return InfoBar(
            title: const Text('CSV 로드 실패'),
            content: Text(viewModel.errorMessage),
            action: Button(
              onPressed: viewModel.didTapReload,
              child: const Text('재시도'),
            ),
            severity: InfoBarSeverity.error,
          );
        }
        final board = viewModel.board;
        if (board == null) {
          return const InfoBar(
            title: Text('이력 없음'),
            content: Text('아직 CSV를 불러오지 않았습니다.'),
          );
        }
        return SizedBox.expand(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                '공통키 기반 검색. 행 클릭은 선택, 상세는 첨부 뷰어, 프로파일·품질은 기존 화면입니다.',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 8),
              WorkHistoryCommandBar(viewModel: viewModel, board: board),
              const SizedBox(height: 12),
              WorkHistoryFilterChips(viewModel: viewModel, board: board),
              const SizedBox(height: 12),
              Expanded(
                child: WorkHistoryTable(viewModel: viewModel, board: board),
              ),
            ],
          ),
        );
    }
  }
}
