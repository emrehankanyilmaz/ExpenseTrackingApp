import 'package:flutter_test/flutter_test.dart';
import 'package:gider_takip/features/transactions/data/models/category_model.dart';
import 'package:gider_takip/features/transactions/data/models/category_type.dart';
import 'package:gider_takip/features/transactions/presentation/providers/category_provider.dart';
import '../../../../fakes/fake_category_repository.dart';

void main() {
  group('CategoryProvider', () {
    late CategoryProvider provider;
    late FakeCategoryRepository repository;

    setUp(() {
      repository = FakeCategoryRepository();
      provider = CategoryProvider(categoryRepository: repository);
    });

    tearDown(() {
      repository.clearData();
    });

    group('Initial State', () {
      test('categories başlangıçta boş liste olmalıdır', () {
        expect(provider.categories, isEmpty);
      });

      test('expenseCategories başlangıçta boş liste olmalıdır', () {
        expect(provider.expenseCategories, isEmpty);
      });

      test('incomeCategories başlangıçta boş liste olmalıdır', () {
        expect(provider.incomeCategories, isEmpty);
      });
    });

    group('loadCategories', () {
      test('kategorileri başarıyla yüklemeli', () async {
        // Önce bazı kategoriler ekleyelim
        await repository.insertCategory(
            'Yemek', 'restaurant', CategoryType.expense);
        await repository.insertCategory('Maaş', 'salary', CategoryType.income);

        // Kategorileri provider'a yükleyelim
        await provider.loadCategories();
        expect(provider.categories, isNotEmpty);
        expect(provider.categories.length, 2);
      });

      test('listeners tetiklenmeli', () async {
        var listenerCalled = false;
        provider.addListener(() {
          listenerCalled = true;
        });

        await provider.loadCategories();
        expect(listenerCalled, true);
      });
    });

    group('addCategory', () {
      test('kategori başarıyla eklemeli', () async {
        await provider.addCategory(
          name: 'Yemek',
          iconName: 'restaurant',
          type: CategoryType.expense,
        );

        expect(provider.categories, isNotEmpty);
        expect(provider.categories.first.name, 'Yemek');
        expect(provider.categories.first.iconName, 'restaurant');
        expect(provider.categories.first.type, CategoryType.expense);
      });

      test('listeners tetiklenmeli', () async {
        var listenerCalled = false;
        provider.addListener(() {
          listenerCalled = true;
        });

        await provider.addCategory(
          name: 'Test Category',
          iconName: 'test_icon',
          type: CategoryType.expense,
        );

        expect(listenerCalled, true);
      });

      test('birden fazla kategori eklenebilmeli', () async {
        await provider.addCategory(
          name: 'Kategori 1',
          iconName: 'icon1',
          type: CategoryType.expense,
        );
        await provider.addCategory(
          name: 'Kategori 2',
          iconName: 'icon2',
          type: CategoryType.income,
        );

        expect(provider.categories.length, 2);
      });
    });

    group('updateCategory', () {
      test('kategori başarıyla güncellemeli', () async {
        await provider.addCategory(
          name: 'Orijinal',
          iconName: 'original_icon',
          type: CategoryType.expense,
        );

        final categoryToUpdate = provider.categories.first;
        final updatedCategory = CategoryModel(
          name: 'Güncellenmiş',
          iconName: 'updated_icon',
          type: CategoryType.income,
          id: categoryToUpdate.id,
        );

        await provider.updateCategory(updatedCategory);

        expect(provider.categories.first.name, 'Güncellenmiş');
        expect(provider.categories.first.iconName, 'updated_icon');
        expect(provider.categories.first.type, CategoryType.income);
      });

      test('listeners tetiklenmeli', () async {
        await provider.addCategory(
          name: 'Test',
          iconName: 'test',
          type: CategoryType.expense,
        );

        var listenerCalled = false;
        provider.addListener(() {
          listenerCalled = true;
        });

        final category = provider.categories.first;
        final updatedCategory = CategoryModel(
          name: 'Yeni Ad',
          iconName: 'new_icon',
          type: category.type,
          id: category.id,
        );

        await provider.updateCategory(updatedCategory);
        expect(listenerCalled, true);
      });
    });

    group('deleteCategory', () {
      test('kategori başarıyla silinmeli', () async {
        await provider.addCategory(
          name: 'Silinecek',
          iconName: 'delete_icon',
          type: CategoryType.expense,
        );

        expect(provider.categories.length, 1);

        final categoryId = provider.categories.first.id!;
        await provider.deleteCategory(categoryId);

        expect(provider.categories, isEmpty);
      });

      test('listeners tetiklenmeli', () async {
        await provider.addCategory(
          name: 'Silinecek',
          iconName: 'delete_icon',
          type: CategoryType.expense,
        );

        var listenerCalled = false;
        provider.addListener(() {
          listenerCalled = true;
        });

        await provider.deleteCategory(provider.categories.first.id!);
        expect(listenerCalled, true);
      });

      test('birden fazla kategoriden bir tanesini silebilmeli', () async {
        await provider.addCategory(
          name: 'Kategori 1',
          iconName: 'icon1',
          type: CategoryType.expense,
        );
        await provider.addCategory(
          name: 'Kategori 2',
          iconName: 'icon2',
          type: CategoryType.income,
        );

        expect(provider.categories.length, 2);

        final firstId = provider.categories.first.id!;
        await provider.deleteCategory(firstId);

        expect(provider.categories.length, 1);
        expect(provider.categories.first.name, 'Kategori 2');
      });
    });

    group('getCategoryById', () {
      test('id\'ye göre kategoryi bulmalı', () async {
        await provider.addCategory(
          name: 'Aranan Kategori',
          iconName: 'search_icon',
          type: CategoryType.expense,
        );

        final categoryId = provider.categories.first.id!;
        final foundCategory = provider.getCategoryById(categoryId);

        expect(foundCategory, isNotNull);
        expect(foundCategory!.name, 'Aranan Kategori');
        expect(foundCategory.id, categoryId);
      });

      test('bulunamayan id için null döndürmeli', () {
        final result = provider.getCategoryById(999);
        expect(result, isNull);
      });

      test('birden fazla kategori olduğunda doğru olanı döndürmeli', () async {
        await provider.addCategory(
          name: 'Kategori 1',
          iconName: 'icon1',
          type: CategoryType.expense,
        );
        await provider.addCategory(
          name: 'Kategori 2',
          iconName: 'icon2',
          type: CategoryType.income,
        );

        final secondCategoryId = provider.categories[1].id!;
        final foundCategory = provider.getCategoryById(secondCategoryId);

        expect(foundCategory!.name, 'Kategori 2');
      });
    });

    group('expenseCategories', () {
      test('sadece gider kategorilerini döndürmeli', () async {
        await provider.addCategory(
          name: 'Yemek',
          iconName: 'food',
          type: CategoryType.expense,
        );
        await provider.addCategory(
          name: 'Maaş',
          iconName: 'salary',
          type: CategoryType.income,
        );
        await provider.addCategory(
          name: 'Ulaşım',
          iconName: 'transport',
          type: CategoryType.expense,
        );

        expect(provider.expenseCategories.length, 2);
        expect(
            provider.expenseCategories
                .every((c) => c.type == CategoryType.expense),
            true);
      });

      test('gider kategorisi yoksa boş liste döndürmeli', () async {
        await provider.addCategory(
          name: 'Maaş',
          iconName: 'salary',
          type: CategoryType.income,
        );

        expect(provider.expenseCategories, isEmpty);
      });
    });

    group('incomeCategories', () {
      test('sadece gelir kategorilerini döndürmeli', () async {
        await provider.addCategory(
          name: 'Yemek',
          iconName: 'food',
          type: CategoryType.expense,
        );
        await provider.addCategory(
          name: 'Maaş',
          iconName: 'salary',
          type: CategoryType.income,
        );
        await provider.addCategory(
          name: 'Bonus',
          iconName: 'bonus',
          type: CategoryType.income,
        );

        expect(provider.incomeCategories.length, 2);
        expect(
            provider.incomeCategories
                .every((c) => c.type == CategoryType.income),
            true);
      });

      test('gelir kategorisi yoksa boş liste döndürmeli', () async {
        await provider.addCategory(
          name: 'Yemek',
          iconName: 'food',
          type: CategoryType.expense,
        );

        expect(provider.incomeCategories, isEmpty);
      });
    });

    group('Integration Tests', () {
      test('tüm CRUD operasyonları çalışmalı', () async {
        // CREATE
        await provider.addCategory(
          name: 'Yemek',
          iconName: 'food',
          type: CategoryType.expense,
        );
        expect(provider.categories.length, 1);

        // READ
        final category =
            provider.getCategoryById(provider.categories.first.id!);
        expect(category, isNotNull);
        expect(category!.name, 'Yemek');

        // UPDATE
        final updatedCategory = CategoryModel(
          name: 'Restoran',
          iconName: 'restaurant',
          type: CategoryType.expense,
          id: category.id,
        );
        await provider.updateCategory(updatedCategory);
        expect(provider.categories.first.name, 'Restoran');

        // DELETE
        await provider.deleteCategory(category.id!);
        expect(provider.categories, isEmpty);
      });

      test('kategori listesi dinamik olarak güncellenebilmeli', () async {
        expect(provider.categories, isEmpty);
        expect(provider.expenseCategories, isEmpty);
        expect(provider.incomeCategories, isEmpty);

        await provider.addCategory(
          name: 'Gider 1',
          iconName: 'icon1',
          type: CategoryType.expense,
        );

        expect(provider.categories.length, 1);
        expect(provider.expenseCategories.length, 1);
        expect(provider.incomeCategories.length, 0);

        await provider.addCategory(
          name: 'Gelir 1',
          iconName: 'icon2',
          type: CategoryType.income,
        );

        expect(provider.categories.length, 2);
        expect(provider.expenseCategories.length, 1);
        expect(provider.incomeCategories.length, 1);
      });
    });
  });
}
