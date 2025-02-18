import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

List<OQEMModel> OQEMModelFromJson(String str) =>
    List<OQEMModel>.from(json.decode(str).map((x) => OQEMModel.fromJson(x)));

String OQEMModelToJson(List<OQEMModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OQEMModel {
  OQEMModel({
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

  factory OQEMModel.fromJson(Map<String, dynamic> json) => OQEMModel(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        ShortDesc: json["ShortDesc"] ?? "",
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] == 1,
        Remarks: json["Remarks"] ?? "",
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

Future<List<OQEMModel>> dataSyncOQEM() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "OQEM" + postfix));
  print(res.body);
  return OQEMModelFromJson(res.body);
}

Future<List<OQEMModel>> retrieveOQEM(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('OQEM');
  return queryResult.map((e) => OQEMModel.fromJson(e)).toList();
}

Future<void> updateOQEM(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update("OQEM", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteOQEM(Database db) async {
  await db.delete('OQEM');
}

// Future<void> insertOQEM(Database db)async{
//   if(postfix.toLowerCase().contains("all"))
//   await deleteOQEM(db);
//   List customers= await dataSyncOQEM();
//   print(customers);
//   var batch = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try
//     {
//       batch.insert('OQEM', customer.toJson());
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
//   //       await db.insert('OQEM', customer.toJson());
//   //     });
//   //   }
//   //   catch(e)
//   //   {
//   //     getErrorSnackBar("Sync Error "+e.toString());
//   //   }
//   //
//   // });
// }
Future<void> insertOQEM(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteOQEM(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncOQEM();
  }
  print(customers);
  var batch = db.batch();
  customers.forEach((customer) async {
    print(customer.toJson());
    try {
      batch.insert('OQEM', customer.toJson());
    } catch (e) {
      writeToLogFile(
          text: e.toString(),
          fileName: StackTrace.current.toString(),
          lineNo: 141);
      getErrorSnackBar("Sync Error " + e.toString());
    }
  });
  await batch.commit(noResult: true);
  // var u=await db.rawQuery("SELECT * FROM  OPTR_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
  // u.forEach((element) {
  //   batch.update("OPTR", element,where:"ID = ? AND TransId = ?",whereArgs: [element["ID"],element["TransId"]]);
  // });
  // await batch.commit(noResult: true);
}

//SEND DATA TO SERVER
//--------------------------
Future<List<OQEMModel>> retrieveOQEMById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('OQEM', where: str, whereArgs: l);
  return queryResult.map((e) => OQEMModel.fromJson(e)).toList();
}

// Future<void> insertOQEMToServer(BuildContext context) async {
//   retrieveOQEMById(context, DataSync.getInsertToServerStr(),
//           DataSync.getInsertToServerList())
//       .then((snapshot) {
//     print(snapshot);
//     snapshot.forEach((data) async {
//       var res = await http.post(Uri.parse(prefix + "OQEM/Add"),
//           headers: header, body: jsonEncode(data.toJson()));
//       print(res.body);
//     });
//   });
// }
//
// Future<void> updateOQEMOnServer(BuildContext? context) async {
//   retrieveOQEMById(context, DataSync.getUpdateOnServerStr(),
//           DataSync.getUpdateOnServerList())
//       .then((snapshot) {
//     print(snapshot);
//     snapshot.forEach((data) async {
//       var res = await http.put(Uri.parse(prefix + 'OQEM/Update'),
//           headers: header, body: jsonEncode(data.toJson()));
//       print(res.body);
//     });
//   });
// }
