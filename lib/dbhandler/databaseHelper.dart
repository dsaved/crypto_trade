import 'dart:async';
import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  // All Static variables
  // Database Version
  // ignore: non_constant_identifier_names
  static final int DATABASE_VERSION = 1;

  // Database Name
  // ignore: non_constant_identifier_names
  static final String DATABASE_NAME = "crypto_trade_db_";

  // Login table name

  // Login Table Columns names
  // ignore: non_constant_identifier_names
  static final String TABLE_LINK = "site_link";
  // ignore: non_constant_identifier_names
  static final String KEY_ID = "id";
  // ignore: non_constant_identifier_names
  static final String KEY_LINK = "link";

  // ignore: non_constant_identifier_names
  String CREATE_LOGIN_TABLE = "CREATE TABLE " + TABLE_LINK + "("
      + KEY_ID + " INTEGER PRIMARY KEY,"
      + KEY_LINK + " TEXT"+ ")";

  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DATABASE_NAME);
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(CREATE_LOGIN_TABLE);
  }

  Future<int> saveLink(String link) async {
    var dbClient = await db;
    var mapLink = new Map<String, dynamic>();
    mapLink[KEY_LINK] = link;
    print(mapLink);
    int res;
    if(await hasLink()){
      res = await dbClient.update(TABLE_LINK, mapLink,where: '$KEY_ID = ?',whereArgs: [1]);
    }else{
      res = await dbClient.insert(TABLE_LINK, mapLink);
    }
    return res;
  }

  Future<bool> hasLink() async {
    var dbClient = await db;
    var res = await dbClient.query(TABLE_LINK);
    return res.length > 0 ? true : false;
  }

  Future getLink() async {
    var dbClient = await db;
    var res = await dbClient.query(TABLE_LINK);
    return res.length > 0 ? res[0]['link'] : null;
  }
}
