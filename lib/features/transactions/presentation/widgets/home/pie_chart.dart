import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gider_takip/features/transactions/constants/app_color_constans.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/base_text.dart';

class ExpensePieChart extends StatelessWidget {
  const ExpensePieChart({super.key, required this.data});

  final Map<String, double> data;

  @override
  Widget build(BuildContext context) {
    final total = data.values.fold(0.0, (sum, v) => sum + v);

    if (total == 0) {
      return Center(
        child: BaseText.bodyMedium(context,
            data: 'noData'.tr(), color: AppColor.colorGrey),
      );
    }

    final colors = [
      AppColor.colorBlue,
      AppColor.colorGreen,
      AppColor.colorRed,
      AppColor.colorOrange,
      const Color(0xFF9C27B0),
      const Color(0xFF00BCD4),
    ];

    final sections = data.entries.toList();

    return Row(
      children: [
        SizedBox(
          width: 140,
          height: 140,
          child: CustomPaint(
            painter: _PieChartPainter(
              sections: sections,
              colors: colors,
              total: total,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: sections.asMap().entries.map((entry) {
              final index = entry.key;
              final section = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: colors[index % colors.length],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: BaseText.labelSmall(
                        context,
                        data: section.key,
                        color: AppColor.colorGrey,
                      ),
                    ),
                    BaseText.labelSmall(
                      context,
                      data:
                          '${'currency'.tr()}${section.value.toStringAsFixed(0)}',
                      color: AppColor.colorBlack,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _PieChartPainter extends CustomPainter {
  _PieChartPainter({
    required this.sections,
    required this.colors,
    required this.total,
  });

  final List<MapEntry<String, double>> sections;
  final List<Color> colors;
  final double total;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;
    var startAngle = -pi / 2;

    for (var i = 0; i < sections.length; i++) {
      final sweepAngle = (sections[i].value / total) * 2 * pi;
      final paint = Paint()
        ..color = colors[i % colors.length]
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      final separatorPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        separatorPaint,
      );

      startAngle += sweepAngle;
    }

    final holePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.55, holePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
