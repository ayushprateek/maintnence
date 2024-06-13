import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/SyncModels/OUSR.dart';
import 'package:sqflite/sqlite_api.dart';

import '../../main.dart';

List<USR1Model> USR1ModelFromJson(String str) =>
    List<USR1Model>.from(json.decode(str).map((x) => USR1Model.fromJson(x)));

String USR1ModelToJson(List<USR1Model> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class USR1Model {
  USR1Model({
    this.ID,
    this.UserCode,
    this.UpdateDate,
    this.hasCreated = false,
    this.hasUpdated = false,
    this.CreateDate,
    this.BranchId,
    this.BranchName,
  });

  int? ID;
  String? UserCode;
  String? BranchId;
  String? BranchName;
  DateTime? UpdateDate;
  bool hasCreated;
  bool hasUpdated;
  DateTime? CreateDate;

  factory USR1Model.fromJson(Map<String, dynamic> json) => USR1Model(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] == 1,
        hasUpdated: json['has_updated'] == 1,
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        BranchName: json['BranchName']?.toString() ?? '',
        BranchId: json['BranchId']?.toString() ?? '',
        UserCode: json['UserCode'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "UpdateDate": UpdateDate?.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "has_updated": hasUpdated ? 1 : 0,
        "CreateDate": CreateDate?.toIso8601String(),
        'UserCode': UserCode,
        'BranchName': BranchName,
        'BranchId': BranchId,
      };
}

Future<List<USR1Model>> dataSyncUSR1() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "USR1" + postfix));
  print(res.body);
  return USR1ModelFromJson(res.body);
}

Future<List<USR1Model>> retrieveUSR1(BuildContext context,
    {String? orderBy}) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('USR1', orderBy: orderBy);
  return queryResult.map((e) => USR1Model.fromJson(e)).toList();
}

Future<void> updateUSR1(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update("USR1", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteUSR1(Database db) async {
  await db.delete('USR1');
}

Future<void> insertUSR1(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteUSR1(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncUSR1();
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
      for (USR1Model record in batchRecords) {
        try {
          batch.insert('USR1_Temp', record.toJson());
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
			select * from USR1_Temp
			except
			select * from USR1
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
          batch.update("USR1", element,
              where:
                  "ID = ? AND UserCode = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
              whereArgs: [element["ID"], element["Code"], 1, 1]);
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
  print('Time taken for USR1 update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from USR1_Temp where ID not in (Select ID from USR1)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM USR1_Temp T0
LEFT JOIN USR1 T1 ON T0.ID = T1.ID 
WHERE T1.ID IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('USR1', record);
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
      'Time taken for USR1_Temp and USR1 compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('USR1_Temp');
  // stopwatch.stop();
}

Future<List<USR1Model>> retrieveUSR1ByBranch(BuildContext context,
    {String? orderBy}) async {
  // 1. Find BranchId using CreatedBy from OUSR table. (done)
  //==> userModel.BranchId
  // 2. Find All users using that BranchId (done)
  // 3. Filter by CreatedBy and Display their data only.

  List<String> list = [];
  String str = "CreatedBy = ?";
  List<OUSRModel> ousrModel =
      await retrieveOUSRById(context, "BranchId = ?", [userModel.BranchId]);

  for (int i = 0; i < ousrModel.length; i++) {
    list.add(ousrModel[i].UserCode);
    if (i != 0) {
      str += " AND CreatedBy = ?";
    }
  }
  if (list.isEmpty) {
    str = "";
  }
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query("USR1", where: str, whereArgs: list, orderBy: orderBy);

  return queryResult.map((e) => USR1Model.fromJson(e)).toList();
}

//SEND DATA TO SERVER
//--------------------------
Future<List<USR1Model>> retrieveUSR1ById(
    BuildContext? context, String str, List l,
    {String? orderBy}) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('USR1', where: str, whereArgs: l, orderBy: orderBy);
  return queryResult.map((e) => USR1Model.fromJson(e)).toList();
}

// Future<void> insertUSR1ToServer(BuildContext? context,
//     {String? TransId}) async {
//   String response = "";
//   List<USR1Model> list = await retrieveUSR1ById(
//       context,
//       TransId == null ? DataSync.getInsertToServerStr() : "TransId = ?",
//       TransId == null ? DataSync.getInsertToServerList() : [TransId]);
//   if (TransId != null) {
//     //only single entry
//     var res = await http.post(Uri.parse(prefix + "USR1/Add"),
//         headers: header, body: jsonEncode(list[0].toJson()));
//     response = res.body;
//   } else if (list.isNotEmpty) {
//     int i = 0;
//     bool sentSuccessInServer = false;
//     if (list.isEmpty) {
//       return;
//     }
//     do {
//       Map<String, dynamic> map = list[i].toJson();
//       sentSuccessInServer = false;
//       try {
//         print(map);
//         map.remove('ID');
//         var res = await http
//             .post(Uri.parse(prefix + "USR1/Add"),
//                 headers: header, body: jsonEncode(map))
//             .timeout(Duration(seconds: 30), onTimeout: () {
//           return http.Response("Error", 500);
//         });
//         response = await res.body;
//         if (res.statusCode == 201 || res.statusCode == 500) {
//           sentSuccessInServer = true;
//           if (res.statusCode == 201) {
//             map['ID'] = jsonDecode(res.body)['ID'];
//
//             final Database db = await initializeDB(context);
//             map["has_created"] = 0;
//             var x = await db.update("USR1", map,
//                 where: "TransId = ?", whereArgs: [map["TransId"]]);
//             print(x.toString());
//           } else {
//             writeToLogFile(
//                 text: '500 error \nMap : $map',
//                 fileName: StackTrace.current.toString(),
//                 lineNo: 141);
//           }
//         }
//         print(res.body);
//       } catch (e) {
//         writeToLogFile(
//             text: '${e.toString()}\nMap : $map',
//             fileName: StackTrace.current.toString(),
//             lineNo: 141);
//         sentSuccessInServer = true;
//       }
//       i++;
//       print("INDEX = " + i.toString());
//     } while (i < list.length && sentSuccessInServer == true);
//   }
// }
//
// Future<void> updateUSR1OnServer(BuildContext? context,
//     {String? condition, List? l}) async {
//   List<USR1Model> list = await retrieveUSR1ById(
//       context,
//       l == null ? DataSync.getUpdateOnServerStr() : condition ?? "",
//       l == null ? DataSync.getUpdateOnServerList() : l);
//   print(list);
//   int i = 0;
//   bool sentSuccessInServer = false;
//   if (list.isEmpty) {
//     return;
//   }
//   do {
//     Map<String, dynamic> map = list[i].toJson();
//     sentSuccessInServer = false;
//     try {
//       if (list.isEmpty) {
//         return;
//       }
//       Map<String, dynamic> map = list[i].toJson();
//       var res = await http
//           .put(Uri.parse(prefix + 'USR1/Update'),
//               headers: header, body: jsonEncode(map))
//           .timeout(Duration(seconds: 30), onTimeout: () {
//         writeToLogFile(
//             text: '500 error \nMap : $map',
//             fileName: StackTrace.current.toString(),
//             lineNo: 141);
//         return http.Response('Error', 500);
//       });
//       print(await res.statusCode);
//       if (res.statusCode == 201 || res.statusCode == 500) {
//         sentSuccessInServer = true;
//         if (res.statusCode == 201) {
//           final Database db = await initializeDB(context);
//           map["has_updated"] = 0;
//           var x = await db.update("USR1", map,
//               where: "TransId = ?", whereArgs: [map["TransId"]]);
//           print(x.toString());
//         } else {
//           writeToLogFile(
//               text: '500 error \nMap : $map',
//               fileName: StackTrace.current.toString(),
//               lineNo: 141);
//         }
//       }
//       print(res.body);
//     } catch (e) {
//       writeToLogFile(
//           text: '${e.toString()}\nMap : $map',
//           fileName: StackTrace.current.toString(),
//           lineNo: 141);
//       sentSuccessInServer = true;
//     }
//
//     i++;
//     print("INDEX = " + i.toString());
//   } while (i < list.length && sentSuccessInServer == true);
// }
