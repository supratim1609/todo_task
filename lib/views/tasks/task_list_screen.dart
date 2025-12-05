import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/widgets/error_view.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/task_list_viewmodel.dart';
import '../../providers/auth_provider.dart';
import 'widgets/task_list_item.dart';
import 'widgets/task_input_field.dart';
import 'task_detail_screen.dart';

class TaskListScreen extends ConsumerStatefulWidget {
  const TaskListScreen({super.key});

  @override
  ConsumerState<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends ConsumerState<TaskListScreen> {
  final _scrollController = ScrollController();
  bool? _filterCompleted;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(taskListViewModelProvider.notifier).loadMore();
    }
  }

  void _showFilterMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.borderRadiusLarge),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: AppDimensions.paddingMedium),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingMedium),
              Text('Filter Tasks', style: AppTextStyles.h3),
              const SizedBox(height: AppDimensions.paddingMedium),
              ListTile(
                leading: const Icon(Icons.list_alt),
                title: const Text('All Tasks'),
                trailing: _filterCompleted == null
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  setState(() => _filterCompleted = null);
                  ref.read(taskListViewModelProvider.notifier).setFilter(null);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.radio_button_unchecked),
                title: const Text('Pending'),
                trailing: _filterCompleted == false
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  setState(() => _filterCompleted = false);
                  ref.read(taskListViewModelProvider.notifier).setFilter(false);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.check_circle_outline),
                title: const Text('Completed'),
                trailing: _filterCompleted == true
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  setState(() => _filterCompleted = true);
                  ref.read(taskListViewModelProvider.notifier).setFilter(true);
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: AppDimensions.paddingMedium),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskState = ref.watch(taskListViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text('My Tasks', style: AppTextStyles.h2),
        actions: [
          IconButton(
            icon: Icon(
              _filterCompleted == null
                  ? Icons.filter_list_outlined
                  : Icons.filter_list,
              color: _filterCompleted == null
                  ? AppColors.textPrimary
                  : AppColors.primary,
            ),
            onPressed: _showFilterMenu,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await ref
                    .read(taskListViewModelProvider.notifier)
                    .loadTasks(refresh: true);
              },
              child: taskState.tasks.isEmpty && !taskState.isLoading
                  ? _buildEmptyState()
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                      itemCount: taskState.tasks.length +
                          (taskState.isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == taskState.tasks.length) {
                          return const Padding(
                            padding: EdgeInsets.all(AppDimensions.paddingLarge),
                            child: LoadingIndicator(size: 30),
                          );
                        }

                        final task = taskState.tasks[index];
                        return TaskListItem(
                          task: task,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    TaskDetailScreen(taskId: task.id),
                              ),
                            );
                          },
                          onToggle: () {
                            ref
                                .read(taskListViewModelProvider.notifier)
                                .toggleTask(task);
                          },
                          onDelete: () {
                            ref
                                .read(taskListViewModelProvider.notifier)
                                .deleteTask(task.id);
                          },
                        );
                      },
                    ),
            ),
          ),
          TaskInputField(
            onSubmit: (title, description) {
              ref
                  .read(taskListViewModelProvider.notifier)
                  .addTask(title, description);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_alt,
              size: 80,
              color: AppColors.textDisabled,
            ),
            const SizedBox(height: AppDimensions.paddingMedium),
            Text(
              'No tasks yet',
              style: AppTextStyles.h2.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingSmall),
            Text(
              'Add your first task to get started',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
