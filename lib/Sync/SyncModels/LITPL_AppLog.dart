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

class LITPL_AppLog {
  int? BPLID;
  int? AppLogID;
  int? AppStageID;
  int? DocID;
  DateTime? DocDate;
  String? Subject;
  int? OriginatorUID;
  int? ApproverUID;
  String? ApproverRemark;
  String? ApprovedStatus;
  DateTime? ApprovedDate;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  int? UpdatedBy;
  String? DocName;
  String? Rejected;
  String? RejectedRemark;
  String? DocNo;
  int? ApprovalLevel;

  LITPL_AppLog({
    this.BPLID,
    this.AppLogID,
    this.AppStageID,
    this.DocID,
    this.DocDate,
    this.Subject,
    this.OriginatorUID,
    this.ApproverUID,
    this.ApproverRemark,
    this.ApprovedStatus,
    this.ApprovedDate,
    this.CreateDate,
    this.UpdateDate,
    this.UpdatedBy,
    this.DocName,
    this.Rejected,
    this.RejectedRemark,
    this.DocNo,
    this.ApprovalLevel,
  });

  factory LITPL_AppLog.fromJson(Map<String, dynamic> json) =>
      LITPL_AppLog(
        BPLID: int.tryParse(json['BPLID'].toString()) ?? 0,
        AppLogID: int.tryParse(json['AppLogID'].toString()) ?? 0,
        AppStageID: int.tryParse(json['AppStageID'].toString()) ?? 0,
        DocID: int.tryParse(json['DocID'].toString()) ?? 0,
        DocDate: DateTime.tryParse(json['DocDate'].toString()),
        Subject: json['Subject'] ?? '',
        OriginatorUID: int.tryParse(json['OriginatorUID'].toString()) ?? 0,
        ApproverUID: int.tryParse(json['ApproverUID'].toString()) ?? 0,
        ApproverRemark: json['ApproverRemark'] ?? '',
        ApprovedStatus: json['ApprovedStatus'] ?? '',
        ApprovedDate: DateTime.tryParse(json['ApprovedDate'].toString()),
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()),
        UpdatedBy: int.tryParse(json['UpdatedBy'].toString()) ?? 0,
        DocName: json['DocName'] ?? '',
        Rejected: json['Rejected'] ?? '',
        RejectedRemark: json['RejectedRemark'] ?? '',
        DocNo: json['DocNo'] ?? '',
        ApprovalLevel: int.tryParse(json['ApprovalLevel'].toString()) ?? 0,
      );

  Map<String, dynamic> toJson() =>
      {
        'BPLID': BPLID,
        'AppLogID': AppLogID,
        'AppStageID': AppStageID,
        'DocID': DocID,
        'DocDate': DocDate?.toIso8601String(),
        'Subject': Subject,
        'OriginatorUID': OriginatorUID,
        'ApproverUID': ApproverUID,
        'ApproverRemark': ApproverRemark,
        'ApprovedStatus': ApprovedStatus,
        'ApprovedDate': ApprovedDate?.toIso8601String(),
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'UpdatedBy': UpdatedBy,
        'DocName': DocName,
        'Rejected': Rejected,
        'RejectedRemark': RejectedRemark,
        'DocNo': DocNo,
        'ApprovalLevel': ApprovalLevel,
      };
}

List<LITPL_AppLog> lITPL_AppLogFromJson(String str) =>
    List<LITPL_AppLog>.from(
        json.decode(str).map((x) => LITPL_AppLog.fromJson(x)));

String lITPL_AppLogToJson(List<LITPL_AppLog> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<LITPL_AppLog>> dataSyncLITPL_AppLog() async {
  var res = await http.get(
      headers: header, Uri.parse(prefix + "LITPL_AppLog" + postfix));
  print(res.body);
  return lITPL_AppLogFromJson(res.body);
}

// Future<void> insertLITPL_AppLog(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteLITPL_AppLog(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncLITPL_AppLog();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('LITPL_AppLog_Temp', customer.toJson());
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
//       "SELECT * FROM  LITPL_AppLog_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("LITPL_AppLog", element,
//         where: "RowId = ? AND TransId = ?",
//         whereArgs: [element["RowId"], element["TransId"]]);
//   });
//   await batch2.commit(noResult: true);
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from LITPL_AppLog_Temp where TransId || RowId not in (Select TransId || RowId from LITPL_AppLog)");
//   v.forEach((element) {
//     batch3.insert('LITPL_AppLog', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('LITPL_AppLog_Temp');
// }

Future<void> insertLITPL_AppLog(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteLITPL_AppLog(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncLITPL_AppLog();
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
      for (LITPL_AppLog record in batchRecords) {
        try {
          batch.insert('LITPL_AppLog_Temp', record.toJson());
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
			select * from LITPL_AppLog_Temp
			except
			select * from LITPL_AppLog
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
          batch.update("LITPL_AppLog", element,
              where: "RowId = ? AND TransId = ?",
              whereArgs: [element["RowId"], element["TransId"]]);
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
  print('Time taken for LITPL_AppLog update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from LITPL_AppLog_Temp where TransId || RowId not in (Select TransId || RowId from LITPL_AppLog)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM LITPL_AppLog_Temp T0
LEFT JOIN LITPL_AppLog T1 ON T0.TransId = T1.TransId AND T0.RowId = T1.RowId
WHERE T1.TransId IS NULL AND T1.RowId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('LITPL_AppLog', record);
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
      'Time taken for LITPL_AppLog_Temp and LITPL_AppLog compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('LITPL_AppLog_Temp');
  // stopwatch.stop();
}


Future<List<LITPL_AppLog>> retrieveLITPL_AppLog(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('LITPL_AppLog');
  return queryResult.map((e) => LITPL_AppLog.fromJson(e)).toList();
}

Future<void> updateLITPL_AppLog(int id, Map<String, dynamic> values,
    BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('LITPL_AppLog', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deleteLITPL_AppLog(Database db) async {
  await db.delete('LITPL_AppLog');
}

Future<List<LITPL_AppLog>> retrieveLITPL_AppLogById(BuildContext? context,
    String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
  await db.query('LITPL_AppLog', where: str, whereArgs: l);
  return queryResult.map((e) => LITPL_AppLog.fromJson(e)).toList();
}

Future<void> insertLITPL_AppLogToServer(BuildContext? context,
    {String? TransId, int? id}) async {
  String response = "";
  List<LITPL_AppLog> list = await retrieveLITPL_AppLogById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "TransId = ? AND ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].AppLogID = 0;
    var res = await http.post(Uri.parse(prefix + "LITPL_AppLog/Add"),
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
        var res = await http
            .post(Uri.parse(prefix + "LITPL_AppLog/Add"),
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
        if (res.statusCode == 201 || res.statusCode == 500) {
          sentSuccessInServer = true;
          if (res.statusCode == 201) {
            map['ID'] = jsonDecode(res.body)['ID'];
            final Database db = await initializeDB(context);
            map = jsonDecode(res.body);
            map["has_created"] = 0;
            var x = await db.update("LITPL_AppLog", map,
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

Future<void> updateLITPL_AppLogOnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<LITPL_AppLog> list = await retrieveLITPL_AppLogById(
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
          .put(Uri.parse(prefix + 'LITPL_AppLog/Update'),
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
          var x = await db.update("LITPL_AppLog", map,
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
