import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gider_takip/features/transactions/presentation/pages/add_transaction_body_page.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/base_text.dart';
import 'package:provider/provider.dart';
import '../../constants/app_color_constans.dart';
import '../providers/transaction_provider.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final amountController = TextEditingController();
  final descController = TextEditingController();

  @override
  void dispose() {
    amountController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColor.colorBlack),
          onPressed: () {
            context.read<TransactionProvider>().resetForm();
            Navigator.pop(context);
          },
        ),
        title: BaseText.displaySmall(context, data: 'newTransaction'.tr()),
      ),
      body: AddTransactionBody(
        amountController: amountController,
        descController: descController,
      ),
    );
  }
}
