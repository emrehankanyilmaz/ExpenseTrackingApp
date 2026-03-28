import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/base_text.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/transaction/filter_bottom_sheet.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/transaction/transaction_page_body.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionProvider = context.watch<TransactionProvider>();
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: BaseText.displaySmall(context, data: 'allTransactions'.tr()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon:
                    const Icon(Icons.filter_list_rounded, color: Colors.black),
                onPressed: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => const FilterBottomSheet(),
                ),
              ),
              if (transactionProvider.hasActiveFilter)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: const TransactionPageBody(),
    );
  }
}
