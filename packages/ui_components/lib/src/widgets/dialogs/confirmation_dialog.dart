import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ui_components/ui_components.dart';

class ConfirmationDialog extends HookWidget {
  const ConfirmationDialog({
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    this.icon,
    super.key,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final IconData? icon;

  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String message,
    required String confirmLabel,
    required String cancelLabel,
    IconData? icon,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => ConfirmationDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        icon: icon,
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final scaleController = useAnimationController(
      duration: AppDurations.slow,
    );

    final scaleAnimation = useMemoized(
      () => CurvedAnimation(parent: scaleController, curve: Curves.easeOutBack),
      [scaleController],
    );
    final rotateAnimation = useMemoized(
      () => Tween<double>(begin: -0.08, end: 0.0).animate(
        CurvedAnimation(parent: scaleController, curve: Curves.easeOutBack),
      ),
      [scaleController],
    );

    useEffect(() {
      scaleController.forward();
      return null;
    }, []);

    return Center(
      child: ScaleTransition(
        scale: scaleAnimation,
        child: RotationTransition(
          turns: rotateAnimation,
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                color: context.colorScheme.surface,
                borderRadius: AppRadius.card,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: 48,
                      color: context.colorScheme.primary,
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  Text(
                    title,
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    message,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.brand.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    width: double.infinity,
                    child: GradientButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      label: confirmLabel,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(
                      cancelLabel,
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: context.brand.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
