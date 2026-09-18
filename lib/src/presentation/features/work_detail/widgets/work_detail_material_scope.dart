import 'package:flutter/cupertino.dart' show DefaultCupertinoLocalizations;
import 'package:flutter/material.dart';

import '../../../core/themes/app_theme.dart';

/// FluentApp 안에 Material/Cupertino 위젯을 둘 때 쓴다.
///
/// Default*Localizations는 `en`만 지원한다. `ko`로 두면 오른쪽 클릭
/// [AdaptiveTextSelectionToolbar]가 CupertinoLocalizations를 못 찾는다.
class WorkDetailMaterialScope extends StatelessWidget {
  const WorkDetailMaterialScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Localizations(
      locale: const Locale('en'),
      delegates: const [
        DefaultMaterialLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      child: Theme(
        data: ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
          colorScheme: const ColorScheme.dark(
            primary: AppTheme.ACCENT_STEEL,
            surface: AppTheme.SURFACE_RAISED,
          ),
        ),
        child: Material(type: MaterialType.transparency, child: child),
      ),
    );
  }
}
