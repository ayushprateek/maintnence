import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

class SUPRM1 {
  int? ID;
  String? ProjectCode;
  String? ModuleName;
  String? SubModuleName;
  String? FormName;
  DateTime? PlanStartDate;
  DateTime? PlanEndDate;
  String? EmpCode;
  String? Status;
  DateTime? ActualStartDate;
  DateTime? ActualEndDate;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  bool? hasCreated;
  bool? hasUpdated;

  SUPRM1({
    this.ID,
    this.ProjectCode,
    this.ModuleName,
    this.SubModuleName,
    this.FormName,
    this.PlanStartDate,
    this.PlanEndDate,
    this.EmpCode,
    this.Status,
    this.ActualStartDate,
    this.ActualEndDate,
    this.CreateDate,
    this.UpdateDate,
    this.hasCreated,
    this.hasUpdated,
  });

  factory SUPRM1.fromJson(Map<String, dynamic> json) => SUPRM1(
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        ProjectCode: json['ProjectCode'],
        ModuleName: json['ModuleName'],
        SubModuleName: json['SubModuleName'],
        FormName: json['FormName'],
        PlanStartDate: DateTime.tryParse(json['PlanStartDate'].toString()),
        PlanEndDate: DateTime.tryParse(json['PlanEndDate'].toString()),
        EmpCode: json['EmpCode'],
        Status: json['Status'],
        ActualStartDate: DateTime.tryParse(json['ActualStartDate'].toString()),
        ActualEndDate: DateTime.tryParse(json['ActualEndDate'].toString()),
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()),
        hasCreated: json['has_created'] is bool
            ? json['has_created']
            : json['has_created'] == 1,
        hasUpdated: json['has_updated'] is bool
            ? json['has_updated']
            : json['has_updated'] == 1,
      );

  Map<String, dynamic> toJson() => {
        'ID': ID,
        'ProjectCode': ProjectCode,
        'ModuleName': ModuleName,
        'SubModuleName': SubModuleName,
        'FormName': FormName,
        'PlanStartDate': PlanStartDate?.toIso8601String(),
        'PlanEndDate': PlanEndDate?.toIso8601String(),
        'EmpCode': EmpCode,
        'Status': Status,
        'ActualStartDate': ActualStartDate?.toIso8601String(),
        'ActualEndDate': ActualEndDate?.toIso8601String(),
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'has_created': hasCreated,
        'has_updated': hasUpdated,
      };
}

List<SUPRM1> sUPRM1FromJson(String str) =>
    List<SUPRM1>.from(json.decode(str).map((x) => SUPRM1.fromJson(x)));

String sUPRM1ToJson(List<SUPRM1> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<SUPRM1>> dataSyncSUPRM1() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "SUPRM1" + postfix));
  print(res.body);
  return sUPRM1FromJson(res.body);
}

// Future<void> insertSUPRM1(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteSUPRM1(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncSUPRM1();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('SUPRM1_Temp', customer.toJson());
//     } catch (e) {
//       writeToLogFile(
//           text: e.toString(),
//           fileName: StackTrace.current.toString(),
//           lineNo: 141);
//       getErrorSnackBar('Sync Error ' + e.toString());
//     }
//   });
//   await batch1.commit(noResult: true);
//   var u = await db.rawQuery(
//       "SELECT * FROM  SUPRM1_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("SUPRM1", element,
//         where: "ProjectCode = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["ProjectCode"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from SUPRM1_Temp where ProjectCode not in (Select ProjectCode from SUPRM1)");
//   v.forEach((element) {
//     batch3.insert('SUPRM1', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('SUPRM1_Temp');
// }
Future<void> insertSUPRM1(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteSUPRM1(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncSUPRM1();
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
      for (SUPRM1 record in batchRecords) {
        try {
          batch.insert('SUPRM1_Temp', record.toJson());
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
			select * from SUPRM1_Temp
			except
			select * from SUPRM1
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
          batch.update("SUPRM1", element,
              where:
                  "ProjectCode = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
              whereArgs: [element["ProjectCode"], 1, 1]);
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
  print('Time taken for SUPRM1 update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from SUPRM1_Temp where ProjectCode not in (Select ProjectCode from SUPRM1)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM SUPRM1_Temp T0
LEFT JOIN SUPRM1 T1 ON T0.ProjectCode = T1.ProjectCode 
WHERE T1.ProjectCode IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('SUPRM1', record);
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
      'Time taken for SUPRM1_Temp and SUPRM1 compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('SUPRM1_Temp');
  // stopwatch.stop();
}

Future<List<SUPRM1>> retrieveSUPRM1(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('SUPRM1');
  return queryResult.map((e) => SUPRM1.fromJson(e)).toList();
}

Future<void> updateSUPRM1(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('SUPRM1', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deleteSUPRM1(Database db) async {
  await db.delete('SUPRM1');
}

Future<List<SUPRM1>> retrieveSUPRM1ById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('SUPRM1', where: str, whereArgs: l);
  return queryResult.map((e) => SUPRM1.fromJson(e)).toList();
}

// Future<void> insertSUPRM1ToServer(BuildContext? context,
//     {String? TransId, int? id}) async {
//   String response = "";
//   List<SUPRM1> list = await retrieveSUPRM1ById(
//       context,
//       TransId == null
//           ? DataSync.getInsertToServerStr()
//           : "TransId = ? AND ID = ?",
//       TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
//   if (TransId != null) {
//     list[0].ID = 0;
//     var res = await http.post(Uri.parse(prefix + "SUPRM1/Add"),
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
//         map.remove('ID');
//         var res = await http
//             .post(Uri.parse(prefix + "SUPRM1/Add"),
//                 headers: header, body: jsonEncode(map))
//             .timeout(Duration(seconds: 30), onTimeout: () {
//           writeToLogFile(
//               text: '500 error \nMap : $map',
//               fileName: StackTrace.current.toString(),
//               lineNo: 141);
//           return http.Response('Error', 500);
//         });
//         response = await res.body;
//         print("eeaaae status");
//         print(await res.statusCode);
//         if (res.statusCode != 201) {
//           await writeToLogFile(
//               text:
//                   '${res.statusCode} error \nMap : $map\nResponse : ${res.body}',
//               fileName: StackTrace.current.toString(),
//               lineNo: 141);
//         }
//         if (res.statusCode == 201 || res.statusCode == 500) {
//           sentSuccessInServer = true;
//           if (res.statusCode == 201) {
//             map['ID'] = jsonDecode(res.body)['ID'];
//             final Database db = await initializeDB(context);
//             // map = jsonDecode(res.body);
//             map["has_created"] = 0;
//             var x = await db.update("SUPRM1", map,
//                 where: "ProjectCode = ?", whereArgs: [map["ProjectCode"]]);
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
// Future<void> updateSUPRM1OnServer(BuildContext? context,
//     {String? condition, List? l}) async {
//   List<SUPRM1> list = await retrieveSUPRM1ById(
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
//           .put(Uri.parse(prefix + 'SUPRM1/Update'),
//               headers: header, body: jsonEncode(map))
//           .timeout(Duration(seconds: 30), onTimeout: () {
//         writeToLogFile(
//             text: '500 error \nMap : $map',
//             fileName: StackTrace.current.toString(),
//             lineNo: 141);
//         return http.Response('Error', 500);
//       });
//       print(await res.statusCode);
//       if (res.statusCode != 201) {
//         await writeToLogFile(
//             text:
//                 '${res.statusCode} error \nMap : $map\nResponse : ${res.body}',
//             fileName: StackTrace.current.toString(),
//             lineNo: 141);
//       }
//       if (res.statusCode == 201 || res.statusCode == 500) {
//         sentSuccessInServer = true;
//         if (res.statusCode == 201) {
//           final Database db = await initializeDB(context);
//           map["has_updated"] = 0;
//           var x = await db.update("SUPRM1", map,
//               where: "ProjectCode = ?", whereArgs: [map["ProjectCode"]]);
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
