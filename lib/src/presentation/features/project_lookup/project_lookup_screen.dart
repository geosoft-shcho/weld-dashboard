import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../core/di/locator.dart';
import '../../core/widgets/catalog_lookup_table.dart';
import '../../core/widgets/lookup_search_field.dart';
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
        child: _content(viewModel),
      ),
    );
  }

  Widget _content(ProjectLookupViewModel viewModel) {
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
      actionLabel: '새 공사',
      filters: [
        InfoLabel(
          label: '검색',
          child: SizedBox(
            width: 360,
            child: LookupSearchField(
              value: viewModel.queryText,
              hintText: '공사 번호 · 이름 · 현장 · 발주처 · 품목',
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
      ),
    );
  }
}
