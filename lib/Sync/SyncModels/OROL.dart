import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

List<OROLModel> OROLModelFromJson(String str) =>
    List<OROLModel>.from(json.decode(str).map((x) => OROLModel.fromJson(x)));

String OROLModelToJson(List<OROLModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OROLModel {
  OROLModel({
    required this.ID,
    required this.ShortDesc,
    required this.Remarks,
    required this.Active,
    required this.CreateDate,
    required this.UpdateDate,
    this.hasCreated = false,
    this.CreatedBy,
    this.UpdatedBy,
    this.BranchId,
  });

  int ID;
  String ShortDesc;
  DateTime CreateDate;
  DateTime UpdateDate;
  bool hasCreated;
  String Remarks;
  bool Active;
  String? CreatedBy;
  String? UpdatedBy;
  String? BranchId;

  factory OROLModel.fromJson(Map<String, dynamic> json) => OROLModel(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        ShortDesc: json["ShortDesc"] ?? "",
        Remarks: json["Remarks"] ?? "",
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] == 1,
        Active: json["Active"] is bool ? json["Active"] : json["Active"] == 1,
        CreatedBy: json['CreatedBy'] ?? '',
        UpdatedBy: json['UpdatedBy'] ?? '',
        BranchId: json['BranchId'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "ShortDesc": ShortDesc,
        "CreateDate": CreateDate.toIso8601String(),
        "UpdateDate": UpdateDate.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "Remarks": Remarks,
        "Active": Active == true ? 1 : 0,
        'CreatedBy': CreatedBy,
        'UpdatedBy': UpdatedBy,
        'BranchId': BranchId,
      };
}

Future<List<OROLModel>> dataSyncOROL() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "OROL" + postfix));
  print(res.body);
  return OROLModelFromJson(res.body);
}

Future<List<OROLModel>> retrieveOROL(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('OROL');
  return queryResult.map((e) => OROLModel.fromJson(e)).toList();
}

Future<void> updateOROL(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update("OROL", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteOROL(Database db) async {
  await db.delete('OROL');
}

// Future<void> insertOROL(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteOROL(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncOROL();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('OROL_Temp', customer.toJson());
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
//       "SELECT * FROM  OROL_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("OROL", element,
//         where: "ShortDesc = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["ShortDesc"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from OROL_Temp where ShortDesc not in (Select ShortDesc from OROL)");
//   v.forEach((element) {
//     batch3.insert('OROL', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('OROL_Temp');
// }
Future<void> insertOROL(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteOROL(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncOROL();
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
      for (OROLModel record in batchRecords) {
        try {
          batch.insert('OROL_Temp', record.toJson());
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
			select * from OROL_Temp
			except
			select * from OROL
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
          batch.update("OROL", element,
              where:
                  "ShortDesc = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
              whereArgs: [element["ShortDesc"], 1, 1]);
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
  print('Time taken for OROL update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from OROL_Temp where ShortDesc not in (Select ShortDesc from OROL)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM OROL_Temp T0
LEFT JOIN OROL T1 ON T0.ShortDesc = T1.ShortDesc 
WHERE T1.ShortDesc IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('OROL', record);
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
      'Time taken for OROL_Temp and OROL compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('OROL_Temp');
  // stopwatch.stop();
}

//SEND DATA TO SERVER
//--------------------------
Future<List<OROLModel>> retrieveOROLById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('OROL', where: str, whereArgs: l);
  return queryResult.map((e) => OROLModel.fromJson(e)).toList();
}

// Future<void> insertOROLToServer(BuildContext context) async {
//   retrieveOROLById(context, DataSync.getInsertToServerStr(),
//           DataSync.getInsertToServerList())
//       .then((snapshot) {
//     print(snapshot);
//     snapshot.forEach((data) async {
//       var res = await http.post(Uri.parse(prefix + "OROL/Add"),
//           headers: header, body: jsonEncode(data.toJson()));
//       print(res.body);
//     });
//   });
// }
//
// Future<void> updateOROLOnServer(BuildContext? context) async {
//   retrieveOROLById(context, DataSync.getUpdateOnServerStr(),
//           DataSync.getUpdateOnServerList())
//       .then((snapshot) {
//     print(snapshot);
//     snapshot.forEach((data) async {
//       var res = await http.put(Uri.parse(prefix + 'OROL/Update'),
//           headers: header, body: jsonEncode(data.toJson()));
//       print(res.body);
//     });
//   });
// }
