import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class GankDB {
  static final GankDB _instance = GankDB.internal();

  factory GankDB() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await init();
    }
    return _db;
  }

  GankDB.internal();

  final String appMode = "appModel";
  final String nameCn = "nameCn";
  final String nameEn = "nameEn";
  final String enable = "enable";
  final String modelIndex = "modelIndex";

  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory();

    final path = join(directory.path, "gank.db");

    var ourDB = await openDatabase(path, version: 1,
        onCreate: (Database newDB, int version) {
      newDB.execute("""
      CREATE TABLE $appMode (
        $modelIndex INTEGER PRIMARY KEY NOT NULL,
        $nameCn TEXT NOT NULL,
        $nameEn TEXT NOT NULL,
        $enable INTEGER NOT NULL
      )
      """);
    });
    return ourDB;
  }

  Future<int> insert(String table, dynamic item) async {
    var dbClient = await db;
    int res = await dbClient.insert(table, item.toJson());
    return res;
  }

  Future<List> getAll(String table) async {
    var dbClient = await db;
    var res = await dbClient.rawQuery("SELECT * FROM $table");
    return res.toList();
  }

/*  Future<dynamic> getItem(String table, int id) async {
    var dbClient = await db;
    var res = await dbClient.rawQuery("SELECT * FROM $table WHERE id = $id");
    if (res == null || res.length == 0) return null;
    if (table == appMode) return AppModel.formJson(res.first);
  }
  */

  Future<int> update(String table, dynamic item) async {
    var dbClient = await db;
    return await dbClient.update(table, item.toJson(),
        where: "modelIndex =?", whereArgs:[item.modelIndex]);
  }
  Future<int> delete(String table, dynamic item) async{
    var dbClient = await db;
    var res = await dbClient.delete(table,where: "modelIndex=?",whereArgs: [item.modelIndex]);
    return res;

  }
  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
