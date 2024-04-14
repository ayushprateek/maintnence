import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

class SUOITA {
  int? ID;
  String? TransId;
  String? BaseTransId;
  String? Remarks;
  String? CreatedBy;
  String? UpdatedBy;
  String? BranchId;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  String? PermanentTransId;
  int? DocEntry;
  String? DocNum;
  String? IssueStatus;
  String? AssignToEmpCode;
  String? AssignToEmpName;
  bool IsOwnDepartment;
  String? EmpCode;
  DateTime? PostingDate;
  String? ActivityTypeCode;
  String? ActivityTypeName;
  String? SubActivityTypeCode;
  String? SubActivityTypeName;
  String? Latitude;
  String? Longitude;
  String? Subject;
  String? PostingAddress;
  DateTime? StartDate;
  DateTime? StartTime;
  DateTime? EndDate;
  DateTime? EndTime;
  String? Notes;
  bool IsActivityDone;
  DateTime? ActivityCompleteTime;
  String? ActivityLocation;
  bool hasCreated;
  bool hasUpdated;

  SUOITA({
    this.ID,
    this.TransId,
    this.BaseTransId,
    this.Remarks,
    this.CreatedBy,
    this.UpdatedBy,
    this.BranchId,
    this.CreateDate,
    this.UpdateDate,
    this.PermanentTransId,
    this.DocEntry,
    this.DocNum,
    this.IssueStatus,
    this.AssignToEmpCode,
    this.AssignToEmpName,
    this.IsOwnDepartment = false,
    this.EmpCode,
    this.PostingDate,
    this.ActivityTypeCode,
    this.ActivityTypeName,
    this.SubActivityTypeCode,
    this.SubActivityTypeName,
    this.Latitude,
    this.Longitude,
    this.Subject,
    this.PostingAddress,
    this.StartDate,
    this.StartTime,
    this.EndDate,
    this.EndTime,
    this.Notes,
    this.IsActivityDone = false,
    this.ActivityCompleteTime,
    this.ActivityLocation,
    this.hasCreated = false,
    this.hasUpdated = false,
  });

  factory SUOITA.fromJson(Map<String, dynamic> json) => SUOITA(
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        TransId: json['TransId'],
        BaseTransId: json['BaseTransId'],
        Remarks: json['Remarks'],
        CreatedBy: json['CreatedBy'],
        UpdatedBy: json['UpdatedBy'],
        BranchId: json['BranchId'],
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()),
        PermanentTransId: json['PermanentTransId'],
        DocEntry: int.tryParse(json['DocEntry'].toString()) ?? 0,
        DocNum: json['DocNum'],
        IssueStatus: json['IssueStatus'],
        AssignToEmpCode: json['AssignToEmpCode'],
        AssignToEmpName: json['AssignToEmpName'],
        IsOwnDepartment: json['IsOwnDepartment'] is bool
            ? json['IsOwnDepartment']
            : json['IsOwnDepartment'] == 1,
        EmpCode: json['EmpCode'],
        PostingDate: DateTime.tryParse(json['PostingDate'].toString()),
        ActivityTypeCode: json['ActivityTypeCode'],
        ActivityTypeName: json['ActivityTypeName'],
        SubActivityTypeCode: json['SubActivityTypeCode'],
        SubActivityTypeName: json['SubActivityTypeName'],
        Latitude: json['Latitude'],
        Longitude: json['Longitude'],
        Subject: json['Subject'],
        PostingAddress: json['PostingAddress'],
        StartDate: DateTime.tryParse(json['StartDate'].toString()),
        StartTime: DateTime.tryParse(json['StartTime'].toString()),
        EndDate: DateTime.tryParse(json['EndDate'].toString()),
        EndTime: DateTime.tryParse(json['EndTime'].toString()),
        Notes: json['Notes'],
        IsActivityDone: json['IsActivityDone'] is bool
            ? json['IsActivityDone']
            : json['IsActivityDone'] == 1,
        ActivityCompleteTime:
            DateTime.tryParse(json['ActivityCompleteTime'].toString()),
        ActivityLocation: json['ActivityLocation'],
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
        'BaseTransId': BaseTransId,
        'Remarks': Remarks,
        'CreatedBy': CreatedBy,
        'UpdatedBy': UpdatedBy,
        'BranchId': BranchId,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'PermanentTransId': PermanentTransId,
        'DocEntry': DocEntry,
        'DocNum': DocNum,
        'IssueStatus': IssueStatus,
        'AssignToEmpCode': AssignToEmpCode,
        'AssignToEmpName': AssignToEmpName,
        'IsOwnDepartment': IsOwnDepartment,
        'EmpCode': EmpCode,
        'PostingDate': PostingDate?.toIso8601String(),
        'ActivityTypeCode': ActivityTypeCode,
        'ActivityTypeName': ActivityTypeName,
        'SubActivityTypeCode': SubActivityTypeCode,
        'SubActivityTypeName': SubActivityTypeName,
        'Latitude': Latitude,
        'Longitude': Longitude,
        'Subject': Subject,
        'PostingAddress': PostingAddress,
        'StartDate': StartDate?.toIso8601String(),
        'StartTime': StartTime?.toIso8601String(),
        'EndDate': EndDate?.toIso8601String(),
        'EndTime': EndTime?.toIso8601String(),
        'Notes': Notes,
        'IsActivityDone': IsActivityDone,
        'ActivityCompleteTime': ActivityCompleteTime?.toIso8601String(),
        'ActivityLocation': ActivityLocation,
        'has_created': hasCreated,
        'has_updated': hasUpdated,
      };
}

List<SUOITA> sUOITAFromJson(String str) =>
    List<SUOITA>.from(json.decode(str).map((x) => SUOITA.fromJson(x)));

String sUOITAToJson(List<SUOITA> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<SUOITA>> dataSyncSUOITA() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "SUOITA" + postfix));
  print(res.body);
  return sUOITAFromJson(res.body);
}

Future<List<SUOITA>> retrieveSUOITA(BuildContext context,
    {String? orderBy, int? limit}) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('SUOITA', orderBy: orderBy, limit: limit);
  return queryResult.map((e) => SUOITA.fromJson(e)).toList();
}

Future<void> updateSUOITA(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    await db.transaction((db) async {
      await db.update("SUOITA", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteSUOITA(Database db) async {
  await db.delete('SUOITA');
}

// Future<void> insertSUOITA(Database db)async{
//   if(postfix.toLowerCase().contains("all"))
//   await deleteSUOITA(db);
//   List customers= await dataSyncSUOITA();
//   print(customers);
//   var batch = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try
//     {
//       batch.insert('SUOITA', customer.toJson());
//     }
//     catch(e)
//     {
//       getErrorSnackBar("Sync Error "+e.toString());
//     }
//   });
//   await batch.commit(noResult: true);
//
//
//   // customers.forEach((customer) async {
//   //   print(customer.toJson());
//   //   try
//   //   {
//   //     db.transaction((db)async{
//   //       await db.insert('SUOITA', customer.toJson());
//   //     });
//   //   }
//   //   catch(e)
//   //   {
//   //     getErrorSnackBar("Sync Error "+e.toString());
//   //   }
//   //
//   // });
// }
// Future<void> insertSUOITA(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteSUOITA(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncSUOITA();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('SUOITA_Temp', customer.toJson());
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
//       "SELECT * FROM  SUOITA_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("SUOITA", element,
//         where: "TransId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["TransId"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//
//   var v = await db.rawQuery(
//       "Select * from SUOITA_Temp where TransId not in (Select TransId from SUOITA)");
//   v.forEach((element) {
//     batch3.insert('SUOITA', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('SUOITA_Temp');
// }
Future<void> insertSUOITA(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteSUOITA(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncSUOITA();
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
      for (SUOITA record in batchRecords) {
        try {
          batch.insert('SUOITA_Temp', record.toJson());
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
			select * from SUOITA_Temp
			except
			select * from SUOITA
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
          batch.update("SUOITA", element,
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
  print('Time taken for SUOITA update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from SUOITA_Temp where TransId not in (Select TransId from SUOITA)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM SUOITA_Temp T0
LEFT JOIN SUOITA T1 ON T0.TransId = T1.TransId 
WHERE T1.TransId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('SUOITA', record);
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
      'Time taken for SUOITA_Temp and SUOITA compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('SUOITA_Temp');
  // stopwatch.stop();
}

//SEND DATA TO SERVER
//--------------------------
Future<List<SUOITA>> retrieveSUOITAById(
    BuildContext? context, String str, List l,
    {String? orderBy}) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('SUOITA', where: str, whereArgs: l, orderBy: orderBy);
  return queryResult.map((e) => SUOITA.fromJson(e)).toList();
}

Future<void> insertSUOITAToServer(BuildContext? context,
    {String? TransId}) async {
  String response = "";
  List<SUOITA> list = await retrieveSUOITAById(
      context,
      TransId == null ? DataSync.getInsertToServerStr() : "TransId = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId]);
  if (TransId != null) {
    //only single entry
    var res = await http.post(Uri.parse(prefix + "SUOITA/Add"),
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
        print(map);
        map.remove('ID');
        String queryParams='TransId=${list[i].TransId}';
        var res = await http.post(Uri.parse(prefix + "SUOITA/Add?$queryParams"),
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
        if(res.statusCode ==409)
        {
          ///Already added in server
          final Database db = await initializeDB(context);
          SUOITA model=SUOITA.fromJson(jsonDecode(res.body));
          var x = await db.update("SUOITA", model.toJson(),
              where: "TransId = ?", whereArgs: [model.TransId]);
          print(x.toString());
        }
        else
        if (res.statusCode == 201 || res.statusCode == 500) {
          sentSuccessInServer = true;
          if (res.statusCode == 201) {
            map['ID'] = jsonDecode(res.body)['ID'];
            map['PermanentTransId'] = jsonDecode(res.body)['PermanentTransId'];
            final Database db = await initializeDB(context);
            map["has_created"] = 0;
            var x = await db.update("SUOITA", map,
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

Future<void> updateSUOITAOnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<SUOITA> list = await retrieveSUOITAById(
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
          .put(Uri.parse(prefix + 'SUOITA/Update'),
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
          var x = await db.update("SUOITA", map,
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
