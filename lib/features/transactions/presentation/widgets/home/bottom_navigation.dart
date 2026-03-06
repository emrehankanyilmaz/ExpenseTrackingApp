import 'package:flutter/material.dart';
import 'package:gider_takip/features/transactions/presentation/providers/transaction_provider.dart';
import '../../../constants/app_color_constans.dart';
import '../../../constants/common_constans.dart';
import '../../../constants/home_page_constans.dart';
import '../../pages/add_transaction_page.dart';
import '../../pages/category_page.dart';

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
        provider.setSelectedIndex(i);
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColor.colorBlue,
      unselectedItemColor: AppColor.colorGrey,
      items: [
        const BottomNavigationBarItem(
            icon: Icon(Icons.home), label: HomePageConstans.homePage),
        const BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined),
            label: CommonConstants.categories),
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
        const BottomNavigationBarItem(
            icon: Icon(Icons.track_changes), label: HomePageConstans.budget),
        const BottomNavigationBarItem(
            icon: Icon(Icons.settings), label: HomePageConstans.settings),
      ],
    );
  }
}
