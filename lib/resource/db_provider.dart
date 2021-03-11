import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' hide Transaction;

import 'package:innout/model/transaction.dart';

class DBProvider {
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  Future<void> initDatabase() async {
    _database = await initDB();
  }

  Future<Database> initDB({bool refresh = false}) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String path = join(appDocDir.path, "database.db");

    if (await File(path).exists() && !refresh) {
      debugPrint("DBProvider: loading the database.");

      return openDatabase(
        path,
        version: 1,
        onOpen: (db) async {
          print(await db.query("sqlite_master"));
        },
      );
    } else {
      debugPrint("DBProvider: copying database from asset to device.");

      ByteData data = await rootBundle.load("database/database.db");
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes);
      return openDatabase(
        path,
        version: 1,
        onOpen: (db) async {
          print(await db.query("sqlite_master"));
        },
      );
    }
  }

  Future<void> updateTransaction(Transaction transaction) async {
    final db = await database;
    var res = await db.update("Transactions", transaction.toMap(), where: "id = ?", whereArgs: [transaction.id]);
    return res;
  }

  Future<void> deleteTransaction(Transaction transaction) async {
    final db = await database;
    var res = await db.delete("Transactions", where: "id = ?", whereArgs: [transaction.id]);
    return res;
  }

//
//  deleteAllRoutines() async {
//    final db = await database;
//    var res = await db.delete("Routines");
//    return res;
//  }
//
  Future<int> addTransaction(Transaction transaction) async {
    final db = await database;

    var table = await db.rawQuery('SELECT MAX(Id)+1 as Id FROM Transactions');
    int id = table.first['Id'];
    transaction.id = id;
    return db.insert('Transactions', transaction.toMap());
//    await db.rawInsert(
//        'INSERT Into Routines (Id, RoutineName, MainPart, Parts, LastCompletedDate, CreatedDate, Count, RoutineHistory, Weekdays) VALUES (?,?,?,?,?,?,?,?,?)',
//        [
//          id,
//
//          ///changed from [map['id']] to [id]
//          map['RoutineName'],
//          map['MainPart'],
//          map['Parts'],
//          map['LastCompletedDate'],
//          map['CreatedDate'],
//          map['Count'],
//          map['RoutineHistory'],
//          map['Weekdays'],
//        ]);
  }

  Future<List<Transaction>> getAllTransactions() async {
    final db = await database;
    List<Map> res;
    res = await db.query('Transactions');

    print("The length of transactions: ${res.length}");

    return res.isNotEmpty
        ? res.map((r) {
            return Transaction.fromMap(r);
          }).toList()
        : [];
  }

  Future<int> getNextId() async {
    final db = await database;

    var table = await db.rawQuery('SELECT MAX(Id)+1 as Id FROM Transactions');
    int id = table.first['Id'];

    return id;
  }
}

//final dbProvider = DBProvider();
