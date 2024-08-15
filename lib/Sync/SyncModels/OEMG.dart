import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:sqflite/sqlite_api.dart';

List<OEMGModel> OEMGModelFromJson(String str) =>
    List<OEMGModel>.from(json.decode(str).map((x) => OEMGModel.fromJson(x)));

String OEMGModelToJson(List<OEMGModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OEMGModel {
  OEMGModel({
    required this.ID,
    required this.ShortDesc,
    required this.Remarks,
    required this.Active,
    required this.CreateDate,
    required this.UpdateDate,
    this.hasCreated = false,
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

  factory OEMGModel.fromJson(Map<String, dynamic> json) => OEMGModel(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        ShortDesc: json["ShortDesc"] ?? "",
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] == 1,
        Remarks: json["Remarks"] ?? "",
        Active: json["Active"] is bool ? json["Active"] : json["Active"] == 1,
        CreatedBy: json['CreatedBy'] ?? '',
        BranchId: json['BranchId'] ?? '',
        UpdatedBy: json['UpdatedBy'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "CreateDate": CreateDate.toIso8601String(),
        "UpdateDate": UpdateDate.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "ShortDesc": ShortDesc,
        "Remarks": Remarks,
        "Active": Active == true ? 1 : 0,
        'CreatedBy': CreatedBy,
        'BranchId': BranchId,
        'UpdatedBy': UpdatedBy,
      };
}

Future<List<OEMGModel>> dataSyncOEMG() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "OEMG" + postfix));
  print(res.body);
  return OEMGModelFromJson(res.body);
}

Future<List<OEMGModel>> retrieveOEMG(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('OEMG');
  return queryResult.map((e) => OEMGModel.fromJson(e)).toList();
}

// Future<void> insertOEMG(Database db,{List? list})async{
//   if(postfix.toLowerCase().contains("all"))
//   await deleteOEMG(db);
//   List customers;
//   if(list!=null)
//   {
//     customers=list;
//   }
//   else
//   {
//     customers= await dataSyncOEMG();
//   }
//   print(customers);
//   var batch = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try
//     {
//       batch.insert('OEMG', customer.toJson());
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
//   //       await db.insert('OEMG', customer.toJson());
//   //     });
//   //   }
//   //   catch(e)
//   //   {
//   //     getErrorSnackBar("Sync Error "+e.toString());
//   //   }
//   //
//   // });
// }
// Future<void> insertOEMG(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteOEMG(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncOEMG();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('OEMG_Temp', customer.toJson());
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
//       "SELECT * FROM  OEMG_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN UpdateDate IS NULL THEN CreateDate ELSE UpdateDate END)");
//   u.forEach((element) {
//     batch2.update("OEMG", element,
//         where: "ShortDesc = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["ShortDesc"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from OEMG_Temp where ShortDesc not in (Select ShortDesc from OEMG)");
//   v.forEach((element) {
//     batch3.insert('OEMG', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('OEMG_Temp');
// }
Future<void> insertOEMG(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteOEMG(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncOEMG();
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
      for (OEMGModel record in batchRecords) {
        try {
          batch.insert('OEMG_Temp', record.toJson());
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
			select * from OEMG_Temp
			except
			select * from OEMG
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
          batch.update("OEMG", element,
              where:
                  "ShortDesc = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
              whereArgs: [element["ShortDesc"], 1, 1]);
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
  print('Time taken for OEMG update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from OEMG_Temp where ShortDesc not in (Select ShortDesc from OEMG)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM OEMG_Temp T0
LEFT JOIN OEMG T1 ON T0.ShortDesc = T1.ShortDesc 
WHERE T1.ShortDesc IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('OEMG', record);
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
      'Time taken for OEMG_Temp and OEMG compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('OEMG_Temp');
  // stopwatch.stop();
}

Future<void> updateOEMG(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    await db.transaction((db) async {
      await db.update("OEMG", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteOEMG(Database db) async {
  await db.delete('OEMG');
}

//SEND DATA TO SERVER
//--------------------------
Future<List<OEMGModel>> retrieveOEMGById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('OEMG', where: str, whereArgs: l);
  return queryResult.map((e) => OEMGModel.fromJson(e)).toList();
}

// Future<void> insertOEMGToServer(BuildContext context) async {
//   retrieveOEMGById(context, DataSync.getInsertToServerStr(),
//           DataSync.getInsertToServerList())
//       .then((snapshot) {
//     print(snapshot);
//     snapshot.forEach((data) async {
//       var res = await http.post(Uri.parse(prefix + "OEMG/Add"),
//           headers: header, body: jsonEncode(data.toJson()));
//       print(res.body);
//     });
//   });
// }
//
// Future<void> updateOEMGOnServer(BuildContext? context) async {
//   retrieveOEMGById(context, DataSync.getUpdateOnServerStr(),
//           DataSync.getUpdateOnServerList())
//       .then((snapshot) {
//     print(snapshot);
//     snapshot.forEach((data) async {
//       var res = await http.put(Uri.parse(prefix + 'OEMG/Update'),
//           headers: header, body: jsonEncode(data.toJson()));
//       print(res.body);
//     });
//   });
// }
