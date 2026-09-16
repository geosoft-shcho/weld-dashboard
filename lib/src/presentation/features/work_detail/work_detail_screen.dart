import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/preview_state.dart';
import '../../core/di/locator.dart';
import '../../core/themes/app_theme.dart';
import '../../navigation/app_coordinator.dart';
import '../app_shell/shell_view_model.dart';
import 'work_detail_view_model.dart';
import 'widgets/work_detail_identity.dart';
import 'widgets/work_detail_stage.dart';
import 'widgets/work_detail_tabs.dart';

class WorkDetailScreen extends StatelessWidget {
  const WorkDetailScreen({super.key, required this.historyId});

  final String historyId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          locator<WorkDetailViewModel>(param1: historyId)..loadDetail(),
      child: const _WorkDetailBody(),
    );
  }
}

class _WorkDetailBody extends StatelessWidget {
  const _WorkDetailBody();

  @override
  Widget build(BuildContext context) {
    final previewState = context.watch<ShellViewModel>().previewState;
    final viewModel = context.watch<WorkDetailViewModel>();
    final coordinator = context.read<AppCoordinator>();
    final job = viewModel.detail?.job;
    return ColoredBox(
      color: AppTheme.SURFACE,
      child: SizedBox.expand(
        child: ScaffoldPage(
          header: PageHeader(
            title: const Text('작업 상세'),
            commandBar: Align(
              alignment: Alignment.centerRight,
              child: CommandBar(
                primaryItems: [
                  CommandBarButton(
                    icon: const Icon(FluentIcons.back),
                    label: const Text('목록으로'),
                    onPressed: () =>
                        coordinator.didTapBackToWorkHistory(context),
                  ),

                  CommandBarButton(
                    icon: const Icon(FluentIcons.line_chart),
                    label: const Text('프로파일'),
                    onPressed: job == null
                        ? null
                        : () => coordinator.didTapLeaveWorkDetailToPassProfile(
                            context,
                            commonKey: job.commonKey,
                            historyId: job.historyId,
                          ),
                  ),

                  CommandBarButton(
                    icon: const Icon(FluentIcons.report_document),
                    label: const Text('품질 이슈'),
                    onPressed: job == null
                        ? null
                        : () => coordinator.didTapLeaveWorkDetailToQualityIssue(
                            context,
                            commonKey: job.commonKey,
                            historyId: job.historyId,
                          ),
                  ),
                ],
              ),
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.all(16),
            child: _content(context, previewState, viewModel, coordinator),
          ),
        ),
      ),
    );
  }

  Widget _content(
    BuildContext context,
    PreviewState previewState,
    WorkDetailViewModel viewModel,
    AppCoordinator coordinator,
  ) {
    switch (previewState) {
      case PreviewState.loading:
        return const Center(child: ProgressRing());
      case PreviewState.empty:
        return _banner(
          InfoBar(
            title: const Text('작업 상세'),
            content: const Text('작업 이력에서 행을 고른 뒤 상세를 여세요.'),
            action: Button(
              onPressed: () => coordinator.didTapBackToWorkHistory(context),
              child: const Text('작업 이력 조회'),
            ),
            severity: InfoBarSeverity.warning,
          ),
        );
      case PreviewState.error:
        return _banner(
          InfoBar(
            title: const Text('CSV 로드 실패'),
            content: const Text('work_attachments.csv와 이력 CSV를 확인하세요.'),
            action: Button(
              onPressed: viewModel.didTapReload,
              child: const Text('재시도'),
            ),
            severity: InfoBarSeverity.error,
          ),
        );
      case PreviewState.live:
        if (viewModel.isLoading && viewModel.detail == null) {
          return const Center(child: ProgressRing());
        }
        if (viewModel.hasError) {
          return _banner(
            InfoBar(
              title: const Text('CSV 로드 실패'),
              content: Text(viewModel.errorMessage),
              action: Button(
                onPressed: viewModel.didTapReload,
                child: const Text('재시도'),
              ),
              severity: InfoBarSeverity.error,
            ),
          );
        }
        final detail = viewModel.detail;
        final job = detail?.job;
        if (detail == null || job == null) {
          return _banner(
            InfoBar(
              title: const Text('작업 상세'),
              content: const Text('작업 이력에서 행을 고른 뒤 상세를 여세요.'),
              action: Button(
                onPressed: () => coordinator.didTapBackToWorkHistory(context),
                child: const Text('작업 이력 조회'),
              ),
              severity: InfoBarSeverity.warning,
            ),
          );
        }
        return SizedBox.expand(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              WorkDetailIdentity(job: job),
              const SizedBox(height: 12),
              WorkDetailTabs(viewModel: viewModel, detail: detail),
              const SizedBox(height: 12),
              Expanded(child: WorkDetailStage(viewModel: viewModel)),
            ],
          ),
        );
    }
  }

  Widget _banner(Widget child) {
    return Align(alignment: Alignment.topLeft, child: child);
  }
}
