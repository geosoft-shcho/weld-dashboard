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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _AssignBar(viewModel: viewModel),
        const SizedBox(height: 8),
        if (viewModel.reportSets.isEmpty)
          const InfoBar(
            title: Text('이 작업이 쓰는 성적서가 없습니다'),
            content: Text('아래에서 품목 세트를 고르거나, 성적서 PDF를 올려 주세요.'),
            severity: InfoBarSeverity.info,
          )
        else
          SizedBox(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final set in viewModel.reportSets)
                  _SetCard(
                    summary: set,
                    isSelected: set.reportSetId == viewModel.selectedReportSetId,
                    onSelect: () =>
                        viewModel.didSelectReportSet(set.reportSetId),
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

class _AssignBar extends StatelessWidget {
  const _AssignBar({required this.viewModel});

  final WorkDetailViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final busy = viewModel.isReportAssigning;
    final candidates = viewModel.reportCandidates;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Text('성적서 세트', style: TextStyle(fontSize: 12)),
        ComboBox<String>(
          placeholder: const Text('품목 세트 고르기'),
          isExpanded: false,
          items: [
            for (final set in candidates)
              ComboBoxItem(
                value: set.reportSetId,
                child: Text(
                  [
                    set.reportSetId,
                    set.isUnmatched ? '본인 품목 없음' : set.commonKey,
                    set.itemName,
                  ].where((t) => t.isNotEmpty).join(' · '),
                ),
              ),
          ],
          onChanged: busy || candidates.isEmpty
              ? null
              : (value) {
                  if (value != null) {
                    viewModel.didAssignReportSet(value);
                  }
                },
        ),
        Button(
          onPressed: busy ? null : () => viewModel.didClearReportSet(),
          child: const Text('지정 풀기'),
        ),
        if (busy) const SizedBox(width: 16, height: 16, child: ProgressRing()),
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
                summary.isUnmatched ? '본인 품목 없음' : summary.commonKey,
                summary.itemName,
                '호기 ${summary.unitNo}',
                '공사 ${summary.projectNo}',
                if (pages.isNotEmpty) '쪽 $pages',
                '확인 ${summary.reviewCount}',
                if (summary.splitAssetId.isNotEmpty) 'PDF 있음',
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
          onEditReview: (review, value) => viewModel.didUpdateReportField(
            table: _tableOf(review.columnName),
            rowId: _rowIdOf(review, detail),
            column: _columnOf(review.columnName),
            value: value,
            reviewId: review.id,
          ),
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
    required this.onEditReview,
  });

  final ReportSetDetail detail;
  final ValueChanged<int?> onSelectSection;
  final Future<void> Function(ReportReviewRow review, String value) onEditReview;

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
                  if (section.table.isNotEmpty) section.table,
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
        const SizedBox(height: 4),
        const Text(
          '값을 바꾸려면 행의 [고치기]를 씁니다. 확인만 하면 세트 값은 안 바뀝니다.',
          style: TextStyle(fontSize: 12),
        ),
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
              1: FlexColumnWidth(1.4),
              2: FlexColumnWidth(1.4),
              3: FlexColumnWidth(1.0),
              4: FlexColumnWidth(0.8),
            },
            children: [
              const TableRow(
                children: [
                  _Cell('칸', isHeader: true),
                  _Cell('값', isHeader: true),
                  _Cell('원문', isHeader: true),
                  _Cell('이유', isHeader: true),
                  _Cell('', isHeader: true),
                ],
              ),
              for (final review in detail.reviews)
                TableRow(
                  children: [
                    _Cell(review.field),
                    _Cell(
                      review.correctedValue.isEmpty
                          ? review.value
                          : '${review.value} → ${review.correctedValue}',
                    ),
                    _Cell(review.raw),
                    _Cell(review.reason),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Button(
                        onPressed: () => _editReview(context, review),
                        child: const Text('고치기'),
                      ),
                    ),
                  ],
                ),
            ],
          ),
      ],
    );
  }

  Future<void> _editReview(BuildContext context, ReportReviewRow review) async {
    final controller = TextEditingController(
      text: review.correctedValue.isEmpty ? review.value : review.correctedValue,
    );
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => ContentDialog(
        title: Text('${review.field} 고치기'),
        content: InfoLabel(
          label: '새 값',
          child: TextBox(controller: controller),
        ),
        actions: [
          Button(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('저장'),
          ),
        ],
      ),
    );
    final value = controller.text.trim();
    controller.dispose();
    if (ok != true) {
      return;
    }
    await onEditReview(review, value);
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

String _tableOf(String columnName) {
  final dot = columnName.indexOf('.');
  if (dot <= 0) {
    return 'report_set';
  }
  return columnName.substring(0, dot);
}

String _columnOf(String columnName) {
  final dot = columnName.indexOf('.');
  if (dot < 0 || dot >= columnName.length - 1) {
    return columnName;
  }
  return columnName.substring(dot + 1);
}

String _rowIdOf(ReportReviewRow review, ReportSetDetail detail) {
  final table = _tableOf(review.columnName);
  if (table == 'report_set') {
    return detail.summary.reportSetId;
  }
  for (final section in detail.sections) {
    if (section.table == table) {
      for (final field in section.fields) {
        if (field.key == _columnOf(review.columnName) &&
            field.rowId.isNotEmpty) {
          return field.rowId;
        }
      }
      if (section.fields.isNotEmpty && section.fields.first.rowId.isNotEmpty) {
        return section.fields.first.rowId;
      }
    }
  }
  return detail.summary.reportSetId;
}
