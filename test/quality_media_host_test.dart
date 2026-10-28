import 'package:flutter_test/flutter_test.dart';

/// QualityMediaHost는 pdfrx native 경로를 끌어오며, VM 테스트에서
/// `pdfrx_engine` PdfFileCache null-safety 컴파일 오류가 난다(웹 실행은 WASM 경로).
/// PDF/Video 탭 UI는 웹에서 수동 확인한다.
void main() {
  test(
    'quality media host widget test skipped on VM (pdfrx_engine)',
    () {},
    skip: 'pdfrx_engine PdfFileCache null-safety breaks VM compile',
  );
}
