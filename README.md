# Disposable

Disposable is responsible for auto disposing resources.

## Installation
Add dependencies to your pubspec.yaml

### Dart only
```yaml
dependencies:
  disposables:
```

### Flutter
```yaml
dependencies:
  flutter_disposables:
```

## How to Use

1. Import package

```dart
// For non Flutter project
import 'package:disposables/disposables.dart';
// OR (for Flutter)
import 'package:flutter_disposables/flutter_disposables.dart';
```

2. Convert instance to disposable

```dart
// You can convert StreamSubscription, StreamController, Timer and so on.
final streamDisposable = stream.listen((v) => {}).asDisposable();
final timerDisposable = timer.asDisposable();

// create SyncDisposableBag which is responsible for disposing
// all disposables add to it when DisposableBag.dispose() called
final syncBag = DisposableBag.sync();

syncBag.add(streamDisp);
syncBag.add(timerDisp);

// later at last to free resources added to the bag use
syncBag.dispose();
```

3. To dispose

```dart
final bag = DisposableBag();
bag.add(streamDisp);
bag.add(timerDisp);
```

Or you can add disposable directly
```dart
stream.listen((v) => {}).disposeWith(bag);
timer.disposeWith(bag);
```

4. Dispose them!

```dart
// Without DisposeBag
await streamDisp.dispose();
timerDisp.dispose();

// With DisposeBag
await bag.dispose();
```

### For Flutter
flutter_disposing adds Listenable extension methods and DisposableBagStateMixin class.

#### Listenable
Listenable is a base class of ChangeNotifier which is used by TextEditingController, FocusNode, ValueNotifier and many other flutter classes.

Use `addDisposableListener` to adds a listener function and returns disposable instance.
```dart
final controller = TextEditingController();
final disp = controller.addDisposableListener(() => print(controller.text));
```

#### DisposableBagStateMixin
This mixin adds `disposeBag` variable and dispose it when the widget's state is being disposed.

```dart
class ExampleWidget extends StatefulWidget {
  ExampleWidget({Key? key}) : super(key: key);

  @override
  _ExampleWidgetState createState() => _ExampleWidgetState();
}

class _ExampleWidgetState extends State<ExampleWidget>
    with DisposableBagStateMixin {
  final controller = TextEditingController();

  @override
  void initState() {
    autoDispose(Timer.periodic(Duration(seconds: 1), (t) => {}).asDisposable());
    autoDispose(controller.addDisposableListener(() => print(controller.text)));
    autoDispose(controller.asDisposable());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
    );
  }
}
```

### using
`using` is an utility method which will dispose disposable instance automatically after the callback execution is finished (like [C# using statement](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/keywords/using-statement)).

```dart
await using(someDisposable, (disposable) async {
  // do something...
});
assert(someDisposable.isDisposed, true);
```
