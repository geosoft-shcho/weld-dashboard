import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:provider/provider.dart';
import 'package:waveform_visualizer/waveform_visualizer.dart';

import 'src/presentation/core/di/locator.dart';
import 'src/presentation/core/themes/app_theme.dart';
import 'src/presentation/features/app_shell/shell_view_model.dart';
import 'src/presentation/navigation/app_coordinator.dart';
import 'src/presentation/navigation/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureAppUrlStrategy();
  SemanticsBinding.instance.ensureSemantics();
  WaveformVisualizer.initialize();
  final pdfrxReady = await _initializePdfrx();
  setupLocator(pdfrxReady: pdfrxReady);
  runApp(const WeldDashboardApp());
}

Future<bool> _initializePdfrx() async {
  try {
    await pdfrxFlutterInitialize();
    return true;
  } catch (_) {
    return false;
  }
}

class WeldDashboardApp extends StatefulWidget {
  const WeldDashboardApp({super.key});

  @override
  State<WeldDashboardApp> createState() => _WeldDashboardAppState();
}

class _WeldDashboardAppState extends State<WeldDashboardApp> {
  late final AppCoordinator _coordinator;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _coordinator = locator<AppCoordinator>();
    _router = createAppRouter(
      onLocationChanged: _coordinator.didApplyRoute,
    );
    _coordinator.attachNavigation(GoRouterAppNavigation(_router));
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppCoordinator>.value(
          value: _coordinator,
        ),
        ChangeNotifierProvider<ShellViewModel>(
          create: (_) => locator<ShellViewModel>(),
        ),
      ],
      child: FluentApp.router(
        title: '용접 수집 모니터링',
        themeMode: ThemeMode.dark,
        darkTheme: AppTheme.dark,
        theme: AppTheme.light,
        routerConfig: _router,
      ),
    );
  }
}
