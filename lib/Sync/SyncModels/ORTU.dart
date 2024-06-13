import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:maintenance/main.dart';
import 'package:sqflite/sqlite_api.dart';

List<ORTUModel> ORTUModelFromJson(String str) =>
    List<ORTUModel>.from(json.decode(str).map((x) => ORTUModel.fromJson(x)));

String ORTUModelToJson(List<ORTUModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ORTUModel {
  ORTUModel({
    required this.ID,
    required this.CreatedBy,
    required this.UserCode,
    required this.CreateDate,
    required this.UpdateDate,
    this.hasCreated = false,
    required this.RoleId,
    required this.RoleShortDesc,
    required this.Menu_Id,
    required this.MenuPath,
    required this.MenuDesc,
    required this.MenuId,
    required this.Sel,
    required this.ReadOnly,
    required this.Self,
    required this.BranchName,
    this.Active,
    this.CreateAuth,
    this.EditAuth,
    this.DetailsAuth,
    this.FullAuth,
    this.UpdatedBy,
    this.BranchId,
    this.Company,
    this.ControllerName,
  });

  int ID;

  String CreatedBy;
  String? ControllerName;

  ///user only for module visibility
  String UserCode;
  DateTime CreateDate;
  DateTime UpdateDate;
  bool hasCreated;

  int RoleId;
  String RoleShortDesc;
  int Menu_Id;
  String MenuPath;
  String MenuDesc;
  int MenuId;
  bool Sel;
  bool ReadOnly;
  bool Self;
  bool BranchName;
  bool? Active;
  bool? CreateAuth;
  bool? EditAuth;
  bool? DetailsAuth;
  bool? FullAuth;
  String? UpdatedBy;
  String? BranchId;
  bool? Company;

  factory ORTUModel.fromJson(Map<String, dynamic> json) => ORTUModel(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        UserCode: json["UserCode"] ?? "",
        CreatedBy: json["CreatedBy"] ?? "",
        RoleId: int.tryParse(json["RoleId"].toString()) ?? 0,
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] == 1,
        ControllerName: json["ControllerName"] ?? "",
        RoleShortDesc: json["RoleShortDesc"] ?? "",
        Menu_Id: int.tryParse(json["Menu_Id"].toString()) ?? 0,
        MenuPath: json["MenuPath"] ?? "",
        MenuDesc: json["MenuDesc"] ?? "",
        MenuId: int.tryParse(json["MenuId"].toString()) ?? 0,
        Sel: json["Sel"] is bool
            ? json["Sel"]
            : json["Sel"] == 1
                ? true
                : false,
        ReadOnly: json["ReadOnly"] is bool
            ? json["ReadOnly"]
            : json["ReadOnly"] == 1
                ? true
                : false,
        Self: json["Self"] is bool
            ? json["Self"]
            : json["Self"] == 1
                ? true
                : false,
        BranchName: json["BranchName"] is bool
            ? json["BranchName"]
            : json["BranchName"] == 1
                ? true
                : false,
        Active: json['Active'] is bool ? json['Active'] : json['Active'] == 1,
        CreateAuth: json['CreateAuth'] is bool
            ? json['CreateAuth']
            : json['CreateAuth'] == 1,
        EditAuth:
            json['EditAuth'] is bool ? json['EditAuth'] : json['EditAuth'] == 1,
        DetailsAuth: json['DetailsAuth'] is bool
            ? json['DetailsAuth']
            : json['DetailsAuth'] == 1,
        FullAuth:
            json['FullAuth'] is bool ? json['FullAuth'] : json['FullAuth'] == 1,
        UpdatedBy: json['UpdatedBy'] ?? '',
        BranchId: json['BranchId'] ?? '',
        Company:
            json['Company'] is bool ? json['Company'] : json['Company'] == 1,
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "UserCode": UserCode,
        "CreatedBy": CreatedBy,
        "CreateDate": CreateDate.toIso8601String(),
        "UpdateDate": UpdateDate.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "RoleId": RoleId,
        "RoleShortDesc": RoleShortDesc,
        "Menu_Id": Menu_Id,
        "MenuPath": MenuPath,
        "MenuDesc": MenuDesc,
        "MenuId": MenuId,
        "Sel": Sel == true ? 1 : 0,
        "ReadOnly": ReadOnly == true ? 1 : 0,
        "Self": Self == true ? 1 : 0,
        "BranchName": BranchName == true ? 1 : 0,
        'Active': Active,
        'CreateAuth': CreateAuth,
        'EditAuth': EditAuth,
        'DetailsAuth': DetailsAuth,
        'FullAuth': FullAuth,
        'UpdatedBy': UpdatedBy,
        'BranchId': BranchId,
        'Company': Company,
      };
}

Future<List<ORTUModel>> dataSyncORTU() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "ORTU" + postfix));
  print(res.body);
  return ORTUModelFromJson(res.body);
}

Future<List<ORTUModel>> retrieveORTU(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('ORTU');
  return queryResult.map((e) => ORTUModel.fromJson(e)).toList();
}

Future<void> updateORTU(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update("ORTU", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteORTU(Database db) async {
  await db.delete('ORTU');
}

// Future<void> insertORTU(Database db, {List<ORTUModel>? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteORTU(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncORTU();
//   }
//   print(customers);
//   List<ORTUModel>? tempList = [];
//   tempList = list?.where((element) => element.MenuId == 10011).toList();
//   print(tempList);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('ORTU_Temp', customer.toJson());
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
//       "SELECT * FROM  ORTU_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   print(u);
//   u.forEach((element) {
//     batch2.update("ORTU", element,
//         where:
//             "MenuId = ? AND UserCode = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["MenuId"], element["UserCode"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from ORTU_Temp where ID  not in (Select ID  from ORTU)");
//   print(v);
//   v.forEach((element) {
//     batch3.insert('ORTU', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('ORTU_Temp');
// }
Future<void> insertORTU(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteORTU(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncORTU();
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
      for (ORTUModel record in batchRecords) {
        try {
          batch.insert('ORTU_Temp', record.toJson());
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
			select * from ORTU_Temp
			except
			select * from ORTU
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
          batch.update("ORTU", element,
              where:
                  "MenuId = ? AND UserCode = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
              whereArgs: [element["MenuId"], element["UserCode"], 1, 1]);
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
  print('Time taken for ORTU update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from ORTU_Temp where ID  not in (Select ID  from ORTU)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM ORTU_Temp T0
LEFT JOIN ORTU T1 ON T0.ID = T1.ID 
WHERE T1.ID IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('ORTU', record);
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
      'Time taken for ORTU_Temp and ORTU compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('ORTU_Temp');
  // stopwatch.stop();
}

//SEND DATA TO SERVER
//--------------------------
Future<List<ORTUModel>> retrieveORTUById(
    BuildContext? context, String str, List l,
    {int? limit, String? orderBy}) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('ORTU',
      where: str, whereArgs: l, limit: limit, orderBy: orderBy);
  return queryResult.map((e) => ORTUModel.fromJson(e)).toList();
}

Future<List<ORTUModel>> retrieveModuleVisibilityData(
    {required String ControllerName}) async {
  final Database db = await initializeDB(null);
  final List<Map<String, Object?>> queryResult = await db.rawQuery('''
      SELECT T0.ControllerName,T0.MenuDesc,T1.* FROM OMNU T0 
      INNER JOIN ORTU T1 ON T0.ID=T1.MenuId 
      WHERE  T1.UserCode='${userModel.UserCode}'
      and T0.ControllerName = '$ControllerName' order By UpdateDate Desc Limit 1
      ''');
  return queryResult.map((e) => ORTUModel.fromJson(e)).toList();
}

Future<List<ORTUModel>> retrieveFormVisibilityData(
    {required String ControllerName}) async {
  final Database db = await initializeDB(null);
  final List<Map<String, Object?>> queryResult = await db.rawQuery('''
      SELECT T0.ControllerName,T1.* FROM OMNU T0 INNER JOIN ORTU T1 
ON T0.ID=T1.MenuId WHERE  T1.UserCode='${userModel.UserCode}'
and T0.ControllerName='${ControllerName}' ORDER BY UpdateDate DESC LIMIT 1
      ''');
  return queryResult.map((e) => ORTUModel.fromJson(e)).toList();
}

// Future<List<ORTUModel>> retrieveModuleVisibility(
//     {required String userCode}) async {
//   final Database db = await initializeDB(null);
//   final List<Map<String, Object?>> queryResult = await db.rawQuery(
//       "SELECT T0.ControllerName,T1.* FROM OMNU T0 INNER JOIN ORTU T1 ON T0.ID=T1.MenuId WHERE T1.Active =1 AND T1.UserCode='$userCode'");
//   return queryResult.map((e) => ORTUModel.fromJson(e)).toList();
// }

Future<void> insertORTUToServer(BuildContext context) async {
  retrieveORTUById(context, DataSync.getInsertToServerStr(),
          DataSync.getInsertToServerList())
      .then((snapshot) {
    print(snapshot);
    snapshot.forEach((data) async {
      var res = await http.post(Uri.parse(prefix + "ORTU/Add"),
          headers: header, body: jsonEncode(data.toJson()));
      print(res.body);
    });
  });
}

Future<void> updateORTUOnServer(BuildContext? context) async {
  retrieveORTUById(context, DataSync.getUpdateOnServerStr(),
          DataSync.getUpdateOnServerList())
      .then((snapshot) {
    print(snapshot);
    snapshot.forEach((data) async {
      var res = await http.put(Uri.parse(prefix + 'ORTU/Update'),
          headers: header, body: jsonEncode(data.toJson()));
      print(res.body);
    });
  });
}

Future<bool> checkVisibility(String module, BuildContext context) async {
  bool visible = false;
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('ORTU',
      where: "MenuDesc = ? AND CreatedBy = ?",
      whereArgs: [module, userModel.UserCode]);
  queryResult.forEach((element) {
    print(element['sel']);
    print(element['ReadOnly']);
    print(element['Self']);
    print(element['BranchName']);
    if (element['sel'] == 1) {
      visible = true;
    }
  });
  return visible;
}
