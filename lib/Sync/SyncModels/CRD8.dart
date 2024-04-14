import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

class CRD8Model {
  String? Code;
  String? BPLID;
  String? BranchName;
  bool? hasCreated;
  bool? hasUpdated;

  CRD8Model({
    this.Code,
    this.BranchName,
    this.BPLID,
    this.hasCreated,
    this.hasUpdated,
  });

  factory CRD8Model.fromJson(Map<String, dynamic> json) => CRD8Model(
        Code: json['Code'] ?? '',
        BranchName: json['BranchName'] ?? '',
        BPLID: json['BPLID'] ?? '',
        hasCreated: json["has_created"] is bool
            ? json["has_created"]
            : json["has_created"] == 1,
        hasUpdated: json["has_updated"] is bool
            ? json["has_updated"]
            : json["has_updated"] == 1,
      );

  Map<String, dynamic> toJson() => {
        'Code': Code,
        'BranchName': BranchName,
        'BPLID': BPLID,
        'has_created': hasCreated == true ? 1 : 0,
        'has_updated': hasUpdated == true ? 1 : 0,
      };
}

List<CRD8Model> temp_CRD8FromJson(String str) =>
    List<CRD8Model>.from(json.decode(str).map((x) => CRD8Model.fromJson(x)));

String temp_CRD8ToJson(List<CRD8Model> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<CRD8Model>> dataSyncCRD8Model() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "CRD8" + postfix));
  print(res.body);
  return temp_CRD8FromJson(res.body);
}

Future<void> insertCRD8(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteCRD8Model(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncCRD8Model();
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
      for (CRD8Model record in batchRecords) {
        try {
          batch.insert('CRD8_Temp', record.toJson());
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
			select * from CRD8_Temp
			except
			select * from CRD8
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
          batch.update("CRD8", element,
              where:
                  "Code = ? AND BPLId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
              whereArgs: [element["Code"], element["BPLId"], 1, 1]);
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
  print('Time taken for CRD8 update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from CRD8_Temp where Code || BPLId not in (Select Code || BPLId from CRD8)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM CRD8_Temp T0
LEFT JOIN CRD8 T1 ON T0.Code = T1.Code AND T0.BPLId = T1.BPLId
WHERE T1.Code IS NULL AND T1.BPLId IS NULL;
''');

  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('CRD8', record);
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
      'Time taken for CRD8_Temp and CRD8 compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('CRD8_Temp');
  // stopwatch.stop();
}

Future<List<CRD8Model>> retrieveCRD8Model(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('CRD8');
  return queryResult.map((e) => CRD8Model.fromJson(e)).toList();
}

Future<void> updateCRD8Model(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('CRD8', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deleteCRD8Model(Database db) async {
  await db.delete('CRD8');
}

Future<List<CRD8Model>> retrieveCRD8ById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('CRD8', where: str, whereArgs: l);
  return queryResult.map((e) => CRD8Model.fromJson(e)).toList();
}
Future<void> insertCRD8ToServer(BuildContext? context,
    {String? TransId, int? id}) async {
  String response = "";
  List<CRD8Model> list = await retrieveCRD8ById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "TransId = ? AND ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);

  if (TransId != null) {
    //only single entry

    var res = await http.post(Uri.parse(prefix + "CRD8/Add"),
        headers: header, body: jsonEncode(list[0].toJson()));
    response = res.body;
  } else if (list.isNotEmpty) {
    //asxkncuievbuefvbeivuehveubvbeuivuibervuierbvueir
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
        String queryParams='Code=${list[i].Code}';
        var res = await http
            .post(Uri.parse(prefix + "CRD8/Add?$queryParams"),
            headers: header, body: jsonEncode(map))
            .timeout(Duration(seconds: 30), onTimeout: () {
          writeToLogFile(
              text: '500 error \nMap : $map', fileName: StackTrace.current.toString(), lineNo: 141);return http.Response('Error', 500);
        });
        response = await res.body;

        print("status");
        print(await res.statusCode);
        if(res.statusCode != 201)
        {
          await writeToLogFile(
              text: '${res.statusCode} error \nMap : $map\nResponse : ${res.body}',
              fileName: StackTrace.current.toString(),
              lineNo: 141);
        }
        if(res.statusCode ==409)
        {
          ///Already added in server
          final Database db = await initializeDB(context);
          CRD8Model model=CRD8Model.fromJson(jsonDecode(res.body));
          var x = await db.update("CRD8", model.toJson(),
              where: "Code = ? AND BPLID = ?", whereArgs: [model.Code,model.BPLID]);
          print(x.toString());
        }
        else
        if (res.statusCode == 201 || res.statusCode == 500) {
          sentSuccessInServer = true;
          if (res.statusCode == 201) {
            map['ID'] = jsonDecode(res.body)['ID'];
            final Database db = await initializeDB(context);
            map["has_created"] = 0;
            var x = await db.update("CRD8", map,
                where: "Code = ? AND RowId = ?",
                whereArgs: [map["Code"], map["RowId"]]);
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

Future<void> updateCRD8OnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<CRD8Model> list = await retrieveCRD8ById(
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
          .put(Uri.parse(prefix + 'CRD8/Update'),
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
          var x = await db.update("CRD8", map,
              where: "Code = ? AND RowId = ?",
              whereArgs: [map["Code"], map["RowId"]]);
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
          text: '${e.toString()}\nMap : $map',
          fileName: StackTrace.current.toString(),
          lineNo: 141);
      sentSuccessInServer = true;
    }

    i++;
    print("INDEX = " + i.toString());
  } while (i < list.length && sentSuccessInServer == true);
}
