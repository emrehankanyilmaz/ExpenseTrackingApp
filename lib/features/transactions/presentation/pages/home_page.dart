import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../providers/category_provider.dart';
import 'add_transaction_page.dart';
import 'category_page.dart';

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
    final categoryProvider = context.watch<CategoryProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Gider Takip',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCard(transactionProvider),
            const SizedBox(height: 16),
            _buildWeeklyChart(transactionProvider),
            const SizedBox(height: 16),
            _buildRecentTransactions(
                context, transactionProvider, categoryProvider),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context, transactionProvider),
    );
  }

  Widget _buildSummaryCard(TransactionProvider provider) {
    final now = DateTime.now();
    const months = [
      'Ocak',
      'Şubat',
      'Mart',
      'Nisan',
      'Mayıs',
      'Haziran',
      'Temmuz',
      'Ağustos',
      'Eylül',
      'Ekim',
      'Kasım',
      'Aralık'
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${months[now.month - 1]} ${now.year}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              Text(
                '${provider.netBalance >= 0 ? '' : '- '}₺ ${provider.netBalance.abs().toStringAsFixed(0)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: provider.netBalance >= 0 ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      Text('₺ ${provider.totalIncome.toStringAsFixed(0)}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                      const Text('Gelir',
                          style:
                              TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      Text('- ₺ ${provider.totalExpense.toStringAsFixed(0)}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                      const Text('Gider',
                          style:
                              TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Bütçe Durumu',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('₺ ${provider.netBalance.toStringAsFixed(0)} | Kaldı',
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: provider.totalIncome > 0
                  ? (provider.totalExpense / provider.totalIncome).clamp(0, 1)
                  : 0,
              minHeight: 10,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
            ),
          ),
          const SizedBox(height: 6),
          Text(
              '₺ ${provider.totalExpense.toStringAsFixed(0)} / ₺ ${provider.totalIncome.toStringAsFixed(0)}',
              style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart(TransactionProvider provider) {
    final data = provider.weeklyExpenses;
    final maxVal =
        data.values.isEmpty ? 1.0 : data.values.reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Harcamalar',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('Bu Hafta', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: data.entries.map((e) {
                final isMax = e.value == maxVal && maxVal > 0;
                final barHeight = maxVal > 0 ? (e.value / maxVal) * 100 : 4.0;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (isMax)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(6)),
                        child: Text('₺${e.value.toStringAsFixed(0)}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 10)),
                      ),
                    const SizedBox(height: 4),
                    Container(
                      width: 28,
                      height: barHeight.clamp(4, 100),
                      decoration: BoxDecoration(
                        color: isMax ? Colors.blue : Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(e.key,
                        style:
                            const TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions(
    BuildContext context,
    TransactionProvider transactionProvider,
    CategoryProvider categoryProvider,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Son İşlemler',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            TextButton(
              onPressed: () {},
              child: const Text('Tümünü Gör',
                  style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
        ...transactionProvider.recentTransactions.map((t) {
          final category = categoryProvider.getCategoryById(t.categoryId);
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(category?.icon ?? '💰',
                        style: const TextStyle(fontSize: 22)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(category?.name ?? 'Bilinmiyor',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(t.description,
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${t.type == 0 ? '- ' : ''}₺ ${t.amount.toStringAsFixed(0)}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: t.type == 0 ? Colors.red : Colors.green),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildBottomNav(BuildContext context, TransactionProvider provider) {
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
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      items: [
        const BottomNavigationBarItem(
            icon: Icon(Icons.home), label: 'Ana Sayfa'),
        const BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined), label: 'Kategoriler'),
        BottomNavigationBarItem(
          icon: Container(
            width: 48,
            height: 48,
            decoration:
                const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
            child: const Icon(Icons.add, color: Colors.white),
          ),
          label: '',
        ),
        const BottomNavigationBarItem(
            icon: Icon(Icons.track_changes), label: 'Bütçe'),
        const BottomNavigationBarItem(
            icon: Icon(Icons.settings), label: 'Ayarlar'),
      ],
    );
  }
}
