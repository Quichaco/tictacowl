import 'package:flutter/material.dart';
import 'package:ui_components/src/extensions/build_context_extensions.dart';
import 'package:ui_components/src/theme/app_radius.dart';
import 'package:ui_components/src/theme/app_spacing.dart';

class SelectField<T> extends StatelessWidget {
  const SelectField({
    required this.title,
    required this.values,
    required this.selected,
    required this.labelOf,
    required this.onSelected,
    this.iconOf,
    super.key,
  });

  final String title;
  final List<T> values;
  final T selected;
  final String Function(T) labelOf;
  final IconData Function(T)? iconOf;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.card),
      tileColor: context.colorScheme.surfaceContainerLow,
      leading: iconOf != null ? Icon(iconOf!(selected)) : null,
      title: Text(labelOf(selected)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showSheet(context),
    );
  }

  void _showSheet(BuildContext context) {
    final primaryColor = context.colorScheme.primary;

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            ...values.map((value) {
              return _buildOption(context, value, primaryColor);
            }),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(BuildContext context, T value, Color activeColor) {
    final isSelected = value == selected;
    final color = isSelected ? activeColor : null;

    return ListTile(
      leading: iconOf != null ? Icon(iconOf!(value), color: color) : null,
      title: Text(
        labelOf(value),
        style: isSelected
            ? TextStyle(color: color, fontWeight: FontWeight.w600)
            : null,
      ),
      trailing: isSelected ? Icon(Icons.check, color: color) : null,
      onTap: () {
        onSelected(value);
        Navigator.pop(context);
      },
    );
  }
}
