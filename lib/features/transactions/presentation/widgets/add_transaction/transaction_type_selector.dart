import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../constants/app_color_constans.dart';
import '../../providers/transaction_provider.dart';

class TransactionTypeSelector extends StatelessWidget {
  const TransactionTypeSelector({
    super.key,
    required this.provider,
  });
  final TransactionProvider provider;

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
        children: [
          Text('expense'.tr(),
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Text('income'.tr(),
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
