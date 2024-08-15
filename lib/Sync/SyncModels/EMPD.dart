import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:sqflite/sqlite_api.dart';

List<EMPDModel> EMPDModelFromJson(String str) =>
    List<EMPDModel>.from(json.decode(str).map((x) => EMPDModel.fromJson(x)));

String EMPDModelToJson(List<EMPDModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EMPDModel {
  EMPDModel({
    required this.ID,
    required this.Code,
    required this.RowId,
    required this.DocName,
    required this.IssueDate,
    required this.ValidDate,
    required this.Attachment,
    required this.CreateDate,
    required this.UpdateDate,
    this.hasCreated = false,
  });

  int ID;
  String Code;
  DateTime CreateDate;
  DateTime UpdateDate;
  bool hasCreated;
  int RowId;
  String DocName;
  String IssueDate;
  String ValidDate;
  String Attachment;

  factory EMPDModel.fromJson(Map<String, dynamic> json) => EMPDModel(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] == 1,
        Code: json["Code"] ?? "",
        RowId: int.tryParse(json["RowId"].toString()) ?? 0,
        DocName: json["DocName"] ?? "",
        IssueDate: json["IssueDate"] ?? "",
        ValidDate: json["ValidDate"] ?? "",
        Attachment: json["Attachment"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "CreateDate": CreateDate.toIso8601String(),
        "UpdateDate": UpdateDate.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "Code": Code,
        "RowId": RowId,
        "DocName": DocName,
        "IssueDate": IssueDate,
        "ValidDate": ValidDate,
        "Attachment": Attachment,
      };
}

Future<List<EMPDModel>> dataSyncEMPD() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "EMPD" + postfix));
  print(res.body);
  return EMPDModelFromJson(res.body);
}
// Future<void> insertEMPD(Database db)async{
//   if(postfix.toLowerCase().contains("all"))
//   await deleteEMPD(db);
//   List customers= await dataSyncEMPD();
//   print(customers);
//   var batch = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try
//     {
//       batch.insert('EMPD', customer.toJson());
//     }
//     catch(e)
//     {
//       getErrorSnackBar("Sync Error "+e.toString());
//     }
//   });
//   await batch.commit(noResult: true);
//   //
//   // customers.forEach((customer) async {
//   //   print(customer.toJson());
//   //   try
//   //   {
//   //     db.transaction((db)async{
//   //       await db.insert('EMPD', customer.toJson());
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

Future<void> insertEMPD(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteEMPD(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncEMPD();
  }
  print(customers);
  var batch = db.batch();
  customers.forEach((customer) async {
    print(customer.toJson());
    try {
      batch.insert('EMPD_Temp', customer.toJson());
    } catch (e) {
      writeToLogFile(
          text: e.toString(),
          fileName: StackTrace.current.toString(),
          lineNo: 141);
      getErrorSnackBar("Sync Error " + e.toString());
    }
  });
  // await batch.commit(noResult: true);
  // var u=await db.rawQuery("SELECT * FROM  EMPD_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
  // u.forEach((element) {
  //   batch.update("EMPD", element,where:"ID = ? AND TransId = ?",whereArgs: [element["ID"],element["TransId"]]);
  // });
  // await batch.commit(noResult: true);
  // var v=await db.rawQuery("Select * from EMPD_Temp where TransId || ID not in (Select TransId || ID from EMPD)");
  // v.forEach((element) {
  //   batch.insert('EMPD', element);
  // });
  // await batch.commit(noResult: true);
  await db.delete('EMPD_Temp');
}

Future<List<EMPDModel>> retrieveEMPD(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('EMPD');
  return queryResult.map((e) => EMPDModel.fromJson(e)).toList();
}

Future<void> updateEMPD(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update("EMPD", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteEMPD(Database db) async {
  await db.delete('EMPD');
}

//SEND DATA TO SERVER
//--------------------------
Future<List<EMPDModel>> retrieveEMPDById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('EMPD', where: str, whereArgs: l);
  return queryResult.map((e) => EMPDModel.fromJson(e)).toList();
}

// Future<void> insertEMPDToServer(BuildContext context) async {
//   retrieveEMPDById(context, DataSync.getInsertToServerStr(),
//           DataSync.getInsertToServerList())
//       .then((snapshot) {
//     print(snapshot);
//     snapshot.forEach((data) async {
//       var res = await http.post(Uri.parse(prefix + "EMPD/Add"),
//           headers: header, body: jsonEncode(data.toJson()));
//       print(res.body);
//     });
//   });
// }
//
// Future<void> updateEMPDOnServer(BuildContext? context) async {
//   retrieveEMPDById(context, DataSync.getUpdateOnServerStr(),
//           DataSync.getUpdateOnServerList())
//       .then((snapshot) {
//     print(snapshot);
//     snapshot.forEach((data) async {
//       var res = await http.put(Uri.parse(prefix + 'EMPD/Update'),
//           headers: header, body: jsonEncode(data.toJson()));
//       print(res.body);
//     });
//   });
// }
