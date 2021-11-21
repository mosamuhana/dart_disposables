import 'package:flutter/foundation.dart';

import 'package:disposables/disposables.dart';

extension ListenableExtension on Listenable {
  SyncCallbackDisposable addDisposableListener(VoidCallback callback) {
    addListener(callback);
    return Disposable.callback(() => removeListener(callback));
  }
}

extension ValueNotifierExtension<T> on ValueNotifier<T> {
  SyncDisposable asDisposable() => Disposable.value(this, dispose);

  ValueNotifier<T> disposeOn(DisposableBag bag) {
    bag.add(asDisposable());
    return this;
  }

  ValueNotifier<T> disposeBy(DisposableBagMixinBase m) {
    m.autoDispose(asDisposable());
    return this;
  }
}

extension ChangeNotifierExtension on ChangeNotifier {
  SyncDisposable asDisposable() => Disposable.value(this, dispose);

  ChangeNotifier disposeOn(DisposableBag bag) {
    bag.add(asDisposable());
    return this;
  }

  ChangeNotifier disposeBy(DisposableBagMixinBase m) {
    m.autoDispose(asDisposable());
    return this;
  }
}
