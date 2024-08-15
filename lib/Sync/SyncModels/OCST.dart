import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:sqflite/sqlite_api.dart';

List<OCSTModel> OCSTModelFromJson(String str) =>
    List<OCSTModel>.from(json.decode(str).map((x) => OCSTModel.fromJson(x)));

String OCSTModelToJson(List<OCSTModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OCSTModel {
  OCSTModel({
    required this.ID,
    required this.CountryCode,
    required this.CountryName,
    required this.StateCode,
    required this.StateName,
    required this.CreateDate,
    required this.UpdateDate,
    this.hasCreated = false,
    this.Active,
    this.CreatedBy,
    this.UpdatedBy,
    this.BranchId,
  });

  int ID;
  String CountryCode;
  String CountryName;
  String StateCode;
  DateTime CreateDate;
  DateTime UpdateDate;
  bool hasCreated;
  String StateName;
  bool? Active;
  String? CreatedBy;
  String? UpdatedBy;
  String? BranchId;

  factory OCSTModel.fromJson(Map<String, dynamic> json) => OCSTModel(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        CountryCode: json["CountryCode"] ?? "",
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] == 1,
        CountryName: json["CountryName"] ?? "",
        StateCode: json["StateCode"] ?? "",
        StateName: json["StateName"] ?? "",
        Active: json['Active'] is bool ? json['Active'] : json['Active'] == 1,
        CreatedBy: json['CreatedBy'] ?? '',
        UpdatedBy: json['UpdatedBy'] ?? '',
        BranchId: json['BranchId'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "CreateDate": CreateDate.toIso8601String(),
        "UpdateDate": UpdateDate.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "CountryCode": CountryCode,
        "CountryName": CountryName,
        "StateCode": StateCode,
        "StateName": StateName,
        'Active': Active,
        'CreatedBy': CreatedBy,
        'UpdatedBy': UpdatedBy,
        'BranchId': BranchId,
      };
}

Future<List<OCSTModel>> dataSyncOCST() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "OCST" + postfix));
  print(res.body);
  return OCSTModelFromJson(res.body);
}

Future<List<OCSTModel>> retrieveOCST(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('OCST');
  return queryResult.map((e) => OCSTModel.fromJson(e)).toList();
}

// Future<void> insertOCST(Database db)async{
//   if(postfix.toLowerCase().contains("all"))
//   await deleteOCST(db);
//   List customers= await dataSyncOCST();
//   print(customers);
//
//   var batch = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try
//     {
//       batch.insert('OCST', customer.toJson());
//     }
//     catch(e)
//     {
//       getErrorSnackBar("Sync Error "+e.toString());
//     }
//   });
//   await batch.commit(noResult: true);
//
//   // customers.forEach((customer) async {
//   //   print(customer.toJson());
//   //   try
//   //   {
//   //     db.transaction((db)async{
//   //       await db.insert('OCST', customer.toJson());
//   //     });
//   //   }
//   //   catch(e)
//   //   {
//   //     getErrorSnackBar("Sync Error "+e.toString());
//   //   }
//   //
//   // });
// }
// Future<void> insertOCST(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteOCST(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncOCST();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('OCST_Temp', customer.toJson());
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
//       "SELECT * FROM  OCST_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN UpdateDate IS NULL THEN CreateDate ELSE UpdateDate END)");
//   u.forEach((element) {
//     batch2.update("OCST", element,
//         where: "StateCode = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["StateCode"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from OCST_Temp where StateCode not in (Select StateCode from OCST)");
//   v.forEach((element) {
//     batch3.insert('OCST', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('OCST_Temp');
// }
Future<void> insertOCST(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteOCST(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncOCST();
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
      for (OCSTModel record in batchRecords) {
        try {
          batch.insert('OCST_Temp', record.toJson());
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
			select * from OCST_Temp
			except
			select * from OCST
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
          batch.update("OCST", element,
              where:
                  "StateCode = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
              whereArgs: [element["StateCode"], 1, 1]);
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
  print('Time taken for OCST update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from OCST_Temp where StateCode not in (Select StateCode from OCST)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM OCST_Temp T0
LEFT JOIN OCST T1 ON T0.StateCode = T1.StateCode 
WHERE T1.StateCode IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('OCST', record);
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
      'Time taken for OCST_Temp and OCST compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('OCST_Temp');
  // stopwatch.stop();
}

Future<void> updateOCST(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    await db.transaction((db) async {
      await db.update("OCST", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteOCST(Database db) async {
  await db.delete('OCST');
}

//SEND DATA TO SERVER
//--------------------------
Future<List<OCSTModel>> retrieveOCSTById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('OCST', where: str, whereArgs: l);
  return queryResult.map((e) => OCSTModel.fromJson(e)).toList();
}

// Future<void> insertOCSTToServer(BuildContext context) async {
//   retrieveOCSTById(context, DataSync.getInsertToServerStr(),
//           DataSync.getInsertToServerList())
//       .then((snapshot) {
//     print(snapshot);
//     snapshot.forEach((data) async {
//       var res = await http.post(Uri.parse(prefix + "OCST/Add"),
//           headers: header, body: jsonEncode(data.toJson()));
//       print(res.body);
//     });
//   });
// }
//
// Future<void> updateOCSTOnServer(BuildContext? context) async {
//   retrieveOCSTById(context, DataSync.getUpdateOnServerStr(),
//           DataSync.getUpdateOnServerList())
//       .then((snapshot) {
//     print(snapshot);
//     snapshot.forEach((data) async {
//       var res = await http.put(Uri.parse(prefix + 'OCST/Update'),
//           headers: header, body: jsonEncode(data.toJson()));
//       print(res.body);
//     });
//   });
// }
