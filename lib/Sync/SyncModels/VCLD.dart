import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

List<VCLDModel> VCLDModelFromJson(String str) =>
    List<VCLDModel>.from(json.decode(str).map((x) => VCLDModel.fromJson(x)));

String VCLDModelToJson(List<VCLDModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VCLDModel {
  VCLDModel({
    required this.ID,
    required this.Code,
    required this.CreateDate,
    required this.UpdateDate,
    this.hasCreated = false,
    required this.RowId,
    required this.DocName,
    required this.IssueDate,
    required this.ValidDate,
    required this.Attachment,
  });

  int ID;
  String Code;
  int RowId;
  String DocName;
  DateTime CreateDate;
  DateTime UpdateDate;
  bool hasCreated;
  String IssueDate;
  String ValidDate;
  String Attachment;

  factory VCLDModel.fromJson(Map<String, dynamic> json) => VCLDModel(
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
        "Code": Code,
        "RowId": RowId,
        "DocName": DocName,
        "CreateDate": CreateDate.toIso8601String(),
        "UpdateDate": UpdateDate.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "IssueDate": IssueDate,
        "ValidDate": ValidDate,
        "Attachment": Attachment,
      };
}

Future<List<VCLDModel>> dataSyncVCLD() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "VCLD" + postfix));
  print(res.body);
  return VCLDModelFromJson(res.body);
}

Future<List<VCLDModel>> retrieveVCLD(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('VCLD');
  return queryResult.map((e) => VCLDModel.fromJson(e)).toList();
}

Future<void> updateVCLD(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    await db.transaction((db) async {
      await db.update("VCLD", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteVCLD(Database db) async {
  await db.delete('VCLD');
}

// Future<void> insertVCLD(Database db) async {
//   if(postfix.toLowerCase().contains("all"))
//   await deleteVCLD(db);
//   List customers = await dataSyncVCLD();
//   print(customers);
//   var batch = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try
//     {
//       batch.insert('VCLD', customer.toJson());
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
//   //       await db.insert('VCLD', customer.toJson());
//   //     });
//   //   }
//   //   catch(e)
//   //   {
//   //     getErrorSnackBar("Sync Error "+e.toString());
//   //   }
//   //
//   // });
// }
// Future<void> insertVCLD(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteVCLD(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncVCLD();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('VCLD_Temp', customer.toJson());
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
//       "SELECT * FROM  VCLD_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("VCLD", element,
//         where:
//             "RowId = ? AND Code = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["RowId"], element["Code"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from VCLD_Temp where Code || RowId not in (Select Code || RowId from VCLD)");
//   v.forEach((element) {
//     batch3.insert('VCLD', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('VCLD_Temp');
// }
Future<void> insertVCLD(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteVCLD(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncVCLD();
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
      for (VCLDModel record in batchRecords) {
        try {
          batch.insert('VCLD_Temp', record.toJson());
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
			select * from VCLD_Temp
			except
			select * from VCLD
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
          batch.update("VCLD", element,
              where:
                  "RowId = ? AND Code = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
              whereArgs: [element["RowId"], element["Code"], 1, 1]);
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
  print('Time taken for VCLD update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from VCLD_Temp where Code || RowId not in (Select Code || RowId from VCLD)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM VCLD_Temp T0
LEFT JOIN VCLD T1 ON T0.Code = T1.Code AND T0.RowId = T1.RowId
WHERE T1.Code IS NULL AND T1.RowId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('VCLD', record);
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
      'Time taken for VCLD_Temp and VCLD compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('VCLD_Temp');
  // stopwatch.stop();
}

//SEND DATA TO SERVER
//--------------------------
Future<List<VCLDModel>> retrieveVCLDById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('VCLD', where: str, whereArgs: l);
  return queryResult.map((e) => VCLDModel.fromJson(e)).toList();
}

Future<void> insertVCLDToServer(BuildContext context) async {
  retrieveVCLDById(context, DataSync.getInsertToServerStr(),
          DataSync.getInsertToServerList())
      .then((snapshot) {
    print(snapshot);
    snapshot.forEach((data) async {
      var res = await http.post(Uri.parse(prefix + "VCLD/Add"),
          headers: header, body: jsonEncode(data.toJson()));
      print(res.body);
    });
  });
}

Future<void> updateVCLDOnServer(BuildContext? context) async {
  retrieveVCLDById(context, DataSync.getUpdateOnServerStr(),
          DataSync.getUpdateOnServerList())
      .then((snapshot) {
    print(snapshot);
    snapshot.forEach((data) async {
      var res = await http.put(Uri.parse(prefix + 'VCLD/Update'),
          headers: header, body: jsonEncode(data.toJson()));
      print(res.body);
    });
  });
}
