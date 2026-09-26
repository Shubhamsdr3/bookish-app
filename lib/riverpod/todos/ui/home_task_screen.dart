import 'dart:math';

import 'package:bookish_module/riverpod/todos/data/Task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../task_list_provider.dart';

class HomeTaskScreen extends ConsumerWidget {
  const HomeTaskScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(taskProvider);

    return Scaffold(
        appBar: AppBar(
          title: Text("Tasks"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            ref.read(taskProvider.notifier).addTask(Task(
                id: generateUniqueId(),
                title: "This is task",
                description: "This is task description",
                createdAt: DateTime.now().millisecond));
          },
          child: Icon(Icons.add),
        ),
        body: items.isEmpty
            ? Center(child: Text("No data available"))
            : ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, idx) {
                  final task = items[idx];
                  return ListTile(
                    title: Text(task.title),
                    subtitle: Text(task.description),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              ref.read(taskProvider.notifier).deleteTask(task);
                            },
                            icon: Icon(Icons.delete))
                      ],
                    ),
                  );
                }));
  }

  String generateUniqueId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(100000);
    return '$timestamp-$random';
  }
}
