import 'dart:async';

import 'disposable.dart';
import 'exceptions.dart';

abstract class DisposableBag extends Iterable<Disposable> {
  final _disposables = <Disposable>[];

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

  //void addCallback(void Function() callback);

  static SyncDisposableBag sync() => SyncDisposableBag._();
  static AsyncDisposableBag async() => AsyncDisposableBag._();
}

class AsyncDisposableBag extends DisposableBag implements AsyncDisposable {
  late final AsyncCallbackDisposable _disposable;

  AsyncDisposableBag._() {
    _disposable = Disposable.asyncCallback(_disposeInternal);
  }

  @override
  bool get isAsync => true;

  @override
  bool get isDisposing => _disposable.isDisposing;

  @override
  bool get isDisposed => _disposable.isDisposed;

  @override
  void throwIfNotAvailable([String? target]) => _disposable.throwIfNotAvailable(target);

  //@override
  //void addCallback(FutureOr<void> Function() callback) => add(Disposable.asyncCallback(callback));

  @override
  Future<void> dispose() => _disposable.dispose();

  Future<void> _disposeInternal() async {
    final Map<Disposable, Object> map = {};
    for (final d in _disposables) {
      try {
        if (d is AsyncDisposable) {
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

class SyncDisposableBag extends DisposableBag implements SyncDisposable {
  late final SyncCallbackDisposable _disposable;

  SyncDisposableBag._() {
    _disposable = Disposable.callback(_disposeInternal);
  }

  @override
  bool get isAsync => false;

  @override
  bool get isDisposed => _disposable.isDisposed;

  @override
  void throwIfNotAvailable([String? target]) => _disposable.throwIfNotAvailable(target);

  //@override
  //void addCallback(void Function() callback) => add(Disposable.callback(callback));

  @override
  void dispose() => _disposable.dispose();

  void _disposeInternal() {
    final Map<Disposable, Object> map = {};
    for (final disposable in _disposables) {
      try {
        disposable.dispose();
      } on Object catch (e) {
        map[disposable] = e;
      }
    }

    _disposables.clear();

    if (map.isNotEmpty) {
      throw DisposeException.aggregate(map);
    }
  }
}

abstract class DisposableBagMixinBase {
  bool get isDisposing;
  void dispose();
  void autoDispose(Disposable disposable);
  void autoDisposeCallback(FutureOr<void> Function() callback);
}
