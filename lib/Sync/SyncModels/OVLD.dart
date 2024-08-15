import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:sqflite/sqlite_api.dart';

List<OVLDModel> OVLDModelFromJson(String str) =>
    List<OVLDModel>.from(json.decode(str).map((x) => OVLDModel.fromJson(x)));

String OVLDModelToJson(List<OVLDModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OVLDModel {
  OVLDModel({
    required this.ID,
    this.PermanentTransId,
    required this.TransId,
    required this.BaseTransId,
    required this.CreateDate,
    required this.UpdateDate,
    this.hasCreated = false,
    required this.RouteCode,
    required this.RouteName,
    required this.VehCode,
    required this.TruckNo,
    required this.TareWeight,
    required this.Volume,
    required this.LoadingCap,
    required this.DriverName,
    required this.ApprovedBy,
    required this.LoadingStatus,
    required this.DocStatus,
    required this.LoadDate,
    required this.ApprovalStatus,
    required this.CreatedBy,
    required this.LoadTime,
    this.DocNum,
    this.Error,
    this.IsPosted,
    this.WhsCode,
    this.Remarks,
    this.LocalDate,
    this.BranchId,
    this.UpdatedBy,
    this.DocEntry,
  });

  int ID;
  int? DocEntry;
  String TransId;
  String? PermanentTransId;
  String BaseTransId;
  String RouteCode;
  String RouteName;
  String VehCode;
  String ApprovedBy;
  String TruckNo;
  double TareWeight;
  double Volume;
  double LoadingCap;
  String DriverName;
  String ApprovalStatus;
  String LoadingStatus;
  String CreatedBy;
  String DocStatus;
  DateTime CreateDate;
  DateTime UpdateDate;
  bool hasCreated;
  DateTime LoadDate;
  DateTime LoadTime;
  String? DocNum;
  String? Error;
  bool? IsPosted;
  String? WhsCode;
  String? Remarks;
  String? LocalDate;
  String? BranchId;
  String? UpdatedBy;

  factory OVLDModel.fromJson(Map<String, dynamic> json) => OVLDModel(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        DocEntry: int.tryParse(json["DocEntry"].toString()) ?? 0,
        TransId: json["TransId"] ?? "",
        PermanentTransId: json["PermanentTransId"] ?? "",
        ApprovedBy: json["ApprovedBy"] ?? "",
        BaseTransId: json["BaseTransId"] ?? "",
        RouteCode: json["RouteCode"] ?? "",
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] == 1,
        CreatedBy: json["CreatedBy"] ?? "",
        RouteName: json["RouteName"] ?? "",
        VehCode: json["VehCode"] ?? "",
        ApprovalStatus: json["ApprovalStatus"] ?? "",
        TruckNo: json["TruckNo"] ?? "",
        TareWeight: double.tryParse(json["TareWeight"].toString()) ?? 0.0,
        Volume: double.tryParse(json["Volume"].toString()) ?? 0.0,
        LoadingCap: double.tryParse(json["LoadingCap"].toString()) ?? 0.0,
        DriverName: json["DriverName"] ?? "",
        LoadingStatus: json["LoadingStatus"] ?? "",
        DocStatus: json["DocStatus"] ?? "",
        LoadDate: DateTime.tryParse(json["LoadDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        LoadTime: DateTime.tryParse(json["LoadTime"].toString()) ??
            DateTime.parse("1900-01-01"),
        DocNum: json['DocNum'] ?? '',
        Error: json['Error'] ?? '',
        IsPosted:
            json['IsPosted'] is bool ? json['IsPosted'] : json['IsPosted'] == 1,
        WhsCode: json['WhsCode'] ?? '',
        Remarks: json['Remarks'] ?? '',
        LocalDate: json['LocalDate'] ?? '',
        BranchId: json['BranchId'] ?? '',
        UpdatedBy: json['UpdatedBy'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "DocEntry": DocEntry,
        "TransId": TransId,
        "BaseTransId": BaseTransId,
        "CreateDate": CreateDate.toIso8601String(),
        "UpdateDate": UpdateDate.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "RouteCode": RouteCode,
        "ApprovalStatus": ApprovalStatus,
        "RouteName": RouteName,
        "VehCode": VehCode,
        "TruckNo": TruckNo,
        "TareWeight": TareWeight,
        "Volume": Volume,
        "LoadingCap": LoadingCap,
        "DriverName": DriverName,
        "LoadingStatus": LoadingStatus,
        "CreatedBy": CreatedBy,
        "ApprovedBy": ApprovedBy,
        "DocStatus": DocStatus,
        "LoadDate": LoadDate.toIso8601String(),
        "LoadTime": LoadTime.toIso8601String(),
        'PermanentTransId': PermanentTransId,
        'DocNum': DocNum,
        'Error': Error,
        'IsPosted': IsPosted,
        'WhsCode': WhsCode,
        'Remarks': Remarks,
        'LocalDate': LocalDate,
        'BranchId': BranchId,
        'UpdatedBy': UpdatedBy,
      };
}

Future<List<OVLDModel>> dataSyncOVLD() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "OVLD" + postfix));
  print(res.body);
  return OVLDModelFromJson(res.body);
}

Future<List<OVLDModel>> retrieveOVLD(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('OVLD');
  return queryResult.map((e) => OVLDModel.fromJson(e)).toList();
}

Future<void> updateOVLD(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update("OVLD", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteOVLD(Database db) async {
  await db.delete('OVLD');
}

// Future<void> insertOVLD(Database db)async{
//   if(postfix.toLowerCase().contains("all"))
//   await deleteOVLD(db);
//   List customers= await dataSyncOVLD();
//   print(customers);
//   var batch = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try
//     {
//       batch.insert('OVLD', customer.toJson());
//     }
//     catch(e)
//     {
//       getErrorSnackBar("Sync Error "+e.toString());
//     }
//   });
//   await batch.commit(noResult: true);
//   // customers.forEach((customer) async {
//   //   print(customer.toJson());
//   //   try
//   //   {
//   //     db.transaction((db)async{
//   //       await db.insert('OVLD', customer.toJson());
//   //     });
//   //   }
//   //   catch(e)
//   //   {
//   //     getErrorSnackBar("Sync Error "+e.toString());
//   //   }
//   //
//   // });
// }
// Future<void> insertOVLD(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteOVLD(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncOVLD();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('OVLD_Temp', customer.toJson());
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
//       "SELECT * FROM  OVLD_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("OVLD", element,
//         where: "TransId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["TransId"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from OVLD_Temp where TransId not in (Select TransId from OVLD)");
//   v.forEach((element) {
//     batch3.insert('OVLD', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('OVLD_Temp');
// }
Future<void> insertOVLD(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteOVLD(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncOVLD();
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
      for (OVLDModel record in batchRecords) {
        try {
          batch.insert('OVLD_Temp', record.toJson());
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
			select * from OVLD_Temp
			except
			select * from OVLD
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
          batch.update("OVLD", element,
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
  print('Time taken for OVLD update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from OVLD_Temp where TransId not in (Select TransId from OVLD)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM OVLD_Temp T0
LEFT JOIN OVLD T1 ON T0.TransId = T1.TransId 
WHERE T1.TransId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('OVLD', record);
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
      'Time taken for OVLD_Temp and OVLD compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('OVLD_Temp');
  // stopwatch.stop();
}

//SEND DATA TO SERVER
//--------------------------
Future<List<OVLDModel>> retrieveOVLDById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('OVLD', where: str, whereArgs: l);
  return queryResult.map((e) => OVLDModel.fromJson(e)).toList();
}

// Future<void> insertOVLDToServer(BuildContext? context,
//     {String? TransId, int? ID}) async {
//   String response = "";
//   List<OVLDModel> list = await retrieveOVLDById(
//       context,
//       TransId == null
//           ? DataSync.getInsertToServerStr()
//           : "TransId = ? AND ID = ?",
//       TransId == null ? DataSync.getInsertToServerList() : [TransId, ID]);
//   if (TransId != null) {
//     //only single entry
//     list[0].ID = 0;
//     var res = await http.post(Uri.parse(prefix + "OVLD/Add"),
//         headers: header, body: jsonEncode(list[0].toJson()));
//     print(res.body);
//     response = res.body;
//   } else if (list.isNotEmpty) {
//     int i = 0;
//     bool sentSuccessInServer = false;
//     if (list.isEmpty) {
//       return;
//     }
//     do {
//       Map<String, dynamic> map = list[i].toJson();
//       sentSuccessInServer = false;
//       try {
//         map.remove('ID');
//         String queryParams = 'TransId=${list[i].TransId}';
//         var res = await http
//             .post(Uri.parse(prefix + "OVLD/Add?$queryParams"),
//                 headers: header, body: jsonEncode(map))
//             .timeout(Duration(seconds: 30), onTimeout: () {
//           return http.Response("Error", 500);
//         });
//         response = await res.body;
//         if (res.statusCode != 201) {
//           await writeToLogFile(
//               text:
//                   '${res.statusCode} error \nMap : $map\nResponse : ${res.body}',
//               fileName: StackTrace.current.toString(),
//               lineNo: 141);
//         }
//         if (res.statusCode == 409) {
//           ///Already added in server
//           final Database db = await initializeDB(context);
//           OVLDModel model = OVLDModel.fromJson(jsonDecode(res.body));
//           map["ID"] = model.ID;
//           map["has_created"] = 0;
//           var x = await db.update("OVLD", map,
//               where: "TransId = ?", whereArgs: [model.TransId]);
//           print(x.toString());
//         } else if (res.statusCode == 201 || res.statusCode == 500) {
//           sentSuccessInServer = true;
//           if (res.statusCode == 201) {
//             map['ID'] = jsonDecode(res.body)['ID'];
//             map['PermanentTransId'] = jsonDecode(res.body)['PermanentTransId'];
//             final Database db = await initializeDB(context);
//             map["has_created"] = 0;
//             var x = await db.update("OVLD", map,
//                 where: "TransId = ??", whereArgs: [map["TransId"]]);
//             print(x.toString());
//           } else {
//             writeToLogFile(
//                 text: '500 error \nMap : $map',
//                 fileName: StackTrace.current.toString(),
//                 lineNo: 141);
//           }
//         }
//         print(res.body);
//       } catch (e) {
//         writeToLogFile(
//             text: '${e.toString()}\nMap : $map',
//             fileName: StackTrace.current.toString(),
//             lineNo: 141);
//         sentSuccessInServer = true;
//       }
//       i++;
//       print("INDEX = " + i.toString());
//     } while (i < list.length && sentSuccessInServer == true);
//   }
// }
//
// Future<void> updateOVLDOnServer(BuildContext? context,
//     {String? condition, List? l}) async {
//   List<OVLDModel> list = await retrieveOVLDById(
//       context,
//       l == null ? DataSync.getUpdateOnServerStr() : condition ?? "",
//       l == null ? DataSync.getUpdateOnServerList() : l);
//   print(list);
//   int i = 0;
//   bool sentSuccessInServer = false;
//   if (list.isEmpty) {
//     return;
//   }
//   do {
//     Map<String, dynamic> map = list[i].toJson();
//     sentSuccessInServer = false;
//     try {
//       if (list.isEmpty) {
//         return;
//       }
//       Map<String, dynamic> map = list[i].toJson();
//       var res = await http
//           .put(Uri.parse(prefix + 'OVLD/Update'),
//               headers: header, body: jsonEncode(map))
//           .timeout(Duration(seconds: 30), onTimeout: () {
//         writeToLogFile(
//             text: '500 error \nMap : $map',
//             fileName: StackTrace.current.toString(),
//             lineNo: 141);
//         return http.Response('Error', 500);
//       });
//       print(await res.statusCode);
//       if (res.statusCode != 201) {
//         await writeToLogFile(
//             text:
//                 '${res.statusCode} error \nMap : $map\nResponse : ${res.body}',
//             fileName: StackTrace.current.toString(),
//             lineNo: 141);
//       }
//       if (res.statusCode == 201 || res.statusCode == 500) {
//         sentSuccessInServer = true;
//         if (res.statusCode == 201) {
//           final Database db = await initializeDB(context);
//           map["has_updated"] = 0;
//           var x = await db.update("OVLD", map,
//               where: "TransId = ?", whereArgs: [map["TransId"]]);
//           print(x.toString());
//         } else {
//           writeToLogFile(
//               text: '500 error \nMap : $map',
//               fileName: StackTrace.current.toString(),
//               lineNo: 141);
//         }
//       }
//       print(res.body);
//     } catch (e) {
//       writeToLogFile(
//           text: '${e.toString()}\nMap : $map',
//           fileName: StackTrace.current.toString(),
//           lineNo: 141);
//       sentSuccessInServer = true;
//     }
//
//     i++;
//     print("INDEX = " + i.toString());
//   } while (i < list.length && sentSuccessInServer == true);
// }
