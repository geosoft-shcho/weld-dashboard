import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/pass_joint_context.dart';
import '../../core/di/locator.dart';
import '../../core/widgets/pass_context_bar.dart';
import '../../core/widgets/lookup_detail_scaffold.dart';
import '../../core/widgets/screen_command_bar.dart';
import '../../navigation/app_coordinator.dart';
import 'job_lookup_detail_view_model.dart';
import 'widgets/job_attachment_tab.dart';
import 'widgets/job_detail_tabs_bar.dart';
import 'widgets/job_info_tab.dart';
import 'widgets/job_pass_tab.dart';

class JobLookupDetailScreen extends StatelessWidget {
  const JobLookupDetailScreen({super.key, required this.jobId});

  final String jobId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator<JobLookupDetailViewModel>(param1: jobId)..load(),
      child: const _JobLookupDetailBody(),
    );
  }
}

class _JobLookupDetailBody extends StatelessWidget {
  const _JobLookupDetailBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<JobLookupDetailViewModel>();
    final coordinator = context.read<AppCoordinator>();
    final job = viewModel.job;
    final title = job == null
        ? '작업 상세'
        : '${job.projectNo}_${job.unitNo}-${job.itemCode} · ${job.jointNo}';
    return LookupDetailScaffold(
      title: title,
      subtitle: job == null ? '' : 'Job ID #${job.jobId}',
      onBack: () => coordinator.didTapBackToWorkHistory(context),
      commandBarExtra: [
        CommandBarButton(
          icon: const Icon(FluentIcons.video),
          label: const CommandBarLabel('비디오 멀티모달'),
          onPressed: job == null
              ? null
              : () => coordinator.didTapOpenVideoMultimodal(context),
        ),
        CommandBarButton(
          icon: const Icon(FluentIcons.line_chart),
          label: const CommandBarLabel('프로파일'),
          onPressed: job == null
              ? null
              : () => coordinator.didTapLeaveWorkDetailToPassProfile(
                  context,
                  commonKey: job.commonKey,
                  jobId: job.jobId,
                ),
        ),
        CommandBarButton(
          icon: const Icon(FluentIcons.report_document),
          label: const CommandBarLabel('품질 이슈'),
          onPressed: job == null
              ? null
              : () => coordinator.didTapLeaveWorkDetailToQualityIssue(
                  context,
                  commonKey: job.commonKey,
                  jobId: job.jobId,
                ),
        ),
      ],
      body: _body(context, viewModel),
    );
  }

  Widget _body(BuildContext context, JobLookupDetailViewModel viewModel) {
    if (viewModel.isLoading && viewModel.job == null) {
      return const Center(child: ProgressRing());
    }
    if (viewModel.hasError && viewModel.job == null) {
      return InfoBar(
        title: const Text('조회 실패'),
        content: Text(viewModel.errorMessage),
        action: Button(onPressed: viewModel.load, child: const Text('재시도')),
        severity: InfoBarSeverity.error,
      );
    }
    final job = viewModel.job;
    if (job == null) {
      return const InfoBar(
        title: Text('작업 없음'),
        severity: InfoBarSeverity.warning,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PassContextBar(
          contextData: PassJointContext(
            commonKey: job.commonKey,
            projectNo: job.projectNo,
            unitNo: job.unitNo,
            itemCode: job.itemCode,
            itemName: job.itemName,
            jointNo: job.jointNo,
            workerName: job.workerName,
            workerKind: job.workerKind,
            equipmentName: job.equipmentName,
          ),
        ),
        const SizedBox(height: 12),
        JobDetailTabsBar(
          selectedTab: viewModel.tab,
          passCount: viewModel.passes.length,
          attachmentCount: job.attachmentCount,
          onSelectTab: viewModel.didSelectTab,
        ),
        const SizedBox(height: 12),
        Expanded(child: _tabBody(context, viewModel)),
      ],
    );
  }

  Widget _tabBody(BuildContext context, JobLookupDetailViewModel viewModel) {
    final coordinator = context.read<AppCoordinator>();
    switch (viewModel.tab) {
      case JobLookupDetailTab.info:
        return JobInfoTab(
          key: ValueKey('job-info|${viewModel.jobId}'),
          viewModel: viewModel,
          onDeleted: () => coordinator.didTapBackToWorkHistory(context),
        );
      case JobLookupDetailTab.passes:
        return JobPassTab(viewModel: viewModel);
      case JobLookupDetailTab.attachments:
        return JobAttachmentTab(viewModel: viewModel);
    }
  }
}
