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

//<create_statement>\r\nCREATE TABLE OSTK(\r\n[ID] [int],\r\n[TransId] [nvarchar](50) NULL,\r\n[EmpCode1] [nvarchar](50) NULL,\r\n[EmpCode2] [nvarchar](50) NULL,\r\n[EmpName1] [nvarchar](150) NULL,\r\n[EmpName2] [nvarchar](150) NULL,\r\n[CardCode] [nvarchar](100) NULL,\r\n[CardName] [nvarchar](150) NULL,\r\n[ContactPersonId] [int] NULL,\r\n[ContactPersonName] [nvarchar](150) NULL,\r\n[MobileNo] [nvarchar](50) NULL,\r\n[PostingDate] [datetime] NULL,\r\n[ApprovalStatus] [nvarchar](50) NULL,\r\n[DocStatus] [nvarchar](50) NULL,\r\n[Remarks] [nvarchar](255) NULL,\r\n[LocalDate] [nvarchar](255) NULL,\r\n[CreatedBy] [nvarchar](50) NULL,\r\n[UpdatedBy] [nvarchar](50) NULL,\r\n[BranchId] [nvarchar](10) NULL,\r\n[StockTakeDate] [datetime] NULL,\r\n[StockTakeTime] [time] NULL,\r\n[CreateDate] [datetime] NULL,\r\n[UpdateDate] [datetime] NULL,\r\n[has_created] [int] NULL DEFAULT (0),\r\n[has_updated]  [int] NULL DEFAULT(0)\r\n);\r\n    </create_statement>\

class OSTK {
  int? ID;
  int? DocEntry;
  String? TransId;
  String? PermanentTransId;
  String? DocNum;
  String? EmpCode1;
  String? EmpCode2;
  String? EmpName1;
  String? EmpName2;
  String? CardCode;
  String? CardName;
  int? ContactPersonId;
  String? ContactPersonName;
  String? MobileNo;
  DateTime? PostingDate;
  String? ApprovalStatus;
  String? DocStatus;
  String? Remarks;
  String? LocalDate;
  String? CreatedBy;
  String? UpdatedBy;
  String? BranchId;
  DateTime? StockTakeDate;
  DateTime? StockTakeTime;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  bool hasCreated;
  bool hasUpdated;

  OSTK({
    this.ID,
    this.TransId,
    this.DocNum,
    this.DocEntry,
    this.PermanentTransId,
    this.EmpCode1,
    this.EmpCode2,
    this.EmpName1,
    this.EmpName2,
    this.CardCode,
    this.CardName,
    this.ContactPersonId,
    this.ContactPersonName,
    this.MobileNo,
    this.PostingDate,
    this.ApprovalStatus,
    this.DocStatus,
    this.Remarks,
    this.LocalDate,
    this.CreatedBy,
    this.UpdatedBy,
    this.BranchId,
    this.StockTakeDate,
    this.StockTakeTime,
    this.CreateDate,
    this.UpdateDate,
    this.hasCreated = false,
    this.hasUpdated = false,
  });

  factory OSTK.fromJson(Map<String, dynamic> json) => OSTK(
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        TransId: json['TransId'],
        EmpCode1: json['EmpCode1'],
        EmpCode2: json['EmpCode2'],
        EmpName1: json['EmpName1'],
        EmpName2: json['EmpName2'],
        CardCode: json['CardCode'],
        CardName: json['CardName'],
        ContactPersonId: int.tryParse(json['ContactPersonId'].toString()) ?? 0,
        ContactPersonName: json['ContactPersonName'],
        MobileNo: json['MobileNo'],
        PostingDate: DateTime.tryParse(json['PostingDate'].toString()),
        ApprovalStatus: json['ApprovalStatus'],
        DocStatus: json['DocStatus'],
        Remarks: json['Remarks'],
        LocalDate: json['LocalDate'],
        CreatedBy: json['CreatedBy'],
        DocEntry: int.tryParse(json["DocEntry"].toString()) ?? 0,
        DocNum: json["DocNum"] ?? "",
        PermanentTransId: json["PermanentTransId"] ?? "",
        UpdatedBy: json['UpdatedBy'],
        BranchId: json['BranchId'],
        StockTakeDate: DateTime.tryParse(json['StockTakeDate'].toString()),
        StockTakeTime: DateTime.tryParse(json['StockTakeTime'].toString()),
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()),
        hasCreated: json['has_created'] is bool
            ? json['has_created']
            : json['has_created'] == 1,
        hasUpdated: json['has_updated'] is bool
            ? json['has_updated']
            : json['has_updated'] == 1,
      );

  Map<String, dynamic> toJson() => {
        'ID': ID,
        'TransId': TransId,
        "DocNum": DocNum,
        "DocEntry": DocEntry,
        "PermanentTransId": PermanentTransId,
        'EmpCode1': EmpCode1,
        'EmpCode2': EmpCode2,
        'EmpName1': EmpName1,
        'EmpName2': EmpName2,
        'CardCode': CardCode,
        'CardName': CardName,
        'ContactPersonId': ContactPersonId,
        'ContactPersonName': ContactPersonName,
        'MobileNo': MobileNo,
        'PostingDate': PostingDate?.toIso8601String(),
        'ApprovalStatus': ApprovalStatus,
        'DocStatus': DocStatus,
        'Remarks': Remarks,
        'LocalDate': LocalDate,
        'CreatedBy': CreatedBy,
        'UpdatedBy': UpdatedBy,
        'BranchId': BranchId,
        'StockTakeDate': StockTakeDate?.toIso8601String(),
        'StockTakeTime': StockTakeTime?.toIso8601String(),
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'has_created': hasCreated == true ? 1 : 0,
        'has_updated': hasUpdated == true ? 1 : 0,
      };
}

List<OSTK> oSTKFromJson(String str) =>
    List<OSTK>.from(json.decode(str).map((x) => OSTK.fromJson(x)));

String oSTKToJson(List<OSTK> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<OSTK>> dataSyncOSTK() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "OSTK" + postfix));
  print(res.body);
  return oSTKFromJson(res.body);
}

// Future<void> insertOSTK(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteOSTK(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncOSTK();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('OSTK_Temp', customer.toJson());
//     } catch (e) {
//       writeToLogFile(
//           text: e.toString(),
//           fileName: StackTrace.current.toString(),
//           lineNo: 141);
//       getErrorSnackBar('Sync Error ' + e.toString());
//     }
//   });
//   await batch1.commit(noResult: true);
//   var u = await db.rawQuery(
//       "SELECT * FROM  OSTK_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("OSTK", element,
//         where: "RowId = ? AND TransId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["RowId"], element["TransId"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from OSTK_Temp where TransId || RowId not in (Select TransId || RowId from OSTK)");
//   v.forEach((element) {
//     batch3.insert('OSTK', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('OSTK_Temp');
// }
Future<void> insertOSTK(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteOSTK(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncOSTK();
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
      for (OSTK record in batchRecords) {
        try {
          batch.insert('OSTK_Temp', record.toJson());
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
			select * from OSTK_Temp
			except
			select * from OSTK
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
          batch.update("OSTK", element,
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
  print('Time taken for OSTK update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from OSTK_Temp where TransId not in (Select TransId from OSTK)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM OSTK_Temp T0
LEFT JOIN OSTK T1 ON T0.TransId = T1.TransId 
WHERE T1.TransId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('OSTK', record);
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
      'Time taken for OSTK_Temp and OSTK compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('OSTK_Temp');
  // stopwatch.stop();
}

Future<List<OSTK>> retrieveOSTK(BuildContext context, {String? orderBy}) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('OSTK', orderBy: orderBy);
  return queryResult.map((e) => OSTK.fromJson(e)).toList();
}

Future<List<OSTK>> retrieveOSTKByBranch(BuildContext context,
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
      await db.query("OSTK", where: str, whereArgs: list, orderBy: orderBy);

  return queryResult.map((e) => OSTK.fromJson(e)).toList();
}

Future<void> updateOSTK(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('OSTK', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deleteOSTK(Database db) async {
  await db.delete('OSTK');
}

Future<List<OSTK>> retrieveOSTKById(BuildContext? context, String str, List l,
    {String? orderBy}) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('OSTK', where: str, whereArgs: l, orderBy: orderBy);
  return queryResult.map((e) => OSTK.fromJson(e)).toList();
}

Future<void> insertOSTKToServer(BuildContext? context,
    {String? TransId, int? id}) async {
  String response = "";
  List<OSTK> list = await retrieveOSTKById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "TransId = ? AND ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "OSTK/Add"),
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
            .post(Uri.parse(prefix + "OSTK/Add?$queryParams"),
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
          OSTK model = OSTK.fromJson(jsonDecode(res.body));
          map["ID"] = model.ID;
          map["has_created"] = 0;
          var x = await db.update("OSTK", map,
              where: "TransId = ?", whereArgs: [model.TransId]);
          print(x.toString());
        } else if (res.statusCode == 201 || res.statusCode == 500) {
          sentSuccessInServer = true;
          if (res.statusCode == 201) {
            map['ID'] = jsonDecode(res.body)['ID'];
            map['PermanentTransId'] = jsonDecode(res.body)['PermanentTransId'];
            final Database db = await initializeDB(context);
            // map = jsonDecode(res.body);
            map["has_created"] = 0;
            var x = await db.update("OSTK", map,
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

Future<void> updateOSTKOnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<OSTK> list = await retrieveOSTKById(
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
          .put(Uri.parse(prefix + 'OSTK/Update'),
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
          var x = await db.update("OSTK", map,
              where: "TransId = ? AND RowId = ?",
              whereArgs: [map["TransId"], map["RowId"]]);
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
