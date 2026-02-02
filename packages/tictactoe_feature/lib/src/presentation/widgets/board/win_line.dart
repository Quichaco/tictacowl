import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ui_components/ui_components.dart';

class WinLine extends HookWidget {
  const WinLine({
    required this.pattern,
    required this.cellSize,
    required this.spacing,
    required this.gradient,
    this.gridSize = 3,
    super.key,
  });

  final List<int> pattern;
  final double cellSize;
  final double spacing;
  final LinearGradient gradient;
  final int gridSize;

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(duration: AppDurations.slow);
    final curved = useMemoized(
      () => CurvedAnimation(parent: controller, curve: Curves.easeOut),
      [controller],
    );
    final progress = useAnimation(curved);

    useEffect(() {
      controller.forward();
      return null;
    }, const []);

    return CustomPaint(
      painter: _WinLinePainter(
        pattern: pattern,
        cellSize: cellSize,
        spacing: spacing,
        gradient: gradient,
        gridSize: gridSize,
        progress: progress,
      ),
    );
  }
}

class _WinLinePainter extends CustomPainter {
  _WinLinePainter({
    required this.pattern,
    required this.cellSize,
    required this.spacing,
    required this.gradient,
    required this.gridSize,
    required this.progress,
  });

  final List<int> pattern;
  final double cellSize;
  final double spacing;
  final LinearGradient gradient;
  final int gridSize;
  final double progress;

  Offset _cellCenter(int index) {
    final row = index ~/ gridSize;
    final col = index % gridSize;
    return Offset(
      col * (cellSize + spacing) + cellSize / 2,
      row * (cellSize + spacing) + cellSize / 2,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0) return;

    final start = _cellCenter(pattern.first);
    final end = _cellCenter(pattern.last);
    final current = Offset.lerp(start, end, progress)!;

    final paint = Paint()
      ..shader = gradient.createShader(Rect.fromPoints(start, end))
      ..strokeWidth = AppBorder.winLineWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(start, current, paint);
  }

  @override
  bool shouldRepaint(_WinLinePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
