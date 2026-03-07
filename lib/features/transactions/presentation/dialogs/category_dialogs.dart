import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gider_takip/features/transactions/constants/app_icons_constants.dart';
import 'package:gider_takip/features/transactions/constants/category_constants.dart';
import 'package:gider_takip/features/transactions/constants/common_constans.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/common/icon_container_widget.dart';
import '../../constants/app_color_constans.dart';
import '../providers/category_provider.dart';
import '../../data/models/category_model.dart';

class CategoryDialogs {
  CategoryDialogs._();

  static void showCategoryDialog(BuildContext context,
      {CategoryModel? category}) {
    final provider = context.read<CategoryProvider>();
    final nameController = TextEditingController(text: category?.name ?? '');
    String selectedIconName = category?.iconName ?? AppIcons.values[0].name;
    int selectedType = category?.type ?? 0;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(category == null
              ? CategoryConstants.addCategory
              : CategoryConstants.editCategory),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TypeToggle(
                  selectedType: selectedType,
                  onTypeChanged: (type) => setState(() => selectedType = type),
                ),
                const SizedBox(height: 16),
                NameField(controller: nameController),
                const SizedBox(height: 16),
                IconPicker(
                  selectedIconName: selectedIconName,
                  onIconSelected: (name) =>
                      setState(() => selectedIconName = name),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(CommonConstants.cancel),
            ),
            ElevatedButton(
              onPressed: () => _saveCategory(
                ctx: ctx,
                provider: provider,
                category: category,
                name: nameController.text.trim(),
                iconName: selectedIconName,
                type: selectedType,
              ),
              child: const Text(CommonConstants.save),
            ),
          ],
        ),
      ),
    );
  }

  static void showDeleteConfirmDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(CategoryConstants.deleteCategory),
        content: const Text(CategoryConstants.deleteConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(CommonConstants.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColor.colorRed),
            onPressed: () async {
              await context.read<CategoryProvider>().deleteCategory(id);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text(
              CommonConstants.delete,
              style: TextStyle(color: AppColor.colorWhite),
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> _saveCategory({
    required BuildContext ctx,
    required CategoryProvider provider,
    required CategoryModel? category,
    required String name,
    required String iconName,
    required int type,
  }) async {
    if (name.isEmpty) return;

    if (category == null) {
      await provider.addCategory(name: name, iconName: iconName, type: type);
    } else {
      await provider.updateCategory(
        CategoryModel(
            id: category.id, name: name, iconName: iconName, type: type),
      );
    }

    if (ctx.mounted) Navigator.pop(ctx);
  }
}

class TypeToggle extends StatelessWidget {
  const TypeToggle(
      {super.key, required this.selectedType, required this.onTypeChanged});

  final int selectedType;
  final void Function(int) onTypeChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.colorGrey100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          TypeToggleButton(
              label: CommonConstants.expense,
              type: 0,
              selectedType: selectedType,
              onTap: () => onTypeChanged(0)),
          TypeToggleButton(
              label: CommonConstants.income,
              type: 1,
              selectedType: selectedType,
              onTap: () => onTypeChanged(1)),
        ],
      ),
    );
  }
}

class TypeToggleButton extends StatelessWidget {
  const TypeToggleButton({
    super.key,
    required this.label,
    required this.type,
    required this.selectedType,
    required this.onTap,
  });

  final String label;
  final int type;
  final int selectedType;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedType == type;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColor.colorRed : AppColor.colorTransparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? AppColor.colorWhite : AppColor.colorGrey600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NameField extends StatelessWidget {
  const NameField({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: CategoryConstants.categoryName,
        filled: true,
        fillColor: AppColor.colorGrey100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class IconPicker extends StatelessWidget {
  const IconPicker(
      {super.key,
      required this.selectedIconName,
      required this.onIconSelected});

  final String selectedIconName;
  final void Function(String) onIconSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(CommonConstants.selectIcon,
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          //burası değişti
          children: AppIcons.values.map((categoryIcon) {
            final isSelected = selectedIconName == categoryIcon.name;
            return GestureDetector(
              onTap: () => onIconSelected(categoryIcon.name),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: isSelected
                      ? Border.all(color: categoryIcon.color, width: 2)
                      : null,
                ),
                child: IconContainerWidget(
                  categoryIcon: categoryIcon,
                  size: 52,
                  iconSize: 28,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
