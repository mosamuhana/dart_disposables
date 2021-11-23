part of disposables;

abstract class DisposableMixin {
  bool get isDisposing;
  void dispose();
  void autoDispose(Disposable disposable);
  //void autoDisposeCallback(FutureOr<void> Function() callback);
}
