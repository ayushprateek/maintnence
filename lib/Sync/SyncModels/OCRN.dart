import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

List<OCRNModel> OCRNModelFromJson(String str) =>
    List<OCRNModel>.from(json.decode(str).map((x) => OCRNModel.fromJson(x)));

String OCRNModelToJson(List<OCRNModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OCRNModel {
  OCRNModel({
    required this.ID,
    required this.Code,
    required this.Name,
    required this.Symbol,
    required this.Active,
    this.hasCreated = false,
    this.CreateDate,
    this.UpdateDate,
    this.CreatedBy,
    this.UpdatedBy,
    this.BranchId,
  });

  int ID;
  String Code;
  String Name;
  String Symbol;

  bool hasCreated;
  bool Active;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  String? CreatedBy;
  String? UpdatedBy;
  String? BranchId;

  factory OCRNModel.fromJson(Map<String, dynamic> json) => OCRNModel(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        Code: json["Code"] ?? "",
        hasCreated: json['has_created'] == 1,
        Name: json["Name"] ?? "",
        Symbol: json["Symbol"] ?? "",
        Active: json["Active"] is bool ? json["Active"] : json["Active"] == 1,
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()) ??
            DateTime.parse('1900-01-01'),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()) ??
            DateTime.parse('1900-01-01'),
        CreatedBy: json['CreatedBy'] ?? '',
        UpdatedBy: json['UpdatedBy'] ?? '',
        BranchId: json['BranchId'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "Code": Code,
        "has_created": hasCreated ? 1 : 0,
        "Name": Name,
        "Symbol": Symbol,
        "Active": Active == true ? 1 : 0,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'CreatedBy': CreatedBy,
        'UpdatedBy': UpdatedBy,
        'BranchId': BranchId,
      };
}

Future<List<OCRNModel>> retrieveOCRNForDisplay(
    {String dbQuery = '', int limit = 30}) async {
  final Database db = await initializeDB(null);
  dbQuery = '%$dbQuery%';
  String searchQuery = '';

  searchQuery = '''
     SELECT * FROM OCRN 
 WHERE Active = 1 AND (Code LIKE '$dbQuery' OR Name LIKE '$dbQuery' OR Symbol LIKE '$dbQuery') 
 LIMIT $limit
      ''';
  final List<Map<String, Object?>> queryResult = await db.rawQuery(searchQuery);
  return queryResult.map((e) => OCRNModel.fromJson(e)).toList();
}

// Future<void> insertOCRN(Database db,{List? list})async{
//   if(postfix.toLowerCase().contains("all"))
//   await deleteOCRN(db);
//   List customers;
//   if(list!=null)
//   {
//     customers=list;
//   }
//   else
//   {
//     customers= await dataSyncOCRN();
//   }
//   print(customers);
//   var batch = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try
//     {
//       batch.insert('OCRN', customer.toJson());
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
//   //       await db.insert('OCRN', customer.toJson());
//   //     });
//   //   }
//   //   catch(e)
//   //   {
//   //     getErrorSnackBar("Sync Error "+e.toString());
//   //   }
//   //
//   // });
// }
// Future<void> insertOCRN(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteOCRN(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncOCRN();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('OCRN_Temp', customer.toJson());
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
//       "SELECT * FROM  OCRN_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("OCRN", element,
//         where: "Code = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["Code"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from OCRN_Temp where Code not in (Select Code from OCRN)");
//   v.forEach((element) {
//     batch3.insert('OCRN', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('OCRN_Temp');
// }
Future<void> insertOCRN(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteOCRN(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncOCRN();
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
      for (OCRNModel record in batchRecords) {
        try {
          batch.insert('OCRN_Temp', record.toJson());
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
			select * from OCRN_Temp
			except
			select * from OCRN
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
          batch.update("OCRN", element,
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
  print('Time taken for OCRN update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from OCRN_Temp where Code not in (Select Code from OCRN)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM OCRN_Temp T0
LEFT JOIN OCRN T1 ON T0.Code = T1.Code 
WHERE T1.Code IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('OCRN', record);
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
      'Time taken for OCRN_Temp and OCRN compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('OCRN_Temp');
  // stopwatch.stop();
}

Future<List<OCRNModel>> dataSyncOCRN() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "OCRN" + postfix));
  print(res.body);
  return OCRNModelFromJson(res.body);
}

Future<List<OCRNModel>> retrieveOCRN(BuildContext? context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('OCRN');
  return queryResult.map((e) => OCRNModel.fromJson(e)).toList();
}

Future<void> updateOCRN(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update("OCRN", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteOCRN(Database db) async {
  await db.delete('OCRN');
}

//SEND DATA TO SERVER
//--------------------------
Future<List<OCRNModel>> retrieveOCRNById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('OCRN', where: str, whereArgs: l);
  return queryResult.map((e) => OCRNModel.fromJson(e)).toList();
}

// Future<void> insertOCRNToServer(BuildContext context) async {
//   retrieveOCRNById(context, DataSync.getInsertToServerStr(),
//           DataSync.getInsertToServerList())
//       .then((snapshot) {
//     print(snapshot);
//     snapshot.forEach((data) async {
//       var res = await http.post(Uri.parse(prefix + "OCRN/Add"),
//           headers: header, body: jsonEncode(data.toJson()));
//       print(res.body);
//     });
//   });
// }
//
// Future<void> updateOCRNOnServer(BuildContext? context) async {
//   retrieveOCRNById(context, DataSync.getUpdateOnServerStr(),
//           DataSync.getUpdateOnServerList())
//       .then((snapshot) {
//     print(snapshot);
//     snapshot.forEach((data) async {
//       var res = await http.put(Uri.parse(prefix + 'OCRN/Update'),
//           headers: header, body: jsonEncode(data.toJson()));
//       print(res.body);
//     });
//   });
// }
