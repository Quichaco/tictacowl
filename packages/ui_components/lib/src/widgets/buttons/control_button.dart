import 'package:flutter/material.dart';
import 'package:ui_components/src/extensions/build_context_extensions.dart';
import 'package:ui_components/src/theme/app_radius.dart';
import 'package:ui_components/src/theme/app_spacing.dart';

class ControlButton extends StatelessWidget {
  const ControlButton({
    required this.icon,
    this.onTap,
    super.key,
  });

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final enabled = onTap != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xs),
        decoration: BoxDecoration(
          color: enabled
              ? colors.primary.withValues(alpha: 0.1)
              : colors.onSurface.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Icon(
          icon,
          color: enabled ? colors.primary : context.theme.disabledColor,
        ),
      ),
    );
  }
}
