import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_disposables/flutter_disposables.dart';

class Example1Page extends StatefulWidget {
  const Example1Page({Key? key}) : super(key: key);

  @override
  _Example1PageState createState() => _Example1PageState();
}

class _Example1PageState extends State<Example1Page> with DisposableBagStateMixin {
  //final controller = TextEditingController();
  late final TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController().disposeBy(this);
    Timer.periodic(const Duration(seconds: 1), (t) => print('timer.tick: ${t.tick}'))
        .disposeBy(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Disbosable Example 1')),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: controller,
            ),
          ],
        ),
      ),
    );
  }
}
