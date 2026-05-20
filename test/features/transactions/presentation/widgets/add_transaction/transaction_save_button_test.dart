import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gider_takip/features/transactions/presentation/providers/transaction_provider.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/add_transaction/transaction_save_button.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../../../../fakes/fake_transaction_repository.dart';

void main() {
  late TextEditingController amountController;
  late TextEditingController descController;

  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    SharedPreferences.setMockInitialValues({});
  });

  setUp(() {
    amountController = TextEditingController();
    descController = TextEditingController();
  });

  testWidgets('TransactionSaveButton triggers save with correct inputs',
      (WidgetTester tester) async {
    final transactionProvider =
        TransactionProvider(FakeTransactionRepository());

    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('tr')],
        path: 'assets/translations',
        startLocale: const Locale('tr'),
        saveLocale: false,
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider<TransactionProvider>.value(
              value: transactionProvider,
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: TransactionSaveButton(
                amountController: amountController,
                descController: descController,
              ),
            ),
          ),
        ),
      ),
    );

    // Act
    await tester.pumpAndSettle();

    amountController.text = '100';
    descController.text = 'Test';

    await tester.tap(find.byType(TransactionSaveButton));
    await tester.pump();
  });
}
