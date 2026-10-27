import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart'
    show InputDecoration, OutlineInputBorder, TextField;

import '../../../domain/entities/asset_lookup_row.dart';
import '../../../domain/entities/asset_upload.dart';
import '../../../domain/entities/camera_recording.dart';
import '../../../domain/entities/equipment.dart';
import '../../../domain/entities/work_history_item.dart';
import '../../core/themes/app_theme.dart';
import '../../core/widgets/waveform_material_scope.dart';

typedef AssetUploadQueueRunner =
    Future<AssetUploadBatchResult> Function({
      required String jobId,
      required String passId,
      required String equipmentId,
      required List<AssetUploadQueueEntry> entries,
      required void Function(AssetUploadQueueItem item) onItemUpdated,
      required String subject,
      required String situation,
    });

const _stepLabels = {
  'properties': '파일 속성',
  'duration': '길이',
  'normalize': '표준화',
  'timeline': '타임라인 배치',
  'report': '글자 인식·성적서',
};

Future<AssetUploadBatchResult?> showAssetUploadDialog(
  BuildContext context, {
  required List<WorkHistoryItem> jobs,
  required List<Equipment> equipment,
  required String initialJobId,
  required String initialPassId,
  required bool lockJob,
  required Future<AssetUploadFormats> Function() loadFormats,
  required Future<List<CameraRecordingFile>> Function() pickFiles,
  required AssetUploadQueueRunner uploadQueue,
}) {
  return showDialog<AssetUploadBatchResult>(
    context: context,
    builder: (_) => _AssetUploadDialog(
      jobs: jobs,
      equipment: equipment,
      initialJobId: initialJobId,
      initialPassId: initialPassId,
      lockJob: lockJob,
      loadFormats: loadFormats,
      pickFiles: pickFiles,
      uploadQueue: uploadQueue,
    ),
  );
}

class _DraftRow {
  _DraftRow({
    required this.localId,
    required this.file,
    required this.timeOriginController,
  });

  final String localId;
  final CameraRecordingFile file;
  final TextEditingController timeOriginController;
  AssetUploadQueueItem? progress;

  void dispose() {
    timeOriginController.dispose();
  }
}

class _AssetUploadDialog extends StatefulWidget {
  const _AssetUploadDialog({
    required this.jobs,
    required this.equipment,
    required this.initialJobId,
    required this.initialPassId,
    required this.lockJob,
    required this.loadFormats,
    required this.pickFiles,
    required this.uploadQueue,
  });

  final List<WorkHistoryItem> jobs;
  final List<Equipment> equipment;
  final String initialJobId;
  final String initialPassId;
  final bool lockJob;
  final Future<AssetUploadFormats> Function() loadFormats;
  final Future<List<CameraRecordingFile>> Function() pickFiles;
  final AssetUploadQueueRunner uploadQueue;

  @override
  State<_AssetUploadDialog> createState() => _AssetUploadDialogState();
}

class _AssetUploadDialogState extends State<_AssetUploadDialog> {
  final TextEditingController _commonTimeOriginController =
      TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _situationController = TextEditingController();

  final List<_DraftRow> _rows = [];
  AssetUploadFormats? _formats;
  List<JobPassOption> _passes = const [];
  String _jobId = '';
  String _passId = '';
  String _equipmentId = '';
  String _error = '';
  bool _isUploading = false;
  int _idSeq = 0;
  AssetUploadBatchResult? _batchResult;

  @override
  void initState() {
    super.initState();
    _jobId = widget.initialJobId;
    _passId = widget.initialPassId == jobCommonPassToken
        ? ''
        : widget.initialPassId;
    _passes = _passesOf(_jobId);
    _loadFormats();
  }

  List<JobPassOption> _passesOf(String jobId) {
    for (final job in widget.jobs) {
      if (job.jobId == jobId) return job.passes;
    }
    return const [];
  }

  @override
  void dispose() {
    _commonTimeOriginController.dispose();
    _subjectController.dispose();
    _situationController.dispose();
    for (final row in _rows) {
      row.dispose();
    }
    super.dispose();
  }

  Future<void> _loadFormats() async {
    try {
      final formats = await widget.loadFormats();
      if (mounted) {
        setState(() => _formats = formats);
      }
    } catch (error) {
      if (mounted) {
        setState(() => _error = error.toString());
      }
    }
  }

  AssetUploadFormat? _formatOf(String fileName) {
    return _formats?.formatOf(fileName);
  }

  String _fileHint(CameraRecordingFile file) {
    if (_formats == null) {
      return '종류는 서버가 내용으로 정합니다.';
    }
    final format = _formatOf(file.fileName);
    if (format == null) {
      return '표에 없는 형식 — 종류 없이 등록만 됩니다(실행 파일은 거절)';
    }
    return '짐작: ${format.label}';
  }

  Future<void> _didTapPickFiles() async {
    try {
      final files = await widget.pickFiles();
      if (!mounted || files.isEmpty) {
        return;
      }
      setState(() {
        for (final file in files) {
          _idSeq += 1;
          _rows.add(
            _DraftRow(
              localId: '$_idSeq',
              file: file,
              timeOriginController: TextEditingController(
                text: _commonTimeOriginController.text,
              ),
            ),
          );
        }
        _error = '';
        _batchResult = null;
      });
    } catch (error) {
      if (mounted) {
        setState(() => _error = error.toString());
      }
    }
  }

  void _didRemoveRow(_DraftRow row) {
    if (_isUploading) {
      return;
    }
    setState(() {
      _rows.remove(row);
      row.dispose();
    });
  }

  void _didSelectJob(String jobId) {
    setState(() {
      _jobId = jobId;
      _passId = '';
      _passes = _passesOf(jobId);
    });
  }

  DateTime? get _selectedPassStartedAt {
    for (final pass in _passes) {
      if (pass.passId == _passId) {
        return pass.startedAt;
      }
    }
    return null;
  }

  DateTime? get _selectedJobStartedAt {
    for (final job in widget.jobs) {
      if (job.jobId == _jobId) {
        return job.workedAt;
      }
    }
    return null;
  }

  void _fillCommonTimeOrigin(DateTime value) {
    final text = _timeText(value);
    _commonTimeOriginController.text = text;
    for (final row in _rows) {
      row.timeOriginController.text = text;
    }
    setState(() {});
  }

  void _applyCommonTimeOriginToRows() {
    final text = _commonTimeOriginController.text;
    for (final row in _rows) {
      row.timeOriginController.text = text;
    }
    setState(() {});
  }

  String _timeText(DateTime value) {
    String two(int part) => part.toString().padLeft(2, '0');
    return '${value.year}-${two(value.month)}-${two(value.day)} '
        '${two(value.hour)}:${two(value.minute)}:${two(value.second)}';
  }

  DateTime? _parseTime(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    return DateTime.tryParse(trimmed);
  }

  String? _validateBeforeUpload() {
    if (_rows.isEmpty) {
      return '파일을 고르세요.';
    }
    final maxBytes = _formats?.maxBytes ?? 0;
    for (final row in _rows) {
      if (maxBytes > 0 && row.file.bytes.length > maxBytes) {
        return '${row.file.fileName}: 파일이 너무 큽니다. 한도는 $maxBytes bytes입니다.';
      }
      final timeText = row.timeOriginController.text.trim();
      if (timeText.isNotEmpty && _parseTime(timeText) == null) {
        return '${row.file.fileName}: 시간 0의 시각 형식이 올바르지 않습니다. 예: 2026-09-16 13:38:53';
      }
      final format = _formatOf(row.file.fileName);
      if (format?.timeOriginRequired == true && timeText.isEmpty) {
        return '${row.file.fileName}: 시간 자료는 시간 0의 시각이 필요합니다(없으면 400).';
      }
    }
    return null;
  }

  Future<void> _didTapUpload() async {
    final validationError = _validateBeforeUpload();
    if (validationError != null) {
      setState(() => _error = validationError);
      return;
    }
    setState(() {
      _isUploading = true;
      _error = '';
      _batchResult = null;
      for (final row in _rows) {
        row.progress = AssetUploadQueueItem(
          localId: row.localId,
          fileName: row.file.fileName,
          status: AssetUploadItemStatus.waiting,
        );
      }
    });
    try {
      final result = await widget.uploadQueue(
        jobId: _jobId,
        passId: _passId == jobCommonPassToken ? '' : _passId,
        equipmentId: _equipmentId,
        subject: _subjectController.text.trim(),
        situation: _situationController.text.trim(),
        entries: [
          for (final row in _rows)
            AssetUploadQueueEntry(
              localId: row.localId,
              file: row.file,
              timeOrigin: _parseTime(row.timeOriginController.text),
            ),
        ],
        onItemUpdated: (item) {
          if (!mounted) {
            return;
          }
          setState(() {
            for (final row in _rows) {
              if (row.localId == item.localId) {
                row.progress = item;
                break;
              }
            }
          });
        },
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _isUploading = false;
        _batchResult = result;
      });
    } catch (error) {
      if (mounted) {
        setState(() {
          _isUploading = false;
          _error = error.toString();
        });
      }
    }
  }

  void _didTapClose() {
    final batch = _batchResult;
    if (batch != null && batch.hasSuccess) {
      Navigator.of(context).pop(batch);
      return;
    }
    Navigator.of(context).pop();
  }

  bool get _canCloseWithResult =>
      _batchResult != null && !_isUploading && _batchResult!.hasSuccess;

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text('에셋 올리기'),
      constraints: const BoxConstraints(maxWidth: 720, maxHeight: 760),
      content: SizedBox(
        width: 680,
        height: 560,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildCommonFields(),
                    const SizedBox(height: 12),
                    _buildQueueHeader(),
                    const SizedBox(height: 8),
                    if (_rows.isEmpty)
                      const Text(
                        '파일을 여러 개 고르면 대기열에 넣고, 동시에 최대 3개까지 올립니다. '
                        '32MB 이상은 이어 올리기(tus)로 보냅니다.',
                        style: TextStyle(fontSize: 12),
                      )
                    else
                      for (final row in _rows) ...[
                        _buildRow(row),
                        const SizedBox(height: 8),
                      ],
                    if (_error.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(_error, style: TextStyle(color: Colors.red)),
                    ],
                    if (_batchResult != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        '성공 ${_batchResult!.succeeded.length} · '
                        '실패 ${_batchResult!.failureNotes.length}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      for (final note in [
                        ..._batchResult!.warningNotes,
                        ..._batchResult!.failureNotes,
                      ])
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(note, style: const TextStyle(fontSize: 12)),
                        ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        Button(
          onPressed: _isUploading ? null : _didTapClose,
          child: Text(_canCloseWithResult ? '닫기' : '취소'),
        ),
        if (_canCloseWithResult)
          FilledButton(
            onPressed: () => Navigator.of(context).pop(_batchResult),
            child: const Text('완료'),
          )
        else
          FilledButton(
            onPressed: _isUploading ? null : _didTapUpload,
            child: Text(_isUploading ? '올리는 중…' : '올리기'),
          ),
      ],
    );
  }

  Widget _buildCommonFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InfoLabel(
          label: '주제',
          child: _MultilineTextInput(
            controller: _subjectController,
            hintText: '주제(파일 공통 기본값)',
            enabled: !_isUploading,
          ),
        ),
        const SizedBox(height: 12),
        InfoLabel(
          label: '상황',
          child: _MultilineTextInput(
            controller: _situationController,
            hintText: '상황(파일 공통 기본값)',
            enabled: !_isUploading,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: InfoLabel(
                label: '작업',
                child: ComboBox<String>(
                  isExpanded: true,
                  value: _jobId,
                  items: [
                    if (!widget.lockJob)
                      const ComboBoxItem(value: '', child: Text('작업 미지정')),
                    for (final job in widget.jobs)
                      ComboBoxItem(
                        value: job.jobId,
                        child: Text(
                          job.commonKey,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                  onChanged: _isUploading || widget.lockJob
                      ? null
                      : (value) {
                          if (value != null) {
                            _didSelectJob(value);
                          }
                        },
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: InfoLabel(
                label: '패스',
                child: ComboBox<String>(
                  isExpanded: true,
                  value: _passId,
                  items: [
                    const ComboBoxItem(value: '', child: Text('작업 공용')),
                    for (final pass in _passes)
                      ComboBoxItem(
                        value: pass.passId,
                        child: Text('${pass.passNo}패스'),
                      ),
                  ],
                  onChanged: _jobId.isEmpty || _isUploading
                      ? null
                      : (value) {
                          if (value != null) {
                            setState(() => _passId = value);
                          }
                        },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: InfoLabel(
                label: '장비',
                child: ComboBox<String>(
                  isExpanded: true,
                  value: _equipmentId,
                  items: [
                    const ComboBoxItem(value: '', child: Text('모름')),
                    for (final item in widget.equipment)
                      ComboBoxItem(
                        value: item.equipmentId,
                        child: Text(
                          item.equipmentName.isEmpty
                              ? item.equipmentCode
                              : item.equipmentName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                  onChanged: _isUploading
                      ? null
                      : (value) {
                          if (value != null) {
                            setState(() => _equipmentId = value);
                          }
                        },
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: InfoLabel(
                label: '시간 0의 시각(공통)',
                child: WaveformMaterialScope(
                  child: TextField(
                    controller: _commonTimeOriginController,
                    enabled: !_isUploading,
                    style: const TextStyle(color: AppTheme.INK, fontSize: 13),
                    cursorColor: AppTheme.ACCENT_STEEL,
                    decoration: _inputDecoration('2026-09-16 13:38:53'),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          '파일마다 시간 0을 따로 둘 수 있습니다. 액션캠·깊이 영상은 촬영 시각이 없을 수 있어 넣는 것이 좋습니다.',
          style: TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Button(
              onPressed: _isUploading ? null : _applyCommonTimeOriginToRows,
              child: const Text('공통 시각을 모든 파일에'),
            ),
            if (_selectedPassStartedAt != null)
              Button(
                onPressed: _isUploading
                    ? null
                    : () => _fillCommonTimeOrigin(_selectedPassStartedAt!),
                child: Text('패스 시작 ${_timeText(_selectedPassStartedAt!)}'),
              ),
            if (_selectedJobStartedAt != null)
              Button(
                onPressed: _isUploading
                    ? null
                    : () => _fillCommonTimeOrigin(_selectedJobStartedAt!),
                child: Text('작업 시작 ${_timeText(_selectedJobStartedAt!)}'),
              ),
            Button(
              onPressed: _isUploading
                  ? null
                  : () => _fillCommonTimeOrigin(DateTime.now()),
              child: const Text('현재 시각'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQueueHeader() {
    return Row(
      children: [
        Button(
          onPressed: _isUploading ? null : _didTapPickFiles,
          child: const Text('파일 고르기'),
        ),
        const SizedBox(width: 8),
        Text(
          _rows.isEmpty ? '선택한 파일 없음' : '${_rows.length}개 파일',
          style: const TextStyle(fontSize: 12),
        ),
        if (_isUploading) ...[
          const SizedBox(width: 12),
          const SizedBox(width: 16, height: 16, child: ProgressRing()),
        ],
      ],
    );
  }

  Widget _buildRow(_DraftRow row) {
    final format = _formatOf(row.file.fileName);
    final progress = row.progress;
    final requiredMark = format?.timeOriginRequired == true ? ' *' : '';
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF3E424A)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  row.file.fileName,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (!_isUploading)
                IconButton(
                  icon: const Icon(FluentIcons.chrome_close, size: 12),
                  onPressed: () => _didRemoveRow(row),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(_fileHint(row.file), style: const TextStyle(fontSize: 12)),
          if (format != null && format.steps.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              '후처리: ${[for (final step in format.steps) _stepLabels[step] ?? step].join(' → ')}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
          const SizedBox(height: 8),
          InfoLabel(
            label: '시간 0의 시각$requiredMark',
            child: WaveformMaterialScope(
              child: TextField(
                controller: row.timeOriginController,
                enabled: !_isUploading,
                style: const TextStyle(color: AppTheme.INK, fontSize: 13),
                cursorColor: AppTheme.ACCENT_STEEL,
                decoration: _inputDecoration('비우면 서버 규칙(파일 시각·촬영 시각)'),
              ),
            ),
          ),
          if (progress != null) ...[
            const SizedBox(height: 8),
            Text(
              _statusLine(progress),
              style: const TextStyle(fontSize: 12),
            ),
            for (final warning in progress.warnings)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  warning,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFE8A838),
                  ),
                ),
              ),
            if (progress.message.isNotEmpty &&
                (progress.status == AssetUploadItemStatus.failed ||
                    progress.status == AssetUploadItemStatus.postprocessFailed))
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  progress.message,
                  style: TextStyle(fontSize: 12, color: Colors.red),
                ),
              ),
          ],
        ],
      ),
    );
  }

  String _statusLine(AssetUploadQueueItem progress) {
    final label = progress.status.label;
    if (progress.status == AssetUploadItemStatus.postprocessRunning &&
        progress.progressPercent > 0) {
      return '$label ${progress.progressPercent.round()}%';
    }
    if (progress.status == AssetUploadItemStatus.uploading) {
      if (progress.progressPercent > 0) {
        return '$label ${progress.progressPercent.round()}%';
      }
      return label;
    }
    final assetId = progress.result?.assetId ?? '';
    if (assetId.isNotEmpty) {
      return '$label · 에셋 $assetId';
    }
    return label;
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      isDense: true,
      hintText: hintText,
      hintStyle: TextStyle(
        color: AppTheme.INK.withValues(alpha: 0.45),
        fontSize: 13,
      ),
      filled: true,
      fillColor: AppTheme.SURFACE,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Color(0xFF3E424A)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Color(0xFF3E424A)),
      ),
    );
  }
}

class _MultilineTextInput extends StatelessWidget {
  const _MultilineTextInput({
    required this.controller,
    required this.hintText,
    required this.enabled,
  });

  final TextEditingController controller;
  final String hintText;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return WaveformMaterialScope(
      child: TextField(
        controller: controller,
        enabled: enabled,
        minLines: 2,
        maxLines: 4,
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
