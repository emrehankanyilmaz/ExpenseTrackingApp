import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gider_takip/features/transactions/data/models/category_model.dart';
import 'package:gider_takip/features/transactions/data/models/category_type.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/add_transaction/transaction_input_type.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  group('TransactionInputWidget', () {
    late List<CategoryModel> mockCategories;

    setUp(() {
      mockCategories = [
        CategoryModel(
          id: 1,
          name: 'Yemek',
          iconName: 'restaurant',
          type: CategoryType.expense,
        ),
        CategoryModel(
          id: 2,
          name: 'Ulaşım',
          iconName: 'directions_car',
          type: CategoryType.expense,
        ),
        CategoryModel(
          id: 3,
          name: 'Maaş',
          iconName: 'salary',
          type: CategoryType.income,
        ),
      ];
    });

    group('TransactionInputType.amount', () {
      testWidgets('BuildAmount widget renderlanmalı',
          (WidgetTester tester) async {
        final controller = TextEditingController();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TransactionInputWidget(
                type: TransactionInputType.amount,
                amountController: controller,
              ),
            ),
          ),
        );

        expect(find.byType(BuildAmount), findsOneWidget);
      });

      testWidgets('Tutar inputu sayı ve nokta kabul etmeli',
          (WidgetTester tester) async {
        final controller = TextEditingController();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TransactionInputWidget(
                type: TransactionInputType.amount,
                amountController: controller,
              ),
            ),
          ),
        );

        await tester.enterText(find.byType(TextField), '123.45');
        expect(controller.text, '123.45');
      });

      testWidgets('Tutar inputu harf kabul etmemeli',
          (WidgetTester tester) async {
        final controller = TextEditingController();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TransactionInputWidget(
                type: TransactionInputType.amount,
                amountController: controller,
              ),
            ),
          ),
        );

        await tester.enterText(find.byType(TextField), 'abc123');
        // Sadece sayılar ve nokta kalmalı
        expect(controller.text.contains(RegExp(r'[a-z]')), false);
      });

      testWidgets('Boş tutar inputu mümkün olmalı',
          (WidgetTester tester) async {
        final controller = TextEditingController();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TransactionInputWidget(
                type: TransactionInputType.amount,
                amountController: controller,
              ),
            ),
          ),
        );

        expect(controller.text, '');
      });

      testWidgets('Para birimi gösterimi olmalı', (WidgetTester tester) async {
        final controller = TextEditingController();

        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('tr'),
              Locale('en'),
            ],
            locale: const Locale('tr'),
            home: Scaffold(
              body: TransactionInputWidget(
                type: TransactionInputType.amount,
                amountController: controller,
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.attach_money), findsWidgets);
      });
    });

    group('TransactionInputType.date', () {
      testWidgets('BuildDate widget renderlanmalı',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TransactionInputWidget(
                type: TransactionInputType.date,
                selectedDate: DateTime(2024, 5, 15),
              ),
            ),
          ),
        );

        expect(find.byType(BuildDate), findsOneWidget);
      });

      testWidgets('Tarih gösterimi DD.MM.YYYY formatında olmalı',
          (WidgetTester tester) async {
        final date = DateTime(2024, 5, 15);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TransactionInputWidget(
                type: TransactionInputType.date,
                selectedDate: date,
              ),
            ),
          ),
        );

        expect(find.text('15.05.2024'), findsOneWidget);
      });

      testWidgets('Tarih gün sayısı 01-09 arasında 0 ile başlamalı',
          (WidgetTester tester) async {
        final date = DateTime(2024, 5, 5);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TransactionInputWidget(
                type: TransactionInputType.date,
                selectedDate: date,
              ),
            ),
          ),
        );

        expect(find.text('05.05.2024'), findsOneWidget);
      });

      testWidgets('Tarih ay sayısı 01-09 arasında 0 ile başlamalı',
          (WidgetTester tester) async {
        final date = DateTime(2024, 3, 15);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TransactionInputWidget(
                type: TransactionInputType.date,
                selectedDate: date,
              ),
            ),
          ),
        );

        expect(find.text('15.03.2024'), findsOneWidget);
      });

      testWidgets('Tarih seçilmediğinde bugünün tarihi gösterilmeli',
          (WidgetTester tester) async {
        final today = DateTime.now();
        final formattedToday =
            '${today.day.toString().padLeft(2, '0')}.${today.month.toString().padLeft(2, '0')}.${today.year}';

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: TransactionInputWidget(
                type: TransactionInputType.date,
              ),
            ),
          ),
        );

        expect(find.text(formattedToday), findsOneWidget);
      });

      testWidgets('Tarih tap edildiğinde callback çalışmalı',
          (WidgetTester tester) async {
        var callbackCalled = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TransactionInputWidget(
                type: TransactionInputType.date,
                selectedDate: DateTime.now(),
                onDateTap: () {
                  callbackCalled = true;
                },
              ),
            ),
          ),
        );

        await tester.tap(find.byType(BuildDate));
        expect(callbackCalled, true);
      });

      testWidgets('Tarih widget takvim ikonu içermeli',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TransactionInputWidget(
                type: TransactionInputType.date,
                selectedDate: DateTime.now(),
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.calendar_month_outlined), findsOneWidget);
      });
    });

    group('TransactionInputType.description', () {
      testWidgets('BuildDescription widget renderlanmalı',
          (WidgetTester tester) async {
        final controller = TextEditingController();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TransactionInputWidget(
                type: TransactionInputType.description,
                descriptionController: controller,
              ),
            ),
          ),
        );

        expect(find.byType(BuildDescription), findsOneWidget);
      });

      testWidgets('Açıklama inputu metin alabilmeli',
          (WidgetTester tester) async {
        final controller = TextEditingController();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TransactionInputWidget(
                type: TransactionInputType.description,
                descriptionController: controller,
              ),
            ),
          ),
        );

        await tester.enterText(find.byType(TextField), 'Test açıklaması');
        expect(controller.text, 'Test açıklaması');
      });

      testWidgets('Açıklama inputu uzun metni desteklemeli',
          (WidgetTester tester) async {
        final controller = TextEditingController();
        final longText = 'Bu çok uzun bir açıklamadır. ' * 20;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TransactionInputWidget(
                type: TransactionInputType.description,
                descriptionController: controller,
              ),
            ),
          ),
        );

        await tester.enterText(find.byType(TextField), longText);
        expect(controller.text, longText);
      });

      testWidgets('Açıklama inputu boş olabilmeli',
          (WidgetTester tester) async {
        final controller = TextEditingController();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TransactionInputWidget(
                type: TransactionInputType.description,
                descriptionController: controller,
              ),
            ),
          ),
        );

        expect(controller.text, '');
      });

      testWidgets('Açıklama inputu çok satırlı olmalı',
          (WidgetTester tester) async {
        final controller = TextEditingController();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TransactionInputWidget(
                type: TransactionInputType.description,
                descriptionController: controller,
              ),
            ),
          ),
        );

        await tester.enterText(
            find.byType(TextField), 'Satır 1\nSatır 2\nSatır 3');
        expect(controller.text, 'Satır 1\nSatır 2\nSatır 3');
      });

      testWidgets('Açıklama inputu türkçe karakterleri desteklemeli',
          (WidgetTester tester) async {
        final controller = TextEditingController();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TransactionInputWidget(
                type: TransactionInputType.description,
                descriptionController: controller,
              ),
            ),
          ),
        );

        await tester.enterText(
            find.byType(TextField), 'Türkçe karakterler: ç, ş, ğ, ı, ö, ü');
        expect(controller.text, 'Türkçe karakterler: ç, ş, ğ, ı, ö, ü');
      });
    });

    group('TransactionInputType.category', () {
      testWidgets('BuildCategory widget renderlanmalı',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TransactionInputWidget(
                type: TransactionInputType.category,
                categories: mockCategories,
              ),
            ),
          ),
        );

        expect(find.byType(BuildCategory), findsOneWidget);
      });

      testWidgets('Kategoriler dropdown içinde gösterilmeli',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TransactionInputWidget(
                type: TransactionInputType.category,
                categories: mockCategories,
                selectedCategory: mockCategories.first,
                onCategoryChanged: (_) {},
              ),
            ),
          ),
        );

        expect(find.text('Yemek'), findsOneWidget);
      });

      testWidgets('Kategori seçimi callback çalışmalı',
          (WidgetTester tester) async {
        CategoryModel? selectedCat;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TransactionInputWidget(
                type: TransactionInputType.category,
                categories: mockCategories,
                onCategoryChanged: (cat) {
                  selectedCat = cat;
                },
              ),
            ),
          ),
        );

        await tester.tap(find.byType(DropdownButton<CategoryModel>));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Yemek'));
        await tester.pumpAndSettle();

        expect(selectedCat?.name, 'Yemek');
      });

      testWidgets('Seçili kategori gösterilmeli', (WidgetTester tester) async {
        final selectedCategory = mockCategories[0];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TransactionInputWidget(
                type: TransactionInputType.category,
                categories: mockCategories,
                selectedCategory: selectedCategory,
              ),
            ),
          ),
        );

        expect(find.text('Yemek'), findsOneWidget);
      });

      testWidgets('Boş kategori listesi gösterilmeli',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: TransactionInputWidget(
                type: TransactionInputType.category,
                categories: [],
              ),
            ),
          ),
        );

        expect(find.byType(DropdownButton<CategoryModel>), findsOneWidget);
      });

      testWidgets('Kategori null olduğunda placeholder gösterilmeli',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('tr'),
              Locale('en'),
            ],
            home: Scaffold(
              body: TransactionInputWidget(
                type: TransactionInputType.category,
                categories: mockCategories,
                selectedCategory: null,
              ),
            ),
          ),
        );

        expect(find.byType(DropdownButton<CategoryModel>), findsOneWidget);
      });

      testWidgets('Kategori listesi null olduğunda hata olmamalı',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: TransactionInputWidget(
                type: TransactionInputType.category,
                categories: null,
              ),
            ),
          ),
        );

        expect(find.byType(DropdownButton<CategoryModel>), findsOneWidget);
      });
    });

    group('TransactionInputWidget Switch Logic', () {
      testWidgets('amount type doğru widget renderlasın',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TransactionInputWidget(
                type: TransactionInputType.amount,
                amountController: TextEditingController(),
              ),
            ),
          ),
        );

        expect(find.byType(BuildAmount), findsOneWidget);
        expect(find.byType(BuildDate), findsNothing);
        expect(find.byType(BuildDescription), findsNothing);
        expect(find.byType(BuildCategory), findsNothing);
      });

      testWidgets('date type doğru widget renderlasın',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: TransactionInputWidget(
                type: TransactionInputType.date,
              ),
            ),
          ),
        );

        expect(find.byType(BuildDate), findsOneWidget);
        expect(find.byType(BuildAmount), findsNothing);
        expect(find.byType(BuildDescription), findsNothing);
        expect(find.byType(BuildCategory), findsNothing);
      });

      testWidgets('description type doğru widget renderlasın',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TransactionInputWidget(
                type: TransactionInputType.description,
                descriptionController: TextEditingController(),
              ),
            ),
          ),
        );

        expect(find.byType(BuildDescription), findsOneWidget);
        expect(find.byType(BuildAmount), findsNothing);
        expect(find.byType(BuildDate), findsNothing);
        expect(find.byType(BuildCategory), findsNothing);
      });

      testWidgets('category type doğru widget renderlasın',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: TransactionInputWidget(
                type: TransactionInputType.category,
                categories: [],
              ),
            ),
          ),
        );

        expect(find.byType(BuildCategory), findsOneWidget);
        expect(find.byType(BuildAmount), findsNothing);
        expect(find.byType(BuildDate), findsNothing);
        expect(find.byType(BuildDescription), findsNothing);
      });
    });
  });
}
