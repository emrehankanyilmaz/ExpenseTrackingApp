import 'package:flutter_test/flutter_test.dart';
import 'package:gider_takip/core/database/base_model.dart';

class MockModel extends BaseModel {
  @override
  Map<String, dynamic> toMap() => {'id': 1};
}

void main() {
  test('MockModel toMap returns correct map', () {
    final model = MockModel();
    expect(model.toMap(), {'id': 1});
  });
}
