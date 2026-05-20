import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gider_takip/features/transactions/presentation/services/snackbar_services.dart';
import 'package:gider_takip/main.dart';

void main() {
  group('SnackbarService', () {
    testWidgets('başarılı mesaj gösterebilmeli', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          scaffoldMessengerKey: scaffoldMessengerKey,
          home: Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  SnackbarService.show(message: 'İşlem başarılı');
                },
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('İşlem başarılı'), findsOneWidget);
    });

    testWidgets('hata mesajı gösterebilmeli', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          scaffoldMessengerKey: scaffoldMessengerKey,
          home: Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  SnackbarService.show(
                      message: 'Bir hata oluştu', isError: true);
                },
                child: const Text('Show Error'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Bir hata oluştu'), findsOneWidget);
    });

    testWidgets('başarılı mesaj için backgroundColor yeşil olmalı',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          scaffoldMessengerKey: scaffoldMessengerKey,
          home: Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  SnackbarService.show(message: 'Başarılı', isError: false);
                },
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      final snackBar = find.byType(SnackBar);
      expect(snackBar, findsOneWidget);

      final SnackBar snackBarWidget = tester.widget<SnackBar>(snackBar);
      expect(snackBarWidget.backgroundColor, Colors.green);
    });

    testWidgets('hata mesajı için backgroundColor kırmızı olmalı',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          scaffoldMessengerKey: scaffoldMessengerKey,
          home: Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  SnackbarService.show(message: 'Hata', isError: true);
                },
                child: const Text('Show Error'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      final snackBar = find.byType(SnackBar);
      expect(snackBar, findsOneWidget);

      final SnackBar snackBarWidget = tester.widget<SnackBar>(snackBar);
      expect(snackBarWidget.backgroundColor, Colors.red);
    });

    testWidgets('SnackBar behavior floating olmalı',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          scaffoldMessengerKey: scaffoldMessengerKey,
          home: Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  SnackbarService.show(message: 'Test');
                },
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      final SnackBar snackBarWidget =
          tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBarWidget.behavior, SnackBarBehavior.floating);
    });

    testWidgets('SnackBar şekli RoundedRectangleBorder olmalı',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          scaffoldMessengerKey: scaffoldMessengerKey,
          home: Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  SnackbarService.show(message: 'Test');
                },
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      final SnackBar snackBarWidget =
          tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBarWidget.shape, isA<RoundedRectangleBorder>());
    });

    testWidgets('RoundedRectangleBorder border radius 10 olmalı',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          scaffoldMessengerKey: scaffoldMessengerKey,
          home: Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  SnackbarService.show(message: 'Test');
                },
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      final SnackBar snackBarWidget =
          tester.widget<SnackBar>(find.byType(SnackBar));
      final shape = snackBarWidget.shape as RoundedRectangleBorder;

      expect(shape.borderRadius, BorderRadius.circular(10));
    });

    testWidgets('SnackBar margin 16 olmalı', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          scaffoldMessengerKey: scaffoldMessengerKey,
          home: Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  SnackbarService.show(message: 'Test');
                },
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      final SnackBar snackBarWidget =
          tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBarWidget.margin, const EdgeInsets.all(16));
    });

    testWidgets('SnackBar duration 2 saniye olmalı',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          scaffoldMessengerKey: scaffoldMessengerKey,
          home: Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  SnackbarService.show(message: 'Test');
                },
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      final SnackBar snackBarWidget =
          tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBarWidget.duration, const Duration(seconds: 2));
    });

    testWidgets('isError parametresi varsayılan olarak false olmalı',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          scaffoldMessengerKey: scaffoldMessengerKey,
          home: Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  SnackbarService.show(message: 'Test');
                },
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      final SnackBar snackBarWidget =
          tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBarWidget.backgroundColor, Colors.green);
    });

    testWidgets('çoklu show çağrıları art arda yapılabilmeli',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          scaffoldMessengerKey: scaffoldMessengerKey,
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      SnackbarService.show(message: 'Mesaj 1');
                    },
                    child: const Text('Show 1'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      SnackbarService.show(message: 'Mesaj 2', isError: true);
                    },
                    child: const Text('Show 2'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      SnackbarService.show(message: 'Mesaj 3');
                    },
                    child: const Text('Show 3'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // İlk mesajı göster
      await tester.tap(find.text('Show 1'));
      await tester.pumpAndSettle();
      expect(find.text('Mesaj 1'), findsOneWidget);

      // SnackBar timeout'u (2 saniye) + biraz extra bekle
      await tester.pump(const Duration(seconds: 2, milliseconds: 100));
      await tester.pumpAndSettle();

      // İkinci mesajı göster
      await tester.tap(find.text('Show 2'));
      await tester.pumpAndSettle();
      expect(find.text('Mesaj 2'), findsOneWidget);

      // SnackBar timeout'u bekle
      await tester.pump(const Duration(seconds: 2, milliseconds: 100));
      await tester.pumpAndSettle();

      // Üçüncü mesajı göster
      await tester.tap(find.text('Show 3'));
      await tester.pumpAndSettle();
      expect(find.text('Mesaj 3'), findsOneWidget);
    });

    testWidgets('boş mesaj gösterebilmeli', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          scaffoldMessengerKey: scaffoldMessengerKey,
          home: Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  SnackbarService.show(message: '');
                },
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('uzun mesaj gösterebilmeli', (WidgetTester tester) async {
      const message =
          'Bu çok uzun bir mesajdır. Sistem bu mesajı doğru bir şekilde gösterebilmeli ve SnackBar içinde düzgün bir şekilde yerleştirilmesi gerekir.';

      await tester.pumpWidget(
        MaterialApp(
          scaffoldMessengerKey: scaffoldMessengerKey,
          home: Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  SnackbarService.show(message: message);
                },
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text(message), findsOneWidget);
    });

    testWidgets('türkçe karakterli mesaj gösterebilmeli',
        (WidgetTester tester) async {
      const message = 'Kategori başarıyla eklendi ✓';

      await tester.pumpWidget(
        MaterialApp(
          scaffoldMessengerKey: scaffoldMessengerKey,
          home: Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  SnackbarService.show(message: message);
                },
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text(message), findsOneWidget);
    });

    testWidgets('özel karakterlerle mesaj gösterebilmeli',
        (WidgetTester tester) async {
      const message = 'İşlem başarılı! [OK] @ #100';

      await tester.pumpWidget(
        MaterialApp(
          scaffoldMessengerKey: scaffoldMessengerKey,
          home: Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  SnackbarService.show(message: message);
                },
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text(message), findsOneWidget);
    });

    testWidgets('başarılı ve hata mesajları sırayla gösterebilmeli',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          scaffoldMessengerKey: scaffoldMessengerKey,
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      SnackbarService.show(
                          message: 'Kategori eklendi', isError: false);
                    },
                    child: const Text('Show Success'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      SnackbarService.show(
                          message: 'Silme işlemi başarısız', isError: true);
                    },
                    child: const Text('Show Error'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Başarılı mesajı göster
      await tester.tap(find.text('Show Success'));
      await tester.pumpAndSettle();

      final successSnackBar = find.byType(SnackBar);
      expect(successSnackBar, findsOneWidget);
      expect(find.text('Kategori eklendi'), findsOneWidget);

      final SnackBar successWidget = tester.widget<SnackBar>(successSnackBar);
      expect(successWidget.backgroundColor, Colors.green);

      // SnackBar timeout'u bekle
      await tester.pump(const Duration(seconds: 2, milliseconds: 100));
      await tester.pumpAndSettle();

      // Hata mesajını göster
      await tester.tap(find.text('Show Error'));
      await tester.pumpAndSettle();

      final errorSnackBar = find.byType(SnackBar);
      expect(errorSnackBar, findsOneWidget);
      expect(find.text('Silme işlemi başarısız'), findsOneWidget);

      final SnackBar errorWidget = tester.widget<SnackBar>(errorSnackBar);
      expect(errorWidget.backgroundColor, Colors.red);
    });

    testWidgets('tüm konfigürasyonlar beraber kontrol edilebilmeli',
        (WidgetTester tester) async {
      const message = 'Test mesajı';

      await tester.pumpWidget(
        MaterialApp(
          scaffoldMessengerKey: scaffoldMessengerKey,
          home: Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  SnackbarService.show(message: message, isError: true);
                },
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      final SnackBar snackBarWidget =
          tester.widget<SnackBar>(find.byType(SnackBar));

      expect(find.text(message), findsOneWidget);
      expect(snackBarWidget.backgroundColor, Colors.red);
      expect(snackBarWidget.behavior, SnackBarBehavior.floating);
      expect(snackBarWidget.shape, isA<RoundedRectangleBorder>());
      expect(snackBarWidget.margin, const EdgeInsets.all(16));
      expect(snackBarWidget.duration, const Duration(seconds: 2));
    });
  });
}
