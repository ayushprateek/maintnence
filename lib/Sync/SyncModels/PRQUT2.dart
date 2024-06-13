import 'package:maintenance/Component/LogFileFunctions.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'dart:convert';
import 'package:sqflite/sqlite_api.dart';

class PRQUT2 {
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

  PRQUT2({
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
  });

  factory PRQUT2.fromJson(Map<String, dynamic> json) => PRQUT2(
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
      };
}

List<PRQUT2> pRQUT2FromJson(String str) =>
    List<PRQUT2>.from(json.decode(str).map((x) => PRQUT2.fromJson(x)));

String pRQUT2ToJson(List<PRQUT2> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<PRQUT2>> dataSyncPRQUT2() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "PRQUT2" + postfix));
  print(res.body);
  return pRQUT2FromJson(res.body);
}

Future<void> insertPRQUT2(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deletePRQUT2(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncPRQUT2();
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
      for (PRQUT2 record in batchRecords) {
        try {
          batch.insert('PRQUT2_Temp', record.toJson());
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
			select * from PRQUT2_Temp
			except
			select * from PRQUT2
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
          batch.update("PRQUT2", element,
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
  print('Time taken for PRQUT2 update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from PRQUT2_Temp where TransId not in (Select TransId from PRQUT2)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM PRQUT2_Temp T0
LEFT JOIN PRQUT2 T1 ON T0.TransId = T1.TransId 
WHERE T1.TransId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('PRQUT2', record);
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
      'Time taken for PRQUT2_Temp and PRQUT2 compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('PRQUT2_Temp');
}

Future<List<PRQUT2>> retrievePRQUT2(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('PRQUT2');
  return queryResult.map((e) => PRQUT2.fromJson(e)).toList();
}

Future<void> updatePRQUT2(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('PRQUT2', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deletePRQUT2(Database db) async {
  await db.delete('PRQUT2');
}

Future<List<PRQUT2>> retrievePRQUT2ById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('PRQUT2', where: str, whereArgs: l);
  return queryResult.map((e) => PRQUT2.fromJson(e)).toList();
}

// Future<String> insertPRQUT2ToServer(BuildContext? context,
//     {String? TransId, int? id}) async {
//   String response = "";
//   List<PRQUT2> list = await retrievePRQUT2ById(
//       context,
//       TransId == null
//           ? DataSync.getInsertToServerStr()
//           : "TransId = ? AND ID = ?",
//       TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
//   if (TransId != null) {
//     list[0].ID = 0;
//     var res = await http.post(Uri.parse(prefix + "PRQUT2/Add"),
//         headers: header, body: jsonEncode(list[0].toJson()));
//     response = res.body;
//   } else if (list.isNotEmpty) {
//     int i = 0;
//     bool sentSuccessInServer = false;
//     do {
//       sentSuccessInServer = false;
//       try {
//         Map<String, dynamic> map = list[i].toJson();
//         map.remove('ID');
//         var res = await http
//             .post(Uri.parse(prefix + "PRQUT2/Add"),
//                 headers: header, body: jsonEncode(map))
//             .timeout(Duration(seconds: 30), onTimeout: () {
//           return http.Response('Error', 500);
//         });
//         response = await res.body;
//         print("eeaaae status");
//         print(await res.statusCode);
//         if (res.statusCode == 201 || res.statusCode == 500) {
//           sentSuccessInServer = true;
//           if (res.statusCode == 201) {
//             map['ID'] = jsonDecode(res.body)['ID'];
//             final Database db = await initializeDB(context);
//             // map=jsonDecode(res.body);
//             map["has_created"] = 0;
//             var x = await db.update("PRQUT2", map,
//                 where: "TransId = ? AND RowId = ?",
//                 whereArgs: [map["TransId"], map["RowId"]]);
//             print(x.toString());
//           }
//         }
//         print(res.body);
//       } catch (e) {
//         print("Timeout " + e.toString());
//         sentSuccessInServer = true;
//       }
//       i++;
//       print("INDEX = " + i.toString());
//     } while (i < list.length && sentSuccessInServer == true);
//   }
//   return response;
// }
//
// Future<void> updatePRQUT2OnServer(BuildContext? context,
//     {String? condition, List? l}) async {
//   List<PRQUT2> list = await retrievePRQUT2ById(
//       context,
//       l == null ? DataSync.getUpdateOnServerStr() : condition ?? "",
//       l == null ? DataSync.getUpdateOnServerList() : l);
//   print(list);
//   int i = 0;
//   bool sentSuccessInServer = false;
//   do {
//     sentSuccessInServer = false;
//     try {
//       Map<String, dynamic> map = list[i].toJson();
//       var res = await http
//           .put(Uri.parse(prefix + 'PRQUT2/Update'),
//               headers: header, body: jsonEncode(map))
//           .timeout(Duration(seconds: 30), onTimeout: () {
//         return http.Response('Error', 500);
//       });
//       print(await res.statusCode);
//       if (res.statusCode == 201 || res.statusCode == 500) {
//         sentSuccessInServer = true;
//         if (res.statusCode == 201) {
//           final Database db = await initializeDB(context);
//           map["has_updated"] = 0;
//           var x = await db.update("PRQUT2", map,
//               where: "TransId = ? AND RowId = ?",
//               whereArgs: [map["TransId"], map["RowId"]]);
//           print(x.toString());
//         }
//       }
//       print(res.body);
//     } catch (e) {
//       print("Timeout " + e.toString());
//       sentSuccessInServer = true;
//     }
//
//     i++;
//     print("INDEX = " + i.toString());
//   } while (i < list.length && sentSuccessInServer == true);
// }
