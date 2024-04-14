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

class LITPL_OAC1 {
  int? ACID;
  int? ID;
  String? UserCode;
  String? UserName;
  String? UpdatedBy;
  String? CreatedBy;
  DateTime? CreateDate;
  DateTime? UpdateDate;

  LITPL_OAC1({
    this.ACID,
    this.ID,
    this.UserName,
    this.UserCode,
    this.UpdatedBy,
    this.CreatedBy,
    this.UpdateDate,
    this.CreateDate,
  });

  factory LITPL_OAC1.fromJson(Map<String, dynamic> json) =>
      LITPL_OAC1(
        ACID: int.tryParse(json['ACID'].toString()) ?? 0,
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        UserName: json['UserName'] ?? '',
        UserCode: json['UserCode'] ?? '',
        UpdatedBy: json['UpdatedBy'] ?? '',
        CreatedBy: json['CreatedBy'] ?? '',
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()),
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()),
      );

  Map<String, dynamic> toJson() =>
      {
        'ACID': ACID,
        'ID': ID,
        'UserName': UserName,
        'UpdatedBy': UpdatedBy,
        'UserCode': UserCode,
        'CreatedBy': CreatedBy,
        'UpdateDate': UpdateDate?.toIso8601String(),
        'CreateDate': CreateDate?.toIso8601String(),
      };
}

List<LITPL_OAC1> lITPL_OAC1FromJson(String str) =>
    List<LITPL_OAC1>.from(json.decode(str).map((x) => LITPL_OAC1.fromJson(x)));

String lITPL_OAC1ToJson(List<LITPL_OAC1> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<LITPL_OAC1>> dataSyncLITPL_OAC1() async {
  var res = await http.get(
      headers: header, Uri.parse(prefix + "LITPL_OAC1" + postfix));
  print(res.body);
  return lITPL_OAC1FromJson(res.body);
}

// Future<void> insertLITPL_OAC1(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteLITPL_OAC1(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncLITPL_OAC1();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('LITPL_OAC1_Temp', customer.toJson());
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
//       "SELECT * FROM  LITPL_OAC1_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("LITPL_OAC1", element,
//         where: "ID = ?", whereArgs: [element["ID"]]);
//   });
//   await batch2.commit(noResult: true);
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from LITPL_OAC1_Temp where ID not in (Select ID from LITPL_OAC1)");
//   v.forEach((element) {
//     batch3.insert('LITPL_OAC1', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('LITPL_OAC1_Temp');
// }
Future<void> insertLITPL_OAC1(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteLITPL_OAC1(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncLITPL_OAC1();
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
      for (LITPL_OAC1 record in batchRecords) {
        try {
          batch.insert('LITPL_OAC1_Temp', record.toJson());
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
			select * from LITPL_OAC1_Temp
			except
			select * from LITPL_OAC1
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
          batch.update("LITPL_OAC1", element,
              where: "ID = ?", whereArgs: [element["ID"]]);

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
  print('Time taken for LITPL_OAC1 update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from LITPL_OAC1_Temp where ID not in (Select ID from LITPL_OAC1)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM LITPL_OAC1_Temp T0
LEFT JOIN LITPL_OAC1 T1 ON T0.ID = T1.ID 
WHERE T1.ID IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('LITPL_OAC1', record);
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
      'Time taken for LITPL_OAC1_Temp and LITPL_OAC1 compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('LITPL_OAC1_Temp');
  // stopwatch.stop();
}

Future<List<LITPL_OAC1>> retrieveLITPL_OAC1(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('LITPL_OAC1');
  return queryResult.map((e) => LITPL_OAC1.fromJson(e)).toList();
}

Future<void> updateLITPL_OAC1(int id, Map<String, dynamic> values,
    BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('LITPL_OAC1', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deleteLITPL_OAC1(Database db) async {
  await db.delete('LITPL_OAC1');
}

Future<List<LITPL_OAC1>> retrieveLITPL_OAC1ById(BuildContext? context,
    String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
  await db.query('LITPL_OAC1', where: str, whereArgs: l);
  return queryResult.map((e) => LITPL_OAC1.fromJson(e)).toList();
}

Future<void> insertLITPL_OAC1ToServer(BuildContext? context,
    {String? TransId, int? id}) async {
  String response = "";
  List<LITPL_OAC1> list = await retrieveLITPL_OAC1ById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "TransId = ? AND ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "LITPL_OAC1/Add"),
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
            .post(Uri.parse(prefix + "LITPL_OAC1/Add"),
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
            var x = await db.update("LITPL_OAC1", map,
                where: "TransId = ? AND RowId = ?",
                whereArgs: [map["TransId"], map["RowId"]]);
            print(x.toString());
          }else{
            writeToLogFile(
                text: '500 error \nMap : $map',
                fileName: StackTrace.current.toString(),
                lineNo: 141);
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

}

Future<void> updateLITPL_OAC1OnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<LITPL_OAC1> list = await retrieveLITPL_OAC1ById(
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
          .put(Uri.parse(prefix + 'LITPL_OAC1/Update'),
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
          var x = await db.update("LITPL_OAC1", map,
              where: "TransId = ? AND RowId = ?",
              whereArgs: [map["TransId"], map["RowId"]]);
          print(x.toString());
        }else{
          writeToLogFile(
              text: '500 error \nMap : $map',
              fileName: StackTrace.current.toString(),
              lineNo: 141);
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
