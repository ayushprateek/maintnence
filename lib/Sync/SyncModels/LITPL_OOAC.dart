import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

class LITPL_OOAC {
  int? ACID;
  String? BranchId;
  int? DocID;
  String? DocName;
  bool? Add;
  bool? Cancle;
  bool? Edit;
  bool? Active;
  String? UpdatedBy;
  String? CreatedBy;
  DateTime? UpdateDate;
  DateTime? CreateDate;

  LITPL_OOAC({
    this.ACID,
    this.BranchId,
    this.DocID,
    this.DocName,
    this.Add,
    this.Cancle,
    this.Active,
    this.Edit,
    this.UpdatedBy,
    this.CreatedBy,
    this.UpdateDate,
    this.CreateDate,
  });

  factory LITPL_OOAC.fromJson(Map<String, dynamic> json) => LITPL_OOAC(
        BranchId: json['BranchId']?.toString() ?? '',
        ACID: int.tryParse(json['ACID'].toString()) ?? 0,
        DocID: int.tryParse(json['DocID'].toString()) ?? 0,
        DocName: json['DocName'] ?? '',
        Add: json['Add'] is bool ? json['Add'] : json['Add'] == 1,
        Cancle: json['Cancle'] is bool ? json['Cancle'] : json['Cancle'] == 1,
        Active: json['Active'] is bool ? json['Active'] : json['Active'] == 1,
        Edit: json['Edit'] is bool ? json['Edit'] : json['Edit'] == 1,
        UpdatedBy: json['UpdatedBy'] ?? '',
        CreatedBy: json['CreatedBy'] ?? '',
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()),
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()),
      );

  Map<String, dynamic> toJson() => {
        'BranchId': BranchId,
        'ACID': ACID,
        'DocID': DocID,
        'DocName': DocName,
        'Add': Add == true ? 1 : 0,
        'Cancle': Cancle == true ? 1 : 0,
        'Active': Active == true ? 1 : 0,
        'Edit': Edit == true ? 1 : 0,
        'UpdatedBy': UpdatedBy,
        'CreatedBy': CreatedBy,
        'UpdateDate': UpdateDate?.toIso8601String(),
        'CreateDate': CreateDate?.toIso8601String(),
      };
}

List<LITPL_OOAC> lITPL_OOACFromJson(String str) =>
    List<LITPL_OOAC>.from(json.decode(str).map((x) => LITPL_OOAC.fromJson(x)));

String lITPL_OOACToJson(List<LITPL_OOAC> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<LITPL_OOAC>> dataSyncLITPL_OOAC() async {
  var res = await http.get(
      headers: header, Uri.parse(prefix + "LITPL_OOAC" + postfix));
  print(res.body);
  return lITPL_OOACFromJson(res.body);
}

// Future<void> insertLITPL_OOAC(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteLITPL_OOAC(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncLITPL_OOAC();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('LITPL_OOAC_Temp', customer.toJson());
//     } catch (e) {
//       writeToLogFile(
//           text: e.toString(),
//           fileName: StackTrace.current.toString(),
//           lineNo: 141);
//       getErrorSnackBar('Sync Error ' + e.toString());
//     }
//   });
//   await batch1.commit(noResult: true);
//   var u = await db.rawQuery("SELECT * FROM  LITPL_OOAC_Temp");
//   u.forEach((element) {
//     batch2.update("LITPL_OOAC", element,
//         where: "ACID = ?", whereArgs: [element["ACID"]]);
//   });
//   await batch2.commit(noResult: true);
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from LITPL_OOAC_Temp where ACID not in (Select ACID from LITPL_OOAC)");
//   v.forEach((element) {
//     batch3.insert('LITPL_OOAC', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('LITPL_OOAC_Temp');
// }
Future<void> insertLITPL_OOAC(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteLITPL_OOAC(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncLITPL_OOAC();
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
      for (LITPL_OOAC record in batchRecords) {
        try {
          batch.insert('LITPL_OOAC_Temp', record.toJson());
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
			select * from LITPL_OOAC_Temp
			except
			select * from LITPL_OOAC
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
          batch.update("LITPL_OOAC", element,
              where: "ACID = ?", whereArgs: [element["ACID"]]);
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
  print('Time taken for LITPL_OOAC update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from LITPL_OOAC_Temp where ACID not in (Select ACID from LITPL_OOAC)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM LITPL_OOAC_Temp T0
LEFT JOIN LITPL_OOAC T1 ON T0.ACID = T1.ACID 
WHERE T1.ACID IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('LITPL_OOAC', record);
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
      'Time taken for LITPL_OOAC_Temp and LITPL_OOAC compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('LITPL_OOAC_Temp');
  // stopwatch.stop();
}

Future<List<LITPL_OOAC>> retrieveLITPL_OOAC(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('LITPL_OOAC');
  return queryResult.map((e) => LITPL_OOAC.fromJson(e)).toList();
}

Future<void> updateLITPL_OOAC(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('LITPL_OOAC', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deleteLITPL_OOAC(Database db) async {
  await db.delete('LITPL_OOAC');
}

Future<List<LITPL_OOAC>> retrieveLITPL_OOACById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('LITPL_OOAC', where: str, whereArgs: l);
  return queryResult.map((e) => LITPL_OOAC.fromJson(e)).toList();
}

// Future<void> insertLITPL_OOACToServer(BuildContext? context,
//     {String? TransId, int? id}) async {
//   String response = "";
//   List<LITPL_OOAC> list = await retrieveLITPL_OOACById(
//       context,
//       TransId == null
//           ? DataSync.getInsertToServerStr()
//           : "TransId = ? AND ID = ?",
//       TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
//   if (TransId != null) {
//     list[0].ACID = 0;
//     var res = await http.post(Uri.parse(prefix + "LITPL_OOAC/Add"),
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
//             .post(Uri.parse(prefix + "LITPL_OOAC/Add"),
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
//             // map["has_created"] = 0;
//             var x = await db.update("LITPL_OOAC", map,
//                 where: "TransId = ? AND RowId = ?",
//                 whereArgs: [map["TransId"], map["RowId"]]);
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
// Future<void> updateLITPL_OOACOnServer(BuildContext? context,
//     {String? condition, List? l}) async {
//   List<LITPL_OOAC> list = await retrieveLITPL_OOACById(
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
//           .put(Uri.parse(prefix + 'LITPL_OOAC/Update'),
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
//           // map["has_updated"] = 0;
//           var x = await db.update("LITPL_OOAC", map,
//               where: "TransId = ? AND RowId = ?",
//               whereArgs: [map["TransId"], map["RowId"]]);
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
