import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/utils/validators.dart';
import '../../core/utils/date_formatter.dart';
import '../../viewmodels/task_detail_viewmodel.dart';

class TaskDetailScreen extends ConsumerStatefulWidget {
  final String taskId;

  const TaskDetailScreen({
    super.key,
    required this.taskId,
  });

  @override
  ConsumerState<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends ConsumerState<TaskDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      ref.read(taskDetailViewModelProvider(widget.taskId).notifier).updateTask(
            _titleController.text.trim(),
            _descriptionController.text.trim(),
          );
      setState(() => _isEditing = false);
    }
  }

  void _showShareOptions() {
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
              Text('Share Task', style: AppTextStyles.h3),
              const SizedBox(height: AppDimensions.paddingMedium),
              ListTile(
                leading: const Icon(Icons.email_outlined),
                title: const Text('Share via Email'),
                onTap: () {
                  Navigator.pop(context);
                  ref
                      .read(taskDetailViewModelProvider(widget.taskId).notifier)
                      .shareViaEmail();
                },
              ),
              ListTile(
                leading: const Icon(Icons.link),
                title: const Text('Share Link'),
                onTap: () {
                  Navigator.pop(context);
                  ref
                      .read(taskDetailViewModelProvider(widget.taskId).notifier)
                      .shareViaLink();
                },
              ),
              ListTile(
                leading: const Icon(Icons.copy),
                title: const Text('Copy Link'),
                onTap: () {
                  final link = ref
                      .read(taskDetailViewModelProvider(widget.taskId).notifier)
                      .getShareLink();
                  Clipboard.setData(ClipboardData(text: link));
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Link copied to clipboard'),
                      backgroundColor: AppColors.success,
                    ),
                  );
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
    final taskState = ref.watch(taskDetailViewModelProvider(widget.taskId));

    if (taskState.isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: LoadingIndicator(),
      );
    }

    final task = taskState.task;
    if (task == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
        ),
        body: const Center(
          child: Text('Task not found'),
        ),
      );
    }

    if (!_isEditing) {
      _titleController.text = task.title;
      _descriptionController.text = task.description;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Task Details', style: AppTextStyles.h3),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.share_outlined, color: AppColors.textPrimary),
              onPressed: _showShareOptions,
            ),
          IconButton(
            icon: Icon(
              _isEditing ? Icons.close : Icons.edit_outlined,
              color: AppColors.textPrimary,
            ),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
                if (!_isEditing) {
                  _titleController.text = task.title;
                  _descriptionController.text = task.description;
                }
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppDimensions.maxContentWidth,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusMedium,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            task.isCompleted
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: task.isCompleted
                                ? AppColors.completedTask
                                : AppColors.textSecondary,
                          ),
                          const SizedBox(width: AppDimensions.paddingSmall),
                          Text(
                            task.isCompleted ? 'Completed' : 'Pending',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: task.isCompleted
                                  ? AppColors.completedTask
                                  : AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.paddingMedium),
                      const Divider(),
                      const SizedBox(height: AppDimensions.paddingMedium),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: AppDimensions.iconSizeSmall,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: AppDimensions.paddingSmall),
                          Text(
                            'Created ${DateFormatter.formatDate(task.createdAt)}',
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.paddingSmall),
                      Row(
                        children: [
                          const Icon(
                            Icons.update,
                            size: AppDimensions.iconSizeSmall,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: AppDimensions.paddingSmall),
                          Text(
                            'Updated ${DateFormatter.formatDate(task.updatedAt)}',
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                      if (task.sharedWith.isNotEmpty) ...[
                        const SizedBox(height: AppDimensions.paddingSmall),
                        Row(
                          children: [
                            const Icon(
                              Icons.people_outline,
                              size: AppDimensions.iconSizeSmall,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: AppDimensions.paddingSmall),
                            Text(
                              'Shared with ${task.sharedWith.length} ${task.sharedWith.length == 1 ? 'person' : 'people'}',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingLarge),
                CustomTextField(
                  label: 'Title',
                  controller: _titleController,
                  validator: Validators.validateTaskTitle,
                  enabled: _isEditing,
                ),
                const SizedBox(height: AppDimensions.paddingMedium),
                CustomTextField(
                  label: 'Description',
                  controller: _descriptionController,
                  maxLines: 5,
                  enabled: _isEditing,
                ),
                if (_isEditing) ...[
                  const SizedBox(height: AppDimensions.paddingLarge),
                  CustomButton(
                    text: 'Save Changes',
                    onPressed: _handleSave,
                    isLoading: taskState.isSaving,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
