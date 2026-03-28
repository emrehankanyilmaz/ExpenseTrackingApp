import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/base_text.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/common/custom_container.dart';
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
        child: CustomContainer(
          height: 48,
          color: AppColor.colorWhite,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add, color: AppColor.colorBlue),
              const SizedBox(width: 6),
              BaseText.headlineMedium(context,
                  data: 'addCategory'.tr(), color: AppColor.colorBlue),
            ],
          ),
        ),
      ),
    );
  }
}
