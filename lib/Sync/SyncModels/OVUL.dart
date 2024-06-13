import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

List<OVULModel> OVULModelFromJson(String str) =>
    List<OVULModel>.from(json.decode(str).map((x) => OVULModel.fromJson(x)));

String OVULModelToJson(List<OVULModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OVULModel {
  OVULModel({
    required this.CreateDate,
    required this.UpdateDate,
    this.hasCreated = false,
    required this.ID,
    required this.DocEntry,
    this.PermanentTransId,
    required this.TransId,
    required this.BaseTransId,
    required this.RouteCode,
    required this.RouteName,
    required this.VehCode,
    required this.TruckNo,
    required this.TotalWeight,
    required this.Volume,
    required this.LoadingCap,
    required this.DriverName,
    required this.LoadingStatus,
    required this.DocStatus,
    required this.LoadDate,
    required this.LoadTime,
    required this.ApprovalStatus,
    required this.ApprovedBy,
    required this.CreatedBy,
    required this.Error,
    required this.DocNum,
    required this.IsPosted,
    this.UpdatedBy,
    this.BranchId,
    this.Remarks,
    this.LocalDate,
    this.WhsCode,
  });

  int ID;
  int DocEntry;
  String DocNum;
  String CreatedBy;
  String? PermanentTransId;
  String TransId;
  String BaseTransId;
  String RouteCode;
  String DocStatus;
  String Error;
  String DriverName;
  String RouteName;
  String LoadingStatus;
  String ApprovalStatus;
  String VehCode;
  String TruckNo;
  String ApprovedBy;
  double TotalWeight;
  double Volume;
  double LoadingCap;
  DateTime CreateDate;
  DateTime LoadDate;
  DateTime UpdateDate;
  bool hasCreated;
  DateTime LoadTime;
  bool IsPosted;
  String? UpdatedBy;
  String? BranchId;
  String? Remarks;
  String? LocalDate;
  String? WhsCode;

  factory OVULModel.fromJson(Map<String, dynamic> json) => OVULModel(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        DocEntry: int.tryParse(json["DocEntry"].toString()) ?? 0,
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        LoadDate: DateTime.tryParse(json["LoadDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        LoadTime: DateTime.tryParse(json["LoadTime"].toString()) ??
            DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] == 1,
        ApprovalStatus: json["ApprovalStatus"] ?? "",
        DriverName: json["DriverName"] ?? "",
        DocNum: json["DocNum"] ?? "",
        Error: json["Error"] ?? "",
        CreatedBy: json["CreatedBy"] ?? "",
        DocStatus: json["DocStatus"] ?? "",
        PermanentTransId: json["PermanentTransId"] ?? "",
        TransId: json["TransId"] ?? "",
        RouteCode: json["RouteCode"] ?? "",
        ApprovedBy: json["ApprovedBy"] ?? "",
        RouteName: json["RouteName"] ?? "",
        BaseTransId: json["BaseTransId"] ?? "",
        LoadingStatus: json["LoadingStatus"] ?? "",
        VehCode: json["VehCode"] ?? "",
        IsPosted:
            json["IsPosted"] is bool ? json["IsPosted"] : json["IsPosted"] == 1,
        TruckNo: json["TruckNo"] ?? "",
        TotalWeight: double.tryParse(json["TotalWeight"].toString()) ?? 0.0,
        Volume: double.tryParse(json["Volume"].toString()) ?? 0.0,
        LoadingCap: double.tryParse(json["LoadingCap"].toString()) ?? 0.0,
        UpdatedBy: json['UpdatedBy'] ?? '',
        BranchId: json['BranchId'] ?? '',
        Remarks: json['Remarks'] ?? '',
        LocalDate: json['LocalDate'] ?? '',
        WhsCode: json['WhsCode'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "DocEntry": DocEntry,
        "ID": ID,
        "Error": Error,
        "DocNum": DocNum,
        "VehCode": VehCode,
        "RouteCode": RouteCode,
        "DriverName": DriverName,
        "ApprovalStatus": ApprovalStatus,
        "LoadingStatus": LoadingStatus,
        "DocStatus": DocStatus,
        "ApprovedBy": ApprovedBy,
        "CreatedBy": CreatedBy,
        "PermanentTransId": PermanentTransId,
        "TransId": TransId,
        "LoadDate": LoadDate.toIso8601String(),
        "LoadTime": LoadTime.toIso8601String(),
        "CreateDate": CreateDate.toIso8601String(),
        "UpdateDate": UpdateDate.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "RouteName": RouteName,
        "BaseTransId": BaseTransId,
        "TruckNo": TruckNo,
        "TotalWeight": TotalWeight,
        "Volume": Volume,
        "IsPosted": IsPosted == true ? 1 : 0,
        "LoadingCap": LoadingCap,
        'UpdatedBy': UpdatedBy,
        'BranchId': BranchId,
        'Remarks': Remarks,
        'LocalDate': LocalDate,
        'WhsCode': WhsCode,
      };
}

Future<List<OVULModel>> dataSyncOVUL() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "OVUL" + postfix));
  print(res.body);
  return OVULModelFromJson(res.body);
}

Future<List<OVULModel>> retrieveOVUL(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('OVUL');
  return queryResult.map((e) => OVULModel.fromJson(e)).toList();
}

Future<void> updateOVUL(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update("OVUL", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteOVUL(Database db) async {
  await db.delete('OVUL');
}

// Future<void> insertOVUL(Database db)async{
//   if(postfix.toLowerCase().contains("all"))
//   await deleteOVUL(db);
//   List customers= await dataSyncOVUL();
//   print(customers);
//
//   var batch = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try
//     {
//       batch.insert('OVUL', customer.toJson());
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
//   //       await db.insert('OVUL', customer.toJson());
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
// Future<void> insertOVUL(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteOVUL(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncOVUL();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('OVUL_Temp', customer.toJson());
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
//       "SELECT * FROM  OVUL_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("OVUL", element,
//         where: "TransId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["TransId"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from OVUL_Temp where TransId not in (Select TransId from OVUL)");
//   v.forEach((element) {
//     batch3.insert('OVUL', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('OVUL_Temp');
// }
Future<void> insertOVUL(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteOVUL(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncOVUL();
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
      for (OVULModel record in batchRecords) {
        try {
          batch.insert('OVUL_Temp', record.toJson());
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
			select * from OVUL_Temp
			except
			select * from OVUL
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
          batch.update("OVUL", element,
              where:
                  "TransId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
              whereArgs: [element["TransId"], 1, 1]);
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
  print('Time taken for OVUL update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from OVUL_Temp where TransId not in (Select TransId from OVUL)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM OVUL_Temp T0
LEFT JOIN OVUL T1 ON T0.TransId = T1.TransId 
WHERE T1.TransId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('OVUL', record);
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
      'Time taken for OVUL_Temp and OVUL compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('OVUL_Temp');
  // stopwatch.stop();
}

//SEND DATA TO SERVER
//--------------------------
Future<List<OVULModel>> retrieveOVULById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('OVUL', where: str, whereArgs: l);
  return queryResult.map((e) => OVULModel.fromJson(e)).toList();
}

Future<void> insertOVULToServer(BuildContext context) async {
  retrieveOVULById(context, DataSync.getInsertToServerStr(),
          DataSync.getInsertToServerList())
      .then((snapshot) {
    print(snapshot);
    snapshot.forEach((data) async {
      var res = await http.post(Uri.parse(prefix + "OVUL/Add"),
          headers: header, body: jsonEncode(data.toJson()));
      print(res.body);
    });
  });
}

Future<void> updateOVULOnServer(BuildContext? context) async {
  retrieveOVULById(context, DataSync.getUpdateOnServerStr(),
          DataSync.getUpdateOnServerList())
      .then((snapshot) {
    print(snapshot);
    snapshot.forEach((data) async {
      var res = await http.put(Uri.parse(prefix + 'OVUL/Update'),
          headers: header, body: jsonEncode(data.toJson()));
      print(res.body);
    });
  });
}
