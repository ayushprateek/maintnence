import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

List<OVCLModel> OVCLModelFromJson(String str) =>
    List<OVCLModel>.from(json.decode(str).map((x) => OVCLModel.fromJson(x)));

String OVCLModelToJson(List<OVCLModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OVCLModel {
  OVCLModel({
    required this.ID,
    required this.Code,
    required this.TruckNo,
    required this.CreateDate,
    required this.UpdateDate,
    this.hasCreated = false,
    required this.TareWeight,
    required this.GrossWeight,
    required this.LoadingCap,
    required this.Volume,
    required this.EngineNo,
    required this.ChasisNo,
    required this.FuelCapacity,
    required this.Active,
    required this.Own,
    required this.EmpId,
    required this.EmpDesc,
    this.TransCode,
    this.TrnasName,
    this.CreatedBy,
    this.UpdatedBy,
    this.BranchId,
    this.TrnsType,
  });

  int ID;
  String Code;
  String TruckNo;
  double TareWeight;
  double GrossWeight;
  double LoadingCap;
  double Volume;
  String EngineNo;
  DateTime CreateDate;
  DateTime UpdateDate;
  bool hasCreated;
  String ChasisNo;
  double FuelCapacity;
  bool Active;
  bool Own;
  String EmpId;
  String EmpDesc;
  String? TransCode;
  String? TrnasName;
  String? CreatedBy;
  String? UpdatedBy;
  String? BranchId;
  String? TrnsType;

  factory OVCLModel.fromJson(Map<String, dynamic> json) => OVCLModel(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        Code: json["Code"] ?? "",
        TruckNo: json["TruckNo"] ?? "",
        TareWeight: double.tryParse(json["TareWeight"].toString()) ?? 0.0,
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] == 1,
        GrossWeight: double.tryParse(json["GrossWeight"].toString()) ?? 0.0,
        LoadingCap: double.tryParse(json["LoadingCap"].toString()) ?? 0.0,
        Volume: double.tryParse(json["Volume"].toString()) ?? 0.0,
        EngineNo: json["EngineNo"] ?? "",
        ChasisNo: json["ChasisNo"] ?? "",
        FuelCapacity: double.tryParse(json["FuelCapacity"].toString()) ?? 0.0,
        Active: json["Active"] is bool ? json["Active"] : json["Active"] == 1,
        Own: json["Own"] is bool ? json["Own"] : json["Own"] == 1,
        EmpId: json["EmpId"] ?? "",
        EmpDesc: json["EmpDesc"] ?? "",
        TransCode: json['TransCode'] ?? '',
        TrnasName: json['TrnasName'] ?? '',
        CreatedBy: json['CreatedBy'] ?? '',
        UpdatedBy: json['UpdatedBy'] ?? '',
        BranchId: json['BranchId'] ?? '',
        TrnsType: json['TrnsType'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "Code": Code,
        "TruckNo": TruckNo,
        "TareWeight": TareWeight,
        "CreateDate": CreateDate.toIso8601String(),
        "UpdateDate": UpdateDate.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "GrossWeight": GrossWeight,
        "LoadingCap": LoadingCap,
        "Volume": Volume,
        "EngineNo": EngineNo,
        "ChasisNo": ChasisNo,
        "FuelCapacity": FuelCapacity,
        "Active": Active == true ? 1 : 0,
        "Own": Own == true ? 1 : 0,
        "EmpId": EmpId,
        "EmpDesc": EmpDesc,
        'TransCode': TransCode,
        'TrnasName': TrnasName,
        'CreatedBy': CreatedBy,
        'UpdatedBy': UpdatedBy,
        'BranchId': BranchId,
        'TrnsType': TrnsType,
      };
}

Future<List<OVCLModel>> dataSyncOVCL() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "OVCL" + postfix));
  print(res.body);
  return OVCLModelFromJson(res.body);
}

Future<List<OVCLModel>> retrieveOVCL(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('OVCL');
  return queryResult.map((e) => OVCLModel.fromJson(e)).toList();
}

Future<List<OVCLModel>> retrieveVehicleForSearch({
  int? limit,
  String? query,
}) async {
  query="%$query%";
  final Database db = await initializeDB(null);
  final List<Map<String, Object?>> queryResult = await db.rawQuery('SELECT * FROM OVCL WHERE Code LIKE "$query" OR TruckNo LIKE "$query" LIMIT $limit');
  return queryResult.map((e) => OVCLModel.fromJson(e)).toList();
}


Future<List<OVCLModel>> retrieveOVCLForSearch({
  int? limit,
  String? query,
}) async {
  query="%$query%";
  final Database db = await initializeDB(null);
  final List<Map<String, Object?>> queryResult = await db.rawQuery('SELECT * FROM OVCL WHERE Code LIKE "$query" LIMIT $limit');
  return queryResult.map((e) => OVCLModel.fromJson(e)).toList();
}
Future<void> updateOVCL(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update("OVCL", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteOVCL(Database db) async {
  await db.delete('OVCL');
}

// Future<void> insertOVCL(Database db)async{
//   if(postfix.toLowerCase().contains("all"))
//   await deleteOVCL(db);
//   List customers= await dataSyncOVCL();
//   print(customers);
//   var batch = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try
//     {
//       batch.insert('OVCL', customer.toJson());
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
//   //       await db.insert('OVCL', customer.toJson());
//   //     });
//   //   }
//   //   catch(e)
//   //   {
//   //     getErrorSnackBar("Sync Error "+e.toString());
//   //   }
//   //
//   // });
// }
// Future<void> insertOVCL(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteOVCL(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncOVCL();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('OVCL_Temp', customer.toJson());
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
//       "SELECT * FROM  OVCL_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("OVCL", element,
//         where: "Code = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["Code"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from OVCL_Temp where Code not in (Select Code from OVCL)");
//   v.forEach((element) {
//     batch3.insert('OVCL', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('OVCL_Temp');
// }
Future<void> insertOVCL(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteOVCL(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncOVCL();
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
      for (OVCLModel record in batchRecords) {
        try {
          batch.insert('OVCL_Temp', record.toJson());
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
			select * from OVCL_Temp
			except
			select * from OVCL
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
          batch.update("OVCL", element,
              where: "Code = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
              whereArgs: [element["Code"], 1, 1]);
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
  print('Time taken for OVCL update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from OVCL_Temp where Code not in (Select Code from OVCL)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM OVCL_Temp T0
LEFT JOIN OVCL T1 ON T0.Code = T1.Code 
WHERE T1.Code IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('OVCL', record);
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
      'Time taken for OVCL_Temp and OVCL compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('OVCL_Temp');
  // stopwatch.stop();
}

//SEND DATA TO SERVER
//--------------------------
Future<List<OVCLModel>> retrieveOVCLById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('OVCL', where: str, whereArgs: l);
  return queryResult.map((e) => OVCLModel.fromJson(e)).toList();
}

Future<void> insertOVCLToServer(BuildContext context) async {
  retrieveOVCLById(context, DataSync.getInsertToServerStr(),
          DataSync.getInsertToServerList())
      .then((snapshot) {
    print(snapshot);
    snapshot.forEach((data) async {
      var res = await http.post(Uri.parse(prefix + "OVCL/Add"),
          headers: header, body: jsonEncode(data.toJson()));
      print(res.body);
    });
  });
}

Future<void> updateOVCLOnServer(BuildContext? context) async {
  retrieveOVCLById(context, DataSync.getUpdateOnServerStr(),
          DataSync.getUpdateOnServerList())
      .then((snapshot) {
    print(snapshot);
    snapshot.forEach((data) async {
      var res = await http.put(Uri.parse(prefix + 'OVCL/Update'),
          headers: header, body: jsonEncode(data.toJson()));
      print(res.body);
    });
  });
}
