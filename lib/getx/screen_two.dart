import 'package:bookish/getX/counter_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScreenTwo extends GetView<CounterController> {
  final CounterController _controller = Get.put(CounterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Screen two"),
      ),
      body: Center(
        child: Column(
          children: [
            Obx(() => Text(_controller.count.toString())), // To observe
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blueGrey,
              ),
              onPressed: () {

              },
              child: Text(
                "+",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),

            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blueGrey,
              ),
              onPressed: () {
                Get.delete<CounterController>();
                Get.back();
              },
              child: Text(
                "Go back",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}
