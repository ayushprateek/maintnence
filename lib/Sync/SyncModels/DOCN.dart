import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

List<DOCNModel> DOCNModelFromJson(String str) =>
    List<DOCNModel>.from(json.decode(str).map((x) => DOCNModel.fromJson(x)));

String DOCNModelToJson(List<DOCNModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DOCNModel {
  DOCNModel({
    required this.ID,
    required this.DocName,
    required this.DocNumber,
    required this.MDocNumber,
    required this.Notes,
    required this.CreateDate,
    required this.UpdateDate,
    this.hasCreated = false,
    this.CreatedBy,
    this.BranchId,
    this.UpdatedBy,
  });

  int ID;
  String DocName;
  int DocNumber;
  int MDocNumber;
  DateTime CreateDate;
  DateTime UpdateDate;
  bool hasCreated;
  String Notes;
  String? CreatedBy;
  String? BranchId;
  String? UpdatedBy;

  factory DOCNModel.fromJson(Map<String, dynamic> json) => DOCNModel(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] == 1,
        DocName: json["DocName"] ?? "",
        DocNumber: int.tryParse(json["DocNumber"].toString()) ?? 0,
        MDocNumber: int.tryParse(json["MDocNumber"].toString()) ?? 0,
        Notes: json["Notes"] ?? "",
        CreatedBy: json["CreatedBy"] ?? "",
        BranchId: json['BranchId'] ?? '',
        UpdatedBy: json['UpdatedBy'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "CreateDate": CreateDate.toIso8601String(),
        "UpdateDate": UpdateDate.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "DocName": DocName,
        "DocNumber": DocNumber,
        "MDocNumber": MDocNumber,
        "Notes": Notes,
        "CreatedBy": CreatedBy,
        'BranchId': BranchId,
        'UpdatedBy': UpdatedBy,
      };
}

Future<List<DOCNModel>> dataSyncDOCN() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "DOCN" + postfix));
  print(res.body);
  return DOCNModelFromJson(res.body);
}

// Future<void> insertDOCN(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteDOCN(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncDOCN();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('DOCN_Temp', customer.toJson());
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
//       "SELECT * FROM  DOCN_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("DOCN", element,
//         where: "DocName = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["DocName"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from DOCN_Temp where DocName  not in (Select DocName from DOCN)");
//   v.forEach((element) {
//     batch3.insert('DOCN', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('DOCN_Temp');
// }

Future<void> insertDOCN(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteDOCN(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncDOCN();
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
      for (DOCNModel record in batchRecords) {
        try {
          batch.insert('DOCN_Temp', record.toJson());
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
			select * from DOCN_Temp
			except
			select * from DOCN
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
          batch.update("DOCN", element,
              where:
                  "DocName = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
              whereArgs: [element["DocName"], 1, 1]);
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
  print('Time taken for DOCN update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from DOCN_Temp where DocName  not in (Select DocName from DOCN)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM DOCN_Temp T0
LEFT JOIN DOCN T1 ON T0.DocName = T1.DocName 
WHERE T1.DocName IS NULL;
''');

  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('DOCN', record);
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
      'Time taken for DOCN_Temp and DOCN compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('DOCN_Temp');
  // stopwatch.stop();
}

Future<List<DOCNModel>> retrieveDOCN(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('DOCN');
  return queryResult.map((e) => DOCNModel.fromJson(e)).toList();
}

Future<void> updateDOCN(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update("DOCN", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteDOCN(Database db) async {
  await db.delete('DOCN');
}

//SEND DATA TO SERVER
//--------------------------
Future<List<DOCNModel>> retrieveDOCNById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('DOCN', where: str, whereArgs: l);
  return queryResult.map((e) => DOCNModel.fromJson(e)).toList();
}

Future<void> insertDOCNToServer(BuildContext context) async {
  retrieveDOCNById(context, DataSync.getInsertToServerStr(),
          DataSync.getInsertToServerList())
      .then((snapshot) {
    print(snapshot);
    snapshot.forEach((data) async {
      var res = await http.post(Uri.parse(prefix + "DOCN/Add"),
          headers: header, body: jsonEncode(data.toJson()));
      print(res.body);
    });
  });
}

Future<void> updateDOCNOnServer(BuildContext? context) async {
  retrieveDOCNById(context, DataSync.getUpdateOnServerStr(),
          DataSync.getUpdateOnServerList())
      .then((snapshot) {
    print(snapshot);
    snapshot.forEach((data) async {
      var res = await http.put(Uri.parse(prefix + 'DOCN/Update'),
          headers: header, body: jsonEncode(data.toJson()));
      print(res.body);
    });
  });
}
