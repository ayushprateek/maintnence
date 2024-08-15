import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

class MNCLD2 {
  int? ID;
  String? TransId;
  int? RowId;
  String? Attachment;
  String? Remarks;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  bool insertedIntoDatabase;
  bool? hasCreated;
  bool? hasUpdated;

  MNCLD2({
    this.ID,
    this.TransId,
    this.RowId,
    this.Attachment,
    this.Remarks,
    this.CreateDate,
    this.UpdateDate,
    this.insertedIntoDatabase = true,
    this.hasCreated,
    this.hasUpdated,
  });

  factory MNCLD2.fromJson(Map<String, dynamic> json) => MNCLD2(
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        TransId: json['TransId']?.toString() ?? '',
        RowId: int.tryParse(json['RowId'].toString()) ?? 0,
        Attachment: json['Attachment']?.toString() ?? '',
        Remarks: json['Remarks']?.toString() ?? '',
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
        'TransId': TransId,
        'RowId': RowId,
        'Attachment': Attachment,
        'Remarks': Remarks,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'has_created': hasCreated,
        'has_updated': hasUpdated,
      };
}

List<MNCLD2> mNCLD2FromJson(String str) =>
    List<MNCLD2>.from(json.decode(str).map((x) => MNCLD2.fromJson(x)));

String mNCLD2ToJson(List<MNCLD2> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<MNCLD2>> dataSyncMNCLD2() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "MNCLD2" + postfix));
  print(res.body);
  return mNCLD2FromJson(res.body);
}

Future<void> insertMNCLD2(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteMNCLD2(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncMNCLD2();
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
      for (MNCLD2 record in batchRecords) {
        try {
          batch.insert('MNCLD2_Temp', record.toJson());
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
			select * from MNCLD2_Temp
			except
			select * from MNCLD2
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
          batch.update("MNCLD2", element,
              where:
                  "TransId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
              whereArgs: [element["TransId"], 1, 1]);
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
  print('Time taken for MNCLD2 update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from MNCLD2_Temp where TransId not in (Select TransId from MNCLD2)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM MNCLD2_Temp T0
LEFT JOIN MNCLD2 T1 ON T0.TransId = T1.TransId 
WHERE T1.TransId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('MNCLD2', record);
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
      'Time taken for MNCLD2_Temp and MNCLD2 compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('MNCLD2_Temp');
}

Future<List<MNCLD2>> retrieveMNCLD2(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('MNCLD2');
  return queryResult.map((e) => MNCLD2.fromJson(e)).toList();
}

Future<void> updateMNCLD2(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('MNCLD2', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deleteMNCLD2(Database db) async {
  await db.delete('MNCLD2');
}

Future<List<MNCLD2>> retrieveMNCLD2ById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('MNCLD2', where: str, whereArgs: l);
  return queryResult.map((e) => MNCLD2.fromJson(e)).toList();
}

Future<String> insertMNCLD2ToServer(BuildContext? context,
    {String? TransId, int? id}) async {
  String response = "";
  List<MNCLD2> list = await retrieveMNCLD2ById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "TransId = ? AND ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "MNCLD2/Add"),
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
            .post(Uri.parse(prefix + "MNCLD2/Add"),
                headers: header, body: jsonEncode(map))
            .timeout(Duration(seconds: 30), onTimeout: () {
          return http.Response('Error', 500);
        });
        response = await res.body;
        print("eeaaae status");
        print(await res.statusCode);
        if (res.statusCode == 409) {
          ///Already added in server
          final Database db = await initializeDB(context);
          MNCLD2 model = MNCLD2.fromJson(jsonDecode(res.body));
          map["ID"] = model.ID;
          map["has_created"] = 0;
          var x = await db.update("MNCLD2", map,
              where: "TransId = ? AND RowId = ?",
              whereArgs: [model.TransId, model.RowId]);
          print(x.toString());
        } else if (res.statusCode == 201 || res.statusCode == 500) {
          sentSuccessInServer = true;
          if (res.statusCode == 201) {
            map['ID'] = jsonDecode(res.body)['ID'];
            final Database db = await initializeDB(context);
            // map=jsonDecode(res.body);
            map["has_created"] = 0;
            var x = await db.update("MNCLD2", map,
                where: "TransId = ? AND RowId = ?",
                whereArgs: [map["TransId"], map["RowId"]]);
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
  return response;
}

Future<void> updateMNCLD2OnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<MNCLD2> list = await retrieveMNCLD2ById(
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
          .put(Uri.parse(prefix + 'MNCLD2/Update'),
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
          var x = await db.update("MNCLD2", map,
              where: "TransId = ? AND RowId = ?",
              whereArgs: [map["TransId"], map["RowId"]]);
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
