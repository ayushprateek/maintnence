import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

List<OAMRModel> OAMRModelFromJson(String str) =>
    List<OAMRModel>.from(json.decode(str).map((x) => OAMRModel.fromJson(x)));

String OAMRModelToJson(List<OAMRModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OAMRModel {
  OAMRModel({
    required this.ID,
    required this.RoleId,
    required this.RoleShortDesc,
    required this.MenuId,
    required this.MenuPath,
    required this.MenuDesc,
    required this.CreateDate,
    required this.UpdateDate,
    this.hasCreated = false,
    required this.Active,
    required this.ReadOnly,
    required this.Self,
    required this.BranchName,
    this.ParentMenuId,
    this.IsCreate,
    this.IsFull,
    this.IsEdit,
    this.CreatedBy,
    this.UpdatedBy,
    this.BranchId,
    this.Company,
  });

  int ID;
  int RoleId;
  String RoleShortDesc;
  int MenuId;
  String MenuPath;
  String MenuDesc;
  bool Active;
  DateTime CreateDate;
  DateTime UpdateDate;
  bool hasCreated;
  bool ReadOnly;
  bool Self;
  bool BranchName;
  int? ParentMenuId;
  bool? IsCreate;
  bool? IsFull;
  bool? IsEdit;
  String? CreatedBy;
  String? UpdatedBy;
  String? BranchId;
  bool? Company;

  factory OAMRModel.fromJson(Map<String, dynamic> json) => OAMRModel(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        RoleId: int.tryParse(json["RoleId"].toString()) ?? 0,
        RoleShortDesc: json["RoleShortDesc"] ?? "",
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] == 1,
        MenuId: int.tryParse(json["MenuId"].toString()) ?? 0,
        MenuPath: json["MenuPath"] ?? "",
        MenuDesc: json["MenuDesc"] ?? "",
        Active: json["Active"] is bool ? json["Active"] : json["Active"] == 1,
        ReadOnly:
            json["ReadOnly"] is bool ? json["ReadOnly"] : json["ReadOnly"] == 1,
        Self: json["Self"] is bool ? json["Self"] : json["Self"] == 1,
        BranchName: json["BranchName"] is bool
            ? json["BranchName"]
            : json["BranchName"] == 1,
        ParentMenuId: int.tryParse(json['ParentMenuId'].toString()) ?? 0,
        IsCreate:
            json['IsCreate'] is bool ? json['IsCreate'] : json['IsCreate'] == 1,
        IsFull: json['IsFull'] is bool ? json['IsFull'] : json['IsFull'] == 1,
        IsEdit: json['IsEdit'] is bool ? json['IsEdit'] : json['IsEdit'] == 1,
        CreatedBy: json['CreatedBy'] ?? '',
        UpdatedBy: json['UpdatedBy'] ?? '',
        BranchId: json['BranchId'] ?? '',
        Company:
            json['Company'] is bool ? json['Company'] : json['Company'] == 1,
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "RoleId": RoleId,
        "CreateDate": CreateDate.toIso8601String(),
        "UpdateDate": UpdateDate.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "RoleShortDesc": RoleShortDesc,
        "MenuId": MenuId,
        "MenuPath": MenuPath,
        "MenuDesc": MenuDesc,
        "Self": Self == true ? 1 : 0,
        "BranchName": BranchName == true ? 1 : 0,
        "ReadOnly": ReadOnly == true ? 1 : 0,
        "Active": Active == true ? 1 : 0,
        'ParentMenuId': ParentMenuId,
        'IsCreate': IsCreate,
        'IsFull': IsFull,
        'IsEdit': IsEdit,
        'CreatedBy': CreatedBy,
        'UpdatedBy': UpdatedBy,
        'BranchId': BranchId,
        'Company': Company,
      };
}

// Future<void> insertOAMR(Database db)async{
//   if(postfix.toLowerCase().contains("all"))
//   await deleteOAMR(db);
//   List customers= await dataSyncOAMR();
//   print(customers);
//   var batch = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try
//     {
//       batch.insert('OAMR', customer.toJson());
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
//   //       await db.insert('OAMR', customer.toJson());
//   //     });
//   //   }
//   //   catch(e)
//   //   {
//   //     getErrorSnackBar("Sync Error "+e.toString());
//   //   }
//   //
//   // });
// }
// Future<void> insertOAMR(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteOAMR(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncOAMR();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('OAMR_Temp', customer.toJson());
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
//       "SELECT * FROM  OAMR_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN UpdateDate IS NULL THEN CreateDate ELSE UpdateDate END)");
//   u.forEach((element) {
//     batch2.update("OAMR", element,
//         where:
//             "MenuId = ? AND RoleId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["MenuId"], element['RoleId'], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from OAMR_Temp where MenuId || RoleId  not in (Select MenuId || RoleId from OAMR)");
//   v.forEach((element) {
//     batch3.insert('OAMR', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('OAMR_Temp');
// }
Future<void> insertOAMR(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteOAMR(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncOAMR();
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
      for (OAMRModel record in batchRecords) {
        try {
          batch.insert('OAMR_Temp', record.toJson());
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
			select * from OAMR_Temp
			except
			select * from OAMR
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
          batch.update("OAMR", element,
              where:
                  "MenuId = ? AND RoleId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
              whereArgs: [element["MenuId"], element['RoleId'], 1, 1]);
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
  print('Time taken for OAMR update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from OAMR_Temp where MenuId || RoleId  not in (Select MenuId || RoleId from OAMR)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM OAMR_Temp T0
LEFT JOIN OAMR T1 ON T0.MenuId = T1.MenuId AND T0.RoleId = T1.RoleId 
WHERE T1.MenuId IS NULL AND T1.RoleId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('OAMR', record);
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
      'Time taken for OAMR_Temp and OAMR compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('OAMR_Temp');
  // stopwatch.stop();
}

Future<List<OAMRModel>> dataSyncOAMR() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "OAMR" + postfix));
  print(res.body);
  return OAMRModelFromJson(res.body);
}

Future<List<OAMRModel>> retrieveOAMR(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('OAMR');
  return queryResult.map((e) => OAMRModel.fromJson(e)).toList();
}

Future<void> updateOAMR(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    await db.transaction((db) async {
      await db.update("OAMR", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteOAMR(Database db) async {
  await db.delete('OAMR');
}

//SEND DATA TO SERVER
//--------------------------
Future<List<OAMRModel>> retrieveOAMRById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('OAMR', where: str, whereArgs: l);
  return queryResult.map((e) => OAMRModel.fromJson(e)).toList();
}

Future<void> insertOAMRToServer(BuildContext context) async {
  retrieveOAMRById(context, DataSync.getInsertToServerStr(),
          DataSync.getInsertToServerList())
      .then((snapshot) {
    print(snapshot);
    snapshot.forEach((data) async {
      var res = await http.post(Uri.parse(prefix + "OAMR/Add"),
          headers: header, body: jsonEncode(data.toJson()));
      print(res.body);
    });
  });
}

Future<void> updateOAMROnServer(BuildContext? context) async {
  retrieveOAMRById(context, DataSync.getUpdateOnServerStr(),
          DataSync.getUpdateOnServerList())
      .then((snapshot) {
    print(snapshot);
    snapshot.forEach((data) async {
      var res = await http.put(Uri.parse(prefix + 'OAMR/Update'),
          headers: header, body: jsonEncode(data.toJson()));
      print(res.body);
    });
  });
}
