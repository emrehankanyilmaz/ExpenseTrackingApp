import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../providers/category_provider.dart';
import '../../data/models/category_model.dart';

class AddTransactionPage extends StatelessWidget {
  const AddTransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final amountController = TextEditingController();
    final descController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            context.read<TransactionProvider>().resetForm();
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'İşlem Ekle',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: _AddTransactionBody(
        amountController: amountController,
        descController: descController,
      ),
    );
  }
}

class _AddTransactionBody extends StatelessWidget {
  final TextEditingController amountController;
  final TextEditingController descController;

  const _AddTransactionBody({
    required this.amountController,
    required this.descController,
  });

  Future<void> _pickDate(
      BuildContext context, TransactionProvider provider) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: provider.selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) provider.setSelectedDate(picked);
  }

  Future<void> _save(BuildContext context) async {
    final provider = context.read<TransactionProvider>();

    if (amountController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tutar girin')),
      );
      return;
    }
    if (provider.selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen kategori seçin')),
      );
      return;
    }

    final success = await provider.addTransaction(
      amount: double.parse(amountController.text.trim()),
      description: descController.text.trim(),
    );

    if (success && context.mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider = context.watch<TransactionProvider>();
    final categoryProvider = context.watch<CategoryProvider>();

    final categories = transactionProvider.selectedType == 0
        ? categoryProvider.expenseCategories
        : categoryProvider.incomeCategories;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildToggle(transactionProvider),
                const SizedBox(height: 12),
                _buildCard(
                  child: TextField(
                    controller: amountController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '0',
                      hintStyle: TextStyle(fontSize: 32, color: Colors.grey),
                      prefixText: '₺ ',
                      prefixStyle:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _buildCard(
                  child: TextField(
                    controller: descController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Açıklama (isteğe bağlı)',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _buildCard(
                  child: GestureDetector(
                    onTap: () => _pickDate(context, transactionProvider),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Tarih',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            Text(
                              '${transactionProvider.selectedDate.day}.${transactionProvider.selectedDate.month}.${transactionProvider.selectedDate.year}',
                              style: const TextStyle(color: Colors.blue),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.calendar_today,
                                size: 16, color: Colors.blue),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Kategori',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 8),
                      categories.isEmpty
                          ? const Text('Henüz kategori yok',
                              style: TextStyle(color: Colors.grey))
                          : Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: categories
                                  .map((cat) => _buildCategoryChip(
                                      context, cat, transactionProvider))
                                  .toList(),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () => _save(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: transactionProvider.selectedType == 0
                    ? Colors.red
                    : Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: const Text(
                'Kaydet',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToggle(TransactionProvider provider) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          _buildTypeButton(
              label: 'Gider',
              type: 0,
              color: Colors.red,
              selectedType: provider.selectedType,
              onTap: () => provider.setSelectedType(0)),
          _buildTypeButton(
              label: 'Gelir',
              type: 1,
              color: Colors.green,
              selectedType: provider.selectedType,
              onTap: () => provider.setSelectedType(1)),
        ],
      ),
    );
  }

  Widget _buildTypeButton({
    required String label,
    required int type,
    required Color color,
    required int selectedType,
    required VoidCallback onTap,
  }) {
    final isSelected = selectedType == type;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(
      BuildContext context, CategoryModel cat, TransactionProvider provider) {
    final isSelected = provider.selectedCategory?.id == cat.id;
    return GestureDetector(
      onTap: () => provider.setSelectedCategory(cat),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (provider.selectedType == 0 ? Colors.red : Colors.green)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(cat.icon, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text(
              cat.name,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: child,
    );
  }
}
