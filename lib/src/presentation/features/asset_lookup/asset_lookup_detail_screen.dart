import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart'
    show InputDecoration, OutlineInputBorder, TextField;
import 'package:provider/provider.dart';

import '../../../domain/entities/asset_lookup_kind.dart';
import '../../../domain/entities/asset_lookup_row.dart';
import '../../core/di/locator.dart';
import '../../core/formatters/dashboard_formatters.dart';
import '../../core/themes/app_theme.dart';
import '../../core/widgets/lookup_detail_scaffold.dart';
import '../../core/widgets/query_failure_pane.dart';
import '../../core/widgets/waveform_material_scope.dart';
import '../../navigation/app_coordinator.dart';
import 'asset_lookup_detail_view_model.dart';
import 'widgets/asset_preview_pane.dart';

class AssetLookupDetailScreen extends StatelessWidget {
  const AssetLookupDetailScreen({super.key, required this.assetId});

  final String assetId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          locator<AssetLookupDetailViewModel>(param1: assetId)..load(),
      child: const _AssetLookupDetailBody(),
    );
  }
}

class _AssetLookupDetailBody extends StatelessWidget {
  const _AssetLookupDetailBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AssetLookupDetailViewModel>();
    final coordinator = context.read<AppCoordinator>();
    final asset = viewModel.asset;
    final kindLabel = asset == null
        ? '에셋'
        : AssetLookupKindOption.labelOf(asset.kindCode);
    return LookupDetailScaffold(
      title: asset == null ? '에셋 상세' : '$kindLabel ${asset.assetId}',
      subtitle: '',
      onBack: coordinator.didTapBackFromLookupDetail,
      actions: [Button(onPressed: null, child: const Text('지우기'))],
      body: _body(context, viewModel, coordinator),
    );
  }

  Widget _body(
    BuildContext context,
    AssetLookupDetailViewModel viewModel,
    AppCoordinator coordinator,
  ) {
    if (viewModel.isLoading && viewModel.asset == null) {
      return const Center(child: ProgressRing());
    }
    if (viewModel.hasError) {
      return QueryFailurePane(
        title: '조회 실패',
        message: viewModel.errorMessage,
        onRetry: viewModel.load,
      );
    }
    final asset = viewModel.asset;
    if (asset == null) {
      return const InfoBar(
        title: Text('에셋 없음'),
        severity: InfoBarSeverity.warning,
      );
    }
    return ListView(
      children: [
        Text(
          asset.fileName,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        AssetPreviewPane(
          asset: asset,
          readContent: viewModel.readContent,
        ),
        const SizedBox(height: 12),
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppTheme.SURFACE_RAISED,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: const Color(0xFF3E424A)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Text(
                      '주제·상황',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Tooltip(
                      message: '주제·상황·기록 시각 수정',
                      child: IconButton(
                        icon: const Icon(FluentIcons.edit, size: 14),
                        onPressed: () =>
                            _didTapEditSubjectSituation(context, asset),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _LabeledTextBlock(label: '주제', value: asset.subject),
                const SizedBox(height: 12),
                _LabeledTextBlock(label: '상황', value: asset.situation),
                const SizedBox(height: 12),
                _LabeledTextBlock(
                  label: '기록 시작 시각',
                  value: asset.recordedAt == null
                      ? '—'
                      : DashboardFormatters.dateTime(asset.recordedAt!),
                ),
              ],
            ),
          ),
        ),
        const LookupDetailSectionTitle('정보'),
        LookupDetailKvGrid(
          entries: [
            ('장비', viewModel.equipmentNameOf(asset.equipmentId)),
            for (final field in asset.displayFields)
              (field.label, field.value),
            ('크기', DashboardFormatters.byteSize(asset.sizeBytes)),
            ('길이', DashboardFormatters.durationFromNs(asset.durationNs)),
            ('파생', '${asset.childCount}개'),
          ],
        ),
        if (asset.propertiesJson.isNotEmpty)
          Expander(
            header: const Text('원래 properties 보기'),
            content: SelectableText(
              asset.propertiesJson,
              style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
            ),
          ),
        const SizedBox(height: 8),
        if (asset.provenanceSummary.isNotEmpty)
          InfoBar(
            title: const Text('만든 경위'),
            content: Text(
              '${asset.provenanceSummary}'
              '${asset.parentAssetId.isEmpty ? '' : '\n부모 ${asset.parentAssetId}'}',
            ),
            severity: InfoBarSeverity.info,
          )
        else
          Text(
            '원본 업로드(만든 경위 없음)',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.55),
            ),
          ),
        LookupDetailSectionTitle(
          '붙은 작업',
          trailing: viewModel.jobs.isEmpty
              ? Button(onPressed: null, child: const Text('작업에 붙이기'))
              : null,
        ),
        LookupDetailPlainTable(
          headers: const ['공통키', '이음부', '작업일시', '패스'],
          emptyText: '작업 미지정',
          rows: [
            for (final job in viewModel.jobs)
              [
                job.commonKey,
                job.jointNo,
                DashboardFormatters.dateTime(job.workedAt),
                '—',
              ],
          ],
          onRowTap: (index) {
            coordinator.didTapOpenWorkDetail(
              context,
              jobId: viewModel.jobs[index].jobId,
            );
          },
        ),
      ],
    );
  }

}

Future<void> _didTapEditSubjectSituation(
  BuildContext context,
  AssetLookupRow asset,
) async {
  final viewModel = context.read<AssetLookupDetailViewModel>();
  final subjectController = TextEditingController(text: asset.subject);
  final situationController = TextEditingController(text: asset.situation);
  final recordedController = TextEditingController(
    text: asset.recordedAt == null
        ? ''
        : DashboardFormatters.dateTime(asset.recordedAt!),
  );
  var error = '';
  var busy = false;
  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return ContentDialog(
            title: const Text('주제·상황·기록 시각'),
            content: SizedBox(
              width: 420,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InfoLabel(
                    label: '주제',
                    child: _MultilineTextInput(
                      controller: subjectController,
                      enabled: !busy,
                    ),
                  ),
                  const SizedBox(height: 12),
                  InfoLabel(
                    label: '상황',
                    child: _MultilineTextInput(
                      controller: situationController,
                      enabled: !busy,
                    ),
                  ),
                  const SizedBox(height: 12),
                  InfoLabel(
                    label: '기록 시작 시각',
                    child: _MultilineTextInput(
                      controller: recordedController,
                      enabled: !busy,
                      minLines: 1,
                      maxLines: 1,
                      hintText: '2026-09-16 13:38:53',
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '시각을 고치면 자동 배치 클립을 다시 놓습니다(사람이 손댄 클립은 그대로).',
                    style: TextStyle(fontSize: 12),
                  ),
                  if (error.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(error, style: TextStyle(color: Colors.red)),
                  ],
                ],
              ),
            ),
            actions: [
              Button(
                onPressed: busy
                    ? null
                    : () => Navigator.of(dialogContext).pop(),
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
                          final timeText = recordedController.text.trim();
                          DateTime? recordedAt;
                          if (timeText.isNotEmpty) {
                            recordedAt = DateTime.tryParse(
                              timeText.contains('T')
                                  ? timeText
                                  : timeText.replaceFirst(' ', 'T'),
                            );
                            if (recordedAt == null) {
                              throw ArgumentError(
                                '기록 시각 형식이 올바르지 않습니다.',
                              );
                            }
                          }
                          await viewModel.updateSubjectSituation(
                            subject: subjectController.text.trim(),
                            situation: situationController.text.trim(),
                            recordedAt: recordedAt,
                          );
                          if (dialogContext.mounted) {
                            Navigator.of(dialogContext).pop();
                          }
                        } catch (e) {
                          setDialogState(() {
                            busy = false;
                            error = e.toString();
                          });
                        }
                      },
                child: const Text('저장'),
              ),
            ],
          );
        },
      );
    },
  );
  subjectController.dispose();
  situationController.dispose();
  recordedController.dispose();
}

class _LabeledTextBlock extends StatelessWidget {
  const _LabeledTextBlock({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppTheme.STATUS_OFF),
        ),
        const SizedBox(height: 2),
        SelectableText(
          value.isEmpty ? '—' : value,
          style: const TextStyle(fontSize: 13),
        ),
      ],
    );
  }
}

class _MultilineTextInput extends StatelessWidget {
  const _MultilineTextInput({
    required this.controller,
    required this.enabled,
    this.minLines = 2,
    this.maxLines = 6,
    this.hintText,
  });

  final TextEditingController controller;
  final bool enabled;
  final int minLines;
  final int maxLines;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return WaveformMaterialScope(
      child: TextField(
        controller: controller,
        enabled: enabled,
        minLines: minLines,
        maxLines: maxLines,
        style: const TextStyle(color: AppTheme.INK, fontSize: 13),
        cursorColor: AppTheme.ACCENT_STEEL,
        decoration: InputDecoration(
          isDense: true,
          hintText: hintText,
          hintStyle: TextStyle(
            color: AppTheme.INK.withValues(alpha: 0.45),
            fontSize: 13,
          ),
          filled: true,
          fillColor: AppTheme.SURFACE,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: Color(0xFF3E424A)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: Color(0xFF3E424A)),
          ),
        ),
      ),
    );
  }
}
