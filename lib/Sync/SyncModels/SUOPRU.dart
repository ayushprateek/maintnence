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

class SUOPRU {
  int? ID;
  String? ProjectCode;
  String? Code;
  bool? Active;
  String? CreatedBy;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  String? UpdatedBy;
  String? BranchId;
  bool? hasCreated;
  bool? hasUpdated;

  SUOPRU({
    this.ID,
    this.ProjectCode,
    this.Code,
    this.Active,
    this.CreatedBy,
    this.CreateDate,
    this.UpdateDate,
    this.UpdatedBy,
    this.BranchId,
    this.hasCreated,
    this.hasUpdated,
  });

  factory SUOPRU.fromJson(Map<String, dynamic> json) =>
      SUOPRU(
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        ProjectCode: json['ProjectCode'],
        Code: json['Code'],
        Active: json['Active'] is bool ? json['Active'] : json['Active'] == 1,
        CreatedBy: json['CreatedBy'],
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()),
        UpdatedBy: json['UpdatedBy'],
        BranchId: json['BranchId'],
        hasCreated: json['has_created'] is bool
            ? json['has_created']
            : json['has_created'] == 1,
        hasUpdated: json['has_updated'] is bool
            ? json['has_updated']
            : json['has_updated'] == 1,
      );

  Map<String, dynamic> toJson() =>
      {
        'ID': ID,
        'ProjectCode': ProjectCode,
        'Code': Code,
        'Active': Active,
        'CreatedBy': CreatedBy,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'UpdatedBy': UpdatedBy,
        'BranchId': BranchId,
        'has_created': hasCreated,
        'has_updated': hasUpdated,
      };
}

List<SUOPRU> sUOPRUFromJson(String str) =>
    List<SUOPRU>.from(json.decode(str).map((x) => SUOPRU.fromJson(x)));

String sUOPRUToJson(List<SUOPRU> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<SUOPRU>> dataSyncSUOPRU() async {
  var res =
  await http.get(headers: header, Uri.parse(prefix + "SUOPRU" + postfix));
  print(res.body);
  return sUOPRUFromJson(res.body);
}

// Future<void> insertSUOPRU(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteSUOPRU(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncSUOPRU();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('SUOPRU_Temp', customer.toJson());
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
//       "SELECT * FROM  SUOPRU_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("SUOPRU", element,
//         where: "ProjectCode = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["ProjectCode"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from SUOPRU_Temp where ProjectCode not in (Select ProjectCode from SUOPRU)");
//   v.forEach((element) {
//     batch3.insert('SUOPRU', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('SUOPRU_Temp');
// }
Future<void> insertSUOPRU(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteSUOPRU(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncSUOPRU();
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
      for (SUOPRU record in batchRecords) {
        try {
          batch.insert('SUOPRU_Temp', record.toJson());
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
			select * from SUOPRU_Temp
			except
			select * from SUOPRU
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
          batch.update("SUOPRU", element,
              where: "ProjectCode = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
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
  print('Time taken for SUOPRU update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from SUOPRU_Temp where ProjectCode not in (Select ProjectCode from SUOPRU)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM SUOPRU_Temp T0
LEFT JOIN SUOPRU T1 ON T0.ProjectCode = T1.ProjectCode 
WHERE T1.ProjectCode IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('SUOPRU', record);
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
      'Time taken for SUOPRU_Temp and SUOPRU compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('SUOPRU_Temp');
  // stopwatch.stop();
}

Future<List<SUOPRU>> retrieveSUOPRU(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('SUOPRU');
  return queryResult.map((e) => SUOPRU.fromJson(e)).toList();
}

Future<void> updateSUOPRU(int id, Map<String, dynamic> values,
    BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('SUOPRU', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deleteSUOPRU(Database db) async {
  await db.delete('SUOPRU');
}

Future<List<SUOPRU>> retrieveSUOPRUById(BuildContext? context, String str,
    List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
  await db.query('SUOPRU', where: str, whereArgs: l);
  return queryResult.map((e) => SUOPRU.fromJson(e)).toList();
}

Future<void> insertSUOPRUToServer(BuildContext? context,
    {String? TransId, int? id}) async {
  String response = "";
  List<SUOPRU> list = await retrieveSUOPRUById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "TransId = ? AND ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "SUOPRU/Add"),
        headers: header, body: jsonEncode(list[0].toJson()));
    response = res.body;
  } else if (list.isNotEmpty) {
    int i = 0;
    bool sentSuccessInServer = false;
    if (list.isEmpty) {
      return;
    }
    do {Map<String, dynamic> map = list[i].toJson();
      sentSuccessInServer = false;
      try {
        map.remove('ID');
        var res = await http
            .post(Uri.parse(prefix + "SUOPRU/Add"),
            headers: header, body: jsonEncode(map))
            .timeout(Duration(seconds: 30), onTimeout: () {
          writeToLogFile(
            text: '500 error \nMap : $map', fileName: StackTrace.current.toString(), lineNo: 141);return http.Response('Error', 500);
        });
        response = await res.body;
        print("eeaaae status");
        print(await res.statusCode);
        if(res.statusCode != 201)
        {
          await writeToLogFile(
              text: '${res.statusCode} error \nMap : $map\nResponse : ${res.body}',
              fileName: StackTrace.current.toString(),
              lineNo: 141);
        }
        if (res.statusCode == 201 || res.statusCode == 500) {
          sentSuccessInServer = true;
          if (res.statusCode == 201) {
            map['ID'] = jsonDecode(res.body)['ID'];
            final Database db = await initializeDB(context);
            map = jsonDecode(res.body);
            map["has_created"] = 0;
            var x = await db.update("SUOPRU", map,
                where: "ProjectCode = ?", whereArgs: [map["ProjectCode"]]);
            print(x.toString());
          }
        }
        print(res.body);
      } catch (e) {
        writeToLogFile(
            text: '${e.toString()}\nMap : $map', fileName: StackTrace.current.toString(), lineNo: 141);
  sentSuccessInServer = true;
  }
  print('i++;');
  print("INDEX = " + i.toString());
  } while (i < list.length && sentSuccessInServer ==
  true
  );
}

}

Future<void> updateSUOPRUOnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<SUOPRU> list = await retrieveSUOPRUById(
      context,
      l == null ? DataSync.getUpdateOnServerStr() : condition ?? "",
      l == null ? DataSync.getUpdateOnServerList() : l);
  print(list);
  int i = 0;
  bool sentSuccessInServer = false;
  if (list.isEmpty) {
    return;
  }
  do {Map<String, dynamic> map = list[i].toJson();
    sentSuccessInServer = false;
    try {
      if (list.isEmpty) {
        return;
      }
      Map<String, dynamic> map = list[i].toJson();
      var res = await http
          .put(Uri.parse(prefix + 'SUOPRU/Update'),
          headers: header, body: jsonEncode(map))
          .timeout(Duration(seconds: 30), onTimeout: () {
        writeToLogFile(
            text: '500 error \nMap : $map', fileName: StackTrace.current.toString(), lineNo: 141);return http.Response('Error', 500);
      });
      print(await res.statusCode);
      if(res.statusCode != 201)
        {
          await writeToLogFile(
              text: '${res.statusCode} error \nMap : $map\nResponse : ${res.body}',
              fileName: StackTrace.current.toString(),
              lineNo: 141);
        }
        if (res.statusCode == 201 || res.statusCode == 500) {
        sentSuccessInServer = true;
        if (res.statusCode == 201) {
          final Database db = await initializeDB(context);
          map["has_updated"] = 0;
          var x = await db.update("SUOPRU", map,
              where: "ProjectCode = ?", whereArgs: [map["ProjectCode"]]);
          print(x.toString());
        }
      }
      print(res.body);
    } catch (e) {
      writeToLogFile(
          text: '${e.toString()}\nMap : $map', fileName: StackTrace.current.toString(), lineNo: 141);
  sentSuccessInServer = true;
  }

  i++;
  print("INDEX = " + i.toString());
  } while (i < list.length && sentSuccessInServer == true);
}
