import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

class MNOJCD {
  int? ID;
  String? PermanentTransId;
  int? DocEntry;
  int? DocNum;
  String? TripTransId;
  String? TransId;
  String? Canceled;
  String? ObjectCode;
  String? ApprovalStatus;
  String? DocStatus;
  DateTime? PostingDate;
  DateTime? ValidUntill;
  String? JobCardStatus;
  String? Remarks;
  String? EquipmentCode;
  String? EquipmentName;
  String? CheckListCode;
  String? CheckListName;
  String? WorkCenterCode;
  String? WorkCenterName;
  DateTime? OpenDate;
  DateTime? CloseDate;
  DateTime? LastReadingDate;
  double? LastReading;
  String? AssignedUserCode;
  String? AssignedUserName;
  bool? WarrentyApplicable;
  String? Type;
  String? Subject;
  String? Resolution;
  String? BranchId;
  String? CreatedBy;
  String? UpdatedBy;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  bool? IsConsumption;
  bool? IsRequest;
  bool hasCreated;
  bool hasUpdated;

  MNOJCD({
    this.ID,
    this.PermanentTransId,
    this.DocEntry,
    this.DocNum,
    this.TransId,
    this.TripTransId,
    this.Canceled,
    this.ObjectCode,
    this.ApprovalStatus,
    this.DocStatus,
    this.PostingDate,
    this.ValidUntill,
    this.JobCardStatus,
    this.Remarks,
    this.EquipmentCode,
    this.EquipmentName,
    this.CheckListCode,
    this.CheckListName,
    this.WorkCenterCode,
    this.WorkCenterName,
    this.OpenDate,
    this.CloseDate,
    this.LastReadingDate,
    this.LastReading,
    this.AssignedUserCode,
    this.AssignedUserName,
    this.WarrentyApplicable,
    this.Type,
    this.Subject,
    this.Resolution,
    this.BranchId,
    this.CreatedBy,
    this.UpdatedBy,
    this.CreateDate,
    this.UpdateDate,
    this.IsConsumption,
    this.IsRequest,
    this.hasCreated = false,
    this.hasUpdated = false,
  });

  factory MNOJCD.fromJson(Map<String, dynamic> json) => MNOJCD(
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        PermanentTransId: json['PermanentTransId']?.toString() ?? '',
        DocEntry: int.tryParse(json['DocEntry'].toString()) ?? 0,
        DocNum: int.tryParse(json['DocNum'].toString()) ?? 0,
    TripTransId: json['TripTransId']?.toString() ?? '',
        TransId: json['TransId']?.toString() ?? '',
        Canceled: json['Canceled']?.toString() ?? '',
        ObjectCode: json['ObjectCode']?.toString() ?? '',
        ApprovalStatus: json['ApprovalStatus']?.toString() ?? '',
        DocStatus: json['DocStatus']?.toString() ?? '',
        PostingDate: DateTime.tryParse(json['PostingDate'].toString()),
        ValidUntill: DateTime.tryParse(json['ValidUntill'].toString()),
        JobCardStatus: json['JobCardStatus']?.toString() ?? '',
        Remarks: json['Remarks']?.toString() ?? '',
        EquipmentCode: json['EquipmentCode']?.toString() ?? '',
        EquipmentName: json['EquipmentName']?.toString() ?? '',
        CheckListCode: json['CheckListCode']?.toString() ?? '',
        CheckListName: json['CheckListName']?.toString() ?? '',
        WorkCenterCode: json['WorkCenterCode']?.toString() ?? '',
        WorkCenterName: json['WorkCenterName']?.toString() ?? '',
        OpenDate: DateTime.tryParse(json['OpenDate'].toString()),
        CloseDate: DateTime.tryParse(json['CloseDate'].toString()),
        LastReadingDate: DateTime.tryParse(json['LastReadingDate'].toString()),
        LastReading: double.tryParse(json['LastReading'].toString()),
        AssignedUserCode: json['AssignedUserCode']?.toString() ?? '',
        AssignedUserName: json['AssignedUserName']?.toString() ?? '',
        WarrentyApplicable: json['WarrentyApplicable'] is bool
            ? json['WarrentyApplicable']
            : json['WarrentyApplicable'] == 1,
        Type: json['Type']?.toString() ?? '',
        Subject: json['Subject']?.toString() ?? '',
        Resolution: json['Resolution']?.toString() ?? '',
        BranchId: json['BranchId']?.toString() ?? '',
        CreatedBy: json['CreatedBy']?.toString() ?? '',
        UpdatedBy: json['UpdatedBy']?.toString() ?? '',
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()),
        IsConsumption: json['IsConsumption'] is bool
            ? json['IsConsumption']
            : json['IsConsumption'] == 1,
        IsRequest: json['IsRequest'] is bool
            ? json['IsRequest']
            : json['IsRequest'] == 1,
        hasCreated: json['has_created'] == 1,
        hasUpdated: json['has_updated'] == 1,
      );

  Map<String, dynamic> toJson() => {
        'ID': ID,
        'PermanentTransId': PermanentTransId,
        'TripTransId': TripTransId,
        'DocEntry': DocEntry,
        'DocNum': DocNum,
        'TransId': TransId,
        'Canceled': Canceled,
        'ObjectCode': ObjectCode,
        'ApprovalStatus': ApprovalStatus,
        'DocStatus': DocStatus,
        'PostingDate': PostingDate?.toIso8601String(),
        'ValidUntill': ValidUntill?.toIso8601String(),
        'JobCardStatus': JobCardStatus,
        'Remarks': Remarks,
        'EquipmentCode': EquipmentCode,
        'EquipmentName': EquipmentName,
        'CheckListCode': CheckListCode,
        'CheckListName': CheckListName,
        'WorkCenterCode': WorkCenterCode,
        'WorkCenterName': WorkCenterName,
        'OpenDate': OpenDate?.toIso8601String(),
        'CloseDate': CloseDate?.toIso8601String(),
        'LastReadingDate': LastReadingDate?.toIso8601String(),
        'LastReading': LastReading,
        'AssignedUserCode': AssignedUserCode,
        'AssignedUserName': AssignedUserName,
        'WarrentyApplicable': WarrentyApplicable,
        'Type': Type,
        'Subject': Subject,
        'Resolution': Resolution,
        'BranchId': BranchId,
        'CreatedBy': CreatedBy,
        'UpdatedBy': UpdatedBy,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'IsConsumption': IsConsumption,
        'IsRequest': IsRequest,
        "has_created": hasCreated ? 1 : 0,
        "has_updated": hasUpdated ? 1 : 0,
      };
}

List<MNOJCD> mNOJCDFromJson(String str) =>
    List<MNOJCD>.from(json.decode(str).map((x) => MNOJCD.fromJson(x)));

String mNOJCDToJson(List<MNOJCD> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<MNOJCD>> dataSyncMNOJCD() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "MNOJCD" + postfix));
  print(res.body);
  return mNOJCDFromJson(res.body);
}

Future<List<MNOJCD>> retrieveMNOJCDForSearch({
  int? limit,
  String? query,
}) async {
  query = "%$query%";
  final Database db = await initializeDB(null);
  final List<Map<String, Object?>> queryResult =
      await db.rawQuery("SELECT * FROM MNOJCD WHERE TransId LIKE '$query'");
  return queryResult.map((e) => MNOJCD.fromJson(e)).toList();
}

Future<void> insertMNOJCD(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteMNOJCD(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncMNOJCD();
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
      for (MNOJCD record in batchRecords) {
        try {
          batch.insert('MNOJCD_Temp', record.toJson());
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
			select * from MNOJCD_Temp
			except
			select * from MNOJCD
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
          batch.update("MNOJCD", element,
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
  print('Time taken for MNOJCD update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from MNOJCD_Temp where TransId not in (Select TransId from MNOJCD)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM MNOJCD_Temp T0
LEFT JOIN MNOJCD T1 ON T0.TransId = T1.TransId 
WHERE T1.TransId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('MNOJCD', record);
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
      'Time taken for MNOJCD_Temp and MNOJCD compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('MNOJCD_Temp');
}

Future<List<MNOJCD>> retrieveMNOJCD(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('MNOJCD');
  return queryResult.map((e) => MNOJCD.fromJson(e)).toList();
}

Future<void> updateMNOJCD(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('MNOJCD', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deleteMNOJCD(Database db) async {
  await db.delete('MNOJCD');
}

Future<List<MNOJCD>> retrieveMNOJCDById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('MNOJCD', where: str, whereArgs: l);
  return queryResult.map((e) => MNOJCD.fromJson(e)).toList();
}

Future<String> insertMNOJCDToServer(BuildContext? context,
    {String? TransId, int? id}) async {
  String response = "";
  List<MNOJCD> list = await retrieveMNOJCDById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "TransId = ? AND ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "MNOJCD/Add"),
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
            .post(Uri.parse(prefix + "MNOJCD/Add"),
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
          MNOJCD model = MNOJCD.fromJson(jsonDecode(res.body));
          map["ID"] = model.ID;
          map["has_created"] = 0;
          var x = await db.update("MNOJCD", map,
              where: "TransId = ?", whereArgs: [model.TransId]);
          print(x.toString());
        } else if (res.statusCode == 201 || res.statusCode == 500) {
          sentSuccessInServer = true;
          if (res.statusCode == 201) {
            map['ID'] = jsonDecode(res.body)['ID'];
            final Database db = await initializeDB(context);
            // map=jsonDecode(res.body);
            map["has_created"] = 0;
            var x = await db.update("MNOJCD", map,
                where: "TransId = ?", whereArgs: [map["TransId"]]);
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

Future<void> updateMNOJCDOnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<MNOJCD> list = await retrieveMNOJCDById(
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
          .put(Uri.parse(prefix + 'MNOJCD/Update'),
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
          var x = await db.update("MNOJCD", map,
              where: "TransId = ?", whereArgs: [map["TransId"]]);
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
