import 'package:flutter/painting.dart';

import 'package:disposables/disposables.dart';

extension BoxPainterExtension on BoxPainter {
  SyncDisposable asDisposable() => Disposable.value(this, dispose);

  BoxPainter disposeOn(DisposableBag bag) {
    bag.add(asDisposable());
    return this;
  }

  BoxPainter disposeBy(DisposableBagMixinBase m) {
    m.autoDispose(asDisposable());
    return this;
  }
}

extension DecorationImagePainterExtension on DecorationImagePainter {
  SyncDisposable asDisposable() => Disposable.value(this, dispose);

  DecorationImagePainter disposeOn(DisposableBag bag) {
    bag.add(asDisposable());
    return this;
  }

  DecorationImagePainter disposeBy(DisposableBagMixinBase m) {
    m.autoDispose(asDisposable());
    return this;
  }
}

extension ImageInfoExtension on ImageInfo {
  SyncDisposable asDisposable() => Disposable.value(this, dispose);

  ImageInfo disposeOn(DisposableBag bag) {
    bag.add(asDisposable());
    return this;
  }

  ImageInfo disposeBy(DisposableBagMixinBase m) {
    m.autoDispose(asDisposable());
    return this;
  }
}

extension ImageStreamCompleterHandleExtension on ImageStreamCompleterHandle {
  SyncDisposable asDisposable() => Disposable.value(this, dispose);

  ImageStreamCompleterHandle disposeOn(DisposableBag bag) {
    bag.add(asDisposable());
    return this;
  }

  ImageStreamCompleterHandle disposeBy(DisposableBagMixinBase m) {
    m.autoDispose(asDisposable());
    return this;
  }
}
