import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gider_takip/features/transactions/data/models/category_type.dart';
import 'package:gider_takip/features/transactions/data/models/date_filter.dart';
import 'package:gider_takip/features/transactions/presentation/pages/home_page.dart';
import 'package:gider_takip/features/transactions/presentation/providers/category_provider.dart';
import 'package:gider_takip/features/transactions/presentation/providers/filter_provider.dart';
import 'package:gider_takip/features/transactions/presentation/providers/transaction_provider.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/home/bottom_navigation.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/home/recent_transactions.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/home/summary_card.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/home/weekly_card.dart';
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
        home: HomePage(),
      ),
    );
  }

  group('HomePage', () {
    testWidgets('AppBar gösterilir', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('SummaryCard gösterilir', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(SummaryCard), findsOneWidget);
    });

    testWidgets('WeeklyCard gösterilir', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(WeeklyCard), findsOneWidget);
    });

    testWidgets('RecentTransactions gösterilir', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(RecentTransactions), findsOneWidget);
    });

    testWidgets('BottomNavigation gösterilir', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(BottomNavigation), findsOneWidget);
    });

    testWidgets('body ScrollView içerir', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('BottomNavigation doğru index ile başlar', (tester) async {
      when(() => mockTransactionProvider.selectedIndex).thenReturn(0);

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });
  });
}
