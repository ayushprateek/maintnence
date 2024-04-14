import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

class CVMTP1 {
  int? ID;
  String? Code;
  int? RowId;
  String? SubMeetingCode;
  String? SubMeetingName;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  bool? Active;

  CVMTP1({
    this.ID,
    this.Code,
    this.RowId,
    this.SubMeetingCode,
    this.SubMeetingName,
    this.CreateDate,
    this.UpdateDate,
    this.Active,
  });

  factory CVMTP1.fromJson(Map<String, dynamic> json) => CVMTP1(
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        Code: json['Code'],
        RowId: int.tryParse(json['RowId'].toString()) ?? 0,
        SubMeetingCode: json['SubMeetingCode'],
        SubMeetingName: json['SubMeetingName'],
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()),
        Active: json['Active'] is bool ? json['Active'] : json['Active'] == 1,
      );

  Map<String, dynamic> toJson() => {
        'ID': ID,
        'Code': Code,
        'RowId': RowId,
        'SubMeetingCode': SubMeetingCode,
        'SubMeetingName': SubMeetingName,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'Active': Active,
      };
}

Future<List<CVMTP1>> retrieveCVMTP1ForSearch(
    {required query, required String Code}) async {
  final Database db = await initializeDB(null);
  String qq='''
      SELECT * FROM CVMTP1 where (SubMeetingCode LIKE '%$query%' COLLATE NOCASE
or SubMeetingName LIKE '%$query%' COLLATE NOCASE) AND Code='$Code' AND Active=1 
      ''';
  final List<Map<String, Object?>> queryResult = await db.rawQuery(qq);
  return queryResult.map((e) => CVMTP1.fromJson(e)).toList();
}

List<CVMTP1> cVMTP1FromJson(String str) =>
    List<CVMTP1>.from(json.decode(str).map((x) => CVMTP1.fromJson(x)));

String cVMTP1ToJson(List<CVMTP1> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<CVMTP1>> dataSyncCVMTP1() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "CVMTP1" + postfix));
  print(res.body);
  return cVMTP1FromJson(res.body);
}

Future<void> insertCVMTP1(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteCVMTP1(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncCVMTP1();
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
      for (CVMTP1 record in batchRecords) {
        try {
          batch.insert('CVMTP1_Temp', record.toJson());
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
			select * from CVMTP1_Temp
			except
			select * from CVMTP1
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
          batch.update("CVMTP1", element,
              where:
                  "Code = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
              whereArgs: [element["Code"], 1, 1]);
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
  print('Time taken for CVMTP1 update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from CVMTP1_Temp where Code not in (Select Code || ID from CVMTP1)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM CVMTP1_Temp T0
LEFT JOIN CVMTP1 T1 ON T0.Code = T1.Code 
WHERE T1.Code IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('CVMTP1', record);
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
      'Time taken for CVMTP1_Temp and CVMTP1 compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('CVMTP1_Temp');
  // stopwatch.stop();
}

Future<List<CVMTP1>> retrieveCVMTP1(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('CVMTP1');
  return queryResult.map((e) => CVMTP1.fromJson(e)).toList();
}

Future<void> updateCVMTP1(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('CVMTP1', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deleteCVMTP1(Database db) async {
  await db.delete('CVMTP1');
}

Future<List<CVMTP1>> retrieveCVMTP1ById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('CVMTP1', where: str, whereArgs: l);
  return queryResult.map((e) => CVMTP1.fromJson(e)).toList();
}

Future<String> insertCVMTP1ToServer(BuildContext? context,
    {String? TransId, int? id}) async {
  String response = "";
  List<CVMTP1> list = await retrieveCVMTP1ById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "TransId = ? AND ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "CVMTP1/Add"),
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
        String queryParams='Code=${list[i].Code}&RowId=${list[i].RowId}';
        var res = await http.post(Uri.parse(prefix + "CVMTP1/Add?$queryParams"),
                headers: header, body: jsonEncode(map))
            .timeout(Duration(seconds: 30), onTimeout: () {
          return http.Response('Error', 500);
        });
        response = await res.body;
        print("eeaaae status");
        print(await res.statusCode);
        if(res.statusCode ==409)
        {
          ///Already added in server
          final Database db = await initializeDB(context);
          CVMTP1 model=CVMTP1.fromJson(jsonDecode(res.body));
          var x = await db.update("CVMTP1", model.toJson(),
              where: "Code = ? AND RowId = ?", whereArgs: [model.Code,model.RowId]);
          print(x.toString());
        }
        else
        if (res.statusCode == 201 || res.statusCode == 500) {
          sentSuccessInServer = true;
          if (res.statusCode == 201) {
            map['ID'] = jsonDecode(res.body)['ID'];
            final Database db = await initializeDB(context);
            map = jsonDecode(res.body);
            map["has_created"] = 0;
            var x = await db.update("CVMTP1", map,
                where: "ID = ? AND RowId = ?",
                whereArgs: [map["ID"], map["RowId"]]);
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

Future<void> updateCVMTP1OnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<CVMTP1> list = await retrieveCVMTP1ById(
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
          .put(Uri.parse(prefix + 'CVMTP1/Update'),
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
          var x = await db.update("CVMTP1", map,
              where: "ID = ? AND RowId = ?",
              whereArgs: [map["ID"], map["RowId"]]);
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
