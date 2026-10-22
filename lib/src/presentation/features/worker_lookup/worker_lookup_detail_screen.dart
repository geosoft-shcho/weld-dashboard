import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/worker_kind.dart';
import '../../core/di/locator.dart';
import '../../core/formatters/dashboard_formatters.dart';
import '../../core/widgets/lookup_detail_scaffold.dart';
import '../../core/widgets/pass_context_bar.dart';
import '../../navigation/app_coordinator.dart';
import 'worker_lookup_detail_view_model.dart';

class WorkerLookupDetailScreen extends StatelessWidget {
  const WorkerLookupDetailScreen({super.key, required this.workerId});

  final String workerId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          locator<WorkerLookupDetailViewModel>(param1: workerId)..load(),
      child: const _WorkerLookupDetailBody(),
    );
  }
}

class _WorkerLookupDetailBody extends StatelessWidget {
  const _WorkerLookupDetailBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<WorkerLookupDetailViewModel>();
    final coordinator = context.read<AppCoordinator>();
    final worker = viewModel.worker;
    return LookupDetailScaffold(
      title: worker?.workerName.isNotEmpty == true
          ? worker!.workerName
          : '작업자 상세',
      subtitle: worker == null ? '' : 'id ${worker.workerId}',
      onBack: coordinator.didTapBackFromLookupDetail,
      actions: [
        Button(onPressed: null, child: const Text('고치기')),
        const SizedBox(width: 8),
        Button(onPressed: null, child: const Text('지우기')),
      ],
      body: _body(context, viewModel, coordinator),
    );
  }

  Widget _body(
    BuildContext context,
    WorkerLookupDetailViewModel viewModel,
    AppCoordinator coordinator,
  ) {
    if (viewModel.isLoading && viewModel.worker == null) {
      return const Center(child: ProgressRing());
    }
    if (viewModel.hasError) {
      return InfoBar(
        title: const Text('조회 실패'),
        content: Text(viewModel.errorMessage),
        action: Button(onPressed: viewModel.load, child: const Text('재시도')),
        severity: InfoBarSeverity.error,
      );
    }
    final worker = viewModel.worker;
    if (worker == null) {
      return const InfoBar(
        title: Text('작업자 없음'),
        severity: InfoBarSeverity.warning,
      );
    }
    final kindHint = worker.workerKind.label == '명장'
        ? '파형 비교의 명장 목록에 들어갑니다.'
        : '파형 비교의 명장 목록에는 안 들어갑니다.';
    return ListView(
      children: [
        PassContextBar.entries(
          entries: [
            ('종류', worker.workerKind.label),
            ('사번', worker.employeeNo),
            ('맡은 작업', '${worker.jobCount}건'),
            ('숨김', worker.isInactive ? '숨김 — 고르는 목록에서 빠짐' : '아니오'),
          ],
        ),
        const SizedBox(height: 12),
        if (worker.description.isNotEmpty) ...[
          const LookupDetailSectionTitle('비고'),
          Text(worker.description),
        ],
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            kindHint,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.55),
            ),
          ),
        ),
        const LookupDetailSectionTitle('맡은 작업'),
        LookupDetailPlainTable(
          headers: const ['공통키', '이음부', '작업일시'],
          emptyText: worker.jobCount == 0
              ? '맡은 작업이 없습니다'
              : '조건에 맞는 작업 목록이 없습니다',
          rows: [
            for (final job in viewModel.jobs)
              [
                job.commonKey,
                job.jointNo,
                DashboardFormatters.dateTime(job.workedAt),
              ],
          ],
          onRowTap: (index) {
            final job = viewModel.jobs[index];
            coordinator.didTapOpenWorkDetail(context, jobId: job.jobId);
          },
        ),
      ],
    );
  }
}
