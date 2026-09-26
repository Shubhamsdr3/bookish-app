import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserState {
  final String name;
  final int age;

  UserState({
    required this.name,
    required this.age,
  });

  UserState copyWith({String? name, int? age}) {
    return UserState(name: name ?? this.name, age: age ?? this.age);
  }
}

final provider = StateProvider<UserState>((ref) => UserState(name: "Shubham", age: 26));

class SliderProvider extends ConsumerWidget {
  const SliderProvider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text("River pod"),
      ),
      body: Column(
        children: [
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final name = ref.watch(provider.select((state) => state.name));
              return Center(
                child: Text(name),
              );
            },
          ),
          SizedBox(height: 24.h),
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final age = ref.watch(provider.select((state) => state.age));
              return Center(
                child: Text(age.toString()),
              );
            },
          ),
        ],
      ),
    );
  }
}
