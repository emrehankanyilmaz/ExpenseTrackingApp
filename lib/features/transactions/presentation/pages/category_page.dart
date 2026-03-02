import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/category_provider.dart';
import '../../data/models/category_model.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  static const List<String> _emojis = [
    '🛒',
    '🛍️',
    '🚗',
    '🏠',
    '💡',
    '📱',
    '👗',
    '🎮',
    '✈️',
    '🏥',
    '📚',
    '🎵',
    '💰',
    '📈',
    '🎁',
    '⚽',
    '🍔',
    '☕',
    '💊',
    '🐾',
  ];

  void _showDialog(BuildContext context, {CategoryModel? category}) {
    final provider = context.read<CategoryProvider>();
    final nameController = TextEditingController(text: category?.name ?? '');
    String selectedIcon = category?.icon ?? '🛒';
    int selectedType = category?.type ?? provider.selectedType;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(category == null ? 'Kategori Ekle' : 'Kategori Düzenle'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      _dialogTabButton(
                        label: 'Gider',
                        type: 0,
                        selectedType: selectedType,
                        color: Colors.red,
                        onTap: () => setDialogState(() => selectedType = 0),
                      ),
                      _dialogTabButton(
                        label: 'Gelir',
                        type: 1,
                        selectedType: selectedType,
                        color: Colors.green,
                        onTap: () => setDialogState(() => selectedType = 1),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Kategori adı',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('İkon Seç',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _emojis.map((emoji) {
                    final isSelected = selectedIcon == emoji;
                    return GestureDetector(
                      onTap: () => setDialogState(() => selectedIcon = emoji),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.blue.shade100
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: isSelected
                              ? Border.all(color: Colors.blue, width: 2)
                              : null,
                        ),
                        child:
                            Text(emoji, style: const TextStyle(fontSize: 20)),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.trim().isEmpty) return;
                if (category == null) {
                  await provider.addCategory(
                    name: nameController.text.trim(),
                    icon: selectedIcon,
                    type: selectedType,
                  );
                } else {
                  await provider.updateCategory(CategoryModel(
                    id: category.id,
                    name: nameController.text.trim(),
                    icon: selectedIcon,
                    type: selectedType,
                  ));
                }
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Kategoriyi Sil'),
        content: const Text('Bu kategoriyi silmek istiyor musunuz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () async {
              await context.read<CategoryProvider>().deleteCategory(id);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Sil', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CategoryProvider>();
    final categories = provider.filteredCategories;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text('Kategoriler',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.blue),
            onPressed: () => _showDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  _buildTabButton(
                    label: 'Gider',
                    type: 0,
                    color: Colors.red,
                    selectedType: provider.selectedType,
                    onTap: () => provider.setSelectedType(0),
                  ),
                  _buildTabButton(
                    label: 'Gelir',
                    type: 1,
                    color: Colors.green,
                    selectedType: provider.selectedType,
                    onTap: () => provider.setSelectedType(1),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: categories.isEmpty
                ? const Center(
                    child: Text('Henüz kategori yok',
                        style: TextStyle(color: Colors.grey)),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (_, index) {
                      final cat = categories[index];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: Text(cat.icon,
                                    style: const TextStyle(fontSize: 22)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(cat.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit_outlined,
                                  color: Colors.blue, size: 20),
                              onPressed: () =>
                                  _showDialog(context, category: cat),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: Colors.red, size: 20),
                              onPressed: () => _confirmDelete(context, cat.id!),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
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
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(label,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.grey)),
          ),
        ),
      ),
    );
  }

  Widget _dialogTabButton({
    required String label,
    required int type,
    required int selectedType,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isSelected = selectedType == type;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(label,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.grey)),
          ),
        ),
      ),
    );
  }
}
