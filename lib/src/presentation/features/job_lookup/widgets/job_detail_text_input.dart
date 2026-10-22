import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart'
    show InputDecoration, OutlineInputBorder, TextField;

import '../../../core/themes/app_theme.dart';
import '../../../core/widgets/waveform_material_scope.dart';

String jobDateTimeText(DateTime? value) {
  if (value == null) return '';
  String two(int n) => n.toString().padLeft(2, '0');
  final ms = value.millisecond.toString().padLeft(3, '0');
  return '${value.year}-${two(value.month)}-${two(value.day)} '
      '${two(value.hour)}:${two(value.minute)}:${two(value.second)}.$ms';
}

/// 빈 값이면 null, 형식이 틀리면 null이면서 [isBad]로 구분한다.
DateTime? parseJobDateTime(String text) {
  final trimmed = text.trim();
  if (trimmed.isEmpty) return null;
  return DateTime.tryParse(trimmed.replaceFirst(' ', 'T'));
}

bool isBadJobDateTime(String text) {
  return text.trim().isNotEmpty && parseJobDateTime(text) == null;
}

class JobDetailTextInput extends StatelessWidget {
  const JobDetailTextInput({
    super.key,
    required this.controller,
    this.hintText = '',
    this.enabled = true,
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
