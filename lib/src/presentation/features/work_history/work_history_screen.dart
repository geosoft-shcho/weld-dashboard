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
