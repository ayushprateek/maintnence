import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

class PRF1 {
  int? ID;
  String? Code;
  int? RowId;
  String? PrefixCode;
  String? PrefixName;
  int? DocStartNumber;
  int? DocNumber;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  bool? Active;

  PRF1({
    this.ID,
    this.Code,
    this.RowId,
    this.PrefixCode,
    this.PrefixName,
    this.DocStartNumber,
    this.DocNumber,
    this.CreateDate,
    this.UpdateDate,
    this.Active,
  });

  factory PRF1.fromJson(Map<String, dynamic> json) => PRF1(
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        Code: json['Code'],
        RowId: int.tryParse(json['RowId'].toString()) ?? 0,
        PrefixCode: json['PrefixCode'],
        PrefixName: json['PrefixName'],
        DocStartNumber: int.tryParse(json['DocStartNumber'].toString()) ?? 0,
        DocNumber: int.tryParse(json['DocNumber'].toString()) ?? 0,
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()),
        Active: json['Active'] is bool ? json['Active'] : json['Active'] == 1,
      );

  Map<String, dynamic> toJson() => {
        'ID': ID,
        'Code': Code,
        'RowId': RowId,
        'PrefixCode': PrefixCode,
        'PrefixName': PrefixName,
        'DocStartNumber': DocStartNumber,
        'DocNumber': DocNumber,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'Active': Active,
      };
}

List<PRF1> pRF1FromJson(String str) =>
    List<PRF1>.from(json.decode(str).map((x) => PRF1.fromJson(x)));

String pRF1ToJson(List<PRF1> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<PRF1>> dataSyncPRF1() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "PRF1" + postfix));
  print(res.body);
  return pRF1FromJson(res.body);
}

Future<void> insertPRF1(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deletePRF1(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncPRF1();
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
      for (PRF1 record in batchRecords) {
        try {
          batch.insert('PRF1_Temp', record.toJson());
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
			select * from PRF1_Temp
			except
			select * from PRF1
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
          batch.update("PRF1", element,
              //todo: when creating from mobile
              // where: "ID = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
              where: "ID = ?",
              whereArgs: [element["ID"]]);
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
  print('Time taken for PRF1 update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from PRF1_Temp where TransId not in (Select TransId from PRF1)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM PRF1_Temp T0
LEFT JOIN PRF1 T1 ON T0.ID = T1.ID 
WHERE T1.ID IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('PRF1', record);
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
      'Time taken for PRF1_Temp and PRF1 compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('PRF1_Temp');
}

Future<List<PRF1>> retrievePRF1({int? limit, String? orderBy}) async {
  final Database db = await initializeDB(null);
  final List<Map<String, Object?>> queryResult =
      await db.query('PRF1', limit: limit, orderBy: orderBy);
  return queryResult.map((e) => PRF1.fromJson(e)).toList();
}

Future<List<PRF1>> retrievePRF1ForDisplay(
    {String dbQuery = '', int limit = 30}) async {
  final Database db = await initializeDB(null);
  dbQuery = '%$dbQuery%';
  String searchQuery = '';

  searchQuery = '''
     SELECT * FROM PRF1 
 WHERE Active = 1 AND (PrefixCode LIKE '$dbQuery' OR DocNumber LIKE '$dbQuery') 
 LIMIT $limit
      ''';
  final List<Map<String, Object?>> queryResult = await db.rawQuery(searchQuery);
  return queryResult.map((e) => PRF1.fromJson(e)).toList();
}

Future<void> updatePRF1(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('PRF1', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deletePRF1(Database db) async {
  await db.delete('PRF1');
}

Future<List<PRF1>> retrievePRF1ById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('PRF1', where: str, whereArgs: l);
  return queryResult.map((e) => PRF1.fromJson(e)).toList();
}

// Future<String> insertPRF1ToServer(BuildContext? context,
//     {String? TransId, int? id}) async {
//   String response = "";
//   List<PRF1> list = await retrievePRF1ById(
//       context,
//       TransId == null
//           ? DataSync.getInsertToServerStr()
//           : "TransId = ? AND ID = ?",
//       TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
//   if (TransId != null) {
//     list[0].ID = 0;
//     var res = await http.post(Uri.parse(prefix + "PRF1/Add"),
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
//             .post(Uri.parse(prefix + "PRF1/Add"),
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
//             // map = jsonDecode(res.body);
//             map["has_created"] = 0;
//             var x = await db
//                 .update("PRF1", map, where: "ID = ?", whereArgs: [map["ID"]]);
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
// Future<void> updatePRF1OnServer(BuildContext? context,
//     {String? condition, List? l}) async {
//   List<PRF1> list = await retrievePRF1ById(
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
//           .put(Uri.parse(prefix + 'PRF1/Update'),
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
//           var x = await db.update("PRF1", map,
//               where: "TransId = ? AND RowId = ?",
//               whereArgs: [map["TransId"], map["RowId"]]);
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
