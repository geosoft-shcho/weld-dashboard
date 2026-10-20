import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../core/di/locator.dart';
import '../../core/widgets/catalog_lookup_table.dart';
import '../../core/widgets/lookup_search_field.dart';
import '../../navigation/app_coordinator.dart';
import 'project_create_dialog.dart';
import 'project_lookup_view_model.dart';

class ProjectLookupScreen extends StatelessWidget {
  const ProjectLookupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator<ProjectLookupViewModel>()..load(),
      child: const _ProjectLookupBody(),
    );
  }
}

class _ProjectLookupBody extends StatelessWidget {
  const _ProjectLookupBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProjectLookupViewModel>();
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      content: Padding(
        padding: const EdgeInsets.all(16),
        child: _content(context, viewModel),
      ),
    );
  }

  Widget _content(BuildContext context, ProjectLookupViewModel viewModel) {
    if (viewModel.isLoading && viewModel.visibleProjects.isEmpty) {
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
    final projects = viewModel.visibleProjects;
    return CatalogLookupFrame(
      tableHeader: Row(
        children: [
          Text('공사', style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(width: 4),
          Text(
            '${viewModel.totalCount}건',
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Color.fromARGB(255, 196, 196, 196),
            ),
          ),
          const Spacer(),
          FilledButton(
            onPressed: () => _didTapNewProject(context, viewModel),
            child: const Text('+ 새 공사'),
          ),
        ],
      ),
      filters: [
        InfoLabel(
          label: '검색',
          child: SizedBox(
            width: 360,
            child: LookupSearchField(
              value: viewModel.queryText,
              hintText: '번호 · 이름 · 현장 · 발주처 · 품목',
              onChanged: viewModel.didChangeQueryText,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Checkbox(
            checked: viewModel.emptyJobsOnly,
            content: const Text('작업 없는 공사만'),
            onChanged: (value) {
              if (value != null) {
                viewModel.didToggleEmptyJobsOnly(value);
              }
            },
          ),
        ),
      ],
      body: CatalogLookupTable(
        headers: const ['공사 번호', '이름', '현장 · 발주처', '호기 · 품목', '작업'],
        columnFlexes: const [12, 18, 16, 28, 8],
        emptyTitle: '조건에 맞는 공사가 없습니다',
        isLoadingMore: viewModel.isLoadingMore,
        onNearEnd: viewModel.didScrollNearEnd,
        rows: [
          for (final project in projects)
            [
              project.projectNo,
              project.projectName,
              projectSiteCustomer(project),
              projectUnitsText(project),
              '${project.jobCount}건',
            ],
        ],
        onRowTap: (index) {
          final project = projects[index];
          if (project.projectId.isEmpty) {
            return;
          }
          context.read<AppCoordinator>().didTapOpenProjectDetail(
            project.projectId,
          );
        },
      ),
    );
  }
}

Future<void> _didTapNewProject(
  BuildContext context,
  ProjectLookupViewModel viewModel,
) async {
  final projectId = await showProjectCreateDialog(context, viewModel);
  if (projectId == null || projectId.isEmpty || !context.mounted) {
    return;
  }
  await viewModel.load();
  if (!context.mounted) {
    return;
  }
  context.read<AppCoordinator>().didTapOpenProjectDetail(projectId);
}
