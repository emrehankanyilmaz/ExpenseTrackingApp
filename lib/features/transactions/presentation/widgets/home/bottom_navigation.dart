import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gider_takip/features/transactions/presentation/providers/transaction_provider.dart';
import '../../../constants/app_color_constans.dart';
import '../../pages/add_transaction_page.dart';
import '../../pages/category_page.dart';
import '../../pages/transaction_page.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key, required this.provider});
  final TransactionProvider provider;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: provider.selectedIndex,
      onTap: (i) {
        if (i == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CategoryPage()),
          );
          return;
        }
        if (i == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTransactionPage()),
          );
          return;
        }
        if (i == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TransactionPage()),
          );
          return;
        }
        provider.setSelectedIndex(i);
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColor.colorBlue,
      unselectedItemColor: AppColor.colorGrey,
      items: [
        BottomNavigationBarItem(
            icon: const Icon(Icons.home), label: 'homePage'.tr()),
        BottomNavigationBarItem(
            icon: const Icon(Icons.category_outlined),
            label: 'categories'.tr()),
        BottomNavigationBarItem(
          icon: Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
                color: AppColor.colorBlue, shape: BoxShape.circle),
            child: const Icon(Icons.add, color: AppColor.colorWhite),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
            icon: const Icon(Icons.view_list_outlined),
            label: 'transactions'.tr()),
        BottomNavigationBarItem(
            icon: const Icon(Icons.settings), label: 'settings'.tr()),
      ],
    );
  }
}
