import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

List<OCRYModel> OCRYModelFromJson(String str) =>
    List<OCRYModel>.from(json.decode(str).map((x) => OCRYModel.fromJson(x)));

String OCRYModelToJson(List<OCRYModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OCRYModel {
  OCRYModel({
    required this.ID,
    required this.Code,
    required this.Name,
    this.CreateDate,
    this.UpdateDate,
    this.hasCreated = false,
    this.Active,
    this.CreatedBy,
    this.UpdatedBy,
    this.BranchId,
    this.MobileDialCode,
    this.MobileNumberLength,
  });

  int ID;
  String Code;
  String Name;
  String? MobileDialCode;
  int? MobileNumberLength;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  bool hasCreated;
  bool? Active;
  String? CreatedBy;
  String? UpdatedBy;
  String? BranchId;

  factory OCRYModel.fromJson(Map<String, dynamic> json) => OCRYModel(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()) ??
            DateTime.parse('1900-01-01'),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()) ??
            DateTime.parse('1900-01-01'),
        hasCreated: json['has_created'] == 1,
        Code: json["Code"] ?? "",
        Name: json["Name"] ?? "",
        MobileNumberLength:
            int.tryParse(json["MobileNumberLength"].toString()) ?? 0,
        MobileDialCode: json["MobileDialCode"] ?? "",
        Active: json['Active'] is bool ? json['Active'] : json['Active'] == 1,
        CreatedBy: json['CreatedBy'] ?? '',
        UpdatedBy: json['UpdatedBy'] ?? '',
        BranchId: json['BranchId'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "Code": Code,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "Name": Name,
        'Active': Active,
        'CreatedBy': CreatedBy,
        'UpdatedBy': UpdatedBy,
        'BranchId': BranchId,
        "MobileNumberLength": MobileNumberLength,
        "MobileDialCode": MobileDialCode,
      };
}

Future<List<OCRYModel>> dataSyncOCRY() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "OCRY" + postfix));
  print(res.body);
  return OCRYModelFromJson(res.body);
}

// Future<void> insertOCRY(Database db)async{
//   if(postfix.toLowerCase().contains("all"))
//   await deleteOCRY(db);
//   List customers= await dataSyncOCRY();
//   print(customers);
//
//   var batch = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try
//     {
//       batch.insert('OCRY', customer.toJson());
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
//   //       await db.insert('OCRY', customer.toJson());
//   //     });
//   //   }
//   //   catch(e)
//   //   {
//   //     getErrorSnackBar("Sync Error "+e.toString());
//   //   }
//   //
//   // });
// }
// Future<void> insertOCRY(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteOCRY(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncOCRY();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('OCRY_Temp', customer.toJson());
//     } catch (e) {
//       writeToLogFile(
//           text: e.toString(),
//           fileName: StackTrace.current.toString(),
//           lineNo: 141);
//       writeToLogFile(
//           text: e.toString(),
//           fileName: StackTrace.current.toString(),
//           lineNo: 141);
//       getErrorSnackBar("Sync Error " + e.toString());
//     }
//   });
//   await batch1.commit(noResult: true);
//   var u = await db.rawQuery(
//       "SELECT * FROM  OCRY_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("OCRY", element,
//         where: "Code = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["Code"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from OCRY_Temp where Code not in (Select Code from OCRY)");
//   v.forEach((element) {
//     batch3.insert('OCRY', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('OCRY_Temp');
// }
Future<void> insertOCRY(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteOCRY(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncOCRY();
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
      for (OCRYModel record in batchRecords) {
        try {
          batch.insert('OCRY_Temp', record.toJson());
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
			select * from OCRY_Temp
			except
			select * from OCRY
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
          batch.update("OCRY", element,
              where:
                  "Code = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
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
  print('Time taken for OCRY update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from OCRY_Temp where Code not in (Select Code from OCRY)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM OCRY_Temp T0
LEFT JOIN OCRY T1 ON T0.Code = T1.Code 
WHERE T1.Code IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('OCRY', record);
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
      'Time taken for OCRY_Temp and OCRY compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('OCRY_Temp');
  // stopwatch.stop();
}

Future<List<OCRYModel>> retrieveOCRY() async {
  final Database db = await initializeDB(null);
  final List<Map<String, Object?>> queryResult = await db.query('OCRY');
  return queryResult.map((e) => OCRYModel.fromJson(e)).toList();
}

Future<void> updateOCRY(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update("OCRY", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteOCRY(Database db) async {
  await db.delete('OCRY');
}

//SEND DATA TO SERVER
//--------------------------
Future<List<OCRYModel>> retrieveOCRYById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('OCRY', where: str, whereArgs: l);
  return queryResult.map((e) => OCRYModel.fromJson(e)).toList();
}

// Future<void> insertOCRYToServer(BuildContext context) async {
//   retrieveOCRYById(context, DataSync.getInsertToServerStr(),
//           DataSync.getInsertToServerList())
//       .then((snapshot) {
//     print(snapshot);
//     snapshot.forEach((data) async {
//       var res = await http.post(Uri.parse(prefix + "OCRY/Add"),
//           headers: header, body: jsonEncode(data.toJson()));
//       print(res.body);
//     });
//   });
// }
//
// Future<void> updateOCRYOnServer(BuildContext? context) async {
//   retrieveOCRYById(context, DataSync.getUpdateOnServerStr(),
//           DataSync.getUpdateOnServerList())
//       .then((snapshot) {
//     print(snapshot);
//     snapshot.forEach((data) async {
//       var res = await http.put(Uri.parse(prefix + 'OCRY/Update'),
//           headers: header, body: jsonEncode(data.toJson()));
//       print(res.body);
//     });
//   });
// }
