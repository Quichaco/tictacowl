import 'package:flutter/material.dart';
import 'package:ui_components/src/extensions/build_context_extensions.dart';
import 'package:ui_components/src/theme/app_spacing.dart';

class ErrorDisplay extends StatelessWidget {
  const ErrorDisplay({
    required this.message,
    required this.onRetry,
    this.retryLabel = 'Réessayer',
    super.key,
  });

  final String message;
  final VoidCallback onRetry;
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: context.colorScheme.error,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              style: context.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(retryLabel),
            ),
          ],
        ),
      ),
    );
  }
}
