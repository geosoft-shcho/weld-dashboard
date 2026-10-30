import 'package:fluent_ui/fluent_ui.dart';

/// 페이지 본문을 대체하는 조회 실패. 로딩과 같이 콘텐츠 중앙에 둔다.
class QueryFailurePane extends StatelessWidget {
  const QueryFailurePane({
    super.key,
    required this.title,
    required this.message,
    this.onRetry,
    this.retryLabel = '재시도',
  });

  final String title;
  final String message;
  final VoidCallback? onRetry;
  final String retryLabel;

  static const double _maxWidth = 520;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _maxWidth),
        child: InfoBar(
          title: Text(title),
          content: Text(message),
          severity: InfoBarSeverity.error,
          action: onRetry == null
              ? null
              : Button(onPressed: onRetry, child: Text(retryLabel)),
        ),
      ),
    );
  }
}
