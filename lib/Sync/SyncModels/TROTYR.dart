import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

class TROTYR {
  int? ID;
  String? ItemCode;
  String? ItemName;
  String? UOM;
  String? ManufacturedBy;
  String? ManufacturedByName;
  String? TyreType;
  String? TyreSize;
  String? Tread;
  bool? InStock;
  String? Remarks;
  String? CreatedBy;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  String? BranchId;
  String? UpdatedBy;
  String? Pressure;
  double? TyreDesign;

  TROTYR({
    this.ID,
    this.ItemCode,
    this.ItemName,
    this.UOM,
    this.ManufacturedBy,
    this.ManufacturedByName,
    this.TyreType,
    this.TyreSize,
    this.Tread,
    this.InStock,
    this.Remarks,
    this.CreatedBy,
    this.CreateDate,
    this.UpdateDate,
    this.BranchId,
    this.UpdatedBy,
    this.Pressure,
    this.TyreDesign,
  });

  factory TROTYR.fromJson(Map<String, dynamic> json) => TROTYR(
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        ItemCode: json['ItemCode'],
        ItemName: json['ItemName'],
        UOM: json['UOM'],
        ManufacturedBy: json['ManufacturedBy'],
        ManufacturedByName: json['ManufacturedByName'],
        TyreType: json['TyreType'],
        TyreSize: json['TyreSize'],
        Tread: json['Tread'],
        InStock:
            json['InStock'] is bool ? json['InStock'] : json['InStock'] == 1,
        Remarks: json['Remarks'],
        CreatedBy: json['CreatedBy'],
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()),
        BranchId: json['BranchId'],
        UpdatedBy: json['UpdatedBy'],
        Pressure: json['Pressure'],
        TyreDesign: double.tryParse(json['TyreDesign'].toString()) ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        'ID': ID,
        'ItemCode': ItemCode,
        'ItemName': ItemName,
        'UOM': UOM,
        'ManufacturedBy': ManufacturedBy,
        'ManufacturedByName': ManufacturedByName,
        'TyreType': TyreType,
        'TyreSize': TyreSize,
        'Tread': Tread,
        'InStock': InStock,
        'Remarks': Remarks,
        'CreatedBy': CreatedBy,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'BranchId': BranchId,
        'UpdatedBy': UpdatedBy,
        'Pressure': Pressure,
        'TyreDesign': TyreDesign,
      };
}

List<TROTYR> tROTYRFromJson(String str) =>
    List<TROTYR>.from(json.decode(str).map((x) => TROTYR.fromJson(x)));

String tROTYRToJson(List<TROTYR> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<TROTYR>> dataSyncTROTYR() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "TROTYR" + postfix));
  print(res.body);
  return tROTYRFromJson(res.body);
}

Future<void> insertTROTYR(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteTROTYR(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncTROTYR();
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
      for (TROTYR record in batchRecords) {
        try {
          batch.insert('TROTYR_Temp', record.toJson());
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
			select * from TROTYR_Temp
			except
			select * from TROTYR
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
          batch.update("TROTYR", element,
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
  print('Time taken for TROTYR update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from TROTYR_Temp where TransId not in (Select TransId from TROTYR)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM TROTYR_Temp T0
LEFT JOIN TROTYR T1 ON T0.TransId = T1.TransId 
WHERE T1.TransId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('TROTYR', record);
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
      'Time taken for TROTYR_Temp and TROTYR compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('TROTYR_Temp');
}

Future<List<TROTYR>> retrieveTROTYR(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('TROTYR');
  return queryResult.map((e) => TROTYR.fromJson(e)).toList();
}

Future<void> updateTROTYR(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('TROTYR', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deleteTROTYR(Database db) async {
  await db.delete('TROTYR');
}

Future<List<TROTYR>> retrieveTROTYRById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('TROTYR', where: str, whereArgs: l);
  return queryResult.map((e) => TROTYR.fromJson(e)).toList();
}

Future<String> insertTROTYRToServer(BuildContext? context,
    {String? TransId, int? id}) async {
  String response = "";
  List<TROTYR> list = await retrieveTROTYRById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "TransId = ? AND ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "TROTYR/Add"),
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
            .post(Uri.parse(prefix + "TROTYR/Add"),
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
            var x = await db.update("TROTYR", map,
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
      print('i++;');
      print("INDEX = " + i.toString());
    } while (i < list.length && sentSuccessInServer == true);
  }
  return response;
}

Future<void> updateTROTYROnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<TROTYR> list = await retrieveTROTYRById(
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
          .put(Uri.parse(prefix + 'TROTYR/Update'),
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
          var x = await db.update("TROTYR", map,
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
