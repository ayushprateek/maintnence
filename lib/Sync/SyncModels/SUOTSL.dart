import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

class SUOTSL {
  int? ID;
  int? TaskUniqueId;
  int? TaskParentId;
  String? TicketCode;
  String? Subject;
  DateTime? StartDate;
  DateTime? EndDate;
  DateTime? StartTime;
  DateTime? EndTime;
  String? Attachment;
  String? Status;
  String? Details;
  String? CreatedBy;
  String? UpdatedBy;
  String? BranchId;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  bool? IsChild;
  bool? hasCreated;
  bool? hasUpdated;
  bool? IsTaskChecked;

  SUOTSL({
    this.ID,
    this.TaskUniqueId,
    this.TaskParentId,
    this.TicketCode,
    this.Subject,
    this.StartDate,
    this.EndDate,
    this.StartTime,
    this.EndTime,
    this.Attachment,
    this.Status,
    this.Details,
    this.CreatedBy,
    this.UpdatedBy,
    this.BranchId,
    this.CreateDate,
    this.UpdateDate,
    this.hasCreated,
    this.hasUpdated,
    this.IsTaskChecked,
    this.IsChild,
  });

  factory SUOTSL.fromJson(Map<String, dynamic> json) => SUOTSL(
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        TaskUniqueId: int.tryParse(json['TaskUniqueId'].toString()) ?? 0,
        TaskParentId: int.tryParse(json['TaskParentId'].toString()) ?? 0,
        TicketCode: json['TicketCode'],
        Subject: json['Subject'],
        StartDate: DateTime.tryParse(json['StartDate'].toString()),
        EndDate: DateTime.tryParse(json['EndDate'].toString()),
        StartTime: DateTime.tryParse(json['StartTime'].toString()),
        EndTime: DateTime.tryParse(json['EndTime'].toString()),
        Attachment: json['Attachment'],
        Status: json['Status'],
        Details: json['Details'],
        CreatedBy: json['CreatedBy'],
        UpdatedBy: json['UpdatedBy'],
        BranchId: json['BranchId'],
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()),
        hasCreated: json['has_created'] is bool
            ? json['has_created']
            : json['has_created'] == 1,
        IsChild:
            json['IsChild'] is bool ? json['IsChild'] : json['IsChild'] == 1,
        hasUpdated: json['has_updated'] is bool
            ? json['has_updated']
            : json['has_updated'] == 1,
        IsTaskChecked: json['IsTaskChecked'] is bool
            ? json['IsTaskChecked']
            : json['IsTaskChecked'] == 1,
      );

  Map<String, dynamic> toJson() => {
        'ID': ID,
        'TaskUniqueId': TaskUniqueId,
        'TaskParentId': TaskParentId,
        'TicketCode': TicketCode,
        'Subject': Subject,
        'StartDate': StartDate?.toIso8601String(),
        'EndDate': EndDate?.toIso8601String(),
        'StartTime': StartTime?.toIso8601String(),
        'EndTime': EndTime?.toIso8601String(),
        'Attachment': Attachment,
        'Status': Status,
        'Details': Details,
        'CreatedBy': CreatedBy,
        'UpdatedBy': UpdatedBy,
        'BranchId': BranchId,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'has_created': hasCreated == true ? 1 : 0,
        'has_updated': hasUpdated == true ? 1 : 0,
        'IsTaskChecked': IsTaskChecked == true ? 1 : 0,
        'IsChild': IsChild == true ? 1 : 0,
      };
}

List<SUOTSL> sUOTSKLFromJson(String str) =>
    List<SUOTSL>.from(json.decode(str).map((x) => SUOTSL.fromJson(x)));

String sUOTSKLToJson(List<SUOTSL> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<SUOTSL>> dataSyncSUOTSL() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "SUOTSL" + postfix));
  print(res.body);
  return sUOTSKLFromJson(res.body);
}

// Future<void> insertSUOTSL(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteSUOTSL(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncSUOTSL();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('SUOTSL_Temp', customer.toJson());
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
//       "SELECT * FROM  SUOTSL_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN UpdateDate IS NULL THEN CreateDate ELSE UpdateDate END)");
//   u.forEach((element) {
//     batch2.update("SUOTSL", element,
//         where: "TicketCode = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["TicketCode"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from SUOTSL_Temp where TicketCode not in (Select TicketCode from SUOTSL)");
//   v.forEach((element) {
//     batch3.insert('SUOTSL', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('SUOTSL_Temp');
// }
Future<void> insertSUOTSL(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteSUOTSL(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncSUOTSL();
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
      for (SUOTSL record in batchRecords) {
        try {
          batch.insert('SUOTSL_Temp', record.toJson());
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
			select * from SUOTSL_Temp
			except
			select * from SUOTSL
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
          batch.update("SUOTSL", element,
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
  print('Time taken for SUOTSL update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from SUOTSL_Temp where TicketCode not in (Select TicketCode from SUOTSL)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM SUOTSL_Temp T0
LEFT JOIN SUOTSL T1 ON T0.TicketCode = T1.TicketCode 
WHERE T1.TicketCode IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('SUOTSL', record);
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
      'Time taken for SUOTSL_Temp and SUOTSL compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('SUOTSL_Temp');
  // stopwatch.stop();
}

Future<List<SUOTSL>> retrieveSUOTSL(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('SUOTSL');
  return queryResult.map((e) => SUOTSL.fromJson(e)).toList();
}

Future<void> updateSUOTSL(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('SUOTSL', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deleteSUOTSL(Database db) async {
  await db.delete('SUOTSL');
}

Future<List<SUOTSL>> retrieveSUOTSLById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('SUOTSL', where: str, whereArgs: l);
  return queryResult.map((e) => SUOTSL.fromJson(e)).toList();
}

// Future<void> insertSUOTSLToServer(BuildContext? context,
//     {String? TransId, int? id}) async {
//   String response = "";
//   List<SUOTSL> list = await retrieveSUOTSLById(
//       context,
//       TransId == null
//           ? DataSync.getInsertToServerStr()
//           : "TransId = ? AND ID = ?",
//       TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
//   if (TransId != null) {
//     list[0].ID = 0;
//     var res = await http.post(Uri.parse(prefix + "SUOTSL/Add"),
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
//             .post(Uri.parse(prefix + "SUOTSL/Add"),
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
//             var x = await db.update("SUOTSL", map,
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
// Future<void> updateSUOTSLOnServer(BuildContext? context,
//     {String? condition, List? l}) async {
//   List<SUOTSL> list = await retrieveSUOTSLById(
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
//           .put(Uri.parse(prefix + 'SUOTSL/Update'),
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
//           var x = await db.update("SUOTSL", map,
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

Future<List<SUOTSL>> getExpansionTileData() async {
  Database db = await initializeDB(null);
  //results = db.SUOTSLs.Where(s => s.TaskUniqueId.HasValue && s.TaskParentId.HasValue && s.TaskUniqueId.Value == s.TaskParentId.Value).ToList();
  final List<Map<String, Object?>> queryResult =
      await db.rawQuery('SELECT * FROM SUOTSL WHERE TaskUniqueId=TaskParentId');
  return queryResult.map((e) => SUOTSL.fromJson(e)).toList();
}

Future<SUOTSL?> GetSingleTask(int? TaskUniqueId) async {
  // SUOTSL sUOTSL = db.SUOTSLs.Where(x => TaskUniqueId == TaskUniqueId).First();
  List<SUOTSL> suotslList =
      await retrieveSUOTSLById(null, 'TaskUniqueId = ?', [TaskUniqueId]);
  if (suotslList.isEmpty) {
    return suotslList[0];
  } else {
    return null;
  }
  // return Json(sUOTSL, JsonRequestBehavior.AllowGet);
}

Future<List<SUOTSL>> GetAllParentTask() async {
  Database db = await initializeDB(null);
  final List<Map<String, Object?>> queryResult =
      await db.rawQuery('SELECT * FROM SUOTSL WHERE TaskUniqueId=TaskParentId');
  return queryResult.map((e) => SUOTSL.fromJson(e)).toList();
}

Future<List<SUOTSL>> getAllChildTask(int? TaskUniqueId) async {
  // List<SUOTSL> sUOTSL = db.SUOTSLs.Where(x => x.TaskParentId == TaskUniqueId).ToList();
  List<SUOTSL> sUOTSL =
      await retrieveSUOTSLById(null, 'TaskParentId = ?', [TaskUniqueId]);
  return sUOTSL;
}

// public JsonResult ChangeStatusTask(int? TaskUniqueId, bool IsTaskChecked = false)
// {
// SUOTSL sUOTSL = db.SUOTSLs.Where(x => TaskUniqueId == TaskUniqueId).First();
// if (sUOTSL != null)
// {
// sUOTSL.IsTaskChecked = IsTaskChecked;
// sUOTSL.UpdateDate = DateTime.Now;
// db.Entry(sUOTSL).State = EntityState.Modified;
// _ = db.SaveChanges();
// return Json("Data is Successfully Updated !");
// }
// else
// {
// return Json("No Change");
// }
// }
