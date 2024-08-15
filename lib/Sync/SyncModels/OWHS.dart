import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:sqflite/sqlite_api.dart';

class OWHS {
  String? WhsCode;
  String? WhsName;
  String? BranchId;
  String? CityName;
  String? WhsType;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  bool? Active;
  int? ID;
  String? CityCode;
  String? CreatedBy;
  String? UpdatedBy;
  bool? hasCreated;
  bool? hasUpdated;

  OWHS({
    this.WhsCode,
    this.WhsName,
    this.BranchId,
    this.CityName,
    this.WhsType,
    this.CreateDate,
    this.UpdateDate,
    this.Active,
    this.ID,
    this.CityCode,
    this.CreatedBy,
    this.UpdatedBy,
    this.hasCreated,
    this.hasUpdated,
  });

  factory OWHS.fromJson(Map<String, dynamic> json) => OWHS(
        WhsCode: json['WhsCode'] ?? '',
        WhsName: json['WhsName'] ?? '',
        BranchId: json['BranchId'] ?? '',
        CityName: json['CityName'] ?? '',
        WhsType: json['WhsType'] ?? '',
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()) ??
            DateTime.parse('1900-01-01'),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()) ??
            DateTime.parse('1900-01-01'),
        Active: json['Active'] is bool ? json['Active'] : json['Active'] == 1,
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        CityCode: json['CityCode'] ?? '',
        CreatedBy: json['CreatedBy'] ?? '',
        UpdatedBy: json['UpdatedBy'] ?? '',
        hasCreated: json['has_created'] is bool
            ? json['has_created']
            : json['has_created'] == 1,
        hasUpdated: json['has_updated'] is bool
            ? json['has_updated']
            : json['has_updated'] == 1,
      );

  Map<String, dynamic> toJson() => {
        'WhsCode': WhsCode,
        'WhsName': WhsName,
        'BranchId': BranchId,
        'CityName': CityName,
        'WhsType': WhsType,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'Active': Active == true ? 1 : 0,
        'ID': ID,
        'CityCode': CityCode,
        'CreatedBy': CreatedBy,
        'UpdatedBy': UpdatedBy,
        'has_created': hasCreated == true ? 1 : 0,
        'has_updated': hasUpdated == true ? 1 : 0,
      };
}

List<OWHS> oWHSFromJson(String str) =>
    List<OWHS>.from(json.decode(str).map((x) => OWHS.fromJson(x)));

String oWHSToJson(List<OWHS> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<OWHS>> dataSyncOWHS() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "OWHS" + postfix));
  print(res.body);
  return oWHSFromJson(res.body);
}

// Future<void> insertOWHS(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteOWHS(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncOWHS();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('OWHS_Temp', customer.toJson());
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
//       "SELECT * FROM  OWHS_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("OWHS", element,
//         where: "ID = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["ID"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from OWHS_Temp where WhsCode not in (Select WhsCode from OWHS)");
//   v.forEach((element) {
//     batch3.insert('OWHS', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('OWHS_Temp');
// }
Future<void> insertOWHS(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteOWHS(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncOWHS();
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
      for (OWHS record in batchRecords) {
        try {
          batch.insert('OWHS_Temp', record.toJson());
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
			select * from OWHS_Temp
			except
			select * from OWHS
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
          batch.update("OWHS", element,
              where:
                  "ID = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
              whereArgs: [element["ID"], 1, 1]);
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
  print('Time taken for OWHS update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from OWHS_Temp where WhsCode not in (Select WhsCode from OWHS)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM OWHS_Temp T0
LEFT JOIN OWHS T1 ON T0.WhsCode = T1.WhsCode 
WHERE T1.WhsCode IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('OWHS', record);
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
      'Time taken for OWHS_Temp and OWHS compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('OWHS_Temp');
  // stopwatch.stop();
}

Future<List<OWHS>> retrieveOWHS(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('OWHS');
  return queryResult.map((e) => OWHS.fromJson(e)).toList();
}

Future<void> updateOWHS(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('OWHS', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deleteOWHS(Database db) async {
  await db.delete('OWHS');
}

Future<List<OWHS>> retrieveOWHSById(BuildContext? context, String str, List l,
    {int? limit}) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('OWHS', where: str, whereArgs: l, limit: limit);
  return queryResult.map((e) => OWHS.fromJson(e)).toList();
}

// Future<void> insertOWHSToServer(BuildContext? context,
//     {String? TransId, int? id}) async {
//   String response = "";
//   List<OWHS> list = await retrieveOWHSById(
//       context,
//       TransId == null
//           ? DataSync.getInsertToServerStr()
//           : "TransId = ? AND ID = ?",
//       TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
//   if (TransId != null) {
//     list[0].ID = 0;
//     var res = await http.post(Uri.parse(prefix + "OWHS/Add"),
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
//             .post(Uri.parse(prefix + "OWHS/Add"),
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
//             var x = await db.update("OWHS", map,
//                 where: "TransId = ? AND RowId = ?",
//                 whereArgs: [map["TransId"], map["RowId"]]);
//             print(x.toString());
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
// Future<void> updateOWHSOnServer(BuildContext? context,
//     {String? condition, List? l}) async {
//   List<OWHS> list = await retrieveOWHSById(
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
//           .put(Uri.parse(prefix + 'OWHS/Update'),
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
//           var x = await db.update("OWHS", map,
//               where: "TransId = ? AND RowId = ?",
//               whereArgs: [map["TransId"], map["RowId"]]);
//           print(x.toString());
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
