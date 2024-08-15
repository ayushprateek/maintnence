import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:sqflite/sqlite_api.dart';

class OPRF {
  int? ID;
  String? Code;
  String? Name;
  String? Remarks;
  String? CreatedBy;
  String? UpdatedBy;
  String? BranchId;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  bool? Active;

  OPRF({
    this.ID,
    this.Code,
    this.Name,
    this.Remarks,
    this.CreatedBy,
    this.UpdatedBy,
    this.BranchId,
    this.CreateDate,
    this.UpdateDate,
    this.Active,
  });

  factory OPRF.fromJson(Map<String, dynamic> json) => OPRF(
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        Code: json['Code'] ?? '',
        Name: json['Name'] ?? '',
        Remarks: json['Remarks'] ?? '',
        CreatedBy: json['CreatedBy'] ?? '',
        UpdatedBy: json['UpdatedBy'] ?? '',
        BranchId: json['BranchId'] ?? '',
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()),
        Active: json['Active'] is bool ? json['Active'] : json['Active'] == 1,
      );

  Map<String, dynamic> toJson() => {
        'ID': ID,
        'Code': Code,
        'Name': Name,
        'Remarks': Remarks,
        'CreatedBy': CreatedBy,
        'UpdatedBy': UpdatedBy,
        'BranchId': BranchId,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'Active': Active,
      };
}

List<OPRF> oPRFFromJson(String str) =>
    List<OPRF>.from(json.decode(str).map((x) => OPRF.fromJson(x)));

String oPRFToJson(List<OPRF> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<OPRF>> dataSyncOPRF() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "OPRF" + postfix));
  print(res.body);
  return oPRFFromJson(res.body);
}

Future<void> insertOPRF(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteOPRF(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncOPRF();
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
      for (OPRF record in batchRecords) {
        try {
          batch.insert('OPRF_Temp', record.toJson());
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
			select * from OPRF_Temp
			except
			select * from OPRF
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
          batch.update("OPRF", element,
              //todo: if creating from mobile
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
  print('Time taken for OPRF update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from OPRF_Temp where TransId not in (Select TransId from OPRF)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM OPRF_Temp T0
LEFT JOIN OPRF T1 ON T0.ID = T1.ID 
WHERE T1.ID IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('OPRF', record);
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
      'Time taken for OPRF_Temp and OPRF compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('OPRF_Temp');
}

Future<List<OPRF>> retrieveOPRF(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('OPRF');
  return queryResult.map((e) => OPRF.fromJson(e)).toList();
}

Future<void> updateOPRF(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('OPRF', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deleteOPRF(Database db) async {
  await db.delete('OPRF');
}

Future<List<OPRF>> retrieveOPRFById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('OPRF', where: str, whereArgs: l);
  return queryResult.map((e) => OPRF.fromJson(e)).toList();
}
// Future<String> insertOPRFToServer(BuildContext? context, {String? TransId, int? id}) async {
//   String response = "";
//   List<OPRF> list = await retrieveOPRFById(context, TransId == null ? DataSync.getInsertToServerStr() : "TransId = ? AND ID = ?", TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
//   if (TransId != null) {
//     list[0].ID = 0;
//     var res = await http.post(Uri.parse(prefix + "OPRF/Add"), headers: header, body: jsonEncode(list[0].toJson()));
//     response = res.body;
//   } else if (list.isNotEmpty) {
//     int i = 0;
//     bool sentSuccessInServer = false;
//     do {
//       sentSuccessInServer = false;
//       try {
//         Map<String, dynamic> map = list[i].toJson();
//         map.remove('ID');
//         var res = await http.post(Uri.parse(prefix + "OPRF/Add"), headers: header,
//             body: jsonEncode(map)).timeout(Duration(seconds: 30), onTimeout: () {
//           return http.Response('Error', 500);});
//         response = await res.body;
//         print("eeaaae status");
//         print(await res.statusCode);
//         if (res.statusCode == 201 || res.statusCode == 500) {
//           sentSuccessInServer = true;
//           if (res.statusCode == 201) {
//             map['ID'] = jsonDecode(res.body)['ID'];
//             final Database db = await initializeDB(context);
//             map=jsonDecode(res.body);
//             map["has_created"] = 0;
//             var x = await db.update("OPRF", map, where: "ID = ?", whereArgs: [map["ID"]]);
//             print(x.toString());}}
//         print(res.body);
//       } catch (e) {
//         print("Timeout " + e.toString());
//         sentSuccessInServer = true;}
//       i++;
//       print("INDEX = " + i.toString());
//     } while (i < list.length && sentSuccessInServer == true);}
//   return response;}
// Future<void> updateOPRFOnServer(BuildContext? context, {String? condition, List? l}) async {
//   List<OPRF> list = await retrieveOPRFById(context, l == null ? DataSync.getUpdateOnServerStr() : condition ?? "", l == null ? DataSync.getUpdateOnServerList() : l);
//   print(list);
//   int i = 0;
//   bool sentSuccessInServer = false;
//   do {
//     sentSuccessInServer = false;
//     try {
//       Map<String, dynamic> map = list[i].toJson();
//       var res = await http.put(Uri.parse(prefix + 'OPRF/Update'), headers: header, body: jsonEncode(map)).timeout(Duration(seconds: 30), onTimeout: () {
//         return http.Response('Error', 500);
//       });
//       print(await res.statusCode);
//       if (res.statusCode == 201 || res.statusCode == 500) {
//         sentSuccessInServer = true;
//         if (res.statusCode == 201) {
//           final Database db = await initializeDB(context);
//           map["has_updated"] = 0;
//           var x = await db.update("OPRF", map, where: "ID = ?", whereArgs: [map["ID"]]);
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
