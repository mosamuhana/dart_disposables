import 'dart:async';

import 'disposable_bag.dart';
import 'disposable.dart';
import 'exceptions.dart';

extension GlobalExtension<T extends Object> on T {
  Disposable asDisposable() {
    final Function fn = _getFunc(this);
    if (fn is _FutureAnyFunc) {
      return Disposable.asyncValue(this, () async => fn());
    } else if (fn is _FutureVoidFunc) {
      return Disposable.asyncValue(this, () async => fn());
    } else if (fn is _AnyFunc) {
      return Disposable.value(this, () => fn());
    } else if (fn is _VoidFunc) {
      return Disposable.value(this, fn);
    } else {
      throw DisposeException.custom('Failed to create Disposable');
    }
  }

  T disposeOn(DisposableBag bag) {
    bag.add(asDisposable());
    return this;
  }

  T disposeBy(DisposableBagMixinBase m) {
    m.autoDispose(asDisposable());
    return this;
  }
}

Function _getFunc(dynamic obj) {
  print('runtimeType: "${obj.runtimeType}"');
  print('obj.cancel: ${obj?.cancel}');
  print('obj.cancel: ${obj?.dispose}');
  if (obj?.cancel != null && obj.cancel is Function) {
    print('has cancel');
    return obj.cancel;
  }
  if (obj?.dispose != null && obj?.dispose is Function) {
    print('has dispose');
    return obj.dispose;
  }
  throw DisposeException.custom('Target object not have dispose or cancel');
}

typedef _VoidFunc = void Function();
typedef _AnyFunc<T> = T Function();
typedef _FutureVoidFunc = Future<void> Function();
typedef _FutureAnyFunc<T> = Future<T> Function();