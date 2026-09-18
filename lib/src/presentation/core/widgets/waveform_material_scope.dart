import 'package:flutter/cupertino.dart' show DefaultCupertinoLocalizations;
import 'package:flutter/material.dart';

import '../themes/app_theme.dart';

/// FluentApp 안에 Material/Cupertino 위젯(pdfrx 선택 툴바 등)을 둘 때 쓴다.
///
/// [DefaultMaterialLocalizations] / [DefaultCupertinoLocalizations]는 `en`만
/// 지원하므로 locale을 `ko`로 두면 CupertinoLocalizations가 비어
/// [AdaptiveTextSelectionToolbar] 오른쪽 클릭 메뉴가 깨진다.
class WaveformMaterialScope extends StatelessWidget {
  const WaveformMaterialScope({super.key, required this.child});

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
