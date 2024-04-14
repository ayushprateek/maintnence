import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:maintenance/Sync/SyncModels/OUSR.dart';
import 'package:maintenance/main.dart';
import 'package:sqflite/sqlite_api.dart';

class ORCT {
  int? ID;

  // int? RowId;
  double? PayAmt;
  double? RecoverAmt;
  double? TotalCashHandoverAmt;
  double? TotalExpenseApprovedAmt;
  double? TotalApprovedAmt;
  double? TotalRequestedAmt;
  DateTime? PostingDate;

  String? DocStatus;
  String? CRTransId;
  String? ApprovedBy;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  String? CreatedBy;
  String? BranchId;
  String? UpdatedBy;
  String? TransId;
  String? PermanentTransId;
  String? EmpId;
  String? EmpName;
  String? EmpGroupId;
  String? EmpDesc;
  String? Remarks;
  DateTime? FromDate;
  DateTime? ToDate;

  String? ApprovalStatus;

  String? Currency;
  double? Rate;
  int? DocEntry;
  String? DocNum;
  String? DraftKey;
  String? Error;
  bool hasCreated;
  bool hasUpdated;

  ORCT({
    this.ID,
    this.PayAmt,
    this.CRTransId,
    // this.RowId,
    this.hasCreated = false,
    this.hasUpdated = false,
    this.TotalCashHandoverAmt,
    this.TotalExpenseApprovedAmt,
    this.TotalApprovedAmt,
    this.DocStatus,
    this.RecoverAmt,
    this.TotalRequestedAmt,
    this.PostingDate,
    this.ApprovedBy,
    this.CreateDate,
    this.UpdateDate,
    this.CreatedBy,
    this.BranchId,
    this.UpdatedBy,
    this.TransId,
    this.PermanentTransId,
    this.EmpId,
    this.EmpName,
    this.EmpGroupId,
    this.EmpDesc,
    this.Remarks,
    this.FromDate,
    this.ToDate,
    this.ApprovalStatus,
    this.Currency,
    this.Rate,
    this.DocEntry,
    this.DocNum,
    this.DraftKey,
    this.Error,
  });

  factory ORCT.fromJson(Map<String, dynamic> json) =>
      ORCT(
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        // RowId: int.tryParse(json['RowId'].toString()) ?? 0,
        PostingDate: DateTime.tryParse(json['PostingDate'].toString()) ??
            DateTime.parse('1900-01-01'),
        hasCreated: json['has_created'] == 1,
        hasUpdated: json['has_updated'] == 1,
        RecoverAmt: double.tryParse(json['RecoverAmt'].toString()) ?? 0.0,
        PayAmt: double.tryParse(json['PayAmt'].toString()) ?? 0.0,
        PermanentTransId: json['PermanentTransId'] ?? '',
        DocStatus: json['DocStatus'] ?? '',
        CRTransId: json['CRTransId'] ?? '',
        ApprovedBy: json['ApprovedBy'] ?? '',
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()) ??
            DateTime.parse('1900-01-01'),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()) ??
            DateTime.parse('1900-01-01'),
        CreatedBy: json['CreatedBy'] ?? '',
        BranchId: json['BranchId'] ?? '',
        UpdatedBy: json['UpdatedBy'] ?? '',
        TransId: json['TransId'] ?? '',
        EmpId: json['EmpId'] ?? '',
        EmpName: json['EmpName'] ?? '',
        EmpGroupId: json['EmpGroupId'] ?? '',
        EmpDesc: json['EmpDesc'] ?? '',
        Remarks: json['Remarks'] ?? '',
        FromDate: DateTime.tryParse(json['FromDate'].toString()) ??
            DateTime.parse('1900-01-01'),
        ToDate: DateTime.tryParse(json['ToDate'].toString()) ??
            DateTime.parse('1900-01-01'),
        TotalApprovedAmt:
        double.tryParse(json['TotalApprovedAmt'].toString()) ?? 0.0,
        TotalCashHandoverAmt:
        double.tryParse(json['TotalCashHandoverAmt'].toString()) ?? 0.0,
        TotalExpenseApprovedAmt:
        double.tryParse(json['TotalExpenseApprovedAmt'].toString()) ?? 0.0,
        TotalRequestedAmt:
        double.tryParse(json['TotalRequestedAmt'].toString()) ?? 0.0,
        ApprovalStatus: json['ApprovalStatus'] ?? '',
        Currency: json['Currency'] ?? '',
        Rate: double.tryParse(json['Rate'].toString()) ?? 0.0,
        DocEntry: int.tryParse(json['DocEntry'].toString()),
        DocNum: json['DocNum'] ?? '',
        DraftKey: json['DraftKey'] ?? '',
        Error: json['Error'] ?? '',
      );

  Map<String, dynamic> toJson() =>
      {
        'ID': ID,
        'PermanentTransId': PermanentTransId,
        'DocStatus': DocStatus,
        'PayAmt': PayAmt,
        'RecoverAmt': RecoverAmt,
        'CRTransId': CRTransId,
        // 'RowId': RowId,
        'PostingDate': PostingDate?.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "has_updated": hasUpdated ? 1 : 0,
        'ApprovedBy': ApprovedBy,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'CreatedBy': CreatedBy,
        'BranchId': BranchId,
        'UpdatedBy': UpdatedBy,
        'TransId': TransId,
        'EmpId': EmpId,
        'EmpName': EmpName,
        'EmpGroupId': EmpGroupId,
        'EmpDesc': EmpDesc,
        'Remarks': Remarks,
        'FromDate': FromDate?.toIso8601String(),
        'ToDate': ToDate?.toIso8601String(),
        'ApprovalStatus': ApprovalStatus,
        'Currency': Currency,
        'Rate': Rate,
        'DocEntry': DocEntry,
        'DocNum': DocNum,
        'DraftKey': DraftKey,
        'Error': Error,
        'TotalCashHandoverAmt': TotalCashHandoverAmt,
        'TotalExpenseApprovedAmt': TotalExpenseApprovedAmt,
        'TotalApprovedAmt': TotalApprovedAmt,
        'TotalRequestedAmt': TotalRequestedAmt,
      };
}

List<ORCT> oRCTFromJson(String str) =>
    List<ORCT>.from(json.decode(str).map((x) => ORCT.fromJson(x)));

String oRCTToJson(List<ORCT> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<ORCT>> dataSyncORCT() async {
  var res =
  await http.get(headers: header, Uri.parse(prefix + "ORCT" + postfix));
  print(res.body);
  return oRCTFromJson(res.body);
}

// Future<void> insertORCT(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteORCT(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncORCT();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('ORCT_Temp', customer.toJson());
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
//       "SELECT * FROM  ORCT_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("ORCT", element,
//         where: "RowId = ? AND TransId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["RowId"], element["TransId"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from ORCT_Temp where TransId || RowId not in (Select TransId || RowId from ORCT)");
//   v.forEach((element) {
//     batch3.insert('ORCT', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('ORCT_Temp');
// }
Future<void> insertORCT(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteORCT(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncORCT();
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
      for (ORCT record in batchRecords) {
        try {
          batch.insert('ORCT_Temp', record.toJson());
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
			select * from ORCT_Temp
			except
			select * from ORCT
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
          batch.update("ORCT", element,
              where: "TransId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
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
  print('Time taken for ORCT update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from ORCT_Temp where TransId not in (Select TransId from ORCT)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM ORCT_Temp T0
LEFT JOIN ORCT T1 ON T0.TransId = T1.TransId 
WHERE T1.TransId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('ORCT', record);
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
      'Time taken for ORCT_Temp and ORCT compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('ORCT_Temp');
  // stopwatch.stop();
}

Future<List<ORCT>> retrieveORCT(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('ORCT');
  return queryResult.map((e) => ORCT.fromJson(e)).toList();
}

Future<void> updateORCT(int id, Map<String, dynamic> values,
    BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('ORCT', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deleteORCT(Database db) async {
  await db.delete('ORCT');
}

Future<List<ORCT>> retrieveORCTById(BuildContext? context, String str,
    List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
  await db.query('ORCT', where: str, whereArgs: l);
  return queryResult.map((e) => ORCT.fromJson(e)).toList();
}

Future<List<ORCT>> retrieveORCTByBranch(BuildContext context) async {
  List<String> list = [];
  String str = "CreatedBy = ?";
  List<OUSRModel> ousrModel =
  await retrieveOUSRById(context, "BranchId = ?", [userModel.BranchId]);

  for (int i = 0; i < ousrModel.length; i++) {
    list.add(ousrModel[i].UserCode);
    if (i != 0) {
      str += " AND CreatedBy = ?";
    }
  }
  if (list.isEmpty) {
    str = "";
  }
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
  await db.query("OEXR", where: str, whereArgs: list);
  return queryResult.map((e) => ORCT.fromJson(e)).toList();
}

Future<void> insertORCTToServer(BuildContext? context,
    {String? TransId, int? id}) async {
  String response = "";
  List<ORCT> list = await retrieveORCTById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "TransId = ? AND ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "ORCT/Add"),
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
        String queryParams='TransId=${list[i].TransId}';
        var res = await http.post(Uri.parse(prefix + "ORCT/Add?$queryParams"),
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
          ORCT model=ORCT.fromJson(jsonDecode(res.body));
          var x = await db.update("ORCT", model.toJson(),
              where: "TransId = ?", whereArgs: [model.TransId]);
          print(x.toString());
        }
        else
        if (res.statusCode == 201 || res.statusCode == 500) {
          sentSuccessInServer = true;
          if (res.statusCode == 201) {
            map['ID'] = jsonDecode(res.body)['ID'];
            map['PermanentTransId'] = jsonDecode(res.body)['PermanentTransId'];
            final Database db = await initializeDB(context);
            map = jsonDecode(res.body);
            map["has_created"] = 0;
            var x = await db.update("ORCT", map,
                where: "TransId = ?", whereArgs: [map["TransId"]]);
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

Future<void> updateORCTOnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<ORCT> list = await retrieveORCTById(
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
          .put(Uri.parse(prefix + 'ORCT/Update'),
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
          var x = await db.update("ORCT", map,
              where: "TransId = ?", whereArgs: [map["TransId"]]);
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
