import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/asset_lookup_kind.dart';
import '../../../domain/entities/equipment.dart';
import '../../core/di/locator.dart';
import '../../core/formatters/dashboard_formatters.dart';
import '../../core/themes/app_theme.dart';
import '../../core/widgets/lookup_detail_scaffold.dart';
import '../../core/widgets/lookup_search_field.dart';
import '../../core/widgets/pass_context_bar.dart';
import '../../core/widgets/query_failure_pane.dart';
import '../../navigation/app_coordinator.dart';
import 'equipment_lookup_detail_view_model.dart';

class EquipmentLookupDetailScreen extends StatelessWidget {
  const EquipmentLookupDetailScreen({super.key, required this.equipmentId});

  final String equipmentId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          locator<EquipmentLookupDetailViewModel>(param1: equipmentId)..load(),
      child: const _EquipmentLookupDetailBody(),
    );
  }
}

enum _EquipmentDetailTab { jobs, assets }

class _EquipmentLookupDetailBody extends StatefulWidget {
  const _EquipmentLookupDetailBody();

  @override
  State<_EquipmentLookupDetailBody> createState() =>
      _EquipmentLookupDetailBodyState();
}

class _EquipmentLookupDetailBodyState
    extends State<_EquipmentLookupDetailBody> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _code = TextEditingController();
  final TextEditingController _description = TextEditingController();

  _EquipmentDetailTab _selectedTab = _EquipmentDetailTab.jobs;
  bool _isInactive = false;
  bool _isCodeOpen = false;
  bool _isEditing = false;
  bool _isBusy = false;
  String _editError = '';

  @override
  void dispose() {
    _name.dispose();
    _code.dispose();
    _description.dispose();
    super.dispose();
  }

  void _startEdit(Equipment equipment) {
    _name.text = equipment.equipmentName;
    _code.text = equipment.equipmentCode;
    _description.text = equipment.description;
    setState(() {
      _isInactive = equipment.isInactive;
      _isCodeOpen = false;
      _isEditing = true;
      _editError = '';
    });
  }

  Future<void> _didTapSave(EquipmentLookupDetailViewModel viewModel) async {
    final equipmentName = _name.text.trim();
    if (equipmentName.isEmpty) {
      setState(() => _editError = '이름을 넣으세요.');
      return;
    }
    final equipmentCode = _isCodeOpen
        ? normalizedEquipmentCode(_code.text)
        : viewModel.equipment?.equipmentCode ?? '';
    setState(() {
      _isBusy = true;
      _editError = '';
    });
    try {
      await viewModel.updateEquipment(
        equipmentName: equipmentName,
        equipmentCode: equipmentCode,
        description: _description.text.trim(),
        isInactive: _isInactive,
      );
      if (mounted) {
        setState(() => _isEditing = false);
      }
    } catch (error) {
      if (mounted) {
        setState(() => _editError = '$error');
      }
    } finally {
      if (mounted) {
        setState(() => _isBusy = false);
      }
    }
  }

  Future<void> _didTapDelete(
    BuildContext context,
    Equipment equipment,
    EquipmentLookupDetailViewModel viewModel,
    AppCoordinator coordinator,
  ) async {
    if (equipment.assetCount > 0) {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => ContentDialog(
          title: const Text('장비를 지울 수 없습니다'),
          content: Text(
            '기록한 에셋 ${equipment.assetCount}건이 있어 지울 수 없습니다. 안 쓰는 장비는 숨기세요.',
          ),
          actions: [
            Button(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('확인'),
            ),
          ],
        ),
      );
      return;
    }
    var error = '';
    var busy = false;
    final deleted = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return ContentDialog(
              title: const Text('장비 지우기'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('${equipment.equipmentName}을 지웁니다. 되돌릴 수 없습니다.'),
                  if (error.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(error, style: TextStyle(color: Colors.red)),
                  ],
                ],
              ),
              actions: [
                Button(
                  onPressed: busy
                      ? null
                      : () => Navigator.of(dialogContext).pop(false),
                  child: const Text('취소'),
                ),
                FilledButton(
                  onPressed: busy
                      ? null
                      : () async {
                          setDialogState(() {
                            busy = true;
                            error = '';
                          });
                          try {
                            await viewModel.deleteEquipment();
                            if (dialogContext.mounted) {
                              Navigator.of(dialogContext).pop(true);
                            }
                          } catch (e) {
                            setDialogState(() {
                              busy = false;
                              error = '$e';
                            });
                          }
                        },
                  child: const Text('지우기'),
                ),
              ],
            );
          },
        );
      },
    );
    if (deleted == true && context.mounted) {
      coordinator.didTapBackFromLookupDetail();
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<EquipmentLookupDetailViewModel>();
    final coordinator = context.read<AppCoordinator>();
    final equipment = viewModel.equipment;
    return LookupDetailScaffold(
      title: equipment?.equipmentName.isNotEmpty == true
          ? equipment!.equipmentName
          : '장비 상세',
      subtitle: equipment == null ? '' : 'id ${equipment.equipmentId}',
      onBack: coordinator.didTapBackFromLookupDetail,
      actions: [
        if (equipment != null && !_isEditing) ...[
          Button(
            onPressed: _isBusy ? null : () => _startEdit(equipment),
            child: const Text('고치기'),
          ),
          const SizedBox(width: 8),
          Button(
            onPressed: _isBusy
                ? null
                : () =>
                      _didTapDelete(context, equipment, viewModel, coordinator),
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all(
                const Color(0xFFE85D5D),
              ),
            ),
            child: const Text('지우기'),
          ),
        ],
      ],
      body: _body(context, viewModel, coordinator),
    );
  }

  Widget _body(
    BuildContext context,
    EquipmentLookupDetailViewModel viewModel,
    AppCoordinator coordinator,
  ) {
    if (viewModel.isLoading && viewModel.equipment == null) {
      return const Center(child: ProgressRing());
    }
    if (viewModel.hasError) {
      return QueryFailurePane(
        title: '조회 실패',
        message: viewModel.errorMessage,
        onRetry: viewModel.load,
      );
    }
    final equipment = viewModel.equipment;
    if (equipment == null) {
      return const InfoBar(
        title: Text('장비 없음'),
        severity: InfoBarSeverity.warning,
      );
    }
    if (_isEditing) {
      return _editForm(viewModel);
    }
    return ListView(
      children: [
        PassContextBar.entries(
          entries: [
            ('장비 코드', equipment.equipmentCode),
            ('쓰인 작업', '${equipment.jobCount}건'),
            ('기록한 에셋', '${equipment.assetCount}건'),
            ('숨김', equipment.isInactive ? '숨김 — 고르는 목록에서 빠짐' : '아니오'),
          ],
        ),
        if (equipment.description.isNotEmpty) ...[
          const LookupDetailSectionTitle('비고'),
          Text(equipment.description),
        ],
        const SizedBox(height: 12),
        _EquipmentDetailTabsBar(
          selectedTab: _selectedTab,
          jobCount: equipment.jobCount,
          assetCount: equipment.assetCount,
          onSelectTab: (tab) => setState(() => _selectedTab = tab),
        ),
        const SizedBox(height: 12),
        if (_selectedTab == _EquipmentDetailTab.jobs)
          LookupDetailPlainTable(
            headers: const ['공통키', '이음부', '작업일시'],
            emptyText: '예시 데이터에 없음',
            rows: [
              for (final job in viewModel.jobs)
                [
                  job.commonKey,
                  job.jointNo,
                  DashboardFormatters.dateTime(job.workedAt),
                ],
            ],
            onRowTap: (index) {
              coordinator.didTapOpenWorkDetail(
                context,
                jobId: viewModel.jobs[index].jobId,
              );
            },
          )
        else
          LookupDetailPlainTable(
            headers: const ['번호', '종류', '파일'],
            emptyText: '기록한 에셋이 없습니다',
            rows: [
              for (final asset in viewModel.assets)
                [
                  asset.assetId,
                  AssetLookupKindOption.labelOf(asset.kindCode),
                  asset.fileName,
                ],
            ],
            onRowTap: (index) {
              coordinator.didTapOpenAssetDetail(
                viewModel.assets[index].assetId,
              );
            },
          ),
      ],
    );
  }

  Widget _editForm(EquipmentLookupDetailViewModel viewModel) {
    return ListView(
      children: [
        InfoLabel(
          label: '이름 *',
          child: LookupSearchField(
            controller: _name,
            value: _name.text,
            hintText: '',
            enabled: !_isBusy,
            textInputAction: TextInputAction.next,
            onChanged: (_) {},
          ),
        ),
        const SizedBox(height: 12),
        InfoLabel(
          label: '장비 코드',
          child: LookupSearchField(
            controller: _code,
            value: _code.text,
            hintText: 'DEMO-PANEL',
            enabled: !_isBusy,
            readOnly: !_isCodeOpen,
            textInputAction: TextInputAction.next,
            onChanged: (_) => setState(() {}),
          ),
        ),
        if (!_isCodeOpen)
          Align(
            alignment: Alignment.centerLeft,
            child: Button(
              onPressed: _isBusy
                  ? null
                  : () => setState(() => _isCodeOpen = true),
              child: const Text('코드 바꾸기'),
            ),
          ),
        const SizedBox(height: 4),
        const Text(
          '코드는 적재기가 장비를 찾는 값입니다. 비우면 손으로만 고를 수 있습니다. 공백 없이 대문자로 보냅니다.',
          style: TextStyle(fontSize: 12),
        ),
        if (_isCodeOpen) ...[
          const SizedBox(height: 8),
          const Text(
            '코드를 바꾸면 적재 설정의 코드도 함께 바꿔야 합니다. 안 바꾸면 다음 적재 때 옛 코드로 장비가 새로 생깁니다.',
            style: TextStyle(fontSize: 12, color: Color(0xFFE0A040)),
          ),
        ],
        const SizedBox(height: 12),
        Checkbox(
          checked: _isInactive,
          content: const Text('숨김 — 고르는 목록에서 뺌(안 쓰는 장비)'),
          onChanged: _isBusy
              ? null
              : (value) {
                  if (value != null) {
                    setState(() => _isInactive = value);
                  }
                },
        ),
        const SizedBox(height: 12),
        InfoLabel(
          label: '비고',
          child: LookupSearchField(
            controller: _description,
            value: _description.text,
            hintText: '설치 위치 · 설정 등',
            enabled: !_isBusy,
            maxLines: 2,
            textInputAction: TextInputAction.newline,
            onChanged: (_) {},
          ),
        ),
        if (_editError.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(_editError, style: TextStyle(color: Colors.red)),
        ],
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Button(
              onPressed: _isBusy
                  ? null
                  : () => setState(() => _isEditing = false),
              child: const Text('취소'),
            ),
            const SizedBox(width: 8),
            FilledButton(
              onPressed: _isBusy ? null : () => _didTapSave(viewModel),
              child: const Text('저장'),
            ),
          ],
        ),
      ],
    );
  }
}

class _EquipmentDetailTabsBar extends StatelessWidget {
  const _EquipmentDetailTabsBar({
    required this.selectedTab,
    required this.jobCount,
    required this.assetCount,
    required this.onSelectTab,
  });

  final _EquipmentDetailTab selectedTab;
  final int jobCount;
  final int assetCount;
  final ValueChanged<_EquipmentDetailTab> onSelectTab;

  static final Color _LINE = AppTheme.STATUS_OFF.withValues(alpha: 0.45);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: _LINE, width: 1)),
        ),
        child: Wrap(
          spacing: 16,
          runSpacing: 0,
          crossAxisAlignment: WrapCrossAlignment.end,
          children: [
            _tab(_EquipmentDetailTab.jobs, '쓰인 작업 $jobCount'),
            _tab(_EquipmentDetailTab.assets, '기록한 에셋 $assetCount'),
          ],
        ),
      ),
    );
  }

  Widget _tab(_EquipmentDetailTab tab, String label) {
    return Transform.translate(
      offset: const Offset(0, 1),
      child: _EquipmentDetailTabItem(
        label: label,
        isSelected: tab == selectedTab,
        onPressed: () => onSelectTab(tab),
      ),
    );
  }
}

class _EquipmentDetailTabItem extends StatelessWidget {
  const _EquipmentDetailTabItem({
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return HoverButton(
      onPressed: onPressed,
      builder: (context, states) {
        final isHovered = states.isHovered;
        final color = isSelected || isHovered
            ? AppTheme.INK
            : AppTheme.STATUS_OFF;
        return DecoratedBox(
          decoration: BoxDecoration(
            border: isSelected
                ? const Border(
                    bottom: BorderSide(color: AppTheme.INK, width: 2),
                  )
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 6),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        );
      },
    );
  }
}
