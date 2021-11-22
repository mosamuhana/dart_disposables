import 'dart:async';

import 'disposable_bag.dart';
import 'disposable.dart';

typedef _VoidFunc = void Function();
typedef _AsyncVoidFunc = Future<void> Function();

extension DisposableBagExtension on DisposableBag {
  DisposableBag addCallback(FutureOr<void> Function() callback) {
    if (callback is _VoidFunc) {
      add(Disposable.callback(callback));
    } else if (callback is _AsyncVoidFunc) {
      add(Disposable.asyncCallback(callback));
    }
    return this;
  }
}

extension SyncDisposableExtension on SyncDisposable {
  AsyncDisposable asAsync() => Disposable.asyncCallback(() async => dispose());
}

extension DisposableExtension on Disposable {
  Disposable disposeOn(DisposableBag bag) {
    bag.add(this);
    return this;
  }

  Disposable disposeBy(DisposableBagMixinBase m) {
    m.autoDispose(this);
    return this;
  }
}

extension StreamSubscriptionExtension<T> on StreamSubscription<T> {
  AsyncDisposable asDisposable() => Disposable.asyncValue(this, cancel);

  StreamSubscription<T> disposeOn(DisposableBag bag) {
    bag.add(asDisposable());
    return this;
  }

  StreamSubscription<T> disposeBy(DisposableBagMixinBase m) {
    m.autoDispose(asDisposable());
    return this;
  }
}

extension StreamControllerExtension<T> on StreamController<T> {
  AsyncDisposable asDisposable() => Disposable.asyncValue(this, close);

  StreamController<T> disposeOn(AsyncDisposableBag bag) {
    bag.add(asDisposable());
    return this;
  }

  StreamController<T> disposeBy(DisposableBagMixinBase m) {
    m.autoDispose(asDisposable());
    return this;
  }
}

extension TimerExtension on Timer {
  SyncDisposable asDisposable() => Disposable.value(this, cancel);

  Timer disposeOn(DisposableBag bag) {
    bag.add(asDisposable());
    return this;
  }

  Timer disposeBy(DisposableBagMixinBase m) {
    m.autoDispose(asDisposable());
    return this;
  }
}

extension SinkExtension<T> on Sink<T> {
  SyncDisposable asDisposable() => Disposable.value(this, close);

  Sink<T> disposeOn(DisposableBag bag) {
    bag.add(asDisposable());
    return this;
  }

  Sink<T> disposeBy(DisposableBagMixinBase m) {
    m.autoDispose(asDisposable());
    return this;
  }
}
