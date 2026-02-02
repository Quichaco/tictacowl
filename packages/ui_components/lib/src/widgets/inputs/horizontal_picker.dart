import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ui_components/src/extensions/build_context_extensions.dart';
import 'package:ui_components/src/theme/app_radius.dart';
import 'package:ui_components/src/theme/app_spacing.dart';

class HorizontalPicker<T> extends HookWidget {
  const HorizontalPicker({
    required this.values,
    required this.selected,
    required this.labelOf,
    required this.onChanged,
    this.emojiOf,
    super.key,
  });

  final List<T> values;
  final T selected;
  final String Function(T) labelOf;
  final String Function(T)? emojiOf;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final goingForward = useRef(true);
    final index = values.indexOf(selected);
    final isFirst = index <= 0;
    final isLast = index >= values.length - 1;

    void previous() {
      if (isFirst) return;
      goingForward.value = false;
      onChanged(values[index - 1]);
    }

    void next() {
      if (isLast) return;
      goingForward.value = true;
      onChanged(values[index + 1]);
    }

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity == null) return;
        if (details.primaryVelocity! < 0) next();
        if (details.primaryVelocity! > 0) previous();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: context.colorScheme.surfaceContainerLow,
          borderRadius: AppRadius.button,
        ),
        child: Row(
          children: [
            _ControlButton(
              icon: Icons.chevron_left,
              onTap: isFirst ? null : previous,
            ),
            Expanded(
              child: ClipRect(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  transitionBuilder: (child, animation) {
                    final isIncoming = child.key == ValueKey(selected);
                    final begin = isIncoming
                        ? Offset(goingForward.value ? 1 : -1, 0)
                        : Offset(goingForward.value ? -1 : 1, 0);
                    return SlideTransition(
                      position: Tween(begin: begin, end: Offset.zero)
                          .animate(animation),
                      child: FadeTransition(opacity: animation, child: child),
                    );
                  },
                  layoutBuilder: (currentChild, previousChildren) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        ...previousChildren,
                        ?currentChild,
                      ],
                    );
                  },
                  child: Row(
                    key: ValueKey(selected),
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (emojiOf != null) ...[
                        Text(
                          emojiOf!(selected),
                          style: const TextStyle(fontSize: 22),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                      ],
                      Text(
                        labelOf(selected),
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _ControlButton(
              icon: Icons.chevron_right,
              onTap: isLast ? null : next,
            ),
          ],
        ),
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final enabled = onTap != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: enabled
              ? colors.primary.withValues(alpha: 0.1)
              : colors.onSurface.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Icon(
          icon,
          color: enabled ? colors.primary : context.theme.disabledColor,
          size: 20,
        ),
      ),
    );
  }
}
