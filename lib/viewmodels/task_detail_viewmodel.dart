import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task_model.dart';
import '../repositories/task_repository.dart';
import '../repositories/share_repository.dart';
import '../providers/task_provider.dart';
import '../providers/share_provider.dart';

class TaskDetailState {
  final TaskModel? task;
  final bool isLoading;
  final String? error;
  final bool isSaving;

  TaskDetailState({
    this.task,
    this.isLoading = false,
    this.error,
    this.isSaving = false,
  });

  TaskDetailState copyWith({
    TaskModel? task,
    bool? isLoading,
    String? error,
    bool? isSaving,
  }) {
    return TaskDetailState(
      task: task ?? this.task,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

class TaskDetailViewModel extends StateNotifier<TaskDetailState> {
  final TaskRepository _taskRepository;
  final ShareRepository _shareRepository;

  TaskDetailViewModel(this._taskRepository, this._shareRepository)
      : super(TaskDetailState());

  Future<void> loadTask(String taskId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final task = await _taskRepository.getTask(taskId);
      state = state.copyWith(task: task, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> updateTask(String title, String description) async {
    if (state.task == null) return;

    state = state.copyWith(isSaving: true, error: null);

    try {
      final updatedTask = state.task!.copyWith(
        title: title,
        description: description,
        updatedAt: DateTime.now(),
      );

      await _taskRepository.updateTask(updatedTask);
      state = state.copyWith(task: updatedTask, isSaving: false);
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> shareViaEmail() async {
    if (state.task == null) return;

    try {
      await _shareRepository.shareViaEmail(state.task!);
    } catch (e) {
      state = state.copyWith(
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> shareViaLink() async {
    if (state.task == null) return;

    try {
      await _shareRepository.shareViaLink(state.task!);
    } catch (e) {
      state = state.copyWith(
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  String getShareLink() {
    if (state.task == null) return '';
    return _shareRepository.generateShareLink(state.task!);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final taskDetailViewModelProvider =
    StateNotifierProvider.family<TaskDetailViewModel, TaskDetailState, String>(
  (ref, taskId) {
    final taskRepository = ref.watch(taskRepositoryProvider);
    final shareRepository = ref.watch(shareRepositoryProvider);
    final viewModel = TaskDetailViewModel(taskRepository, shareRepository);
    viewModel.loadTask(taskId);
    return viewModel;
  },
);
