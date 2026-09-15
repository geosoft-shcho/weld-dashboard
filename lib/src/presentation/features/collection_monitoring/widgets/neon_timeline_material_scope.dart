import 'package:flutter/material.dart';
import 'package:neon_timeline_flutter/timeline_v16.dart' hide TimelineViewKind;

import '../../../core/themes/app_theme.dart' show AppTheme;

class NeonTimelineMaterialScope extends StatelessWidget {
  const NeonTimelineMaterialScope({super.key, required this.child});

  final Widget child;

  static TimelineThemeData timelineTheme() {
    return TimelineThemeData.modern(
      brightness: Brightness.dark,
      seed: AppTheme.ACCENT_STEEL,
    ).copyWith(
      backgroundColor: AppTheme.SURFACE,
      surfaceColor: AppTheme.SURFACE_RAISED,
      surfaceVariantColor: const Color(0xFF32363C),
      primaryColor: AppTheme.ACCENT_STEEL,
      textColor: AppTheme.INK,
      mutedTextColor: const Color(0xFFB0B6C0),
      successColor: AppTheme.STATUS_OK,
      warningColor: AppTheme.STATUS_WARN,
      errorColor: AppTheme.STATUS_ERROR,
      dividerColor: const Color(0xFF3E424A),
      selectionColor: AppTheme.ACCENT_STEEL,
      cardRadius: 4,
    );
  }

  static NeonPlannerTimelineThemeData plannerTheme() {
    return NeonPlannerTimelineThemeData.dark().copyWith(
      canvasColor: AppTheme.SURFACE,
      surfaceColor: AppTheme.SURFACE_RAISED,
      dayAccentColor: AppTheme.ACCENT_STEEL,
      nightAccentColor: AppTheme.STATUS_DESYNC,
      successColor: AppTheme.STATUS_OK,
      warningColor: AppTheme.STATUS_WARN,
      errorColor: AppTheme.STATUS_ERROR,
      focusColor: AppTheme.ACCENT_STEEL,
      selectionColor: const Color(0x288FA4C4),
      surfaceRadius: 4,
      nodeRadius: 18,
    );
  }

  @override
  Widget build(BuildContext context) {
    final timelineThemeData = timelineTheme();
    final plannerThemeData = plannerTheme();
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
            error: AppTheme.STATUS_ERROR,
          ),
          scaffoldBackgroundColor: AppTheme.SURFACE,
          extensions: [timelineThemeData, plannerThemeData],
        ),
        child: TimelineTheme(
          data: timelineThemeData,
          child: NeonPlannerTimelineTheme(
            data: plannerThemeData,
            child: Material(type: MaterialType.transparency, child: child),
          ),
        ),
      ),
    );
  }
}
