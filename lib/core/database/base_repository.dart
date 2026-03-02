import 'package:gider_takip/core/database/base_model.dart';
import 'package:gider_takip/core/database/database_helper.dart';

abstract class BaseRepository<T extends BaseModel> {
  final String tableName;

  BaseRepository(this.tableName);

  Future<int> insert(T model) async {
    final db = await DatabaseHelper.instance.database;
    return await db.insert(tableName, model.toMap());
  }

  Future<List<T>> getAll(T Function(Map<String, dynamic>) fromMap) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(tableName);
    return result.map((e) => fromMap(e)).toList();
  }

  Future<int> update(int id, T model) async {
    final db = await DatabaseHelper.instance.database;
    return await db.update(
      tableName,
      model.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> delete(int id) async {
    final db = await DatabaseHelper.instance.database;
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
