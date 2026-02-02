import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ui_components/src/extensions/build_context_extensions.dart';
import 'package:ui_components/src/theme/app_radius.dart';
import 'package:ui_components/src/theme/app_spacing.dart';
import 'package:ui_components/src/widgets/display/xo_loader.dart';

typedef AsyncCallback = FutureOr<void> Function();

class GradientButton extends HookWidget {
  const GradientButton({
    required this.onPressed,
    required this.label,
    this.icon,
    this.expand = true,
    this.main = false,
    super.key,
  }) : _secondary = false;

  const GradientButton.secondary({
    required this.onPressed,
    required this.label,
    this.icon,
    this.expand = true,
    this.main = false,
    super.key,
  }) : _secondary = true;

  final AsyncCallback? onPressed;
  final String label;
  final IconData? icon;
  final bool expand;
  final bool main;
  final bool _secondary;

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);
    final isDisabled = onPressed == null;

    Future<void> handlePress() async {
      isLoading.value = true;
      try {
        await onPressed?.call();
      } finally {
        if (context.mounted) isLoading.value = false;
      }
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: isDisabled
            ? null
            : _secondary
                ? context.brand.secondaryGradient
                : context.brand.actionGradient,
        color: isDisabled ? context.theme.disabledColor : null,
        borderRadius: AppRadius.button,
      ),
      child: SizedBox(
        width: expand ? double.infinity : null,
        child: ElevatedButton(
          onPressed: isDisabled || isLoading.value ? null : handlePress,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            foregroundColor: context.colorScheme.onPrimary,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            disabledForegroundColor: context.theme.disabledColor,
            disabledBackgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.button,
            ),
            textStyle: (main
                    ? context.textTheme.headlineSmall
                    : context.textTheme.titleMedium)
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLoading.value)
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.xs),
                  child: XoLoader(color: context.colorScheme.onPrimary),
                )
              else if (icon != null)
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.xs),
                  child: Icon(icon),
                ),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}
