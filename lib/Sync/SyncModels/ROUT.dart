import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

List<ROUTModel> ROUTModelFromJson(String str) =>
    List<ROUTModel>.from(json.decode(str).map((x) => ROUTModel.fromJson(x)));

String ROUTModelToJson(List<ROUTModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ROUTModel {
  ROUTModel({
    required this.ID,
    required this.RouteCode,
    required this.RouteName,
    required this.StartingLocation,
    required this.CreateDate,
    required this.UpdateDate,
    this.hasCreated = false,
    required this.EndLocation,
    required this.Active,
    required this.Latitude,
    required this.Longitude,
    required this.Caption,
    required this.TLatitude,
    required this.TLongitude,
    required this.TCaption,
    required this.Distance,
    this.CreatedBy,
    this.UpdatedBy,
  });

  int ID;
  String RouteCode;
  String RouteName;
  DateTime CreateDate;
  DateTime UpdateDate;
  bool hasCreated;
  String StartingLocation;
  String EndLocation;
  bool Active;
  String Latitude;
  String Longitude;
  String Caption;
  String TLatitude;
  String TLongitude;
  String TCaption;
  double Distance;
  String? CreatedBy;
  String? UpdatedBy;

  factory ROUTModel.fromJson(Map<String, dynamic> json) => ROUTModel(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        RouteCode: json["RouteCode"] ?? "",
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] == 1,
        RouteName: json["RouteName"] ?? "",
        StartingLocation: json["StartingLocation"] ?? "",
        EndLocation: json["EndLocation"] ?? "",
        Active: json["Active"] is bool ? json["Active"] : json["Active"] == 1,
        Latitude: json["Latitude"] ?? "",
        Longitude: json["Longitude"] ?? "",
        Caption: json["Caption"] ?? "",
        TLatitude: json["TLatitude"] ?? "",
        TLongitude: json["TLongitude"] ?? "",
        TCaption: json["TCaption"] ?? "",
        Distance: double.tryParse(json["Distance"].toString()) ?? 0.0,
        CreatedBy: json['CreatedBy'] ?? '',
        UpdatedBy: json['UpdatedBy'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "RouteCode": RouteCode,
        "RouteName": RouteName,
        "StartingLocation": StartingLocation,
        "CreateDate": CreateDate.toIso8601String(),
        "UpdateDate": UpdateDate.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "EndLocation": EndLocation,
        "Active": Active == true ? 1 : 0,
        "Latitude": Latitude,
        "Longitude": Longitude,
        "Caption": Caption,
        "TLatitude": TLatitude,
        "TLongitude": TLongitude,
        "TCaption": TCaption,
        "Distance": Distance,
        'CreatedBy': CreatedBy,
        'UpdatedBy': UpdatedBy,
      };
}

Future<List<ROUTModel>> dataSyncROUT() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "ROUT" + postfix));
  print(res.body);
  return ROUTModelFromJson(res.body);
}

Future<List<ROUTModel>> retrieveROUT(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('ROUT');
  return queryResult.map((e) => ROUTModel.fromJson(e)).toList();
}

Future<List<ROUTModel>> retrieveROUTForCustomerVisit({
  required String dbQuery,
  required int limit,
}) async {
  final Database db = await initializeDB(null);
  String query = '''
  SELECT * FROM ROUT WHERE Active = 1 AND RouteCode LIKE '%$dbQuery%' 
  OR RouteName LIKE '%$dbQuery%' LIMIT $limit
  ''';
  final List<Map<String, Object?>> queryResult = await db.rawQuery(query);
  return queryResult.map((e) => ROUTModel.fromJson(e)).toList();
}

Future<void> updateROUT(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    await db.transaction((db) async {
      await db.update("ROUT", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<List<ROUTModel>> retrieveRouteForSearch({
  int? limit,
  String? query,
}) async {
  query = "%$query%";
  final Database db = await initializeDB(null);
  final List<Map<String, Object?>> queryResult = await db.rawQuery(
      'SELECT * FROM ROUT WHERE RouteCode LIKE "$query" OR RouteName LIKE "$query" LIMIT $limit');
  return queryResult.map((e) => ROUTModel.fromJson(e)).toList();
}

Future<void> deleteROUT(Database db) async {
  await db.delete('ROUT');
}

// Future<void> insertROUT(Database db)async{
//   if(postfix.toLowerCase().contains("all"))
//   await deleteROUT(db);
//   List customers= await dataSyncROUT();
//   print(customers);
//   var batch = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try
//     {
//       batch.insert('ROUT', customer.toJson());
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
//   //       await db.insert('ROUT', customer.toJson());
//   //     });
//   //   }
//   //   catch(e)
//   //   {
//   //     getErrorSnackBar("Sync Error "+e.toString());
//   //   }
//   //
//   // });
// }
// Future<void> insertROUT(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteROUT(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncROUT();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('ROUT_Temp', customer.toJson());
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
//       "SELECT * FROM  ROUT_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("ROUT", element,
//         where: "RouteCode = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["RouteCode"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from ROUT_Temp where RouteCode not in (Select RouteCode from ROUT)");
//   v.forEach((element) {
//     batch3.insert('ROUT', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('ROUT_Temp');
// }
Future<void> insertROUT(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteROUT(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncROUT();
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
      for (ROUTModel record in batchRecords) {
        try {
          batch.insert('ROUT_Temp', record.toJson());
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
			select * from ROUT_Temp
			except
			select * from ROUT
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
          batch.update("ROUT", element,
              where:
                  "RouteCode = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
              whereArgs: [element["RouteCode"], 1, 1]);
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
  print('Time taken for ROUT update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from ROUT_Temp where RouteCode not in (Select RouteCode from ROUT)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM ROUT_Temp T0
LEFT JOIN ROUT T1 ON T0.RouteCode = T1.RouteCode 
WHERE T1.RouteCode IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('ROUT', record);
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
      'Time taken for ROUT_Temp and ROUT compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('ROUT_Temp');
  // stopwatch.stop();
}

//SEND DATA TO SERVER
//--------------------------
Future<List<ROUTModel>> retrieveROUTById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('ROUT', where: str, whereArgs: l);
  return queryResult.map((e) => ROUTModel.fromJson(e)).toList();
}

Future<void> insertROUTToServer(BuildContext context) async {
  retrieveROUTById(context, DataSync.getInsertToServerStr(),
          DataSync.getInsertToServerList())
      .then((snapshot) {
    print(snapshot);
    snapshot.forEach((data) async {
      var res = await http.post(Uri.parse(prefix + "ROUT/Add"),
          headers: header, body: jsonEncode(data.toJson()));
      print(res.body);
    });
  });
}

Future<void> updateROUTOnServer(BuildContext? context) async {
  retrieveROUTById(context, DataSync.getUpdateOnServerStr(),
          DataSync.getUpdateOnServerList())
      .then((snapshot) {
    print(snapshot);
    snapshot.forEach((data) async {
      var res = await http.put(Uri.parse(prefix + 'ROUT/Update'),
          headers: header, body: jsonEncode(data.toJson()));
      print(res.body);
    });
  });
}
