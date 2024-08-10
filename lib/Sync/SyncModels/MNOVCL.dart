import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

class MNOVCL {
  int? ID;
  String? Code;
  DateTime? FromDate;
  DateTime? ToDate;
  DateTime? InstalledDate;
  String? InstalledByCode;
  String? InstalledByName;
  DateTime? WarrantyFromDate;
  DateTime? WarrantyToDate;
  String? WarrantyByCode;
  String? WarrantyByName;
  String? Remarks;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  int? hasCreated;
  int? hasUpdated;

  MNOVCL({
    this.ID,
    this.Code,
    this.FromDate,
    this.ToDate,
    this.InstalledDate,
    this.InstalledByCode,
    this.InstalledByName,
    this.WarrantyFromDate,
    this.WarrantyToDate,
    this.WarrantyByCode,
    this.WarrantyByName,
    this.Remarks,
    this.CreateDate,
    this.UpdateDate,
    this.hasCreated,
    this.hasUpdated,
  });

  factory MNOVCL.fromJson(Map<String, dynamic> json) => MNOVCL(
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        Code: json['Code'],
        FromDate: DateTime.tryParse(json['FromDate'].toString()),
        ToDate: DateTime.tryParse(json['ToDate'].toString()),
        InstalledDate: DateTime.tryParse(json['InstalledDate'].toString()),
        InstalledByCode: json['InstalledByCode'],
        InstalledByName: json['InstalledByName'],
        WarrantyFromDate:
            DateTime.tryParse(json['WarrantyFromDate'].toString()),
        WarrantyToDate: DateTime.tryParse(json['WarrantyToDate'].toString()),
        WarrantyByCode: json['WarrantyByCode'],
        WarrantyByName: json['WarrantyByName'],
        Remarks: json['Remarks'],
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()),
        hasCreated: int.tryParse(json['has_created'].toString()) ?? 0,
        hasUpdated: int.tryParse(json['has_updated'].toString()) ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'ID': ID,
        'Code': Code,
        'FromDate': FromDate?.toIso8601String(),
        'ToDate': ToDate?.toIso8601String(),
        'InstalledDate': InstalledDate?.toIso8601String(),
        'InstalledByCode': InstalledByCode,
        'InstalledByName': InstalledByName,
        'WarrantyFromDate': WarrantyFromDate?.toIso8601String(),
        'WarrantyToDate': WarrantyToDate?.toIso8601String(),
        'WarrantyByCode': WarrantyByCode,
        'WarrantyByName': WarrantyByName,
        'Remarks': Remarks,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'has_created': hasCreated,
        'has_updated': hasUpdated,
      };
}

List<MNOVCL> mNOVLCFromJson(String str) =>
    List<MNOVCL>.from(json.decode(str).map((x) => MNOVCL.fromJson(x)));

String mNOVLCToJson(List<MNOVCL> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<MNOVCL>> dataSyncMNOVCL() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "MNOVCL" + postfix));
  print(res.body);
  return mNOVLCFromJson(res.body);
}

Future<void> insertMNOVCL(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteMNOVCL(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncMNOVCL();
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
      for (MNOVCL record in batchRecords) {
        try {
          batch.insert('MNOVCL_Temp', record.toJson());
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
			select * from MNOVCL_Temp
			except
			select * from MNOVCL
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
          batch.update("MNOVCL", element,
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
  print('Time taken for MNOVCL update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  var v = await db.rawQuery('''
    SELECT T0.*
FROM MNOVCL_Temp T0
LEFT JOIN MNOVCL T1 ON T0.Code = T1.Code 
WHERE T1.Code IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('MNOVCL', record);
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
      'Time taken for MNOVCL_Temp and MNOVCL compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('MNOVCL_Temp');
}

Future<List<MNOVCL>> retrieveMNOVCL(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('MNOVCL');
  return queryResult.map((e) => MNOVCL.fromJson(e)).toList();
}

Future<void> updateMNOVCL(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('MNOVCL', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deleteMNOVCL(Database db) async {
  await db.delete('MNOVCL');
}

Future<List<MNOVCL>> retrieveMNOVCLById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('MNOVCL', where: str, whereArgs: l);
  return queryResult.map((e) => MNOVCL.fromJson(e)).toList();
}

Future<String> insertMNOVCLToServer(BuildContext? context,
    {String? TransId, int? id}) async {
  String response = "";
  List<MNOVCL> list = await retrieveMNOVCLById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "Code = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "MNOVCL/Add"),
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
            .post(Uri.parse(prefix + "MNOVCL/Add"),
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
            var x = await db.update("MNOVCL", map,
                where: "Code = ?",
                whereArgs: [map["Code"]]);
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

Future<void> updateMNOVCLOnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<MNOVCL> list = await retrieveMNOVCLById(
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
          .put(Uri.parse(prefix + 'MNOVCL/Update'),
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
          var x = await db.update("MNOVCL", map,
              where: "Code = ?",
              whereArgs: [map["Code"]]);
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
