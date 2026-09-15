import 'package:fluent_ui/fluent_ui.dart';

import '../../../../domain/entities/work_detail_tab.dart';
import '../work_detail_view_model.dart';
import 'work_detail_image_viewer.dart';
import 'work_detail_media_viewers.dart';
import 'work_detail_overview.dart';
import 'work_detail_pdf_viewer.dart';
import 'work_detail_text_viewer.dart';

class WorkDetailStage extends StatelessWidget {
  const WorkDetailStage({super.key, required this.viewModel});

  final WorkDetailViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    switch (viewModel.selectedTab) {
      case WorkDetailTab.overview:
        return WorkDetailOverview(viewModel: viewModel);
      case WorkDetailTab.image:
        return WorkDetailImageViewer(viewModel: viewModel);
      case WorkDetailTab.video:
        return WorkDetailVideoViewer(viewModel: viewModel);
      case WorkDetailTab.pdf:
        return WorkDetailPdfViewer(viewModel: viewModel);
      case WorkDetailTab.audio:
        return WorkDetailAudioViewer(viewModel: viewModel);
      case WorkDetailTab.text:
        return WorkDetailTextViewer(viewModel: viewModel);
    }
  }
}
