import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

class TROTRS {
  int? ID;
  String? TransId;
  String? TripTransId;
  String? PermanentTransId;
  int? DocEntry;
  String? DocNum;
  String? TruckNo;
  String? ApprovalStatus;
  String? DocStatus;
  String? CreatedBy;
  String? UpdatedBy;
  String? BranchId;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  String? Latitude;
  String? Longitude;
  String? PostingAddress;
  DateTime? TripStartDate;
  String? Remarks;
  int? hasCreated;
  int? hasUpdated;

  TROTRS({
    this.ID,
    this.TransId,
    this.TripTransId,
    this.PermanentTransId,
    this.DocEntry,
    this.DocNum,
    this.TruckNo,
    this.ApprovalStatus,
    this.DocStatus,
    this.CreatedBy,
    this.UpdatedBy,
    this.BranchId,
    this.CreateDate,
    this.UpdateDate,
    this.Latitude,
    this.Longitude,
    this.PostingAddress,
    this.TripStartDate,
    this.Remarks,
    this.hasCreated,
    this.hasUpdated,
  });

  factory TROTRS.fromJson(Map<String, dynamic> json) => TROTRS(
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        TransId: json['TransId'],
        TripTransId: json['TripTransId'],
        PermanentTransId: json['PermanentTransId'],
        DocEntry: int.tryParse(json['DocEntry'].toString()) ?? 0,
        DocNum: json['DocNum'],
        TruckNo: json['TruckNo'],
        ApprovalStatus: json['ApprovalStatus'],
        DocStatus: json['DocStatus'],
        CreatedBy: json['CreatedBy'],
        UpdatedBy: json['UpdatedBy'],
        BranchId: json['BranchId'],
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()),
        Latitude: json['Latitude'],
        Longitude: json['Longitude'],
        PostingAddress: json['PostingAddress'],
        TripStartDate: DateTime.tryParse(json['TripStartDate'].toString()),
        Remarks: json['Remarks'],
        hasCreated: int.tryParse(json['has_created'].toString()) ?? 0,
        hasUpdated: int.tryParse(json['has_updated'].toString()) ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'ID': ID,
        'TransId': TransId,
        'TripTransId': TripTransId,
        'PermanentTransId': PermanentTransId,
        'DocEntry': DocEntry,
        'DocNum': DocNum,
        'TruckNo': TruckNo,
        'ApprovalStatus': ApprovalStatus,
        'DocStatus': DocStatus,
        'CreatedBy': CreatedBy,
        'UpdatedBy': UpdatedBy,
        'BranchId': BranchId,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'Latitude': Latitude,
        'Longitude': Longitude,
        'PostingAddress': PostingAddress,
        'TripStartDate': TripStartDate?.toIso8601String(),
        'Remarks': Remarks,
        'has_created': hasCreated,
        'has_updated': hasUpdated,
      };
}

List<TROTRS> tROTRSFromJson(String str) =>
    List<TROTRS>.from(json.decode(str).map((x) => TROTRS.fromJson(x)));

String tROTRSToJson(List<TROTRS> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<TROTRS>> dataSyncTROTRS() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "TROTRS" + postfix));
  print(res.body);
  return tROTRSFromJson(res.body);
}

Future<void> insertTROTRS(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteTROTRS(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncTROTRS();
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
      for (TROTRS record in batchRecords) {
        try {
          batch.insert('TROTRS_Temp', record.toJson());
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
			select * from TROTRS_Temp
			except
			select * from TROTRS
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
          batch.update("TROTRS", element,
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
  print('Time taken for TROTRS update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from TROTRS_Temp where TransId not in (Select TransId from TROTRS)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM TROTRS_Temp T0
LEFT JOIN TROTRS T1 ON T0.TransId = T1.TransId 
WHERE T1.TransId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('TROTRS', record);
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
      'Time taken for TROTRS_Temp and TROTRS compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('TROTRS_Temp');
}

Future<List<TROTRS>> retrieveTROTRS(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('TROTRS');
  return queryResult.map((e) => TROTRS.fromJson(e)).toList();
}

Future<void> updateTROTRS(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('TROTRS', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deleteTROTRS(Database db) async {
  await db.delete('TROTRS');
}

Future<List<TROTRS>> retrieveTROTRSById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('TROTRS', where: str, whereArgs: l);
  return queryResult.map((e) => TROTRS.fromJson(e)).toList();
}

Future<String> insertTROTRSToServer(BuildContext? context,
    {String? TransId, int? id}) async {
  String response = "";
  List<TROTRS> list = await retrieveTROTRSById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "TransId = ? AND ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "TROTRS/Add"),
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
            .post(Uri.parse(prefix + "TROTRS/Add"),
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
            var x = await db.update("TROTRS", map,
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

Future<void> updateTROTRSOnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<TROTRS> list = await retrieveTROTRSById(
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
          .put(Uri.parse(prefix + 'TROTRS/Update'),
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
          var x = await db.update("TROTRS", map,
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
