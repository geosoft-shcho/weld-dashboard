import 'package:fluent_ui/fluent_ui.dart';

import '../../../core/themes/app_theme.dart';
import '../video_multimodal_view_model.dart';
import 'camera_recording_dialog.dart';
import 'multimodal_dialogs.dart';

/// S01 상단 툴바 배치. 버튼 묶음만 맞추고, 라벨링 페이지의 저장·추론은 호출하지 않는다.
class MultimodalPageToolbar extends StatelessWidget {
  const MultimodalPageToolbar({
    super.key,
    required this.viewModel,
    required this.title,
    required this.onBack,
  });

  static const double BAR_HEIGHT = 48;

  final VideoMultimodalViewModel viewModel;
  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    final locked = viewModel.isLoading;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.SURFACE_RAISED,
        border: Border(
          bottom: BorderSide(color: theme.resources.cardStrokeColorDefault),
        ),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
            height: BAR_HEIGHT,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  _ToolbarButton(
                    icon: FluentIcons.back,
                    label: '',
                    enabled: true,
                    onPressed: onBack,
                  ),
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            color: theme.resources.cardStrokeColorDefault,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.typography.body?.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  _group(
                    theme,
                    children: [
                      _ToolbarButton(
                        icon: FluentIcons.refresh,
                        label: '새로고침',
                        enabled: !locked,
                        onPressed: viewModel.didTapRefresh,
                      ),
                    ],
                  ),
                  _group(
                    theme,
                    children: [
                      _ToolbarButton(
                        icon: FluentIcons.folder,
                        label: 'Assets',
                        enabled: !locked,
                        selected: viewModel.isAssetsOpen,
                        onPressed: viewModel.didTapToggleAssets,
                      ),
                      _ToolbarButton(
                        icon: FluentIcons.equalizer,
                        label: 'Properties',
                        enabled: !locked,
                        selected: viewModel.isPropertiesOpen,
                        onPressed: viewModel.didTapToggleProperties,
                      ),
                      _ToolbarButton(
                        icon: FluentIcons.tag,
                        label: 'Labels',
                        enabled: !locked,
                        selected: viewModel.isLabelsOpen,
                        onPressed: viewModel.didTapToggleLabels,
                      ),
                    ],
                  ),
                  _group(
                    theme,
                    children: [
                      _ToolbarButton(
                        icon: FluentIcons.chat,
                        label: '질문',
                        enabled: !locked,
                        selected: viewModel.isAskOpen,
                        onPressed: viewModel.didTapToggleAsk,
                      ),
                      _ToolbarButton(
                        icon: FluentIcons.auto_enhance_on,
                        label: '추론',
                        enabled: !locked,
                        onPressed: () =>
                            showMultimodalInferencePicker(context, viewModel),
                      ),
                    ],
                  ),

                  _group(
                    theme,
                    children: [
                      _ToolbarButton(
                        icon: FluentIcons.video,
                        label: '녹화',
                        enabled: !locked,
                        onPressed: () => showCameraRecordingDialog(context),
                      ),
                    ],
                  ),
                  _group(
                    theme,
                    isLast: true,
                    children: [
                      _ToolbarButton(
                        icon: FluentIcons.save,
                        label: '레이어 저장',
                        enabled: !locked,
                        accent: true,
                        onPressed: () => showMultimodalPersistDialog(
                          context,
                          succeeded: viewModel.pageTitle.trim().isNotEmpty,
                        ),
                      ),
                      _ToolbarButton(
                        icon: FluentIcons.delete,
                        label: '레이어 삭제',
                        enabled: !locked,
                        onPressed: () =>
                            showMultimodalLayerDeleteDialog(context, viewModel),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (locked)
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 2,
              child: ProgressBar(strokeWidth: 2),
            ),
        ],
      ),
    );
  }

  Widget _group(
    FluentThemeData theme, {
    required List<Widget> children,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(right: isLast ? 0 : 6),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(
                  right: BorderSide(
                    color: theme.resources.cardStrokeColorDefault,
                  ),
                ),
        ),
        child: Padding(
          padding: EdgeInsets.only(right: isLast ? 0 : 6),
          child: Row(mainAxisSize: MainAxisSize.min, children: children),
        ),
      ),
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  const _ToolbarButton({
    required this.icon,
    required this.label,
    required this.enabled,
    required this.onPressed,
    this.selected = false,
    this.accent = false,
  });

  final IconData icon;
  final String label;
  final bool enabled;
  final bool selected;
  final bool accent;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    final foreground = selected
        ? Colors.white
        : accent
        ? AppTheme.ACCENT_STEEL
        : theme.resources.textFillColorPrimary;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Button(
        onPressed: enabled ? onPressed : null,
        style: ButtonStyle(
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          ),
          backgroundColor: WidgetStatePropertyAll(
            selected ? AppTheme.ACCENT_STEEL : Colors.transparent,
          ),
          foregroundColor: WidgetStatePropertyAll(foreground),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: foreground),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(fontSize: 12, color: foreground)),
          ],
        ),
      ),
    );
  }
}
