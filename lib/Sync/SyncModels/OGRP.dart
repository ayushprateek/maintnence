import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

List<OGRPModel> OGRPModelFromJson(String str) =>
    List<OGRPModel>.from(json.decode(str).map((x) => OGRPModel.fromJson(x)));

String OGRPModelToJson(List<OGRPModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OGRPModel {
  OGRPModel({
    required this.CreateDate,
    required this.UpdateDate,
    this.hasCreated = false,
    required this.ID,
    required this.GrpDesc,
    required this.SubGroup,
    this.CreatedBy,
    this.BranchId,
    this.UpdatedBy,
  });

  int ID;
  String GrpDesc;
  String SubGroup;
  DateTime CreateDate;
  DateTime UpdateDate;
  bool hasCreated;
  String? CreatedBy;
  String? BranchId;
  String? UpdatedBy;

  factory OGRPModel.fromJson(Map<String, dynamic> json) => OGRPModel(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] == 1,
        GrpDesc: json["GrpDesc"] ?? "",
        SubGroup: json["SubGroup"] ?? "",
        CreatedBy: json['CreatedBy'] ?? '',
        BranchId: json['BranchId'] ?? '',
        UpdatedBy: json['UpdatedBy'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "GrpDesc": GrpDesc,
        "CreateDate": CreateDate.toIso8601String(),
        "UpdateDate": UpdateDate.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "SubGroup": SubGroup,
        'CreatedBy': CreatedBy,
        'BranchId': BranchId,
        'UpdatedBy': UpdatedBy,
      };
}

Future<List<OGRPModel>> dataSyncOGRP() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "OGRP" + postfix));
  print(res.body);
  return OGRPModelFromJson(res.body);
}

Future<List<OGRPModel>> retrieveOGRP(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('OGRP');
  return queryResult.map((e) => OGRPModel.fromJson(e)).toList();
}

Future<void> updateOGRP(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    await db.transaction((db) async {
      await db.update("OGRP", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteOGRP(Database db) async {
  await db.delete('OGRP');
}

// Future<void> insertOGRP(Database db)async{
//   if(postfix.toLowerCase().contains("all"))
//   await deleteOGRP(db);
//   List customers= await dataSyncOGRP();
//   print(customers);
//
//   var batch = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try
//     {
//       batch.insert('OGRP', customer.toJson());
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
//   //       await db.insert('OGRP', customer.toJson());
//   //     });
//   //   }
//   //   catch(e)
//   //   {
//   //     getErrorSnackBar("Sync Error "+e.toString());
//   //   }
//   //
//   // });
//
// }
// Future<void> insertOGRP(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteOGRP(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncOGRP();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('OGRP_Temp', customer.toJson());
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
//       "SELECT * FROM  OGRP_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("OGRP", element,
//         where: "GrpDesc = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["GrpDesc"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from OGRP_Temp where GrpDesc not in (Select GrpDesc from OGRP)");
//   v.forEach((element) {
//     batch3.insert('OGRP', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('OGRP_Temp');
// }
Future<void> insertOGRP(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteOGRP(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncOGRP();
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
      for (OGRPModel record in batchRecords) {
        try {
          batch.insert('OGRP_Temp', record.toJson());
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
			select * from OGRP_Temp
			except
			select * from OGRP
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
          batch.update("OGRP", element,
              where: "GrpDesc = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
              whereArgs: [element["GrpDesc"], 1, 1]);

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
  print('Time taken for OGRP update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from OGRP_Temp where GrpDesc not in (Select GrpDesc from OGRP)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM OGRP_Temp T0
LEFT JOIN OGRP T1 ON T0.GrpDesc = T1.GrpDesc 
WHERE T1.GrpDesc IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('OGRP', record);
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
      'Time taken for OGRP_Temp and OGRP compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('OGRP_Temp');
  // stopwatch.stop();
}

//SEND DATA TO SERVER
//--------------------------
Future<List<OGRPModel>> retrieveOGRPById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('OGRP', where: str, whereArgs: l);
  return queryResult.map((e) => OGRPModel.fromJson(e)).toList();
}

Future<void> insertOGRPToServer(BuildContext context) async {
  retrieveOGRPById(context, DataSync.getInsertToServerStr(),
          DataSync.getInsertToServerList())
      .then((snapshot) {
    print(snapshot);
    snapshot.forEach((data) async {
      var res = await http.post(Uri.parse(prefix + "OGRP/Add"),
          headers: header, body: jsonEncode(data.toJson()));
      print(res.body);
    });
  });
}

Future<void> updateOGRPOnServer(BuildContext? context) async {
  retrieveOGRPById(context, DataSync.getUpdateOnServerStr(),
          DataSync.getUpdateOnServerList())
      .then((snapshot) {
    print(snapshot);
    snapshot.forEach((data) async {
      var res = await http.put(Uri.parse(prefix + 'OGRP/Update'),
          headers: header, body: jsonEncode(data.toJson()));
      print(res.body);
    });
  });
}
