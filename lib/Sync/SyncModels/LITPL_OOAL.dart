import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:maintenance/main.dart';
import 'package:sqflite/sqlite_api.dart';

class LITPL_OOAL {
  int? ALID;
  int? ACID;
  int? TransDocID;
  int? Level;
  String? RejectRemarks;
  String? BranchId;
  String? TransId;
  String? AUserName;
  String? AUserCode;
  String? OUserCode;
  String? DocStatus;
  String? OUserName;
  String? CreatedBy;
  String? DocNum;
  int? DocID;
  int? DocEntry;
  DateTime? CreatedDate;
  DateTime? UpdateDate;
  DateTime? DocDate;
  String? Remark;
  bool? Approve;
  bool? Reject;
  bool hasCreated;
  bool hasUpdated;

  LITPL_OOAL({
    this.RejectRemarks,
    this.ALID,
    this.BranchId,
    this.ACID,
    this.TransDocID,
    this.TransId,
    this.hasCreated = false,
    this.hasUpdated = false,
    this.Level,
    this.DocStatus,
    this.AUserName,
    this.AUserCode,
    this.OUserCode,
    this.OUserName,
    this.DocNum,
    this.DocID,
    this.DocDate,
    this.Remark,
    this.CreatedDate,
    this.UpdateDate,
    this.CreatedBy,
    this.Approve,
    this.Reject,
    this.DocEntry,
  });

  factory LITPL_OOAL.fromJson(Map<String, dynamic> json) => LITPL_OOAL(
        ALID: int.tryParse(json['ALID'].toString()) ?? 0,
        TransDocID: int.tryParse(json['TransDocID'].toString()) ?? 0,
        ACID: int.tryParse(json['ACID'].toString()) ?? 0,
        Level: int.tryParse(json['Level'].toString()) ?? 0,
        BranchId: json['BranchId'] ?? '',
        RejectRemarks: json['RejectRemarks'] ?? '',
        AUserName: json['AUserName'] ?? '',
        DocStatus: json['DocStatus'] ?? '',
        OUserCode: json['OUserCode'] ?? '',
        hasCreated: json['has_created'] == 1,
        hasUpdated: json['has_updated'] == 1,
        AUserCode: json['AUserCode'] ?? '',
        OUserName: json['OUserName'] ?? '',
        CreatedBy: json['CreatedBy'] ?? '',
        TransId: json['TransId'] ?? '',
        DocEntry: json['DocEntry'],
        DocNum: json['DocNum'] ?? '',
        DocID: int.tryParse(json['DocID'].toString()) ?? 0,
        CreatedDate: DateTime.tryParse(json['CreatedDate'].toString()),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()),
        DocDate: DateTime.tryParse(json['DocDate'].toString()),
        Remark: json['Remark'] ?? '',
        Approve:
            json['Approve'] is bool ? json['Approve'] : json['Approve'] == 1,
        Reject: json['Reject'] is bool ? json['Reject'] : json['Reject'] == 1,
      );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'ALID': ALID,
      'RejectRemarks': RejectRemarks,
      'TransDocID': TransDocID??0,
      'BranchId': BranchId,
      'ACID': ACID,
      'Level': Level,
      'TransId': TransId,
      'DocStatus': DocStatus,
      'AUserCode': AUserCode,
      'AUserName': AUserName,
      "has_created": hasCreated ? 1 : 0,
      "has_updated": hasUpdated ? 1 : 0,
      'OUserCode': OUserCode,
      'OUserName': OUserName,
      'DocNum': DocNum,
      'DocID': DocID,
      'DocEntry': DocEntry,
      'CreatedDate': CreatedDate?.toIso8601String(),
      'UpdateDate': UpdateDate?.toIso8601String(),
      'DocDate': DocDate?.toIso8601String(),
      'Remark': Remark,
      'CreatedBy': CreatedBy,
      'Approve': Approve,
      'Reject': Reject,
    };
    return map;
  }
}

List<LITPL_OOAL> lITPL_OOALFromJson(String str) =>
    List<LITPL_OOAL>.from(json.decode(str).map((x) => LITPL_OOAL.fromJson(x)));

String lITPL_OOALToJson(List<LITPL_OOAL> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<LITPL_OOAL>> dataSyncLITPL_OOAL() async {
  var res = await http.get(
      headers: header, Uri.parse(prefix + "LITPL_OOAL" + postfix));
  print(res.body);
  return lITPL_OOALFromJson(res.body);
}

// Future<void> insertLITPL_OOAL(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteLITPL_OOAL(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncLITPL_OOAL();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('LITPL_OOAL_Temp', customer.toJson());
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
//       "SELECT * FROM  LITPL_OOAL_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (DocDate)");
//   u.forEach((element) {
//     LITPL_OOAL ooal = LITPL_OOAL.fromJson(element);
//     print(ooal.toJson());
//     batch2.update("LITPL_OOAL", ooal.toJson(),
//         where: "ALID = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["ALID"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from LITPL_OOAL_Temp where ALID not in (Select ALID from LITPL_OOAL)");
//   v.forEach((element) {
//     batch3.insert('LITPL_OOAL', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('LITPL_OOAL_Temp');
// }
Future<void> insertLITPL_OOAL(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteLITPL_OOAL(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncLITPL_OOAL();
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
      for (LITPL_OOAL record in batchRecords) {
        try {
          batch.insert('LITPL_OOAL_Temp', record.toJson());
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
			select * from LITPL_OOAL_Temp
			except
			select * from LITPL_OOAL
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
          batch.update("LITPL_OOAL", element,
              where:
                  "AUserCode = ? AND TransId = ? AND Level = ? AND Approve = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
              whereArgs: [
                element["AUserCode"],
                element["TransId"],
                element["Level"],
                element["Approve"],
                1,
                1
              ]);
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
  print('Time taken for LITPL_OOAL update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from LITPL_OOAL_Temp where ALID not in (Select ALID from LITPL_OOAL)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM LITPL_OOAL_Temp T0
LEFT JOIN LITPL_OOAL T1 ON T0.ALID = T1.ALID 
WHERE T1.ALID IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('LITPL_OOAL', record);
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
      'Time taken for LITPL_OOAL_Temp and LITPL_OOAL compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('LITPL_OOAL_Temp');
  // stopwatch.stop();
}

Future<List<LITPL_OOAL>> retrieveLITPL_OOAL(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('LITPL_OOAL');
  return queryResult.map((e) => LITPL_OOAL.fromJson(e)).toList();
}

Future<void> updateLITPL_OOAL(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('LITPL_OOAL', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deleteLITPL_OOAL(Database db) async {
  await db.delete('LITPL_OOAL');
}

Future<List<LITPL_OOAL>> retrieveLITPL_OOALById(
    BuildContext? context, String str, List l,
    {String? orderBy, int? limit}) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('LITPL_OOAL',
      where: str, whereArgs: l, orderBy: orderBy, limit: limit);
  return queryResult.map((e) => LITPL_OOAL.fromJson(e)).toList();
}

Future<List<LITPL_OOAL>> retrieveLITPL_OOALUnApprovedDoc(
    {required String TransId}) async {
  final Database db = await initializeDB(null);
  String query='''
        SELECT Max(ooal.Level),(ooal.Level),ooal.ACID,ooal.ALID,ooal.Approve,ooal.Reject,ooal.AUserCode,
ooal.DocStatus,ooal.TransDocID,ooal.RejectRemarks,ooal.BranchId,ooal.TransId,ooal.AUserName,
ooal.AUserCode,ooal.OUserCode,ooal.DocStatus,ooal.OUserName,ooal.CreatedBy,ooal.DocNum,
ooal.DocID,ooal.DocEntry,ooal.CreatedDate,ooal.UpdateDate,ooal.DocDate,ooal.Remark,ooal.Approve,ooal.Reject
 FROM LITPL_OOAL ooal 
        WHERE ooal.TransId='$TransId' 
        AND ooal.Level=(SELECT MAX(ooal1.Level) as Level FROM LITPL_OOAL ooal1 
        WHERE ooal1.TransId='$TransId' AND ooal1.DocStatus<>'Approved')
        AND ooal.Approve=0 AND ooal.Reject=0 
        AND ooal.AUserCode='${userModel.UserCode}'
		group by ooal.Level,ooal.ACID,ooal.ALID,ooal.Approve,ooal.Reject,ooal.AUserCode,
                 ooal.DocStatus,ooal.TransDocID,ooal.RejectRemarks,ooal.BranchId,ooal.TransId,ooal.AUserName,
                 ooal.AUserCode,ooal.OUserCode,ooal.DocStatus,ooal.OUserName,ooal.CreatedBy,ooal.DocNum,
                 ooal.DocID,ooal.DocEntry,ooal.CreatedDate,ooal.UpdateDate,ooal.DocDate,ooal.Remark,ooal.Approve,ooal.Reject
        ''';
  final List<Map<String, Object?>> queryResult = await db.rawQuery(query);
  return queryResult.map((e) => LITPL_OOAL.fromJson(e)).toList();
}
Future<List<LITPL_OOAL>> getLITPL_OOALApprovalData({
  required Database db
}) async {
  final List<Map<String, Object?>> queryResult = await db.rawQuery('''
  SELECT litplooal.* from   LITPL_OOAL litplooal
                     inner join  LITPL_OAC2 ooac2 on litplooal.Level = ooac2.Level
                     inner join LITPL_OOAC on ooac2.ACID = LITPL_OOAC.ACID
                     where
                     ooac2.UserCode = '${userModel.UserCode}' AND
                     LITPL_OOAC.Active = 1 AND
                     litplooal.AUserCode = '${userModel.UserCode}' AND
                     LITPL_OOAC.DocID IN (SELECT Distinct DocID FROM LITPL_OOAL)
  ''');
  return queryResult.map((e) => LITPL_OOAL.fromJson(e)).toList();
}

Future<List<LITPL_OOAL>> retrieveLITPL_OOALGroupByDocNum() async {
  final Database db = await initializeDB(null);
  final List<Map<String, Object?>> queryResult = await db.rawQuery(
      "SELECT * FROM LITPL_OOAL where AUserCode = '${userModel.UserCode}' and Approve=0 and Reject=0 group by DocNum");
  return queryResult.map((e) => LITPL_OOAL.fromJson(e)).toList();
}

Future<void> insertLITPL_OOALToServer(BuildContext? context,
    {String? TransId, int? id}) async {
  String response = "";
  List<LITPL_OOAL> list = await retrieveLITPL_OOALById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "TransId = ? AND ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ALID = 0;

    var res = await http.post(Uri.parse(prefix + "LITPL_OOAL/Add"),
        headers: header, body: jsonEncode(list[0].toJson()));
    response = res.body;
  } else if (list.isNotEmpty) {
    int i = 0;
    bool sentSuccessInServer = false;
    if (list.isEmpty) {
      return;
    }
    do {
      Map<String, dynamic> map = list[i].toJson();
      sentSuccessInServer = false;
      try {
        map.remove('ALID');
        print(jsonEncode(map));
        var res = await http
            .post(Uri.parse(prefix + "LITPL_OOAL/Add"),
                headers: header, body: jsonEncode(map))
            .timeout(Duration(seconds: 30), onTimeout: () {
          writeToLogFile(
              text: '500 error \nMap : $map',
              fileName: StackTrace.current.toString(),
              lineNo: 141);
          return http.Response('Error', 500);
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
            map['ALID'] = jsonDecode(res.body)['ALID'];
            final Database db = await initializeDB(context);
            // map = jsonDecode(res.body);
            map["has_created"] = 0;

            Map element = list[i].toJson();
            var x = await db.update("LITPL_OOAL", map,
                where:
                    "AUserCode = ? AND TransId = ? AND Level = ? AND Approve = ?",
                whereArgs: [
                  element["AUserCode"],
                  element["TransId"],
                  element["Level"],
                  element["Approve"]
                ]);
            print(x.toString());
          } else {
            writeToLogFile(
                text: '500 error \nMap : $map',
                fileName: StackTrace.current.toString(),
                lineNo: 141);
          }
        }
        print(res.body);
      } catch (e) {
        writeToLogFile(
            text: '${e.toString()}\nMap : $map',
            fileName: StackTrace.current.toString(),
            lineNo: 141);
        sentSuccessInServer = true;
      }
      i++;
      print("INDEX = " + i.toString());
    } while (i < list.length && sentSuccessInServer == true);
  }
}

Future<void> updateLITPL_OOALOnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<LITPL_OOAL> list = await retrieveLITPL_OOALById(
      context,
      l == null ? DataSync.getUpdateOnServerStr() : condition ?? "",
      l == null ? DataSync.getUpdateOnServerList() : l);
  print(list);
  if (list.isNotEmpty) {
    int i = 0;
    bool sentSuccessInServer = false;
    if (list.isEmpty) {
      return;
    }
    do {
      Map<String, dynamic> map = list[i].toJson();
      sentSuccessInServer = false;
      try {
        var res = await http
            .put(Uri.parse(prefix + 'LITPL_OOAL/Update'),
                headers: header, body: jsonEncode(map))
            .timeout(Duration(seconds: 30), onTimeout: () {
          writeToLogFile(
              text: '500 error \nMap : $map',
              fileName: StackTrace.current.toString(),
              lineNo: 141);
          return http.Response('Error', 500);
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
            var x = await db.update("LITPL_OOAL", map,
                where:
                    "AUserCode = ? AND TransId = ? AND Level = ? AND Approve = ?",
                whereArgs: [
                  map["AUserCode"],
                  map["TransId"],
                  map["Level"],
                  map["Approve"]
                ]);
            print(x.toString());
          } else {
            writeToLogFile(
                text: '500 error \nMap : $map',
                fileName: StackTrace.current.toString(),
                lineNo: 141);
          }
        }
        print(res.body);
      } catch (e) {
        writeToLogFile(
            text: '${e.toString()}\nMap : $map',
            fileName: StackTrace.current.toString(),
            lineNo: 141);
        sentSuccessInServer = true;
      }

      i++;
      print("INDEX = " + i.toString());
    } while (i < list.length && sentSuccessInServer == true);
  }
}
