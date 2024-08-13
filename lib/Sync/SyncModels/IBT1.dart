import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

class IBT1 {
  int? ID;
  int? OIBTID;
  int? RowId;
  String? ItemCode;
  String? ItemName;
  String? WhsCode;
  String? BatchNum;
  double? Quantity;
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

  IBT1({
    this.ID,
    this.OIBTID,
    this.RowId,
    this.ItemCode,
    this.ItemName,
    this.WhsCode,
    this.BatchNum,
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

  factory IBT1.fromJson(Map<String, dynamic> json) => IBT1(
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        OIBTID: int.tryParse(json['OIBTID'].toString()) ?? 0,
        RowId: int.tryParse(json['RowId'].toString()) ?? 0,
        ItemCode: json['ItemCode'],
        ItemName: json['ItemName'],
        WhsCode: json['WhsCode'],
        BatchNum: json['BatchNum'],
        Quantity: double.tryParse(json['Quantity'].toString()) ?? 0.0,
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
        'OIBTID': OIBTID,
        'RowId': RowId,
        'ItemCode': ItemCode,
        'ItemName': ItemName,
        'WhsCode': WhsCode,
        'BatchNum': BatchNum,
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

List<IBT1> iBT1FromJson(String str) =>
    List<IBT1>.from(json.decode(str).map((x) => IBT1.fromJson(x)));

String iBT1ToJson(List<IBT1> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<IBT1>> dataSyncIBT1() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "IBT1" + postfix));
  print(res.body);
  return iBT1FromJson(res.body);
}

Future<void> insertIBT1(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteIBT1(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncIBT1();
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
      for (IBT1 record in batchRecords) {
        try {
          batch.insert('IBT1_Temp', record.toJson());
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
			select * from IBT1_Temp
			except
			select * from IBT1
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
          batch.update("IBT1", element,
              where:
                  "OIBTID = ? AND RowId AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
              whereArgs: [element["TransId"], element["RowId"], 1, 1]);
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
  print('Time taken for IBT1 update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  var v = await db.rawQuery('''
    SELECT T0.*
FROM IBT1_Temp T0
LEFT JOIN IBT1 T1 ON T0.OIBTID = T1.OIBTID AND T0.RowId = T1.RowId 
WHERE T1.TransId IS NULL AND T1.RowId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('IBT1', record);
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
      'Time taken for IBT1_Temp and IBT1 compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('IBT1_Temp');
}

Future<List<IBT1>> retrieveIBT1(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('IBT1');
  return queryResult.map((e) => IBT1.fromJson(e)).toList();
}

Future<void> updateIBT1(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('IBT1', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deleteIBT1(Database db) async {
  await db.delete('IBT1');
}

Future<List<IBT1>> retrieveIBT1ById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('IBT1', where: str, whereArgs: l);
  return queryResult.map((e) => IBT1.fromJson(e)).toList();
}

Future<String> insertIBT1ToServer(BuildContext? context,
    {String? TransId, int? id}) async {
  String response = "";
  List<IBT1> list = await retrieveIBT1ById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "TransId = ? AND ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "IBT1/Add"),
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
            .post(Uri.parse(prefix + "IBT1/Add"),
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
            var x = await db.update("IBT1", map,
                where: "OIBTID = ? AND RowId = ?",
                whereArgs: [map["OIBTID"], map["RowId"]]);
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

Future<void> updateIBT1OnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<IBT1> list = await retrieveIBT1ById(
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
          .put(Uri.parse(prefix + 'IBT1/Update'),
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
          var x = await db.update("IBT1", map,
              where: "OIBTID = ? AND RowId = ?",
              whereArgs: [map["OIBTID"], map["RowId"]]);
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
