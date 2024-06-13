import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

class OCSH {
  int? ID;
  int? DocEntry;
  String? Error;
  String? DocNum;
  String? Currency;
  String? DocStatus;
  String? ApprovalStatus;
  String? RPTransId;
  String? TransId;
  String? PermanentTransId;
  DateTime? PostingDate;
  String? CRTransId;
  double? Amount;

  // double? OpenAmt;
  double? Rate;
  double? Cash;
  String? Remarks;
  String? CreatedBy;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  String? UpdatedBy;
  String? BranchId;
  String? LocalDate;
  bool hasCreated;
  bool hasUpdated;

  OCSH({
    this.ID,
    this.Error,
    this.RPTransId,
    this.Currency,
    this.Rate,
    this.DocNum,
    this.DocEntry,
    this.DocStatus,
    this.ApprovalStatus,
    this.TransId,
    this.PermanentTransId,
    this.PostingDate,
    this.hasCreated = false,
    this.hasUpdated = false,
    this.CRTransId,
    this.Amount,
    // this.OpenAmt,
    this.Cash,
    this.Remarks,
    this.CreatedBy,
    this.CreateDate,
    this.UpdateDate,
    this.UpdatedBy,
    this.BranchId,
    this.LocalDate,
  });

  factory OCSH.fromJson(Map<String, dynamic> json) => OCSH(
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        DocEntry: int.tryParse(json['DocEntry'].toString()) ?? 0,
        Error: json['Error'] ?? '',
        Currency: json['Currency'] ?? '',
        RPTransId: json['RPTransId'] ?? '',
        PermanentTransId: json["PermanentTransId"] ?? "",
        DocNum: json['DocNum'] ?? '',
        TransId: json['TransId'] ?? '',
        PostingDate: DateTime.tryParse(json['PostingDate'].toString()) ??
            DateTime.parse('1900-01-01'),
        CRTransId: json['CRTransId'] ?? '',
        Amount: double.tryParse(json['Amount'].toString()) ?? 0.0,
        Rate: double.tryParse(json['Rate'].toString()) ?? 0.0,
        // OpenAmt: double.tryParse(json['OpenAmt'].toString()) ?? 0.0,
        Cash: double.tryParse(json['Cash'].toString()) ?? 0.0,
        ApprovalStatus: json['ApprovalStatus'] ?? '',
        Remarks: json['Remarks'] ?? '',
        DocStatus: json['DocStatus'] ?? '',
        CreatedBy: json['CreatedBy'] ?? '',
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()) ??
            DateTime.parse('1900-01-01'),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()) ??
            DateTime.parse('1900-01-01'),
        UpdatedBy: json['UpdatedBy'] ?? '',
        hasCreated: json['has_created'] is bool
            ? json['has_created']
            : json['has_created'] == 1,
        hasUpdated: json['has_updated'] is bool
            ? json['has_updated']
            : json['has_updated'] == 1,
        BranchId: json['BranchId'] ?? '',
        LocalDate: json['LocalDate'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'ID': ID,
        'Rate': Rate,
        'RPTransId': RPTransId,
        "PermanentTransId": PermanentTransId,
        'Currency': Currency,
        'DocEntry': DocEntry,
        'TransId': TransId,
        'PostingDate': PostingDate?.toIso8601String(),
        'DocStatus': DocStatus,
        'ApprovalStatus': ApprovalStatus,
        'CRTransId': CRTransId,
        'Error': Error,
        'Amount': Amount,
        // 'OpenAmt': OpenAmt,
        'Cash': Cash,
        'Remarks': Remarks,
        'CreatedBy': CreatedBy,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'UpdatedBy': UpdatedBy,
        'BranchId': BranchId,
        'LocalDate': LocalDate,
        "has_created": hasCreated ? 1 : 0,
        "has_updated": hasUpdated ? 1 : 0,
      };
}

List<OCSH> oCSHFromJson(String str) =>
    List<OCSH>.from(json.decode(str).map((x) => OCSH.fromJson(x)));

String oCSHToJson(List<OCSH> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<OCSH>> dataSyncOCSH() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "OCSH" + postfix));
  print(res.body);
  return oCSHFromJson(res.body);
}

Future<void> insertOCSH(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteOCSH(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncOCSH();
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
      for (OCSH record in batchRecords) {
        try {
          batch.insert('OCSH_Temp', record.toJson());
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
			select * from OCSH_Temp
			except
			select * from OCSH
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
          batch.update("OCSH", element,
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
  print('Time taken for OCSH update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from OCSH_Temp where TransId not in (Select TransId from OCSH)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM OCSH_Temp T0
LEFT JOIN OCSH T1 ON T0.TransId = T1.TransId 
WHERE T1.TransId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('OCSH', record);
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
      'Time taken for OCSH_Temp and OCSH compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('OCSH_Temp');
  // stopwatch.stop();
}

Future<List<OCSH>> retrieveOCSH(BuildContext? context) async {
  final Database db = await initializeDB(null);
  final List<Map<String, Object?>> queryResult = await db.query('OCSH');
  return queryResult.map((e) => OCSH.fromJson(e)).toList();
}

Future<void> updateOCSH(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    await db.transaction((db) async {
      await db.update('OCSH', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deleteOCSH(Database db) async {
  await db.delete('OCSH');
}

Future<List<OCSH>> retrieveOCSHById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('OCSH', where: str, whereArgs: l);
  return queryResult.map((e) => OCSH.fromJson(e)).toList();
}

Future<void> insertOCSHToServer(BuildContext? context,
    {String? TransId, int? id}) async {
  String response = "";
  List<OCSH> list = await retrieveOCSHById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "TransId = ? AND ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "OCSH/Add"),
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
        map.remove('ID');
        String queryParams = 'TransId=${list[i].TransId}';
        var res = await http
            .post(Uri.parse(prefix + "OCSH/Add?$queryParams"),
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
        if (res.statusCode != 201) {
          await writeToLogFile(
              text:
                  '${res.statusCode} error \nMap : $map\nResponse : ${res.body}',
              fileName: StackTrace.current.toString(),
              lineNo: 141);
        }
        if (res.statusCode == 409) {
          ///Already added in server
          final Database db = await initializeDB(context);
          OCSH model = OCSH.fromJson(jsonDecode(res.body));
          var x = await db.update("OCSH", model.toJson(),
              where: "TransId = ?", whereArgs: [model.TransId]);
          print(x.toString());
        } else if (res.statusCode == 201 || res.statusCode == 500) {
          sentSuccessInServer = true;
          if (res.statusCode == 201) {
            final Database db = await initializeDB(context);
            // map = jsonDecode(res.body);
            map['ID'] = jsonDecode(res.body)['ID'];
            map['PermanentTransId'] = jsonDecode(res.body)['PermanentTransId'];
            map["has_created"] = 0;
            var x = await db.update("OCSH", map,
                where: "TransId = ?", whereArgs: [map["TransId"]]);
            print(x.toString());
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

Future<void> updateOCSHOnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<OCSH> list = await retrieveOCSHById(
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
          .put(Uri.parse(prefix + 'OCSH/Update'),
              headers: header, body: jsonEncode(map))
          .timeout(Duration(seconds: 30), onTimeout: () {
        writeToLogFile(
            text: '500 error \nMap : $map',
            fileName: StackTrace.current.toString(),
            lineNo: 141);
        return http.Response('Error', 500);
      });
      print(await res.statusCode);
      if (res.statusCode != 201) {
        await writeToLogFile(
            text:
                '${res.statusCode} error \nMap : $map\nResponse : ${res.body}',
            fileName: StackTrace.current.toString(),
            lineNo: 141);
      }
      if (res.statusCode == 201 || res.statusCode == 500) {
        sentSuccessInServer = true;
        if (res.statusCode == 201) {
          final Database db = await initializeDB(context);
          map["has_updated"] = 0;
          var x = await db.update("OCSH", map,
              where: "TransId = ?", whereArgs: [map["TransId"]]);
          print(x.toString());
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
