import 'dart:math';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChartDonutPainterWidget extends StatefulWidget {
  final String title;
  final double diameter;
  final Duration? duration;
  final List<ChartData> data;

  const ChartDonutPainterWidget({super.key, required this.title, required this.data, required this.diameter, this.duration});

  @override
  State<ChartDonutPainterWidget> createState() => _ChartDonutPainterWidgetState();
}

class _ChartDonutPainterWidgetState extends State<ChartDonutPainterWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.duration ?? const Duration(milliseconds: 500),
      vsync: this,
    );
    _controller.forward();

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: widget.diameter.w,
          height: widget.diameter.h,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return CustomPaint(
                painter: DonutChartPainter(
                  progress: _animation.value,
                  dataList: widget.data,
                  diameter: widget.diameter.w,
                ),
              );
            },
          ),
        ),

        Positioned(
          width: widget.diameter.w, height: widget.diameter.h,
          child: Center(
            child: Text(widget.title,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        )
      ],
    );
  }

  int _per(int value) {
    int total = widget.data.map((x) => x.value).reduce((a, b) => a + b);
    return (value / total * 100).round();
  }
}

class DonutChartPainter extends CustomPainter {
  final double progress;
  final double diameter;
  final List<ChartData> dataList;
  final double strokeWidth;

  DonutChartPainter({required this.progress, required this.dataList, required this.diameter}):
      strokeWidth = diameter / 4;

  @override
  void paint(Canvas canvas, Size size) {
    final int total = dataList.map((x) => x.value).reduce((a, b) => a + b);
    double startAngle = -90.0; // 시작 각도
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth // 기본 도넛 두께
      ..strokeCap = StrokeCap.butt;

    final double radius = size.width / 3;
    double accumulatedProgress = 0.0; // 현재까지의 누적 진행도

    for (ChartData data in dataList) {
      final double sectionProgress = (data.value / total); // 해당 데이터의 백분율

      // 현재 진행도가 이 섹션에 아직 도달하지 않았을 경우 그리지 않음
      if (progress <= accumulatedProgress) break;

      // 현재 섹션의 진행도 중 그릴 부분만 계산
      final double sweepProgress = (progress - accumulatedProgress).clamp(0.0, sectionProgress);
      final double sweepAngle = sweepProgress * 360;

      paint.color = data.color;

      // 섹션 그리기
      canvas.drawArc(
        Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: radius),
        radians(startAngle),
        radians(sweepAngle),
        false,
        paint,
      );

      // 섹션의 중앙 각도를 계산하여 텍스트 그리기
      final double halfAngle = startAngle + sweepAngle / 2;
      final Offset labelPosition = Offset(
        size.width / 2 + radius * cos(radians(halfAngle)), // 중앙 위치에서 조금 안쪽에 그리기
        size.height / 2 + radius * sin(radians(halfAngle)),
      );

      // 섹션이 로드될 때 텍스트를 그리기
      _drawText(canvas, data.title, labelPosition);

      startAngle += sectionProgress * 360;
      accumulatedProgress += sectionProgress; // 누적 진행도 갱신
    }
  }

  void _drawText(Canvas canvas, String text, Offset position) {

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );

    textPainter.layout();
    final offset = Offset(position.dx - textPainter.width / 2, position.dy - textPainter.height / 2);

    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  double radians(double degrees) => degrees * (3.141592653589793 / 180);
}

class ChartData {
  final String title;
  final int value;
  final Color color;

  ChartData({required this.title, required this.value, required this.color});
}
