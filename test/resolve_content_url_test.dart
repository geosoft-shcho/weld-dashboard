import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/data/datasources/remote/media_tag_data_source.dart';

void main() {
  const baseUrl = 'https://tks.faivv.ai/api';
  const filePath = '/files/devseed/ast_devcmb_05ae898d0f142e38127842ce.csv';
  const fileUrl =
      'https://tks.faivv.ai/api/files/devseed/ast_devcmb_05ae898d0f142e38127842ce.csv';

  late MediaTagDataSource dataSource;

  setUp(() {
    dataSource = MediaTagDataSource(baseUrl: baseUrl);
  });

  test('a root content path keeps the api prefix', () {
    expect(dataSource.resolveContentUrl(filePath), fileUrl);
  });

  test('a relative content path keeps the api prefix', () {
    expect(
      dataSource.resolveContentUrl(filePath.substring(1)),
      fileUrl,
    );
  });

  test('a base url with a trailing slash keeps a single slash', () {
    final source = MediaTagDataSource(baseUrl: '$baseUrl/');
    expect(source.resolveContentUrl(filePath), fileUrl);
  });

  test('an absolute content url stays unchanged', () {
    const absolute = 'https://example.com/files/a.csv';
    expect(dataSource.resolveContentUrl(absolute), absolute);
  });

  test('an empty content path stays empty', () {
    expect(dataSource.resolveContentUrl(''), '');
  });
}
