import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_list_test/model/to_do_model.dart';

import 'constants.dart';

class DatabaseProvider {
  static final DatabaseProvider instance = DatabaseProvider._init();

  DatabaseProvider._init();

  static Database? _database;

  Future<Database>? get database async {
    if (_database != null) _database;
    _database = await _initDB();
    return _database!;
  }


  Future<Database>? _initDB() async {
    String path = join(await getDatabasesPath(), 'TaskDatabase.db');
    return await openDatabase(path, version: 2, onCreate: _createDB);
  }

  Future<void> _createDB(Database database, int version) async {
    await database.execute('''  
    CREATE TABLE $tableToDo (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    $columnText $textType,
    $columnDate $textType,
    $columnStatus $textType
    )
    ''');
  }

  /// CRUD
  // Create

  Future<void> createToDo(ToDoModel toDoModel) async {
    final db = await instance.database;
    db!.insert(
      tableToDo,
      toDoModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  // Update
  Future<void> updateToDo(ToDoModel toDoModel) async {
    final db = await instance.database;
    db!.update(
      tableToDo,
      toDoModel.toMap(),
      where: '$columnID = ?',
      whereArgs: [toDoModel.id],
    );
  }


  // Delete
  Future<void> deleteToDo(int? id) async {
    final db = await instance.database;
    db!.delete(
      tableToDo,
      where: '$columnID = ?',
      whereArgs: [id],
    );
  }

  // Read One Element
  Future<ToDoModel> readOneToDo(int? id) async {
    final db = await instance.database;
    final data = await db!.query(
      tableToDo,
      where: '$columnID ? =',
      whereArgs: [id],
    );
    return data.isNotEmpty
        ? ToDoModel.fromMap(data.first)
        : throw Exception('There is no Data');
  }

  // Read All Elements
  Future<List<ToDoModel>> readAllToDo() async {
    final db = await instance.database;
    final data = await db!.query(tableToDo);
    return data.isNotEmpty
        ? data.map((e) => ToDoModel.fromMap(e)).toList()
        : [];
  }
}
