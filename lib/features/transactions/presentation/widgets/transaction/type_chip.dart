import 'package:flutter/material.dart';
import 'package:gider_takip/features/transactions/constants/app_color_constans.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/base_text.dart';

class TypeChipWidget extends StatelessWidget {
  const TypeChipWidget({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.color,
    super.key,
  });
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.22)
              : AppColor.colorGrey100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isSelected ? color : AppColor.colorTransparent,
              width: 1.5),
        ),
        child: BaseText.labelMedium(context,
            data: label, color: isSelected ? color : AppColor.colorGrey),
      ),
    );
  }
}
