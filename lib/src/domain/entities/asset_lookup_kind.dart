class AssetLookupKindOption {
  const AssetLookupKindOption({required this.code, required this.label});

  final String code;
  final String label;

  static const List<AssetLookupKindOption> kinds = [
    AssetLookupKindOption(code: '', label: '전체'),
    AssetLookupKindOption(code: 'video', label: '영상'),
    AssetLookupKindOption(code: 'audio', label: '음성'),
    AssetLookupKindOption(code: 'image', label: '이미지'),
    AssetLookupKindOption(code: 'document', label: '문서'),
    AssetLookupKindOption(code: 'pose', label: '포즈'),
    AssetLookupKindOption(code: 'subtitle', label: '자막'),
    AssetLookupKindOption(code: 'timeseries', label: '센서'),
    AssetLookupKindOption(code: 'pointCloud', label: '깊이 원본'),
    AssetLookupKindOption(code: 'ocrJson', label: '글자 인식'),
    AssetLookupKindOption(code: 'region', label: '영역'),
  ];

  static String labelOf(String code) {
    for (final kind in kinds) {
      if (kind.code == code) {
        return kind.label;
      }
    }
    return code.isEmpty ? '—' : code;
  }
}
