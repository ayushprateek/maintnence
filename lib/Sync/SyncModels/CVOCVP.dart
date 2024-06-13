import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:maintenance/Sync/SyncModels/OUSR.dart';
import 'package:sqflite/sqlite_api.dart';

import '../../main.dart';

List<CVOCVP> CVOCVPFromJson(String str) =>
    List<CVOCVP>.from(json.decode(str).map((x) => CVOCVP.fromJson(x)));

String CVOCVPToJson(List<CVOCVP> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CVOCVP {
  CVOCVP({
    this.ID,
    this.TransId,
    this.RouteCode,
    this.RouteName,
    this.DocStatus,
    this.PostingAddress,
    this.UpdateDate,
    this.hasCreated = false,
    this.hasUpdated = false,
    this.CreateDate,
    this.CreatedBy,
    this.Remarks,
    this.BranchId,
    this.UpdatedBy,
    this.EmpCode1,
    this.EmpName1,
    this.EmpCode2,
    this.EmpName2,
    this.EmpCode3,
    this.EmpName3,
    this.StartDate,
    this.EndDate,
    this.ApprovalStatus,
    this.DocNum,
    this.DocEntry,
    this.PermanentTransId,
  });

  int? ID;
  int? DocEntry;
  String? TransId;
  String? PermanentTransId;
  String? DocNum;
  String? RouteCode;
  String? RouteName;
  String? EmpCode1;
  String? EmpName1;
  String? EmpCode2;
  String? EmpName2;
  String? EmpCode3;
  String? EmpName3;

  String? DocStatus;
  String? PostingAddress;
  String? Remarks;
  DateTime? StartDate;
  DateTime? EndDate;
  DateTime? UpdateDate;
  bool hasCreated;
  bool hasUpdated;
  DateTime? CreateDate;
  String? BranchId;
  String? CreatedBy;
  String? UpdatedBy;
  String? ApprovalStatus;

  factory CVOCVP.fromJson(Map<String, dynamic> json) => CVOCVP(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        DocEntry: int.tryParse(json["DocEntry"].toString()) ?? 0,
        DocNum: json["DocNum"] ?? "",
        PermanentTransId: json["PermanentTransId"] ?? "",
        TransId: json["TransId"] ?? "",
        EmpCode1: json['EmpCode1'] ?? "",
        EmpCode2: json['EmpCode2'] ?? '',
        EmpCode3: json['EmpCode3'] ?? '',
        EmpName1: json['EmpName1'] ?? "",
        EmpName2: json['EmpName2'] ?? "",
        EmpName3: json['EmpName3'] ?? "",
        EndDate: DateTime.tryParse(json["EndDate"].toString()),
        StartDate: DateTime.tryParse(json["StartDate"].toString()),
        RouteName: json['RouteName'],
        RouteCode: json['RouteCode'],
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] == 1,
        hasUpdated: json['has_updated'] == 1,
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        DocStatus: json["DocStatus"] ?? "",
        PostingAddress: json["PostingAddress"] ?? "",
        CreatedBy: json["CreatedBy"] ?? "",
        ApprovalStatus: json['ApprovalStatus'] ?? '',
        Remarks: json['Remarks'] ?? '',
        BranchId: json['BranchId'] ?? '',
        UpdatedBy: json['UpdatedBy'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "PostingAddress": PostingAddress,
        "DocNum": DocNum,
        "DocEntry": DocEntry,
        "PermanentTransId": PermanentTransId,
        "TransId": TransId,
        "EmpCode1": EmpCode1,
        "EmpCode2": EmpCode2,
        "EmpCode3": EmpCode3,
        "RouteCode": RouteCode,
        "UpdateDate": UpdateDate?.toIso8601String(),
        "EndDate": EndDate?.toIso8601String(),
        "StartDate": StartDate?.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "has_updated": hasUpdated ? 1 : 0,
        "CreateDate": CreateDate?.toIso8601String(),
        "DocStatus": DocStatus,
        "CreatedBy": CreatedBy,
        'Remarks': Remarks,
        'BranchId': BranchId,
        'ApprovalStatus': ApprovalStatus,
        'UpdatedBy': UpdatedBy,
      };
}

Future<List<CVOCVP>> dataSyncCVOCVP() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "CVOCVP" + postfix));
  print(res.body);
  return CVOCVPFromJson(res.body);
}

Future<List<CVOCVP>> retrieveCVOCVP(BuildContext context,
    {String? orderBy}) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.rawQuery('''
      SELECT  
(Select FirstName ||' '|| MiddleName || ' '||LastName from OEMP T2 WHERE T1.EmpCode1=T2.Code ) AS EmpName1,
(Select FirstName ||' '|| MiddleName || ' '||LastName from OEMP T2 WHERE T1.EmpCode2=T2.Code ) AS EmpName2,
(Select FirstName ||' '|| MiddleName || ' '||LastName from OEMP T2 WHERE T1.EmpCode3=T2.Code ) AS EmpName3,
(Select T3.RouteName from ROUT T3 WHERE T1.RouteCode=T3.RouteCode ) AS RouteName,
* FROM CVOCVP T1 ORDER BY $orderBy
      ''');
  return queryResult.map((e) => CVOCVP.fromJson(e)).toList();
}

Future<List<CVOCVP>> retrieveCVOCVPForSearch(BuildContext context,
    {String? orderBy}) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('CVOCVP', orderBy: orderBy);
  return queryResult.map((e) => CVOCVP.fromJson(e)).toList();
}

Future<void> updateCVOCVP(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update("CVOCVP", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteCVOCVP(Database db) async {
  await db.delete('CVOCVP');
}

// Future<void> insertCVOCVP(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteCVOCVP(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncCVOCVP();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('CVOCVP_Temp', customer.toJson());
//     } catch (e) {
//       writeToLogFile(
//           text: e.toString(),
//           fileName: StackTrace.current.toString(),
//           lineNo: 141);
//       getErrorSnackBar("Sync Error " + e.toString());
//     }
//   });
//   await batch1.commit(noResult: true);
//
//   var u = await db.rawQuery(
//       "SELECT * FROM  CVOCVP_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("CVOCVP", element,
//         where: "TransId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["TransId"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//
//   var v = await db.rawQuery(
//       "Select * from CVOCVP_Temp where TransId not in (Select TransId from CVOCVP)");
//   v.forEach((element) {
//     batch3.insert('CVOCVP', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('CVOCVP_Temp');
// }

Future<void> insertCVOCVP(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteCVOCVP(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncCVOCVP();
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
      for (CVOCVP record in batchRecords) {
        try {
          batch.insert('CVOCVP_Temp', record.toJson());
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
			select * from CVOCVP_Temp
			except
			select * from CVOCVP
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
          batch.update("CVOCVP", element,
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
  print('Time taken for CVOCVP update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from CVOCVP_Temp where TransId not in (Select TransId from CVOCVP)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM CVOCVP_Temp T0
LEFT JOIN CVOCVP T1 ON T0.TransId = T1.TransId 
WHERE T1.TransId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('CVOCVP', record);
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
      'Time taken for CVOCVP_Temp and CVOCVP compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('CVOCVP_Temp');
  // stopwatch.stop();
}

Future<List<CVOCVP>> retrieveCVOCVPByBranch(BuildContext context,
    {String? orderBy}) async {
  // 1. Find BranchId using CreatedBy from OUSR table. (done)
  //==> userModel.BranchId
  // 2. Find All users using that BranchId (done)
  // 3. Filter by CreatedBy and Display their data only.

  List<String> list = [];
  String str = "CreatedBy = ?";
  List<OUSRModel> ousrModel =
      await retrieveOUSRById(context, "BranchId = ?", [userModel.BranchId]);

  for (int i = 0; i < ousrModel.length; i++) {
    list.add(ousrModel[i].UserCode);
    if (i != 0) {
      str += " AND CreatedBy = ?";
    }
  }
  if (list.isEmpty) {
    str = "";
  }
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query("CVOCVP", where: str, whereArgs: list, orderBy: orderBy);

  return queryResult.map((e) => CVOCVP.fromJson(e)).toList();
}

//SEND DATA TO SERVER
//--------------------------
Future<List<CVOCVP>> retrieveCVOCVPById(
    BuildContext? context, String str, List l,
    {String? orderBy}) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('CVOCVP', where: str, whereArgs: l, orderBy: orderBy);
  return queryResult.map((e) => CVOCVP.fromJson(e)).toList();
}

Future<CVOCVP?> retrieveLatestVisitPlan() async {
  final Database db = await initializeDB(null);
  final List<Map<String, Object?>> queryResult = await db.rawQuery(
      "SELECT * FROM CVOCVP WHERE CreatedBy='${userModel.UserCode}'  ORDER BY CreateDate DESC  LIMIT 1");
  List<CVOCVP> list = queryResult.map((e) => CVOCVP.fromJson(e)).toList();
  if (list.isNotEmpty) {
    return list[0];
  }
  return null;
}

Future<void> insertCVOCVPToServer(BuildContext? context,
    {String? TransId}) async {
  String response = "";
  List<CVOCVP> list = await retrieveCVOCVPById(
      context,
      TransId == null ? DataSync.getInsertToServerStr() : "TransId = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId]);
  if (TransId != null) {
    //only single entry
    var res = await http.post(Uri.parse(prefix + "CVOCVP/Add"),
        headers: header, body: jsonEncode(list[0].toJson()));
    response = res.body;
  } else if (list.isNotEmpty) {
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
            .post(Uri.parse(prefix + "CVOCVP/Add?$queryParams"),
                headers: header, body: jsonEncode(map))
            .timeout(Duration(seconds: 30), onTimeout: () {
          return http.Response("Error", 500);
        });
        response = await res.body;
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
          CVOCVP model = CVOCVP.fromJson(jsonDecode(res.body));
          map["ID"] = model.ID;
          map["has_created"] = 0;
          var x = await db.update("CVOCVP", map,
              where: "TransId = ?", whereArgs: [model.TransId]);
          print(x.toString());
        } else if (res.statusCode == 201 || res.statusCode == 500) {
          sentSuccessInServer = true;
          if (res.statusCode == 201) {
            map['ID'] = jsonDecode(res.body)['ID'];
            map['PermanentTransId'] = jsonDecode(res.body)['PermanentTransId'];
            final Database db = await initializeDB(context);
            map["has_created"] = 0;
            var x = await db.update("CVOCVP", map,
                where: "TransId = ?", whereArgs: [map["TransId"]]);
            print(x.toString());
          } else {
            writeToLogFile(
                text: '500 error \nMap : $map',
                fileName: StackTrace.current.toString(),
                lineNo: 141);
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

Future<void> updateCVOCVPOnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<CVOCVP> list = await retrieveCVOCVPById(
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
          .put(Uri.parse(prefix + 'CVOCVP/Update'),
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
          var x = await db.update("CVOCVP", map,
              where: "TransId = ?", whereArgs: [map["TransId"]]);
          print(x.toString());
        } else {
          writeToLogFile(
              text: '500 error \nMap : $map',
              fileName: StackTrace.current.toString(),
              lineNo: 141);
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
