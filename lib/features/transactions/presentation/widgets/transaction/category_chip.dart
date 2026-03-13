import 'package:flutter/material.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/base_text.dart';

import '../../../constants/app_color_constans.dart';

class CategoryChipWidget extends StatelessWidget {
  const CategoryChipWidget(
      {super.key,
      required this.label,
      required this.isSelected,
      required this.onTap});
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColor.colorBlue.withValues(alpha: 0.22)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color:
                  isSelected ? AppColor.colorBlue : AppColor.colorTransparent,
              width: 1.5),
        ),
        child: BaseText.labelMedium(context,
            data: label,
            color: isSelected ? AppColor.colorBlue : AppColor.colorGrey),
      ),
    );
  }
}
