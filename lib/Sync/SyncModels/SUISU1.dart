import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:sqflite/sqlite_api.dart';

class SUISU1 {
  int? ID;
  int? BaseMessageId;
  String? TicketCode;
  String? Message;
  String? Attachment;
  String? CreatedBy;
  bool? IsDeleted;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  bool? hasCreated;
  bool? hasUpdated;

  ///CREATED ONLY FOR DEVELOPMENT PURPOSE
  TextEditingController message = TextEditingController();

  SUISU1({
    this.ID,
    this.BaseMessageId,
    this.TicketCode,
    this.Message,
    this.Attachment,
    this.CreatedBy,
    this.IsDeleted,
    this.CreateDate,
    this.UpdateDate,
    this.hasCreated,
    this.hasUpdated,
  });

  factory SUISU1.fromJson(Map<String, dynamic> json) => SUISU1(
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        BaseMessageId: int.tryParse(json['BaseMessageId'].toString()) ?? 0,
        TicketCode: json['TicketCode'],
        Message: json['Message'],
        Attachment: json['Attachment'],
        CreatedBy: json['CreatedBy'],
        IsDeleted: json['IsDeleted'] is bool
            ? json['IsDeleted']
            : json['IsDeleted'] == 1,
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
        'BaseMessageId': BaseMessageId,
        'TicketCode': TicketCode,
        'Message': Message,
        'Attachment': Attachment,
        'CreatedBy': CreatedBy,
        'IsDeleted': IsDeleted,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'has_created': hasCreated,
        'has_updated': hasUpdated,
      };
}

List<SUISU1> sUISU1FromJson(String str) =>
    List<SUISU1>.from(json.decode(str).map((x) => SUISU1.fromJson(x)));

String sUISU1ToJson(List<SUISU1> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<SUISU1>> dataSyncSUISU1() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "SUISU1" + postfix));
  print(res.body);
  return sUISU1FromJson(res.body);
}

// Future<void> insertSUISU1(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteSUISU1(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncSUISU1();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('SUISU1_Temp', customer.toJson());
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
//       "SELECT * FROM  SUISU1_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("SUISU1", element,
//         where: "TicketCode = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["TicketCode"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from SUISU1_Temp where TicketCode not in (Select TicketCode from SUISU1)");
//   v.forEach((element) {
//     batch3.insert('SUISU1', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('SUISU1_Temp');
// }
Future<void> insertSUISU1(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteSUISU1(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncSUISU1();
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
      for (SUISU1 record in batchRecords) {
        try {
          batch.insert('SUISU1_Temp', record.toJson());
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
			select * from SUISU1_Temp
			except
			select * from SUISU1
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
          batch.update("SUISU1", element,
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
  print('Time taken for SUISU1 update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from SUISU1_Temp where TicketCode not in (Select TicketCode from SUISU1)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM SUISU1_Temp T0
LEFT JOIN SUISU1 T1 ON T0.TicketCode = T1.TicketCode 
WHERE T1.TicketCode IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('SUISU1', record);
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
      'Time taken for SUISU1_Temp and SUISU1 compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('SUISU1_Temp');
  // stopwatch.stop();
}

Future<List<SUISU1>> retrieveSUISU1(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('SUISU1');
  return queryResult.map((e) => SUISU1.fromJson(e)).toList();
}

Future<void> updateSUISU1(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('SUISU1', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deleteSUISU1(Database db) async {
  await db.delete('SUISU1');
}

Future<List<SUISU1>> retrieveSUISU1ById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('SUISU1', where: str, whereArgs: l);
  return queryResult.map((e) => SUISU1.fromJson(e)).toList();
}

// Future<void> insertSUISU1ToServer(BuildContext? context,
//     {String? TransId, int? id}) async {
//   String response = "";
//   List<SUISU1> list = await retrieveSUISU1ById(
//       context,
//       TransId == null ? DataSync.getInsertToServerStr() : "TicketCode = ?",
//       TransId == null
//           ? DataSync.getInsertToServerList()
//           : [
//               TransId,
//             ]);
//   if (TransId != null) {
//     list[0].ID = 0;
//     var res = await http.post(Uri.parse(prefix + "SUISU1/Add"),
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
//             .post(Uri.parse(prefix + "SUISU1/Add"),
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
//             var x = await db.update("SUISU1", map,
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
// Future<void> updateSUISU1OnServer(BuildContext? context,
//     {String? condition, List? l}) async {
//   List<SUISU1> list = await retrieveSUISU1ById(
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
//           .put(Uri.parse(prefix + 'SUISU1/Update'),
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
//           var x = await db.update("SUISU1", map,
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
