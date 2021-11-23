part of disposables;

class DisposableBag extends Iterable<Disposable> {
  final _list = <Disposable>[];
  late final Disposable _disposable;

  DisposableBag() {
    _disposable = Disposable.create(_asyncDisposeFunc);
  }

  Future<void> dispose() async => await _disposable.dispose();

  @override
  int get length => _list.length;

  @override
  Iterator<Disposable> get iterator => _list.iterator;

  void add(Disposable disposable) {
    disposable.throwIfNotAvailable();
    throwIfNotAvailable('add');
    _list.add(disposable);
  }

  void remove(Disposable disposable) {
    throwIfNotAvailable('remove');
    _list.remove(disposable);
  }

  void removeAt(int index) {
    throwIfNotAvailable('removeAt');
    _list.removeAt(index);
  }

  void clear() {
    throwIfNotAvailable('clear');
    _list.clear();
  }

  void throwIfNotAvailable([String? target]) => _disposable.throwIfNotAvailable(target);

  Future<void> _asyncDisposeFunc() async {
    final Map<Disposable, Object> map = {};
    for (final d in _list) {
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
    _list.clear();
    if (map.isNotEmpty) {
      throw DisposeException.aggregate(map);
    }
  }

  DisposableBag addCallback(FutureOr<void> Function() func) {
    if (func is _VoidFunc) {
      Disposable.create(func).disposeBy(this);
    } else if (func is _AsyncVoidFunc) {
      Disposable.create(func).disposeBy(this);
    } else {
      throw DisposeException.custom('Argument func must be of return type void or Future<void>');
    }
    return this;
  }
}
