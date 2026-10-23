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

typedef AssetUploadFile =
    Future<AssetUploadResult> Function({
      required String jobId,
      required String passId,
      required String equipmentId,
      required DateTime? timeOrigin,
      required CameraRecordingFile file,
    });

const _stepLabels = {
  'properties': '파일 속성',
  'duration': '길이',
  'normalize': '표준화',
  'timeline': '타임라인 배치',
  'report': '글자 인식·성적서',
};

Future<AssetUploadResult?> showAssetUploadDialog(
  BuildContext context, {
  required List<WorkHistoryItem> jobs,
  required List<Equipment> equipment,
  required String initialJobId,
  required String initialPassId,
  required bool lockJob,
  required Future<AssetUploadFormats> Function() loadFormats,
  required Future<CameraRecordingFile?> Function() pickFile,
  required AssetUploadFile uploadFile,
}) {
  return showDialog<AssetUploadResult>(
    context: context,
    builder: (_) => _AssetUploadDialog(
      jobs: jobs,
      equipment: equipment,
      initialJobId: initialJobId,
      initialPassId: initialPassId,
      lockJob: lockJob,
      loadFormats: loadFormats,
      pickFile: pickFile,
      uploadFile: uploadFile,
    ),
  );
}

class _AssetUploadDialog extends StatefulWidget {
  const _AssetUploadDialog({
    required this.jobs,
    required this.equipment,
    required this.initialJobId,
    required this.initialPassId,
    required this.lockJob,
    required this.loadFormats,
    required this.pickFile,
    required this.uploadFile,
  });

  final List<WorkHistoryItem> jobs;
  final List<Equipment> equipment;
  final String initialJobId;
  final String initialPassId;
  final bool lockJob;
  final Future<AssetUploadFormats> Function() loadFormats;
  final Future<CameraRecordingFile?> Function() pickFile;
  final AssetUploadFile uploadFile;

  @override
  State<_AssetUploadDialog> createState() => _AssetUploadDialogState();
}

class _AssetUploadDialogState extends State<_AssetUploadDialog> {
  final TextEditingController _timeOriginController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _situationController = TextEditingController();

  CameraRecordingFile? _file;
  AssetUploadFormats? _formats;
  List<JobPassOption> _passes = const [];
  String _jobId = '';
  String _passId = '';
  String _equipmentId = '';
  String _error = '';
  bool _isUploading = false;

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
    _timeOriginController.dispose();
    _subjectController.dispose();
    _situationController.dispose();
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

  AssetUploadFormat? get _guessedFormat {
    final file = _file;
    final formats = _formats;
    if (file == null || formats == null) {
      return null;
    }
    return formats.formatOf(file.fileName);
  }

  String get _fileHint {
    if (_file == null || _formats == null) {
      return '종류는 서버가 내용으로 정합니다. 표시는 확장자로 짐작한 안내입니다(ListUploadFormats).';
    }
    final format = _guessedFormat;
    if (format == null) {
      return '표에 없는 형식 — 종류 없이 등록만 됩니다(실행 파일은 거절)';
    }
    return '짐작: ${format.label} — 서버가 내용으로 최종 판별합니다';
  }

  Future<void> _didTapPickFile() async {
    try {
      final file = await widget.pickFile();
      if (file != null && mounted) {
        setState(() {
          _file = file;
          _error = '';
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() => _error = error.toString());
      }
    }
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

  void _fillTimeOrigin(DateTime value) {
    _timeOriginController.text = _timeText(value);
  }

  String _timeText(DateTime value) {
    String two(int part) => part.toString().padLeft(2, '0');
    return '${value.year}-${two(value.month)}-${two(value.day)} '
        '${two(value.hour)}:${two(value.minute)}:${two(value.second)}';
  }

  Future<void> _didTapUpload() async {
    final file = _file;
    if (file == null) {
      setState(() => _error = '파일을 고르세요.');
      return;
    }
    final maxBytes = _formats?.maxBytes ?? 0;
    if (maxBytes > 0 && file.bytes.length > maxBytes) {
      setState(() => _error = '파일이 너무 큽니다. 한도는 $maxBytes bytes입니다.');
      return;
    }
    final timeText = _timeOriginController.text.trim();
    final timeOrigin = timeText.isEmpty ? null : DateTime.tryParse(timeText);
    if (timeText.isNotEmpty && timeOrigin == null) {
      setState(() => _error = '시간 0의 시각 형식이 올바르지 않습니다. 예: 2026-09-16 13:38:53');
      return;
    }
    if (_guessedFormat?.timeOriginRequired == true && timeOrigin == null) {
      setState(() => _error = '시간 자료는 시간 0의 시각이 필요합니다(없으면 400).');
      return;
    }
    setState(() {
      _isUploading = true;
      _error = '';
    });
    try {
      final result = await widget.uploadFile(
        jobId: _jobId,
        passId: _passId == jobCommonPassToken ? '' : _passId,
        equipmentId: _equipmentId,
        timeOrigin: timeOrigin,
        file: file,
      );
      if (mounted) {
        Navigator.of(context).pop(result);
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isUploading = false;
          _error = error.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final format = _guessedFormat;
    return ContentDialog(
      title: const Text('에셋 올리기'),
      constraints: const BoxConstraints(maxWidth: 480, maxHeight: 640),
      content: SizedBox(
        width: 440,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InfoLabel(
                label: '파일 *',
                child: Row(
                  children: [
                    Button(
                      onPressed: _isUploading ? null : _didTapPickFile,
                      child: const Text('파일 고르기'),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _file?.fileName ?? '선택한 파일 없음',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(_fileHint, style: const TextStyle(fontSize: 12)),
              if (format != null && format.steps.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  '올린 뒤 후처리: ${[for (final step in format.steps) _stepLabels[step] ?? step].join(' → ')}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
              const SizedBox(height: 12),
              InfoLabel(
                label: '주제',
                child: _MultilineTextInput(
                  controller: _subjectController,
                  hintText: '주제',
                  enabled: !_isUploading,
                ),
              ),
              const SizedBox(height: 12),
              InfoLabel(
                label: '상황',
                child: _MultilineTextInput(
                  controller: _situationController,
                  hintText: '상황',
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
                            const ComboBoxItem(
                              value: '',
                              child: Text('작업 미지정'),
                            ),
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
                      label:
                          '시간 0의 시각${format?.timeOriginRequired == true ? ' *' : ''}',
                      child: WaveformMaterialScope(
                        child: TextField(
                          controller: _timeOriginController,
                          enabled: !_isUploading,
                          style: const TextStyle(
                            color: AppTheme.INK,
                            fontSize: 13,
                          ),
                          cursorColor: AppTheme.ACCENT_STEEL,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: '2026-09-16 13:38:53',
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
                              borderSide: const BorderSide(
                                color: Color(0xFF3E424A),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: const BorderSide(
                                color: Color(0xFF3E424A),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                '영상은 첫 프레임, IMU는 깊이 녹화 시작, 회전수는 구간 시작',
                style: TextStyle(fontSize: 12),
              ),
              if (_file != null && format?.timeOriginRequired == true) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (_selectedPassStartedAt != null)
                      Button(
                        onPressed: _isUploading
                            ? null
                            : () => _fillTimeOrigin(_selectedPassStartedAt!),
                        child: Text(
                          '패스 시작 ${_timeText(_selectedPassStartedAt!)}',
                        ),
                      ),
                    if (_selectedJobStartedAt != null)
                      Button(
                        onPressed: _isUploading
                            ? null
                            : () => _fillTimeOrigin(_selectedJobStartedAt!),
                        child: Text(
                          '작업 시작 ${_timeText(_selectedJobStartedAt!)}',
                        ),
                      ),
                    if (_file?.lastModifiedAt != null)
                      Button(
                        onPressed: _isUploading
                            ? null
                            : () => _fillTimeOrigin(_file!.lastModifiedAt!),
                        child: Text(
                          '파일 시각 ${_timeText(_file!.lastModifiedAt!)}',
                        ),
                      ),
                    Button(
                      onPressed: _isUploading
                          ? null
                          : () => _fillTimeOrigin(DateTime.now()),
                      child: const Text('현재 시각'),
                    ),
                  ],
                ),
              ],
              if (_isUploading) ...[
                const SizedBox(height: 12),
                const Center(child: ProgressRing()),
              ],
              if (_error.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(_error, style: TextStyle(color: Colors.red)),
              ],
            ],
          ),
        ),
      ),
      actions: [
        Button(
          onPressed: _isUploading ? null : () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: _isUploading ? null : _didTapUpload,
          child: const Text('올리기'),
        ),
      ],
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
        maxLines: 6,
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
