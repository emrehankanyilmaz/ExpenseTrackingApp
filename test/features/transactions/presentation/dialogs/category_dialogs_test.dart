import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gider_takip/features/transactions/constants/app_icons_constants.dart';
import 'package:gider_takip/features/transactions/data/models/category_model.dart';
import 'package:gider_takip/features/transactions/data/models/category_type.dart';
import 'package:gider_takip/features/transactions/presentation/dialogs/category_dialogs.dart';
import 'package:gider_takip/features/transactions/presentation/providers/category_provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockCategoryProvider extends Mock implements CategoryProvider {}

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  late MockCategoryProvider mockCategoryProvider;

  setUpAll(() {
    registerFallbackValue(CategoryModel(
      name: '',
      iconName: AppIcons.values[0].iconName,
      type: CategoryType.expense,
    ));
  });

  setUp(() {
    mockCategoryProvider = MockCategoryProvider();

    when(() => mockCategoryProvider.addCategory(
          name: any(named: 'name'),
          iconName: any(named: 'iconName'),
          type: any(named: 'type'),
        )).thenAnswer((_) async {});

    when(() => mockCategoryProvider.updateCategory(any()))
        .thenAnswer((_) async {});

    when(() => mockCategoryProvider.deleteCategory(any()))
        .thenAnswer((_) async {});

    when(() => mockCategoryProvider.categories).thenReturn([]);
  });

  Widget buildTestWidget(Widget child) {
    return EasyLocalization(
      supportedLocales: const [Locale('tr'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('tr'),
      startLocale: const Locale('tr'),
      child: Builder(
        builder: (context) => ChangeNotifierProvider<CategoryProvider>.value(
          value: mockCategoryProvider,
          child: MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            home: Scaffold(body: child),
          ),
        ),
      ),
    );
  }

  group('CategoryDialogs', () {
    testWidgets('showCategoryDialog — yeni kategori ekler', (tester) async {
      await tester.pumpWidget(buildTestWidget(Builder(
        builder: (context) {
          Future.microtask(() => context.showCategoryDialog());
          return Container();
        },
      )));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Test Kategori');
      await tester.tap(find.text('save'.tr()));
      await tester.pumpAndSettle();

      verify(() => mockCategoryProvider.addCategory(
            name: 'Test Kategori',
            iconName: any(named: 'iconName'),
            type: CategoryType.expense,
          )).called(1);
    });

    testWidgets('showCategoryDialog — mevcut kategoriyi günceller',
        (tester) async {
      final existingCategory = CategoryModel(
        id: 1,
        name: 'Eski İsim',
        iconName: AppIcons.values[0].iconName,
        type: CategoryType.expense,
      );

      await tester.pumpWidget(buildTestWidget(Builder(
        builder: (context) {
          Future.microtask(
              () => context.showCategoryDialog(category: existingCategory));
          return Container();
        },
      )));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Yeni İsim');
      await tester.tap(find.text('save'.tr()));
      await tester.pumpAndSettle();

      final captured =
          verify(() => mockCategoryProvider.updateCategory(captureAny()))
              .captured;
      expect((captured.first as CategoryModel).name, 'Yeni İsim');
      expect((captured.first as CategoryModel).id, 1);
    });

    testWidgets('showCategoryDialog — boş isimle kaydetme yapılmaz',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(Builder(
        builder: (context) {
          Future.microtask(() => context.showCategoryDialog());
          return Container();
        },
      )));
      await tester.pumpAndSettle();

      await tester.tap(find.text('save'.tr()));
      await tester.pumpAndSettle();

      verifyNever(() => mockCategoryProvider.addCategory(
            name: any(named: 'name'),
            iconName: any(named: 'iconName'),
            type: any(named: 'type'),
          ));
    });

    testWidgets('showCategoryDialog — iptal butonu dialogu kapatır',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(Builder(
        builder: (context) {
          Future.microtask(() => context.showCategoryDialog());
          return Container();
        },
      )));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      await tester.tap(find.text('cancel'.tr()));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('showDeleteConfirmDialog — kategoriyi siler', (tester) async {
      await tester.pumpWidget(buildTestWidget(Builder(
        builder: (context) {
          Future.microtask(() => context.showDeleteConfirmDialog(1));
          return Container();
        },
      )));
      await tester.pumpAndSettle();

      await tester.tap(find.text('delete'.tr()));
      await tester.pumpAndSettle();

      verify(() => mockCategoryProvider.deleteCategory(1)).called(1);
    });

    testWidgets('showDeleteConfirmDialog — iptal butonu dialogu kapatır',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(Builder(
        builder: (context) {
          Future.microtask(() => context.showDeleteConfirmDialog(1));
          return Container();
        },
      )));
      await tester.pumpAndSettle();

      await tester.tap(find.text('cancel'.tr()));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
      verifyNever(() => mockCategoryProvider.deleteCategory(any()));
    });

    testWidgets('TypeToggle — gelir seçimi çalışır', (tester) async {
      CategoryType selectedType = CategoryType.expense;

      await tester.pumpWidget(buildTestWidget(
        StatefulBuilder(builder: (context, setState) {
          return TypeToggle(
            selectedType: selectedType,
            onTypeChanged: (type) => setState(() => selectedType = type),
          );
        }),
      ));

      await tester.tap(find.text('income'.tr()));
      await tester.pumpAndSettle();

      expect(selectedType, CategoryType.income);
    });

    testWidgets('TypeToggle — gider seçimi çalışır', (tester) async {
      CategoryType selectedType = CategoryType.income;

      await tester.pumpWidget(buildTestWidget(
        StatefulBuilder(builder: (context, setState) {
          return TypeToggle(
            selectedType: selectedType,
            onTypeChanged: (type) => setState(() => selectedType = type),
          );
        }),
      ));

      await tester.tap(find.text('expense'.tr()));
      await tester.pumpAndSettle();

      expect(selectedType, CategoryType.expense);
    });

    testWidgets('IconPicker — ikon seçimi çalışır', (tester) async {
      String selectedIcon = AppIcons.values[0].iconName;

      await tester.pumpWidget(buildTestWidget(
        StatefulBuilder(builder: (context, setState) {
          return SingleChildScrollView(
            child: IconPicker(
              selectedIconName: selectedIcon,
              onIconSelected: (name) => setState(() => selectedIcon = name),
            ),
          );
        }),
      ));

      await tester.tap(find.byType(GestureDetector).at(1));
      await tester.pumpAndSettle();

      expect(selectedIcon, AppIcons.values[1].iconName);
    });
  });
}
