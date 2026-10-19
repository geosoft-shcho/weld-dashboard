import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart'
    show InputDecoration, OutlineInputBorder, TextField;

import '../themes/app_theme.dart';
import 'waveform_material_scope.dart';

/// Fluent Web에서 TextBox 입력이 Shell/lookup rebuild에 끊기는 것을 피하려고
/// 작업 조회 공통키와 같이 Material [TextField] + [WaveformMaterialScope]를 쓴다.
class LookupSearchField extends StatefulWidget {
  const LookupSearchField({
    super.key,
    required this.value,
    required this.hintText,
    required this.onChanged,
    this.onSubmitted,
  });

  final String value;
  final String hintText;
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  State<LookupSearchField> createState() => _LookupSearchFieldState();
}

class _LookupSearchFieldState extends State<LookupSearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant LookupSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_controller.text != widget.value) {
      _controller.value = TextEditingValue(
        text: widget.value,
        selection: TextSelection.collapsed(offset: widget.value.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WaveformMaterialScope(
      child: TextField(
        controller: _controller,
        style: const TextStyle(color: AppTheme.INK, fontSize: 13),
        cursorColor: AppTheme.ACCENT_STEEL,
        textInputAction: TextInputAction.search,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        decoration: InputDecoration(
          isDense: true,
          hintText: widget.hintText,
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
