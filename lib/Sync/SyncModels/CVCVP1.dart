import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:maintenance/Sync/SyncModels/OUSR.dart';
import 'package:sqflite/sqlite_api.dart';

import '../../main.dart';

List<CVCVP1> CVCVP1FromJson(String str) =>
    List<CVCVP1>.from(json.decode(str).map((x) => CVCVP1.fromJson(x)));

String CVCVP1ToJson(List<CVCVP1> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CVCVP1 {
  CVCVP1({
    this.ID,
    this.ATTransId,
    this.ContactPersonId,
    this.ContactPersonName,
    this.MobileNo,
    this.EmpCode,
    this.CardCode,
    this.CardName,
    this.EmpName,
    this.TransId,
    this.RowId,
    this.UpdateDate,
    this.hasCreated = false,
    this.hasUpdated = false,
    this.CreateDate,
    this.Latitude,
    this.Longitude,
    this.DocEntry,
    this.DocNum,
    this.LineStatus,
  });

  int? ID;

  /// CREATED FOR DEVELOPMENT PURPOSE ONLY
  int? RowId;
  String? LineStatus;
  String? ATTransId;
  String? TransId;
  String? Latitude;
  String? Longitude;

  String? EmpCode;

  /// CREATED FOR DEVELOPMENT PURPOSE ONLY
  String? EmpName;

  String? CardCode;
  String? CardName;
  int? ContactPersonId;
  String? ContactPersonName;
  String? MobileNo;

  DateTime? UpdateDate;
  bool hasCreated;
  bool hasUpdated;
  DateTime? CreateDate;
  int? DocEntry;
  String? DocNum;

  factory CVCVP1.fromJson(Map<String, dynamic> json) => CVCVP1(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        RowId: int.tryParse(json["RowId"].toString()) ?? 0,
        ContactPersonId: int.tryParse(json["ContactPersonId"].toString()) ?? 0,
        ATTransId: json["ATTransId"] ?? "",
        TransId: json["TransId"] ?? "",
        LineStatus: json['LineStatus'] ?? "",
        EmpCode: json['EmpCode'] ?? "",
        EmpName: json['EmpName'] ?? "",
        CardCode: json['CardCode'] ?? '',
        CardName: json['CardName'] ?? '',
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] == 1,
        hasUpdated: json['has_updated'] == 1,
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        ContactPersonName: json["ContactPersonName"] ?? "",
        MobileNo: json['MobileNo'] ?? '',
        DocEntry: json['DocEntry'],
        DocNum: json['DocNum'],
      );

  Map<String, dynamic> toJson() => {
        "RowId": RowId,
        "ID": ID,
        "LineStatus": LineStatus,
        "ContactPersonId": ContactPersonId,
        "TransId": TransId,
        "ATTransId": ATTransId,
        "EmpCode": EmpCode,
        "CardCode": CardCode,
        "CardName": CardName,
        "UpdateDate": UpdateDate?.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "has_updated": hasUpdated ? 1 : 0,
        "CreateDate": CreateDate?.toIso8601String(),
        "ContactPersonName": ContactPersonName,
        'MobileNo': MobileNo,
        'DocEntry': DocEntry,
        'DocNum': DocNum,
      };
}

Future<List<CVCVP1>> dataSyncCVCVP1() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "CVCVP1" + postfix));
  print(res.body);
  return CVCVP1FromJson(res.body);
}

Future<List<CVCVP1>> retrieveCVCVP1(BuildContext context,
    {String? orderBy}) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('CVCVP1', orderBy: orderBy);
  return queryResult.map((e) => CVCVP1.fromJson(e)).toList();
}

Future<void> updateCVCVP1(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update("CVCVP1", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteCVCVP1(Database db) async {
  await db.delete('CVCVP1');
}

// Future<void> insertCVCVP1(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteCVCVP1(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncCVCVP1();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('CVCVP1_Temp', customer.toJson());
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
//       "SELECT * FROM  CVCVP1_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("CVCVP1", element,
//         where: "ATTransId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["ATTransId"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//
//   var v = await db.rawQuery(
//       "Select * from CVCVP1_Temp where ATTransId not in (Select ATTransId from CVCVP1)");
//   v.forEach((element) {
//     batch3.insert('CVCVP1', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('CVCVP1_Temp');
// }

Future<void> insertCVCVP1(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteCVCVP1(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncCVCVP1();
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
      for (CVCVP1 record in batchRecords) {
        try {
          batch.insert('CVCVP1_Temp', record.toJson());
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
			select * from CVCVP1_Temp
			except
			select * from CVCVP1
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
          batch.update("CVCVP1", element,
              where:
                  "ATTransId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
              whereArgs: [element["ATTransId"], 1, 1]);
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
  print('Time taken for CVCVP1 update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from CVCVP1_Temp where ATTransId not in (Select ATTransId from CVCVP1)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM CVCVP1_Temp T0
LEFT JOIN CVCVP1 T1 ON T0.ATTransId = T1.ATTransId 
WHERE T1.ATTransId IS NULL;
''');

  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('CVCVP1', record);
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
      'Time taken for CVCVP1_Temp and CVCVP1 compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('CVCVP1_Temp');
  // stopwatch.stop();
}

Future<List<CVCVP1>> retrieveCVCVP1ByBranch(BuildContext context,
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
      await db.query("CVCVP1", where: str, whereArgs: list, orderBy: orderBy);

  return queryResult.map((e) => CVCVP1.fromJson(e)).toList();
}

//SEND DATA TO SERVER
//--------------------------
Future<List<CVCVP1>> retrieveCVCVP1ById(
    BuildContext? context, String str, List l,
    {String? orderBy}) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.rawQuery(
      "SELECT (Select FirstName ||' '|| MiddleName || ' '||LastName from OEMP T2 WHERE T1.EmpCode=T2.Code ) AS EmpName,T1.* FROM CVCVP1 T1 WHERE $str",
      l);
  return queryResult.map((e) => CVCVP1.fromJson(e)).toList();
}

Future<List<CVCVP1>> retrieveCVCVP1ForSearch(String TransId) async {
  final Database db = await initializeDB(null);
  final List<Map<String, Object?>> queryResult =
      await db.rawQuery('CVCVP1', []);
  return queryResult.map((e) => CVCVP1.fromJson(e)).toList();
}

Future<void> insertCVCVP1ToServer(BuildContext? context,
    {String? ATTransId}) async {
  String response = "";
  List<CVCVP1> list = await retrieveCVCVP1ById(
      context,
      ATTransId == null ? DataSync.getInsertToServerStr() : "ATTransId = ?",
      ATTransId == null ? DataSync.getInsertToServerList() : [ATTransId]);
  if (ATTransId != null) {
    //only single entry
    var res = await http.post(Uri.parse(prefix + "CVCVP1/Add"),
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
        String queryParams =
            'TransId=${list[i].TransId}&RowId=${list[i].RowId}';
        var res = await http
            .post(Uri.parse(prefix + "CVCVP1/Add?$queryParams"),
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
          CVCVP1 model = CVCVP1.fromJson(jsonDecode(res.body));
          map["ID"] = model.ID;
          map["has_created"] = 0;
          var x = await db.update("CVCVP1", map,
              where: "TransId = ? AND RowId = ?",
              whereArgs: [model.TransId, model.RowId]);
          print(x.toString());
        } else if (res.statusCode == 201 || res.statusCode == 500) {
          sentSuccessInServer = true;
          if (res.statusCode == 201) {
            map['ID'] = jsonDecode(res.body)['ID'];
            final Database db = await initializeDB(context);
            map["has_created"] = 0;
            var x = await db.update("CVCVP1", map,
                where: "ATTransId = ?", whereArgs: [map["ATTransId"]]);
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

Future<void> updateCVCVP1OnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<CVCVP1> list = await retrieveCVCVP1ById(
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
          .put(Uri.parse(prefix + 'CVCVP1/Update'),
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
          var x = await db.update("CVCVP1", map,
              where: "ATTransId = ?", whereArgs: [map["ATTransId"]]);
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
