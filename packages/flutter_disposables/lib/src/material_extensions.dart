import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
import 'package:flutter/gestures.dart';
//import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

import 'package:disposables/disposables.dart';

extension WidgetsBindingExtension on WidgetsBinding {
  SyncDisposable addDisposableObserver<T extends WidgetsBinding>(WidgetsBindingObserver observer) {
    addObserver(observer);
    return Disposable.callback(() => removeObserver(observer));
  }
}

extension TabControllerExtension on TabController {
  SyncDisposable asDisposable() => Disposable.value(this, dispose);

  TabController disposeOn(DisposableBag bag) {
    bag.add(asDisposable());
    return this;
  }

  TabController disposeBy(DisposableBagMixinBase m) {
    m.autoDispose(asDisposable());
    return this;
  }
}

extension FocusNodeExtension on FocusNode {
  SyncDisposable asDisposable() => Disposable.value(this, dispose);

  FocusNode disposeOn(DisposableBag bag) {
    bag.add(asDisposable());
    return this;
  }

  FocusNode disposeBy(DisposableBagMixinBase m) {
    m.autoDispose(asDisposable());
    return this;
  }
}

extension ScrollControllerExtension on ScrollController {
  SyncDisposable asDisposable() => Disposable.value(this, dispose);

  ScrollController disposeOn(DisposableBag bag) {
    bag.add(asDisposable());
    return this;
  }

  ScrollController disposeBy(DisposableBagMixinBase m) {
    m.autoDispose(asDisposable());
    return this;
  }
}

extension TextEditingControllerExtension on TextEditingController {
  SyncDisposable asDisposable() => Disposable.value(this, dispose);

  TextEditingController disposeOn(DisposableBag bag) {
    bag.add(asDisposable());
    return this;
  }

  TextEditingController disposeBy(DisposableBagMixinBase m) {
    m.autoDispose(asDisposable());
    return this;
  }
}

extension DisposableBuildContextExtension on DisposableBuildContext {
  SyncDisposable asDisposable() => Disposable.value(this, dispose);

  DisposableBuildContext disposeOn(DisposableBag bag) {
    bag.add(asDisposable());
    return this;
  }

  DisposableBuildContext disposeBy(DisposableBagMixinBase m) {
    m.autoDispose(asDisposable());
    return this;
  }
}

extension GestureRecognizerExtension on GestureRecognizer {
  SyncDisposable asDisposable() => Disposable.value(this, dispose);

  GestureRecognizer disposeOn(DisposableBag bag) {
    bag.add(asDisposable());
    return this;
  }

  GestureRecognizer disposeBy(DisposableBagMixinBase m) {
    m.autoDispose(asDisposable());
    return this;
  }
}

extension RestorationBucketExtension on RestorationBucket {
  SyncDisposable asDisposable() => Disposable.value(this, dispose);

  RestorationBucket disposeOn(DisposableBag bag) {
    bag.add(asDisposable());
    return this;
  }

  RestorationBucket disposeBy(DisposableBagMixinBase m) {
    m.autoDispose(asDisposable());
    return this;
  }
}

extension ScrollActivityExtension on ScrollActivity {
  SyncDisposable asDisposable() => Disposable.value(this, dispose);

  ScrollActivity disposeOn(DisposableBag bag) {
    bag.add(asDisposable());
    return this;
  }

  ScrollActivity disposeBy(DisposableBagMixinBase m) {
    m.autoDispose(asDisposable());
    return this;
  }
}

extension ScrollDragControllerExtension on ScrollDragController {
  SyncDisposable asDisposable() => Disposable.value(this, dispose);

  ScrollDragController disposeOn(DisposableBag bag) {
    bag.add(asDisposable());
    return this;
  }

  ScrollDragController disposeBy(DisposableBagMixinBase m) {
    m.autoDispose(asDisposable());
    return this;
  }
}

extension SemanticsHandleExtension on SemanticsHandle {
  SyncDisposable asDisposable() => Disposable.value(this, dispose);

  SemanticsHandle disposeOn(DisposableBag bag) {
    bag.add(asDisposable());
    return this;
  }

  SemanticsHandle disposeBy(DisposableBagMixinBase m) {
    m.autoDispose(asDisposable());
    return this;
  }
}

extension TickerExtension on Ticker {
  SyncDisposable asDisposable() => Disposable.value(this, dispose);

  Ticker disposeOn(DisposableBag bag) {
    bag.add(asDisposable());
    return this;
  }

  Ticker disposeBy(DisposableBagMixinBase m) {
    m.autoDispose(asDisposable());
    return this;
  }
}


/*
extension StateExtension<T extends StatefulWidget> on State<T> {
  SyncDisposable asDisposable() => Disposable.value(this, dispose);

  State<T> disposeOn(DisposableBag bag) {
    bag.add(asDisposable());
    return this;
  }

  State<T> disposeBy(DisposableBagMixinBase m) {
    m.autoDispose(asDisposable());
    return this;
  }
}
*/
