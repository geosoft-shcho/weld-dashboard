import 'package:fluent_ui/fluent_ui.dart';

import '../../../../domain/entities/work_history_item.dart';
import '../../../core/formatters/dashboard_formatters.dart';

class WorkDetailIdentity extends StatelessWidget {
  const WorkDetailIdentity({super.key, required this.job});

  final WorkHistoryItem job;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2D32),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFF3E424A)),
      ),
      child: Wrap(
        spacing: 24,
        runSpacing: 12,
        children: [
          _pair('공통키', job.commonKey),
          _pair('작업지시', '${job.workOrderNo} · ${job.title}'),
          _pair('조인트', '${job.jointNo} ${job.jointName}'),
          _pair('작업자', job.workerName),
          _pair('장비', job.equipmentName),
          _pair(
            '작업일시 / 패스',
            '${DashboardFormatters.dateTime(job.workedAt)} · ${job.passCount}패스',
          ),
        ],
      ),
    );
  }

  Widget _pair(String label, String value) {
    return SizedBox(
      width: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Color(0xFF8E949E)),
          ),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}
