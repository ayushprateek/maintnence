import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

class MNOCLD {
  int? ID;
  String? PermanentTransId;
  String? TripTransId;
  String? TransId;
  int? DocEntry;
  String? DocNum;
  String? Canceled;
  String? DocStatus;
  String? ApprovalStatus;
  String? CheckListStatus;
  String? ObjectCode;
  String? EquipmentCode;
  String? EquipmentName;
  String? CheckListCode;
  String? CheckListName;
  String? WorkCenterCode;
  String? WorkCenterName;
  DateTime? OpenDate;
  DateTime? CloseDate;
  DateTime? PostingDate;
  DateTime? ValidUntill;
  DateTime? LastReadingDate;
  String? LastReading;
  String? AssignedUserCode;
  String? AssignedUserName;
  String? MNJCTransId;
  String? Remarks;
  String? CreatedBy;
  String? UpdatedBy;
  String? BranchId;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  String? CurrentReading;
  bool? IsConsumption;
  bool? IsRequest;
  bool hasCreated;
  bool hasUpdated;

  MNOCLD({
    this.ID,
    this.PermanentTransId,
    this.TripTransId,
    this.TransId,
    this.DocEntry,
    this.DocNum,
    this.Canceled,
    this.DocStatus,
    this.ApprovalStatus,
    this.CheckListStatus,
    this.ObjectCode,
    this.EquipmentCode,
    this.EquipmentName,
    this.CheckListCode,
    this.CheckListName,
    this.WorkCenterCode,
    this.WorkCenterName,
    this.OpenDate,
    this.CloseDate,
    this.PostingDate,
    this.ValidUntill,
    this.LastReadingDate,
    this.LastReading,
    this.AssignedUserCode,
    this.AssignedUserName,
    this.MNJCTransId,
    this.Remarks,
    this.CreatedBy,
    this.UpdatedBy,
    this.BranchId,
    this.CreateDate,
    this.UpdateDate,
    this.CurrentReading,
    this.IsConsumption,
    this.IsRequest,
    this.hasCreated = false,
    this.hasUpdated = false,
  });

  factory MNOCLD.fromJson(Map<String, dynamic> json) => MNOCLD(
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        PermanentTransId: json['PermanentTransId']?.toString() ?? '',
    TripTransId: json['TripTransId']?.toString() ?? '',
        TransId: json['TransId']?.toString() ?? '',
        DocEntry: int.tryParse(json['DocEntry'].toString()) ?? 0,
        DocNum: json['DocNum']?.toString() ?? '',
        Canceled: json['Canceled']?.toString() ?? '',
        DocStatus: json['DocStatus']?.toString() ?? '',
        hasCreated: json['has_created'] == 1,
        hasUpdated: json['has_updated'] == 1,
        ApprovalStatus: json['ApprovalStatus']?.toString() ?? '',
        CheckListStatus: json['CheckListStatus']?.toString() ?? '',
        ObjectCode: json['ObjectCode']?.toString() ?? '',
        EquipmentCode: json['EquipmentCode']?.toString() ?? '',
        EquipmentName: json['EquipmentName']?.toString() ?? '',
        CheckListCode: json['CheckListCode']?.toString() ?? '',
        CheckListName: json['CheckListName']?.toString() ?? '',
        WorkCenterCode: json['WorkCenterCode']?.toString() ?? '',
        WorkCenterName: json['WorkCenterName']?.toString() ?? '',
        OpenDate: DateTime.tryParse(json['OpenDate'].toString()),
        CloseDate: DateTime.tryParse(json['CloseDate'].toString()),
        PostingDate: DateTime.tryParse(json['PostingDate'].toString()),
        ValidUntill: DateTime.tryParse(json['ValidUntill'].toString()),
        LastReadingDate: DateTime.tryParse(json['LastReadingDate'].toString()),
        LastReading: json['LastReading']?.toString() ?? '',
        AssignedUserCode: json['AssignedUserCode']?.toString() ?? '',
        AssignedUserName: json['AssignedUserName']?.toString() ?? '',
        MNJCTransId: json['MNJCTransId']?.toString() ?? '',
        Remarks: json['Remarks']?.toString() ?? '',
        CreatedBy: json['CreatedBy']?.toString() ?? '',
        UpdatedBy: json['UpdatedBy']?.toString() ?? '',
        BranchId: json['BranchId']?.toString() ?? '',
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()),
        CurrentReading: json['CurrentReading']?.toString() ?? '',
        IsConsumption: json['IsConsumption'] is bool
            ? json['IsConsumption']
            : json['IsConsumption'] == 1,
        IsRequest: json['IsRequest'] is bool
            ? json['IsRequest']
            : json['IsRequest'] == 1,
      );

  Map<String, dynamic> toJson() => {
        'ID': ID,
        'TripTransId': TripTransId,
        'PermanentTransId': PermanentTransId,
        'TransId': TransId,
        'DocEntry': DocEntry,
        'DocNum': DocNum,
        'Canceled': Canceled,
        'DocStatus': DocStatus,
        'ApprovalStatus': ApprovalStatus,
        'CheckListStatus': CheckListStatus,
        'ObjectCode': ObjectCode,
        'EquipmentCode': EquipmentCode,
        'EquipmentName': EquipmentName,
        'CheckListCode': CheckListCode,
        'CheckListName': CheckListName,
        'WorkCenterCode': WorkCenterCode,
        'WorkCenterName': WorkCenterName,
        "has_created": hasCreated ? 1 : 0,
        "has_updated": hasUpdated ? 1 : 0,
        'OpenDate': OpenDate?.toIso8601String(),
        'CloseDate': CloseDate?.toIso8601String(),
        'PostingDate': PostingDate?.toIso8601String(),
        'ValidUntill': ValidUntill?.toIso8601String(),
        'LastReadingDate': LastReadingDate?.toIso8601String(),
        'LastReading': LastReading,
        'AssignedUserCode': AssignedUserCode,
        'AssignedUserName': AssignedUserName,
        'MNJCTransId': MNJCTransId,
        'Remarks': Remarks,
        'CreatedBy': CreatedBy,
        'UpdatedBy': UpdatedBy,
        'BranchId': BranchId,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'CurrentReading': CurrentReading,
        'IsConsumption': IsConsumption,
        'IsRequest': IsRequest,
      };
}

List<MNOCLD> mNOCLDFromJson(String str) =>
    List<MNOCLD>.from(json.decode(str).map((x) => MNOCLD.fromJson(x)));

String mNOCLDToJson(List<MNOCLD> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<MNOCLD>> dataSyncMNOCLD() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "MNOCLD" + postfix));
  print(res.body);
  return mNOCLDFromJson(res.body);
}

Future<void> insertMNOCLD(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteMNOCLD(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncMNOCLD();
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
      for (MNOCLD record in batchRecords) {
        try {
          batch.insert('MNOCLD_Temp', record.toJson());
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
			select * from MNOCLD_Temp
			except
			select * from MNOCLD
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
          batch.update("MNOCLD", element,
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
  print('Time taken for MNOCLD update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from MNOCLD_Temp where TransId not in (Select TransId from MNOCLD)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM MNOCLD_Temp T0
LEFT JOIN MNOCLD T1 ON T0.TransId = T1.TransId 
WHERE T1.TransId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('MNOCLD', record);
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
      'Time taken for MNOCLD_Temp and MNOCLD compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('MNOCLD_Temp');
}

Future<List<MNOCLD>> retrieveMNOCLD(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('MNOCLD');
  return queryResult.map((e) => MNOCLD.fromJson(e)).toList();
}

Future<List<MNOCLD>> retrieveMNOCLDFORSEARCH({
  int? limit,
  String? query,
}) async {
  query = "%$query%";
  final Database db = await initializeDB(null);
  final List<Map<String, Object?>> queryResult =
      await db.rawQuery("SELECT * FROM MNOCLD WHERE TransId LIKE '$query'");
  return queryResult.map((e) => MNOCLD.fromJson(e)).toList();
}

Future<void> updateMNOCLD(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('MNOCLD', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deleteMNOCLD(Database db) async {
  await db.delete('MNOCLD');
}

Future<List<MNOCLD>> retrieveMNOCLDById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('MNOCLD', where: str, whereArgs: l);
  return queryResult.map((e) => MNOCLD.fromJson(e)).toList();
}

Future<String> insertMNOCLDToServer(BuildContext? context,
    {String? TransId, int? id}) async {
  String response = "";
  List<MNOCLD> list = await retrieveMNOCLDById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "TransId = ? AND ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "MNOCLD/Add"),
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
            .post(Uri.parse(prefix + "MNOCLD/Add"),
                headers: header, body: jsonEncode(map))
            .timeout(Duration(seconds: 30), onTimeout: () {
          return http.Response('Error', 500);
        });
        response = await res.body;
        print("eeaaae status");
        print(await res.statusCode);
        if (res.statusCode == 409) {
          ///Already added in server
          final Database db = await initializeDB(context);
          MNOCLD model = MNOCLD.fromJson(jsonDecode(res.body));
          map["ID"] = model.ID;
          map["has_created"] = 0;
          var x = await db.update("MNOCLD", map,
              where: "TransId = ?", whereArgs: [model.TransId]);
          print(x.toString());
        } else if (res.statusCode == 201 || res.statusCode == 500) {
          sentSuccessInServer = true;
          if (res.statusCode == 201) {
            map['ID'] = jsonDecode(res.body)['ID'];
            final Database db = await initializeDB(context);
            // map=jsonDecode(res.body);
            map["has_created"] = 0;
            var x = await db.update("MNOCLD", map,
                where: "TransId = ? AND RowId = ?",
                whereArgs: [map["TransId"], map["RowId"]]);
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
  return response;
}

Future<void> updateMNOCLDOnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<MNOCLD> list = await retrieveMNOCLDById(
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
          .put(Uri.parse(prefix + 'MNOCLD/Update'),
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
          var x = await db.update("MNOCLD", map,
              where: "TransId = ? AND RowId = ?",
              whereArgs: [map["TransId"], map["RowId"]]);
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
