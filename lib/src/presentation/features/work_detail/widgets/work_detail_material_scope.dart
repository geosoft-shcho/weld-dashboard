import 'package:flutter/material.dart';

import '../../../core/themes/app_theme.dart';

class WorkDetailMaterialScope extends StatelessWidget {
  const WorkDetailMaterialScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Localizations(
      locale: const Locale('ko'),
      delegates: const [
        DefaultMaterialLocalizations.delegate,
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
