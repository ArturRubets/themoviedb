class PaginatorLoadResult<T> {
  PaginatorLoadResult({
    required this.data,
    required this.currentPage,
    required this.totalPage,
  });

  final List<T> data;
  final int currentPage;
  final int totalPage;
}

typedef PaginatorLoad<T> = Future<PaginatorLoadResult<T>> Function(int);

class Paginator<T> {
  final _data = <T>[];
  List<T> get data => _data;
  late int _currentPage;
  late int _totalPage;
  bool _isLoadingInProgress = false;
  final PaginatorLoad<T> _load;

  Paginator(this._load);

  Future<void> loadNextPage() async {
    if (_isLoadingInProgress || _currentPage >= _totalPage) return;
    _isLoadingInProgress = true;
    final nextPage = _currentPage + 1;

    try {
      final result = await _load(nextPage);
      _data.addAll(result.data);
      _currentPage = result.currentPage;
      _totalPage = result.totalPage;
      _isLoadingInProgress = false;
    } catch (e) {
      _isLoadingInProgress = false;
    }
  }

  Future<void> reset() async {
    _currentPage = 0;
    _totalPage = 1;
    _data.clear();
    await loadNextPage();
  }
}
