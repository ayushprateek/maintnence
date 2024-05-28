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

class OCRO {
  int? ID;
  String? TransId;
  DateTime? DocDate;
  String? EmpId;
  String? EmpName;
  String? EmpGroupId;
  String? EmpDesc;
  String? Remarks;
  bool? Active;
  double? RequestedAmt;
  double? ApprovedAmt;
  String? ApprovedBy;
  String? ApprovedByDesc;
  DateTime? ApprovedDate;
  DateTime? FromDate;
  DateTime? ToDate;
  double? Factor;
  double? AdditionalCash;
  double? AdditionalApprovedCash;
  DateTime? ReconDate;
  double? ReconAmt;
  String? ReconStatus;
  String? ReconBy;
  String? ApprovalStatus;
  String? RPTransId;
  String? CreatedBy;
  String? Currency;
  double? Rate;
  int? DocEntry;
  String? DocNum;
  String? DraftKey;
  String? Error;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  String? UpdatedBy;
  String? BranchId;
  String? LocalDate;

  OCRO({
    this.ID,
    this.TransId,
    this.DocDate,
    this.EmpId,
    this.EmpName,
    this.EmpGroupId,
    this.EmpDesc,
    this.Remarks,
    this.Active,
    this.RequestedAmt,
    this.ApprovedAmt,
    this.ApprovedBy,
    this.ApprovedByDesc,
    this.ApprovedDate,
    this.FromDate,
    this.ToDate,
    this.Factor,
    this.AdditionalCash,
    this.AdditionalApprovedCash,
    this.ReconDate,
    this.ReconAmt,
    this.ReconStatus,
    this.ReconBy,
    this.ApprovalStatus,
    this.RPTransId,
    this.CreatedBy,
    this.Currency,
    this.Rate,
    this.DocEntry,
    this.DocNum,
    this.DraftKey,
    this.Error,
    this.CreateDate,
    this.UpdateDate,
    this.UpdatedBy,
    this.BranchId,
    this.LocalDate,
  });

  factory OCRO.fromJson(Map<String, dynamic> json) =>
      OCRO(
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        TransId: json['TransId'] ?? '',
        DocDate: DateTime.tryParse(json['DocDate'].toString()) ??
            DateTime.parse('1900-01-01'),
        EmpId: json['EmpId'] ?? '',
        EmpName: json['EmpName'] ?? '',
        EmpGroupId: json['EmpGroupId'] ?? '',
        EmpDesc: json['EmpDesc'] ?? '',
        Remarks: json['Remarks'] ?? '',
        Active: json['Active'] is bool ? json['Active'] : json['Active'] == 1,
        RequestedAmt: double.tryParse(json['RequestedAmt'].toString()) ?? 0.0,
        ApprovedAmt: double.tryParse(json['ApprovedAmt'].toString()) ?? 0.0,
        ApprovedBy: json['ApprovedBy'] ?? '',
        ApprovedByDesc: json['ApprovedByDesc'] ?? '',
        ApprovedDate: DateTime.tryParse(json['ApprovedDate'].toString()) ??
            DateTime.parse('1900-01-01'),
        FromDate: DateTime.tryParse(json['FromDate'].toString()) ??
            DateTime.parse('1900-01-01'),
        ToDate: DateTime.tryParse(json['ToDate'].toString()) ??
            DateTime.parse('1900-01-01'),
        Factor: double.tryParse(json['Factor'].toString()) ?? 0.0,
        AdditionalCash:
        double.tryParse(json['AdditionalCash'].toString()) ?? 0.0,
        AdditionalApprovedCash:
        double.tryParse(json['AdditionalApprovedCash'].toString()) ?? 0.0,
        ReconDate: DateTime.tryParse(json['ReconDate'].toString()) ??
            DateTime.parse('1900-01-01'),
        ReconAmt: double.tryParse(json['ReconAmt'].toString()) ?? 0.0,
        ReconStatus: json['ReconStatus'] ?? '',
        ReconBy: json['ReconBy'] ?? '',
        ApprovalStatus: json['ApprovalStatus'] ?? '',
        RPTransId: json['RPTransId'] ?? '',
        CreatedBy: json['CreatedBy'] ?? '',
        Currency: json['Currency'] ?? '',
        Rate: double.tryParse(json['Rate'].toString()) ?? 0.0,
        DocEntry: int.tryParse(json['DocEntry'].toString()),
        DocNum: json['DocNum'] ?? '',
        DraftKey: json['DraftKey'] ?? '',
        Error: json['Error'] ?? '',
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()) ??
            DateTime.parse('1900-01-01'),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()) ??
            DateTime.parse('1900-01-01'),
        UpdatedBy: json['UpdatedBy'] ?? '',
        BranchId: json['BranchId'] ?? '',
        LocalDate: json['LocalDate'] ?? '',
      );

  Map<String, dynamic> toJson() =>
      {
        'ID': ID,
        'TransId': TransId,
        'DocDate': DocDate?.toIso8601String(),
        'EmpId': EmpId,
        'EmpName': EmpName,
        'EmpGroupId': EmpGroupId,
        'EmpDesc': EmpDesc,
        'Remarks': Remarks,
        'Active': Active,
        'RequestedAmt': RequestedAmt,
        'ApprovedAmt': ApprovedAmt,
        'ApprovedBy': ApprovedBy,
        'ApprovedByDesc': ApprovedByDesc,
        'ApprovedDate': ApprovedDate?.toIso8601String(),
        'FromDate': FromDate?.toIso8601String(),
        'ToDate': ToDate?.toIso8601String(),
        'Factor': Factor,
        'AdditionalCash': AdditionalCash,
        'AdditionalApprovedCash': AdditionalApprovedCash,
        'ReconDate': ReconDate?.toIso8601String(),
        'ReconAmt': ReconAmt,
        'ReconStatus': ReconStatus,
        'ReconBy': ReconBy,
        'ApprovalStatus': ApprovalStatus,
        'RPTransId': RPTransId,
        'CreatedBy': CreatedBy,
        'Currency': Currency,
        'Rate': Rate,
        'DocEntry': DocEntry,
        'DocNum': DocNum,
        'DraftKey': DraftKey,
        'Error': Error,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'UpdatedBy': UpdatedBy,
        'BranchId': BranchId,
        'LocalDate': LocalDate,
      };
}

List<OCRO> oCROFromJson(String str) =>
    List<OCRO>.from(json.decode(str).map((x) => OCRO.fromJson(x)));

String oCROToJson(List<OCRO> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<OCRO>> dataSyncOCRO() async {
  var res =
  await http.get(headers: header, Uri.parse(prefix + "OCRO" + postfix));
  print(res.body);
  return oCROFromJson(res.body);
}

// Future<void> insertOCRO(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteOCRO(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncOCRO();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('OCRO_Temp', customer.toJson());
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
//       "SELECT * FROM  OCRO_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("OCRO", element,
//         where: "RowId = ? AND TransId = ?",
//         whereArgs: [element["RowId"], element["TransId"]]);
//   });
//   await batch2.commit(noResult: true);
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from OCRO_Temp where TransId || RowId not in (Select TransId || RowId from OCRO)");
//   v.forEach((element) {
//     batch3.insert('OCRO', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('OCRO_Temp');
// }
Future<void> insertOCRO(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteOCRO(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncOCRO();
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
      for (OCRO record in batchRecords) {
        try {
          batch.insert('OCRO_Temp', record.toJson());
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
			select * from OCRO_Temp
			except
			select * from OCRO
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
          batch.update("OCRO", element,
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
  print('Time taken for OCRO update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from OCRO_Temp where TransId || RowId not in (Select TransId || RowId from OCRO)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM OCRO_Temp T0
LEFT JOIN OCRO T1 ON T0.TransId = T1.TransId AND T0.RowId = T1.RowId
WHERE T1.TransId IS NULL AND T1.RowId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('OCRO', record);
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
      'Time taken for OCRO_Temp and OCRO compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('OCRO_Temp');
  // stopwatch.stop();
}

Future<List<OCRO>> retrieveOCRO(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('OCRO');
  return queryResult.map((e) => OCRO.fromJson(e)).toList();
}

Future<void> updateOCRO(int id, Map<String, dynamic> values,
    BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('OCRO', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deleteOCRO(Database db) async {
  await db.delete('OCRO');
}

Future<List<OCRO>> retrieveOCROById(BuildContext? context, String str,
    List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
  await db.query('OCRO', where: str, whereArgs: l);
  return queryResult.map((e) => OCRO.fromJson(e)).toList();
}

Future<void> insertOCROToServer(BuildContext? context,
    {String? TransId, int? id}) async {
  String response = "";
  List<OCRO> list = await retrieveOCROById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "TransId = ? AND ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "OCRO/Add"),
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
            .post(Uri.parse(prefix + "OCRO/Add"),
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
            // map = jsonDecode(res.body);
            map["has_created"] = 0;
            var x = await db.update("OCRO", map,
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

Future<void> updateOCROOnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<OCRO> list = await retrieveOCROById(
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
          .put(Uri.parse(prefix + 'OCRO/Update'),
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
          var x = await db.update("OCRO", map,
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
