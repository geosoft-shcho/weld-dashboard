import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/work_history_project_filter.dart';
import '../../core/di/locator.dart';
import '../../core/formatters/dashboard_formatters.dart';
import '../../core/widgets/lookup_detail_scaffold.dart';
import '../../navigation/app_coordinator.dart';
import 'project_lookup_detail_view_model.dart';

class ProjectLookupDetailScreen extends StatelessWidget {
  const ProjectLookupDetailScreen({super.key, required this.projectId});

  final String projectId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          locator<ProjectLookupDetailViewModel>(param1: projectId)..load(),
      child: const _ProjectLookupDetailBody(),
    );
  }
}

class _ProjectLookupDetailBody extends StatelessWidget {
  const _ProjectLookupDetailBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProjectLookupDetailViewModel>();
    final coordinator = context.read<AppCoordinator>();
    final project = viewModel.project;
    return LookupDetailScaffold(
      title: project?.projectNo.isNotEmpty == true
          ? project!.projectNo
          : '공사 상세',
      subtitle: project == null ? '' : 'id ${project.projectId}',
      onBack: coordinator.didTapBackFromLookupDetail,
      actions: [
        Button(onPressed: null, child: const Text('기본 정보 수정')),
        const SizedBox(width: 8),
        Button(
          onPressed: null,
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all(const Color(0xFFE85D5D)),
          ),
          child: const Text('지우기'),
        ),
      ],
      body: _body(viewModel),
    );
  }

  Widget _body(ProjectLookupDetailViewModel viewModel) {
    if (viewModel.isLoading && viewModel.project == null) {
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
    final project = viewModel.project;
    if (project == null) {
      return const InfoBar(
        title: Text('공사 없음'),
        severity: InfoBarSeverity.warning,
      );
    }
    return ListView(
      children: [
        LookupDetailKvGrid(
          entries: [
            ('공사 이름', project.projectName),
            ('현장', project.siteName),
            ('발주처', project.customer),
            ('작업', '${project.jobCount}건'),
          ],
        ),
        const SizedBox(height: 8),
        Button(onPressed: null, child: const Text('작업 탭에서 보기 →')),
        const LookupDetailSectionTitle('호기 · 품목 배정'),
        Text(
          '공사 번호는 만든 뒤 고칠 수 없습니다. 호기만 따로 만들 수 없고, 품목 이름을 바꾸면 그 배정을 쓰는 작업 이름이 함께 바뀝니다.',
          style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.55)),
        ),
        const SizedBox(height: 8),
        if (project.units.isEmpty)
          const Text('배정된 품목이 없습니다. 첫 품목을 넣으면 호기도 생깁니다.')
        else
          for (final unit in project.units) _unitBlock(unit),
        const SizedBox(height: 12),
        Button(onPressed: null, child: const Text('+ 호기 추가 (첫 품목과 함께)')),
      ],
    );
  }

  Widget _unitBlock(WorkHistoryUnitFilter unit) {
    final title = unit.unitNo == '00'
        ? '호기 구분 없음 (00)'
        : '${DashboardFormatters.unitNo(unit.unitNo)} (${unit.unitNo})';
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Expander(
        header: Text('$title · ${unit.items.length}품목'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final item in unit.items)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    SizedBox(
                      width: 48,
                      child: Text(unit.unitNo, style: const TextStyle(fontSize: 12)),
                    ),
                    SizedBox(
                      width: 88,
                      child: Text(item.itemCode, style: const TextStyle(fontSize: 12)),
                    ),
                    Expanded(
                      child: Text(
                        item.itemName.isEmpty ? '—' : item.itemName,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    Button(onPressed: null, child: const Text('작업 →')),
                    const SizedBox(width: 4),
                    Button(onPressed: null, child: const Text('이름 수정')),
                    const SizedBox(width: 4),
                    Button(onPressed: null, child: const Text('지우기')),
                  ],
                ),
              ),
            Button(onPressed: null, child: Text('+ ${unit.unitNo}에 품목 추가')),
          ],
        ),
      ),
    );
  }
}
