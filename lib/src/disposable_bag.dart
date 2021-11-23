part of disposables;

abstract class DisposableBag extends Iterable<Disposable> {
  final _disposables = <Disposable>[];

  FutureOr<void> dispose();

  bool get isAsync;

  @override
  int get length => _disposables.length;

  @override
  Iterator<Disposable> get iterator => _disposables.iterator;

  void add(Disposable disposable) {
    if (!isAsync && disposable.isAsync) {
      throw DisposeException.custom("Can't add async disposable with async DisposableBag");
    }
    disposable.throwIfNotAvailable();
    throwIfNotAvailable('add');
    _disposables.add(disposable);
  }

  void remove(Disposable disposable) {
    throwIfNotAvailable('remove');
    _disposables.remove(disposable);
  }

  void removeAt(int index) {
    throwIfNotAvailable('removeAt');
    _disposables.removeAt(index);
  }

  void clear() {
    throwIfNotAvailable('clear');
    _disposables.clear();
  }

  void throwIfNotAvailable([String? target]);

  //static DisposableBag sync() => _SyncDisposableBag._();
  //static DisposableBag async() => _AsyncDisposableBag._();
}

class _AsyncDisposableBag extends DisposableBag {
  late final Disposable _disposable;

  _AsyncDisposableBag._() {
    _disposable = Disposable.async(null, _disposeFunc);
  }

  @override
  bool get isAsync => true;

  bool get isDisposing => _disposable.isDisposing;

  bool get isDisposed => _disposable.isDisposed;

  @override
  void throwIfNotAvailable([String? target]) => _disposable.throwIfNotAvailable(target);

  //@override
  //void addCallback(FutureOr<void> Function() callback) => add(Disposable.asyncCallback(callback));

  @override
  Future<void> dispose() async => await _disposable.dispose();

  Future<void> _disposeFunc() async {
    final Map<Disposable, Object> map = {};
    for (final d in _disposables) {
      try {
        if (d.isAsync) {
          await d.dispose();
        } else {
          d.dispose();
        }
      } on Object catch (e) {
        map[d] = e;
      }
    }
    _disposables.clear();
    if (map.isNotEmpty) {
      throw DisposeException.aggregate(map);
    }
  }
}

class _SyncDisposableBag extends DisposableBag {
  late final Disposable _disposable;

  _SyncDisposableBag._() {
    _disposable = Disposable.sync(null, _disposeFunc);
  }

  @override
  bool get isAsync => false;

  bool get isDisposed => _disposable.isDisposed;

  @override
  void throwIfNotAvailable([String? target]) => _disposable.throwIfNotAvailable(target);

  @override
  void dispose() => _disposable.dispose();

  void _disposeFunc() {
    final Map<Disposable, Object> map = {};
    for (final d in _disposables) {
      try {
        d.dispose();
      } on Object catch (e) {
        map[d] = e;
      }
    }

    _disposables.clear();

    if (map.isNotEmpty) {
      throw DisposeException.aggregate(map);
    }
  }
}
