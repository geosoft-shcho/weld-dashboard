import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/asset_lookup_kind.dart';
import '../../core/di/locator.dart';
import '../../core/formatters/dashboard_formatters.dart';
import '../../core/themes/app_theme.dart';
import '../../core/widgets/lookup_detail_scaffold.dart';
import '../../core/widgets/screen_command_bar.dart';
import '../../navigation/app_coordinator.dart';
import 'job_lookup_detail_view_model.dart';

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
      subtitle: job == null ? '' : 'job ${job.jobId}',
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
      body: _body(viewModel),
    );
  }

  Widget _body(JobLookupDetailViewModel viewModel) {
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
        Row(
          children: [
            _tabButton(
              viewModel,
              JobLookupDetailTab.info,
              '기본 정보',
            ),
            _tabButton(
              viewModel,
              JobLookupDetailTab.passes,
              '패스 ${viewModel.passes.length}',
            ),
            _tabButton(
              viewModel,
              JobLookupDetailTab.attachments,
              '첨부 ${job.attachmentCount}',
            ),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(child: _tabBody(viewModel)),
      ],
    );
  }

  Widget _tabButton(
    JobLookupDetailViewModel viewModel,
    JobLookupDetailTab tab,
    String label,
  ) {
    final selected = viewModel.tab == tab;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Button(
        onPressed: () => viewModel.didSelectTab(tab),
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            selected ? AppTheme.SURFACE_RAISED : const Color(0x00000000),
          ),
        ),
        child: Text(label),
      ),
    );
  }

  Widget _tabBody(JobLookupDetailViewModel viewModel) {
    final job = viewModel.job!;
    switch (viewModel.tab) {
      case JobLookupDetailTab.info:
        return ListView(
          children: [
            if (job.jobKey.isNotEmpty)
              Text(
                job.jobKey,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.STATUS_OFF,
                ),
              ),
            const SizedBox(height: 8),
            LookupDetailKvGrid(
              entries: [
                ('공사', job.projectNo),
                ('호기', DashboardFormatters.unitNo(job.unitNo)),
                ('품목 코드', job.itemCode),
                ('품목 이름', job.itemName),
                ('이음부', job.jointNo),
                ('시작', DashboardFormatters.dateTime(job.workedAt)),
                ('작업자', job.workerName),
                ('구분', DashboardFormatters.workerKindLabel(job.workerKind)),
                ('성적서', job.hasReport ? '있음' : '—'),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '공사 · 호기 · 품목 · 이음부 · 시작을 바꾸면 공통키와 작업 키가 다시 만들어집니다. 품목 이름은 공사에서 고칩니다.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.55),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Button(onPressed: null, child: const Text('작업 지우기')),
                const SizedBox(width: 8),
                FilledButton(onPressed: null, child: const Text('저장')),
              ],
            ),
          ],
        );
      case JobLookupDetailTab.passes:
        return ListView(
          children: [
            LookupDetailPlainTable(
              headers: const ['패스', '시작', '종료', ''],
              emptyText: '패스가 없습니다',
              rows: [
                for (final pass in viewModel.passes)
                  [
                    '${pass.passNo}${pass.passNo == 1 ? ' 초층' : ''}',
                    DashboardFormatters.dateTime(pass.startedAt),
                    DashboardFormatters.dateTime(pass.endedAt),
                    '에셋 → · 수정 · 지우기',
                  ],
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '작업 구간 안이어야 하고 서로 겹칠 수 없습니다. 끝과 시작이 맞닿는 건 됩니다.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.55),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(onPressed: null, child: const Text('+ 패스 추가')),
          ],
        );
      case JobLookupDetailTab.attachments:
        return ListView(
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const [
                Button(onPressed: null, child: Text('+ 이 작업에 올리기')),
                Button(onPressed: null, child: Text('에셋 붙이기')),
                Button(onPressed: null, child: Text('에셋 탭에서 보기 →')),
              ],
            ),
            const SizedBox(height: 12),
            LookupDetailPlainTable(
              headers: const ['번호', '종류', '파일', '패스', ''],
              emptyText: '첨부가 없습니다',
              rows: [
                for (final row in viewModel.attachments)
                  [
                    row.assetId,
                    AssetLookupKindOption.labelOf(row.kindCode),
                    row.fileName,
                    viewModel.passLabelOf(row),
                    '떼기',
                  ],
              ],
            ),
          ],
        );
    }
  }
}
