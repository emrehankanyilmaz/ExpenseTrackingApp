import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('expense_app.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        icon TEXT NOT NULL,
        type INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        categoryId INTEGER NOT NULL,
        type INTEGER NOT NULL,
        amount REAL NOT NULL,
        transactionDate TEXT NOT NULL,
        description TEXT NOT NULL,
        FOREIGN KEY (categoryId) REFERENCES categories(id)
          ON DELETE CASCADE ON UPDATE CASCADE
      )
    ''');
    /*final defaultCategories = [
      {'name': 'Market', 'icon': '🛒', 'type': 0},
      {'name': 'Alışveriş', 'icon': '🛍️', 'type': 0},
      {'name': 'Ulaşım', 'icon': '🚗', 'type': 0},
      {'name': 'Eğlence', 'icon': '🎮', 'type': 0},
      {'name': 'Maaş', 'icon': '💰', 'type': 1},
      {'name': 'Yatırım', 'icon': '📈', 'type': 1},
    ];

    for (final cat in defaultCategories) {
      await db.insert('categories', cat);
    }*/
  }
}
