import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:sqflite/sqlite_api.dart';

List<OTRNSModel> OTRNSModelFromJson(String str) =>
    List<OTRNSModel>.from(json.decode(str).map((x) => OTRNSModel.fromJson(x)));

String OTRNSModelToJson(List<OTRNSModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OTRNSModel {
  OTRNSModel({
    required this.CreateDate,
    required this.UpdateDate,
    this.hasCreated = false,
    required this.ID,
    required this.CardCode,
    required this.CardName,
    required this.GroupCode,
    required this.GroupName,
    this.CreatedBy,
    this.BranchId,
    this.UpdatedBy,
  });

  int ID;
  String CardCode;
  String CardName;
  String GroupCode;
  String GroupName;
  DateTime CreateDate;
  DateTime UpdateDate;
  bool hasCreated;
  String? CreatedBy;
  String? BranchId;
  String? UpdatedBy;

  factory OTRNSModel.fromJson(Map<String, dynamic> json) => OTRNSModel(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] == 1,
        CardCode: json["CardCode"] ?? "",
        GroupCode: json["GroupCode"] ?? "",
        GroupName: json["GroupName"] ?? "",
        CardName: json["CardName"] ?? "",
        CreatedBy: json['CreatedBy'] ?? '',
        BranchId: json['BranchId'] ?? '',
        UpdatedBy: json['UpdatedBy'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "GroupCode": GroupCode,
        "CardCode": CardCode,
        "CreateDate": CreateDate.toIso8601String(),
        "UpdateDate": UpdateDate.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "GroupName": GroupName,
        "CardName": CardName,
        'CreatedBy': CreatedBy,
        'BranchId': BranchId,
        'UpdatedBy': UpdatedBy,
      };
}

Future<List<OTRNSModel>> dataSyncOTRNS() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "OTRNS" + postfix));
  print(res.body);
  return OTRNSModelFromJson(res.body);
}

Future<List<OTRNSModel>> retrieveOTRNS(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('OTRNS');
  return queryResult.map((e) => OTRNSModel.fromJson(e)).toList();
}

Future<void> updateOTRNS(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update("OTRNS", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteOTRNS(Database db) async {
  await db.delete('OTRNS');
}

// Future<void> insertOTRNS(Database db)async{
//   if(postfix.toLowerCase().contains("all"))
//   await deleteOTRNS(db);
//   List customers= await dataSyncOTRNS();
//   print(customers);
//
//   var batch = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try
//     {
//       batch.insert('OTRNS', customer.toJson());
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
//   //       await db.insert('OTRNS', customer.toJson());
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
// Future<void> insertOTRNS(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteOTRNS(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncOTRNS();
//   }
//   print(customers);
//   var batch = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch.insert('OTRNS_Temp', customer.toJson());
//     } catch (e) {
//       writeToLogFile(
//           text: e.toString(),
//           fileName: StackTrace.current.toString(),
//           lineNo: 141);
//       getErrorSnackBar("Sync Error " + e.toString());
//     }
//   });
//   // await batch.commit(noResult: true);
//   // var u=await db.rawQuery("SELECT * FROM  OTRNS_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   // u.forEach((element) {
//   //   batch.update("OTRNS", element,where:"CardCode = ? AND GroupCode = ?",whereArgs: [element["CardCode"],element["GroupCode"]]);
//   // });
//   // await batch.commit(noResult: true);
//   // var v=await db.rawQuery("Select * from OTRNS_Temp where CardCode || GroupCode not in (Select CardCode || GroupCode from OTRNS)");
//   // v.forEach((element) {
//   //   batch.insert('OTRNS', element);
//   // });
//   // await batch.commit(noResult: true);
//   // await db.delete('OTRNS_Temp');
// }
Future<void> insertOTRNS(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteOTRNS(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncOTRNS();
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
      for (OTRNSModel record in batchRecords) {
        try {
          batch.insert('OTRNS_Temp', record.toJson());
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
			select * from OTRNS_Temp
			except
			select * from OTRNS
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
          batch.update("OTRNS", element,
              where: "CardCode = ? AND GroupCode = ?",
              whereArgs: [element["CardCode"], element["GroupCode"]]);
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
  print('Time taken for OTRNS update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from OTRNS_Temp where CardCode || GroupCode not in (Select CardCode || GroupCode from OTRNS)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM OTRNS_Temp T0
LEFT JOIN OTRNS T1 ON T0.CardCode = T1.CardCode  AND T0.GroupCode = T1.GroupCode 
WHERE T1.CardCode IS NULL AND T1.GroupCode IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('OTRNS', record);
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
      'Time taken for OTRNS_Temp and OTRNS compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('OTRNS_Temp');
  // stopwatch.stop();
}

//SEND DATA TO SERVER
//--------------------------
Future<List<OTRNSModel>> retrieveOTRNSById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('OTRNS', where: str, whereArgs: l);
  return queryResult.map((e) => OTRNSModel.fromJson(e)).toList();
}

// Future<void> insertOTRNSToServer(BuildContext context) async {
//   retrieveOTRNSById(context, DataSync.getInsertToServerStr(),
//           DataSync.getInsertToServerList())
//       .then((snapshot) {
//     print(snapshot);
//     snapshot.forEach((data) async {
//       var res = await http.post(Uri.parse(prefix + "OTRNS/Add"),
//           headers: header, body: jsonEncode(data.toJson()));
//       print(res.body);
//     });
//   });
// }
//
// Future<void> updateOTRNSOnServer(BuildContext? context) async {
//   retrieveOTRNSById(context, DataSync.getUpdateOnServerStr(),
//           DataSync.getUpdateOnServerList())
//       .then((snapshot) {
//     print(snapshot);
//     snapshot.forEach((data) async {
//       var res = await http.put(Uri.parse(prefix + 'OTRNS/Update'),
//           headers: header, body: jsonEncode(data.toJson()));
//       print(res.body);
//     });
//   });
// }
