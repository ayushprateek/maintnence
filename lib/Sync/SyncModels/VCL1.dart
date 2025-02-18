import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

List<VCL1Model> VCL1ModelFromJson(String str) =>
    List<VCL1Model>.from(json.decode(str).map((x) => VCL1Model.fromJson(x)));

String VCL1ModelToJson(List<VCL1Model> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VCL1Model {
  VCL1Model({
    required this.ID,
    required this.Code,
    required this.RowId,
    required this.DriverName,
    required this.CreateDate,
    required this.UpdateDate,
    this.hasCreated = false,
    this.Own,
    this.EmpId,
    this.NrcNo,
    this.DriverMobileNo,
  });

  int ID;
  String Code;
  int RowId;
  String DriverName;
  DateTime CreateDate;
  DateTime UpdateDate;
  bool hasCreated;
  bool? Own;
  String? EmpId;
  String? NrcNo;
  String? DriverMobileNo;

  factory VCL1Model.fromJson(Map<String, dynamic> json) => VCL1Model(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        Code: json["Code"] ?? "",
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] == 1,
        RowId: int.tryParse(json["RowId"].toString()) ?? 0,
        DriverName: json["DriverName"] ?? "",
        Own: json['Own'] is bool ? json['Own'] : json['Own'] == 1,
        EmpId: json['EmpId'] ?? '',
        NrcNo: json['NrcNo'] ?? '',
        DriverMobileNo: json['DriverMobileNo'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "Code": Code,
        "RowId": RowId,
        "CreateDate": CreateDate.toIso8601String(),
        "UpdateDate": UpdateDate.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "DriverName": DriverName,
        'Own': Own,
        'EmpId': EmpId,
        'NrcNo': NrcNo,
        'DriverMobileNo': DriverMobileNo,
      };
}

Future<List<VCL1Model>> dataSyncVCL1() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "VCL1" + postfix));
  print(res.body);
  return VCL1ModelFromJson(res.body);
}

Future<List<VCL1Model>> retrieveVCL1(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('VCL1');
  return queryResult.map((e) => VCL1Model.fromJson(e)).toList();
}

Future<void> updateVCL1(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update("VCL1", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteVCL1(Database db) async {
  await db.delete('VCL1');
}

// Future<void> insertVCL1(Database db)async{
//   if(postfix.toLowerCase().contains("all"))
//   await deleteVCL1(db);
//   List customers= await dataSyncVCL1();
//   print(customers);
//   var batch = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try
//     {
//       batch.insert('VCL1', customer.toJson());
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
//   //       await db.insert('VCL1', customer.toJson());
//   //     });
//   //   }
//   //   catch(e)
//   //   {
//   //     getErrorSnackBar("Sync Error "+e.toString());
//   //   }
//   //
//   // });
// }
// Future<void> insertVCL1(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteVCL1(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncVCL1();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('VCL1_Temp', customer.toJson());
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
//       "SELECT * FROM  VCL1_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("VCL1", element,
//         where:
//             "Code = ? AND RowId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["Code"], element["RowId"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from VCL1_Temp where Code || RowId not in (Select Code | RowId from VCL1)");
//   v.forEach((element) {
//     batch3.insert('VCL1', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('VCL1_Temp');
// }
Future<void> insertVCL1(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteVCL1(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncVCL1();
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
      for (VCL1Model record in batchRecords) {
        try {
          batch.insert('VCL1_Temp', record.toJson());
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
			select * from VCL1_Temp
			except
			select * from VCL1
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
          batch.update("VCL1", element,
              where:
                  "Code = ? AND RowId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
              whereArgs: [element["Code"], element["RowId"], 1, 1]);
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
  print('Time taken for VCL1 update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from VCL1_Temp where Code || RowId not in (Select Code | RowId from VCL1)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM VCL1_Temp T0
LEFT JOIN VCL1 T1 ON T0.Code = T1.Code AND T0.RowId = T1.RowId
WHERE T1.Code IS NULL AND T1.RowId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('VCL1', record);
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
      'Time taken for VCL1_Temp and VCL1 compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('VCL1_Temp');
  // stopwatch.stop();
}

//SEND DATA TO SERVER
//--------------------------
Future<List<VCL1Model>> retrieveVCL1ById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('VCL1', where: str, whereArgs: l);
  return queryResult.map((e) => VCL1Model.fromJson(e)).toList();
}

// Future<void> insertVCL1ToServer(BuildContext context) async {
//   retrieveVCL1ById(context, DataSync.getInsertToServerStr(),
//           DataSync.getInsertToServerList())
//       .then((snapshot) {
//     print(snapshot);
//     snapshot.forEach((data) async {
//       var res = await http.post(Uri.parse(prefix + "VCL1/Add"),
//           headers: header, body: jsonEncode(data.toJson()));
//       print(res.body);
//     });
//   });
// }
//
// Future<void> updateVCL1OnServer(BuildContext? context) async {
//   retrieveVCL1ById(context, DataSync.getUpdateOnServerStr(),
//           DataSync.getUpdateOnServerList())
//       .then((snapshot) {
//     print(snapshot);
//     snapshot.forEach((data) async {
//       var res = await http.put(Uri.parse(prefix + 'VCL1/Update'),
//           headers: header, body: jsonEncode(data.toJson()));
//       print(res.body);
//     });
//   });
// }
