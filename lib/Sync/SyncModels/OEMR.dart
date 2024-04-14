import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

List<OEMRModel> OEMRModelFromJson(String str) =>
    List<OEMRModel>.from(json.decode(str).map((x) => OEMRModel.fromJson(x)));

String OEMRModelToJson(List<OEMRModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OEMRModel {
  OEMRModel({
    required this.ID,
    required this.EmpGroupId,
    required this.ShortDesc,
    required this.JobTitle,
    required this.JobResp,
    required this.Requirements,
    required this.CreateDate,
    required this.UpdateDate,
    this.hasCreated = false,
    required this.Active,
    this.CreatedBy,
    this.BranchId,
    this.UpdatedBy,
  });

  int ID;
  int EmpGroupId;
  String ShortDesc;
  String JobTitle;
  DateTime CreateDate;
  DateTime UpdateDate;
  bool hasCreated;
  String JobResp;
  String Requirements;
  bool Active;
  String? CreatedBy;
  String? BranchId;
  String? UpdatedBy;

  factory OEMRModel.fromJson(Map<String, dynamic> json) => OEMRModel(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        EmpGroupId: int.tryParse(json["EmpGroupId"].toString()) ?? 0,
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] == 1,
        ShortDesc: json["ShortDesc"] ?? "",
        JobTitle: json["JobTitle"] ?? "",
        JobResp: json["JobResp"] ?? "",
        Requirements: json["Requirements"] ?? "",
        Active: json["Active"] is bool ? json["Active"] : json["Active"] == 1,
        CreatedBy: json['CreatedBy'] ?? '',
        BranchId: json['BranchId'] ?? '',
        UpdatedBy: json['UpdatedBy'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "EmpGroupId": EmpGroupId,
        "CreateDate": CreateDate.toIso8601String(),
        "UpdateDate": UpdateDate.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "ShortDesc": ShortDesc,
        "JobTitle": JobTitle,
        "JobResp": JobResp,
        "Requirements": Requirements,
        "Active": Active == true ? 1 : 0,
        'CreatedBy': CreatedBy,
        'BranchId': BranchId,
        'UpdatedBy': UpdatedBy,
      };
}

Future<List<OEMRModel>> dataSyncOEMR() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "OEMR" + postfix));
  print(res.body);
  return OEMRModelFromJson(res.body);
}

Future<List<OEMRModel>> retrieveOEMR(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('OEMR');
  return queryResult.map((e) => OEMRModel.fromJson(e)).toList();
}

Future<void> updateOEMR(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update("OEMR", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteOEMR(Database db) async {
  await db.delete('OEMR');
}

// Future<void> insertOEMR(Database db)async{
//   if(postfix.toLowerCase().contains("all"))
//   await deleteOEMR(db);
//   List customers= await dataSyncOEMR();
//   print(customers);
//   var batch = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try
//     {
//       batch.insert('OEMR', customer.toJson());
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
//   //       await db.insert('OEMR', customer.toJson());
//   //     });
//   //   }
//   //   catch(e)
//   //   {
//   //     getErrorSnackBar("Sync Error "+e.toString());
//   //   }
//   //
//   // });
//
//
// }
Future<void> insertOEMR(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteOEMR(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncOEMR();
  }
  print(customers);
  var batch1 = db.batch();
  customers.forEach((customer) async {
    print(customer.toJson());
    try {
      batch1.insert('OEMR', customer.toJson());
    } catch (e) {
      writeToLogFile(
          text: e.toString(),
          fileName: StackTrace.current.toString(),
          lineNo: 141);
      getErrorSnackBar("Sync Error " + e.toString());
    }
  });
  await batch1.commit(noResult: true);
  // var u=await db.rawQuery("SELECT * FROM  OEMR_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN UpdateDate IS NULL THEN CreateDate ELSE UpdateDate END)");
  // u.forEach((element) {
  //   batch.update("OEMR", element,where:"ID = ? AND TransId = ?",whereArgs: [element["ID"],element["TransId"]]);
  // });
  // await batch.commit(noResult: true);
}

//SEND DATA TO SERVER
//--------------------------
Future<List<OEMRModel>> retrieveOEMRById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('OEMR', where: str, whereArgs: l);
  return queryResult.map((e) => OEMRModel.fromJson(e)).toList();
}

Future<void> insertOEMRToServer(BuildContext context) async {
  retrieveOEMRById(context, DataSync.getInsertToServerStr(),
          DataSync.getInsertToServerList())
      .then((snapshot) {
    print(snapshot);
    snapshot.forEach((data) async {
      var res = await http.post(Uri.parse(prefix + "OEMR/Add"),
          headers: header, body: jsonEncode(data.toJson()));
      print(res.body);
    });
  });
}

Future<void> updateOEMROnServer(BuildContext? context) async {
  retrieveOEMRById(context, DataSync.getUpdateOnServerStr(),
          DataSync.getUpdateOnServerList())
      .then((snapshot) {
    print(snapshot);
    snapshot.forEach((data) async {
      var res = await http.put(Uri.parse(prefix + 'OEMR/Update'),
          headers: header, body: jsonEncode(data.toJson()));
      print(res.body);
    });
  });
}
