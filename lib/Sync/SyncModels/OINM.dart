import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:sqflite/sqlite_api.dart';

class OINM {
  int? ID;
  String? BaseTransId;
  String? BaseObjectCode;
  int? BaseID;
  int? BaseRowId;
  String? ItemCode;
  String? ItemName;
  String? WhsCode;
  double? InQty;
  double? OutQty;
  double? Price;
  double? MSP;
  String? ManagedBy;
  int? OIBTID;
  int? OSRIID;
  String? CreatedBy;
  String? BranchId;
  String? UpdatedBy;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  String? Currency;
  int? hasCreated;
  int? hasUpdated;

  OINM({
    this.ID,
    this.BaseTransId,
    this.BaseObjectCode,
    this.BaseID,
    this.BaseRowId,
    this.ItemCode,
    this.ItemName,
    this.WhsCode,
    this.InQty,
    this.OutQty,
    this.Price,
    this.MSP,
    this.ManagedBy,
    this.OIBTID,
    this.OSRIID,
    this.CreatedBy,
    this.BranchId,
    this.UpdatedBy,
    this.CreateDate,
    this.UpdateDate,
    this.Currency,
    this.hasCreated,
    this.hasUpdated,
  });

  factory OINM.fromJson(Map<String, dynamic> json) => OINM(
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        BaseTransId: json['BaseTransId'],
        BaseObjectCode: json['BaseObjectCode'],
        BaseID: int.tryParse(json['BaseID'].toString()) ?? 0,
        BaseRowId: int.tryParse(json['BaseRowId'].toString()) ?? 0,
        ItemCode: json['ItemCode'],
        ItemName: json['ItemName'],
        WhsCode: json['WhsCode'],
        InQty: double.tryParse(json['InQty'].toString()) ?? 0.0,
        OutQty: double.tryParse(json['OutQty'].toString()) ?? 0.0,
        Price: double.tryParse(json['Price'].toString()) ?? 0.0,
        MSP: double.tryParse(json['MSP'].toString()) ?? 0.0,
        ManagedBy: json['ManagedBy'],
        OIBTID: int.tryParse(json['OIBTID'].toString()) ?? 0,
        OSRIID: int.tryParse(json['OSRIID'].toString()) ?? 0,
        CreatedBy: json['CreatedBy'],
        BranchId: json['BranchId'],
        UpdatedBy: json['UpdatedBy'],
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()),
        Currency: json['Currency'],
        hasCreated: int.tryParse(json['has_created'].toString()) ?? 0,
        hasUpdated: int.tryParse(json['has_updated'].toString()) ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'ID': ID,
        'BaseTransId': BaseTransId,
        'BaseObjectCode': BaseObjectCode,
        'BaseID': BaseID,
        'BaseRowId': BaseRowId,
        'ItemCode': ItemCode,
        'ItemName': ItemName,
        'WhsCode': WhsCode,
        'InQty': InQty,
        'OutQty': OutQty,
        'Price': Price,
        'MSP': MSP,
        'ManagedBy': ManagedBy,
        'OIBTID': OIBTID,
        'OSRIID': OSRIID,
        'CreatedBy': CreatedBy,
        'BranchId': BranchId,
        'UpdatedBy': UpdatedBy,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'Currency': Currency,
        'has_created': hasCreated,
        'has_updated': hasUpdated,
      };
}

List<OINM> oINMFromJson(String str) =>
    List<OINM>.from(json.decode(str).map((x) => OINM.fromJson(x)));

String oINMToJson(List<OINM> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<OINM>> dataSyncOINM() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "OINM" + postfix));
  print(res.body);
  return oINMFromJson(res.body);
}

Future<void> insertOINM(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteOINM(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncOINM();
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
      for (OINM record in batchRecords) {
        try {
          batch.insert('OINM_Temp', record.toJson());
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
			select * from OINM_Temp
			except
			select * from OINM
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
          batch.update("OINM", element,
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
  print('Time taken for OINM update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  var v = await db.rawQuery('''
    SELECT T0.*
FROM OINM_Temp T0
LEFT JOIN OINM T1 ON T0.ID = T1.ID 
WHERE T1.ID IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('OINM', record);
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
      'Time taken for OINM_Temp and OINM compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('OINM_Temp');
}

Future<List<OINM>> retrieveOINM(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('OINM');
  return queryResult.map((e) => OINM.fromJson(e)).toList();
}

Future<void> updateOINM(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('OINM', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deleteOINM(Database db) async {
  await db.delete('OINM');
}

Future<List<OINM>> retrieveOINMById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('OINM', where: str, whereArgs: l);
  return queryResult.map((e) => OINM.fromJson(e)).toList();
}
//
// Future<String> insertOINMToServer(BuildContext? context,
//     {String? TransId, int? id})
// async {
//   String response = "";
//   List<OINM> list = await retrieveOINMById(
//       context,
//       TransId == null
//           ? DataSync.getInsertToServerStr()
//           : "TransId = ? AND ID = ?",
//       TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
//   if (TransId != null) {
//     list[0].ID = 0;
//     var res = await http.post(Uri.parse(prefix + "OINM/Add"),
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
//             .post(Uri.parse(prefix + "OINM/Add"),
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
//             map = jsonDecode(res.body);
//             map["has_created"] = 0;
//             var x = await db.update("OINM", map,
//                 where: "TransId = ? AND RowId = ?",
//                 whereArgs: [map["TransId"], map["RowId"]]);
//             print(x.toString());
//           }
//         }
//         print(res.body);
//       } catch (e) {
//         print("Timeout " + e.toString());
//         sentSuccessInServer = true;
//       }
//       print('i++;');
//       print("INDEX = " + i.toString());
//     } while (i < list.length && sentSuccessInServer == true);
//   }
//   return response;
// }
//
// Future<void> updateOINMOnServer(BuildContext? context,
//     {String? condition, List? l})
// async {
//   List<OINM> list = await retrieveOINMById(
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
//           .put(Uri.parse(prefix + 'OINM/Update'),
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
//           var x = await db.update("OINM", map,
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
