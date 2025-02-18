import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

class MNEQG2 {
  int? ID;
  String? Code;
  int? RowId;
  String? CheckListCode;
  String? CheckListName;
  double? Days;
  String? Unit;
  double? TimeRequired;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  bool? IsTyreMaintenence;

  MNEQG2({
    this.ID,
    this.Code,
    this.RowId,
    this.CheckListCode,
    this.CheckListName,
    this.Days,
    this.Unit,
    this.TimeRequired,
    this.CreateDate,
    this.UpdateDate,
    this.IsTyreMaintenence,
  });

  factory MNEQG2.fromJson(Map<String, dynamic> json) => MNEQG2(
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        Code: json['Code']?.toString() ?? '',
        RowId: int.tryParse(json['RowId'].toString()) ?? 0,
        CheckListCode: json['CheckListCode']?.toString() ?? '',
        CheckListName: json['CheckListName']?.toString() ?? '',
        Days: double.tryParse(json['Days'].toString()) ?? 0.0,
        Unit: json['Unit']?.toString() ?? '',
        TimeRequired: double.tryParse(json['TimeRequired'].toString()) ?? 0.0,
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()),
        IsTyreMaintenence: json['IsTyreMaintenence'] is bool
            ? json['IsTyreMaintenence']
            : json['IsTyreMaintenence'] == 1,
      );

  Map<String, dynamic> toJson() => {
        'ID': ID,
        'Code': Code,
        'RowId': RowId,
        'CheckListCode': CheckListCode,
        'CheckListName': CheckListName,
        'Days': Days,
        'Unit': Unit,
        'TimeRequired': TimeRequired,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'IsTyreMaintenence': IsTyreMaintenence,
      };
}

List<MNEQG2> mNEQG2FromJson(String str) =>
    List<MNEQG2>.from(json.decode(str).map((x) => MNEQG2.fromJson(x)));

String mNEQG2ToJson(List<MNEQG2> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<MNEQG2>> dataSyncMNEQG2() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "MNEQG2" + postfix));
  print(res.body);
  return mNEQG2FromJson(res.body);
}

Future<void> insertMNEQG2(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteMNEQG2(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncMNEQG2();
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
      for (MNEQG2 record in batchRecords) {
        try {
          batch.insert('MNEQG2_Temp', record.toJson());
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
			select * from MNEQG2_Temp
			except
			select * from MNEQG2
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
          batch.update("MNEQG2", element,
              where:
                  "Code = ? AND RowId = ?AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
              whereArgs: [element["Code"], element["RowId"], 1, 1]);
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
  print('Time taken for MNEQG2 update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from MNEQG2_Temp where TransId not in (Select TransId from MNEQG2)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM MNEQG2_Temp T0
LEFT JOIN MNEQG2 T1 ON T0.Code = T1.Code AND T0.RowId = T1.RowId
WHERE T1.Code IS NULL AND T1.RowId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('MNEQG2', record);
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
      'Time taken for MNEQG2_Temp and MNEQG2 compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('MNEQG2_Temp');
}

Future<List<MNEQG2>> retrieveMNEQG2(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('MNEQG2');
  return queryResult.map((e) => MNEQG2.fromJson(e)).toList();
}

Future<void> updateMNEQG2(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('MNEQG2', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deleteMNEQG2(Database db) async {
  await db.delete('MNEQG2');
}

Future<List<MNEQG2>> retrieveMNEQG2ById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('MNEQG2', where: str, whereArgs: l);
  return queryResult.map((e) => MNEQG2.fromJson(e)).toList();
}

// Future<String> insertMNEQG2ToServer(BuildContext? context,
//     {String? TransId, int? id}) async {
//   String response = "";
//   List<MNEQG2> list = await retrieveMNEQG2ById(
//       context,
//       TransId == null
//           ? DataSync.getInsertToServerStr()
//           : "TransId = ? AND ID = ?",
//       TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
//   if (TransId != null) {
//     list[0].ID = 0;
//     var res = await http.post(Uri.parse(prefix + "MNEQG2/Add"),
//         headers: header, body: jsonEncode(list[0].toJson()));
//     response = res.body;
//   } else if (list.isNotEmpty) {
//     int i = 0;
//     bool sentSuccessInServer = false;
//     do {
//       sentSuccessInServer = false;
//       try {
//         Map<String, dynamic> map = list[i].toJson();
//         map.remove('ID');
//         var res = await http
//             .post(Uri.parse(prefix + "MNEQG2/Add"),
//                 headers: header, body: jsonEncode(map))
//             .timeout(Duration(seconds: 30), onTimeout: () {
//           return http.Response('Error', 500);
//         });
//         response = await res.body;
//         print("eeaaae status");
//         print(await res.statusCode);
//         if (res.statusCode == 201 || res.statusCode == 500) {
//           sentSuccessInServer = true;
//           if (res.statusCode == 201) {
//             map['ID'] = jsonDecode(res.body)['ID'];
//             final Database db = await initializeDB(context);
//             // map=jsonDecode(res.body);
//             map["has_created"] = 0;
//             var x = await db.update("MNEQG2", map,
//                 where: "Code = ? AND RowId = ?",
//                 whereArgs: [map["Code"], map["RowId"]]);
//             print(x.toString());
//           }
//         }
//         print(res.body);
//       } catch (e) {
//         print("Timeout " + e.toString());
//         sentSuccessInServer = true;
//       }
//       i++;
//       print("INDEX = " + i.toString());
//     } while (i < list.length && sentSuccessInServer == true);
//   }
//   return response;
// }
//
// Future<void> updateMNEQG2OnServer(BuildContext? context,
//     {String? condition, List? l}) async {
//   List<MNEQG2> list = await retrieveMNEQG2ById(
//       context,
//       l == null ? DataSync.getUpdateOnServerStr() : condition ?? "",
//       l == null ? DataSync.getUpdateOnServerList() : l);
//   print(list);
//   int i = 0;
//   bool sentSuccessInServer = false;
//   do {
//     sentSuccessInServer = false;
//     try {
//       Map<String, dynamic> map = list[i].toJson();
//       var res = await http
//           .put(Uri.parse(prefix + 'MNEQG2/Update'),
//               headers: header, body: jsonEncode(map))
//           .timeout(Duration(seconds: 30), onTimeout: () {
//         return http.Response('Error', 500);
//       });
//       print(await res.statusCode);
//       if (res.statusCode == 201 || res.statusCode == 500) {
//         sentSuccessInServer = true;
//         if (res.statusCode == 201) {
//           final Database db = await initializeDB(context);
//           map["has_updated"] = 0;
//           var x = await db.update("MNEQG2", map,
//               where: "Code = ? AND RowId = ?",
//               whereArgs: [map["Code"], map["RowId"]]);
//           print(x.toString());
//         }
//       }
//       print(res.body);
//     } catch (e) {
//       print("Timeout " + e.toString());
//       sentSuccessInServer = true;
//     }
//
//     i++;
//     print("INDEX = " + i.toString());
//   } while (i < list.length && sentSuccessInServer == true);
// }
