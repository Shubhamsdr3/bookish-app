import 'package:bookish_module/examples/example_controller.dart';
import 'package:bookish_module/widgets/dashed_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExampleHomeScreen extends GetView<ExampleController> {
  const ExampleHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Example"),
      ),
      body: ListView(
        children: [DashedBorder()],
      ),
    );
  }
}
