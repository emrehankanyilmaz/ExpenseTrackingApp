import 'package:flutter/material.dart';
import 'package:gider_takip/features/transactions/constants/category_constants.dart';

import '../../../constants/app_color_constans.dart';

class AddCategoryButton extends StatelessWidget {
  const AddCategoryButton({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: AppColor.colorWhite,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: AppColor.colorBlue),
              SizedBox(width: 6),
              Text(
                CategoryConstants.addCategory,
                style: TextStyle(
                  fontSize: 20,
                  color: AppColor.colorBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
