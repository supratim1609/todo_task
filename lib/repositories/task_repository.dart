import '../models/task_model.dart';
import '../services/hive_service.dart';

class TaskRepository {
  final HiveService _hiveService;

  TaskRepository(this._hiveService);

  Stream<List<TaskModel>> get tasksStream => _hiveService.tasksStream;

  Future<void> initialize() async {
    await _hiveService.initialize();
  }

  Future<void> addTask(TaskModel task) async {
    try {
      await _hiveService.addTask(task);
    } catch (e) {
      throw Exception('Failed to add task: ${e.toString()}');
    }
  }

  Future<void> updateTask(TaskModel task) async {
    try {
      final updatedTask = task.copyWith(updatedAt: DateTime.now());
      await _hiveService.updateTask(updatedTask);
    } catch (e) {
      throw Exception('Failed to update task: ${e.toString()}');
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _hiveService.deleteTask(taskId);
    } catch (e) {
      throw Exception('Failed to delete task: ${e.toString()}');
    }
  }

  Future<TaskModel?> getTask(String taskId) async {
    try {
      return await _hiveService.getTask(taskId);
    } catch (e) {
      throw Exception('Failed to get task: ${e.toString()}');
    }
  }

  List<TaskModel> getTasks({
    int page = 0,
    String? userId,
    bool? isCompleted,
  }) {
    try {
      return _hiveService.getTasks(
        page: page,
        userId: userId,
        isCompleted: isCompleted,
      );
    } catch (e) {
      throw Exception('Failed to get tasks: ${e.toString()}');
    }
  }

  Future<List<TaskModel>> searchTasks(String query, String userId) async {
    try {
      return await _hiveService.searchTasks(query, userId);
    } catch (e) {
      throw Exception('Failed to search tasks: ${e.toString()}');
    }
  }

  int getTaskCount({String? userId, bool? isCompleted}) {
    try {
      return _hiveService.getTaskCount(
        userId: userId,
        isCompleted: isCompleted,
      );
    } catch (e) {
      return 0;
    }
  }

  Future<void> toggleTaskCompletion(TaskModel task) async {
    try {
      final updatedTask = task.copyWith(
        isCompleted: !task.isCompleted,
        updatedAt: DateTime.now(),
      );
      await _hiveService.updateTask(updatedTask);
    } catch (e) {
      throw Exception('Failed to toggle task: ${e.toString()}');
    }
  }
}
