import 'dart:async';

import 'package:flutter/material.dart';
import 'package:disposables/disposables.dart';

mixin DisposableBagStateMixin<T extends StatefulWidget> on State<T>
    implements DisposableBagMixinBase {
  final SyncDisposableBag _syncBag = DisposableBag.sync();
  final SyncDisposableBag _syncLateBag = DisposableBag.sync();

  final AsyncDisposableBag _asyncBag = DisposableBag.async();
  final AsyncDisposableBag _asyncLateBag = DisposableBag.async();

  bool _isDisposing = false;

  @override
  bool get isDisposing => _isDisposing;

  @mustCallSuper
  @override
  void dispose() async {
    print('DisposableBagStateMixin dispose()');
    _isDisposing = true;
    try {
      _syncBag.dispose();
      _syncLateBag.dispose();
    } catch (_) {
      _isDisposing = false;
      rethrow;
    } finally {
      super.dispose();
    }

    try {
      await _asyncBag.dispose();
      await _asyncLateBag.dispose();
    } finally {
      _isDisposing = false;
    }
  }

  @override
  void autoDispose(Disposable disposable) {
    print('autoDispose(Disposable: ${disposable.runtimeType})');
    if (disposable is SyncDisposable) {
      if (disposable is SyncValueDisposable<ChangeNotifier>) {
        _syncLateBag.add(disposable);
      } else {
        _syncBag.add(disposable);
      }
    } else if (disposable is AsyncDisposable) {
      if (disposable is AsyncValueDisposable<ChangeNotifier>) {
        _asyncLateBag.add(disposable);
      } else {
        _asyncBag.add(disposable);
      }
    }
  }

  @override
  void autoDisposeCallback(FutureOr<void> Function() callback) {
    if (callback is _AsyncVoidFunc) {
      autoDispose(Disposable.asyncCallback(callback));
    } else if (callback is _VoidFunc) {
      autoDispose(Disposable.callback(callback));
    }
  }
}

typedef _VoidFunc = void Function();
typedef _AsyncVoidFunc = Future<void> Function();
