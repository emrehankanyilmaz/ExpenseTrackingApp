import 'package:flutter/material.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/common/custom_container.dart';

import '../../../constants/app_color_constans.dart';

class AmountFieldWidget extends StatelessWidget {
  const AmountFieldWidget({
    this.onChanged,
    required this.hint,
    required this.controller,
    super.key,
  });
  final String hint;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
        color: AppColor.colorGrey100,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
          ),
          onChanged: onChanged,
        ));
  }
}
