import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart'
    show InputDecoration, OutlineInputBorder, TextField, TextInputAction;

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
    this.obscureText = false,
    this.textInputAction = TextInputAction.search,
    this.controller,
    this.suffixIcon,
  });

  final String value;
  final String hintText;
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool obscureText;
  final TextInputAction textInputAction;

  /// 넘기면 이 컨트롤러를 쓰고, 제출 시 부모가 최신 문구를 읽을 수 있다.
  final TextEditingController? controller;

  /// 입력란 오른쪽 아이콘(비밀번호 보기 등). 없으면 두지 않는다.
  final Widget? suffixIcon;

  @override
  State<LookupSearchField> createState() => _LookupSearchFieldState();
}

class _LookupSearchFieldState extends State<LookupSearchField> {
  TextEditingController? _ownedController;
  late final FocusNode _focusNode;

  TextEditingController get _controller =>
      widget.controller ?? _ownedController!;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    if (widget.controller == null) {
      _ownedController = TextEditingController(text: widget.value);
    } else if (widget.controller!.text != widget.value &&
        widget.value.isNotEmpty) {
      widget.controller!.text = widget.value;
    }
  }

  @override
  void didUpdateWidget(covariant LookupSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 포커스 중(타이핑·자동완성)에는 부모 value로 덮지 않는다.
    if (_focusNode.hasFocus) {
      return;
    }
    if (_controller.text != widget.value) {
      _controller.value = TextEditingValue(
        text: widget.value,
        selection: TextSelection.collapsed(offset: widget.value.length),
      );
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _ownedController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WaveformMaterialScope(
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        obscureText: widget.obscureText,
        style: const TextStyle(color: AppTheme.INK, fontSize: 13),
        cursorColor: AppTheme.ACCENT_STEEL,
        textInputAction: widget.textInputAction,
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
          suffixIcon: widget.suffixIcon,
          suffixIconConstraints: widget.suffixIcon == null
              ? null
              : const BoxConstraints(minWidth: 36, minHeight: 32),
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
