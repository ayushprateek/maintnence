import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:sqflite/sqlite_api.dart';

class SUOATE {
  int? ID;
  String? TicketCode;
  String? EmpCode;
  String? AssignedBy;
  String? RaisedBy;
  String? Status;
  String? Remarks;
  String? CreatedBy;
  String? UpdatedBy;
  String? BranchId;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  bool? IsTicketTaken;
  bool? IsDeleted;
  DateTime? TakenDate;
  bool? hasCreated;
  bool? hasUpdated;

  SUOATE({
    this.ID,
    this.TicketCode,
    this.EmpCode,
    this.AssignedBy,
    this.RaisedBy,
    this.Status,
    this.Remarks,
    this.CreatedBy,
    this.UpdatedBy,
    this.BranchId,
    this.CreateDate,
    this.UpdateDate,
    this.IsTicketTaken,
    this.IsDeleted,
    this.TakenDate,
    this.hasCreated,
    this.hasUpdated,
  });

  factory SUOATE.fromJson(Map<String, dynamic> json) => SUOATE(
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        TicketCode: json['TicketCode'],
        EmpCode: json['EmpCode'],
        AssignedBy: json['AssignedBy'],
        RaisedBy: json['RaisedBy'],
        Status: json['Status'],
        Remarks: json['Remarks'],
        CreatedBy: json['CreatedBy'],
        UpdatedBy: json['UpdatedBy'],
        BranchId: json['BranchId'],
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()),
        IsTicketTaken: json['IsTicketTaken'] is bool
            ? json['IsTicketTaken']
            : json['IsTicketTaken'] == 1,
        IsDeleted: json['IsDeleted'] is bool
            ? json['IsDeleted']
            : json['IsDeleted'] == 1,
        TakenDate: DateTime.tryParse(json['TakenDate'].toString()),
        hasCreated: json['has_created'] is bool
            ? json['has_created']
            : json['has_created'] == 1,
        hasUpdated: json['has_updated'] is bool
            ? json['has_updated']
            : json['has_updated'] == 1,
      );

  Map<String, dynamic> toJson() => {
        'ID': ID,
        'TicketCode': TicketCode,
        'EmpCode': EmpCode,
        'AssignedBy': AssignedBy,
        'RaisedBy': RaisedBy,
        'Status': Status,
        'Remarks': Remarks,
        'CreatedBy': CreatedBy,
        'UpdatedBy': UpdatedBy,
        'BranchId': BranchId,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'IsTicketTaken': IsTicketTaken,
        'IsDeleted': IsDeleted,
        'TakenDate': TakenDate?.toIso8601String(),
        'has_created': hasCreated,
        'has_updated': hasUpdated,
      };
}

List<SUOATE> sUOATEFromJson(String str) =>
    List<SUOATE>.from(json.decode(str).map((x) => SUOATE.fromJson(x)));

String sUOATEToJson(List<SUOATE> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<SUOATE>> dataSyncSUOATE() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "SUOATE" + postfix));
  print(res.body);
  return sUOATEFromJson(res.body);
}

// Future<void> insertSUOATE(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteSUOATE(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncSUOATE();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('SUOATE_Temp', customer.toJson());
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
//       "SELECT * FROM  SUOATE_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("SUOATE", element,
//         where: "TicketCode = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [
//           element["TicketCode"], 1, 1
//         ]);
//   });
//   await batch2.commit(noResult: true);
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from SUOATE_Temp where TicketCode not in (Select TicketCode from SUOATE)");
//   v.forEach((element) {
//     batch3.insert('SUOATE', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('SUOATE_Temp');
// }
Future<void> insertSUOATE(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteSUOATE(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncSUOATE();
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
      for (SUOATE record in batchRecords) {
        try {
          batch.insert('SUOATE_Temp', record.toJson());
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
			select * from SUOATE_Temp
			except
			select * from SUOATE
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
          batch.update("SUOATE", element,
              where:
                  "TicketCode = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
              whereArgs: [element["TicketCode"], 1, 1]);
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
  print('Time taken for SUOATE update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from SUOATE_Temp where TicketCode not in (Select TicketCode from SUOATE)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM SUOATE_Temp T0
LEFT JOIN SUOATE T1 ON T0.TicketCode = T1.TicketCode 
WHERE T1.TicketCode IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('SUOATE', record);
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
      'Time taken for SUOATE_Temp and SUOATE compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('SUOATE_Temp');
  // stopwatch.stop();
}

Future<List<SUOATE>> retrieveSUOATE(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('SUOATE');
  return queryResult.map((e) => SUOATE.fromJson(e)).toList();
}

Future<void> updateSUOATE(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('SUOATE', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deleteSUOATE(Database db) async {
  await db.delete('SUOATE');
}

Future<List<SUOATE>> retrieveSUOATEById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('SUOATE', where: str, whereArgs: l);
  return queryResult.map((e) => SUOATE.fromJson(e)).toList();
}

// Future<void> insertSUOATEToServer(BuildContext? context,
//     {String? TransId, int? id}) async {
//   String response = "";
//   List<SUOATE> list = await retrieveSUOATEById(
//       context,
//       TransId == null
//           ? DataSync.getInsertToServerStr()
//           : "TransId = ? AND ID = ?",
//       TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
//   if (TransId != null) {
//     list[0].ID = 0;
//     var res = await http.post(Uri.parse(prefix + "SUOATE/Add"),
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
//             .post(Uri.parse(prefix + "SUOATE/Add"),
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
//             var x = await db.update("SUOATE", map,
//                 where: "TicketCode = ?", whereArgs: [map["TicketCode"]]);
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
// Future<void> updateSUOATEOnServer(BuildContext? context,
//     {String? condition, List? l}) async {
//   List<SUOATE> list = await retrieveSUOATEById(
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
//           .put(Uri.parse(prefix + 'SUOATE/Update'),
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
//           var x = await db.update("SUOATE", map,
//               where: "TicketCode = ?", whereArgs: [map["TicketCode"]]);
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
