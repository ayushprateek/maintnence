import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:sqflite/sqlite_api.dart';

List<OUOMModel> OUOMModelFromJson(String str) =>
    List<OUOMModel>.from(json.decode(str).map((x) => OUOMModel.fromJson(x)));

String OUOMModelToJson(List<OUOMModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OUOMModel {
  OUOMModel({
    required this.CreateDate,
    required this.UpdateDate,
    this.hasCreated = false,
    this.Active = false,
    required this.UomEntry,
    required this.UomCode,
    required this.UomName,
  });

  int UomEntry;
  String UomCode;
  String UomName;
  DateTime CreateDate;
  DateTime UpdateDate;
  bool hasCreated;
  bool Active;

  factory OUOMModel.fromJson(Map<String, dynamic> json) => OUOMModel(
        UomEntry: int.tryParse(json["UomEntry"].toString()) ?? 0,
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] == 1,
        UomCode: json["UomCode"]?.toString() ?? "",
        UomName: json["UomName"]?.toString() ?? "",
        Active: json["Active"] is bool ? json["Active"] : json["Active"] == 1,
      );

  Map<String, dynamic> toJson() => {
        "UomEntry": UomEntry,
        "UomCode": UomCode,
        "CreateDate": CreateDate.toIso8601String(),
        "UpdateDate": UpdateDate.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "UomName": UomName,
        "Active": Active ? 1 : 0,
      };
}

Future<List<OUOMModel>> dataSyncOUOM() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "OUOM" + postfix));
  print(res.body);
  return OUOMModelFromJson(res.body);
}

Future<List<OUOMModel>> retrieveOUOM(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('OUOM');
  return queryResult.map((e) => OUOMModel.fromJson(e)).toList();
}

Future<void> updateOUOM(
    int UomEntry, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    await db.transaction((db) async {
      await db
          .update("OUOM", values, where: 'UomEntry = ?', whereArgs: [UomEntry]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteOUOM(Database db) async {
  await db.delete('OUOM');
}

// Future<void> insertOUOM(Database db)async{
//   if(postfix.toLowerCase().contains("all"))
//   await deleteOUOM(db);
//   List customers= await dataSyncOUOM();
//   print(customers);
//
//   var batch = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try
//     {
//       batch.insert('OUOM', customer.toJson());
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
//   //       await db.insert('OUOM', customer.toJson());
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
// Future<void> insertOUOM(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteOUOM(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncOUOM();
//   }
//   print(customers);
//   var batch = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch.insert('OUOM_Temp', customer.toJson());
//     } catch (e) {
//       writeToLogFile(
//           text: e.toString(),
//           fileName: StackTrace.current.toString(),
//           lineNo: 141);
//       getErrorSnackBar("Sync Error " + e.toString());
//     }
//   });
//   // await batch.commit(noResult: true);
//   // var u=await db.rawQuery("SELECT * FROM  OUOM_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   // u.forEach((element) {
//   //   batch.update("OUOM", element,where:"UomCode = ?",whereArgs: [element["UomCode"]]);
//   // });
//   // await batch.commit(noResult: true);
//   // var v=await db.rawQuery("Select * from OUOM_Temp where UomCode not in (Select UomCode from OUOM)");
//   // v.forEach((element) {
//   //   batch.insert('OUOM', element);
//   // });
//   // // await batch.commit(noResult: true);
//   // await db.delete('OUOM_Temp');
// }

Future<void> insertOUOM(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteOUOM(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncOUOM();
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
      for (OUOMModel record in batchRecords) {
        try {
          batch.insert('OUOM_Temp', record.toJson());
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
			select * from OUOM_Temp
			except
			select * from OUOM
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
          batch.update("OUOM", element,
              where: "UomCode = ?", whereArgs: [element["UomCode"]]);
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
  print('Time taken for OUOM update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from OUOM_Temp where UomCode not in (Select UomCode from OUOM)");

  var v = await db.rawQuery('''
    SELECT T0.*
FROM OUOM_Temp T0
LEFT JOIN OUOM T1 ON T0.UomCode = T1.UomCode 
WHERE T1.UomCode IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('OUOM', record);
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
      'Time taken for OUOM_Temp and OUOM compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('OUOM_Temp');
  // stopwatch.stop();
}

Future<List<OUOMModel>> retrieveOUOMForSearch({
  int? limit,
  String? query,
}) async {
  query = "%$query%";
  final Database db = await initializeDB(null);
  final List<Map<String, Object?>> queryResult = await db.rawQuery(
      'SELECT * FROM OUOM WHERE UomCode LIKE "$query" OR UomName LIKE "$query" LIMIT $limit');
  return queryResult.map((e) => OUOMModel.fromJson(e)).toList();
}

//SEND DATA TO SERVER
//--------------------------
Future<List<OUOMModel>> retrieveOUOMById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('OUOM', where: str, whereArgs: l);
  return queryResult.map((e) => OUOMModel.fromJson(e)).toList();
}

// Future<void> insertOUOMToServer(BuildContext context) async {
//   retrieveOUOMById(context, DataSync.getInsertToServerStr(),
//           DataSync.getInsertToServerList())
//       .then((snapshot) {
//     print(snapshot);
//     snapshot.forEach((data) async {
//       var res = await http.post(Uri.parse(prefix + "OUOM/Add"),
//           headers: header, body: jsonEncode(data.toJson()));
//       print(res.body);
//     });
//   });
// }
//
// Future<void> updateOUOMOnServer(BuildContext? context) async {
//   retrieveOUOMById(context, DataSync.getUpdateOnServerStr(),
//           DataSync.getUpdateOnServerList())
//       .then((snapshot) {
//     print(snapshot);
//     snapshot.forEach((data) async {
//       var res = await http.put(Uri.parse(prefix + 'OUOM/Update'),
//           headers: header, body: jsonEncode(data.toJson()));
//       print(res.body);
//     });
//   });
// }
