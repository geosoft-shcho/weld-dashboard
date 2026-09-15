import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/data/datasources/local/csv_parser.dart';
import 'package:weld_dashboard/src/domain/entities/work_attachment.dart';
import 'package:weld_dashboard/src/domain/entities/work_attachment_type.dart';
import 'package:weld_dashboard/src/domain/entities/work_detail_catalog.dart';
import 'package:weld_dashboard/src/domain/entities/work_history_item.dart';
import 'package:weld_dashboard/src/domain/use_cases/query_work_detail_use_case.dart';

void main() {
  test('csv parser keeps quoted multiline attachment content', () {
    const raw = '''
attachment_id,history_id,file_type,file_name,note,content
ATT-012,H001,text,작업일지.txt,메모,"첫 줄
둘째 줄"
ATT-003,H002,video,clip.mp4,캡 패스 12초,
''';
    final rows = CsvParser.rows(raw);
    expect(rows.length, 2);
    expect(rows.first['attachment_id'], 'ATT-012');
    expect(rows.first['content'], '첫 줄\n둘째 줄');
    expect(rows.last['attachment_id'], 'ATT-003');
    expect(rows.last['file_type'], 'video');
  });

  test('H001 detail keeps image pdf and multiline text', () {
    final detail = QueryWorkDetailUseCase().execute(
      catalog: _catalog(),
      historyId: 'H001',
    );
    expect(detail.job?.historyId, 'H001');
    expect(detail.attachments.map((item) => item.fileType).toList(), [
      WorkAttachmentType.image,
      WorkAttachmentType.pdf,
      WorkAttachmentType.text,
    ]);
    expect(detail.attachments.last.displayText.contains('캡 패스 시작'), isTrue);
  });

  test('empty history id picks latest job before snapshot', () {
    final detail = QueryWorkDetailUseCase().execute(
      catalog: _catalog(),
      historyId: '',
    );
    expect(detail.job?.historyId, 'H002');
  });
}

WorkDetailCatalog _catalog() {
  return WorkDetailCatalog(
    items: [
      _item('H001', DateTime(2026, 9, 6, 14, 20)),
      _item('H002', DateTime(2026, 9, 6, 16, 5)),
      _item('H003', DateTime(2026, 9, 5, 11, 12)),
    ],
    attachments: const [
      WorkAttachment(
        attachmentId: 'ATT-001',
        historyId: 'H001',
        fileType: WorkAttachmentType.image,
        fileName: '비드 외관_캡.jpg',
        note: '캡 패스 표면',
        content: '',
      ),
      WorkAttachment(
        attachmentId: 'ATT-002',
        historyId: 'H001',
        fileType: WorkAttachmentType.pdf,
        fileName: '성적서_H001.pdf',
        note: '페이퍼 스캔 3쪽',
        content: '',
      ),
      WorkAttachment(
        attachmentId: 'ATT-012',
        historyId: 'H001',
        fileType: WorkAttachmentType.text,
        fileName: '작업일지_H001.txt',
        note: '캡 패스 작업 메모',
        content: '[2026-09-06 14:20] 캡 패스 시작\n장비 EQ-01',
      ),
      WorkAttachment(
        attachmentId: 'ATT-003',
        historyId: 'H002',
        fileType: WorkAttachmentType.video,
        fileName: '아크_캡_12s.mp4',
        note: '캡 패스 12초',
        content: '',
      ),
    ],
  );
}

WorkHistoryItem _item(String historyId, DateTime workedAt) {
  return WorkHistoryItem(
    historyId: historyId,
    commonKey: 'WO-2026-0312|J-A-14',
    workOrderId: 'WO1',
    workOrderNo: 'WO-2026-0312',
    title: '압력용기 쉘 종용접',
    jointId: 'JT-A14',
    jointNo: 'J-A-14',
    jointName: '쉘 종용접 하부',
    workerId: 'WK-01',
    workerName: '박대조',
    equipmentId: 'EQ-01',
    equipmentName: '용접기 A라인-1',
    workedAt: workedAt,
    passCount: 3,
    attachmentCount: 1,
  );
}
