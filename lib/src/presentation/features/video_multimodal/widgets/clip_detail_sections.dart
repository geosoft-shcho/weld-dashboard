import '../../../../domain/entities/job_timeline.dart';

class ClipDetailRow {
  const ClipDetailRow({required this.label, required this.value});

  final String label;
  final String value;
}

class ClipDetailSection {
  const ClipDetailSection({required this.title, required this.rows});

  final String title;
  final List<ClipDetailRow> rows;
}

const _SECTION_TITLES = [
  '클립',
  '파일 구간',
  '클립 파일',
  '만든 실행',
  '관계',
  '대상 클립',
  '대상 파일',
];

const _CLIP_KEYS = {
  'clipId',
  'trackId',
  'kind',
  'timelineStartNs',
  'timelineEndNs',
  'labelValueId',
  'description',
  'embeddedAt',
  'createdAt',
  'updatedAt',
};

const _FIELD_LABELS = {
  'clipId': '클립 번호',
  'trackId': '트랙 번호',
  'kind': '종류',
  'timelineStartNs': '타임라인 시작',
  'timelineEndNs': '타임라인 끝',
  'labelValueId': '라벨',
  'description': '설명',
  'embeddedAt': '임베딩 시각',
  'createdAt': '만든 시각',
  'updatedAt': '고친 시각',
  'source.assetId': '파일 번호',
  'source.startNs': '파일 시작',
  'source.endNs': '파일 끝',
  'source.locator': '위치',
  'asset': '상태',
  'asset.assetId': '파일 번호',
  'asset.kind': '종류',
  'asset.fileName': '파일 이름',
  'asset.sha256': 'SHA-256',
  'asset.mimeType': 'MIME',
  'asset.sizeBytes': '크기',
  'asset.properties': '속성',
  'asset.equipmentId': '장비 번호',
  'asset.collectedAt': '수집 시각',
  'asset.recordedAt': '기록 시각',
  'asset.durationNs': '길이',
  'asset.provenance.operation': '작업',
  'asset.provenance.runId': '실행 번호',
  'asset.provenance.toolId': '도구 번호',
  'asset.provenance.toolVersion': '도구 버전',
  'asset.provenance.parameters': '매개변수',
  'asset.provenance.parentAssetId': '부모 파일 번호',
  'asset.contentUrl': '내용 주소',
  'asset.childCount': '자식 수',
  'provenance.confidence': '확신도',
  'provenance.reviewed': '검토',
  'provenance.runId': '실행 번호',
  'provenance.toolId': '도구 번호',
  'provenance.toolVersion': '도구 버전',
  'provenance.targetKind': '대상 종류',
  'provenance.targetId': '대상',
  'relation.fromClipId': '시작 클립',
  'relation.toClipId': '끝 클립',
  'targetClip': '상태',
  'targetClip.clipId': '클립 번호',
  'targetClip.kind': '종류',
  'targetClip.timelineStartNs': '타임라인 시작',
  'targetClip.timelineEndNs': '타임라인 끝',
  'targetAsset': '상태',
  'targetAsset.assetId': '파일 번호',
  'targetAsset.kind': '종류',
  'targetAsset.fileName': '파일 이름',
  'targetAsset.contentUrl': '내용 주소',
};

List<ClipDetailSection> groupClipDetailFields(List<ClipField> fields) {
  final buckets = <String, List<ClipDetailRow>>{
    for (final title in _SECTION_TITLES) title: <ClipDetailRow>[],
  };
  final clipExtras = <ClipDetailRow>[];
  for (final field in fields) {
    final title = _sectionTitle(field.label);
    final row = ClipDetailRow(
      label: _fieldLabel(field.label),
      value: field.value,
    );
    if (title == '클립' && !_CLIP_KEYS.contains(field.label)) {
      clipExtras.add(row);
      continue;
    }
    buckets[title]!.add(row);
  }
  buckets['클립']!.addAll(clipExtras);

  final sections = <ClipDetailSection>[];
  for (final title in _SECTION_TITLES) {
    final rows = buckets[title]!;
    if (rows.isEmpty) {
      continue;
    }
    if (title == '관계' && rows.every((row) => row.value == '—')) {
      continue;
    }
    sections.add(ClipDetailSection(title: title, rows: rows));
  }
  return sections;
}

String _sectionTitle(String key) {
  if (key == 'asset' || key.startsWith('asset.')) {
    return '클립 파일';
  }
  if (key.startsWith('source.')) {
    return '파일 구간';
  }
  if (key.startsWith('provenance.')) {
    return '만든 실행';
  }
  if (key.startsWith('relation.')) {
    return '관계';
  }
  if (key == 'targetClip' || key.startsWith('targetClip.')) {
    return '대상 클립';
  }
  if (key == 'targetAsset' || key.startsWith('targetAsset.')) {
    return '대상 파일';
  }
  return '클립';
}

String _fieldLabel(String key) {
  final known = _FIELD_LABELS[key];
  if (known != null) {
    return known;
  }
  const assetProvenance = 'asset.provenance.';
  if (!key.startsWith(assetProvenance)) {
    return key;
  }
  final provenanceKey = 'provenance.${key.substring(assetProvenance.length)}';
  return _FIELD_LABELS[provenanceKey] ?? key;
}
