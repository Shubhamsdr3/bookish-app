import 'package:bookish/getx/safe_get.dart';
import 'package:bookish/getx/safe_get_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'counter_controller.dart';

class CounterPage extends SafeGetView<CounterController> {
  const CounterPage({Key? key}) : super(key: key);

  @override
  Widget buildWithController(BuildContext context, CounterController controller) {
    return Scaffold(
      appBar: AppBar(title: const Text('Safe Counter')),
      body: Center(
        child: Obx(() => Text(
          'Count: ${controller.count.value}',
          style: Theme.of(context).textTheme.headlineMedium,
        )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.increment,
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  Widget buildFallback(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Controller not found!'),
            ElevatedButton(
              onPressed: () {
                // Initialize controller
                SafeGet.findOrPut(() => CounterController());
                Get.forceAppUpdate();
              },
              child: const Text('Initialize'),
            ),
          ],
        ),
      ),
    );
  }
}
