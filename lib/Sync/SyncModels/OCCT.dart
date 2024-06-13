import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

List<OCCTModel> OCCTModelFromJson(String str) =>
    List<OCCTModel>.from(json.decode(str).map((x) => OCCTModel.fromJson(x)));

String OCCTModelToJson(List<OCCTModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OCCTModel {
  OCCTModel({
    required this.ID,
    required this.Code,
    required this.Name,
    required this.StateCode,
    required this.StateName,
    required this.CountryCode,
    required this.CountryName,
    required this.CreateDate,
    required this.UpdateDate,
    this.hasCreated = false,
    this.Active,
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
  String StateCode;
  String StateName;
  String CountryCode;
  String CountryName;
  bool? Active;
  String? CreatedBy;
  String? UpdatedBy;
  String? BranchId;

  factory OCCTModel.fromJson(Map<String, dynamic> json) => OCCTModel(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        Code: json["Code"] ?? "",
        Name: json["Name"] ?? "",
        StateCode: json["StateCode"] ?? "",
        StateName: json["StateName"] ?? "",
        CountryCode: json["CountryCode"] ?? "",
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] == 1,
        CountryName: json["CountryName"] ?? "",
        Active: json['Active'] is bool ? json['Active'] : json['Active'] == 1,
        CreatedBy: json['CreatedBy'] ?? '',
        UpdatedBy: json['UpdatedBy'] ?? '',
        BranchId: json['BranchId'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "Code": Code,
        "CreateDate": CreateDate.toIso8601String(),
        "UpdateDate": UpdateDate.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "Name": Name,
        "StateCode": StateCode,
        "StateName": StateName,
        "CountryCode": CountryCode,
        "CountryName": CountryName,
        'Active': Active,
        'CreatedBy': CreatedBy,
        'UpdatedBy': UpdatedBy,
        'BranchId': BranchId,
      };
}

Future<List<OCCTModel>> retrieveOCCTForDisplay(
    {String dbQuery = '', int limit = 30}) async {
  final Database db = await initializeDB(null);
  dbQuery = '%$dbQuery%';
  String searchQuery = '';

  searchQuery = '''
     SELECT * FROM OCCT 
 WHERE Active = 1 AND (Code LIKE '$dbQuery' OR Name LIKE '$dbQuery' OR StateCode LIKE '$dbQuery' OR StateName LIKE '$dbQuery') 
 LIMIT $limit
      ''';
  final List<Map<String, Object?>> queryResult = await db.rawQuery(searchQuery);
  return queryResult.map((e) => OCCTModel.fromJson(e)).toList();
}

// Future<void> insertOCCT(Database db)async{
//   if(postfix.toLowerCase().contains("all"))
//   await deleteOCCT(db);
//   List customers= await dataSyncOCCT();
//   print(customers);
//   var batch = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try
//     {
//       batch.insert('OCCT', customer.toJson());
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
//   //       await db.insert('OCCT', customer.toJson());
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
// Future<void> insertOCCT(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteOCCT(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncOCCT();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('OCCT_Temp', customer.toJson());
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
//       "SELECT * FROM  OCCT_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN UpdateDate IS NULL THEN CreateDate ELSE UpdateDate END)");
//   u.forEach((element) {
//     batch2.update("OCCT", element,
//         where: "Code = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["Code"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from OCCT_Temp where Code  not in (Select Code  from OCCT)");
//   v.forEach((element) {
//     batch3.insert('OCCT', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('OCCT_Temp');
// }
Future<void> insertOCCT(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteOCCT(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncOCCT();
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
      for (OCCTModel record in batchRecords) {
        try {
          batch.insert('OCCT_Temp', record.toJson());
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
			select * from OCCT_Temp
			except
			select * from OCCT
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
          batch.update("OCCT", element,
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
  print('Time taken for OCCT update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from OCCT_Temp where Code  not in (Select Code  from OCCT)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM OCCT_Temp T0
LEFT JOIN OCCT T1 ON T0.Code = T1.Code 
WHERE T1.Code IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('OCCT', record);
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
      'Time taken for OCCT_Temp and OCCT compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('OCCT_Temp');
  // stopwatch.stop();
}

Future<List<OCCTModel>> dataSyncOCCT() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "OCCT" + postfix));
  print(res.body);
  return OCCTModelFromJson(res.body);
}

Future<List<OCCTModel>> retrieveOCCT(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('OCCT');
  return queryResult.map((e) => OCCTModel.fromJson(e)).toList();
}

Future<void> updateOCCT(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update("OCCT", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteOCCT(Database db) async {
  await db.delete('OCCT');
}

//SEND DATA TO SERVER
//--------------------------
Future<List<OCCTModel>> retrieveOCCTById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('OCCT', where: str, whereArgs: l);
  return queryResult.map((e) => OCCTModel.fromJson(e)).toList();
}

// Future<void> insertOCCTToServer(BuildContext context) async {
//   retrieveOCCTById(context, DataSync.getInsertToServerStr(),
//           DataSync.getInsertToServerList())
//       .then((snapshot) {
//     print(snapshot);
//     snapshot.forEach((data) async {
//       var res = await http.post(Uri.parse(prefix + "OCCT/Add"),
//           headers: header, body: jsonEncode(data.toJson()));
//       print(res.body);
//     });
//   });
// }
//
// Future<void> updateOCCTOnServer(BuildContext? context) async {
//   retrieveOCCTById(context, DataSync.getUpdateOnServerStr(),
//           DataSync.getUpdateOnServerList())
//       .then((snapshot) {
//     print(snapshot);
//     snapshot.forEach((data) async {
//       var res = await http.put(Uri.parse(prefix + 'OCCT/Update'),
//           headers: header, body: jsonEncode(data.toJson()));
//       print(res.body);
//     });
//   });
// }
