import 'package:flutter/material.dart';

import '../themes/app_theme.dart';
import 'waveform_material_scope.dart';

/// PDF 툴바 검색 전용 필드.
///
/// 부모 [setState]와 분리된 [State]를 가져 입력 중 리빌드해도
/// 포커스·IME가 유지된다. Fluent TextBox 대신 Material [TextField]를 써서
/// pdfrx Focus와 키보드 경쟁을 줄인다.
class PdfrxSearchField extends StatefulWidget {
  const PdfrxSearchField({
    super.key,
    required this.onSubmit,
  });

  final ValueChanged<String> onSubmit;

  @override
  State<PdfrxSearchField> createState() => PdfrxSearchFieldState();
}

class PdfrxSearchFieldState extends State<PdfrxSearchField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  String get query => _controller.text.trim();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode(debugLabel: 'pdfrxSearchField');
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void clear() {
    _controller.clear();
  }

  void _didSubmit() {
    widget.onSubmit(query);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 34,
      child: WaveformMaterialScope(
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          style: const TextStyle(color: AppTheme.INK, fontSize: 13),
          cursorColor: AppTheme.ACCENT_STEEL,
          textInputAction: TextInputAction.search,
          onTap: () => _focusNode.requestFocus(),
          onSubmitted: (_) => _didSubmit(),
          decoration: InputDecoration(
            isDense: true,
            hintText: '검색',
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
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: AppTheme.ACCENT_STEEL),
            ),
          ),
        ),
      ),
    );
  }
}
