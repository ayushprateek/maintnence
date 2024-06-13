import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

List<OLEVModel> OLEVModelFromJson(String str) =>
    List<OLEVModel>.from(json.decode(str).map((x) => OLEVModel.fromJson(x)));

String OLEVModelToJson(List<OLEVModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OLEVModel {
  OLEVModel({
    required this.ID,
    required this.Code,
    required this.Name,
    required this.Active,
    required this.CreateDate,
    required this.UpdateDate,
    this.hasCreated = false,
    this.CreatedBy,
    this.UpdatedBy,
    this.BranchId,
  });

  int ID;
  String Code;
  String Name;
  DateTime CreateDate;
  DateTime UpdateDate;
  bool hasCreated;
  bool Active;
  String? CreatedBy;
  String? UpdatedBy;
  String? BranchId;

  factory OLEVModel.fromJson(Map<String, dynamic> json) => OLEVModel(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        Code: json["Code"] ?? "",
        Name: json["Name"] ?? "",
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] == 1,
        Active: json["Active"] is bool ? json["Active"] : json["Active"] == 1,
        CreatedBy: json['CreatedBy'] ?? '',
        UpdatedBy: json['UpdatedBy'] ?? '',
        BranchId: json['BranchId'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "Code": Code,
        "Name": Name,
        "CreateDate": CreateDate.toIso8601String(),
        "UpdateDate": UpdateDate.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "Active": Active == true ? 1 : 0,
        'CreatedBy': CreatedBy,
        'UpdatedBy': UpdatedBy,
        'BranchId': BranchId,
      };
}

Future<List<OLEVModel>> dataSyncOLEV() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "OLEV" + postfix));
  print(res.body);
  return OLEVModelFromJson(res.body);
}

Future<List<OLEVModel>> retrieveOLEV(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('OLEV');
  return queryResult.map((e) => OLEVModel.fromJson(e)).toList();
}

Future<void> updateOLEV(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update("OLEV", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteOLEV(Database db) async {
  await db.delete('OLEV');
}

// Future<void> insertOLEV(Database db)async{
//   if(postfix.toLowerCase().contains("all"))
//   await deleteOLEV(db);
//   List customers= await dataSyncOLEV();
//   print(customers);
//   var batch = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try
//     {
//       batch.insert('OLEV', customer.toJson());
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
//   //       await db.insert('OLEV', customer.toJson());
//   //     });
//   //   }
//   //   catch(e)
//   //   {
//   //     getErrorSnackBar("Sync Error "+e.toString());
//   //   }
//   //
//   // });
// }
Future<void> insertOLEV(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteOLEV(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncOLEV();
  }
  print(customers);
  var batch = db.batch();
  customers.forEach((customer) async {
    print(customer.toJson());
    try {
      batch.insert('OLEV_Temp', customer.toJson());
    } catch (e) {
      writeToLogFile(
          text: e.toString(),
          fileName: StackTrace.current.toString(),
          lineNo: 141);
      getErrorSnackBar("Sync Error " + e.toString());
    }
  });
  // await batch.commit(noResult: true);
  // var u=await db.rawQuery("SELECT * FROM  OLEV_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
  // u.forEach((element) {
  //   batch.update("OLEV", element,where:"ID = ? AND Code = ?",whereArgs: [element["ID"],element["Code"]]);
  // });
  // await batch.commit(noResult: true);
  // var v=await db.rawQuery("Select * from OLEV_Temp where ID || Code not in (Select ID || Code from OLEV)");
  // v.forEach((element) {
  //   batch.insert('OLEV', element);
  // });
  // await batch.commit(noResult: true);
  // await db.delete('OLEV_Temp');
}

//SEND DATA TO SERVER
//--------------------------
Future<List<OLEVModel>> retrieveOLEVById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('OLEV', where: str, whereArgs: l);
  return queryResult.map((e) => OLEVModel.fromJson(e)).toList();
}

Future<void> insertOLEVToServer(BuildContext context) async {
  retrieveOLEVById(context, DataSync.getInsertToServerStr(),
          DataSync.getInsertToServerList())
      .then((snapshot) {
    print(snapshot);
    snapshot.forEach((data) async {
      var res = await http.post(Uri.parse(prefix + "OLEV/Add"),
          headers: header, body: jsonEncode(data.toJson()));
      print(res.body);
    });
  });
}

Future<void> updateOLEVOnServer(BuildContext? context) async {
  retrieveOLEVById(context, DataSync.getUpdateOnServerStr(),
          DataSync.getUpdateOnServerList())
      .then((snapshot) {
    print(snapshot);
    snapshot.forEach((data) async {
      var res = await http.put(Uri.parse(prefix + 'OLEV/Update'),
          headers: header, body: jsonEncode(data.toJson()));
      print(res.body);
    });
  });
}
