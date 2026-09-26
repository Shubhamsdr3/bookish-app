import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'data/Task.dart';

final familyProvider = StateProvider.family<String, String>((ref, name) {
  return "shubham" + name;
});



final taskProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  return TaskNotifier();
});


class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier() : super([]);

  void addTask(Task task) {
    state = [...state, task];
  }

  void deleteTask(Task task) {
    state.removeWhere((element) => element.id == task.id);
    state = state.toList();
  }
}