import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';

class TaskInputField extends StatefulWidget {
  final Function(String title, String description) onSubmit;

  const TaskInputField({
    super.key,
    required this.onSubmit,
  });

  @override
  State<TaskInputField> createState() => _TaskInputFieldState();
}

class _TaskInputFieldState extends State<TaskInputField> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isExpanded = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a task title'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    widget.onSubmit(title, description);
    _titleController.clear();
    _descriptionController.clear();
    setState(() {
      _isExpanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(
            color: AppColors.border.withOpacity(0.3),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: 'Add a new task...',
                      hintStyle: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textDisabled,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.borderRadiusMedium,
                        ),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.borderRadiusMedium,
                        ),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.borderRadiusMedium,
                        ),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingMedium,
                        vertical: AppDimensions.paddingMedium,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isExpanded
                              ? Icons.expand_less
                              : Icons.expand_more,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () {
                          setState(() {
                            _isExpanded = !_isExpanded;
                          });
                        },
                      ),
                    ),
                    onSubmitted: (_) => _handleSubmit(),
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingSmall),
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.gradientStart, AppColors.gradientEnd],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusMedium,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: _handleSubmit,
                  ),
                ),
              ],
            ),
            if (_isExpanded) ...[
              const SizedBox(height: AppDimensions.paddingMedium),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: 'Add description (optional)',
                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textDisabled,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusMedium,
                    ),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusMedium,
                    ),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusMedium,
                    ),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(
                    AppDimensions.paddingMedium,
                  ),
                ),
                maxLines: 3,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
