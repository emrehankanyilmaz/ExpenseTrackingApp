import 'package:flutter_test/flutter_test.dart';
import 'package:gider_takip/core/database/database_helper.dart';

void main() {
  test('DatabaseHelper initializes correctly', () async {
    final dbHelper = DatabaseHelper.instance;
    expect(dbHelper, isNotNull);
  });
}
