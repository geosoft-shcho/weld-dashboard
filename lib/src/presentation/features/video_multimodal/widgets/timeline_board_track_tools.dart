import 'package:flutter/material.dart';

import '../video_multimodal_view_model.dart';
import 'multimodal_studio_palette.dart';

/// 트랙 목록 메뉴 오버레이 (전체/개별 체크).
class TimelineBoardTrackMenu extends StatelessWidget {
  const TimelineBoardTrackMenu({
    super.key,
    required this.viewModel,
    required this.boardHeight,
  });

  final VideoMultimodalViewModel viewModel;
  final double boardHeight;

  static const TextStyle _labelStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );

  @override
  Widget build(BuildContext context) {
    const menuTop = 36.0;
    const menuBottomPad = 8.0;
    const rowChrome = 38.0;
    final maxHeight = (boardHeight - menuTop - menuBottomPad).clamp(
      120.0,
      double.infinity,
    );
    final tracks = <({String key, String label})>[
      for (final track in viewModel.timelineTracks)
        (
          key: track.trackId,
          label: track.name.trim().isEmpty ? '트랙' : track.name.trim(),
        ),
    ];
    var menuWidth = 196.0;
    final scaler = MediaQuery.textScalerOf(context);
    for (final label in ['전체', ...tracks.map((track) => track.label)]) {
      final width = rowChrome + _labelTextWidth(label, scaler);
      if (width > menuWidth) {
        menuWidth = width;
      }
    }
    return Positioned(
      right: 12,
      top: menuTop,
      child: Material(
        elevation: 6,
        color: MultimodalStudioPalette.SAND_0,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: maxHeight,
            maxWidth: menuWidth,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: [
                InkWell(
                  onTap: viewModel.didTapToggleAllTracks,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Icon(
                          viewModel.areAllTracksEnabled
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          size: 16,
                          color: MultimodalStudioPalette.SAND_700,
                        ),
                        const SizedBox(width: 6),
                        const Expanded(
                          child: Text(
                            '전체',
                            style: TextStyle(
                              color: MultimodalStudioPalette.SAND_900,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: MultimodalStudioPalette.SAND_300,
                  ),
                ),
                for (final track in tracks)
                  InkWell(
                    onTap: () =>
                        viewModel.didTapToggleTrackVisibility(track.key),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          Icon(
                            viewModel.isTrackVisible(track.key)
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            size: 16,
                            color: MultimodalStudioPalette.SAND_700,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              track.label,
                              style: const TextStyle(
                                color: MultimodalStudioPalette.SAND_900,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _labelTextWidth(String text, TextScaler scaler) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: _labelStyle),
      maxLines: 1,
      textDirection: TextDirection.ltr,
      textScaler: scaler,
    )..layout();
    final width = painter.width;
    painter.dispose();
    return width;
  }
}
