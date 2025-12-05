import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/task_model.dart';
import '../repositories/task_repository.dart';
import '../providers/task_provider.dart';
import '../providers/auth_provider.dart';

class TaskListState {
  final List<TaskModel> tasks;
  final bool isLoading;
  final String? error;
  final int currentPage;
  final bool hasMore;
  final bool? filterCompleted;

  TaskListState({
    this.tasks = const [],
    this.isLoading = false,
    this.error,
    this.currentPage = 0,
    this.hasMore = true,
    this.filterCompleted,
  });

  TaskListState copyWith({
    List<TaskModel>? tasks,
    bool? isLoading,
    String? error,
    int? currentPage,
    bool? hasMore,
    bool? filterCompleted,
  }) {
    return TaskListState(
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      filterCompleted: filterCompleted ?? this.filterCompleted,
    );
  }
}

class TaskListViewModel extends StateNotifier<TaskListState> {
  final TaskRepository _taskRepository;
  final String _userId;

  TaskListViewModel(this._taskRepository, String? userId)
      : _userId = userId ?? 'default_user',
        super(TaskListState()) {
    loadTasks();
  }

  Future<void> loadTasks({bool refresh = false}) async {
    if (refresh) {
      state = TaskListState(filterCompleted: state.filterCompleted);
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final tasks = _taskRepository.getTasks(
        page: refresh ? 0 : state.currentPage,
        userId: _userId,
        isCompleted: state.filterCompleted,
      );

      if (refresh) {
        state = state.copyWith(
          tasks: tasks,
          isLoading: false,
          currentPage: 0,
          hasMore: tasks.length >= 20,
        );
      } else {
        state = state.copyWith(
          tasks: [...state.tasks, ...tasks],
          isLoading: false,
          hasMore: tasks.length >= 20,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(currentPage: state.currentPage + 1);
    await loadTasks();
  }

  Future<void> addTask(String title, String description) async {
    try {
      final task = TaskModel(
        id: const Uuid().v4(),
        title: title,
        description: description,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        ownerId: _userId,
      );

      await _taskRepository.addTask(task);
      await loadTasks(refresh: true);
    } catch (e) {
      state = state.copyWith(
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> toggleTask(TaskModel task) async {
    try {
      await _taskRepository.toggleTaskCompletion(task);
    } catch (e) {
      state = state.copyWith(
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _taskRepository.deleteTask(taskId);
      await loadTasks(refresh: true);
    } catch (e) {
      state = state.copyWith(
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  void setFilter(bool? isCompleted) {
    state = state.copyWith(filterCompleted: isCompleted);
    loadTasks(refresh: true);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final taskListViewModelProvider =
    StateNotifierProvider<TaskListViewModel, TaskListState>((ref) {
  final taskRepository = ref.watch(taskRepositoryProvider);
  final currentUser = ref.watch(currentUserProvider);
  return TaskListViewModel(taskRepository, currentUser?.uid);
});
