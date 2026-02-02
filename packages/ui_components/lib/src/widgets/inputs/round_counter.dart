import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ui_components/src/extensions/build_context_extensions.dart';
import 'package:ui_components/src/theme/app_durations.dart';
import 'package:ui_components/src/theme/app_radius.dart';
import 'package:ui_components/src/theme/app_spacing.dart';
import 'package:ui_components/src/widgets/buttons/control_button.dart';

class RoundCounter extends HookWidget {
  const RoundCounter({
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.max = 10,
    this.labelOf,
    super.key,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;
  final String Function(int)? labelOf;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final goingUp = useRef(true);

    void decrement() {
      if (value <= min) return;
      goingUp.value = false;
      onChanged(value - 1);
    }

    void increment() {
      if (value >= max) return;
      goingUp.value = true;
      onChanged(value + 1);
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: AppRadius.button,
      ),
      child: Row(
        children: [
          ControlButton(
            icon: Icons.remove,
            onTap: value > min ? decrement : null,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRect(
                  child: AnimatedSwitcher(
                    duration: AppDurations.fast,
                    switchInCurve: Curves.easeInOut,
                    switchOutCurve: Curves.easeInOut,
                    transitionBuilder: (child, animation) {
                      final isIncoming = child.key == ValueKey(value);
                      final begin = isIncoming
                          ? Offset(0, goingUp.value ? 1 : -1)
                          : Offset(0, goingUp.value ? -1 : 1);
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
                    child: Text(
                      '$value',
                      key: ValueKey(value),
                      textAlign: TextAlign.center,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                if (labelOf != null) ...[
                  const SizedBox(width: 4),
                  Text(
                    labelOf!(value),
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          ControlButton(
            icon: Icons.add,
            onTap: value < max ? increment : null,
          ),
        ],
      ),
    );
  }
}
