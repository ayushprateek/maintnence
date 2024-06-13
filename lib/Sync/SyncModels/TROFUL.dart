import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

class TROFUL {
  int? ID;
  String? Code;
  String? Name;
  String? Remarks;
  String? TruckType;
  String? RefuelByType;
  String? LoadStatus;
  String? RoadType;
  String? CargoType;
  String? CargoDimension;
  String? TrailerType;
  double? Tonnage;
  double? FuelRatio;
  double? Variance;
  String? CreatedBy;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  String? BranchId;
  String? UpdatedBy;
  double? FullLoadAverage;
  double? EmptyLoadAverage;
  double? PartialLoadAverage;
  String? EquipmentGroupCode;
  String? EquipmentGroupName;
  double? MinForEmpty;
  double? MaxForFull;
  String? ItemCode;
  String? ItemName;

  TROFUL({
    this.ID,
    this.Code,
    this.Name,
    this.Remarks,
    this.TruckType,
    this.RefuelByType,
    this.LoadStatus,
    this.RoadType,
    this.CargoType,
    this.CargoDimension,
    this.TrailerType,
    this.Tonnage,
    this.FuelRatio,
    this.Variance,
    this.CreatedBy,
    this.CreateDate,
    this.UpdateDate,
    this.BranchId,
    this.UpdatedBy,
    this.FullLoadAverage,
    this.EmptyLoadAverage,
    this.PartialLoadAverage,
    this.EquipmentGroupCode,
    this.EquipmentGroupName,
    this.MinForEmpty,
    this.MaxForFull,
    this.ItemCode,
    this.ItemName,
  });

  factory TROFUL.fromJson(Map<String, dynamic> json) => TROFUL(
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        Code: json['Code']?.toString() ?? '',
        Name: json['Name']?.toString() ?? '',
        Remarks: json['Remarks']?.toString() ?? '',
        TruckType: json['TruckType']?.toString() ?? '',
        RefuelByType: json['RefuelByType']?.toString() ?? '',
        LoadStatus: json['LoadStatus']?.toString() ?? '',
        RoadType: json['RoadType']?.toString() ?? '',
        CargoType: json['CargoType']?.toString() ?? '',
        CargoDimension: json['CargoDimension']?.toString() ?? '',
        TrailerType: json['TrailerType']?.toString() ?? '',
        Tonnage: double.tryParse(json['Tonnage'].toString()) ?? 0.0,
        FuelRatio: double.tryParse(json['FuelRatio'].toString()) ?? 0.0,
        Variance: double.tryParse(json['Variance'].toString()) ?? 0.0,
        CreatedBy: json['CreatedBy']?.toString() ?? '',
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()),
        BranchId: json['BranchId']?.toString() ?? '',
        UpdatedBy: json['UpdatedBy']?.toString() ?? '',
        FullLoadAverage:
            double.tryParse(json['FullLoadAverage'].toString()) ?? 0.0,
        EmptyLoadAverage:
            double.tryParse(json['EmptyLoadAverage'].toString()) ?? 0.0,
        PartialLoadAverage:
            double.tryParse(json['PartialLoadAverage'].toString()) ?? 0.0,
        EquipmentGroupCode: json['EquipmentGroupCode']?.toString() ?? '',
        EquipmentGroupName: json['EquipmentGroupName']?.toString() ?? '',
        MinForEmpty: double.tryParse(json['MinForEmpty'].toString()) ?? 0.0,
        MaxForFull: double.tryParse(json['MaxForFull'].toString()) ?? 0.0,
        ItemCode: json['ItemCode']?.toString() ?? '',
        ItemName: json['ItemName']?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
        'ID': ID,
        'Code': Code,
        'Name': Name,
        'Remarks': Remarks,
        'TruckType': TruckType,
        'RefuelByType': RefuelByType,
        'LoadStatus': LoadStatus,
        'RoadType': RoadType,
        'CargoType': CargoType,
        'CargoDimension': CargoDimension,
        'TrailerType': TrailerType,
        'Tonnage': Tonnage,
        'FuelRatio': FuelRatio,
        'Variance': Variance,
        'CreatedBy': CreatedBy,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'BranchId': BranchId,
        'UpdatedBy': UpdatedBy,
        'FullLoadAverage': FullLoadAverage,
        'EmptyLoadAverage': EmptyLoadAverage,
        'PartialLoadAverage': PartialLoadAverage,
        'EquipmentGroupCode': EquipmentGroupCode,
        'EquipmentGroupName': EquipmentGroupName,
        'MinForEmpty': MinForEmpty,
        'MaxForFull': MaxForFull,
        'ItemCode': ItemCode,
        'ItemName': ItemName,
      };
}

List<TROFUL> tROFULFromJson(String str) =>
    List<TROFUL>.from(json.decode(str).map((x) => TROFUL.fromJson(x)));

String tROFULToJson(List<TROFUL> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<TROFUL>> dataSyncTROFUL() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "TROFUL" + postfix));
  print(res.body);
  return tROFULFromJson(res.body);
}

Future<void> insertTROFUL(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteTROFUL(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncTROFUL();
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
      for (TROFUL record in batchRecords) {
        try {
          batch.insert('TROFUL_Temp', record.toJson());
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
			select * from TROFUL_Temp
			except
			select * from TROFUL
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
          batch.update("TROFUL", element,
              where:
                  "Code = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
              whereArgs: [element["Code"], 1, 1]);
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
  print('Time taken for TROFUL update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from TROFUL_Temp where TransId not in (Select TransId from TROFUL)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM TROFUL_Temp T0
LEFT JOIN TROFUL T1 ON T0.Code = T1.Code 
WHERE T1.Code IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('TROFUL', record);
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
      'Time taken for TROFUL_Temp and TROFUL compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('TROFUL_Temp');
}

Future<List<TROFUL>> retrieveTROFUL(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('TROFUL');
  return queryResult.map((e) => TROFUL.fromJson(e)).toList();
}

Future<void> updateTROFUL(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('TROFUL', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deleteTROFUL(Database db) async {
  await db.delete('TROFUL');
}

Future<List<TROFUL>> retrieveTROFULById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('TROFUL', where: str, whereArgs: l);
  return queryResult.map((e) => TROFUL.fromJson(e)).toList();
}

// Future<String> insertTROFULToServer(BuildContext? context,
//     {String? TransId, int? id}) async {
//   String response = "";
//   List<TROFUL> list = await retrieveTROFULById(
//       context,
//       TransId == null
//           ? DataSync.getInsertToServerStr()
//           : "TransId = ? AND ID = ?",
//       TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
//   if (TransId != null) {
//     list[0].ID = 0;
//     var res = await http.post(Uri.parse(prefix + "TROFUL/Add"),
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
//             .post(Uri.parse(prefix + "TROFUL/Add"),
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
//             var x = await db.update("TROFUL", map,
//                 where: "Code = ?", whereArgs: [map["Code"]]);
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
// Future<void> updateTROFULOnServer(BuildContext? context,
//     {String? condition, List? l}) async {
//   List<TROFUL> list = await retrieveTROFULById(
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
//           .put(Uri.parse(prefix + 'TROFUL/Update'),
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
//           var x = await db.update("TROFUL", map,
//               where: "Code = ?", whereArgs: [map["Code"]]);
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
