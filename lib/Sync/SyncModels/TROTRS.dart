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
  String? OPTETransId;
  int? TripAndTruckRowId;
  String? TruckNo;
  String? TruckStatus;
  String? RouteCode;
  String? RouteName;
  String? DriverCode;
  String? DriverName;
  String? MobileNo;
  String? Remarks;
  String? OdometerReading;
  double? AvailableFuel;
  double? Temperature;
  double? LoadWeight;
  String? Latitude;
  String? Longitude;
  String? PostingAddress;
  String? CreatedBy;
  DateTime? TripStartDate;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  String? BranchId;
  String? UpdatedBy;

  TROTRS({
    this.ID,
    this.TransId,
    this.OPTETransId,
    this.TripAndTruckRowId,
    this.TruckNo,
    this.TruckStatus,
    this.RouteCode,
    this.RouteName,
    this.DriverCode,
    this.DriverName,
    this.MobileNo,
    this.Remarks,
    this.OdometerReading,
    this.AvailableFuel,
    this.Temperature,
    this.LoadWeight,
    this.Latitude,
    this.Longitude,
    this.PostingAddress,
    this.CreatedBy,
    this.TripStartDate,
    this.CreateDate,
    this.UpdateDate,
    this.BranchId,
    this.UpdatedBy,
  });

  factory TROTRS.fromJson(Map<String, dynamic> json) => TROTRS(
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        TransId: json['TransId']?.toString() ?? '',
        OPTETransId: json['OPTETransId']?.toString() ?? '',
        TripAndTruckRowId:
            int.tryParse(json['TripAndTruckRowId'].toString()) ?? 0,
        TruckNo: json['TruckNo']?.toString() ?? '',
        TruckStatus: json['TruckStatus']?.toString() ?? '',
        RouteCode: json['RouteCode']?.toString() ?? '',
        RouteName: json['RouteName']?.toString() ?? '',
        DriverCode: json['DriverCode']?.toString() ?? '',
        DriverName: json['DriverName']?.toString() ?? '',
        MobileNo: json['MobileNo']?.toString() ?? '',
        Remarks: json['Remarks']?.toString() ?? '',
        OdometerReading: json['OdometerReading']?.toString() ?? '',
        AvailableFuel: double.tryParse(json['AvailableFuel'].toString()) ?? 0.0,
        Temperature: double.tryParse(json['Temperature'].toString()) ?? 0.0,
        LoadWeight: double.tryParse(json['LoadWeight'].toString()) ?? 0.0,
        Latitude: json['Latitude']?.toString() ?? '',
        Longitude: json['Longitude']?.toString() ?? '',
        PostingAddress: json['PostingAddress']?.toString() ?? '',
        CreatedBy: json['CreatedBy']?.toString() ?? '',
        TripStartDate: DateTime.tryParse(json['TripStartDate'].toString()),
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()),
        BranchId: json['BranchId']?.toString() ?? '',
        UpdatedBy: json['UpdatedBy']?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
        'ID': ID,
        'TransId': TransId,
        'OPTETransId': OPTETransId,
        'TripAndTruckRowId': TripAndTruckRowId,
        'TruckNo': TruckNo,
        'TruckStatus': TruckStatus,
        'RouteCode': RouteCode,
        'RouteName': RouteName,
        'DriverCode': DriverCode,
        'DriverName': DriverName,
        'MobileNo': MobileNo,
        'Remarks': Remarks,
        'OdometerReading': OdometerReading,
        'AvailableFuel': AvailableFuel,
        'Temperature': Temperature,
        'LoadWeight': LoadWeight,
        'Latitude': Latitude,
        'Longitude': Longitude,
        'PostingAddress': PostingAddress,
        'CreatedBy': CreatedBy,
        'TripStartDate': TripStartDate?.toIso8601String(),
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'BranchId': BranchId,
        'UpdatedBy': UpdatedBy,
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
            // map=jsonDecode(res.body);
            map["has_created"] = 0;
            var x = await db.update("TROTRS", map,
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
