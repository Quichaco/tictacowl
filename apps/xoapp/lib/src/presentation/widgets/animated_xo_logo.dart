import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:xoapp/src/common/constants/app_assets.dart';

class AnimatedXoLogo extends HookWidget {
  const AnimatedXoLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 3000),
    );

    useEffect(() {
      controller.repeat(reverse: true);
      return null;
    }, [controller]);

    final scale = useAnimation(
      Tween<double>(begin: 0.95, end: 1.05).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      ),
    );

    return Transform.scale(
      scale: scale,
      child: Image.asset(
        AppAssets.xoLogo,
        fit: BoxFit.contain,
      ),
    );
  }
}
