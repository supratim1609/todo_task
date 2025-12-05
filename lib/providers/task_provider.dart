import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task_model.dart';
import '../repositories/task_repository.dart';
import '../services/hive_service.dart';

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  return TaskRepository(hiveService);
});

final tasksStreamProvider = StreamProvider<List<TaskModel>>((ref) {
  final taskRepository = ref.watch(taskRepositoryProvider);
  return taskRepository.tasksStream;
});

final taskCountProvider = Provider.family<int, String?>((ref, userId) {
  final taskRepository = ref.watch(taskRepositoryProvider);
  return taskRepository.getTaskCount(userId: userId);
});

final pendingTaskCountProvider = Provider.family<int, String?>((ref, userId) {
  final taskRepository = ref.watch(taskRepositoryProvider);
  return taskRepository.getTaskCount(userId: userId, isCompleted: false);
});

final completedTaskCountProvider = Provider.family<int, String?>((ref, userId) {
  final taskRepository = ref.watch(taskRepositoryProvider);
  return taskRepository.getTaskCount(userId: userId, isCompleted: true);
});
