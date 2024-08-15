import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

class SRI1 {
  int? ID;
  int? OSRIID;
  int? RowId;
  String? ItemCode;
  String? ItemName;
  String? WhsCode;
  String? SerialNum;
  int? Quantity;
  int? Direction;
  DateTime? InDate;
  DateTime? ExpDate;
  String? CreatedBy;
  String? BranchId;
  String? UpdatedBy;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  double? Price;
  double? MSP;
  String? Currency;
  int? hasCreated;
  int? hasUpdated;

  SRI1({
    this.ID,
    this.OSRIID,
    this.RowId,
    this.ItemCode,
    this.ItemName,
    this.WhsCode,
    this.SerialNum,
    this.Quantity,
    this.Direction,
    this.InDate,
    this.ExpDate,
    this.CreatedBy,
    this.BranchId,
    this.UpdatedBy,
    this.CreateDate,
    this.UpdateDate,
    this.Price,
    this.MSP,
    this.Currency,
    this.hasCreated,
    this.hasUpdated,
  });

  factory SRI1.fromJson(Map<String, dynamic> json) => SRI1(
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        OSRIID: int.tryParse(json['OSRIID'].toString()) ?? 0,
        RowId: int.tryParse(json['RowId'].toString()) ?? 0,
        ItemCode: json['ItemCode'],
        ItemName: json['ItemName'],
        WhsCode: json['WhsCode'],
        SerialNum: json['SerialNum'],
        Quantity: int.tryParse(json['Quantity'].toString()) ?? 0,
        Direction: int.tryParse(json['Direction'].toString()) ?? 0,
        InDate: DateTime.tryParse(json['InDate'].toString()),
        ExpDate: DateTime.tryParse(json['ExpDate'].toString()),
        CreatedBy: json['CreatedBy'],
        BranchId: json['BranchId'],
        UpdatedBy: json['UpdatedBy'],
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()),
        Price: double.tryParse(json['Price'].toString()) ?? 0.0,
        MSP: double.tryParse(json['MSP'].toString()) ?? 0.0,
        Currency: json['Currency'],
        hasCreated: int.tryParse(json['has_created'].toString()) ?? 0,
        hasUpdated: int.tryParse(json['has_updated'].toString()) ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'ID': ID,
        'OSRIID': OSRIID,
        'RowId': RowId,
        'ItemCode': ItemCode,
        'ItemName': ItemName,
        'WhsCode': WhsCode,
        'SerialNum': SerialNum,
        'Quantity': Quantity,
        'Direction': Direction,
        'InDate': InDate?.toIso8601String(),
        'ExpDate': ExpDate?.toIso8601String(),
        'CreatedBy': CreatedBy,
        'BranchId': BranchId,
        'UpdatedBy': UpdatedBy,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'Price': Price,
        'MSP': MSP,
        'Currency': Currency,
        'has_created': hasCreated,
        'has_updated': hasUpdated,
      };
}

List<SRI1> sRI1FromJson(String str) =>
    List<SRI1>.from(json.decode(str).map((x) => SRI1.fromJson(x)));

String sRI1ToJson(List<SRI1> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<SRI1>> dataSyncSRI1() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "SRI1" + postfix));
  print(res.body);
  return sRI1FromJson(res.body);
}

Future<void> insertSRI1(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteSRI1(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncSRI1();
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
      for (SRI1 record in batchRecords) {
        try {
          batch.insert('SRI1_Temp', record.toJson());
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
			select * from SRI1_Temp
			except
			select * from SRI1
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
          batch.update("SRI1", element,
              where:
                  "OSRIID = ? AND RowId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
              whereArgs: [element["OSRIID"], element["RowId"], 1, 1]);
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
  print('Time taken for SRI1 update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from SRI1_Temp where TransId not in (Select TransId from SRI1)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM SRI1_Temp T0
LEFT JOIN SRI1 T1 ON T0.OSRIID = T1.OSRIID AND T0.RowId = T1.RowId 
WHERE T1.OSRIID IS NULL AND T1.RowId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('SRI1', record);
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
      'Time taken for SRI1_Temp and SRI1 compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('SRI1_Temp');
}

Future<List<SRI1>> retrieveSRI1(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('SRI1');
  return queryResult.map((e) => SRI1.fromJson(e)).toList();
}

Future<void> updateSRI1(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('SRI1', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deleteSRI1(Database db) async {
  await db.delete('SRI1');
}

Future<List<SRI1>> retrieveSRI1ById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('SRI1', where: str, whereArgs: l);
  return queryResult.map((e) => SRI1.fromJson(e)).toList();
}

Future<String> insertSRI1ToServer(BuildContext? context,
    {String? TransId, int? id}) async {
  String response = "";
  List<SRI1> list = await retrieveSRI1ById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "TransId = ? AND ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "SRI1/Add"),
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
            .post(Uri.parse(prefix + "SRI1/Add"),
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
            var x = await db.update("SRI1", map,
                where: "OSRIID = ? AND RowId = ?",
                whereArgs: [map["OSRIID"], map["RowId"]]);
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

Future<void> updateSRI1OnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<SRI1> list = await retrieveSRI1ById(
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
          .put(Uri.parse(prefix + 'SRI1/Update'),
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
          var x = await db.update("SRI1", map,
              where: "OSRIID = ? AND RowId = ?",
              whereArgs: [map["OSRIID"], map["RowId"]]);
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
