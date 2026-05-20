import 'package:flutter_test/flutter_test.dart';
import 'package:gider_takip/features/transactions/theme/app_theme.dart';

void main() {
  test('AppTheme light theme is defined', () {
    final theme = AppTheme.light;
    expect(theme, isNotNull);
  });
}
