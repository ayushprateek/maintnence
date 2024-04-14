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

class STK1 {
  int? ID;
  String? TransId;
  int? RowId;
  String? UOM;
  String? ItemCode;
  double? PhysicalStock;
  int? DocEntry;
  String? DocNum;
  String? ItemName;
  double? Quantity;
  double? OpenQty;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  bool? hasCreated;
  bool? hasUpdated;
  bool insertedIntoDatabase;

  STK1({
    this.ID,
    this.UOM,
    this.DocNum,
    this.PhysicalStock,
    this.TransId,
    this.RowId,
    this.DocEntry,
    this.ItemCode,
    this.ItemName,
    this.Quantity,
    this.OpenQty,
    this.CreateDate,
    this.UpdateDate,
    this.hasCreated,
    this.hasUpdated,
    this.insertedIntoDatabase = false,
  });

  factory STK1.fromJson(Map<String, dynamic> json) =>
      STK1(
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        PhysicalStock: double.tryParse(json['PhysicalStock'].toString()),
        DocEntry: int.tryParse(json['DocEntry'].toString()),
        DocNum: json['DocNum'],
        UOM: json['UOM'],
        TransId: json['TransId'],
        RowId: int.tryParse(json['RowId'].toString()) ?? 0,
        ItemCode: json['ItemCode'],
        ItemName: json['ItemName'],
        Quantity: double.tryParse(json['Quantity'].toString()) ?? 0.0,
        OpenQty: double.tryParse(json['OpenQty'].toString()) ?? 0.0,
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()),
        hasCreated: json['has_created'] is bool
            ? json['has_created']
            : json['has_created'] == 1,
        hasUpdated: json['has_updated'] is bool
            ? json['has_updated']
            : json['has_updated'] == 1,
      );

  Map<String, dynamic> toJson() =>
      {
        'ID': ID,
        'DocEntry': DocEntry,
        'DocNum': DocNum,
        'PhysicalStock': PhysicalStock,
        'UOM': UOM,
        'TransId': TransId,
        'RowId': RowId,
        'ItemCode': ItemCode,
        'ItemName': ItemName,
        'Quantity': Quantity,
        'OpenQty': OpenQty,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'has_created': hasCreated == true ? 1 : 0,
        'has_updated': hasUpdated == true ? 1 : 0,
      };
}

List<STK1> sTK1FromJson(String str) =>
    List<STK1>.from(json.decode(str).map((x) => STK1.fromJson(x)));

String sTK1ToJson(List<STK1> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<STK1>> dataSyncSTK1() async {
  var res =
  await http.get(headers: header, Uri.parse(prefix + "STK1" + postfix));
  print(res.body);
  return sTK1FromJson(res.body);
}

// Future<void> insertSTK1(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteSTK1(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncSTK1();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('STK1_Temp', customer.toJson());
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
//       "SELECT * FROM  STK1_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("STK1", element,
//         where: "RowId = ? AND TransId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["RowId"], element["TransId"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from STK1_Temp where TransId || RowId not in (Select TransId || RowId from STK1)");
//   v.forEach((element) {
//     batch3.insert('STK1', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('STK1_Temp');
// }
Future<void> insertSTK1(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteSTK1(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncSTK1();
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
      for (STK1 record in batchRecords) {
        try {
          batch.insert('STK1_Temp', record.toJson());
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
			select * from STK1_Temp
			except
			select * from STK1
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
          batch.update("STK1", element,
              where: "RowId = ? AND TransId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
              whereArgs: [element["RowId"], element["TransId"], 1, 1]);
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
  print('Time taken for STK1 update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from STK1_Temp where TransId || RowId not in (Select TransId || RowId from STK1)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM STK1_Temp T0
LEFT JOIN STK1 T1 ON T0.TransId = T1.TransId AND T0.RowId = T1.RowId
WHERE T1.TransId IS NULL AND T1.RowId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('STK1', record);
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
      'Time taken for STK1_Temp and STK1 compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('STK1_Temp');
  // stopwatch.stop();
}

Future<List<STK1>> retrieveSTK1(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('STK1');
  return queryResult.map((e) => STK1.fromJson(e)).toList();
}

Future<void> updateSTK1(int id, Map<String, dynamic> values,
    BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('STK1', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deleteSTK1(Database db) async {
  await db.delete('STK1');
}

Future<List<STK1>> retrieveSTK1ById(BuildContext? context, String str,
    List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
  await db.query('STK1', where: str, whereArgs: l);
  return queryResult.map((e) => STK1.fromJson(e)).toList();
}

Future<void> insertSTK1ToServer(BuildContext? context,
    {String? TransId, int? id}) async {
  String response = "";
  List<STK1> list = await retrieveSTK1ById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "TransId = ? AND ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "STK1/Add"),
        headers: header, body: jsonEncode(list[0].toJson()));
    response = res.body;
  } else if (list.isNotEmpty) {
    int i = 0;
    bool sentSuccessInServer = false;
    if (list.isEmpty) {
      return;
    }
    do {Map<String, dynamic> map = list[i].toJson();
      sentSuccessInServer = false;
      try {
        map.remove('ID');
        String queryParams='TransId=${list[i].TransId}&RowId=${list[i].RowId}';
        var res = await http.post(Uri.parse(prefix + "STK1/Add?$queryParams"),
            headers: header, body: jsonEncode(map))
            .timeout(Duration(seconds: 30), onTimeout: () {
          writeToLogFile(
            text: '500 error \nMap : $map', fileName: StackTrace.current.toString(), lineNo: 141);return http.Response('Error', 500);
        });
        response = await res.body;
        print("eeaaae status");
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
          STK1 model=STK1.fromJson(jsonDecode(res.body));
          var x = await db.update("STK1", model.toJson(),
              where: "TransId = ? AND RowId = ?", whereArgs: [model.TransId,model.RowId]);
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
            var x = await db.update("STK1", map,
                where: "TransId = ? AND RowId = ?",
                whereArgs: [map["TransId"], map["RowId"]]);
            print(x.toString());
          }
        }
        print(res.body);
      } catch (e) {
        writeToLogFile(
            text: '${e.toString()}\nMap : $map', fileName: StackTrace.current.toString(), lineNo: 141);
  sentSuccessInServer = true;
  }
  i++;
  print("INDEX = " + i.toString());
  } while (i < list.length && sentSuccessInServer == true);
}

}

Future<void> updateSTK1OnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<STK1> list = await retrieveSTK1ById(
      context,
      l == null ? DataSync.getUpdateOnServerStr() : condition ?? "",
      l == null ? DataSync.getUpdateOnServerList() : l);
  print(list);
  int i = 0;
  bool sentSuccessInServer = false;
  if (list.isEmpty) {
    return;
  }
  do {Map<String, dynamic> map = list[i].toJson();
    sentSuccessInServer = false;
    try {
      if (list.isEmpty) {
        return;
      }
      Map<String, dynamic> map = list[i].toJson();
      var res = await http
          .put(Uri.parse(prefix + 'STK1/Update'),
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
          var x = await db.update("STK1", map,
              where: "TransId = ? AND RowId = ?",
              whereArgs: [map["TransId"], map["RowId"]]);
          print(x.toString());
        }
      }
      print(res.body);
    } catch (e) {
      writeToLogFile(
          text: '${e.toString()}\nMap : $map', fileName: StackTrace.current.toString(), lineNo: 141);
  sentSuccessInServer = true;
  }

  i++;
  print("INDEX = " + i.toString());
  } while (i < list.length && sentSuccessInServer == true);
}
