import 'package:flutter/material.dart';
import 'package:gider_takip/features/transactions/constants/app_color_constans.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    super.key,
    required this.child,
    this.height,
    this.width,
    this.padding,
    this.margin,
    this.color,
    this.borderRadius = 12,
    this.border,
    this.gradient,
    this.alignment,
    this.customBorderRadius,
  });

  final Widget child;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double borderRadius;
  final Border? border;
  final Gradient? gradient;
  final AlignmentGeometry? alignment;
  final BorderRadiusGeometry? customBorderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: padding,
      margin: margin,
      alignment: alignment,
      decoration: BoxDecoration(
        color: gradient == null ? (color ?? AppColor.colorWhite) : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border,
      ),
      child: child,
    );
  }
}
