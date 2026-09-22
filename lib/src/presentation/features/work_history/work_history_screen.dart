import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../core/di/locator.dart';
import '../../navigation/app_coordinator.dart';
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
        child: _content(viewModel),
      ),
    );
  }

  Widget _content(WorkHistoryViewModel viewModel) {
    if (viewModel.isLoading && viewModel.board == null) {
      return const Center(child: ProgressRing());
    }
    if (viewModel.hasError) {
      return InfoBar(
        title: const Text('조회 실패'),
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
        content: Text('아직 조회되지 않았습니다.'),
      );
    }
    return SizedBox.expand(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (viewModel.doesHavePendingFilters)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: InfoBar(
                title: Text('필터 미적용'),
                content: Text('필터가 변경되었습니다. 조회를 눌러 반영하세요.'),
                severity: InfoBarSeverity.warning,
              ),
            ),
          if (viewModel.doesHaveInvalidDateRange)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: InfoBar(
                title: Text('기간 오류'),
                content: Text('시작일이 종료일보다 늦습니다. 조회 시 결과가 비어 있을 수 있습니다.'),
                severity: InfoBarSeverity.error,
              ),
            ),
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
