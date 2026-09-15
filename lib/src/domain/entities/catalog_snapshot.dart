class CatalogSnapshot {
  const CatalogSnapshot({
    required this.rowCountsByAsset,
    required this.snapshotAt,
    required this.pdfrxReady,
  });

  final Map<String, int> rowCountsByAsset;
  final DateTime snapshotAt;
  final bool pdfrxReady;

  int get tableCount => rowCountsByAsset.length;

  int get totalRowCount =>
      rowCountsByAsset.values.fold(0, (sum, count) => sum + count);
}
