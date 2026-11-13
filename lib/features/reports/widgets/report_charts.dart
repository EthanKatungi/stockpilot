import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../reports_mock_data.dart';

class InventoryTrendChart extends StatelessWidget {
  const InventoryTrendChart({
    super.key,
    required this.points,
    required this.selectedIndex,
    required this.onSelect,
  });

  final List<ReportTrendPoint> points;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      SizedBox(
        height: 145,
        width: double.infinity,
        child: LayoutBuilder(
          builder: (context, constraints) => GestureDetector(
            onTapDown: (details) {
              final fraction = (details.localPosition.dx / constraints.maxWidth)
                  .clamp(0.0, 1.0);
              onSelect((fraction * (points.length - 1)).round());
            },
            child: CustomPaint(
              painter: _TrendPainter(
                points: points,
                selectedIndex: selectedIndex,
              ),
              child: Semantics(
                label: 'Inventory trend chart with ${points.length} periods',
              ),
            ),
          ),
        ),
      ),
      const SizedBox(height: 6),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (final point in points)
            Text(point.label, style: AppTheme.bodySmall.copyWith(fontSize: 10)),
        ],
      ),
    ],
  );
}

class _TrendPainter extends CustomPainter {
  const _TrendPainter({required this.points, required this.selectedIndex});

  final List<ReportTrendPoint> points;
  final int selectedIndex;

  @override
  void paint(Canvas canvas, Size size) {
    final guide = Paint()..color = AppTheme.border;
    for (var row = 1; row <= 3; row++) {
      final y = size.height * row / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), guide);
    }
    if (points.isEmpty) return;
    final offsets = <Offset>[
      for (var index = 0; index < points.length; index++)
        Offset(
          points.length == 1
              ? size.width / 2
              : size.width * index / (points.length - 1),
          size.height -
              (points[index].stockIndex.clamp(0, 100) / 100 * size.height),
        ),
    ];
    final path = Path()..moveTo(offsets.first.dx, offsets.first.dy);
    for (final offset in offsets.skip(1)) {
      path.lineTo(offset.dx, offset.dy);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = AppTheme.primary
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
    for (var index = 0; index < offsets.length; index++) {
      canvas.drawCircle(
        offsets[index],
        index == selectedIndex ? 6 : 3,
        Paint()..color = AppTheme.primary,
      );
      if (index == selectedIndex) {
        canvas.drawCircle(offsets[index], 2.5, Paint()..color = Colors.white);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _TrendPainter oldDelegate) =>
      oldDelegate.points != points ||
      oldDelegate.selectedIndex != selectedIndex;
}

class MovementBarsChart extends StatelessWidget {
  const MovementBarsChart({
    super.key,
    required this.points,
    required this.selectedIndex,
    required this.onSelect,
  });

  final List<ReportTrendPoint> points;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      SizedBox(
        height: 112,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (final (index, point) in points.indexed)
              Expanded(
                child: InkWell(
                  onTap: () => onSelect(index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _Bar(
                              height: point.received,
                              color: AppTheme.primary,
                              selected: index == selectedIndex,
                            ),
                            const SizedBox(width: 3),
                            _Bar(
                              height: point.issued,
                              color: AppTheme.warning,
                              selected: index == selectedIndex,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      const SizedBox(height: 5),
      Row(
        children: [
          for (final point in points)
            Expanded(
              child: Text(
                point.label,
                textAlign: TextAlign.center,
                style: AppTheme.bodySmall.copyWith(fontSize: 10),
              ),
            ),
        ],
      ),
    ],
  );
}

class _Bar extends StatelessWidget {
  const _Bar({
    required this.height,
    required this.color,
    required this.selected,
  });

  final double height;
  final Color color;
  final bool selected;

  @override
  Widget build(BuildContext context) => Container(
    width: selected ? 13 : 11,
    height: height.clamp(0, 100),
    decoration: BoxDecoration(
      color: color.withValues(alpha: selected ? 1 : .7),
      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
    ),
  );
}
