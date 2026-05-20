import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gider_takip/features/transactions/data/models/category_type.dart';
import 'package:gider_takip/features/transactions/data/models/date_filter.dart';
import 'package:gider_takip/features/transactions/data/models/transaction_model.dart';
import 'package:gider_takip/features/transactions/presentation/pages/transaction_page.dart';
import 'package:gider_takip/features/transactions/presentation/providers/category_provider.dart';
import 'package:gider_takip/features/transactions/presentation/providers/filter_provider.dart';
import 'package:gider_takip/features/transactions/presentation/providers/transaction_provider.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/transaction/filter_bottom_sheet.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/transaction/transaction_page_body.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockTransactionProvider extends Mock implements TransactionProvider {}

class MockCategoryProvider extends Mock implements CategoryProvider {}

class MockFilterProvider extends Mock implements FilterProvider {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockTransactionProvider mockTransactionProvider;
  late MockCategoryProvider mockCategoryProvider;
  late MockFilterProvider mockFilterProvider;

  setUpAll(() {
    registerFallbackValue(CategoryType.expense);
    registerFallbackValue(DateFilter.thisWeek);
  });

  setUp(() {
    mockTransactionProvider = MockTransactionProvider();
    mockCategoryProvider = MockCategoryProvider();
    mockFilterProvider = MockFilterProvider();

    when(() => mockTransactionProvider.filteredTransactions).thenReturn([]);
    when(() => mockTransactionProvider.hasActiveFilter).thenReturn(false);
    when(() => mockTransactionProvider.hasMore).thenReturn(false);
    when(() => mockTransactionProvider.selectedIndex).thenReturn(0);
    when(() => mockTransactionProvider.transactions).thenReturn([]);
    when(() => mockTransactionProvider.recentTransactions).thenReturn([]);
    when(() => mockTransactionProvider.totalIncome(any())).thenReturn(0);
    when(() => mockTransactionProvider.totalExpense(any())).thenReturn(0);
    when(() => mockTransactionProvider.netBalance(any())).thenReturn(0);
    when(() => mockTransactionProvider.getExpensesByFilter(any()))
        .thenReturn({});
    when(() => mockTransactionProvider.addListener(any())).thenReturn(null);
    when(() => mockTransactionProvider.removeListener(any())).thenReturn(null);

    when(() => mockCategoryProvider.categories).thenReturn([]);
    when(() => mockCategoryProvider.expenseCategories).thenReturn([]);
    when(() => mockCategoryProvider.incomeCategories).thenReturn([]);
    when(() => mockCategoryProvider.addListener(any())).thenReturn(null);
    when(() => mockCategoryProvider.removeListener(any())).thenReturn(null);

    when(() => mockFilterProvider.dateFilter).thenReturn(DateFilter.thisWeek);
    when(() => mockFilterProvider.budgetFilter).thenReturn(DateFilter.thisWeek);
    when(() => mockFilterProvider.type).thenReturn(null);
    when(() => mockFilterProvider.categoryId).thenReturn(null);
    when(() => mockFilterProvider.startDate).thenReturn(null);
    when(() => mockFilterProvider.endDate).thenReturn(null);
    when(() => mockFilterProvider.minAmount).thenReturn(null);
    when(() => mockFilterProvider.maxAmount).thenReturn(null);
    when(() => mockFilterProvider.addListener(any())).thenReturn(null);
    when(() => mockFilterProvider.removeListener(any())).thenReturn(null);
  });

  Widget buildTestWidget() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TransactionProvider>.value(
            value: mockTransactionProvider),
        ChangeNotifierProvider<CategoryProvider>.value(
            value: mockCategoryProvider),
        ChangeNotifierProvider<FilterProvider>.value(value: mockFilterProvider),
      ],
      child: const MaterialApp(
        home: TransactionPage(),
      ),
    );
  }

  group('TransactionPage', () {
    testWidgets('AppBar gösterilir', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('filtre ikonu görünür', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.filter_list_rounded), findsOneWidget);
    });

    testWidgets('TransactionPageBody görünür', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(TransactionPageBody), findsOneWidget);
    });

    testWidgets('aktif filtre yokken mavi nokta görünmez', (tester) async {
      when(() => mockTransactionProvider.hasActiveFilter).thenReturn(false);

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('active_filter_dot')), findsNothing);
    });

    testWidgets('aktif filtre varken mavi nokta görünür', (tester) async {
      when(() => mockTransactionProvider.hasActiveFilter).thenReturn(true);

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('active_filter_dot')), findsOneWidget);
    });

    testWidgets('filtre butonuna basınca FilterBottomSheet açılır',
        (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.filter_list_rounded));
      await tester.pumpAndSettle();

      expect(find.byType(FilterBottomSheet), findsOneWidget);
    });

    testWidgets('işlem varken liste görünür', (tester) async {
      final transaction = TransactionModel(
        id: 1,
        type: CategoryType.expense,
        categoryId: 1,
        amount: 100,
        transactionDate: DateTime.now(),
        description: 'Test işlem',
      );

      when(() => mockTransactionProvider.filteredTransactions)
          .thenReturn([transaction]);
      when(() => mockCategoryProvider.getCategoryById(1)).thenReturn(null);

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('hasMore true iken daha fazla butonu görünür', (tester) async {
      final transaction = TransactionModel(
        id: 1,
        type: CategoryType.expense,
        categoryId: 1,
        amount: 100,
        transactionDate: DateTime.now(),
        description: 'Test',
      );

      when(() => mockTransactionProvider.filteredTransactions)
          .thenReturn([transaction]);
      when(() => mockTransactionProvider.hasMore).thenReturn(true);
      when(() => mockCategoryProvider.getCategoryById(1)).thenReturn(null);

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(TextButton), findsOneWidget);
    });
  });
}
