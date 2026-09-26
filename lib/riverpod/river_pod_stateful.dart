import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final ageProvider = StateProvider<String>((ref) => "Shubham");

class RiverPodStateful extends ConsumerWidget {
  const RiverPodStateful({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final age = ref.watch(ageProvider);
    return Scaffold(
        appBar: AppBar(
          title: Text("RiverPod"),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {
                final age = ref.watch(ageProvider);
                return Text(age);
              }),
              SizedBox(height: 24.h,),
              ElevatedButton(
                  onPressed: () {
                    ref.read(ageProvider.notifier).state = "Shubham Pandey";
                  },
                  child: Text( "Change")
              )
            ]
        ));
  }
}

