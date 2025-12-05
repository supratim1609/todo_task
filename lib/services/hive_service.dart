import 'dart:async';
import 'package:hive/hive.dart';
import '../models/task_model.dart';

class HiveService {
  static const String _taskBoxName = 'tasks';
  static const int _pageSize = 20;

  Box<TaskModel>? _taskBox;

  final StreamController<List<TaskModel>> _tasksController =
      StreamController<List<TaskModel>>.broadcast();

  Stream<List<TaskModel>> get tasksStream => _tasksController.stream;

  Future<void> initialize() async {
    _taskBox = await Hive.openBox<TaskModel>(_taskBoxName);
    _notifyListeners();
  }

  void _notifyListeners() {
    if (_taskBox != null) {
      final tasks = _taskBox!.values.toList();
      tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      _tasksController.add(tasks);
    }
  }

  Future<void> addTask(TaskModel task) async {
    if (_taskBox == null) throw Exception('Hive not initialized');

    await _taskBox!.put(task.id, task);
    _notifyListeners();
  }

  Future<void> updateTask(TaskModel task) async {
    if (_taskBox == null) throw Exception('Hive not initialized');

    await _taskBox!.put(task.id, task);
    _notifyListeners();
  }

  Future<void> deleteTask(String taskId) async {
    if (_taskBox == null) throw Exception('Hive not initialized');

    await _taskBox!.delete(taskId);
    _notifyListeners();
  }

  Future<TaskModel?> getTask(String taskId) async {
    if (_taskBox == null) throw Exception('Hive not initialized');

    return _taskBox!.get(taskId);
  }

  List<TaskModel> getTasks({
    int page = 0,
    String? userId,
    bool? isCompleted,
  }) {
    if (_taskBox == null) return [];

    var tasks = _taskBox!.values.toList();

    if (userId != null) {
      tasks = tasks.where((task) {
        return task.ownerId == userId || task.sharedWith.contains(userId);
      }).toList();
    }

    if (isCompleted != null) {
      tasks = tasks.where((task) => task.isCompleted == isCompleted).toList();
    }

    tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final startIndex = page * _pageSize;
    final endIndex = (startIndex + _pageSize).clamp(0, tasks.length);

    if (startIndex >= tasks.length) {
      return [];
    }

    return tasks.sublist(startIndex, endIndex);
  }

  Future<List<TaskModel>> searchTasks(String query, String userId) async {
    if (_taskBox == null) return [];

    final tasks = _taskBox!.values.where((task) {
      final matchesUser =
          task.ownerId == userId || task.sharedWith.contains(userId);
      final matchesQuery = task.title.toLowerCase().contains(query.toLowerCase()) ||
          task.description.toLowerCase().contains(query.toLowerCase());

      return matchesUser && matchesQuery;
    }).toList();

    tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return tasks;
  }

  int getTaskCount({String? userId, bool? isCompleted}) {
    if (_taskBox == null) return 0;

    var tasks = _taskBox!.values.toList();

    if (userId != null) {
      tasks = tasks.where((task) {
        return task.ownerId == userId || task.sharedWith.contains(userId);
      }).toList();
    }

    if (isCompleted != null) {
      tasks = tasks.where((task) => task.isCompleted == isCompleted).toList();
    }

    return tasks.length;
  }

  Future<void> clearAllTasks() async {
    if (_taskBox == null) throw Exception('Hive not initialized');

    await _taskBox!.clear();
    _notifyListeners();
  }

  void dispose() {
    _tasksController.close();
  }
}
