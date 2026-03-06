import 'package:flutter/material.dart';
import 'package:gider_takip/features/transactions/constants/app_icons_constants.dart';

class IconContainerWidget extends StatelessWidget {
  final CategoryIcon categoryIcon;
  final double size;
  final double iconSize;

  const IconContainerWidget({
    super.key,
    required this.categoryIcon,
    required this.size,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            categoryIcon.color.withOpacity(0.15),
            categoryIcon.color.withOpacity(0.25),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Icon(
          categoryIcon.icon,
          color: categoryIcon.color,
          size: iconSize,
        ),
      ),
    );
  }
}
