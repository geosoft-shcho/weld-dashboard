import 'package:fluent_ui/fluent_ui.dart';

class FilterFlyoutButton extends StatefulWidget {
  const FilterFlyoutButton({
    super.key,
    required this.title,
    required this.summary,
    required this.panelBuilder,
  });

  final String title;
  final String summary;
  final WidgetBuilder panelBuilder;

  @override
  State<FilterFlyoutButton> createState() => _FilterFlyoutButtonState();
}

class _FilterFlyoutButtonState extends State<FilterFlyoutButton> {
  final FlyoutController _controller = FlyoutController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      width: double.infinity,
      child: FlyoutTarget(
        controller: _controller,
        child: Button(
          onPressed: () {
            _controller.showFlyout(
              builder: (flyoutContext) {
                return FlyoutContent(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 280,
                      maxHeight: 320,
                    ),
                    child: widget.panelBuilder(flyoutContext),
                  ),
                );
              },
            );
          },
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.summary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(FluentIcons.chevron_down, size: 10),
            ],
          ),
        ),
      ),
    );
  }
}
