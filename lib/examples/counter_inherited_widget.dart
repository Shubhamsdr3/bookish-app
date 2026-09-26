import 'package:flutter/cupertino.dart';

class MyInheritedWidget extends InheritedWidget {

  final int counter;

  MyInheritedWidget({required super.child, required this.counter});

  @override
  bool updateShouldNotify(covariant MyInheritedWidget oldWidget) => oldWidget.counter != counter;

  static MyInheritedWidget? of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<MyInheritedWidget>();
}