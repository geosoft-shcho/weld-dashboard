import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:provider/provider.dart';
import 'package:waveform_visualizer/waveform_visualizer.dart';

import 'src/presentation/core/di/locator.dart';
import 'src/presentation/core/themes/app_theme.dart';
import 'src/presentation/features/app_shell/shell_view_model.dart';
import 'src/presentation/features/app_shell/widgets/shell_title_leading.dart';
import 'src/presentation/features/auth/auth_session_view_model.dart';
import 'src/presentation/features/auth/login_screen.dart';
import 'src/presentation/navigation/app_coordinator.dart';
import 'src/presentation/navigation/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureAppUrlStrategy();
  SemanticsBinding.instance.ensureSemantics();
  WaveformVisualizer.initialize();
  await dotenv.load(fileName: '.env');
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
  late final AuthSessionViewModel _authSession;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _coordinator = locator<AppCoordinator>();
    _authSession = locator<AuthSessionViewModel>();
    _coordinator.attachAuthPermission(
      canAccessVideoMultimodal: () => _authSession.canAccessVideoMultimodal,
    );
    _authSession.addListener(_didAuthSessionChange);
    _router = createAppRouter(onLocationChanged: _coordinator.didApplyRoute);
    _coordinator.attachNavigation(GoRouterAppNavigation(_router));
    // restore 후 권한 없는 계정 + multimodal URL이면 스택을 상세로 되돌린다.
    _authSession.restore().then((_) {
      if (!mounted) {
        return;
      }
      _coordinator.didDenyVideoMultimodalIfNeeded();
    });
  }

  @override
  void dispose() {
    _authSession.removeListener(_didAuthSessionChange);
    super.dispose();
  }

  void _didAuthSessionChange() {
    _coordinator.didAuthSessionChange();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppCoordinator>.value(value: _coordinator),
        ChangeNotifierProvider<AuthSessionViewModel>.value(value: _authSession),
        ChangeNotifierProvider<ShellViewModel>(
          create: (_) => locator<ShellViewModel>(),
        ),
      ],
      child: FluentApp.router(
        title: ShellTitleLeading.APP_TITLE,
        themeMode: ThemeMode.dark,
        darkTheme: AppTheme.dark,
        theme: AppTheme.light,
        routerConfig: _router,
        builder: (context, child) {
          return _AuthGate(child: child ?? const SizedBox.shrink());
        },
      ),
    );
  }
}

class _AuthGate extends StatelessWidget {
  const _AuthGate({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthSessionViewModel>();
    if (auth.isRestoring) {
      return const ColoredBox(
        color: Color(0xFF1F1F1F),
        child: Center(child: ProgressRing()),
      );
    }
    if (!auth.isSignedIn) {
      // FluentApp.router child(Navigator/Overlay)를 빼면 로그인 TextField가
      // "No Overlay widget found"로 깨진다. 로그인 전용 Overlay를 둔다.
      return const _LoginHost();
    }
    return child;
  }
}

class _LoginHost extends StatelessWidget {
  const _LoginHost();

  @override
  Widget build(BuildContext context) {
    return Overlay(
      initialEntries: [
        OverlayEntry(
          builder: (context) => const ColoredBox(
            color: Color(0xFF1F1F1F),
            child: LoginScreen(),
          ),
        ),
      ],
    );
  }
}
