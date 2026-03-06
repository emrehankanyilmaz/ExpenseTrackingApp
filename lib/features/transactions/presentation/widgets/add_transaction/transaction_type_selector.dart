import 'package:flutter/material.dart';

import '../../../constants/app_color_constans.dart';
import '../../../constants/common_constans.dart';
import '../../providers/transaction_provider.dart';

class TransactionTypeSelector extends StatelessWidget {
  final TransactionProvider provider;

  const TransactionTypeSelector({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ToggleButtons(
        isSelected: [provider.selectedType == 0, provider.selectedType == 1],
        onPressed: provider.setSelectedType,
        borderRadius: BorderRadius.circular(10),
        selectedColor: AppColor.colorWhite,
        fillColor: AppColor.colorRed,
        color: AppColor.colorGrey600,
        constraints: const BoxConstraints(
          minHeight: 35,
          minWidth: 90,
        ),
        children: const [
          Text(CommonConstants.expense,
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text(CommonConstants.income,
              style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
