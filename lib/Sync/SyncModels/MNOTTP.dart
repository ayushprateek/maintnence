import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

class MNOTTP {
  int? ID;
  String? TransId;
  String? EquipmentCode;
  String? EquipmentName;
  String? RefNo;
  DateTime? PostingDate;
  DateTime? ValidUntill;
  String? ApprovalStatus;
  String? DocStatus;
  String? BaseTransId;
  String? PermanentTransId;
  int? DocEntry;
  String? DocNum;
  String? CreatedBy;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  String? Error;
  bool? IsPosted;
  String? Latitude;
  String? Longitude;
  String? ObjectCode;
  String? Remarks;
  String? BranchId;
  String? UpdatedBy;
  String? PostingAddress;
  String? Type;
  String? GroupName;
  int? hasCreated;
  int? hasUpdated;

  MNOTTP({
    this.ID,
    this.TransId,
    this.EquipmentCode,
    this.EquipmentName,
    this.RefNo,
    this.PostingDate,
    this.ValidUntill,
    this.ApprovalStatus,
    this.DocStatus,
    this.BaseTransId,
    this.PermanentTransId,
    this.DocEntry,
    this.DocNum,
    this.CreatedBy,
    this.CreateDate,
    this.UpdateDate,
    this.Error,
    this.IsPosted,
    this.Latitude,
    this.Longitude,
    this.ObjectCode,
    this.Remarks,
    this.BranchId,
    this.UpdatedBy,
    this.PostingAddress,
    this.Type,
    this.GroupName,
    this.hasCreated,
    this.hasUpdated,
  });

  factory MNOTTP.fromJson(Map<String, dynamic> json) => MNOTTP(
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        TransId: json['TransId'],
        EquipmentCode: json['EquipmentCode'],
        EquipmentName: json['EquipmentName'],
        RefNo: json['RefNo'],
        PostingDate: DateTime.tryParse(json['PostingDate'].toString()),
        ValidUntill: DateTime.tryParse(json['ValidUntill'].toString()),
        ApprovalStatus: json['ApprovalStatus'],
        DocStatus: json['DocStatus'],
        BaseTransId: json['BaseTransId'],
        PermanentTransId: json['PermanentTransId'],
        DocEntry: int.tryParse(json['DocEntry'].toString()) ?? 0,
        DocNum: json['DocNum'],
        CreatedBy: json['CreatedBy'],
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()),
        Error: json['Error'],
        IsPosted:
            json['IsPosted'] is bool ? json['IsPosted'] : json['IsPosted'] == 1,
        Latitude: json['Latitude'],
        Longitude: json['Longitude'],
        ObjectCode: json['ObjectCode'],
        Remarks: json['Remarks'],
        BranchId: json['BranchId'],
        UpdatedBy: json['UpdatedBy'],
        PostingAddress: json['PostingAddress'],
        Type: json['Type'],
        GroupName: json['GroupName'],
        hasCreated: int.tryParse(json['has_created'].toString()) ?? 0,
        hasUpdated: int.tryParse(json['has_updated'].toString()) ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'ID': ID,
        'TransId': TransId,
        'EquipmentCode': EquipmentCode,
        'EquipmentName': EquipmentName,
        'RefNo': RefNo,
        'PostingDate': PostingDate?.toIso8601String(),
        'ValidUntill': ValidUntill?.toIso8601String(),
        'ApprovalStatus': ApprovalStatus,
        'DocStatus': DocStatus,
        'BaseTransId': BaseTransId,
        'PermanentTransId': PermanentTransId,
        'DocEntry': DocEntry,
        'DocNum': DocNum,
        'CreatedBy': CreatedBy,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'Error': Error,
        'IsPosted': IsPosted,
        'Latitude': Latitude,
        'Longitude': Longitude,
        'ObjectCode': ObjectCode,
        'Remarks': Remarks,
        'BranchId': BranchId,
        'UpdatedBy': UpdatedBy,
        'PostingAddress': PostingAddress,
        'Type': Type,
        'GroupName': GroupName,
        'has_created': hasCreated,
        'has_updated': hasUpdated,
      };
}

List<MNOTTP> mNOTTPFromJson(String str) =>
    List<MNOTTP>.from(json.decode(str).map((x) => MNOTTP.fromJson(x)));

String mNOTTPToJson(List<MNOTTP> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<MNOTTP>> dataSyncMNOTTP() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "MNOTTP" + postfix));
  print(res.body);
  return mNOTTPFromJson(res.body);
}

Future<void> insertMNOTTP(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteMNOTTP(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncMNOTTP();
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
      for (MNOTTP record in batchRecords) {
        try {
          batch.insert('MNOTTP_Temp', record.toJson());
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
			select * from MNOTTP_Temp
			except
			select * from MNOTTP
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
          batch.update("MNOTTP", element,
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
  print('Time taken for MNOTTP update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from MNOTTP_Temp where TransId not in (Select TransId from MNOTTP)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM MNOTTP_Temp T0
LEFT JOIN MNOTTP T1 ON T0.TransId = T1.TransId 
WHERE T1.TransId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('MNOTTP', record);
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
      'Time taken for MNOTTP_Temp and MNOTTP compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('MNOTTP_Temp');
}

Future<List<MNOTTP>> retrieveMNOTTP(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('MNOTTP');
  return queryResult.map((e) => MNOTTP.fromJson(e)).toList();
}

Future<void> updateMNOTTP(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('MNOTTP', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deleteMNOTTP(Database db) async {
  await db.delete('MNOTTP');
}

Future<List<MNOTTP>> retrieveMNOTTPById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('MNOTTP', where: str, whereArgs: l);
  return queryResult.map((e) => MNOTTP.fromJson(e)).toList();
}

Future<String> insertMNOTTPToServer(BuildContext? context,
    {String? TransId, int? id}) async {
  String response = "";
  List<MNOTTP> list = await retrieveMNOTTPById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "TransId = ? AND ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "MNOTTP/Add"),
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
            .post(Uri.parse(prefix + "MNOTTP/Add"),
                headers: header, body: jsonEncode(map))
            .timeout(Duration(seconds: 30), onTimeout: () {
          return http.Response('Error', 500);
        });
        response = await res.body;
        print("eeaaae status");
        print(await res.statusCode);
        if (res.statusCode == 201 || res.statusCode == 500) {
          sentSuccessInServer = true;
          if (res.statusCode == 201) {
            map['ID'] = jsonDecode(res.body)['ID'];
            final Database db = await initializeDB(context);
            map = jsonDecode(res.body);
            map["has_created"] = 0;
            var x = await db.update("MNOTTP", map,
                where: "TransId = ?", whereArgs: [map["TransId"]]);
            print(x.toString());
          }
        }
        print(res.body);
      } catch (e) {
        print("Timeout " + e.toString());
        sentSuccessInServer = true;
      }
      print('i++;');
      print("INDEX = " + i.toString());
    } while (i < list.length && sentSuccessInServer == true);
  }
  return response;
}

Future<void> updateMNOTTPOnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<MNOTTP> list = await retrieveMNOTTPById(
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
          .put(Uri.parse(prefix + 'MNOTTP/Update'),
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
          var x = await db.update("MNOTTP", map,
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
