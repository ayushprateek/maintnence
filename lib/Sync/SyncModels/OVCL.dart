import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:sqflite/sqlite_api.dart';

class OVCLModel {
  int? ID;
  String? Code;
  String? TruckNo;
  double? TareWeight;
  double? GrossWeight;
  double? LoadingCap;
  double? Volume;
  String? EngineNo;
  String? ChasisNo;
  double? FuelCapacity;
  int? Active;
  int? Own;
  String? EmpId;
  String? EmpDesc;
  String? TransCode;
  String? TrnasName;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  String? CreatedBy;
  String? UpdatedBy;
  String? BranchId;
  String? TrnsType;
  String? TruckStatus;
  String? EngagedRPTransId;
  String? Type;
  String? EquipmentType;
  String? NoOfAxis;
  int? ManufactureYear;
  DateTime? PurchaseDate;
  String? Attachment;
  String? ReFuelNature;
  double? OdometerReading;
  String? EquipmentGroupCode;
  String? EquipmentGroupName;
  String? Name;
  int? hasCreated;
  int? hasUpdated;

  OVCLModel({
    this.ID,
    this.Code,
    this.TruckNo,
    this.TareWeight,
    this.GrossWeight,
    this.LoadingCap,
    this.Volume,
    this.EngineNo,
    this.ChasisNo,
    this.FuelCapacity,
    this.Active,
    this.Own,
    this.EmpId,
    this.EmpDesc,
    this.TransCode,
    this.TrnasName,
    this.CreateDate,
    this.UpdateDate,
    this.CreatedBy,
    this.UpdatedBy,
    this.BranchId,
    this.TrnsType,
    this.TruckStatus,
    this.EngagedRPTransId,
    this.Type,
    this.EquipmentType,
    this.NoOfAxis,
    this.ManufactureYear,
    this.PurchaseDate,
    this.Attachment,
    this.ReFuelNature,
    this.OdometerReading,
    this.EquipmentGroupCode,
    this.EquipmentGroupName,
    this.Name,
    this.hasCreated,
    this.hasUpdated,
  });

  factory OVCLModel.fromJson(Map<String, dynamic> json) => OVCLModel(
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        Code: json['Code'],
        TruckNo: json['TruckNo'],
        TareWeight: double.tryParse(json['TareWeight'].toString()) ?? 0.0,
        GrossWeight: double.tryParse(json['GrossWeight'].toString()) ?? 0.0,
        LoadingCap: double.tryParse(json['LoadingCap'].toString()) ?? 0.0,
        Volume: double.tryParse(json['Volume'].toString()) ?? 0.0,
        EngineNo: json['EngineNo'],
        ChasisNo: json['ChasisNo'],
        FuelCapacity: double.tryParse(json['FuelCapacity'].toString()) ?? 0.0,
        Active: int.tryParse(json['Active'].toString()) ?? 0,
        Own: int.tryParse(json['Own'].toString()) ?? 0,
        EmpId: json['EmpId'],
        EmpDesc: json['EmpDesc'],
        TransCode: json['TransCode'],
        TrnasName: json['TrnasName'],
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()),
        CreatedBy: json['CreatedBy'],
        UpdatedBy: json['UpdatedBy'],
        BranchId: json['BranchId'],
        TrnsType: json['TrnsType'],
        TruckStatus: json['TruckStatus'],
        EngagedRPTransId: json['EngagedRPTransId'],
        Type: json['Type'],
        EquipmentType: json['EquipmentType'],
        NoOfAxis: json['NoOfAxis'],
        ManufactureYear: int.tryParse(json['ManufactureYear'].toString()) ?? 0,
        PurchaseDate: DateTime.tryParse(json['PurchaseDate'].toString()),
        Attachment: json['Attachment'],
        ReFuelNature: json['ReFuelNature'],
        OdometerReading:
            double.tryParse(json['OdometerReading'].toString()) ?? 0.0,
        EquipmentGroupCode: json['EquipmentGroupCode'],
        EquipmentGroupName: json['EquipmentGroupName'],
        Name: json['Name'],
        hasCreated: int.tryParse(json['has_created'].toString()) ?? 0,
        hasUpdated: int.tryParse(json['has_updated'].toString()) ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'ID': ID,
        'Code': Code,
        'TruckNo': TruckNo,
        'TareWeight': TareWeight,
        'GrossWeight': GrossWeight,
        'LoadingCap': LoadingCap,
        'Volume': Volume,
        'EngineNo': EngineNo,
        'ChasisNo': ChasisNo,
        'FuelCapacity': FuelCapacity,
        'Active': Active,
        'Own': Own,
        'EmpId': EmpId,
        'EmpDesc': EmpDesc,
        'TransCode': TransCode,
        'TrnasName': TrnasName,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'CreatedBy': CreatedBy,
        'UpdatedBy': UpdatedBy,
        'BranchId': BranchId,
        'TrnsType': TrnsType,
        'TruckStatus': TruckStatus,
        'EngagedRPTransId': EngagedRPTransId,
        'Type': Type,
        'EquipmentType': EquipmentType,
        'NoOfAxis': NoOfAxis,
        'ManufactureYear': ManufactureYear,
        'PurchaseDate': PurchaseDate?.toIso8601String(),
        'Attachment': Attachment,
        'ReFuelNature': ReFuelNature,
        'OdometerReading': OdometerReading,
        'EquipmentGroupCode': EquipmentGroupCode,
        'EquipmentGroupName': EquipmentGroupName,
        'Name': Name,
        'has_created': hasCreated,
        'has_updated': hasUpdated,
      };
}

List<OVCLModel> oVCLModelFromJson(String str) =>
    List<OVCLModel>.from(json.decode(str).map((x) => OVCLModel.fromJson(x)));

String oVCLModelToJson(List<OVCLModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<OVCLModel>> dataSyncOVCLModel() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "OVCL" + postfix));
  print(res.body);
  return oVCLModelFromJson(res.body);
}

Future<void> insertOVCLModel(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteOVCLModel(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncOVCLModel();
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
      for (OVCLModel record in batchRecords) {
        try {
          batch.insert('OVCL_Temp', record.toJson());
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
			select * from OVCL_Temp
			except
			select * from OVCL
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
          batch.update("OVCL", element,
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
  print('Time taken for OVCL update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from OVCLModel_Temp where TransId not in (Select TransId from OVCLModel)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM OVCL_Temp T0
LEFT JOIN OVCL T1 ON T0.Code = T1.Code 
WHERE T1.Code IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('OVCL', record);
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
      'Time taken for OVCL_Temp and OVCL compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('OVCL_Temp');
}

Future<List<OVCLModel>> retrieveOVCLModel(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('OVCL');
  return queryResult.map((e) => OVCLModel.fromJson(e)).toList();
}

Future<void> updateOVCLModel(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('OVCL', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deleteOVCLModel(Database db) async {
  await db.delete('OVCL');
}

Future<List<OVCLModel>> retrieveOVCLModelById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('OVCL', where: str, whereArgs: l);
  return queryResult.map((e) => OVCLModel.fromJson(e)).toList();
}

//
// Future<String> insertOVCLModelToServer(BuildContext? context,
//     {String? TransId, int? id})
// async {
//   String response = "";
//   List<OVCLModel> list = await retrieveOVCLModelById(
//       context,
//       TransId == null
//           ? DataSync.getInsertToServerStr()
//           : "TransId = ? AND ID = ?",
//       TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
//   if (TransId != null) {
//     list[0].ID = 0;
//     var res = await http.post(Uri.parse(prefix + "OVCL/Add"),
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
//             .post(Uri.parse(prefix + "OVCL/Add"),
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
//             map = jsonDecode(res.body);
//             map["has_created"] = 0;
//             var x = await db.update("OVCL", map,
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
//       print('i++;');
//       print("INDEX = " + i.toString());
//     } while (i < list.length && sentSuccessInServer == true);
//   }
//   return response;
// }
//
// Future<void> updateOVCLModelOnServer(BuildContext? context,
//     {String? condition, List? l})
// async {
//   List<OVCLModel> list = await retrieveOVCLModelById(
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
//           .put(Uri.parse(prefix + 'OVCL/Update'),
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
//           var x = await db.update("OVCL", map,
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
Future<List<OVCLModel>> retrieveVehicleForSearch({
  int? limit,
  String? query,
}) async {
  query = "%$query%";
  final Database db = await initializeDB(null);
  final List<Map<String, Object?>> queryResult = await db.rawQuery(
      'SELECT * FROM OVCL WHERE Code LIKE "$query" OR TruckNo LIKE "$query" LIMIT $limit');
  return queryResult.map((e) => OVCLModel.fromJson(e)).toList();
}

Future<List<OVCLModel>> retrieveOVCLForSearch({
  int? limit,
  String? query,
}) async {
  query = "%$query%";
  final Database db = await initializeDB(null);
  final List<Map<String, Object?>> queryResult = await db
      .rawQuery('SELECT * FROM OVCL WHERE Code LIKE "$query" LIMIT $limit');
  return queryResult.map((e) => OVCLModel.fromJson(e)).toList();
}
