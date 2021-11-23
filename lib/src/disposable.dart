part of disposables;

class Disposable<T extends Object> {
  final bool _isAsync;
  final T? _source;
  final _VoidFunc? _syncFunc;
  final _AsyncVoidFunc? _asyncFunc;

  bool _isDisposing = false;
  bool _isDisposed = false;

  bool get isAsync => _isAsync;
  bool get isDisposing => _isDisposing;
  bool get isDisposed => _isDisposed;

  T? get source => _source;

  Disposable<T> asAsync() {
    if (_isAsync) return this;
    return Disposable.async(_source, () async => _syncDispose());
  }

  Disposable<T> disposeBy(dynamic disposer) {
    if (disposer is DisposableBag) {
      disposer.add(this);
    } else if (disposer is DisposableMixin) {
      disposer.autoDispose(this);
    } else {
      throw DisposeException.custom(
        'Argument disposer must be DisposableBag or DisposableBagMixinBase',
      );
    }
    return this;
  }

  Disposable._({
    bool isAsync = false,
    T? source,
    _VoidFunc? syncFunc,
    _AsyncVoidFunc? asyncFunc,
  })  : _isAsync = isAsync,
        _source = source,
        _syncFunc = syncFunc,
        _asyncFunc = asyncFunc;

  Disposable.sync(T? source, _VoidFunc func)
      : this._(
          source: source,
          syncFunc: func,
        );

  Disposable.async(T? source, _AsyncVoidFunc func)
      : this._(
          isAsync: true,
          source: source,
          asyncFunc: func,
        );

  Future<void> _asyncDispose() async {
    if (_isDisposing || _isDisposed) return;

    _isDisposing = true;
    try {
      await _asyncFunc!();
      _isDisposed = true;
    } finally {
      _isDisposing = false;
    }
  }

  void _syncDispose() {
    if (!_isDisposed) {
      _syncFunc!();
      _isDisposed = true;
    }
  }

  FutureOr<void> dispose() async {
    if (_isAsync) {
      await _asyncDispose();
    } else {
      _syncDispose();
    }
  }

  void throwIfNotAvailable([String? info]) {
    if (isDisposing) {
      throw DisposeException.disposing(this, info);
    }
    if (isDisposed) {
      throw DisposeException.disposed(this, info);
    }
  }

  @override
  String toString() {
    String? state;
    if (isDisposing) {
      state = 'disposing';
    }
    if (isDisposed) {
      state = 'disposed';
    }

    final a = <String>[
      if (_source != null) 'source: $_source',
      if (state != null) 'state: $state',
    ];
    return '$runtimeType' + (a.isEmpty ? '' : ' (' + a.join(', ') + ')');
  }

  static DisposableBag createSyncBag() => _SyncDisposableBag._();
  static DisposableBag createAsyncBag() => _AsyncDisposableBag._();
}
