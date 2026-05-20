import 'package:flutter_test/flutter_test.dart';
import 'package:gider_takip/features/transactions/data/models/category_type.dart';
import 'package:gider_takip/features/transactions/data/models/date_filter.dart';
import 'package:gider_takip/features/transactions/presentation/providers/filter_provider.dart';

void main() {
  group('FilterProvider', () {
    late FilterProvider filterProvider;

    setUp(() {
      filterProvider = FilterProvider();
    });

    group('Initial State', () {
      test('dateFilter varsayılan olarak thisWeek olmalıdır', () {
        expect(filterProvider.dateFilter, DateFilter.thisWeek);
      });

      test('budgetFilter varsayılan olarak thisWeek olmalıdır', () {
        expect(filterProvider.budgetFilter, DateFilter.thisWeek);
      });

      test('startDate başlangıçta null olmalıdır', () {
        expect(filterProvider.startDate, isNull);
      });

      test('endDate başlangıçta null olmalıdır', () {
        expect(filterProvider.endDate, isNull);
      });

      test('minAmount başlangıçta null olmalıdır', () {
        expect(filterProvider.minAmount, isNull);
      });

      test('maxAmount başlangıçta null olmalıdır', () {
        expect(filterProvider.maxAmount, isNull);
      });

      test('categoryId başlangıçta null olmalıdır', () {
        expect(filterProvider.categoryId, isNull);
      });

      test('type başlangıçta null olmalıdır', () {
        expect(filterProvider.type, isNull);
      });
    });

    group('setWeeklyFilter', () {
      test('dateFilter değerini güncellemeli', () {
        filterProvider.setWeeklyFilter(DateFilter.thisMonth);
        expect(filterProvider.dateFilter, DateFilter.thisMonth);
      });

      test('listeners tetiklenmeli', () {
        var listenerCalled = false;
        filterProvider.addListener(() {
          listenerCalled = true;
        });

        filterProvider.setWeeklyFilter(DateFilter.thisMonth);
        expect(listenerCalled, true);
      });
    });

    group('setBudgetFilter', () {
      test('budgetFilter değerini güncellemeli', () {
        filterProvider.setBudgetFilter(DateFilter.thisMonth);
        expect(filterProvider.budgetFilter, DateFilter.thisMonth);
      });

      test('listeners tetiklenmeli', () {
        var listenerCalled = false;
        filterProvider.addListener(() {
          listenerCalled = true;
        });

        filterProvider.setBudgetFilter(DateFilter.thisMonth);
        expect(listenerCalled, true);
      });
    });

    group('setType', () {
      test('type değerini güncellemeli', () {
        filterProvider.setType(CategoryType.income);
        expect(filterProvider.type, CategoryType.income);
      });

      test('type null olarak ayarlanabilmeli', () {
        filterProvider.setType(CategoryType.expense);
        filterProvider.setType(null);
        expect(filterProvider.type, isNull);
      });

      test('listeners tetiklenmeli', () {
        var listenerCalled = false;
        filterProvider.addListener(() {
          listenerCalled = true;
        });

        filterProvider.setType(CategoryType.income);
        expect(listenerCalled, true);
      });
    });

    group('setCategory', () {
      test('categoryId değerini güncellemeli', () {
        filterProvider.setCategory(1);
        expect(filterProvider.categoryId, 1);
      });

      test('categoryId null olarak ayarlanabilmeli', () {
        filterProvider.setCategory(5);
        filterProvider.setCategory(null);
        expect(filterProvider.categoryId, isNull);
      });

      test('listeners tetiklenmeli', () {
        var listenerCalled = false;
        filterProvider.addListener(() {
          listenerCalled = true;
        });

        filterProvider.setCategory(10);
        expect(listenerCalled, true);
      });
    });

    group('setStartDate', () {
      test('startDate değerini güncellemeli', () {
        final date = DateTime(2024, 5, 1);
        filterProvider.setStartDate(date);
        expect(filterProvider.startDate, date);
      });

      test('startDate null olarak ayarlanabilmeli', () {
        filterProvider.setStartDate(DateTime(2024, 5, 1));
        filterProvider.setStartDate(null);
        expect(filterProvider.startDate, isNull);
      });

      test('listeners tetiklenmeli', () {
        var listenerCalled = false;
        filterProvider.addListener(() {
          listenerCalled = true;
        });

        filterProvider.setStartDate(DateTime(2024, 5, 1));
        expect(listenerCalled, true);
      });
    });

    group('setEndDate', () {
      test('endDate değerini güncellemeli', () {
        final date = DateTime(2024, 5, 31);
        filterProvider.setEndDate(date);
        expect(filterProvider.endDate, date);
      });

      test('endDate null olarak ayarlanabilmeli', () {
        filterProvider.setEndDate(DateTime(2024, 5, 31));
        filterProvider.setEndDate(null);
        expect(filterProvider.endDate, isNull);
      });

      test('listeners tetiklenmeli', () {
        var listenerCalled = false;
        filterProvider.addListener(() {
          listenerCalled = true;
        });

        filterProvider.setEndDate(DateTime(2024, 5, 31));
        expect(listenerCalled, true);
      });
    });

    group('setMinAmount', () {
      test('minAmount değerini güncellemeli', () {
        filterProvider.setMinAmount(100.0);
        expect(filterProvider.minAmount, 100.0);
      });

      test('minAmount null olarak ayarlanabilmeli', () {
        filterProvider.setMinAmount(50.0);
        filterProvider.setMinAmount(null);
        expect(filterProvider.minAmount, isNull);
      });

      test('listeners tetiklenmeli', () {
        var listenerCalled = false;
        filterProvider.addListener(() {
          listenerCalled = true;
        });

        filterProvider.setMinAmount(100.0);
        expect(listenerCalled, true);
      });
    });

    group('setMaxAmount', () {
      test('maxAmount değerini güncellemeli', () {
        filterProvider.setMaxAmount(500.0);
        expect(filterProvider.maxAmount, 500.0);
      });

      test('maxAmount null olarak ayarlanabilmeli', () {
        filterProvider.setMaxAmount(1000.0);
        filterProvider.setMaxAmount(null);
        expect(filterProvider.maxAmount, isNull);
      });

      test('listeners tetiklenmeli', () {
        var listenerCalled = false;
        filterProvider.addListener(() {
          listenerCalled = true;
        });

        filterProvider.setMaxAmount(500.0);
        expect(listenerCalled, true);
      });
    });

    group('reset', () {
      test('tüm filtre değerlerini null olarak sıfırlamalı', () {
        // Tüm değerleri ayarla
        filterProvider.setStartDate(DateTime(2024, 5, 1));
        filterProvider.setEndDate(DateTime(2024, 5, 31));
        filterProvider.setCategory(1);
        filterProvider.setType(CategoryType.income);

        // Reset çağır
        filterProvider.reset();

        // Değerlerin null olduğunu kontrol et
        expect(filterProvider.startDate, isNull);
        expect(filterProvider.endDate, isNull);
        expect(filterProvider.categoryId, isNull);
        expect(filterProvider.type, isNull);
      });

      test('listeners tetiklenmeli', () {
        var listenerCalled = false;
        filterProvider.addListener(() {
          listenerCalled = true;
        });

        filterProvider.reset();
        expect(listenerCalled, true);
      });

      test('dateFilter ve budgetFilter değişmemeli', () {
        filterProvider.setWeeklyFilter(DateFilter.thisMonth);

        filterProvider.reset();

        expect(filterProvider.dateFilter, DateFilter.thisMonth);
      });
    });

    group('Multiple Changes', () {
      test('ardışık değişiklikler düzgün çalışmalı', () {
        filterProvider.setType(CategoryType.income);
        filterProvider.setCategory(1);
        filterProvider.setMinAmount(100.0);
        filterProvider.setMaxAmount(500.0);

        expect(filterProvider.type, CategoryType.income);
        expect(filterProvider.categoryId, 1);
        expect(filterProvider.minAmount, 100.0);
        expect(filterProvider.maxAmount, 500.0);
      });

      test('her değişiklik listeners tetiklemeli', () {
        var listenerCallCount = 0;
        filterProvider.addListener(() {
          listenerCallCount++;
        });

        filterProvider.setType(CategoryType.income);
        filterProvider.setCategory(1);
        filterProvider.setMinAmount(100.0);
        filterProvider.setMaxAmount(500.0);

        expect(listenerCallCount, 4);
      });
    });
  });
}
