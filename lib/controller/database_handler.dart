import 'package:firebasetest/model/grateful_model/grateful_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/const_values/const_values.dart';
import '../model/grateful_model/grateful_constant.dart';

import '../model/tasks_model/task_constant.dart';
import '../model/tasks_model/task_model.dart';
class DatabaseHandler {
  static final DatabaseHandler? instance = DatabaseHandler._init();


  List<Map<String, Object>> constTasks = [
    {
      "Task": 'صلاة الفجر',
      "state": 'false',
    },
    {
      "Task": 'صلاة الظهر',
      "state": 'false',
    },
    {
      "Task": 'صلاة العصر',
      "state": 'false',
    },
    {
      "Task": 'صلاة المغرب',
      "state": 'false',
    },
    {
      "Task": 'صلاة العشاء',
      "state": 'false',
    },
  ];

  DatabaseHandler._init();

  static Database? _database;

  Future<Database> get database async {
    _database = await openDB();
    return _database!;
  }

  Future<Database> openDB() async {
    String path = join(await getDatabasesPath(), databaseName);
    return openDatabase(path, version: 1, onCreate: (Database db, int version) {
      // create task table
      db.execute(
          'CREATE TABLE $taskTable ($taskId $idType, $taskValue $textType, $taskState $textType )'
      ).then((value) {
        print('task Table created');
        for (int i = 0; i < constTasks.length; i++) {
          db.transaction((txn) async {
            await txn
                .rawInsert(
                'INSERT INTO $taskTable ($taskValue ,$taskState) VALUES("${constTasks[i]['Task']}" ,false)')
                .then((value) {
              print('insert const Tasks done successfully');
            })
                .catchError((error) {});
          }
            );}


          }).catchError((error) {
        print('Error creating task table');
      });
      //==========================================================

      //==========================================================

      // gratefulTable
      db.execute(
          'CREATE TABLE $gratefulTable ($gratefulId $idType, $gratefulValue $textType)'
      ).then((value) {
        print('grateful Table created');

          }).catchError((error) {
        print('Error creating grateful table');
      });

      //-==========================================================

    },
        // on open
        onOpen: (Database db) {

          print('Database opened');
        });

  }

  /// CRUD

  // Create
  Future<void> createTask(TaskModel taskModel) async {
    final Database db = await instance!.database;
    await db.insert(
      taskTable,
      taskModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Update
  Future<void> updateTask(TaskModel taskModel) async {
    final Database db = await instance!.database;
    await db.update(
      taskTable,
      taskModel.toMap(),
      where: '$taskId = ?',
      whereArgs: [taskModel.id],
    );
  }

  // Delete
  Future<void> deleteTask(int id) async {
    final Database db = await instance!.database;
    await db.delete(
      taskTable,
      where: '$taskId = ?',
      whereArgs: [id],
    );
  }



  // Read All Elements
  Future<List<TaskModel>> getAllTasks() async {
    final Database db = await instance!.database;
    List<Map<String, dynamic>> maps = await db.query(taskTable);

    return maps.isNotEmpty
        ? maps.map((user) => TaskModel.fromMap(user)).toList()
        : [];
  }

  // Read One Elements
  Future<TaskModel> getOneTask(int id) async {
    final Database db = await instance!.database;
    List<Map<String, dynamic>> maps = await db.query(
      taskTable,
      where: '$taskId = ?',
      whereArgs: [id],
    );

    return maps.isNotEmpty
        ? TaskModel.fromMap(maps.first)
        : throw Exception('No User with ID:$id');
  }

  // Create grateful
  Future<void> createGrateful (GratefulModel gratefulModel) async {
    final Database db = await instance!.database;
    await db.insert(
      gratefulTable,
      gratefulModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Update Grateful
  Future<void> updateGrateful(GratefulModel gratefulModel) async {
    final Database db = await instance!.database;
    await db.update(
      gratefulTable,
      gratefulModel.toMap(),
      where: '$taskId = ?',
      whereArgs: [gratefulModel.id],
    );
  }

  // Delete Grateful
  Future<void> deleteGrateful(int id) async {
    final Database db = await instance!.database;
    await db.delete(
      gratefulTable,
      where: '$taskId = ?',
      whereArgs: [id],
    );
  }

  // Read All Elements Grateful
  Future<List<GratefulModel>> getAllGrateful() async {
    final Database db = await instance!.database;
    List<Map<String, dynamic>> maps = await db.query(gratefulTable);

    return maps.isNotEmpty
        ? maps.map((user) => GratefulModel.fromMap(user)).toList()
        : [];
  }

  // Read One Elements Grateful
  Future<GratefulModel> getOneGrateful(int id) async {
    final Database db = await instance!.database;
    List<Map<String, dynamic>> maps = await db.query(
      taskTable,
      where: '$taskId = ?',
      whereArgs: [id],
    );
    return maps.isNotEmpty
        ? GratefulModel.fromMap(maps.first)
        : throw Exception('No User with ID:$id');
  }


}




