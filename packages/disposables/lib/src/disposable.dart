import 'dart:async';

import 'exceptions.dart';

abstract class Disposable {
  bool get isDisposed;
  //bool get isDisposing;
  void dispose();
  //bool get isAsync => this is AsyncDisposable;

  bool get isAsync;

  void throwIfNotAvailable([String? target]) {
    if (isDisposed) {
      throw DisposeException.disposed(this, target);
    }
  }

  static Future<R> usingValue<T, R>(AsyncValueDisposable<T> disposable, _Body<T, R> body) =>
      using(disposable, (_) => body(disposable.value));

  static Future<R> using<T extends Disposable, R>(T value, _Body<T, R> body) async {
    if (value is SyncDisposable) {
      value.throwIfNotAvailable();
      try {
        return await body(value);
      } finally {
        value.dispose();
      }
    } else if (value is AsyncDisposable) {
      value.throwIfNotAvailable();
      try {
        return await body(value);
      } finally {
        await value.dispose();
      }
    } else {
      throw DisposeException.unknown(value);
    }
  }

  static SyncCallbackDisposable callback(_VoidCallback callback) =>
      SyncCallbackDisposable._(callback);

  static AsyncCallbackDisposable asyncCallback(_AsyncVoidCallback callback) =>
      AsyncCallbackDisposable._(callback);

  static SyncValueDisposable<T> value<T>(T value, _VoidCallback callback) =>
      SyncValueDisposable<T>._(value, callback);

  static AsyncValueDisposable<T> asyncValue<T>(T value, _AsyncVoidCallback callback) =>
      AsyncValueDisposable<T>._(value, callback);
}

abstract class AsyncDisposable extends Disposable {
  bool _isDisposing = false;
  bool _isDisposed = false;

  @override
  bool get isAsync => true;

  bool get isDisposing => _isDisposing;

  @override
  bool get isDisposed => _isDisposed;

  @override
  Future<void> dispose();

  @override
  String toString() =>
      '$runtimeType' + (isDisposing ? ' (disposing)' : (isDisposed ? ' (disposed)' : ''));

  @override
  void throwIfNotAvailable([String? target]) {
    if (isDisposing) {
      throw DisposeException.disposing(this, target);
    }
    if (isDisposed) {
      throw DisposeException.disposed(this, target);
    }
  }
}

abstract class SyncDisposable extends Disposable {
  bool _isDisposed = false;

  @override
  bool get isAsync => false;

  @override
  bool get isDisposed => _isDisposed;

  @override
  void dispose();

  @override
  String toString() => '$runtimeType' + (isDisposed ? ' (disposed)' : '');
}

class AsyncCallbackDisposable extends AsyncDisposable {
  final _AsyncVoidCallback _callback;

  AsyncCallbackDisposable._(this._callback);

  @override
  Future<void> dispose() async {
    if (_isDisposed || _isDisposing) return;

    _isDisposing = true;
    try {
      await _callback();
      _isDisposed = true;
    } finally {
      _isDisposing = false;
    }
  }
}

class AsyncValueDisposable<T> extends AsyncCallbackDisposable {
  final T value;

  AsyncValueDisposable._(this.value, _AsyncVoidCallback _callback) : super._(_callback);

  @override
  String toString() {
    var text = '$runtimeType ($value';
    if (isDisposing) {
      text += ', disposing';
    }
    if (isDisposed) {
      text += ', disposed';
    }
    text += ')';
    return text;
  }
}

class SyncCallbackDisposable extends SyncDisposable {
  final _VoidCallback _callback;

  SyncCallbackDisposable._(this._callback);

  @override
  void dispose() {
    if (!_isDisposed) {
      _callback();
      _isDisposed = true;
    }
  }
}

class SyncValueDisposable<T> extends SyncCallbackDisposable {
  final T value;

  SyncValueDisposable._(this.value, _VoidCallback _callback) : super._(_callback);

  @override
  String toString() => '$runtimeType ($value' + (isDisposed ? ', disposed)' : ')');
}

typedef _Body<T, R> = FutureOr<R> Function(T);
typedef _VoidCallback = void Function();
typedef _AsyncVoidCallback = FutureOr<void> Function();
