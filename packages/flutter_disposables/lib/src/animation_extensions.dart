import 'package:flutter/animation.dart';

import 'package:disposables/disposables.dart';

extension AnimationEagerListenerMixinExtension on AnimationEagerListenerMixin {
  SyncDisposable asDisposable() => Disposable.value(this, dispose);

  AnimationEagerListenerMixin disposeOn(DisposableBag bag) {
    bag.add(asDisposable());
    return this;
  }

  AnimationEagerListenerMixin disposeBy(DisposableBagMixinBase m) {
    m.autoDispose(asDisposable());
    return this;
  }
}
