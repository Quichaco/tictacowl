import 'package:confetti/confetti.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

ConfettiController useConfettiController(Duration duration) {
  final controller = useMemoized(() => ConfettiController(duration: duration));
  useEffect(() => controller.dispose, [controller]);
  return controller;
}
