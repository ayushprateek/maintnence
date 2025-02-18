import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

class PRPDN3 {
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
  DateTime? CreateDate;
  DateTime? UpdateDate;
  int? DocEntry;
  String? DocNum;
  bool hasCreated;
  bool hasUpdated;

  PRPDN3({
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
    this.CreateDate,
    this.UpdateDate,
    this.DocEntry,
    this.DocNum,
    this.hasCreated = false,
    this.hasUpdated = false,
  });

  factory PRPDN3.fromJson(Map<String, dynamic> json) => PRPDN3(
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
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()),
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
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'DocEntry': DocEntry,
        'DocNum': DocNum,
        "has_created": hasCreated ? 1 : 0,
        "has_updated": hasUpdated ? 1 : 0,
      };
}

List<PRPDN3> pRPDN3FromJson(String str) =>
    List<PRPDN3>.from(json.decode(str).map((x) => PRPDN3.fromJson(x)));

String pRPDN3ToJson(List<PRPDN3> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<PRPDN3>> dataSyncPRPDN3() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "PRPDN3" + postfix));
  print(res.body);
  return pRPDN3FromJson(res.body);
}

Future<void> insertPRPDN3(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deletePRPDN3(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncPRPDN3();
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
      for (PRPDN3 record in batchRecords) {
        try {
          batch.insert('PRPDN3_Temp', record.toJson());
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
			select * from PRPDN3_Temp
			except
			select * from PRPDN3
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
          batch.update("PRPDN3", element,
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
  print('Time taken for PRPDN3 update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from PRPDN3_Temp where TransId not in (Select TransId from PRPDN3)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM PRPDN3_Temp T0
LEFT JOIN PRPDN3 T1 ON T0.TransId = T1.TransId 
WHERE T1.TransId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('PRPDN3', record);
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
      'Time taken for PRPDN3_Temp and PRPDN3 compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('PRPDN3_Temp');
}

Future<List<PRPDN3>> retrievePRPDN3(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('PRPDN3');
  return queryResult.map((e) => PRPDN3.fromJson(e)).toList();
}

Future<void> updatePRPDN3(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('PRPDN3', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deletePRPDN3(Database db) async {
  await db.delete('PRPDN3');
}

Future<List<PRPDN3>> retrievePRPDN3ById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('PRPDN3', where: str, whereArgs: l);
  return queryResult.map((e) => PRPDN3.fromJson(e)).toList();
}

Future<String> insertPRPDN3ToServer(BuildContext? context,
    {String? TransId, int? id}) async {
  String response = "";
  List<PRPDN3> list = await retrievePRPDN3ById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "TransId = ? AND ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "PRPDN3/Add"),
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
            .post(Uri.parse(prefix + "PRPDN3/Add"),
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
          PRPDN3 model = PRPDN3.fromJson(jsonDecode(res.body));
          map["ID"] = model.ID;
          map["has_created"] = 0;
          var x = await db.update("PRPDN3", map,
              where: "TransId = ? AND RowId = ?",
              whereArgs: [model.TransId, model.RowId]);
          print(x.toString());
        } else

        if (res.statusCode == 201 || res.statusCode == 500) {
          sentSuccessInServer = true;
          if (res.statusCode == 201) {
            map['ID'] = jsonDecode(res.body)['ID'];
            final Database db = await initializeDB(context);
            // map=jsonDecode(res.body);
            map["has_created"] = 0;
            var x = await db.update("PRPDN3", map,
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

Future<void> updatePRPDN3OnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<PRPDN3> list = await retrievePRPDN3ById(
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
          .put(Uri.parse(prefix + 'PRPDN3/Update'),
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
          var x = await db.update("PRPDN3", map,
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
