import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../models/task_model.dart';

class TaskListItem extends ConsumerStatefulWidget {
  final TaskModel task;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TaskListItem({
    super.key,
    required this.task,
    required this.onTap,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  ConsumerState<TaskListItem> createState() => _TaskListItemState();
}

class _TaskListItemState extends ConsumerState<TaskListItem> {
  double _scratchProgress = 0.0;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _scratchProgress = widget.task.isCompleted ? 1.0 : 0.0;
  }

  void _handleHorizontalDragUpdate(DragUpdateDetails details) {
    if (_isAnimating) return;
    
    setState(() {
      // Update progress based on drag velocity and direction
      final delta = details.primaryDelta ?? 0;
      _scratchProgress = (_scratchProgress + (delta / 200)).clamp(0.0, 1.0);
    });
  }

  void _handleHorizontalDragEnd(DragEndDetails details) {
    if (_isAnimating) return;

    final velocity = details.primaryVelocity ?? 0;
    
    setState(() {
      _isAnimating = true;
    });

    // Swipe right (positive velocity) = complete
    // Swipe left (negative velocity) = uncomplete
    if (velocity > 300 && !widget.task.isCompleted) {
      // Fast swipe right - complete the task
      setState(() {
        _scratchProgress = 1.0;
      });
      Future.delayed(const Duration(milliseconds: 300), () {
        widget.onToggle();
        setState(() {
          _isAnimating = false;
        });
      });
    } else if (velocity < -300 && widget.task.isCompleted) {
      // Fast swipe left - uncomplete the task
      setState(() {
        _scratchProgress = 0.0;
      });
      Future.delayed(const Duration(milliseconds: 300), () {
        widget.onToggle();
        setState(() {
          _isAnimating = false;
        });
      });
    } else {
      // Slow drag - snap back to current state
      setState(() {
        _scratchProgress = widget.task.isCompleted ? 1.0 : 0.0;
        _isAnimating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppDimensions.paddingLarge),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
        ),
        child: const Icon(
          Icons.delete_outline,
          color: AppColors.surface,
          size: AppDimensions.iconSizeLarge,
        ),
      ),
      onDismissed: (_) => widget.onDelete(),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppDimensions.paddingMedium),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.surface,
              AppColors.surfaceVariant,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
          border: Border.all(
            color: AppColors.border.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: _scratchProgress > 0.7
                  ? AppColors.completedTask.withOpacity(0.2)
                  : AppColors.primary.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return GestureDetector(
                  onHorizontalDragUpdate: _handleHorizontalDragUpdate,
                  onHorizontalDragEnd: _handleHorizontalDragEnd,
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                    child: Stack(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              margin: const EdgeInsets.only(
                                top: 2,
                                right: AppDimensions.paddingMedium,
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _scratchProgress > 0.7
                                      ? AppColors.completedTask
                                      : AppColors.border,
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: AnimatedOpacity(
                                  opacity: _scratchProgress > 0.7 ? 1.0 : 0.0,
                                  duration: const Duration(milliseconds: 200),
                                  child: const Icon(
                                    Icons.check,
                                    size: 16,
                                    color: AppColors.completedTask,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.task.title,
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  if (widget.task.description.isNotEmpty) ...[
                                    const SizedBox(height: AppDimensions.paddingXSmall),
                                    Text(
                                      widget.task.description,
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                  const SizedBox(height: AppDimensions.paddingSmall),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        size: AppDimensions.iconSizeSmall,
                                        color: AppColors.textDisabled,
                                      ),
                                      const SizedBox(width: AppDimensions.paddingXSmall),
                                      Text(
                                        DateFormatter.formatRelativeTime(widget.task.createdAt),
                                        style: AppTextStyles.caption,
                                      ),
                                      if (widget.task.sharedWith.isNotEmpty) ...[
                                        const SizedBox(width: AppDimensions.paddingMedium),
                                        Icon(
                                          Icons.people_outline,
                                          size: AppDimensions.iconSizeSmall,
                                          color: AppColors.primary,
                                        ),
                                        const SizedBox(width: AppDimensions.paddingXSmall),
                                        Text(
                                          'Shared',
                                          style: AppTextStyles.caption.copyWith(
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: AppColors.textDisabled,
                            ),
                          ],
                        ),
                        // Scratch-off line overlay
                        Positioned.fill(
                          child: CustomPaint(
                            painter: ScratchLinePainter(
                              progress: _scratchProgress,
                              isAnimating: _isAnimating,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class ScratchLinePainter extends CustomPainter {
  final double progress;
  final bool isAnimating;

  ScratchLinePainter({
    required this.progress,
    required this.isAnimating,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final paint = Paint()
      ..color = AppColors.completedTask.withOpacity(0.8)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final y = size.height / 2;
    final startX = 40.0;
    final endX = size.width * progress - 40;

    if (endX > startX) {
      canvas.drawLine(
        Offset(startX, y),
        Offset(endX, y),
        paint,
      );

      // Add a glow effect
      if (progress > 0.7) {
        final glowPaint = Paint()
          ..color = AppColors.completedTask.withOpacity(0.3)
          ..strokeWidth = 6
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

        canvas.drawLine(
          Offset(startX, y),
          Offset(endX, y),
          glowPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(ScratchLinePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isAnimating != isAnimating;
  }
}
