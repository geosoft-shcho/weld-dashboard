import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';

import 'clip_detail_sections.dart';
import '../video_multimodal_view_model.dart';
import 'multimodal_studio_palette.dart';
import 'side_panel_chrome.dart';

class PropertiesSideBody extends StatelessWidget {
  const PropertiesSideBody({super.key, required this.viewModel, required this.onClose});

  final VideoMultimodalViewModel viewModel;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final clip = viewModel.selectedClip;
    final bar = viewModel.selectedBar;
    return SidePanelFrame(
      head: SidePanelHead(title: 'Properties', onClose: onClose),
      body: ListView(
        children: [
          if (clip == null && bar == null)
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                '타임라인 클립을 선택하면 속성이 표시됩니다.',
                style: TextStyle(
                  color: MultimodalStudioPalette.PANEL_MUTED,
                  fontSize: 11,
                ),
              ),
            )
          else if (clip == null)
            ColoredBox(
              color: MultimodalStudioPalette.PANEL_PAPER,
              child: Column(
                children: [
                  const SidePanelDataRow([
                    SidePanelDataCell('항목', isHeader: true, flex: 1),
                    SidePanelDataCell('값', isHeader: true, flex: 1),
                  ], isHeader: true),
                  SidePanelDataRow([
                    const SidePanelDataCell('이름', flex: 2),
                    SidePanelDataCell(bar!.fileName, flex: 3),
                  ]),
                  SidePanelDataRow([
                    const SidePanelDataCell('유형', flex: 2),
                    SidePanelDataCell(bar.fileTypeLabel, flex: 3),
                  ]),
                  SidePanelDataRow([
                    const SidePanelDataCell('구간', flex: 2),
                    SidePanelDataCell(viewModel.playheadLabel, flex: 3),
                  ]),
                  if (bar.note.isNotEmpty)
                    SidePanelDataRow([
                      const SidePanelDataCell('메모', flex: 2),
                      SidePanelDataCell(bar.note, flex: 3),
                    ]),
                ],
              ),
            )
          else if (viewModel.isClipDetailLoading)
            const Padding(
              padding: EdgeInsets.all(12),
              child: SizedBox(
                width: double.infinity,
                child: fluent.ProgressBar(strokeWidth: 2),
              ),
            )
          else
            ..._clipDetailChildren(),
        ],
      ),
      foot: const SidePanelFootNote('타임라인에서 고른 클립과 같은 시각의 수집값입니다.'),
    );
  }

  List<Widget> _clipDetailChildren() {
    final message = viewModel.clipDetailMessage;
    final sections = groupClipDetailFields(viewModel.clipDetailFields);
    if (message.isNotEmpty && sections.isEmpty) {
      return [_detailMessage(message)];
    }
    return [
      if (message.isNotEmpty) _detailMessage(message),
      for (final section in sections) ...[
        SidePanelSectionLabel(section.title),
        _PropertyTable(rows: section.rows),
      ],
    ];
  }
}

class _PropertyTable extends StatelessWidget {
  const _PropertyTable({required this.rows});

  final List<ClipDetailRow> rows;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: MultimodalStudioPalette.PANEL_PAPER,
      child: Column(
        children: [
          const SidePanelDataRow([
            SidePanelDataCell('항목', isHeader: true, flex: 1),
            SidePanelDataCell('값', isHeader: true, flex: 1),
          ], isHeader: true),
          for (final row in rows)
            SidePanelDataRow([
              SidePanelDataCell(row.label, flex: 1),
              SidePanelDataCell(row.value, flex: 1),
            ]),
        ],
      ),
    );
  }
}

Widget _detailMessage(String message) {
  return Padding(
    padding: const EdgeInsets.all(12),
    child: Text(
      message,
      style: const TextStyle(
        color: MultimodalStudioPalette.PANEL_MUTED,
        fontSize: 11,
      ),
    ),
  );
}
