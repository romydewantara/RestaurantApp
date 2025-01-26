import 'package:sqflite/sqflite.dart';
import 'package:restaurant_app/data/model/restaurant.dart';

class RestaurantSqliteService {
  static const String _databaseName = 'restaurant-app.db';
  static const String _tableName = 'favorite';
  static const int _version = 1;

  Future<void> createTables(Database database) async {
    await database.execute("""CREATE TABLE $_tableName(
    id TEXT PRIMARY KEY,
    name TEXT,
    description TEXT,
    pictureId TEXT,
    city TEXT,
    rating REAL
    )
    """);
  }

  Future<Database> _initDb() async {
    return openDatabase(
      _databaseName,
      version: _version,
      onCreate: (Database database, int version) async {
        await createTables(database);
      },
    );
  }

  Future<int> insertItem(Restaurant restaurant) async {
    final db = await _initDb();

    final data = restaurant.toJson();
    final id = await db.insert(
      _tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<List<Restaurant>> getAllItems() async {
    try {
      final db = await _initDb();
      final results = await db.query(_tableName, orderBy: "name");

      return results.map((result) => Restaurant.fromJson(result)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<Restaurant> getItemById(String id) async {
    final db = await _initDb();
    final results =
        await db.query(_tableName, where: "id = ?", whereArgs: [id], limit: 1);

    return results.map((result) => Restaurant.fromJson(result)).first;
  }

  Future<int> updateItem(int id, Restaurant restaurant) async {
    final db = await _initDb();

    final data = restaurant.toJson();

    final result =
        await db.update(_tableName, data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  Future<int> removeItem(String id) async {
    final db = await _initDb();

    final result =
        await db.delete(_tableName, where: "id = ?", whereArgs: [id]);
    return result;
  }
}
