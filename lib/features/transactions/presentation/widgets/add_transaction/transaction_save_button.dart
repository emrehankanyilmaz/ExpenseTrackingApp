import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../constants/app_color_constans.dart';
import '../../helper/transaction_helper.dart';

class TransactionSaveButton extends StatelessWidget {
  const TransactionSaveButton({
    super.key,
    required this.amountController,
    required this.descController,
  });
  final TextEditingController amountController;
  final TextEditingController descController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () => TransactionHelper.save(
            context,
            amount: amountController.text,
            description: descController.text,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.colorBlue700,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            'save'.tr(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColor.colorWhite,
            ),
          ),
        ),
      ),
    );
  }
}
