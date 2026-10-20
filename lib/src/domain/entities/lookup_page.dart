class LookupPage<T> {
  const LookupPage({
    required this.items,
    required this.nextPageToken,
    this.totalCount = 0,
  });

  final List<T> items;
  final String nextPageToken;
  final int totalCount;

  bool get doesHaveMore => nextPageToken.isNotEmpty;
}
