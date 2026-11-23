import 'package:fluent_ui/fluent_ui.dart';

import '../../../../domain/entities/collection_summary.dart';
import '../../../core/formatters/dashboard_formatters.dart';
import '../../../core/themes/app_theme.dart';
import '../collection_monitoring_view_model.dart';

class CollectionAssetCountsPanel extends StatelessWidget {
  const CollectionAssetCountsPanel({super.key, required this.viewModel});

  final CollectionMonitoringViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final rows = viewModel.assetCounts;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.SURFACE_RAISED,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF3E424A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Text(
                '날짜별 파일 수 · 용량',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              SizedBox(
                width: 140,
                child: ComboBox<AssetCountTimeBasis>(
                  isExpanded: true,
                  value: viewModel.assetCountBasis,
                  items: const [
                    ComboBoxItem(
                      value: AssetCountTimeBasis.collected,
                      child: Text('수집 시각'),
                    ),
                    ComboBoxItem(
                      value: AssetCountTimeBasis.recorded,
                      child: Text('기록 시각'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      viewModel.didSelectAssetCountBasis(value);
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (rows.isEmpty)
            const Text('날짜별 집계가 없습니다.', style: TextStyle(fontSize: 12))
          else
            SizedBox(
              height: 160,
              child: ListView.separated(
                itemCount: rows.length,
                separatorBuilder: (_, _) => const SizedBox(height: 4),
                itemBuilder: (context, index) {
                  final row = rows[index];
                  return Row(
                    children: [
                      SizedBox(
                        width: 96,
                        child: Text(row.date, style: const TextStyle(fontSize: 12)),
                      ),
                      SizedBox(
                        width: 64,
                        child: Text(
                          _kindLabel(row.kind),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '${DashboardFormatters.count(row.assetCount)} · ${DashboardFormatters.byteSize(row.totalSizeBytes)}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  String _kindLabel(CollectionAssetKind kind) {
    return switch (kind) {
      CollectionAssetKind.video => '영상',
      CollectionAssetKind.audio => '음성',
      CollectionAssetKind.timeseries => '센서',
      CollectionAssetKind.pose => '포즈',
      CollectionAssetKind.pointcloud => '깊이',
      CollectionAssetKind.image => '이미지',
      CollectionAssetKind.document => '문서',
      CollectionAssetKind.subtitle => '자막',
      CollectionAssetKind.ocrJson => 'OCR',
      CollectionAssetKind.region => '영역',
      CollectionAssetKind.unspecified => '기타',
    };
  }
}
