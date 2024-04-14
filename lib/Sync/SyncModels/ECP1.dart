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

class ECP1 {
  int? ID;
  String? TransId;
  int? RowId;
  int? ExpId;
  String? ExpShortDesc;
  String? Based;
  String? Remarks;
  bool? Mandatory;
  double? Amount;
  double? Factor;
  double? RAmount;
  String? RRemarks;
  double? AAmount;
  String? ARemarks;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  bool hasCreated;
  bool hasUpdated;
  int? DocEntry;
  String? DocNum;

  ECP1({
    this.ID,
    this.TransId,
    this.RowId,
    this.ExpId,
    this.ExpShortDesc,
    this.hasCreated = false,
    this.hasUpdated = false,
    this.Based,
    this.Remarks,
    this.Mandatory,
    this.Amount,
    this.Factor,
    this.RAmount,
    this.RRemarks,
    this.AAmount,
    this.ARemarks,
    this.CreateDate,
    this.UpdateDate,
    this.DocEntry,
    this.DocNum,
  });

  factory ECP1.fromJson(Map<String, dynamic> json) =>
      ECP1(
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        TransId: json['TransId'],
        RowId: int.tryParse(json['RowId'].toString()) ?? 0,
        ExpId: int.tryParse(json['ExpId'].toString()) ?? 0,
        ExpShortDesc: json['ExpShortDesc'],
        Based: json['Based'],
        Remarks: json['Remarks']??'',
        Mandatory: json['Mandatory'] is bool
            ? json['Mandatory']
            : json['Mandatory'] == 1,
        Amount: double.tryParse(json['Amount'].toString()) ?? 0.0,
        Factor: double.tryParse(json['Factor'].toString()) ?? 0.0,
        RAmount: double.tryParse(json['RAmount'].toString()) ?? 0.0,
        RRemarks: json['RRemarks']??'',
        AAmount: double.tryParse(json['AAmount'].toString()) ?? 0.0,
        ARemarks: json['ARemarks']??'',
        hasCreated: json['has_created'] is bool
            ? json['has_created']
            : json['has_created'] == 1,
        hasUpdated: json['has_updated'] is bool
            ? json['has_updated']
            : json['has_updated'] == 1,
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()),
        DocEntry: json['DocEntry'],
        DocNum: json['DocNum'],
      );

  Map<String, dynamic> toJson() =>
      {
        'ID': ID,
        'TransId': TransId,
        'RowId': RowId,
        'ExpId': ExpId,
        'ExpShortDesc': ExpShortDesc,
        'Based': Based,
        "has_created": hasCreated ? 1 : 0,
        "has_updated": hasUpdated ? 1 : 0,
        'Remarks': Remarks,
        'Mandatory': Mandatory,
        'Amount': Amount,
        'Factor': Factor,
        'RAmount': RAmount,
        'RRemarks': RRemarks,
        'AAmount': AAmount,
        'ARemarks': ARemarks,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'DocEntry': DocEntry,
        'DocNum': DocNum,
      };
}

List<ECP1> eCP1FromJson(String str) =>
    List<ECP1>.from(json.decode(str).map((x) => ECP1.fromJson(x)));

String eCP1ToJson(List<ECP1> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<ECP1>> dataSyncECP1() async {
  var res =
  await http.get(headers: header, Uri.parse(prefix + "ECP1" + postfix));
  print(res.body);
  return eCP1FromJson(res.body);
}

// Future<void> insertECP1(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteECP1(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncECP1();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('ECP1_Temp', customer.toJson());
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
//       "SELECT * FROM  ECP1_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("ECP1", element,
//         where: "RowId = ? AND TransId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["RowId"], element["TransId"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from ECP1_Temp where TransId || RowId not in (Select TransId || RowId from ECP1)");
//   v.forEach((element) {
//     batch3.insert('ECP1', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('ECP1_Temp');
// }

Future<void> insertECP1(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteECP1(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncECP1();
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
      for (ECP1 record in batchRecords) {
        try {
          batch.insert('ECP1_Temp', record.toJson());
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
			select * from ECP1_Temp
			except
			select * from ECP1
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
          batch.update("ECP1", element,
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
  print('Time taken for ECP1 update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from ECP1_Temp where TransId || RowId not in (Select TransId || RowId from ECP1)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM ECP1_Temp T0
LEFT JOIN ECP1 T1 ON T0.TransId = T1.TransId AND T0.RowId = T1.RowId
WHERE T1.TransId IS NULL AND T1.RowId IS NULL;
''');
  print(v.length);
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('ECP1', record);
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
      'Time taken for ECP1_Temp and ECP1 compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('ECP1_Temp');
  // stopwatch.stop();
}


Future<List<ECP1>> retrieveECP1(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('ECP1');
  return queryResult.map((e) => ECP1.fromJson(e)).toList();
}

Future<void> updateECP1(int id, Map<String, dynamic> values,
    BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('ECP1', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deleteECP1(Database db) async {
  await db.delete('ECP1');
}

Future<List<ECP1>> retrieveECP1ById(BuildContext? context, String str,
    List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
  await db.query('ECP1', where: str, whereArgs: l);
  return queryResult.map((e) => ECP1.fromJson(e)).toList();
}
Future<List<ECP1>> retrieveECP1ForRecon({
  required String CRTransId,
  required String ExpShortDesc,
}) async {
  final Database db = await initializeDB(null);
  String query='''
       SELECT ecp1.* FROM OECP oecp  INNER JOIN ECP1 ecp1 ON oecp.TransId=ecp1.TransId
 WHERE oecp.TransId='$CRTransId' AND  ecp1.ExpShortDesc='$ExpShortDesc'
      ''';

  final List<Map<String, Object?>> queryResult =
  await db.rawQuery(query);
  return queryResult.map((e) => ECP1.fromJson(e)).toList();
}

Future<void> insertECP1ToServer(BuildContext? context,
    {String? TransId, int? id}) async {
  String response = "";
  List<ECP1> list = await retrieveECP1ById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "TransId = ? AND ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "ECP1/Add"),
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
        print(jsonEncode(map));
        String queryParams='TransId=${list[i].TransId}&RowId=${list[i].RowId}';
        var res = await http.post(Uri.parse(prefix + "ECP1/Add?$queryParams"),
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
          ECP1 model=ECP1.fromJson(jsonDecode(res.body));
          var x = await db.update("ECP1", model.toJson(),
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
            var x = await db.update("ECP1", map,
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

}

Future<void> updateECP1OnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<ECP1> list = await retrieveECP1ById(
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
      print(map);
      var res = await http
          .put(Uri.parse(prefix + 'ECP1/Update'),
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
          var x = await db.update("ECP1", map,
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
