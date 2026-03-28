import 'package:flutter/material.dart';

abstract class BaseProvider extends ChangeNotifier {
  Future<void> run(Future<void> Function() action) async {
    try {
      await action();
    } catch (e) {
      debugPrint('Provider error: $e');
    } finally {
      notifyListeners();
    }
  }
}
