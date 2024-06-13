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

class LITPL_OADM {
  int? ID;
  String? Name;
  String? TableName;
  String? UserName;
  String? CreatedBy;
  String? FormGroupCode;
  String? FormGroupName;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  bool? Active;
  String? UpdatedBy;

  LITPL_OADM({
    this.ID,
    this.Name,
    this.TableName,
    this.UserName,
    this.CreatedBy,
    this.CreateDate,
    this.UpdateDate,
    this.Active,
    this.UpdatedBy,
    this.FormGroupCode,
    this.FormGroupName,
  });

  factory LITPL_OADM.fromJson(Map<String, dynamic> json) => LITPL_OADM(
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        Name: json['Name'] ?? '',
        TableName: json['TableName'] ?? '',
        UserName: json['UserName'] ?? '',
        CreatedBy: json['CreatedBy'] ?? '',
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()),
        Active: json['Active'] is bool ? json['Active'] : json['Active'] == 1,
        UpdatedBy: json['UpdatedBy'] ?? '',
        FormGroupCode: json['FormGroupCode'] ?? '',
        FormGroupName: json['FormGroupName'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'ID': ID,
        'Name': Name,
        'UserName': UserName,
        'TableName': TableName,
        'CreatedBy': CreatedBy,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'Active': Active == true ? 1 : 0,
        'UpdatedBy': UpdatedBy,
        'FormGroupCode': FormGroupCode,
        'FormGroupName': FormGroupName,
      };
}

List<LITPL_OADM> lITPL_OADMFromJson(String str) =>
    List<LITPL_OADM>.from(json.decode(str).map((x) => LITPL_OADM.fromJson(x)));

String lITPL_OADMToJson(List<LITPL_OADM> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<LITPL_OADM>> dataSyncLITPL_OADM() async {
  var res = await http.get(
      headers: header, Uri.parse(prefix + "LITPL_OADM" + postfix));
  print(res.body);
  return lITPL_OADMFromJson(res.body);
}

// Future<void> insertLITPL_OADM(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteLITPL_OADM(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncLITPL_OADM();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('LITPL_OADM_Temp', customer.toJson());
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
//       "SELECT * FROM  LITPL_OADM_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("LITPL_OADM", element,
//         where: "ID = ? AND TableName = ?",
//         whereArgs: [element["ID"], element["ID"]]);
//   });
//   await batch2.commit(noResult: true);
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from LITPL_OADM_Temp where ID || TableName not in (Select ID || TableName from LITPL_OADM)");
//   v.forEach((element) {
//     batch3.insert('LITPL_OADM', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('LITPL_OADM_Temp');
// }
Future<void> insertLITPL_OADM(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteLITPL_OADM(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncLITPL_OADM();
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
      for (LITPL_OADM record in batchRecords) {
        try {
          batch.insert('LITPL_OADM_Temp', record.toJson());
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
			select * from LITPL_OADM_Temp
			except
			select * from LITPL_OADM
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
          batch.update("LITPL_OADM", element,
              where: "ID = ? AND TableName = ?",
              whereArgs: [element["ID"], element["ID"]]);
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
  print('Time taken for LITPL_OADM update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from LITPL_OADM_Temp where ID || TableName not in (Select ID || TableName from LITPL_OADM)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM LITPL_OADM_Temp T0
LEFT JOIN LITPL_OADM T1 ON T0.ID = T1.ID AND T0.TableName = T1.TableName
WHERE T1.ID IS NULL AND T1.TableName IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('LITPL_OADM', record);
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
      'Time taken for LITPL_OADM_Temp and LITPL_OADM compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('LITPL_OADM_Temp');
  // stopwatch.stop();
}

Future<List<LITPL_OADM>> retrieveLITPL_OADM(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('LITPL_OADM');
  return queryResult.map((e) => LITPL_OADM.fromJson(e)).toList();
}

Future<List<LITPL_OADM>> retrieveAllDocList() async {
  final Database db = await initializeDB(null);
  String query = '''
  SELECT * FROM LITPL_OADM 
WHERE TableName in ('OECP','OCSH','OEXR','ORCT','OQUT','ORDR','ODSC','ODLN','OINV','OCRT','ODPT','OACT','CVOCVP','OSTK')
  ''';
  final List<Map<String, Object?>> queryResult = await db.rawQuery(query);
  return queryResult.map((e) => LITPL_OADM.fromJson(e)).toList();
}

Future<void> updateLITPL_OADM(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('LITPL_OADM', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deleteLITPL_OADM(Database db) async {
  await db.delete('LITPL_OADM');
}

Future<List<LITPL_OADM>> retrieveLITPL_OADMById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('LITPL_OADM', where: str, whereArgs: l);
  return queryResult.map((e) => LITPL_OADM.fromJson(e)).toList();
}

Future<void> insertLITPL_OADMToServer(BuildContext? context,
    {String? TransId, int? id}) async {
  String response = "";
  List<LITPL_OADM> list = await retrieveLITPL_OADMById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "TableName = ? AND ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "LITPL_OADM/Add"),
        headers: header, body: jsonEncode(list[0].toJson()));
    response = res.body;
  } else if (list.isNotEmpty) {
    int i = 0;
    bool sentSuccessInServer = false;
    if (list.isEmpty) {
      return;
    }
    do {
      Map<String, dynamic> map = list[i].toJson();
      sentSuccessInServer = false;
      try {
        map.remove('ID');
        var res = await http
            .post(Uri.parse(prefix + "LITPL_OADM/Add"),
                headers: header, body: jsonEncode(map))
            .timeout(Duration(seconds: 30), onTimeout: () {
          writeToLogFile(
              text: '500 error \nMap : $map',
              fileName: StackTrace.current.toString(),
              lineNo: 141);
          return http.Response('Error', 500);
        });
        response = await res.body;
        print("eeaaae status");
        print(await res.statusCode);
        if (res.statusCode != 201) {
          await writeToLogFile(
              text:
                  '${res.statusCode} error \nMap : $map\nResponse : ${res.body}',
              fileName: StackTrace.current.toString(),
              lineNo: 141);
        }
        if (res.statusCode == 201 || res.statusCode == 500) {
          sentSuccessInServer = true;
          if (res.statusCode == 201) {
            map['ID'] = jsonDecode(res.body)['ID'];
            final Database db = await initializeDB(context);
            // map = jsonDecode(res.body);
            map["has_created"] = 0;
            var x = await db.update("LITPL_OADM", map,
                where: "TransId = ? AND RowId = ?",
                whereArgs: [map["TransId"], map["RowId"]]);
            print(x.toString());
          } else {
            writeToLogFile(
                text: '500 error \nMap : $map',
                fileName: StackTrace.current.toString(),
                lineNo: 141);
          }
        }
        print(res.body);
      } catch (e) {
        writeToLogFile(
            text: '${e.toString()}\nMap : $map',
            fileName: StackTrace.current.toString(),
            lineNo: 141);
        sentSuccessInServer = true;
      }
      i++;
      print("INDEX = " + i.toString());
    } while (i < list.length && sentSuccessInServer == true);
  }
}

Future<void> updateLITPL_OADMOnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<LITPL_OADM> list = await retrieveLITPL_OADMById(
      context,
      l == null ? DataSync.getUpdateOnServerStr() : condition ?? "",
      l == null ? DataSync.getUpdateOnServerList() : l);
  print(list);
  int i = 0;
  bool sentSuccessInServer = false;
  if (list.isEmpty) {
    return;
  }
  do {
    Map<String, dynamic> map = list[i].toJson();
    sentSuccessInServer = false;
    try {
      if (list.isEmpty) {
        return;
      }
      Map<String, dynamic> map = list[i].toJson();
      var res = await http
          .put(Uri.parse(prefix + 'LITPL_OADM/Update'),
              headers: header, body: jsonEncode(map))
          .timeout(Duration(seconds: 30), onTimeout: () {
        writeToLogFile(
            text: '500 error \nMap : $map',
            fileName: StackTrace.current.toString(),
            lineNo: 141);
        return http.Response('Error', 500);
      });
      print(await res.statusCode);
      if (res.statusCode != 201) {
        await writeToLogFile(
            text:
                '${res.statusCode} error \nMap : $map\nResponse : ${res.body}',
            fileName: StackTrace.current.toString(),
            lineNo: 141);
      }
      if (res.statusCode == 201 || res.statusCode == 500) {
        sentSuccessInServer = true;
        if (res.statusCode == 201) {
          final Database db = await initializeDB(context);
          map["has_updated"] = 0;
          var x = await db.update("LITPL_OADM", map,
              where: "TableName = ? AND ID = ?",
              whereArgs: [map["TableName"], map["ID"]]);
          print(x.toString());
        } else {
          writeToLogFile(
              text: '500 error \nMap : $map',
              fileName: StackTrace.current.toString(),
              lineNo: 141);
        }
      }
      print(res.body);
    } catch (e) {
      writeToLogFile(
          text: '${e.toString()}\nMap : $map',
          fileName: StackTrace.current.toString(),
          lineNo: 141);
      sentSuccessInServer = true;
    }

    i++;
    print("INDEX = " + i.toString());
  } while (i < list.length && sentSuccessInServer == true);
}
