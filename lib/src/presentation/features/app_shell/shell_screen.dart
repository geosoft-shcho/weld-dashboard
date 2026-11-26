import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../features/account_admin/accounts_admin_screen.dart';
import '../../features/account_admin/roles_admin_screen.dart';
import '../../features/account_admin/service_tokens_admin_screen.dart';
import '../../features/asset_lookup/asset_lookup_detail_screen.dart';
import '../../features/asset_lookup/asset_lookup_screen.dart';
import '../../features/auth/auth_session_view_model.dart';
import '../../features/collection_monitoring/collection_monitoring_screen.dart';
import '../../features/equipment_lookup/equipment_lookup_detail_screen.dart';
import '../../features/equipment_lookup/equipment_lookup_screen.dart';
import '../../features/job_lookup/job_lookup_detail_screen.dart';
import '../../features/pass_profile/pass_profile_screen.dart';
import '../../features/project_lookup/project_lookup_detail_screen.dart';
import '../../features/project_lookup/project_lookup_screen.dart';
import '../../features/quality_issue/quality_issue_screen.dart';
import '../../features/video_multimodal/video_multimodal_screen.dart';
import '../../features/work_history/work_history_screen.dart';
import '../../features/worker_lookup/worker_lookup_detail_screen.dart';
import '../../features/worker_lookup/worker_lookup_screen.dart';
import '../../core/themes/app_theme.dart';
import '../../core/widgets/lookup_search_field.dart';
import '../../navigation/app_coordinator.dart';
import 'shell_view_model.dart';
import 'widgets/shell_title_leading.dart';

class ShellScreen extends StatefulWidget {
  const ShellScreen({super.key});

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  /// Compact rail when false; open pane with labels when true.
  bool _isPaneOpen = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCatalogAndLatestPaneTargets();
    });
  }

  Future<void> _loadCatalogAndLatestPaneTargets() async {
    final viewModel = context.read<ShellViewModel>();
    final coordinator = context.read<AppCoordinator>();
    await viewModel.loadCatalog();
    if (!mounted) {
      return;
    }
    coordinator.didApplyLatestPaneCandidates(
      passProfile: viewModel.latestPassProfile,
      qualityIssue: viewModel.latestQualityIssue,
    );
  }

  void _didTapTogglePane() {
    setState(() {
      _isPaneOpen = !_isPaneOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    // lastDataUpdatedAt는 타이틀 전용 위젯만 구독한다. Shell 전체가
    // 주기적으로 rebuild되면 작업이력 TextBox 입력이 Web에서 끊긴다.
    final nav = context.select<AppCoordinator, _ShellNavSnapshot>(
      _ShellNavSnapshot.from,
    );
    final canManageAccounts = context.select<AuthSessionViewModel, bool>(
      (auth) => auth.hasAccountManage,
    );
    final coordinator = context.read<AppCoordinator>();

    return Stack(
      children: [
        NavigationView(
          titleBar: TitleBar(
            isBackButtonVisible: false,
            height: 48,
            leftHeader: ShellTitleLeading(onTogglePane: _didTapTogglePane),
            endHeader: const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _AuthSessionActions(),
                  SizedBox(width: 12),
                  _LastDataUpdatedLabel(),
                ],
              ),
            ),
          ),
          pane: NavigationPane(
            selected: nav.selectedPaneIndex,
            onChanged: coordinator.didSelectPane,
            displayMode: _isPaneOpen
                ? PaneDisplayMode.expanded
                : PaneDisplayMode.compact,
            // Single toggle lives in the title bar leading row.
            toggleButton: null,
            size: const NavigationPaneSize(openWidth: 240),
            items: [
              _buildPaneGroupLabel('모니터링', showsDivider: false),
              _navPaneItem(
                iconData: FluentIcons.server_processes,
                label: '수집 모니터링',
                body: const CollectionMonitoringScreen(),
              ),
              _navPaneItem(
                iconData: FluentIcons.line_chart,
                label: '최신 패스 프로파일',
                enabled: nav.canOpenLatestPassProfile,
                body: _panePassProfileBody(nav),
              ),
              _navPaneItem(
                iconData: FluentIcons.report_document,
                label: '최신 품질 이슈',
                enabled: nav.canOpenLatestQualityIssue,
                body: _paneQualityIssueBody(nav),
              ),
              _buildPaneGroupLabel('관리'),
              _navPaneItem(
                iconData: FluentIcons.city_next,
                label: '공사 관리',
                body: _projectLookupBody(nav),
              ),
              _navPaneItem(
                iconData: FluentIcons.contact,
                label: '작업자 관리',
                body: _workerLookupBody(nav),
              ),
              _navPaneItem(
                iconData: FluentIcons.history,
                label: '작업 관리',
                body: _workHistoryBody(nav),
              ),
              _navPaneItem(
                iconData: FluentIcons.camera,
                label: '장비 관리',
                body: _equipmentLookupBody(nav),
              ),
              _navPaneItem(
                iconData: FluentIcons.folder_open,
                label: '파일 관리',
                body: _assetLookupBody(nav),
              ),
              if (canManageAccounts) ...[
                _buildPaneGroupLabel('계정'),
                _navPaneItem(
                  iconData: FluentIcons.contact_info,
                  label: '계정 관리',
                  body: const AccountsAdminScreen(),
                ),
                _navPaneItem(
                  iconData: FluentIcons.permissions,
                  label: '권한 관리',
                  body: const RolesAdminScreen(),
                ),
                _navPaneItem(
                  iconData: FluentIcons.protected_document,
                  label: '서버 연동 토큰',
                  body: const ServiceTokensAdminScreen(),
                ),
              ],
              _buildPaneGroupLabel('설정'),
              _navPaneAction(
                iconData: FluentIcons.contact,
                label: '내정보',
                onTap: () => _didTapMyAccountInfo(context),
              ),
              _navPaneAction(
                iconData: FluentIcons.password_field,
                label: '비밀번호 변경',
                onTap: () => _didTapChangePassword(context),
              ),
              _navPaneAction(
                iconData: FluentIcons.sign_out,
                label: '로그아웃',
                onTap: () => _didTapSignOut(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _didTapMyAccountInfo(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (_) => const _MyAccountInfoDialog(),
    );
  }

  Future<void> _didTapChangePassword(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (_) => const _ChangePasswordDialog(),
    );
  }

  Future<void> _didTapSignOut(BuildContext context) async {
    final auth = context.read<AuthSessionViewModel>();
    if (auth.isBusy) {
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => ContentDialog(
        title: const Text('로그아웃'),
        content: const Text('로그아웃할까요?'),
        actions: [
          Button(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('로그아웃'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) {
      return;
    }
    final session = context.read<AuthSessionViewModel>();
    if (session.isBusy) {
      return;
    }
    await session.signOut();
  }

  /// 펼친 창에는 묶음 이름을 보이고, 아이콘만 보이는 창에는 구분선을 둔다.
  /// 헤더·구분선은 선택 번호에 들어가지 않는다.
  NavigationPaneItem _buildPaneGroupLabel(
    String label, {
    bool showsDivider = true,
  }) {
    return PaneItemWidgetAdapter(
      applyPadding: false,
      child: _PaneGroupLabel(label: label, showsDivider: showsDivider),
    );
  }

  /// compact에서 아이콘 오른쪽 툴팁(오프셋 12). 내장 위쪽 툴팁은 title을 Builder로 막아 끈다.
  PaneItem _navPaneItem({
    required IconData iconData,
    required String label,
    required Widget body,
    bool enabled = true,
  }) {
    return PaneItem(
      icon: Tooltip(
        message: label,
        displayHorizontally: true,
        useMousePosition: false,
        style: const TooltipThemeData(verticalOffset: 12, preferBelow: false),
        child: Icon(iconData),
      ),
      title: Builder(builder: (_) => Text(label)),
      enabled: enabled,
      body: body,
    );
  }

  /// 선택 인덱스에 들어가지 않는 액션(설정·로그아웃 등).
  PaneItemAction _navPaneAction({
    required IconData iconData,
    required String label,
    required VoidCallback onTap,
  }) {
    return PaneItemAction(
      icon: Tooltip(
        message: label,
        displayHorizontally: true,
        useMousePosition: false,
        style: const TooltipThemeData(verticalOffset: 12, preferBelow: false),
        child: Icon(iconData),
      ),
      title: Builder(builder: (_) => Text(label)),
      onTap: onTap,
    );
  }

  Widget _projectLookupBody(_ShellNavSnapshot nav) {
    if (nav.lookupDetailId.isEmpty) {
      return const ProjectLookupScreen();
    }
    return ProjectLookupDetailScreen(
      key: ValueKey('project-detail|${nav.lookupDetailId}'),
      projectId: nav.lookupDetailId,
    );
  }

  Widget _workerLookupBody(_ShellNavSnapshot nav) {
    if (nav.lookupDetailId.isEmpty) {
      return const WorkerLookupScreen();
    }
    return WorkerLookupDetailScreen(
      key: ValueKey('worker-detail|${nav.lookupDetailId}'),
      workerId: nav.lookupDetailId,
    );
  }

  Widget _equipmentLookupBody(_ShellNavSnapshot nav) {
    if (nav.lookupDetailId.isEmpty) {
      return const EquipmentLookupScreen();
    }
    return EquipmentLookupDetailScreen(
      key: ValueKey('equipment-detail|${nav.lookupDetailId}'),
      equipmentId: nav.lookupDetailId,
    );
  }

  Widget _assetLookupBody(_ShellNavSnapshot nav) {
    if (nav.lookupDetailId.isEmpty) {
      return const AssetLookupScreen();
    }
    return AssetLookupDetailScreen(
      key: ValueKey('asset-detail|${nav.lookupDetailId}'),
      assetId: nav.lookupDetailId,
    );
  }

  Widget _panePassProfileBody(_ShellNavSnapshot nav) {
    if (!nav.canOpenLatestPassProfile || nav.panePassCommonKey.isEmpty) {
      return const SizedBox.shrink();
    }
    return PassProfileScreen(
      key: ValueKey(
        'pane-pass|${nav.panePassCommonKey}|${nav.panePassJobId}|${nav.panePassPassId}',
      ),
      commonKey: nav.panePassCommonKey,
      jobId: nav.panePassJobId,
      passId: nav.panePassPassId,
    );
  }

  Widget _paneQualityIssueBody(_ShellNavSnapshot nav) {
    if (nav.paneQualityCommonKey.isEmpty) {
      return const SizedBox.shrink();
    }
    return QualityIssueScreen(
      key: ValueKey(
        'pane-quality|${nav.paneQualityCommonKey}|${nav.paneQualityJobId}|${nav.paneQualityPassId}|${nav.paneQualityLinkId}',
      ),
      commonKey: nav.paneQualityCommonKey,
      jobId: nav.paneQualityJobId,
      passId: nav.paneQualityPassId,
      linkId: nav.paneQualityLinkId,
    );
  }

  Widget _workHistoryBody(_ShellNavSnapshot nav) {
    switch (nav.workHistoryStack) {
      case WorkHistoryStack.list:
        return const WorkHistoryScreen();
      case WorkHistoryStack.detail:
        return JobLookupDetailScreen(
          key: ValueKey('detail|${nav.jobId}'),
          jobId: nav.jobId,
        );
      case WorkHistoryStack.videoMultimodal:
        return VideoMultimodalScreen(
          key: ValueKey('multimodal|${nav.jobId}'),
          jobId: nav.jobId,
        );
      case WorkHistoryStack.passProfile:
        return PassProfileScreen(
          key: ValueKey(
            'pass|${nav.historyCommonKey}|${nav.jobId}|${nav.passId}',
          ),
          commonKey: nav.historyCommonKey,
          jobId: nav.jobId,
          passId: nav.passId,
        );
      case WorkHistoryStack.qualityIssue:
        return QualityIssueScreen(
          key: ValueKey(
            'quality|${nav.historyCommonKey}|${nav.jobId}|${nav.passId}|${nav.linkId}',
          ),
          commonKey: nav.historyCommonKey,
          jobId: nav.jobId,
          passId: nav.passId,
          linkId: nav.linkId,
        );
    }
  }
}

class _ShellNavSnapshot {
  const _ShellNavSnapshot({
    required this.selectedPaneIndex,
    required this.workHistoryStack,
    required this.historyCommonKey,
    required this.jobId,
    required this.passId,
    required this.linkId,
    required this.lookupDetailId,
    required this.canOpenLatestPassProfile,
    required this.canOpenLatestQualityIssue,
    required this.panePassCommonKey,
    required this.panePassJobId,
    required this.panePassPassId,
    required this.paneQualityCommonKey,
    required this.paneQualityJobId,
    required this.paneQualityPassId,
    required this.paneQualityLinkId,
  });

  factory _ShellNavSnapshot.from(AppCoordinator coordinator) {
    return _ShellNavSnapshot(
      selectedPaneIndex: coordinator.selectedPaneIndex,
      workHistoryStack: coordinator.workHistoryStack,
      historyCommonKey: coordinator.historyCommonKey,
      jobId: coordinator.jobId,
      passId: coordinator.passId,
      linkId: coordinator.linkId,
      lookupDetailId: coordinator.lookupDetailId,
      canOpenLatestPassProfile: coordinator.canOpenLatestPassProfile,
      canOpenLatestQualityIssue: coordinator.canOpenLatestQualityIssue,
      panePassCommonKey: coordinator.panePassCommonKey,
      panePassJobId: coordinator.panePassJobId,
      panePassPassId: coordinator.panePassPassId,
      paneQualityCommonKey: coordinator.paneQualityCommonKey,
      paneQualityJobId: coordinator.paneQualityJobId,
      paneQualityPassId: coordinator.paneQualityPassId,
      paneQualityLinkId: coordinator.paneQualityLinkId,
    );
  }

  final int selectedPaneIndex;
  final WorkHistoryStack workHistoryStack;
  final String historyCommonKey;
  final String jobId;
  final String passId;
  final String linkId;
  final String lookupDetailId;
  final bool canOpenLatestPassProfile;
  final bool canOpenLatestQualityIssue;
  final String panePassCommonKey;
  final String panePassJobId;
  final String panePassPassId;
  final String paneQualityCommonKey;
  final String paneQualityJobId;
  final String paneQualityPassId;
  final String paneQualityLinkId;

  @override
  bool operator ==(Object other) {
    return other is _ShellNavSnapshot &&
        selectedPaneIndex == other.selectedPaneIndex &&
        workHistoryStack == other.workHistoryStack &&
        historyCommonKey == other.historyCommonKey &&
        jobId == other.jobId &&
        passId == other.passId &&
        linkId == other.linkId &&
        lookupDetailId == other.lookupDetailId &&
        canOpenLatestPassProfile == other.canOpenLatestPassProfile &&
        canOpenLatestQualityIssue == other.canOpenLatestQualityIssue &&
        panePassCommonKey == other.panePassCommonKey &&
        panePassJobId == other.panePassJobId &&
        panePassPassId == other.panePassPassId &&
        paneQualityCommonKey == other.paneQualityCommonKey &&
        paneQualityJobId == other.paneQualityJobId &&
        paneQualityPassId == other.paneQualityPassId &&
        paneQualityLinkId == other.paneQualityLinkId;
  }

  @override
  int get hashCode => Object.hash(
    selectedPaneIndex,
    workHistoryStack,
    historyCommonKey,
    jobId,
    passId,
    linkId,
    lookupDetailId,
    canOpenLatestPassProfile,
    canOpenLatestQualityIssue,
    panePassCommonKey,
    panePassJobId,
    panePassPassId,
    paneQualityCommonKey,
    paneQualityJobId,
    paneQualityPassId,
    paneQualityLinkId,
  );
}

class _PaneGroupLabel extends StatelessWidget {
  const _PaneGroupLabel({required this.label, required this.showsDivider});

  final String label;
  final bool showsDivider;

  @override
  Widget build(BuildContext context) {
    final isIconOnly =
        NavigationView.of(context).displayMode == PaneDisplayMode.compact;
    if (isIconOnly) {
      if (!showsDivider) {
        return const SizedBox.shrink();
      }
      final stroke = FluentTheme.of(context).resources.cardStrokeColorDefault;
      return Tooltip(
        message: label,
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: 10,
            vertical: 6,
          ),
          child: Container(height: 1, color: stroke),
        ),
      );
    }

    final theme = FluentTheme.of(context);
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20, showsDivider ? 16 : 8, 12, 2),
      child: Text(
        label,
        style: theme.typography.caption?.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.resources.textFillColorSecondary,
        ),
      ),
    );
  }
}

class _AuthSessionActions extends StatelessWidget {
  const _AuthSessionActions();

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthSessionViewModel>().user;
    final loginName = user?.loginName.trim() ?? '';
    if (loginName.isEmpty) {
      return const SizedBox.shrink();
    }
    return Text(
      loginName,
      style: const TextStyle(fontSize: 12, color: AppTheme.ACCENT_STEEL),
    );
  }
}

class _MyAccountInfoDialog extends StatelessWidget {
  const _MyAccountInfoDialog();

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    final user = context.watch<AuthSessionViewModel>().user;

    final loginName = user?.loginName.trim() ?? '';
    final displayName = user?.displayName.trim() ?? '';
    final roleName = user?.roleName.trim() ?? '';
    final roleId = user?.roleId ?? 0;
    final permissions = user?.permissions ?? const <String>[];

    return ContentDialog(
      title: const Text('내정보'),
      constraints: const BoxConstraints(maxWidth: 440),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(FluentIcons.contact, size: 28, color: AppTheme.WHITE),
              const SizedBox(width: 12),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loginName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (displayName.isNotEmpty) ...[
                      Text(
                        displayName,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.ACCENT_STEEL,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _MyAccountInfoRow(
            label: '권한',
            value: roleName.isEmpty ? '없음' : roleName,
          ),
          const SizedBox(height: 12),
          Text('권한', style: TextStyle(fontSize: 12, color: AppTheme.WHITE)),
          const SizedBox(height: 6),
          if (permissions.isEmpty)
            const Text('없음')
          else
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final permission in permissions)
                  _MyAccountPermissionBadge(label: permission),
              ],
            ),
        ],
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('확인'),
        ),
      ],
    );
  }
}

/// 권한 관리 `_PermissionKeyBadge`와 같은 뱃지.
class _MyAccountPermissionBadge extends StatelessWidget {
  const _MyAccountPermissionBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.ACCENT_STEEL.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: const Color(0xFF3E424A)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppTheme.ACCENT_STEEL,
          ),
        ),
      ),
    );
  }
}

class _MyAccountInfoRow extends StatelessWidget {
  const _MyAccountInfoRow({
    required this.label,
    required this.value,
    this.trailing,
  });

  final String label;
  final String value;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final secondary = FluentTheme.of(context).resources.textFillColorSecondary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: secondary)),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Expanded(child: SelectableText(value)),
            if (trailing != null) ...[const SizedBox(width: 8), trailing!],
          ],
        ),
      ],
    );
  }
}

class _ChangePasswordDialog extends StatefulWidget {
  const _ChangePasswordDialog();

  @override
  State<_ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<_ChangePasswordDialog> {
  final TextEditingController _current = TextEditingController();
  final TextEditingController _next = TextEditingController();
  final TextEditingController _confirm = TextEditingController();
  String _error = '';
  bool _isSaving = false;
  bool _didSucceed = false;
  bool _isCurrentVisible = false;
  bool _isNextVisible = false;
  bool _isConfirmVisible = false;

  Widget _passwordField({
    required TextEditingController controller,
    required String hintText,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
  }) {
    return LookupSearchField(
      controller: controller,
      value: controller.text,
      hintText: hintText,
      obscureText: !isVisible,
      textInputAction: TextInputAction.next,
      onChanged: (_) {},
      suffixIcon: Tooltip(
        message: isVisible ? '비밀번호 가리기' : '비밀번호 보기',
        child: IconButton(
          icon: Icon(
            isVisible ? FluentIcons.hide : FluentIcons.red_eye,
            size: 14,
          ),
          onPressed: onToggleVisibility,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _current.dispose();
    _next.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _didTapSave() async {
    setState(() {
      _error = '';
      _isSaving = true;
    });
    final message = await context.read<AuthSessionViewModel>().changePassword(
      currentPassword: _current.text,
      newPassword: _next.text,
      confirmPassword: _confirm.text,
    );
    if (!mounted) {
      return;
    }
    if (message != null) {
      setState(() {
        _error = message;
        _isSaving = false;
      });
      return;
    }
    setState(() {
      _isSaving = false;
      _didSucceed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_didSucceed) {
      return ContentDialog(
        title: const Text('비밀번호 변경'),
        content: const Text(
          '비밀번호를 바꿨습니다. 이 계정의 다른 세션은 끊깁니다. '
          '확인하면 다시 로그인합니다.',
        ),
        actions: [
          FilledButton(
            onPressed: () async {
              final auth = context.read<AuthSessionViewModel>();
              Navigator.of(context).pop();
              await auth.signOut();
            },
            child: const Text('확인'),
          ),
        ],
      );
    }
    return ContentDialog(
      title: const Text('비밀번호 변경'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InfoLabel(
            label: '현재 비밀번호',
            child: _passwordField(
              controller: _current,
              hintText: '현재 비밀번호',
              isVisible: _isCurrentVisible,
              onToggleVisibility: () {
                setState(() => _isCurrentVisible = !_isCurrentVisible);
              },
            ),
          ),
          const SizedBox(height: 12),
          InfoLabel(
            label: '새 비밀번호 (8~72바이트)',
            child: _passwordField(
              controller: _next,
              hintText: '새 비밀번호',
              isVisible: _isNextVisible,
              onToggleVisibility: () {
                setState(() => _isNextVisible = !_isNextVisible);
              },
            ),
          ),
          const SizedBox(height: 12),
          InfoLabel(
            label: '새 비밀번호 확인',
            child: _passwordField(
              controller: _confirm,
              hintText: '새 비밀번호 확인',
              isVisible: _isConfirmVisible,
              onToggleVisibility: () {
                setState(() => _isConfirmVisible = !_isConfirmVisible);
              },
            ),
          ),
          if (_error.isNotEmpty) ...[
            const SizedBox(height: 12),
            InfoBar(
              title: const Text('변경 실패'),
              content: Text(_error),
              severity: InfoBarSeverity.error,
            ),
          ],
        ],
      ),
      actions: [
        Button(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _didTapSave,
          child: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: ProgressRing(strokeWidth: 2),
                )
              : const Text('변경'),
        ),
      ],
    );
  }
}

class _LastDataUpdatedLabel extends StatelessWidget {
  const _LastDataUpdatedLabel();

  @override
  Widget build(BuildContext context) {
    final updatedAt = context.select<AppCoordinator, DateTime>(
      (coordinator) => coordinator.lastDataUpdatedAt,
    );
    return Text(
      '최신 업데이트 ${DateFormat('yyyy-MM-dd HH:mm:ss').format(updatedAt)}',
      style: const TextStyle(fontSize: 12),
    );
  }
}
