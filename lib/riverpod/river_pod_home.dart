import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final helloProvider = Provider<String>((ref) {
  return "Hello world";
});

class RiverPodHome extends ConsumerWidget {

  const RiverPodHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final helloWorld = ref.watch(helloProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Hello RiverPod"),

      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(helloWorld)
        ],
      ),
    );
  }
}
