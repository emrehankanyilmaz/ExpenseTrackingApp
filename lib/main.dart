import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/transactions/presentation/providers/category_provider.dart';
import 'features/transactions/presentation/providers/transaction_provider.dart';
import 'features/transactions/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => CategoryProvider()..loadCategories()),
        ChangeNotifierProvider(
            create: (_) => TransactionProvider()..loadTransactions()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Gider Takip',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      ),
    );
  }
}
