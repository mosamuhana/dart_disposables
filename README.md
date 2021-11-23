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
// create DisposableBag which is responsible for disposing
// all disposables added to it when DisposableBag.dispose() called
final bag = DisposableBag();

// You can convert StreamSubscription, StreamController, Timer and so on.
final streamDisposable = stream.listen((v) => {}).disposable;
final timerDisposable = timer.disposable;
Timer.periodic(const Duration(seconds: 1), (t) => print('timer.tick: ${t.tick}'))
        .disposeBy(bag);
// or add it to bag
bag.add(streamDisposable);
bag.add(timerDisposable);

// later at last to free resources added to the bag use
await asyncBag.dispose();
```

3. Dispose them!

```dart
// Without DisposableBag
await streamDisposable.dispose();
timerDisposable.dispose();

// With DisposableBag
await bag.dispose();
```

### For Flutter
flutter_disposables adds extension methods and DisposableStateMixin class.

#### Listenable
Listenable is a base class of ChangeNotifier which is used by TextEditingController, FocusNode, ValueNotifier and many other flutter classes.

Use `addDisposableListener` to adds a listener function and returns disposable instance.
```dart
final bag = DisposableBag();
final controller = TextEditingController().disposeBy(bag);
```

#### DisposableStateMixin
This mixin uses `DisposableBag` to dispose it when the widget's state is being disposed.

```dart
class ExampleWidget extends StatefulWidget {
  ExampleWidget({Key? key}) : super(key: key);

  @override
  _ExampleWidgetState createState() => _ExampleWidgetState();
}

class _ExampleWidgetState extends State<ExampleWidget> with DisposableStateMixin {
  late final TextEditingController controller;
  String currentTime = '';

  @override
  void initState() {
    controller = TextEditingController().disposeBy(this);
    Timer.periodic(const Duration(seconds: 1), (t) {
      print('timer.tick: ${t.tick}');
      var now = DateTime.now();
      setState(() {
        currentTime = '${now.hour}:${now.minute}:${now.second}';
      });
    }).disposeBy(this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Disbosable Example 1')),
      body: Center(
        child: Column(
          children: [
            Text('Current: $currentTime'),
            const SizedBox(height: 20),
            TextField(
              controller: controller,
            ),
          ],
        ),
      ),
    );
  }
}
```
