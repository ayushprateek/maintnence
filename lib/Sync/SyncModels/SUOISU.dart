import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

class SUOISU {
  int? ID;
  String? TransId;
  String? CardCode;
  String? CardName;
  String? CategoryCode;
  String? CategoryName;
  String? CurrentlyHandledBy;
  String? Manager;
  DateTime? OpenDate;
  String? Priority;
  String? Subject;
  DateTime? CloseDate;
  String? Remarks;
  String? Attachment;
  String? CreatedBy;
  String? UpdatedBy;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  String? RefNo;
  String? MobileNo;
  DateTime? PostingDate;
  DateTime? ValidUntill;
  String? ApprovalStatus;
  String? DocStatus;
  String? BaseTransId;
  String? PermanentTransId;
  int? DocEntry;
  String? DocNum;
  String? Error;
  bool? IsPosted;
  String? Latitude;
  String? Longitude;
  String? ObjectCode;
  String? BranchId;
  String? PostingAddress;
  String? ProjectCode;
  String? ModuleCode;
  String? ModuleName;
  int? ContactPersonId;
  String? ContactPersonName;
  String? CustomerEmail;
  String? IssueSourceCode;
  String? IssueSourceName;
  bool? hasCreated;
  bool? hasUpdated;

  SUOISU({
    this.ID,
    this.TransId,
    this.CardCode,
    this.CardName,
    this.CategoryCode,
    this.CategoryName,
    this.CurrentlyHandledBy,
    this.Manager,
    this.OpenDate,
    this.Priority,
    this.Subject,
    this.CloseDate,
    this.Remarks,
    this.Attachment,
    this.CreatedBy,
    this.UpdatedBy,
    this.CreateDate,
    this.UpdateDate,
    this.RefNo,
    this.MobileNo,
    this.PostingDate,
    this.ValidUntill,
    this.ApprovalStatus,
    this.DocStatus,
    this.BaseTransId,
    this.PermanentTransId,
    this.DocEntry,
    this.DocNum,
    this.Error,
    this.IsPosted,
    this.Latitude,
    this.Longitude,
    this.ObjectCode,
    this.BranchId,
    this.PostingAddress,
    this.ProjectCode,
    this.ModuleCode,
    this.ModuleName,
    this.ContactPersonId,
    this.ContactPersonName,
    this.CustomerEmail,
    this.IssueSourceCode,
    this.IssueSourceName,
    this.hasCreated,
    this.hasUpdated,
  });

  factory SUOISU.fromJson(Map<String, dynamic> json) => SUOISU(
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        TransId: json['TransId'] ?? '',
        CardCode: json['CardCode'] ?? '',
        CardName: json['CardName'] ?? '',
        CategoryCode: json['CategoryCode'] ?? '',
        CategoryName: json['CategoryName'] ?? '',
        CurrentlyHandledBy: json['CurrentlyHandledBy'] ?? '',
        Manager: json['Manager'] ?? '',
        OpenDate: DateTime.tryParse(json['OpenDate'].toString()),
        Priority: json['Priority'] ?? '',
        Subject: json['Subject'] ?? '',
        CloseDate: DateTime.tryParse(json['CloseDate'].toString()),
        Remarks: json['Remarks'] ?? '',
        Attachment: json['Attachment'] ?? '',
        CreatedBy: json['CreatedBy'] ?? '',
        UpdatedBy: json['UpdatedBy'] ?? '',
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()),
        RefNo: json['RefNo'] ?? '',
        MobileNo: json['MobileNo'] ?? '',
        PostingDate: DateTime.tryParse(json['PostingDate'].toString()),
        ValidUntill: DateTime.tryParse(json['ValidUntill'].toString()),
        ApprovalStatus: json['ApprovalStatus'] ?? '',
        DocStatus: json['DocStatus'] ?? '',
        BaseTransId: json['BaseTransId'] ?? '',
        PermanentTransId: json['PermanentTransId'] ?? '',
        DocEntry: int.tryParse(json['DocEntry'].toString()) ?? 0,
        DocNum: json['DocNum'] ?? '',
        Error: json['Error'] ?? '',
        IsPosted:
            json['IsPosted'] is bool ? json['IsPosted'] : json['IsPosted'] == 1,
        Latitude: json['Latitude'] ?? '',
        Longitude: json['Longitude'] ?? '',
        ObjectCode: json['ObjectCode'] ?? '',
        BranchId: json['BranchId'] ?? '',
        PostingAddress: json['PostingAddress'] ?? '',
        ProjectCode: json['ProjectCode'] ?? '',
        ModuleCode: json['ModuleCode'] ?? '',
        ModuleName: json['ModuleName'] ?? '',
        ContactPersonId: int.tryParse(json['ContactPersonId'].toString()) ?? 0,
        ContactPersonName: json['ContactPersonName'] ?? '',
        CustomerEmail: json['CustomerEmail'] ?? '',
        IssueSourceCode: json['IssueSourceCode'] ?? '',
        IssueSourceName: json['IssueSourceName'] ?? '',
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
        'CardCode': CardCode,
        'CardName': CardName,
        'CategoryCode': CategoryCode,
        'CategoryName': CategoryName,
        'CurrentlyHandledBy': CurrentlyHandledBy,
        'Manager': Manager,
        'OpenDate': OpenDate?.toIso8601String(),
        'Priority': Priority,
        'Subject': Subject,
        'CloseDate': CloseDate?.toIso8601String(),
        'Remarks': Remarks,
        'Attachment': Attachment,
        'CreatedBy': CreatedBy,
        'UpdatedBy': UpdatedBy,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'RefNo': RefNo,
        'MobileNo': MobileNo,
        'PostingDate': PostingDate?.toIso8601String(),
        'ValidUntill': ValidUntill?.toIso8601String(),
        'ApprovalStatus': ApprovalStatus,
        'DocStatus': DocStatus,
        'BaseTransId': BaseTransId,
        'PermanentTransId': PermanentTransId,
        'DocEntry': DocEntry,
        'DocNum': DocNum,
        'Error': Error,
        'IsPosted': IsPosted,
        'Latitude': Latitude,
        'Longitude': Longitude,
        'ObjectCode': ObjectCode,
        'BranchId': BranchId,
        'PostingAddress': PostingAddress,
        'ProjectCode': ProjectCode,
        'ModuleCode': ModuleCode,
        'ModuleName': ModuleName,
        'ContactPersonId': ContactPersonId,
        'ContactPersonName': ContactPersonName,
        'CustomerEmail': CustomerEmail,
        'IssueSourceCode': IssueSourceCode,
        'IssueSourceName': IssueSourceName,
        'has_created': hasCreated,
        'has_updated': hasUpdated,
      };
}

List<SUOISU> sUOISUFromJson(String str) =>
    List<SUOISU>.from(json.decode(str).map((x) => SUOISU.fromJson(x)));

String sUOISUToJson(List<SUOISU> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<SUOISU>> dataSyncSUOISU() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "SUOISU" + postfix));
  print(res.body);
  return sUOISUFromJson(res.body);
}

// Future<void> insertSUOISU(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteSUOISU(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncSUOISU();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('SUOISU_Temp', customer.toJson());
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
//       "SELECT * FROM  SUOISU_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("SUOISU", element,
//         where: "TransId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["TransId"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from SUOISU_Temp where TransId not in (Select TransId from SUOISU)");
//   v.forEach((element) {
//     batch3.insert('SUOISU', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('SUOISU_Temp');
// }
Future<void> insertSUOISU(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteSUOISU(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncSUOISU();
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
      for (SUOISU record in batchRecords) {
        try {
          batch.insert('SUOISU_Temp', record.toJson());
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
			select * from SUOISU_Temp
			except
			select * from SUOISU
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
          batch.update("SUOISU", element,
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
  print('Time taken for SUOISU update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from SUOISU_Temp where TransId not in (Select TransId from SUOISU)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM SUOISU_Temp T0
LEFT JOIN SUOISU T1 ON T0.TransId = T1.TransId 
WHERE T1.TransId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('SUOISU', record);
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
      'Time taken for SUOISU_Temp and SUOISU compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('SUOISU_Temp');
  // stopwatch.stop();
}

Future<List<SUOISU>> retrieveSUOISU(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('SUOISU');
  return queryResult.map((e) => SUOISU.fromJson(e)).toList();
}

Future<void> updateSUOISU(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('SUOISU', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deleteSUOISU(Database db) async {
  await db.delete('SUOISU');
}

Future<List<SUOISU>> retrieveSUOISUById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('SUOISU', where: str, whereArgs: l);
  return queryResult.map((e) => SUOISU.fromJson(e)).toList();
}

Future<void> insertSUOISUToServer(BuildContext? context,
    {String? TransId, int? id}) async {
  String response = "";
  List<SUOISU> list = await retrieveSUOISUById(
      context,
      TransId == null ? DataSync.getInsertToServerStr() : "TransId = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "SUOISU/Add"),
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
        String queryParams='TransId=${list[i].TransId}';
        var res = await http.post(Uri.parse(prefix + "SUOISU/Add?$queryParams"),
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
        if(res.statusCode ==409)
        {
          ///Already added in server
          final Database db = await initializeDB(context);
          SUOISU model=SUOISU.fromJson(jsonDecode(res.body));
          var x = await db.update("SUOISU", model.toJson(),
              where: "TransId = ?", whereArgs: [model.TransId]);
          print(x.toString());
        }
        else
        if (res.statusCode == 201 || res.statusCode == 500) {
          sentSuccessInServer = true;
          if (res.statusCode == 201) {
            map['ID'] = jsonDecode(res.body)['ID'];
            final Database db = await initializeDB(context);
            // map = jsonDecode(res.body);
            map["has_created"] = 0;
            var x = await db.update("SUOISU", map,
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

Future<void> updateSUOISUOnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<SUOISU> list = await retrieveSUOISUById(
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
          .put(Uri.parse(prefix + 'SUOISU/Update'),
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
          var x = await db.update("SUOISU", map,
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
