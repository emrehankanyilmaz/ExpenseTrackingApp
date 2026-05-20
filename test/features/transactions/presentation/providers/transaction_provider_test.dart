import 'package:flutter_test/flutter_test.dart';
import 'package:gider_takip/features/transactions/data/models/category_model.dart';
import 'package:gider_takip/features/transactions/data/models/category_type.dart';
import 'package:gider_takip/features/transactions/data/models/date_filter.dart';
import 'package:gider_takip/features/transactions/data/models/transaction_model.dart';
import 'package:gider_takip/features/transactions/presentation/providers/transaction_provider.dart';
import '../../../../fakes/fake_transaction_repository.dart';

void main() {
  group('TransactionProvider', () {
    late TransactionProvider provider;
    late FakeTransactionRepository repository;

    setUp(() {
      repository = FakeTransactionRepository();
      provider = TransactionProvider(repository);
    });

    group('Initial State', () {
      test('transactions başlangıçta boş liste olmalıdır', () {
        expect(provider.transactions, isEmpty);
      });

      test('selectedIndex varsayılan olarak 0 olmalıdır', () {
        expect(provider.selectedIndex, 0);
      });

      test('selectedType varsayılan olarak expense olmalıdır', () {
        expect(provider.selectedType, CategoryType.expense);
      });

      test('selectedCategory başlangıçta null olmalıdır', () {
        expect(provider.selectedCategory, isNull);
      });

      test('selectedDate bugün olmalıdır', () {
        expect(provider.selectedDate.day, DateTime.now().day);
        expect(provider.selectedDate.month, DateTime.now().month);
        expect(provider.selectedDate.year, DateTime.now().year);
      });

      test('tüm filter değerleri başlangıçta null olmalıdır', () {
        expect(provider.filterStartDate, isNull);
        expect(provider.filterEndDate, isNull);
        expect(provider.filterMinAmount, isNull);
        expect(provider.filterMaxAmount, isNull);
        expect(provider.filterCategoryId, isNull);
        expect(provider.filterType, isNull);
      });
    });

    group('setSelectedIndex', () {
      test('selectedIndex değerini güncellenmeli', () {
        provider.setSelectedIndex(5);
        expect(provider.selectedIndex, 5);
      });

      test('listeners tetiklenmeli', () {
        var listenerCalled = false;
        provider.addListener(() {
          listenerCalled = true;
        });

        provider.setSelectedIndex(3);
        expect(listenerCalled, true);
      });
    });

    group('setSelectedType', () {
      test('selectedType değerini güncellemeli', () {
        provider.setSelectedType(CategoryType.income);
        expect(provider.selectedType, CategoryType.income);
      });

      test('selectedCategory null yapmalı', () {
        final category = CategoryModel(
          iconName: 'test_icon',
          id: 1,
          name: 'Test',
          type: CategoryType.income,
        );
        provider.setSelectedCategory(category);
        expect(provider.selectedCategory, isNotNull);

        provider.setSelectedType(CategoryType.expense);
        expect(provider.selectedCategory, isNull);
      });

      test('listeners tetiklenmeli', () {
        var listenerCalled = false;
        provider.addListener(() {
          listenerCalled = true;
        });

        provider.setSelectedType(CategoryType.income);
        expect(listenerCalled, true);
      });
    });

    group('setSelectedCategory', () {
      test('selectedCategory değerini güncellemeli', () {
        final category = CategoryModel(
          iconName: 'test_icon',
          id: 1,
          name: 'Test',
          type: CategoryType.income,
        );
        provider.setSelectedCategory(category);
        expect(provider.selectedCategory, category);
      });

      test('listeners tetiklenmeli', () {
        var listenerCalled = false;
        provider.addListener(() {
          listenerCalled = true;
        });

        final category = CategoryModel(
          iconName: 'test_icon',
          id: 2,
          name: 'Test2',
          type: CategoryType.expense,
        );
        provider.setSelectedCategory(category);
        expect(listenerCalled, true);
      });
    });

    group('setSelectedDate', () {
      test('selectedDate değerini güncellemeli', () {
        final date = DateTime(2024, 5, 15);
        provider.setSelectedDate(date);
        expect(provider.selectedDate, date);
      });

      test('listeners tetiklenmeli', () {
        var listenerCalled = false;
        provider.addListener(() {
          listenerCalled = true;
        });

        final date = DateTime(2024, 5, 20);
        provider.setSelectedDate(date);
        expect(listenerCalled, true);
      });
    });

    group('resetForm', () {
      test('selectedType expense olmalıdır', () {
        provider.setSelectedType(CategoryType.income);
        provider.resetForm();
        expect(provider.selectedType, CategoryType.expense);
      });

      test('selectedCategory null olmalıdır', () {
        final category = CategoryModel(
          iconName: 'test_icon',
          id: 1,
          name: 'Test',
          type: CategoryType.expense,
        );
        provider.setSelectedCategory(category);
        provider.resetForm();
        expect(provider.selectedCategory, isNull);
      });

      test('selectedDate bugün olmalıdır', () {
        final date = DateTime(2024, 5, 15);
        provider.setSelectedDate(date);
        provider.resetForm();
        expect(provider.selectedDate.day, DateTime.now().day);
        expect(provider.selectedDate.month, DateTime.now().month);
        expect(provider.selectedDate.year, DateTime.now().year);
      });
    });

    group('loadTransactions', () {
      test('repository\'den transactions yüklemeli', () async {
        final transaction = TransactionModel(
          id: 1,
          type: CategoryType.expense,
          categoryId: 1,
          amount: 100.0,
          transactionDate: DateTime.now(),
          description: 'Test',
        );
        await repository.insert(transaction);

        await provider.loadTransactions();
        expect(provider.transactions, isNotEmpty);
        expect(provider.transactions.length, 1);
      });

      test('transactions tarih sırasına göre sıralanmalıdır', () async {
        final t1 = TransactionModel(
          id: 1,
          type: CategoryType.expense,
          categoryId: 1,
          amount: 100.0,
          transactionDate: DateTime(2024, 5, 1),
          description: 'Test 1',
        );
        final t2 = TransactionModel(
          id: 2,
          type: CategoryType.expense,
          categoryId: 1,
          amount: 50.0,
          transactionDate: DateTime(2024, 5, 10),
          description: 'Test 2',
        );
        await repository.insert(t1);
        await repository.insert(t2);

        await provider.loadTransactions();
        expect(provider.transactions.length, 2);
        // Yeni tarih (May 10) ilk sırada olmalı
        expect(provider.transactions[0].description, 'Test 2');
        expect(provider.transactions[1].description, 'Test 1');
      });

      test('listeners tetiklenmeli', () async {
        var listenerCalled = false;
        provider.addListener(() {
          listenerCalled = true;
        });

        await provider.loadTransactions();
        expect(listenerCalled, true);
      });
    });

    group('addTransaction', () {
      test('selectedCategory null ise false döndürmeli', () async {
        final result = await provider.addTransaction(
          amount: 100.0,
          description: 'Test',
        );
        expect(result, false);
      });

      test('geçerli kategori ile transaction eklemeli', () async {
        final category = CategoryModel(
          iconName: 'test_icon',
          id: 1,
          name: 'Test',
          type: CategoryType.expense,
        );
        provider.setSelectedCategory(category);

        final result = await provider.addTransaction(
          amount: 100.0,
          description: 'Test Expense',
        );

        expect(result, true);
        expect(provider.transactions, isNotEmpty);
        expect(provider.transactions[0].amount, 100.0);
        expect(provider.transactions[0].description, 'Test Expense');
      });

      test('form sıfırlanmalıdır', () async {
        final category = CategoryModel(
          iconName: 'test_icon',
          id: 1,
          name: 'Test',
          type: CategoryType.income,
        );
        provider.setSelectedType(CategoryType.income);
        provider.setSelectedCategory(category);
        final date = DateTime(2024, 5, 15);
        provider.setSelectedDate(date);

        await provider.addTransaction(
          amount: 200.0,
          description: 'Test Income',
        );

        expect(provider.selectedCategory, isNull);
        expect(provider.selectedType, CategoryType.expense);
        // selectedDate'in gün, ay, yıl bugün olduğunu kontrol et
        final now = DateTime.now();
        expect(provider.selectedDate.year, now.year);
        expect(provider.selectedDate.month, now.month);
        expect(provider.selectedDate.day, now.day);
      });
    });

    group('deleteTransaction', () {
      test('transaction silinmeli', () async {
        final transaction = TransactionModel(
          id: 1,
          type: CategoryType.expense,
          categoryId: 1,
          amount: 100.0,
          transactionDate: DateTime.now(),
          description: 'Test',
        );
        await repository.insert(transaction);
        await provider.loadTransactions();
        expect(provider.transactions.length, 1);

        await provider.deleteTransaction(1);
        expect(provider.transactions, isEmpty);
      });
    });

    group('updateTransaction', () {
      test('transaction güncellenli', () async {
        final transaction = TransactionModel(
          id: 1,
          type: CategoryType.expense,
          categoryId: 1,
          amount: 100.0,
          transactionDate: DateTime.now(),
          description: 'Original',
        );
        await repository.insert(transaction);
        await provider.loadTransactions();

        final updated = TransactionModel(
          id: 1,
          type: CategoryType.expense,
          categoryId: 1,
          amount: 200.0,
          transactionDate: DateTime.now(),
          description: 'Updated',
        );
        await provider.updateTransaction(updated);
        expect(provider.transactions[0].amount, 200.0);
        expect(provider.transactions[0].description, 'Updated');
      });
    });

    group('totalIncome', () {
      test('gelir işlemlerinin toplamını hesaplamalı', () async {
        final t1 = TransactionModel(
          id: 1,
          type: CategoryType.income,
          categoryId: 1,
          amount: 100.0,
          transactionDate: DateTime.now(),
          description: 'Income 1',
        );
        final t2 = TransactionModel(
          id: 2,
          type: CategoryType.income,
          categoryId: 1,
          amount: 200.0,
          transactionDate: DateTime.now(),
          description: 'Income 2',
        );
        final t3 = TransactionModel(
          id: 3,
          type: CategoryType.expense,
          categoryId: 1,
          amount: 150.0,
          transactionDate: DateTime.now(),
          description: 'Expense',
        );
        provider.setTransactionsForTest([t1, t2, t3]);

        final total = provider.totalIncome(DateFilter.thisWeek);
        expect(total, 300.0);
      });

      test('çeşitli tarihlerle doğru hesaplamalı', () async {
        final now = DateTime.now();
        final monthAgo = DateTime(now.year, now.month - 1, 1);

        final t1 = TransactionModel(
          id: 1,
          type: CategoryType.income,
          categoryId: 1,
          amount: 100.0,
          transactionDate: now,
          description: 'Recent Income',
        );
        final t2 = TransactionModel(
          id: 2,
          type: CategoryType.income,
          categoryId: 1,
          amount: 50.0,
          transactionDate: monthAgo,
          description: 'Old Income',
        );
        provider.setTransactionsForTest([t1, t2]);

        final weekTotal = provider.totalIncome(DateFilter.thisWeek);
        expect(weekTotal, 100.0);
      });
    });

    group('totalExpense', () {
      test('gider işlemlerinin toplamını hesaplamalı', () async {
        final t1 = TransactionModel(
          id: 1,
          type: CategoryType.expense,
          categoryId: 1,
          amount: 100.0,
          transactionDate: DateTime.now(),
          description: 'Expense 1',
        );
        final t2 = TransactionModel(
          id: 2,
          type: CategoryType.expense,
          categoryId: 1,
          amount: 200.0,
          transactionDate: DateTime.now(),
          description: 'Expense 2',
        );
        final t3 = TransactionModel(
          id: 3,
          type: CategoryType.income,
          categoryId: 1,
          amount: 150.0,
          transactionDate: DateTime.now(),
          description: 'Income',
        );
        provider.setTransactionsForTest([t1, t2, t3]);

        final total = provider.totalExpense(DateFilter.thisWeek);
        expect(total, 300.0);
      });
    });

    group('netBalance', () {
      test('denge doğru hesaplanmalıdır', () async {
        final t1 = TransactionModel(
          id: 1,
          type: CategoryType.income,
          categoryId: 1,
          amount: 500.0,
          transactionDate: DateTime.now(),
          description: 'Income',
        );
        final t2 = TransactionModel(
          id: 2,
          type: CategoryType.expense,
          categoryId: 1,
          amount: 200.0,
          transactionDate: DateTime.now(),
          description: 'Expense',
        );
        provider.setTransactionsForTest([t1, t2]);

        final balance = provider.netBalance(DateFilter.thisWeek);
        expect(balance, 300.0);
      });
    });

    group('recentTransactions', () {
      test('son 5 işlemi döndürmeli', () async {
        final transactions = List.generate(
          7,
          (i) => TransactionModel(
            id: i + 1,
            type: CategoryType.expense,
            categoryId: 1,
            amount: double.parse('${i + 1}00.0'),
            transactionDate: DateTime.now().subtract(Duration(days: i)),
            description: 'Transaction $i',
          ),
        );
        provider.setTransactionsForTest(transactions);

        final recent = provider.recentTransactions;
        expect(recent.length, 5);
      });
    });

    group('applyFilter', () {
      test('tüm filter değerlerini ayarlamalı', () {
        final startDate = DateTime(2024, 5, 1);
        final endDate = DateTime(2024, 5, 31);

        provider.applyFilter(
          startDate: startDate,
          endDate: endDate,
          minAmount: 100.0,
          maxAmount: 500.0,
          categoryId: 1,
          type: CategoryType.income,
        );

        expect(provider.filterStartDate, startDate);
        expect(provider.filterEndDate, endDate);
        expect(provider.filterMinAmount, 100.0);
        expect(provider.filterMaxAmount, 500.0);
        expect(provider.filterCategoryId, 1);
        expect(provider.filterType, CategoryType.income);
      });

      test('listeners tetiklenmeli', () {
        var listenerCalled = false;
        provider.addListener(() {
          listenerCalled = true;
        });

        provider.applyFilter(startDate: DateTime.now());
        expect(listenerCalled, true);
      });
    });

    group('loadMore', () {
      test('sayfa artmalıdır', () {
        final transactions = List.generate(
          30,
          (i) => TransactionModel(
            id: i + 1,
            type: CategoryType.expense,
            categoryId: 1,
            amount: 100.0,
            transactionDate: DateTime.now(),
            description: 'Transaction $i',
          ),
        );
        provider.setTransactionsForTest(transactions);

        final initialCount = provider.filteredTransactions.length;
        provider.loadMore();
        final newCount = provider.filteredTransactions.length;

        expect(newCount, greaterThan(initialCount));
      });
    });

    group('hasActiveFilter', () {
      test('filter yokken false döndürmeli', () {
        expect(provider.hasActiveFilter, false);
      });

      test('herhangi bir filter var iken true döndürmeli', () {
        provider.applyFilter(startDate: DateTime.now());
        expect(provider.hasActiveFilter, true);
      });

      test('endDate filter ile true döndürmeli', () {
        provider.applyFilter(endDate: DateTime.now());
        expect(provider.hasActiveFilter, true);
      });
    });

    group('filteredTransactions', () {
      test('minAmount filtresi çalışmalı', () {
        final now = DateTime.now();
        final t1 = TransactionModel(
          id: 1,
          type: CategoryType.expense,
          categoryId: 1,
          amount: 100.0,
          transactionDate: now,
          description: 'Expensive',
        );
        final t2 = TransactionModel(
          id: 2,
          type: CategoryType.expense,
          categoryId: 2,
          amount: 50.0,
          transactionDate: now,
          description: 'Cheap',
        );
        provider.setTransactionsForTest([t1, t2]);

        provider.applyFilter(minAmount: 75.0);
        final filtered = provider.filteredTransactions;

        expect(filtered.length, 1);
        expect(filtered[0].amount, 100.0);
      });

      test('tarih filtreleme yapmalı', () {
        final startDate = DateTime(2024, 5, 10);
        final endDate = DateTime(2024, 5, 20);

        final t1 = TransactionModel(
          id: 1,
          type: CategoryType.expense,
          categoryId: 1,
          amount: 100.0,
          transactionDate: DateTime(2024, 5, 5),
          description: 'Before',
        );
        final t2 = TransactionModel(
          id: 2,
          type: CategoryType.expense,
          categoryId: 1,
          amount: 100.0,
          transactionDate: DateTime(2024, 5, 15),
          description: 'Inside',
        );
        final t3 = TransactionModel(
          id: 3,
          type: CategoryType.expense,
          categoryId: 1,
          amount: 100.0,
          transactionDate: DateTime(2024, 5, 25),
          description: 'After',
        );
        provider.setTransactionsForTest([t1, t2, t3]);

        provider.applyFilter(startDate: startDate, endDate: endDate);
        final filtered = provider.filteredTransactions;

        expect(filtered.length, 1);
        expect(filtered[0].description, 'Inside');
      });

      test('kategori filtreleme yapmalı', () {
        final t1 = TransactionModel(
          id: 1,
          type: CategoryType.expense,
          categoryId: 1,
          amount: 100.0,
          transactionDate: DateTime.now(),
          description: 'Cat 1',
        );
        final t2 = TransactionModel(
          id: 2,
          type: CategoryType.expense,
          categoryId: 2,
          amount: 100.0,
          transactionDate: DateTime.now(),
          description: 'Cat 2',
        );
        provider.setTransactionsForTest([t1, t2]);

        provider.applyFilter(categoryId: 1);
        final filtered = provider.filteredTransactions;

        expect(filtered.length, 1);
        expect(filtered[0].categoryId, 1);
      });

      test('tür filtreleme yapmalı', () {
        final t1 = TransactionModel(
          id: 1,
          type: CategoryType.income,
          categoryId: 1,
          amount: 100.0,
          transactionDate: DateTime.now(),
          description: 'Income',
        );
        final t2 = TransactionModel(
          id: 2,
          type: CategoryType.expense,
          categoryId: 1,
          amount: 100.0,
          transactionDate: DateTime.now(),
          description: 'Expense',
        );
        provider.setTransactionsForTest([t1, t2]);

        provider.applyFilter(type: CategoryType.income);
        final filtered = provider.filteredTransactions;

        expect(filtered.length, 1);
        expect(filtered[0].type, CategoryType.income);
      });

      test('sonuçları tarih sırasında döndürmeli', () {
        final t1 = TransactionModel(
          id: 1,
          type: CategoryType.expense,
          categoryId: 1,
          amount: 100.0,
          transactionDate: DateTime(2024, 5, 10),
          description: 'Old',
        );
        final t2 = TransactionModel(
          id: 2,
          type: CategoryType.expense,
          categoryId: 1,
          amount: 100.0,
          transactionDate: DateTime(2024, 5, 20),
          description: 'New',
        );
        provider.setTransactionsForTest([t1, t2]);

        final filtered = provider.filteredTransactions;
        expect(filtered.length, 2);
        // Yeni tarih (May 20) ilk sırada olmalı
        expect(filtered.length, 2);
        // Yeni tarih (May 20) ilk sırada olmalı
        expect(filtered[0].description, 'New');
        expect(filtered[1].description, 'Old');
      });
    });

    group('hasMore', () {
      test('daha fazla transaction var iken true döndürmeli', () {
        final transactions = List.generate(
          25,
          (i) => TransactionModel(
            id: i + 1,
            type: CategoryType.expense,
            categoryId: 1,
            amount: 100.0,
            transactionDate: DateTime.now(),
            description: 'Transaction $i',
          ),
        );
        provider.setTransactionsForTest(transactions);

        expect(provider.hasMore, true);
      });

      test('tüm transactions yüklendiğinde false döndürmeli', () {
        final transactions = List.generate(
          5,
          (i) => TransactionModel(
            id: i + 1,
            type: CategoryType.expense,
            categoryId: 1,
            amount: 100.0,
            transactionDate: DateTime.now(),
            description: 'Transaction $i',
          ),
        );
        provider.setTransactionsForTest(transactions);

        expect(provider.hasMore, false);
      });
    });

    group('getExpensesByFilter', () {
      test('haftalık harcamaları günlere göre gruplandırmalı', () {
        final now = DateTime.now();
        final t1 = TransactionModel(
          id: 1,
          type: CategoryType.expense,
          categoryId: 1,
          amount: 100.0,
          transactionDate: now,
          description: 'Expense',
        );
        provider.setTransactionsForTest([t1]);

        final expenses = provider.getExpensesByFilter(DateFilter.thisWeek);
        expect(expenses.isNotEmpty, true);
      });

      test('aylık harcamaları haftaya göre gruplandırmalı', () {
        final now = DateTime.now();
        final t1 = TransactionModel(
          id: 1,
          type: CategoryType.expense,
          categoryId: 1,
          amount: 100.0,
          transactionDate: now,
          description: 'Expense',
        );
        provider.setTransactionsForTest([t1]);

        final expenses = provider.getExpensesByFilter(DateFilter.thisMonth);
        expect(expenses.isNotEmpty, true);
        expect(expenses.keys.toList().toString().contains('Hafta'), true);
      });

      test('3 aylık harcamaları aya göre gruplandırmalı', () {
        final now = DateTime.now();
        final t1 = TransactionModel(
          id: 1,
          type: CategoryType.expense,
          categoryId: 1,
          amount: 100.0,
          transactionDate: now,
          description: 'Expense',
        );
        provider.setTransactionsForTest([t1]);

        final expenses =
            provider.getExpensesByFilter(DateFilter.lastThreeMonths);
        expect(expenses.isNotEmpty, true);
      });
    });

    group('Pagination', () {
      test('sayfa numarası sıfırlanmalıdır filter uygulandığında', () {
        final transactions = List.generate(
          30,
          (i) => TransactionModel(
            id: i + 1,
            type: CategoryType.expense,
            categoryId: 1,
            amount: 100.0,
            transactionDate: DateTime.now(),
            description: 'Transaction $i',
          ),
        );
        provider.setTransactionsForTest(transactions);
        provider.loadMore();

        provider.applyFilter(minAmount: 50.0);
        expect(provider.filteredTransactions.length, 10);
      });
    });
  });
}
