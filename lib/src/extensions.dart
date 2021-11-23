part of disposables;

extension VoidFuncExtension on _VoidFunc {
  Disposable<dynamic> get disposable => Disposable.create(this);
}

extension AsyncVoidFuncExtension on _AsyncVoidFunc {
  Disposable<dynamic> get disposable => Disposable.create(this);
}

extension StreamSubscriptionExtension<T> on StreamSubscription<T> {
  Disposable<StreamSubscription<T>> get disposable => Disposable.create(cancel, this);

  StreamSubscription<T> disposeBy(dynamic disposer) => this..disposable.disposeBy(disposer);
}

extension StreamControllerExtension<T> on StreamController<T> {
  Disposable<StreamController<T>> get disposable => Disposable.create(close, this);

  StreamController<T> disposeBy(dynamic disposer) => this..disposable.disposeBy(disposer);
}

extension TimerExtension on Timer {
  Disposable<Timer> get disposable => Disposable.create(cancel, this);

  Timer disposeBy(dynamic disposer) => this..disposable.disposeBy(disposer);
}

extension SinkExtension<T> on Sink<T> {
  Disposable<Sink<T>> get disposable => Disposable.create(close, this);

  Sink<T> disposeBy(dynamic disposer) => this..disposable.disposeBy(disposer);
}
