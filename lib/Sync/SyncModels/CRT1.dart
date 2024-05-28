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

class CRT1 {
  int? ID;
  String? NID;
  String? TransId;
  String? CardCode;
  double? DocTotal;
  double? Payment;
  double? Balance;
  int? DocEntry;
  String? DocNum;
  String? CRTransID;
  DateTime? PostingDate;
  String? INTransId;
  String? RPTransId;
  bool hasCreated;
  bool hasUpdated;
  DateTime? CreateDate;
  DateTime? UpdateDate;

  CRT1({
    this.ID,
    this.NID,
    this.TransId,
    this.CardCode,
    this.DocTotal,
    this.Payment,
    this.Balance,
    this.DocEntry,
    this.DocNum,
    this.CRTransID,
    this.PostingDate,
    this.INTransId,
    this.RPTransId,
    this.hasCreated = false,
    this.hasUpdated = false,
    this.CreateDate,
    this.UpdateDate,
  });

  factory CRT1.fromJson(Map<String, dynamic> json) =>
      CRT1(
        ID: json['ID'],
        NID: json['NID'],
        TransId: json['TransId'],
        CardCode: json['CardCode'],
        DocTotal: double.tryParse(json['DocTotal'].toString()) ?? 0.0,
        Payment: double.tryParse(json['Payment'].toString()) ?? 0.0,
        Balance: double.tryParse(json['Balance'].toString()) ?? 0.0,
        DocEntry: json['DocEntry'],
        DocNum: json['DocNum'],
        CRTransID: json['CRTransID'],
        PostingDate: DateTime.tryParse(json['PostingDate'].toString()),
        INTransId: json['INTransId'],
        RPTransId: json['RPTransId'],
        hasCreated: json['has_created'] == 1,
        hasUpdated: json['has_updated'] == 1,
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()) ??
            DateTime.parse('1900-01-01'),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()) ??
            DateTime.parse('1900-01-01'),
      );

  Map<String, dynamic> toJson() =>
      {
        'ID': ID,
        'NID': NID,
        'TransId': TransId,
        'CardCode': CardCode,
        'DocTotal': DocTotal,
        'Payment': Payment,
        'Balance': Balance,
        'DocEntry': DocEntry,
        'DocNum': DocNum,
        'CRTransID': CRTransID,
        'PostingDate': PostingDate?.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "has_updated": hasUpdated ? 1 : 0,
        'INTransId': INTransId,
        'RPTransId': RPTransId,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
      };
}

List<CRT1> cRT1FromJson(String str) =>
    List<CRT1>.from(json.decode(str).map((x) => CRT1.fromJson(x)));

String cRT1ToJson(List<CRT1> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<CRT1>> dataSyncCRT1() async {
  var res =
  await http.get(headers: header, Uri.parse(prefix + "CRT1" + postfix));
  print(res.body);
  return cRT1FromJson(res.body);
}

// Future<void> insertCRT1(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteCRT1(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncCRT1();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('CRT1_Temp', customer.toJson());
//     } catch (e) {
//       writeToLogFile(
//           text: e.toString(),
//           fileName: StackTrace.current.toString(),
//           lineNo: 141);
//       getErrorSnackBar('Sync Error ' + e.toString());
//     }
//   });
//   await batch1.commit(noResult: true);
//   var u = await db.rawQuery("SELECT * FROM  CRT1_Temp");
//   u.forEach((element) {
//     batch2.update("CRT1", element,
//         where: "ID = ? AND TransId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["ID"], element["TransId"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from CRT1_Temp where TransId || ID not in (Select TransId || ID from CRT1)");
//   v.forEach((element) {
//     batch3.insert('CRT1', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('CRT1_Temp');
// }

Future<void> insertCRT1(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteCRT1(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncCRT1();
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
      for (CRT1 record in batchRecords) {
        try {
          batch.insert('CRT1_Temp', record.toJson());
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
			select * from CRT1_Temp
			except
			select * from CRT1
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
          batch.update("CRT1", element,
              where:
              "ID = ? AND TransId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
              whereArgs: [element["ID"], element["TransId"], 1, 1]);
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
  print('Time taken for CRT1 update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from CRT1_Temp where TransId || ID not in (Select TransId || ID from CRT1)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM CRT1_Temp T0
LEFT JOIN CRT1 T1 ON T0.TransId = T1.TransId AND T0.ID = T1.ID
WHERE T1.TransId IS NULL AND T1.ID IS NULL;
''');

  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('CRT1', record);
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
      'Time taken for CRT1_Temp and CRT1 compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('CRT1_Temp');
  // stopwatch.stop();
}


Future<List<CRT1>> retrieveCRT1(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('CRT1');
  return queryResult.map((e) => CRT1.fromJson(e)).toList();
}

Future<void> updateCRT1(int id, Map<String, dynamic> values,
    BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('CRT1', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deleteCRT1(Database db) async {
  await db.delete('CRT1');
}

Future<List<CRT1>> retrieveCRT1ById(BuildContext? context, String str,
    List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
  await db.query('CRT1', where: str, whereArgs: l);
  return queryResult.map((e) => CRT1.fromJson(e)).toList();
}

Future<void> insertCRT1ToServer(BuildContext? context,
    {String? TransId, int? id}) async {
  String response = "";
  List<CRT1> list = await retrieveCRT1ById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "TransId = ? AND ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "CRT1/Add"),
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
        String queryParams='TransId=${list[i].TransId}&INTransId=${list[i].INTransId}';
        var res = await http.post(Uri.parse(prefix + "CRT1/Add?$queryParams"),
            headers: header, body: jsonEncode(map))
            .timeout(Duration(seconds: 30), onTimeout: () {
          writeToLogFile(
            text: '500 error \nMap : $map', fileName: StackTrace.current.toString(), lineNo: 141);return http.Response('Error', 500);
        });
        response = await res.body;
        print(res.body);
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
          CRT1 model=CRT1.fromJson(jsonDecode(res.body));
          var x = await db.update("CRT1", model.toJson(),
              where: "TransId = ? AND INTransId = ?", whereArgs: [model.TransId,model.INTransId]);
          print(x.toString());
        }
        else
        if (res.statusCode == 201 || res.statusCode == 500) {
          sentSuccessInServer = true;
          if (res.statusCode == 201) {
            map['ID'] = jsonDecode(res.body)['ID'];
            final Database db = await initializeDB(context);
            // map = jsonDecode(res.body);
            map["has_created"] = 0;
            var x = await db.update("CRT1", map,
                where: "TransId = ? AND INTransId = ?",
                whereArgs: [map["TransId"], map["INTransId"]]);
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
            text: '${e.toString()}\nMap : $map', fileName: StackTrace.current.toString(), lineNo: 141);
  sentSuccessInServer = true;
  }
  i++;
  print("INDEX = " + i.toString());
  } while (i < list.length && sentSuccessInServer == true);
}

}

Future<void> updateCRT1OnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<CRT1> list = await retrieveCRT1ById(
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
          .put(Uri.parse(prefix + 'CRT1/Update'),
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
          var x = await db.update("CRT1", map,
              where: "TransId = ? AND RowId = ?",
              whereArgs: [map["TransId"], map["RowId"]]);
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
          text: '${e.toString()}\nMap : $map', fileName: StackTrace.current.toString(), lineNo: 141);
  sentSuccessInServer = true;
  }

  i++;
  print("INDEX = " + i.toString());
  } while (i < list.length && sentSuccessInServer == true);
}
