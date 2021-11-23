part of disposables;

extension DisposableBagExtension on DisposableBag {
  DisposableBag addCallback(FutureOr<void> Function() callback) {
    if (callback is _VoidFunc) {
      Disposable.sync(null as dynamic, callback).disposeBy(this);
    } else if (callback is _AsyncVoidFunc) {
      Disposable.async(null as dynamic, callback).disposeBy(this);
    }
    return this;
  }
}

extension StreamSubscriptionExtension<T> on StreamSubscription<T> {
  Disposable get disposable => Disposable.async(this, cancel);

  StreamSubscription<T> disposeBy(dynamic disposer) => this..disposable.disposeBy(disposer);
}

extension StreamControllerExtension<T> on StreamController<T> {
  Disposable get disposable => Disposable.async(this, close);

  StreamController<T> disposeBy(dynamic disposer) => this..disposable.disposeBy(disposer);
}

extension TimerExtension on Timer {
  Disposable get disposable => Disposable.sync(this, cancel);

  Timer disposeBy(dynamic disposer) => this..disposable.disposeBy(disposer);
}

extension SinkExtension<T> on Sink<T> {
  Disposable get disposable => Disposable.sync(this, close);

  Sink<T> disposeBy(dynamic disposer) => this..disposable.disposeBy(disposer);
}
