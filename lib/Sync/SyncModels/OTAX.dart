import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

List<OTAXModel> OTAXModelFromJson(String str) =>
    List<OTAXModel>.from(json.decode(str).map((x) => OTAXModel.fromJson(x)));

String OTAXModelToJson(List<OTAXModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OTAXModel {
  OTAXModel({
    required this.ID,
    required this.TaxCode,
    required this.Rate,
    required this.CreateDate,
    required this.UpdateDate,
    this.hasCreated = false,
    this.Active,
    this.CreatedBy,
    this.BranchId,
    this.UpdatedBy,
  });

  int ID;
  String TaxCode;
  double Rate;
  DateTime CreateDate;
  DateTime UpdateDate;
  bool hasCreated;
  bool? Active;
  String? CreatedBy;
  String? BranchId;
  String? UpdatedBy;

  factory OTAXModel.fromJson(Map<String, dynamic> json) => OTAXModel(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        TaxCode: json["TaxCode"] ?? "",
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] == 1,
        Rate: double.tryParse(json["Rate"].toString()) ?? 0.0,
        Active: json['Active'] is bool ? json['Active'] : json['Active'] == 1,
        CreatedBy: json['CreatedBy'] ?? '',
        BranchId: json['BranchId'] ?? '',
        UpdatedBy: json['UpdatedBy'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "CreateDate": CreateDate.toIso8601String(),
        "UpdateDate": UpdateDate.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "TaxCode": TaxCode,
        "Rate": Rate,
        'Active': Active,
        'CreatedBy': CreatedBy,
        'BranchId': BranchId,
        'UpdatedBy': UpdatedBy,
      };
}

Future<List<OTAXModel>> dataSyncOTAX() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "OTAX" + postfix));
  return OTAXModelFromJson(res.body);
}

Future<List<OTAXModel>> retrieveOTAX(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('OTAX');
  return queryResult.map((e) => OTAXModel.fromJson(e)).toList();
}

Future<List<OTAXModel>> retrieveTaxForSearch({
  int? limit,
  String? query,
}) async {
  query = "%$query%";
  final Database db = await initializeDB(null);
  final List<Map<String, Object?>> queryResult = await db
      .rawQuery('SELECT * FROM OTAX WHERE TaxCode LIKE "$query" LIMIT $limit');
  return queryResult.map((e) => OTAXModel.fromJson(e)).toList();
}

Future<void> updateOTAX(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update("OTAX", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteOTAX(Database db) async {
  await db.delete('OTAX');
}

// Future<void> insertOTAX(Database db,{List? list})async{
//   if(postfix.toLowerCase().contains("all"))
//   await deleteOTAX(db);
//   List customers;
//   if(list!=null)
//   {
//     customers=list;
//   }
//   else
//   {
//     customers= await dataSyncOTAX();
//   }
//   // List customers= await dataSyncOTAX();

//   var batch = db.batch();
//   customers.forEach((customer) async {

//     try
//     {
//       batch.insert('OTAX', customer.toJson());
//     }
//     catch(e)
//     {
//       getErrorSnackBar("Sync Error "+e.toString());
//     }
//   });
//   await batch.commit(noResult: true);
//
//   // customers.forEach((customer) async {

//   //   try
//   //   {
//   //     db.transaction((db)async{
//   //       await db.insert('OTAX', customer.toJson());
//   //     });
//   //   }
//   //   catch(e)
//   //   {
//   //     getErrorSnackBar("Sync Error "+e.toString());
//   //   }
//   //
//   // });
// }
// Future<void> insertOTAX(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteOTAX(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncOTAX();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('OTAX_Temp', customer.toJson());
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
//       "SELECT * FROM  OTAX_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("OTAX", element,
//         where: "TaxCode = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["TaxCode"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from OTAX_Temp where TaxCode not in (Select TaxCode from OTAX)");
//   v.forEach((element) {
//     batch3.insert('OTAX', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('OTAX_Temp');
// }
Future<void> insertOTAX(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteOTAX(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncOTAX();
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
      for (OTAXModel record in batchRecords) {
        try {
          batch.insert('OTAX_Temp', record.toJson());
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
			select * from OTAX_Temp
			except
			select * from OTAX
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
          batch.update("OTAX", element,
              where:
                  "TaxCode = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
              whereArgs: [element["TaxCode"], 1, 1]);
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
  print('Time taken for OTAX update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from OTAX_Temp where TaxCode not in (Select TaxCode from OTAX)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM OTAX_Temp T0
LEFT JOIN OTAX T1 ON T0.TaxCode = T1.TaxCode 
WHERE T1.TaxCode IS NULL;
''');

  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('OTAX', record);
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
      'Time taken for OTAX_Temp and OTAX compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('OTAX_Temp');
  // stopwatch.stop();
}

//SEND DATA TO SERVER
//--------------------------
Future<List<OTAXModel>> retrieveOTAXById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('OTAX', where: str, whereArgs: l);
  return queryResult.map((e) => OTAXModel.fromJson(e)).toList();
}

// Future<void> insertOTAXToServer(BuildContext context) async {
//   retrieveOTAXById(context, DataSync.getInsertToServerStr(),
//           DataSync.getInsertToServerList())
//       .then((snapshot) {
//     snapshot.forEach((data) async {
//       var res = await http.post(Uri.parse(prefix + "OTAX/Add"),
//           headers: header, body: jsonEncode(data.toJson()));
//     });
//   });
// }
//
// Future<void> updateOTAXOnServer(BuildContext? context) async {
//   retrieveOTAXById(context, DataSync.getUpdateOnServerStr(),
//           DataSync.getUpdateOnServerList())
//       .then((snapshot) {
//     snapshot.forEach((data) async {
//       var res = await http.put(Uri.parse(prefix + 'OTAX/Update'),
//           headers: header, body: jsonEncode(data.toJson()));
//     });
//   });
// }
