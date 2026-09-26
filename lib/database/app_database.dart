import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {

  AppDatabase._internal() {
    init();
  }

  static final String _databaseName = 'bookish.db';

  static final AppDatabase appDatabase = AppDatabase._internal();

  static Database? _database;

  Future<Database?> init() async {
    String path = join(await getDatabasesPath(), _databaseName);
    _database ??= await openDatabase(path, version: 1, onCreate: (db, version) {
      db.execute('''
        CREATE TABLE feed_post(
          post_id TEXT PRIMARY KEY,
          user_id TEXT,
          book_title TEXT,
          book_id TEXT,
          user_name TEXT,
          profile_image TEXT,
          post_images TEXT,
          post_caption TEXT,
          created_at TEXT,
          is_liked INTEGER,
          like_count INTEGER,
          comment_count INTEGER,
          share_count INTEGER
        )
      ''');
    });
    return _database;
  }

  Future<void> insert(String table, Map<String, dynamic> data) async {
    await _database?.insert(table, data,  conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> queryItems(String table) async {
    _database ?? await init();
    return await _database!.query(table);
  }

  Future<Map<String, dynamic>?> queryItemById(String table, String id) async {
    final List<Map<String, dynamic>> items =  await _database!.query(table, where: 'id = ?', whereArgs: [id]);
    return items.first;
  }

  Future<void> updateItems(String table, Map<String, dynamic> data) async {
    await _database?.update(table, data);
  }

  Future<void> updateItemById(String table, Map<String, dynamic> data, String id) async {
    await _database?.update(table, data, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> delete(String table, int id) async {
    await _database?.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    await _database?.close();
  }
}