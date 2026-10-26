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
    // 보더는 부모 툴바 필드 셸이 그린다. 여기선 내용만 채운다.
    return WaveformMaterialScope(
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        expands: true,
        maxLines: null,
        minLines: null,
        style: const TextStyle(color: AppTheme.INK, fontSize: 13, height: 1.2),
        cursorColor: AppTheme.ACCENT_STEEL,
        textInputAction: TextInputAction.search,
        textAlignVertical: TextAlignVertical.center,
        onTap: () => _focusNode.requestFocus(),
        onSubmitted: (_) => _didSubmit(),
        decoration: InputDecoration(
          isDense: true,
          isCollapsed: true,
          hintText: '검색',
          hintStyle: TextStyle(
            color: AppTheme.INK.withValues(alpha: 0.45),
            fontSize: 13,
            height: 1.2,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        ),
      ),
    );
  }
}
