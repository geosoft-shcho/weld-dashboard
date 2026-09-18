import 'package:fluent_ui/fluent_ui.dart';

import '../../../core/themes/app_theme.dart';
import '../../../core/widgets/section_empty_placeholder.dart';

class PassLegendToolbar extends StatelessWidget {
  const PassLegendToolbar({
    super.key,
    required this.showMaster,
    required this.showBeginner,
    required this.showRobot,
    required this.mastersForPass,
    required this.selectedMasterProfileId,
    required this.onToggleMaster,
    required this.onToggleBeginner,
    required this.onToggleRobot,
    required this.onSelectMasterProfile,
    this.isEmpty = false,
  });

  final bool showMaster;
  final bool showBeginner;
  final bool showRobot;
  final List<String> mastersForPass;
  final String selectedMasterProfileId;
  final ValueChanged<bool> onToggleMaster;
  final ValueChanged<bool> onToggleBeginner;
  final ValueChanged<bool> onToggleRobot;
  final ValueChanged<String> onSelectMasterProfile;

  /// True when there is no pass or no series to legend-toggle (s3 · s4 shared).
  final bool isEmpty;

  @override
  Widget build(BuildContext context) {
    if (isEmpty) {
      return const SectionEmptyPlaceholder(
        title: '범례를 표시할 데이터가 없습니다',
        message: '패스 또는 파형 시리즈가 없어 명장·초보자·로봇 범례를 켤 수 없습니다.',
      );
    }
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Text('범례', style: TextStyle(fontWeight: FontWeight.w600)),
        _legendToggle(
          label: '명장',
          color: AppTheme.CHART_MASTER,
          isOn: showMaster,
          onChanged: onToggleMaster,
        ),
        _legendToggle(
          label: '초보자',
          color: AppTheme.CHART_BEGINNER,
          isOn: showBeginner,
          onChanged: onToggleBeginner,
        ),
        _legendToggle(
          label: '로봇',
          color: AppTheme.CHART_ROBOT,
          isOn: showRobot,
          onChanged: onToggleRobot,
        ),
        if (mastersForPass.length > 1)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('명장 프로파일'),
              const SizedBox(width: 8),
              SizedBox(
                width: 160,
                child: ComboBox<String>(
                  value: selectedMasterProfileId.isEmpty
                      ? null
                      : selectedMasterProfileId,
                  items: [
                    for (final id in mastersForPass)
                      ComboBoxItem(value: id, child: Text(id)),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      onSelectMasterProfile(value);
                    }
                  },
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _legendToggle({
    required String label,
    required Color color,
    required bool isOn,
    required ValueChanged<bool> onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!isOn),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: isOn ? color : AppTheme.STATUS_OFF,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 6),
          Text(label),
          const SizedBox(width: 4),
          Checkbox(
            checked: isOn,
            onChanged: (value) => onChanged(value ?? false),
          ),
        ],
      ),
    );
  }
}
