import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

List<ORTTModel> ORTTModelFromJson(String str) =>
    List<ORTTModel>.from(json.decode(str).map((x) => ORTTModel.fromJson(x)));

String ORTTModelToJson(List<ORTTModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ORTTModel {
  ORTTModel({
    required this.RateDate,
    required this.Currency,
    required this.Rate,
    required this.CreatedBy,
    required this.CreateDate,
    required this.UpdateDate,
    this.hasCreated = false,
    this.UpdatedBy,
    this.ID,
    this.BranchId,
  });

  DateTime RateDate;
  String Currency;
  DateTime CreateDate;
  DateTime UpdateDate;
  bool hasCreated;
  double Rate;
  String CreatedBy;
  String? UpdatedBy;
  int? ID;
  String? BranchId;

  factory ORTTModel.fromJson(Map<String, dynamic> json) => ORTTModel(
        RateDate: DateTime.tryParse(json["RateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        Currency: json["Currency"] ?? "",
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] == 1,
        Rate: double.tryParse(json["Rate"].toString()) ?? 0.0,
        CreatedBy: json["CreatedBy"] ?? "",
        UpdatedBy: json['UpdatedBy'] ?? '',
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        BranchId: json['BranchId'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "RateDate": RateDate.toIso8601String(),
        "CreateDate": CreateDate.toIso8601String(),
        "UpdateDate": UpdateDate.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "Currency": Currency,
        "Rate": Rate,
        "CreatedBy": CreatedBy,
        'UpdatedBy': UpdatedBy,
        'ID': ID,
        'BranchId': BranchId,
      };
}

Future<List<ORTTModel>> dataSyncORTT() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "ORTT" + postfix));
  print(res.body);
  return ORTTModelFromJson(res.body);
}

// Future<void> insertORTT(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteORTT(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncORTT();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('ORTT_Temp', customer.toJson());
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
//       "SELECT * FROM  ORTT_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("ORTT", element,
//         where:
//             "RateDate = ? AND Rate = ? AND Currency = ? AND CreatedBy = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [
//           element["RateDate"],
//           element["Rate"],
//           element["Currency"],
//           element['CreatedBy'],
//           1,
//           1
//         ]);
//   });
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from ORTT_Temp where RateDate || Rate || Currency || CreatedBy  not in (Select RateDate || Rate || Currency || CreatedBy from ORTT)");
//   v.forEach((element) {
//     batch3.insert('ORTT', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('ORTT_Temp');
// }
Future<void> insertORTT(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteORTT(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncORTT();
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
      for (ORTTModel record in batchRecords) {
        try {
          batch.insert('ORTT_Temp', record.toJson());
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
			select * from ORTT_Temp
			except
			select * from ORTT
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
          batch.update("ORTT", element,
              where:
                  "RateDate = ? AND Rate = ? AND Currency = ? AND CreatedBy = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
              whereArgs: [
                element["RateDate"],
                element["Rate"],
                element["Currency"],
                element['CreatedBy'],
                1,
                1
              ]);
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
  print('Time taken for ORTT update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from ORTT_Temp where RateDate || Rate || Currency || CreatedBy  not in (Select RateDate || Rate || Currency || CreatedBy from ORTT)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM ORTT_Temp T0
LEFT JOIN ORTT T1 ON T0.RateDate = T1.RateDate AND T0.Rate = T1.Rate AND T0.Currency = T1.Currency AND T0.CreatedBy = T1.CreatedBy  
WHERE T1.RateDate IS NULL AND T1.Rate IS NULL AND T1.Currency IS NULL AND T1.CreatedBy IS NULL ;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('ORTT', record);
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
      'Time taken for ORTT_Temp and ORTT compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('ORTT_Temp');
  // stopwatch.stop();
}

Future<List<ORTTModel>> retrieveORTT(BuildContext context, {int? limit}) async {
  final Database db = await initializeDB(context);

  final List<Map<String, Object?>> queryResult =
      await db.query('ORTT', limit: limit);
  return queryResult.map((e) => ORTTModel.fromJson(e)).toList();
}

Future<void> updateORTT(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update("ORTT", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteORTT(Database db) async {
  await db.delete('ORTT');
}

//SEND DATA TO SERVER
//--------------------------
Future<List<ORTTModel>> retrieveORTTById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('ORTT', where: str, whereArgs: l);
  return queryResult.map((e) => ORTTModel.fromJson(e)).toList();
}

Future<void> insertORTTToServer(BuildContext context) async {
  retrieveORTTById(context, DataSync.getInsertToServerStr(),
          DataSync.getInsertToServerList())
      .then((snapshot) {
    print(snapshot);
    snapshot.forEach((data) async {
      var res = await http.post(Uri.parse(prefix + "ORTT/Add"),
          headers: header, body: jsonEncode(data.toJson()));
      print(res.body);
    });
  });
}

Future<void> updateORTTOnServer(BuildContext? context) async {
  retrieveORTTById(context, DataSync.getUpdateOnServerStr(),
          DataSync.getUpdateOnServerList())
      .then((snapshot) {
    print(snapshot);
    snapshot.forEach((data) async {
      var res = await http.put(Uri.parse(prefix + 'ORTT/Update'),
          headers: header, body: jsonEncode(data.toJson()));
      print(res.body);
    });
  });
}
