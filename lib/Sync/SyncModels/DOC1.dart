import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

List<DOC1Model> DOC1ModelFromJson(String str) =>
    List<DOC1Model>.from(json.decode(str).map((x) => DOC1Model.fromJson(x)));

String DOC1ModelToJson(List<DOC1Model> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DOC1Model {
  DOC1Model({
    required this.ID,
    required this.EmpGroupId,
    required this.RowId,
    required this.CreateDate,
    required this.UpdateDate,
    this.hasCreated = false,
    required this.DocName,
    required this.Validity,
    required this.Mandatory,
  });

  int ID;
  int EmpGroupId;
  int RowId;
  String DocName;
  DateTime CreateDate;
  DateTime UpdateDate;
  bool hasCreated;
  int Validity;
  bool Mandatory;

  factory DOC1Model.fromJson(Map<String, dynamic> json) => DOC1Model(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        EmpGroupId: int.tryParse(json["EmpGroupId"].toString()) ?? 0,
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] == 1,
        RowId: int.tryParse(json["RowId"].toString()) ?? 0,
        DocName: json["DocName"] ?? "",
        Validity: int.tryParse(json["Validity"].toString()) ?? 0,
        Mandatory: json["Mandatory"] is bool
            ? json["Mandatory"]
            : json["Mandatory"] == 1,
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "CreateDate": CreateDate.toIso8601String(),
        "UpdateDate": UpdateDate.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "EmpGroupId": EmpGroupId,
        "RowId": RowId,
        "DocName": DocName,
        "Validity": Validity,
        "Mandatory": Mandatory == true ? 1 : 0,
      };
}

Future<List<DOC1Model>> dataSyncDOC1() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "DOC1" + postfix));
  print(res.body);
  return DOC1ModelFromJson(res.body);
}

// Future<void> insertDOC1(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteDOC1(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncDOC1();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('DOC1_Temp', customer.toJson());
//     } catch (e) {
//       writeToLogFile(
//           text: e.toString(),
//           fileName: StackTrace.current.toString(),
//           lineNo: 141);
//       getErrorSnackBar("Sync Error " + e.toString());
//     }
//   });
//   await batch1.commit(noResult: true);
//   var u = await db.rawQuery(
//       "SELECT * FROM  DOC1_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN UpdateDate IS NULL THEN CreateDate ELSE UpdateDate END)");
//   u.forEach((element) {
//     batch2.update("DOC1", element,
//         where:
//             "RowId = ? AND EmpGroupId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["RowId"], element["EmpGroupId"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//
//   var v = await db.rawQuery(
//       "Select * from DOC1_Temp where EmpGroupId || RowId not in (Select EmpGroupId || RowId from DOC1)");
//   v.forEach((element) {
//     batch3.insert('DOC1', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('DOC1_Temp');
// }

Future<void> insertDOC1(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteDOC1(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncDOC1();
  }
  print(customers);
  Stopwatch stopwatch = Stopwatch();
  stopwatch.start();
  for (var i = 0; i < customers.length; i += batchSize) {
    var end =
        (i + batchSize < customers.length) ? i + batchSize : customers.length;
    var batchRecords = customers.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (DOC1Model record in batchRecords) {
        try {
          batch.insert('DOC1_Temp', record.toJson());
        } catch (e) {
          writeToLogFile(
              text: e.toString(),
              fileName: StackTrace.current.toString(),
              lineNo: 141);
          getErrorSnackBar("Sync Error " + e.toString());
        }
      }
      await batch.commit();
    });
  }
  stopwatch.stop();
  print('Time taken for insert: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  var differenceList = await db.rawQuery('''
  Select * from (
			select * from DOC1_Temp
			except
			select * from DOC1
			)A
  ''');
  print(differenceList);
  for (var i = 0; i < differenceList.length; i += batchSize) {
    var end = (i + batchSize < differenceList.length)
        ? i + batchSize
        : differenceList.length;
    var batchRecords = differenceList.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var element in batchRecords) {
        try {
          batch.update("DOC1", element,
              where:
                  "RowId = ? AND EmpGroupId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
              whereArgs: [element["RowId"], element["EmpGroupId"], 1, 1]);
        } catch (e) {
          writeToLogFile(
              text: e.toString(),
              fileName: StackTrace.current.toString(),
              lineNo: 141);
          getErrorSnackBar("Sync Error " + e.toString());
        }
      }
      await batch.commit();
    });
  }

  stopwatch.stop();
  print('Time taken for DOC1 update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from DOC1_Temp where EmpGroupId || RowId not in (Select EmpGroupId || RowId from DOC1)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM DOC1_Temp T0
LEFT JOIN DOC1 T1 ON T0.EmpGroupId = T1.EmpGroupId AND T0.RowId = T1.RowId
WHERE T1.EmpGroupId IS NULL AND T1.RowId IS NULL;
''');

  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('DOC1', record);
        } catch (e) {
          writeToLogFile(
              text: e.toString(),
              fileName: StackTrace.current.toString(),
              lineNo: 141);
          getErrorSnackBar("Sync Error " + e.toString());
        }
      }
      await batch.commit();
    });
  }
  stopwatch.stop();
  print(
      'Time taken for DOC1_Temp and DOC1 compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('DOC1_Temp');
  // stopwatch.stop();
}

Future<List<DOC1Model>> retrieveDOC1(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('DOC1');
  return queryResult.map((e) => DOC1Model.fromJson(e)).toList();
}

Future<void> updateDOC1(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    await db.transaction((db) async {
      await db.update("DOC1", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteDOC1(Database db) async {
  await db.delete('DOC1');
}

//SEND DATA TO SERVER
//--------------------------
Future<List<DOC1Model>> retrieveDOC1ById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('DOC1', where: str, whereArgs: l);
  return queryResult.map((e) => DOC1Model.fromJson(e)).toList();
}

Future<void> insertDOC1ToServer(BuildContext context) async {
  //todo:
  retrieveDOC1ById(context, DataSync.getInsertToServerStr(),
          DataSync.getInsertToServerList())
      .then((snapshot) {
    print(snapshot);
    snapshot.forEach((data) async {
      var res = await http.post(Uri.parse(prefix + "DOC1/Add"),
          headers: header, body: jsonEncode(data.toJson()));
      print(res.body);
    });
  });
}

Future<void> updateDOC1OnServer(BuildContext? context) async {
  retrieveDOC1ById(context, DataSync.getUpdateOnServerStr(),
          DataSync.getUpdateOnServerList())
      .then((snapshot) {
    print(snapshot);
    snapshot.forEach((data) async {
      var res = await http.put(Uri.parse(prefix + 'DOC1/Update'),
          headers: header, body: jsonEncode(data.toJson()));
      print(res.body);
    });
  });
}
