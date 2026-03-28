import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gider_takip/features/transactions/data/models/category_type.dart';
import 'package:provider/provider.dart';
import 'package:gider_takip/features/transactions/constants/app_icons_constants.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/common/icon_container_widget.dart';
import '../../constants/app_color_constans.dart';
import '../providers/category_provider.dart';
import '../../data/models/category_model.dart';

extension CategoryDialogs on BuildContext {
  void showCategoryDialog({CategoryModel? category}) {
    final provider = read<CategoryProvider>();
    final nameController = TextEditingController(text: category?.name ?? '');
    String selectedIconName = category?.iconName ?? AppIcons.values[0].iconName;
    CategoryType selectedType = category?.type ?? CategoryType.expense;

    showDialog(
      context: this,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title:
              Text(category == null ? 'addCategory'.tr() : 'editCategory'.tr()),
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
              child: Text('cancel'.tr()),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.trim().isEmpty) return;
                if (category == null) {
                  await provider.addCategory(
                    name: nameController.text.trim(),
                    iconName: selectedIconName,
                    type: selectedType,
                  );
                } else {
                  await provider.updateCategory(
                    CategoryModel(
                      id: category.id,
                      name: nameController.text.trim(),
                      iconName: selectedIconName,
                      type: selectedType,
                    ),
                  );
                }
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: Text('save'.tr()),
            ),
          ],
        ),
      ),
    );
  }

  void showDeleteConfirmDialog(int id) {
    showDialog(
      context: this,
      builder: (ctx) => AlertDialog(
        title: Text('deleteCategory'.tr()),
        content: Text('deleteConfirmation'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('cancel'.tr()),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColor.colorRed),
            onPressed: () async {
              await read<CategoryProvider>().deleteCategory(id);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: Text(
              'delete'.tr(),
              style: const TextStyle(color: AppColor.colorWhite),
            ),
          ),
        ],
      ),
    );
  }
}

class TypeToggle extends StatelessWidget {
  const TypeToggle(
      {super.key, required this.selectedType, required this.onTypeChanged});

  final CategoryType selectedType;
  final void Function(CategoryType) onTypeChanged;

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
            label: 'expense'.tr(),
            type: CategoryType.expense,
            selectedType: selectedType,
            onTap: () => onTypeChanged(CategoryType.expense),
          ),
          TypeToggleButton(
            label: 'income'.tr(),
            type: CategoryType.income,
            selectedType: selectedType,
            onTap: () => onTypeChanged(CategoryType.income),
          ),
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
  final CategoryType type;
  final CategoryType selectedType;
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
        hintText: 'categoryName'.tr(),
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
        Text('selectIcon'.tr(),
            style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AppIcons.values.map((categoryIcon) {
            final isSelected = selectedIconName == categoryIcon.iconName;
            return GestureDetector(
              onTap: () => onIconSelected(categoryIcon.iconName),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: isSelected
                      ? Border.all(color: categoryIcon.color, width: 2)
                      : null,
                ),
                child: IconContainerWidget(
                    categoryIcon: categoryIcon, size: 52, iconSize: 28),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
