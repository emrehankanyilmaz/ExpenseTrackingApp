import 'package:flutter/material.dart';
import 'package:gider_takip/features/transactions/constants/days_months_constants.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../providers/category_provider.dart';
import 'package:gider_takip/features/transactions/constants/app_icons_constants.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/common/icon_container_widget.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionProvider = context.watch<TransactionProvider>();
    final categoryProvider = context.watch<CategoryProvider>();
    final transactions = transactionProvider.filteredTransactions;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text('İşlemler',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
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
                onPressed: () => _showFilterSheet(
                    context, transactionProvider, categoryProvider),
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
      body: transactions.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_rounded,
                      size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('İşlem bulunamadı',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount:
                  transactions.length + (transactionProvider.hasMore ? 1 : 0),
              itemBuilder: (_, index) {
                if (index == transactions.length) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: TextButton(
                        onPressed: () => transactionProvider.loadMore(),
                        child: const Text('Daha Fazla Göster'),
                      ),
                    ),
                  );
                }

                final t = transactions[index];
                final category = categoryProvider.getCategoryById(t.categoryId);
                final categoryIcon =
                    AppIcons.fromName(category?.iconName ?? '');

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      IconContainerWidget(
                        categoryIcon: categoryIcon,
                        size: 46,
                        iconSize: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category?.name ?? 'Bilinmiyor',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            if (t.description.isNotEmpty)
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
                            '${t.type == 0 ? '- ' : '+ '}₺${t.amount.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: t.type == 0 ? Colors.red : Colors.green,
                            ),
                          ),
                          Text(
                            _formatDate(t.transactionDate),
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 11),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${WeekDaysConstants.months[date.month - 1]} ${date.year}';
  }

  void _showFilterSheet(
    BuildContext context,
    TransactionProvider transactionProvider,
    CategoryProvider categoryProvider,
  ) {
    DateTime? startDate = transactionProvider.filterStartDate;
    DateTime? endDate = transactionProvider.filterEndDate;
    double? minAmount = transactionProvider.filterMinAmount;
    double? maxAmount = transactionProvider.filterMaxAmount;
    int? selectedCategoryId = transactionProvider.filterCategoryId;
    int? selectedType = transactionProvider.filterType;

    final minController = TextEditingController(
        text: minAmount != null ? minAmount.toStringAsFixed(0) : '');
    final maxController = TextEditingController(
        text: maxAmount != null ? maxAmount.toStringAsFixed(0) : '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Filtrele',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    if (transactionProvider.hasActiveFilter)
                      TextButton(
                        onPressed: () {
                          transactionProvider.clearFilter();
                          Navigator.pop(ctx);
                        },
                        child: const Text('Temizle',
                            style: TextStyle(color: Colors.red)),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Tür',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildTypeChip(
                      label: 'Tümü',
                      isSelected: selectedType == null,
                      onTap: () => setSheetState(() => selectedType = null),
                    ),
                    const SizedBox(width: 8),
                    _buildTypeChip(
                      label: 'Gelir',
                      isSelected: selectedType == 1,
                      color: Colors.green,
                      onTap: () => setSheetState(() => selectedType = 1),
                    ),
                    const SizedBox(width: 8),
                    _buildTypeChip(
                      label: 'Gider',
                      isSelected: selectedType == 0,
                      color: Colors.red,
                      onTap: () => setSheetState(() => selectedType = 0),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Tarih Aralığı',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildDateButton(
                        label: startDate != null
                            ? '${startDate!.day}.${startDate!.month}.${startDate!.year}'
                            : 'Başlangıç',
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: ctx,
                            initialDate: startDate ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null)
                            setSheetState(() => startDate = picked);
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('—', style: TextStyle(color: Colors.grey)),
                    ),
                    Expanded(
                      child: _buildDateButton(
                        label: endDate != null
                            ? '${endDate!.day}.${endDate!.month}.${endDate!.year}'
                            : 'Bitiş',
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: ctx,
                            initialDate: endDate ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null)
                            setSheetState(() => endDate = picked);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Fiyat Aralığı',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildAmountField(
                        controller: minController,
                        hint: 'Min ₺',
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('—', style: TextStyle(color: Colors.grey)),
                    ),
                    Expanded(
                      child: _buildAmountField(
                        controller: maxController,
                        hint: 'Max ₺',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Kategori',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 8),
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildCategoryChip(
                        label: 'Tümü',
                        isSelected: selectedCategoryId == null,
                        onTap: () =>
                            setSheetState(() => selectedCategoryId = null),
                      ),
                      const SizedBox(width: 8),
                      ...categoryProvider.categories.map((cat) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _buildCategoryChip(
                            label: cat.name,
                            isSelected: selectedCategoryId == cat.id,
                            onTap: () => setSheetState(
                                () => selectedCategoryId = cat.id),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      transactionProvider.applyFilter(
                        startDate: startDate,
                        endDate: endDate,
                        minAmount: minController.text.isNotEmpty
                            ? double.tryParse(minController.text)
                            : null,
                        maxAmount: maxController.text.isNotEmpty
                            ? double.tryParse(maxController.text)
                            : null,
                        categoryId: selectedCategoryId,
                        type: selectedType,
                      );
                      Navigator.pop(ctx);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: const Text('Uygula',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeChip({
    required String label,
    required bool isSelected,
    Color color = Colors.blue,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.15) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? color : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected ? Colors.blue.withOpacity(0.15) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.blue : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildDateButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 13)),
            const Icon(Icons.calendar_today_outlined,
                size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountField({
    required TextEditingController controller,
    required String hint,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
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
      ),
    );
  }
}
