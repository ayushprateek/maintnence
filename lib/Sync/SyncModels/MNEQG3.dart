import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

class MNEQG3 {
  int? ID;
  String? Code;
  int? RowId;
  String? Problem;
  String? SubProblem;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  String? Section;
  String? SubSection;
  bool? hasCreated;
  bool? hasUpdated;

  MNEQG3({
    this.ID,
    this.Code,
    this.RowId,
    this.Problem,
    this.SubProblem,
    this.CreateDate,
    this.UpdateDate,
    this.Section,
    this.SubSection,
    this.hasCreated,
    this.hasUpdated,
  });

  factory MNEQG3.fromJson(Map<String, dynamic> json) => MNEQG3(
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        Code: json['Code'],
        RowId: int.tryParse(json['RowId'].toString()) ?? 0,
        Problem: json['Problem'],
        SubProblem: json['SubProblem'],
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()),
        Section: json['Section'],
        SubSection: json['SubSection'],
        hasCreated: json['has_created'] is bool
            ? json['has_created']
            : json['has_created'] == 1,
        hasUpdated: json['has_updated'] is bool
            ? json['has_updated']
            : json['has_updated'] == 1,
      );

  Map<String, dynamic> toJson() => {
        'ID': ID,
        'Code': Code,
        'RowId': RowId,
        'Problem': Problem,
        'SubProblem': SubProblem,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'Section': Section,
        'SubSection': SubSection,
        'has_created': hasCreated,
        'has_updated': hasUpdated,
      };
}

List<MNEQG3> mNEQG3FromJson(String str) =>
    List<MNEQG3>.from(json.decode(str).map((x) => MNEQG3.fromJson(x)));

String mNEQG3ToJson(List<MNEQG3> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<MNEQG3>> dataSyncMNEQG3() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "MNEQG3" + postfix));
  print(res.body);
  return mNEQG3FromJson(res.body);
}

Future<List<MNEQG3>> retrieveMNEQG3ForSearch({
  int? limit,
  String? query,
  String condition='1',
}) async {
  query = "%$query%";
  final Database db = await initializeDB(null);
  final List<Map<String, Object?>> queryResult = await db.rawQuery(
      '''
      SELECT * FROM MNEQG3 WHERE 
      (
      Code LIKE "$query" OR 
      Problem LIKE "$query" OR 
      SubProblem LIKE "$query" OR 
      Section LIKE "$query" OR 
      SubSection LIKE "$query" 
      )
      and $condition 
      LIMIT $limit
      ''');
  return queryResult.map((e) => MNEQG3.fromJson(e)).toList();
}

Future<void> insertMNEQG3(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteMNEQG3(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncMNEQG3();
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
      for (MNEQG3 record in batchRecords) {
        try {
          batch.insert('MNEQG3_Temp', record.toJson());
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
			select * from MNEQG3_Temp
			except
			select * from MNEQG3
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
          batch.update("MNEQG3", element,
              where:
                  "Code = ? AND RowId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
              whereArgs: [element["Code"], element["RowId"], 1, 1]);
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
  print('Time taken for MNEQG3 update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  var v = await db.rawQuery('''
    SELECT T0.*
      FROM MNEQG3_Temp T0
      LEFT JOIN MNEQG3 T1 ON T0.Code = T1.Code AND T0.RowId = T1.RowId
      WHERE T1.Code IS NULL AND T1.RowId IS NULL
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('MNEQG3', record);
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
      'Time taken for MNEQG3_Temp and MNEQG3 compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('MNEQG3_Temp');
}

Future<List<MNEQG3>> retrieveMNEQG3(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('MNEQG3');
  return queryResult.map((e) => MNEQG3.fromJson(e)).toList();
}

Future<void> updateMNEQG3(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('MNEQG3', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deleteMNEQG3(Database db) async {
  await db.delete('MNEQG3');
}

Future<List<MNEQG3>> retrieveMNEQG3ById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('MNEQG3', where: str, whereArgs: l);
  return queryResult.map((e) => MNEQG3.fromJson(e)).toList();
}

Future<String> insertMNEQG3ToServer(BuildContext? context,
    {String? TransId, int? id}) async {
  String response = "";
  List<MNEQG3> list = await retrieveMNEQG3ById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "TransId = ? AND ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "MNEQG3/Add"),
        headers: header, body: jsonEncode(list[0].toJson()));
    response = res.body;
  } else if (list.isNotEmpty) {
    int i = 0;
    bool sentSuccessInServer = false;
    do {
      sentSuccessInServer = false;
      try {
        Map<String, dynamic> map = list[i].toJson();
        map.remove('ID');
        var res = await http
            .post(Uri.parse(prefix + "MNEQG3/Add"),
                headers: header, body: jsonEncode(map))
            .timeout(Duration(seconds: 30), onTimeout: () {
          return http.Response('Error', 500);
        });
        response = await res.body;
        print("eeaaae status");
        print(await res.statusCode);
        if (res.statusCode == 201 || res.statusCode == 500) {
          sentSuccessInServer = true;
          if (res.statusCode == 201) {
            map['ID'] = jsonDecode(res.body)['ID'];
            final Database db = await initializeDB(context);
            map = jsonDecode(res.body);
            map["has_created"] = 0;
            var x = await db.update("MNEQG3", map,
                where: "Code = ? AND RowId = ?",
                whereArgs: [map["Code"], map["RowId"]]);
            print(x.toString());
          }
        }
        print(res.body);
      } catch (e) {
        print("Timeout " + e.toString());
        sentSuccessInServer = true;
      }
      print('i++;');
      print("INDEX = " + i.toString());
    } while (i < list.length && sentSuccessInServer == true);
  }
  return response;
}

Future<void> updateMNEQG3OnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<MNEQG3> list = await retrieveMNEQG3ById(
      context,
      l == null ? DataSync.getUpdateOnServerStr() : condition ?? "",
      l == null ? DataSync.getUpdateOnServerList() : l);
  print(list);
  int i = 0;
  bool sentSuccessInServer = false;
  do {
    sentSuccessInServer = false;
    try {
      Map<String, dynamic> map = list[i].toJson();
      var res = await http
          .put(Uri.parse(prefix + 'MNEQG3/Update'),
              headers: header, body: jsonEncode(map))
          .timeout(Duration(seconds: 30), onTimeout: () {
        return http.Response('Error', 500);
      });
      print(await res.statusCode);
      if (res.statusCode == 201 || res.statusCode == 500) {
        sentSuccessInServer = true;
        if (res.statusCode == 201) {
          final Database db = await initializeDB(context);
          map["has_updated"] = 0;
          var x = await db.update("MNEQG3", map,
              where: "Code = ? AND RowId = ?",
              whereArgs: [map["Code"], map["RowId"]]);
          print(x.toString());
        }
      }
      print(res.body);
    } catch (e) {
      print("Timeout " + e.toString());
      sentSuccessInServer = true;
    }

    i++;
    print("INDEX = " + i.toString());
  } while (i < list.length && sentSuccessInServer == true);
}
