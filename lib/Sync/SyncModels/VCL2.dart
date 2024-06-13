import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

List<VCL2Model> VCL2ModelFromJson(String str) =>
    List<VCL2Model>.from(json.decode(str).map((x) => VCL2Model.fromJson(x)));

String VCL2ModelToJson(List<VCL2Model> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VCL2Model {
  VCL2Model({
    required this.ID,
    required this.Code,
    required this.CreateDate,
    required this.UpdateDate,
    this.hasCreated = false,
    required this.RowId,
    required this.RouteCode,
    required this.RouteName,
  });

  int ID;

  DateTime CreateDate;
  DateTime UpdateDate;
  bool hasCreated;
  String Code;
  int RowId;
  String RouteCode;
  String RouteName;

  factory VCL2Model.fromJson(Map<String, dynamic> json) => VCL2Model(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] == 1,
        Code: json["Code"] ?? "",
        RowId: int.tryParse(json["RowId"].toString()) ?? 0,
        RouteCode: json["RouteCode"] ?? "",
        RouteName: json["RouteName"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "CreateDate": CreateDate.toIso8601String(),
        "UpdateDate": UpdateDate.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "Code": Code,
        "RowId": RowId,
        "RouteCode": RouteCode,
        "RouteName": RouteName,
      };
}

Future<List<VCL2Model>> dataSyncVCL2() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "VCL2" + postfix));
  print(res.body);
  return VCL2ModelFromJson(res.body);
}

Future<List<VCL2Model>> retrieveVCL2(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('VCL2');
  return queryResult.map((e) => VCL2Model.fromJson(e)).toList();
}

Future<void> updateVCL2(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update("VCL2", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteVCL2(Database db) async {
  await db.delete('VCL2');
}

// Future<void> insertVCL2(Database db) async {
//   if(postfix.toLowerCase().contains("all"))
//   await deleteVCL2(db);
//   List customers = await dataSyncVCL2();
//   print(customers);
//   var batch = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try
//     {
//       batch.insert('VCL2', customer.toJson());
//     }
//     catch(e)
//     {
//       getErrorSnackBar("Sync Error "+e.toString());
//     }
//   });
//   await batch.commit(noResult: true);
//   // customers.forEach((customer) async {
//   //   print(customer.toJson());
//   //   try
//   //   {
//   //     db.transaction((db)async{
//   //       await db.insert('VCL2', customer.toJson());
//   //     });
//   //   }
//   //   catch(e)
//   //   {
//   //     getErrorSnackBar("Sync Error "+e.toString());
//   //   }
//   //
//   // });
// }
// Future<void> insertVCL2(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteVCL2(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncVCL2();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('VCL2_Temp', customer.toJson());
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
//       "SELECT * FROM  VCL2_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("VCL2", element,
//         where:
//             "Code = ? AND RouteCode = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["Code"], element["RouteCode"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from VCL2_Temp where Code || RouteCode not in (Select Code || RouteCode from VCL2)");
//   v.forEach((element) {
//     batch3.insert('VCL2', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('VCL2_Temp');
// }
Future<void> insertVCL2(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteVCL2(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncVCL2();
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
      for (VCL2Model record in batchRecords) {
        try {
          batch.insert('VCL2_Temp', record.toJson());
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
			select * from VCL2_Temp
			except
			select * from VCL2
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
          batch.update("VCL2", element,
              where:
                  "Code = ? AND RouteCode = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
              whereArgs: [element["Code"], element["RouteCode"], 1, 1]);
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
  print('Time taken for VCL2 update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from VCL2_Temp where Code || RouteCode not in (Select Code || RouteCode from VCL2)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM VCL2_Temp T0
LEFT JOIN VCL2 T1 ON T0.Code = T1.Code AND T0.RouteCode = T1.RouteCode
WHERE T1.Code IS NULL AND T1.RouteCode IS NULL;
''');

  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('VCL2', record);
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
      'Time taken for VCL2_Temp and VCL2 compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('VCL2_Temp');
  // stopwatch.stop();
}

//SEND DATA TO SERVER
//--------------------------
Future<List<VCL2Model>> retrieveVCL2ById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('VCL2', where: str, whereArgs: l);
  return queryResult.map((e) => VCL2Model.fromJson(e)).toList();
}

Future<void> insertVCL2ToServer(BuildContext context) async {
  retrieveVCL2ById(context, DataSync.getInsertToServerStr(),
          DataSync.getInsertToServerList())
      .then((snapshot) {
    print(snapshot);
    snapshot.forEach((data) async {
      var res = await http.post(Uri.parse(prefix + "VCL2/Add"),
          headers: header, body: jsonEncode(data.toJson()));
      print(res.body);
    });
  });
}

Future<void> updateVCL2OnServer(BuildContext? context) async {
  retrieveVCL2ById(context, DataSync.getUpdateOnServerStr(),
          DataSync.getUpdateOnServerList())
      .then((snapshot) {
    print(snapshot);
    snapshot.forEach((data) async {
      var res = await http.put(Uri.parse(prefix + 'VCL2/Update'),
          headers: header, body: jsonEncode(data.toJson()));
      print(res.body);
    });
  });
}
