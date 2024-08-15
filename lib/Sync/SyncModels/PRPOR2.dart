import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

class PRPOR2 {
  int? ID;
  String? TransId;
  int? RowId;
  String? AddressCode;
  String? Address;
  String? CityCode;
  String? CityName;
  String? StateCode;
  String? StateName;
  String? CountryCode;
  String? CountryName;
  String? Latitude;
  String? Longitude;
  String? RouteCode;
  String? RouteName;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  String? BaseObjectCode;
  int? DocEntry;
  String? DocNum;
  bool hasCreated;
  bool hasUpdated;

  PRPOR2({
    this.ID,
    this.TransId,
    this.RowId,
    this.AddressCode,
    this.Address,
    this.CityCode,
    this.CityName,
    this.StateCode,
    this.StateName,
    this.CountryCode,
    this.CountryName,
    this.Latitude,
    this.Longitude,
    this.RouteCode,
    this.RouteName,
    this.CreateDate,
    this.UpdateDate,
    this.BaseObjectCode,
    this.DocEntry,
    this.DocNum,
    this.hasCreated = false,
    this.hasUpdated = false,
  });

  factory PRPOR2.fromJson(Map<String, dynamic> json) => PRPOR2(
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        TransId: json['TransId']?.toString() ?? '',
        RowId: int.tryParse(json['RowId'].toString()) ?? 0,
        AddressCode: json['AddressCode']?.toString() ?? '',
        Address: json['Address']?.toString() ?? '',
        CityCode: json['CityCode']?.toString() ?? '',
        CityName: json['CityName']?.toString() ?? '',
        StateCode: json['StateCode']?.toString() ?? '',
        StateName: json['StateName']?.toString() ?? '',
        CountryCode: json['CountryCode']?.toString() ?? '',
        CountryName: json['CountryName']?.toString() ?? '',
        Latitude: json['Latitude']?.toString() ?? '',
        Longitude: json['Longitude']?.toString() ?? '',
        RouteCode: json['RouteCode']?.toString() ?? '',
        RouteName: json['RouteName']?.toString() ?? '',
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()),
        BaseObjectCode: json['BaseObjectCode']?.toString() ?? '',
        DocEntry: int.tryParse(json['DocEntry'].toString()) ?? 0,
        DocNum: json['DocNum']?.toString() ?? '',
        hasCreated: json['has_created'] == 1,
        hasUpdated: json['has_updated'] == 1,
      );

  Map<String, dynamic> toJson() => {
        'ID': ID,
        'TransId': TransId,
        'RowId': RowId,
        'AddressCode': AddressCode,
        'Address': Address,
        'CityCode': CityCode,
        'CityName': CityName,
        'StateCode': StateCode,
        'StateName': StateName,
        'CountryCode': CountryCode,
        'CountryName': CountryName,
        'Latitude': Latitude,
        'Longitude': Longitude,
        'RouteCode': RouteCode,
        'RouteName': RouteName,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'BaseObjectCode': BaseObjectCode,
        'DocEntry': DocEntry,
        'DocNum': DocNum,
        "has_created": hasCreated ? 1 : 0,
        "has_updated": hasUpdated ? 1 : 0,
      };
}

List<PRPOR2> pRPOR2FromJson(String str) =>
    List<PRPOR2>.from(json.decode(str).map((x) => PRPOR2.fromJson(x)));

String pRPOR2ToJson(List<PRPOR2> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<PRPOR2>> dataSyncPRPOR2() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "PRPOR2" + postfix));
  print(res.body);
  return pRPOR2FromJson(res.body);
}

Future<void> insertPRPOR2(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deletePRPOR2(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncPRPOR2();
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
      for (PRPOR2 record in batchRecords) {
        try {
          batch.insert('PRPOR2_Temp', record.toJson());
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
			select * from PRPOR2_Temp
			except
			select * from PRPOR2
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
          batch.update("PRPOR2", element,
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
  print('Time taken for PRPOR2 update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from PRPOR2_Temp where TransId not in (Select TransId from PRPOR2)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM PRPOR2_Temp T0
LEFT JOIN PRPOR2 T1 ON T0.TransId = T1.TransId 
WHERE T1.TransId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('PRPOR2', record);
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
      'Time taken for PRPOR2_Temp and PRPOR2 compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('PRPOR2_Temp');
}

Future<List<PRPOR2>> retrievePRPOR2(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('PRPOR2');
  return queryResult.map((e) => PRPOR2.fromJson(e)).toList();
}

Future<void> updatePRPOR2(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('PRPOR2', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deletePRPOR2(Database db) async {
  await db.delete('PRPOR2');
}

Future<List<PRPOR2>> retrievePRPOR2ById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('PRPOR2', where: str, whereArgs: l);
  return queryResult.map((e) => PRPOR2.fromJson(e)).toList();
}

Future<String> insertPRPOR2ToServer(BuildContext? context,
    {String? TransId, int? id}) async {
  String response = "";
  List<PRPOR2> list = await retrievePRPOR2ById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "TransId = ? AND ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "PRPOR2/Add"),
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
            .post(Uri.parse(prefix + "PRPOR2/Add"),
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
          PRPOR2 model = PRPOR2.fromJson(jsonDecode(res.body));
          map["ID"] = model.ID;
          map["has_created"] = 0;
          var x = await db.update("PRPOR2", map,
              where: "TransId = ? AND RowId = ?",
              whereArgs: [model.TransId, model.RowId]);
          print(x.toString());
        } else if (res.statusCode == 201 || res.statusCode == 500) {
          sentSuccessInServer = true;
          if (res.statusCode == 201) {
            map['ID'] = jsonDecode(res.body)['ID'];
            final Database db = await initializeDB(context);
            // map=jsonDecode(res.body);
            map["has_created"] = 0;
            var x = await db.update("PRPOR2", map,
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

Future<void> updatePRPOR2OnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<PRPOR2> list = await retrievePRPOR2ById(
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
          .put(Uri.parse(prefix + 'PRPOR2/Update'),
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
          var x = await db.update("PRPOR2", map,
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
