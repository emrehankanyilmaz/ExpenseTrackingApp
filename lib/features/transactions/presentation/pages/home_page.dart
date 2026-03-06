import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_color_constans.dart';
import '../../constants/home_page_constans.dart';
import '../providers/transaction_provider.dart';
import '../widgets/home/bottom_navigation.dart';
import '../widgets/home/recent_transactions.dart';
import '../widgets/home/summary_card.dart';
import '../widgets/home/weekly_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _HomeView();
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final transactionProvider = context.watch<TransactionProvider>();

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.colorWhite,
        centerTitle: true,
        title: const Text(
          HomePageConstans.expenseTracking,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColor.colorBlack,
              fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SummaryCard(provider: transactionProvider),
            const SizedBox(height: 16),
            const WeeklyCard(),
            const SizedBox(height: 16),
            const RecentTransactions(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(provider: transactionProvider),
    );
  }
}
