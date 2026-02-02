import 'package:flutter/material.dart';
import 'package:ui_components/src/extensions/build_context_extensions.dart';
import 'package:ui_components/src/theme/app_radius.dart';

class EditableField extends StatelessWidget {
  const EditableField({
    required this.value,
    required this.isEditing,
    required this.controller,
    required this.onSubmitted,
    required this.onEditPressed,
    this.maxLength = 30,
    super.key,
  });

  final String value;
  final bool isEditing;
  final TextEditingController controller;
  final VoidCallback onSubmitted;
  final VoidCallback onEditPressed;
  final int maxLength;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    return ListTile(
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.card),
      tileColor: colors.surfaceContainerLow,
      title: isEditing
          ? TextField(
              controller: controller,
              autofocus: true,
              maxLength: maxLength,
              textInputAction: TextInputAction.done,
              style: context.textTheme.bodyLarge,
              decoration: InputDecoration(
                counterText: '',
                isDense: true,
                contentPadding: EdgeInsets.zero,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: colors.outline.withValues(alpha: 0.3),
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: colors.primary,
                    width: 2,
                  ),
                ),
              ),
              onSubmitted: (_) => onSubmitted(),
            )
          : Text(
              value,
              style: context.textTheme.bodyLarge,
            ),
      trailing: Icon(isEditing ? Icons.check : Icons.edit_outlined),
      onTap: isEditing ? onSubmitted : onEditPressed,
    );
  }
}
