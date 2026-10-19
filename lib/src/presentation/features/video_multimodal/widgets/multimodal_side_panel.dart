import 'package:flutter/material.dart';

import '../../work_detail/widgets/work_detail_material_scope.dart';
import '../video_multimodal_view_model.dart';
import 'ask_side_body.dart';
import 'assets_side_body.dart';
import 'labels_side_body.dart';
import 'multimodal_studio_palette.dart';
import 'properties_side_body.dart';

class MultimodalSidePanel extends StatelessWidget {
  const MultimodalSidePanel({
    super.key,
    required this.viewModel,
    required this.onClose,
  });

  final VideoMultimodalViewModel viewModel;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final width = switch (viewModel.side) {
      VideoMultimodalSide.ask => 360.0,
      VideoMultimodalSide.assets => 360.0,
      VideoMultimodalSide.properties => 360.0,
      _ => 320.0,
    };
    return WorkDetailMaterialScope(
      child: Material(
        color: MultimodalStudioPalette.PANEL_PAGE,
        child: SizedBox(
          width: width,
          child: switch (viewModel.side) {
            VideoMultimodalSide.assets => AssetsSideBody(
              viewModel: viewModel,
              onClose: onClose,
            ),
            VideoMultimodalSide.properties => PropertiesSideBody(
              viewModel: viewModel,
              onClose: onClose,
            ),
            VideoMultimodalSide.ask => AskSideBody(
              viewModel: viewModel,
              onClose: onClose,
            ),
            VideoMultimodalSide.labels => LabelsSideBody(
              viewModel: viewModel,
              onClose: onClose,
            ),
            VideoMultimodalSide.none => const SizedBox.shrink(),
          },
        ),
      ),
    );
  }
}
