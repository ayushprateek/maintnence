import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

class MNOWCM {
  int? ID;
  String? Code;
  String? Name;
  String? WhsCode;
  String? WhsName;
  String? CityCode;
  String? CityName;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  String? CreatedBy;
  String? UpdatedBy;
  String? BranchId;
  bool? Active;
  double? Capacity;

  MNOWCM({
    this.ID,
    this.Code,
    this.Name,
    this.WhsCode,
    this.WhsName,
    this.CityCode,
    this.CityName,
    this.CreateDate,
    this.UpdateDate,
    this.CreatedBy,
    this.UpdatedBy,
    this.BranchId,
    this.Active,
    this.Capacity,
  });

  factory MNOWCM.fromJson(Map<String, dynamic> json) => MNOWCM(
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        Code: json['Code']?.toString() ?? '',
        Name: json['Name']?.toString() ?? '',
        WhsCode: json['WhsCode']?.toString() ?? '',
        WhsName: json['WhsName']?.toString() ?? '',
        CityCode: json['CityCode']?.toString() ?? '',
        CityName: json['CityName']?.toString() ?? '',
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()),
        CreatedBy: json['CreatedBy']?.toString() ?? '',
        UpdatedBy: json['UpdatedBy']?.toString() ?? '',
        BranchId: json['BranchId']?.toString() ?? '',
        Active: json['Active'] is bool ? json['Active'] : json['Active'] == 1,
        Capacity: double.tryParse(json['Capacity'].toString()) ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        'ID': ID,
        'Code': Code,
        'Name': Name,
        'WhsCode': WhsCode,
        'WhsName': WhsName,
        'CityCode': CityCode,
        'CityName': CityName,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'CreatedBy': CreatedBy,
        'UpdatedBy': UpdatedBy,
        'BranchId': BranchId,
        'Active': Active,
        'Capacity': Capacity,
      };
}

List<MNOWCM> mNOWCMFromJson(String str) =>
    List<MNOWCM>.from(json.decode(str).map((x) => MNOWCM.fromJson(x)));

String mNOWCMToJson(List<MNOWCM> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<MNOWCM>> dataSyncMNOWCM() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "MNOWCM" + postfix));
  print(res.body);
  return mNOWCMFromJson(res.body);
}

Future<void> insertMNOWCM(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteMNOWCM(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncMNOWCM();
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
      for (MNOWCM record in batchRecords) {
        try {
          batch.insert('MNOWCM_Temp', record.toJson());
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
			select * from MNOWCM_Temp
			except
			select * from MNOWCM
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
          batch.update("MNOWCM", element,
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
  print('Time taken for MNOWCM update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from MNOWCM_Temp where TransId not in (Select TransId from MNOWCM)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM MNOWCM_Temp T0
LEFT JOIN MNOWCM T1 ON T0.Code = T1.Code 
WHERE T1.Code IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('MNOWCM', record);
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
      'Time taken for MNOWCM_Temp and MNOWCM compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('MNOWCM_Temp');
}

Future<List<MNOWCM>> retrieveMNOWCMForSearch({
  int? limit,
  String? query,
}) async {
  query = "%$query%";
  final Database db = await initializeDB(null);
  final List<Map<String, Object?>> queryResult = await db.rawQuery(
      'SELECT * FROM MNOWCM WHERE Code LIKE "$query" OR Name LIKE "$query" LIMIT $limit');
  return queryResult.map((e) => MNOWCM.fromJson(e)).toList();
}

Future<List<MNOWCM>> retrieveMNOWCM(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('MNOWCM');
  return queryResult.map((e) => MNOWCM.fromJson(e)).toList();
}

Future<void> updateMNOWCM(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('MNOWCM', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deleteMNOWCM(Database db) async {
  await db.delete('MNOWCM');
}

Future<List<MNOWCM>> retrieveMNOWCMById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('MNOWCM', where: str, whereArgs: l);
  return queryResult.map((e) => MNOWCM.fromJson(e)).toList();
}

Future<String> insertMNOWCMToServer(BuildContext? context,
    {String? TransId, int? id}) async {
  String response = "";
  List<MNOWCM> list = await retrieveMNOWCMById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "TransId = ? AND ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "MNOWCM/Add"),
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
            .post(Uri.parse(prefix + "MNOWCM/Add"),
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
          MNOWCM model = MNOWCM.fromJson(jsonDecode(res.body));
          map["ID"] = model.ID;
          map["has_created"] = 0;
          var x = await db.update("MNOWCM", map,
              where: "Code = ?", whereArgs: [model.Code]);
          print(x.toString());
        } else if (res.statusCode == 201 || res.statusCode == 500) {
          sentSuccessInServer = true;
          if (res.statusCode == 201) {
            map['ID'] = jsonDecode(res.body)['ID'];
            final Database db = await initializeDB(context);
            // map = jsonDecode(res.body);
            map["has_created"] = 0;
            var x = await db.update("MNOWCM", map,
                where: "Code = ? ", whereArgs: [map["Code"]]);
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

Future<void> updateMNOWCMOnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<MNOWCM> list = await retrieveMNOWCMById(
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
          .put(Uri.parse(prefix + 'MNOWCM/Update'),
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
          var x = await db.update("MNOWCM", map,
              where: "Code = ?", whereArgs: [map["Code"]]);
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
