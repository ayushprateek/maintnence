import 'package:flutter/material.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:sqflite/sqlite_api.dart';

class GetLastDocNum {
  final int ID, DocNumber;

  final String DocName;

  GetLastDocNum(
      {required this.ID, required this.DocName, required this.DocNumber});

  GetLastDocNum.fromMap(Map<String, dynamic> res)
      : ID = res["ID"],
        DocName = res["DocName"],
        DocNumber = res["DocNumber"];

  Map<String, Object> toMap() {
    return {
      'ID': ID,
      'DocName': DocName,
      'DocNumber': DocNumber,
    };
  }
}

Future<List<GetLastDocNum>> getLastDocNum(String DocName, BuildContext? context,
    {Transaction? txn}) async {
  var db;
  if (txn == null) {
    db = await initializeDB(context);
  } else {
    db = txn;
  }

  final List<Map<String, Object?>> queryResult = await db.query(
    'DOCN',
    where: "DocName = ?",
    whereArgs: [DocName],
  );
  return queryResult.map((e) => GetLastDocNum.fromMap(e)).toList();
}

Future<void> updateDocNum(
    int id, Map<String, dynamic> values, BuildContext context,
    {Transaction? txn}) async {
  var db;
  if (txn == null) {
    db = await initializeDB(context);
  } else {
    db = txn;
  }
  await db.update("DOCN", values, where: 'ID = ?', whereArgs: [id]);
}
