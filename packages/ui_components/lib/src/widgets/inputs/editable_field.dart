import 'package:flutter/material.dart';
import 'package:ui_components/src/extensions/build_context_extensions.dart';

class EditableField extends StatelessWidget {
  const EditableField({
    required this.value,
    required this.isEditing,
    required this.controller,
    required this.formKey,
    required this.onSubmitted,
    required this.onEditPressed,
    this.validator,
    this.maxLength,
    super.key,
  });

  final String value;
  final bool isEditing;
  final TextEditingController controller;
  final GlobalKey<FormState> formKey;
  final VoidCallback onSubmitted;
  final VoidCallback onEditPressed;
  final String? Function(String?)? validator;
  final int? maxLength;

  void _submit() {
    if (formKey.currentState?.validate() ?? false) {
      onSubmitted();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    return ListTile(
      title: isEditing
          ? Form(
              key: formKey,
              child: TextFormField(
                controller: controller,
                autofocus: true,
                maxLength: maxLength,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.done,
                style: context.textTheme.bodyLarge,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: validator,
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
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colors.error),
                  ),
                  focusedErrorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colors.error, width: 2),
                  ),
                ),
                onFieldSubmitted: (_) => _submit(),
              ),
            )
          : Text(
              value,
              style: context.textTheme.bodyLarge,
            ),
      trailing: Icon(isEditing ? Icons.check : Icons.edit_outlined),
      onTap: isEditing ? _submit : onEditPressed,
    );
  }
}
