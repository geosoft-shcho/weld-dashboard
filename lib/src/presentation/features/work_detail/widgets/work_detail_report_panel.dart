import 'package:fluent_ui/fluent_ui.dart';

import '../../../../domain/entities/report_set.dart';
import '../../../core/themes/app_theme.dart';
import '../../../core/widgets/pdfrx_document_source.dart';
import '../../../core/widgets/pdfrx_document_viewer.dart';
import '../work_detail_view_model.dart';

class WorkDetailReportPanel extends StatelessWidget {
  const WorkDetailReportPanel({super.key, required this.viewModel});

  final WorkDetailViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    if (viewModel.reportError.isNotEmpty) {
      return InfoBar(
        title: const Text('조회 실패'),
        content: Text(viewModel.reportError),
        severity: InfoBarSeverity.error,
      );
    }
    if (viewModel.reportSets.isEmpty) {
      return const InfoBar(
        title: Text('성적서가 없습니다'),
        severity: InfoBarSeverity.info,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 132,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (final set in viewModel.reportSets)
                _SetCard(
                  summary: set,
                  isSelected: set.reportSetId == viewModel.selectedReportSetId,
                  onSelect: () => viewModel.didSelectReportSet(set.reportSetId),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(child: _SetBody(viewModel: viewModel)),
      ],
    );
  }
}

class _SetCard extends StatelessWidget {
  const _SetCard({
    required this.summary,
    required this.isSelected,
    required this.onSelect,
  });

  final ReportSetSummary summary;
  final bool isSelected;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final pages = _pageRange(summary.pageStart, summary.pageEnd);
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: SizedBox(
        width: 280,
        child: Button(
          onPressed: onSelect,
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              isSelected ? const Color(0xFF3A4558) : const Color(0xFF2A2D32),
            ),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              [
                summary.reportSetId,
                summary.isUnmatched ? '미매칭' : summary.commonKey,
                summary.itemName,
                '호기 ${summary.unitNo}',
                '공사 ${summary.projectNo}',
                if (pages.isNotEmpty) '쪽 $pages',
                '확인 ${summary.reviewCount}',
                [
                  for (final section in summary.sections)
                    if (section.kindLabel.isNotEmpty ||
                        section.overallResult.isNotEmpty)
                      '${section.kindLabel} ${section.overallResult}'.trim(),
                ].join(' · '),
              ].where((line) => line.trim().isNotEmpty).join('\n'),
              maxLines: 8,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}

class _SetBody extends StatelessWidget {
  const _SetBody({required this.viewModel});

  final WorkDetailViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    if (viewModel.selectedReportSetId.isEmpty) {
      return const InfoBar(
        title: Text('성적서 세트를 고르세요'),
        severity: InfoBarSeverity.info,
      );
    }
    if (viewModel.isReportDetailLoading) {
      return const Center(child: ProgressRing());
    }
    if (viewModel.reportDetailError.isNotEmpty) {
      return InfoBar(
        title: const Text('조회 실패'),
        content: Text(viewModel.reportDetailError),
        severity: InfoBarSeverity.error,
      );
    }
    final detail = viewModel.reportDetail;
    if (detail == null) {
      return const SizedBox.shrink();
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final body = _SectionAndReviews(
          detail: detail,
          onSelectSection: viewModel.didSelectReportSection,
        );
        final pdf = _SplitPdf(
          pdfUrl: detail.pdfUrl,
          page: viewModel.reportPdfPage,
        );
        if (constraints.maxWidth >= 960) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: body),
              const SizedBox(width: 12),
              Expanded(child: pdf),
            ],
          );
        }
        return Column(
          children: [
            Expanded(child: body),
            const SizedBox(height: 12),
            Expanded(child: pdf),
          ],
        );
      },
    );
  }
}

class _SectionAndReviews extends StatelessWidget {
  const _SectionAndReviews({
    required this.detail,
    required this.onSelectSection,
  });

  final ReportSetDetail detail;
  final ValueChanged<int?> onSelectSection;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Text('섹션', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        for (final section in detail.sections) ...[
          Button(
            onPressed: () => onSelectSection(section.splitPageStart),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                [
                  section.kindLabel,
                  _pageLabel(section),
                ].where((line) => line.isNotEmpty).join(' · '),
              ),
            ),
          ),
          const SizedBox(height: 4),
          for (final field in section.fields)
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 2),
              child: Text('${field.key}: ${field.value}'),
            ),
          const SizedBox(height: 12),
        ],
        const Text('확인 목록', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        if (detail.reviews.isEmpty)
          const Text('확인 목록이 없습니다')
        else
          Table(
            border: TableBorder.all(
              color: AppTheme.STATUS_OFF.withValues(alpha: 0.35),
            ),
            columnWidths: const {
              0: FlexColumnWidth(1.4),
              1: FlexColumnWidth(1.6),
              2: FlexColumnWidth(1.6),
              3: FlexColumnWidth(1.2),
            },
            children: [
              const TableRow(
                children: [
                  _Cell('칸', isHeader: true),
                  _Cell('값', isHeader: true),
                  _Cell('원문', isHeader: true),
                  _Cell('이유', isHeader: true),
                ],
              ),
              for (final review in detail.reviews)
                TableRow(
                  children: [
                    _Cell(review.field),
                    _Cell(review.value),
                    _Cell(review.raw),
                    _Cell(review.reason),
                  ],
                ),
            ],
          ),
      ],
    );
  }
}

class _SplitPdf extends StatelessWidget {
  const _SplitPdf({required this.pdfUrl, required this.page});

  final String pdfUrl;
  final int? page;

  @override
  Widget build(BuildContext context) {
    if (pdfUrl.isEmpty) {
      return const InfoBar(
        title: Text('잘라 낸 PDF는 아직 없습니다'),
        severity: InfoBarSeverity.info,
      );
    }
    final source = resolvePdfrxDocumentSource(pdfUrl);
    if (source == null) {
      return const InfoBar(
        title: Text('PDF 주소를 열 수 없습니다'),
        severity: InfoBarSeverity.warning,
      );
    }
    return PdfrxDocumentViewer(
      key: ValueKey(pdfUrl),
      source: source,
      initialPage: page,
      backgroundColor: AppTheme.SURFACE,
      expandViewport: true,
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell(this.text, {this.isHeader = false});

  final String text;
  final bool isHeader;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: TextStyle(fontWeight: isHeader ? FontWeight.w600 : null),
      ),
    );
  }
}

String _pageRange(int? start, int? end) {
  if (start == null && end == null) {
    return '';
  }
  if (start != null && end != null && start != end) {
    return '$start–$end';
  }
  return '${start ?? end}';
}

String _pageLabel(ReportSectionBody section) {
  final original = _pageRange(
    section.originalPageStart,
    section.originalPageEnd,
  );
  final split = section.splitPageStart;
  if (original.isEmpty && split == null) {
    return '';
  }
  if (split == null) {
    return '원본 $original쪽';
  }
  if (original.isEmpty) {
    return 'PDF $split쪽';
  }
  return '원본 $original쪽 · PDF $split쪽';
}
