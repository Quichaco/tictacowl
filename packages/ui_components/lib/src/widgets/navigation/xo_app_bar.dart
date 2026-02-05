import 'package:flutter/material.dart';
import 'package:ui_components/src/extensions/build_context_extensions.dart';

class XoAppBar extends StatelessWidget implements PreferredSizeWidget {
  const XoAppBar({
    this.title,
    this.actions,
    this.onBackPressed,
    super.key,
  });

  final String? title;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();

    return AppBar(
      backgroundColor: context.colorScheme.surface,
      automaticallyImplyLeading: false,
      surfaceTintColor: Colors.transparent,
      leading: canPop
          ? IconButton.filledTonal(
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_rounded),
            )
          : null,
      title: title != null
          ? Text(
              title!,
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            )
          : null,
      centerTitle: true,
      actions: actions,
    );
  }
}

