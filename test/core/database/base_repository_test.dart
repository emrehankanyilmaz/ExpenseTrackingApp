import 'package:flutter_test/flutter_test.dart';
import 'package:gider_takip/core/database/base_repository.dart';
import 'package:gider_takip/core/database/base_model.dart';

class MockModel extends BaseModel {
  @override
  Map<String, dynamic> toMap() => {'id': 1};
}

class MockRepository extends BaseRepository<MockModel> {
  MockRepository(super.tableName);
  MockModel fromMap(Map<String, dynamic> map) => MockModel();
}

void main() {
  test('BaseRepository initializes with table name', () {
    final repository = MockRepository('test_table');

    expect(repository.tableName, 'test_table');
  });
}
