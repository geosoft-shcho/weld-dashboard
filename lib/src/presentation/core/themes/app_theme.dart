import 'package:fluent_ui/fluent_ui.dart';

class AppTheme {
  static const Color SURFACE = Color(0xFF1C1F24);
  static const Color SURFACE_RAISED = Color(0xFF2A2D32);
  static const Color INK = Color(0xFFE8EAED);
  static const Color ACCENT_STEEL = Color(0xFF8FA4C4);
  static const Color CTA = Color(0xFFE67E22);
  static const Color STATUS_OK = Color(0xFF5DBA7A);
  static const Color STATUS_WARN = Color(0xFFE0A14A);
  static const Color STATUS_ERROR = Color(0xFFE85D5D);
  static const Color STATUS_OFF = Color(0xFF8A8F98);
  static const Color STATUS_DESYNC = Color(0xFF8FA4C4);

  static const Color CHART_MASTER = Color(0xFF7EB6FF);
  static const Color CHART_BEGINNER = Color(0xFFE67E22);
  static const Color CHART_ROBOT = Color(0xFFC4B5FD);
  static const Color CHART_BAND = Color(0xFF3A3E46);
  static const Color CHART_BAND_ACTIVE = Color(0xFF4D5F7A);
  static const Color CHART_CURSOR = Color(0xFF8FA4C4);
  static const Color CHART_PLOT = Color(0xFF1C1F24);

  static AccentColor get steelAccent {
    return AccentColor.swatch({
      'darkest': const Color(0xFF4D5F7A),
      'darker': const Color(0xFF5D7394),
      'dark': const Color(0xFF6E89AE),
      'normal': ACCENT_STEEL,
      'light': const Color(0xFFA7B8D1),
      'lighter': const Color(0xFFC0CDE0),
      'lightest': const Color(0xFFD9E2EE),
    });
  }

  static FluentThemeData get dark {
    return FluentThemeData(
      brightness: Brightness.dark,
      accentColor: steelAccent,
      scaffoldBackgroundColor: SURFACE,
      micaBackgroundColor: SURFACE,
      cardColor: SURFACE_RAISED,
    );
  }

  static FluentThemeData get light {
    return FluentThemeData(
      brightness: Brightness.light,
      accentColor: steelAccent,
    );
  }
}
