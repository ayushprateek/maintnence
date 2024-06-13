import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:maintenance/Sync/SyncModels/OUSR.dart';
import 'package:maintenance/main.dart';
import 'package:sqflite/sqlite_api.dart';

List<ODSCModel> ODSCModelFromJson(String str) =>
    List<ODSCModel>.from(json.decode(str).map((x) => ODSCModel.fromJson(x)));

String ODSCModelToJson(List<ODSCModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ODSCModel {
  ODSCModel({
    this.ID,
    this.DriverId,
    this.TransId,
    this.PermanentTransId,
    this.BaseTransId,
    this.RouteCode,
    this.RouteName,
    this.VehCode,
    this.TruckNo,
    this.TareWeight,
    this.EmpMobileNo,
    this.Volume,
    this.LoadingCap,
    this.DriverName,
    this.LoadingStatus,
    this.DocStatus,
    this.CreateDate,
    this.ApprovedBy,
    this.ApprovalStatus,
    this.DocEntry,
    this.DocNum,
    this.CreatedBy,
    this.SalesEmpId,
    this.SalesEmp,
    this.DriverMobileNo,
    this.UpdateDate,
    this.hasCreated = false,
    this.hasUpdated = false,
    this.Latitude,
    this.Longitude,
    this.WhsCode,
    this.Remarks,
    this.LocalDate,
    this.BranchId,
    this.UpdatedBy,
    this.NrcNo,
    this.IsPosted,
    this.Error,
    this.ObjectCode,
  });

  int? ID;
  int? DocEntry;
  String? DriverId;
  String? TransId;
  String? PermanentTransId;
  String? BaseTransId;
  String? RouteCode;
  String? EmpMobileNo;
  String? RouteName;
  String? VehCode;
  String? TruckNo;
  double? TareWeight;
  double? Volume;
  double? LoadingCap;
  String? DriverName;
  String? ApprovalStatus;
  String? LoadingStatus;
  String? DocStatus;
  String? ApprovedBy;
  String? DocNum;
  String? CreatedBy;
  String? DriverMobileNo;
  String? Latitude;
  String? Longitude;
  String? SalesEmp;
  String? SalesEmpId;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  bool hasCreated;
  bool hasUpdated;

  String? WhsCode;
  String? Remarks;
  String? LocalDate;
  String? BranchId;
  String? UpdatedBy;
  String? NrcNo;
  bool? IsPosted;
  String? Error;
  String? ObjectCode;

  factory ODSCModel.fromJson(Map<String, dynamic> json) => ODSCModel(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        DocEntry: int.tryParse(json["DocEntry"].toString()) ?? 0,
        SalesEmpId: json["SalesEmpId"] ?? "",
        DriverId: json["DriverId"] ?? "",
        TransId: json["TransId"] ?? "",
        EmpMobileNo: json["EmpMobileNo"] ?? "",
        PermanentTransId: json["PermanentTransId"] ?? "",
        SalesEmp: json["SalesEmp"].toString(),
        DriverMobileNo: json["DriverMobileNo"].toString(),
        CreatedBy: json["CreatedBy"].toString(),
        DocNum: json["DocNum"],
        BaseTransId: json["BaseTransId"] ?? "",
        ApprovedBy: json["ApprovedBy"] ?? "",
        ApprovalStatus: json["ApprovalStatus"] ?? "",
        RouteCode: json["RouteCode"] ?? "",
        Latitude: json['Latitude'] ?? '',
        Longitude: json['Longitude'] ?? '',
        RouteName: json["RouteName"] ?? "",
        VehCode: json["VehCode"] ?? "",
        TruckNo: json["TruckNo"] ?? "",
        TareWeight: double.tryParse(json["TareWeight"].toString()) ?? 0.0,
        Volume: double.tryParse(json["Volume"].toString()) ?? 0.0,
        LoadingCap: double.tryParse(json["LoadingCap"].toString()) ?? 0.0,
        DriverName: json["DriverName"] ?? "",
        LoadingStatus: json["LoadingStatus"] ?? "",
        DocStatus: json["DocStatus"] ?? "",
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] == 1,
        hasUpdated: json['has_updated'] == 1,
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        WhsCode: json['WhsCode'] ?? '',
        Remarks: json['Remarks'] ?? '',
        LocalDate: json['LocalDate'] ?? '',
        BranchId: json['BranchId'] ?? '',
        UpdatedBy: json['UpdatedBy'] ?? '',
        NrcNo: json['NrcNo'] ?? '',
        IsPosted:
            json['IsPosted'] is bool ? json['IsPosted'] : json['IsPosted'] == 1,
        Error: json['Error'] ?? '',
        ObjectCode: json['ObjectCode'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "DriverId": DriverId,
        "DriverMobileNo": DriverMobileNo,
        "SalesEmpId": SalesEmpId,
        "SalesEmp": SalesEmp,
        'Latitude': Latitude,
        'Longitude': Longitude,
        "CreatedBy": CreatedBy,
        "DocNum": DocNum,
        "DocEntry": DocEntry,
        "PermanentTransId": PermanentTransId,
        "TransId": TransId,
        "BaseTransId": BaseTransId,
        "RouteCode": RouteCode,
        "RouteName": RouteName,
        "VehCode": VehCode,
        "EmpMobileNo": EmpMobileNo,
        "TruckNo": TruckNo,
        "TareWeight": TareWeight,
        "Volume": Volume,
        "LoadingCap": LoadingCap,
        "DriverName": DriverName,
        "LoadingStatus": LoadingStatus,
        "DocStatus": DocStatus,
        "CreateDate": CreateDate?.toIso8601String(),
        "UpdateDate": UpdateDate?.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "has_updated": hasUpdated ? 1 : 0,
        "ApprovedBy": ApprovedBy,
        "ApprovalStatus": ApprovalStatus,
        'WhsCode': WhsCode,
        'Remarks': Remarks,
        'LocalDate': LocalDate,
        'BranchId': BranchId,
        'UpdatedBy': UpdatedBy,
        'NrcNo': NrcNo,
        'IsPosted': IsPosted,
        'Error': Error,
        'ObjectCode': ObjectCode,
      };
}

// Future<void> insertODSC(Database db)async{
//   if(postfix.toLowerCase().contains("all"))
//   await deleteODSC(db);
//   List customers= await dataSyncODSC();
//   print(customers);
//   var batch = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try
//     {
//       batch.insert('ODSC', customer.toJson());
//     }
//     catch(e)
//     {
//       getErrorSnackBar("Sync Error "+e.toString());
//     }
//   });
//   await batch.commit(noResult: true);
//
//   // customers.forEach((customer) async {
//   //   print(customer.toJson());
//   //   try
//   //   {
//   //     db.transaction((db)async{
//   //       await db.insert('ODSC', customer.toJson());
//   //     });
//   //   }
//   //   catch(e)
//   //   {
//   //     getErrorSnackBar("Sync Error "+e.toString());
//   //   }
//   //
//   // });
// }

// Future<void> insertODSC(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteODSC(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncODSC();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('ODSC_Temp', customer.toJson());
//     } catch (e) {
//       writeToLogFile(
//           text: e.toString(),
//           fileName: StackTrace.current.toString(),
//           lineNo: 141);
//       getErrorSnackBar("Sync Error " + e.toString());
//     }
//   });
//   await batch1.commit(noResult: true);
//   var u = await db.rawQuery(
//       "SELECT * FROM  ODSC_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("ODSC", element,
//         where: "TransId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["TransId"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//
//   var v = await db.rawQuery(
//       "Select * from ODSC_Temp where TransId not in (Select TransId from ODSC)");
//   v.forEach((element) {
//     batch3.insert('ODSC', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('ODSC_Temp');
// }
Future<void> insertODSC(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteODSC(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncODSC();
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
      for (ODSCModel record in batchRecords) {
        try {
          batch.insert('ODSC_Temp', record.toJson());
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
			select * from ODSC_Temp
			except
			select * from ODSC
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
          batch.update("ODSC", element,
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
  print('Time taken for ODSC update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from ODSC_Temp where TransId not in (Select TransId from ODSC)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM ODSC_Temp T0
LEFT JOIN ODSC T1 ON T0.TransId = T1.TransId 
WHERE T1.TransId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('ODSC', record);
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
      'Time taken for ODSC_Temp and ODSC compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('ODSC_Temp');
  // stopwatch.stop();
}

Future<List<ODSCModel>> dataSyncODSC() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "ODSC" + postfix));
  print(res.body);
  return ODSCModelFromJson(res.body);
}

Future<List<ODSCModel>> retrieveODSC(BuildContext context,
    {String? orderBy}) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('ODSC', orderBy: orderBy);
  return queryResult.map((e) => ODSCModel.fromJson(e)).toList();
}

Future<List<ODSCModel>> retrieveODSCById(
    BuildContext? context, String str, List l,
    {String? orderBy}) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('ODSC', where: str, whereArgs: l, orderBy: orderBy);
  return queryResult.map((e) => ODSCModel.fromJson(e)).toList();
}

Future<ODSCModel?> retrieveLatestRoute() async {
  final Database db = await initializeDB(null);
  final List<Map<String, Object?>> queryResult = await db.rawQuery(
      "SELECT * FROM ODSC WHERE CreatedBy='${userModel.UserCode}'  ORDER BY CreateDate DESC  LIMIT 1");
  List<ODSCModel> list = queryResult.map((e) => ODSCModel.fromJson(e)).toList();
  if (list.isNotEmpty) {
    return list[0];
  }
}

Future<void> updateODSC(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update("ODSC", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteODSC(Database db) async {
  await db.delete('ODSC');
}

Future<List<ODSCModel>> retrieveODSCByBranch(BuildContext context,
    {String? orderBy}) async {
  List<String> list = [];
  String str = "CreatedBy = ?";
  List<OUSRModel> ousrModel =
      await retrieveOUSRById(context, "BranchId = ?", [userModel.BranchId]);
  print(ousrModel);

  for (int i = 0; i < ousrModel.length; i++) {
    list.add(ousrModel[i].UserCode);
    if (i != 0) {
      str += "OR CreatedBy = ?";
    }
  }
  if (list.isEmpty) {
    str = "";
  }
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query("ODSC", where: str, whereArgs: list, orderBy: orderBy);
  return queryResult.map((e) => ODSCModel.fromJson(e)).toList();
}
//SEND DATA TO SERVER
//--------------------------

Future<void> insertODSCToServer(BuildContext? context,
    {String? TransId}) async {
  String response = "";
  List<ODSCModel> list = await retrieveODSCById(
      context,
      TransId == null ? DataSync.getInsertToServerStr() : "TransId = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId]);
  if (TransId != null) {
    //only single entry
    var res = await http.post(Uri.parse(prefix + "ODSC/Add"),
        headers: header, body: jsonEncode(list[0].toJson()));
    print(res.body);
    response = res.body;
  } else if (list.isNotEmpty) {
    //asxkncuievbuefvbeivuehveubvbeuivuibervuierbvueir
    int i = 0;
    bool sentSuccessInServer = false;
    if (list.isEmpty) {
      return;
    }
    do {
      Map<String, dynamic> map = list[i].toJson();
      sentSuccessInServer = false;
      try {
        map.remove('ID');
        String queryParams = 'TransId=${list[i].TransId}';
        var res = await http
            .post(Uri.parse(prefix + "ODSC/Add?$queryParams"),
                headers: header, body: jsonEncode(map))
            .timeout(Duration(seconds: 30), onTimeout: () {
          writeToLogFile(
              text: '500 error \nMap : $map',
              fileName: StackTrace.current.toString(),
              lineNo: 141);
          return http.Response('Error', 500);
        });
        response = await res.body;

        print("eeaaae status");
        print(await res.statusCode);
        if (res.statusCode != 201) {
          await writeToLogFile(
              text:
                  '${res.statusCode} error \nMap : $map\nResponse : ${res.body}',
              fileName: StackTrace.current.toString(),
              lineNo: 141);
        }
        if (res.statusCode == 409) {
          ///Already added in server
          final Database db = await initializeDB(context);
          ODSCModel model = ODSCModel.fromJson(jsonDecode(res.body));
          var x = await db.update("ODSC", model.toJson(),
              where: "TransId = ?", whereArgs: [model.TransId]);
          print(x.toString());
        } else if (res.statusCode == 201 || res.statusCode == 500) {
          sentSuccessInServer = true;
          if (res.statusCode == 201) {
            map['ID'] = jsonDecode(res.body)['ID'];
            map['PermanentTransId'] = jsonDecode(res.body)['PermanentTransId'];
            final Database db = await initializeDB(context);
            map["has_created"] = 0;
            var x = await db.update("ODSC", map,
                where: "TransId = ?", whereArgs: [map["TransId"]]);
            print(x.toString());
          }
        }
        print(res.body);
      } catch (e) {
        writeToLogFile(
            text: '${e.toString()}\nMap : $map',
            fileName: StackTrace.current.toString(),
            lineNo: 141);
        sentSuccessInServer = true;
      }

      i++;
      print("INDEX = " + i.toString());
    } while (i < list.length && sentSuccessInServer == true);
  }
}

Future<void> updateODSCOnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<ODSCModel> list = await retrieveODSCById(
      context,
      l == null ? DataSync.getUpdateOnServerStr() : condition ?? "",
      l == null ? DataSync.getUpdateOnServerList() : l);
  print(list);
  int i = 0;
  bool sentSuccessInServer = false;
  if (list.isEmpty) {
    return;
  }
  do {
    Map<String, dynamic> map = list[i].toJson();
    sentSuccessInServer = false;
    try {
      if (list.isEmpty) {
        return;
      }
      Map<String, dynamic> map = list[i].toJson();
      var res = await http
          .put(Uri.parse(prefix + 'ODSC/Update'),
              headers: header, body: jsonEncode(map))
          .timeout(Duration(seconds: 30), onTimeout: () {
        writeToLogFile(
            text: '500 error \nMap : $map',
            fileName: StackTrace.current.toString(),
            lineNo: 141);
        return http.Response('Error', 500);
      });
      print(await res.statusCode);
      if (res.statusCode != 201) {
        await writeToLogFile(
            text:
                '${res.statusCode} error \nMap : $map\nResponse : ${res.body}',
            fileName: StackTrace.current.toString(),
            lineNo: 141);
      }
      if (res.statusCode == 201 || res.statusCode == 500) {
        sentSuccessInServer = true;
        if (res.statusCode == 201) {
          final Database db = await initializeDB(context);
          map["has_updated"] = 0;
          var x = await db.update("ODSC", map,
              where: "TransId = ?", whereArgs: [map["TransId"]]);
          print(x.toString());
        }
      }
      print(res.body);
    } catch (e) {
      writeToLogFile(
          text: '${e.toString()}\nMap : $map',
          fileName: StackTrace.current.toString(),
          lineNo: 141);
      sentSuccessInServer = true;
    }

    i++;
    print("INDEX = " + i.toString());
  } while (i < list.length && sentSuccessInServer == true);
}
