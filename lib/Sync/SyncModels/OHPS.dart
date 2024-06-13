import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

List<OHPSModel> OHPSModelFromJson(String str) =>
    List<OHPSModel>.from(json.decode(str).map((x) => OHPSModel.fromJson(x)));

String OHPSModelToJson(List<OHPSModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OHPSModel {
  OHPSModel({
    required this.CreateDate,
    required this.UpdateDate,
    this.hasCreated = false,
    required this.ID,
    required this.ShortDesc,
    required this.Remarks,
    required this.Active,
    this.CreatedBy,
    this.BranchId,
    this.UpdatedBy,
  });

  int ID;
  String ShortDesc;
  DateTime CreateDate;
  DateTime UpdateDate;
  bool hasCreated;
  String Remarks;
  bool Active;
  String? CreatedBy;
  String? BranchId;
  String? UpdatedBy;

  factory OHPSModel.fromJson(Map<String, dynamic> json) => OHPSModel(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] == 1,
        ShortDesc: json["ShortDesc"] ?? "",
        Remarks: json["Remarks"] ?? "",
        Active: json["Active"] is bool ? json["Active"] : json["Active"] == 1,
        CreatedBy: json['CreatedBy'] ?? '',
        BranchId: json['BranchId'] ?? '',
        UpdatedBy: json['UpdatedBy'] ?? '',
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
        'BranchId': BranchId,
        'UpdatedBy': UpdatedBy,
      };
}

Future<List<OHPSModel>> dataSyncOHPS() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "OHPS" + postfix));
  print(res.body);
  return OHPSModelFromJson(res.body);
}

Future<List<OHPSModel>> retrieveOHPS(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('OHPS');
  return queryResult.map((e) => OHPSModel.fromJson(e)).toList();
}

Future<void> updateOHPS(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update("OHPS", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteOHPS(Database db) async {
  await db.delete('OHPS');
}

// Future<void> insertOHPS(Database db)async{
//   if(postfix.toLowerCase().contains("all"))
//   await deleteOHPS(db);
//   List customers= await dataSyncOHPS();
//   print(customers);
//
//   var batch = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try
//     {
//       batch.insert('OHPS', customer.toJson());
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
//   //       await db.insert('OHPS', customer.toJson());
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
Future<void> insertOHPS(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteOHPS(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncOHPS();
  }
  print(customers);
  var batch = db.batch();
  customers.forEach((customer) async {
    print(customer.toJson());
    try {
      batch.insert('OHPS', customer.toJson());
    } catch (e) {
      writeToLogFile(
          text: e.toString(),
          fileName: StackTrace.current.toString(),
          lineNo: 141);
      getErrorSnackBar("Sync Error " + e.toString());
    }
  });
  await batch.commit(noResult: true);
  // var u=await db.rawQuery("SELECT * FROM  OHPS_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
  // u.forEach((element) {
  //   batch.update("OHPS", element,where:"ID = ? AND TransId = ?",whereArgs: [element["ID"],element["TransId"]]);
  // });
  // await batch.commit(noResult: true);
}

//SEND DATA TO SERVER
//--------------------------
Future<List<OHPSModel>> retrieveOHPSById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('OHPS', where: str, whereArgs: l);
  return queryResult.map((e) => OHPSModel.fromJson(e)).toList();
}

Future<void> insertOHPSToServer(BuildContext context) async {
  retrieveOHPSById(context, DataSync.getInsertToServerStr(),
          DataSync.getInsertToServerList())
      .then((snapshot) {
    print(snapshot);
    snapshot.forEach((data) async {
      var res = await http.post(Uri.parse(prefix + "OHPS/Add"),
          headers: header, body: jsonEncode(data.toJson()));
      print(res.body);
    });
  });
}

Future<void> updateOHPSOnServer(BuildContext? context) async {
  retrieveOHPSById(context, DataSync.getUpdateOnServerStr(),
          DataSync.getUpdateOnServerList())
      .then((snapshot) {
    print(snapshot);
    snapshot.forEach((data) async {
      var res = await http.put(Uri.parse(prefix + 'OHPS/Update'),
          headers: header, body: jsonEncode(data.toJson()));
      print(res.body);
    });
  });
}
