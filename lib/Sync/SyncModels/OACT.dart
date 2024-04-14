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

List<OACTModel> OACTModelFromJson(String str) =>
    List<OACTModel>.from(json.decode(str).map((x) => OACTModel.fromJson(x)));

String OACTModelToJson(List<OACTModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OACTModel {
  OACTModel({
    this.ID,
    this.IsMeetingDone = false,
    this.Longitude,
    this.Latitude,
    this.GeoLongitude,
    this.GeoLatitude,
    this.MeetingCompleteTime,
    this.CreateDate,
    this.UpdateDate,
    this.hasCreated = false,
    this.hasUpdated = false,
    this.TransId,
    this.PermanentTransId,
    this.CardCode,
    this.CardName,
    this.RefNo,
    this.ContactPersonId,
    this.ContactPersonName,
    this.MobileNo,
    this.PostingDate,
    this.DocStatus,
    this.Notes,
    this.Subject,
    this.MeetingLocation,
    this.GeoFancingDetails,
    this.StartDate,
    this.EndDate,
    this.StartTime,
    this.EndTime,
    this.CreatedBy,
    this.BranchId,
    this.UpdatedBy,
    this.DocEntry,
    this.DocNum,
    this.ApprovalStatus,
    this.Currency,
    this.CurrRate,
    this.CustomerVisitType,
    this.MeetingTypeCode,
    this.MeetingTypeName,
    this.SubMeetingTypeCode,
    this.SubMeetingTypeName,
    this.PostingAddress,
    this.BaseTransId,
    this.RouteCode,
    this.RouteName,
  });

  double? CurrRate;
  int? ID;
  int? DocEntry;
  String? CustomerVisitType;
  String? Latitude;
  String? Longitude;
  String? GeoLatitude;
  String? MeetingTypeCode;
  String? MeetingTypeName;
  String? SubMeetingTypeCode;
  String? SubMeetingTypeName;
  String? GeoLongitude;
  String? BaseTransId;
  String? DocNum;
  String? PostingAddress;
  String? RouteCode;
  String? RouteName;

  String? TransId;
  String? PermanentTransId;
  String? CardCode;
  String? CardName;
  String? RefNo;
  String? Currency;
  int? ContactPersonId;
  String? ContactPersonName;
  String? MobileNo;
  DateTime? PostingDate;
  DateTime? StartDate;
  DateTime? EndDate;
  DateTime? MeetingCompleteTime;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  bool IsMeetingDone;
  bool hasCreated;
  bool hasUpdated;
  DateTime? EndTime;
  DateTime? StartTime;
  String? DocStatus;
  String? Notes;
  String? Subject;
  String? ApprovalStatus;
  String? MeetingLocation;
  String? GeoFancingDetails;
  String? CreatedBy;
  String? BranchId;
  String? UpdatedBy;

  ///MADE FOR DEVELOPMENT PURPOSE ONLY
  bool isSelected = false;

  factory OACTModel.fromJson(Map<String, dynamic> json) => OACTModel(
        DocEntry: int.tryParse(json["DocEntry"].toString()) ?? 0,
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        CurrRate: double.tryParse(json["CurrRate"].toString()) ?? 0.0,
        Currency: json["Currency"] ?? "",
        MeetingTypeCode: json["MeetingTypeCode"] ?? "",
        MeetingTypeName: json["MeetingTypeName"] ?? "",
        SubMeetingTypeCode: json["SubMeetingTypeCode"] ?? "",
        SubMeetingTypeName: json["SubMeetingTypeName"] ?? "",
        CustomerVisitType: json["CustomerVisitType"] ?? "",
        BaseTransId: json["BaseTransId"] ?? "",
        PostingAddress: json["PostingAddress"] ?? "",
        RouteCode: json["RouteCode"] ?? "",
        RouteName: json["RouteName"] ?? "",
        DocNum: json["DocNum"] ?? "",
        TransId: json["TransId"] ?? "",
        PermanentTransId: json["PermanentTransId"] ?? "",
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        MeetingCompleteTime:
            DateTime.tryParse(json["MeetingCompleteTime"].toString()) ??
                DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        IsMeetingDone: json['IsMeetingDone'] == 1,
        hasCreated: json['has_created'] == 1,
        hasUpdated: json['has_updated'] == 1,
        Longitude: json["Longitude"] ?? "",
        Latitude: json["Latitude"] ?? "",
        GeoLongitude: json["GeoLongitude"] ?? "",
        GeoLatitude: json["GeoLatitude"] ?? "",
        CreatedBy: json["CreatedBy"] ?? "",
        Subject: json["Subject"] == null || json["Subject"] == ""
            ? "Test Subject"
            : json["Subject"],
        ApprovalStatus: json["ApprovalStatus"] ?? "",
        CardCode: json["CardCode"] ?? "",
        CardName: json["CardName"] ?? "",
        GeoFancingDetails:
            json["GeoFancingDetails"] == null || json["GeoFancingDetails"] == ""
                ? ""
                : json["GeoFancingDetails"],
        RefNo: json["RefNo"] ?? "",
        MeetingLocation:
            json["MeetingLocation"] == null || json["MeetingLocation"] == ""
                ? ""
                : json["MeetingLocation"] ?? "",
        ContactPersonId: int.tryParse(json["ContactPersonId"].toString()) ?? 0,
        ContactPersonName: json["ContactPersonName"] ?? "",
        MobileNo: json["MobileNo"] ?? "",
        EndTime: DateTime.tryParse(json["EndTime"].toString()) ??
            DateTime.parse("1900-01-01T12:00"),
        EndDate: DateTime.tryParse(json["EndDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        StartTime: DateTime.tryParse(json["StartTime"].toString()) ??
            DateTime.parse("1900-01-01T01:00"),
        StartDate: DateTime.tryParse(json["StartDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        PostingDate: DateTime.tryParse(json["PostingDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        DocStatus: json["DocStatus"] ?? "",
        Notes: json["Notes"] ?? "",
        BranchId: json['BranchId'] ?? '',
        UpdatedBy: json['UpdatedBy'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "RouteCode": RouteCode,
        "RouteName": RouteName,
        "BaseTransId": BaseTransId,
        "PostingAddress": PostingAddress,
        "MeetingTypeCode": MeetingTypeCode,
        "MeetingTypeName": MeetingTypeName,
        "SubMeetingTypeCode": SubMeetingTypeCode,
        "SubMeetingTypeName": SubMeetingTypeName,
        "IsMeetingDone": IsMeetingDone ? 1 : 0,
        "CustomerVisitType": CustomerVisitType,
        "Longitude": Longitude,
        "Latitude": Latitude,
        "GeoLongitude": GeoLongitude,
        "GeoLatitude": GeoLatitude,
        "DocNum": DocNum,
        "CurrRate": CurrRate,
        "ApprovalStatus": ApprovalStatus,
        "Currency": Currency,
        "DocEntry": DocEntry,
        "ID": ID,
        "TransId": TransId,
        "PermanentTransId": PermanentTransId,
        "CardCode": CardCode,
        "CardName": CardName,
        "MeetingCompleteTime": MeetingCompleteTime?.toIso8601String(),
        "CreateDate": CreateDate?.toIso8601String(),
        "UpdateDate": UpdateDate?.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "has_updated": hasUpdated ? 1 : 0,
        "RefNo": RefNo,
        "Subject": Subject,
        "ContactPersonId": ContactPersonId,
        "GeoFancingDetails": GeoFancingDetails,
        "MeetingLocation": MeetingLocation,
        "ContactPersonName": ContactPersonName,
        "MobileNo": MobileNo,
        "StartTime": StartTime?.toIso8601String(),
        "EndTime": EndTime?.toIso8601String(),
        "StartDate": StartDate?.toIso8601String(),
        "EndDate": EndDate?.toIso8601String(),
        "PostingDate": PostingDate?.toIso8601String(),
        "DocStatus": DocStatus,
        "Notes": Notes,
        "CreatedBy": CreatedBy,
        'BranchId': BranchId,
        'UpdatedBy': UpdatedBy,
      };
// Map<String, dynamic> toJson() => {
//   "ID": 0,
//   "TransId": TransId,
//         "PermanentTransId": PermanentTransId,
//   "CardCode": CardCode,
//   "CardName": CardName,
//   "RefNo": RefNo,
//   "ContactPersonId": ContactPersonId,
//   "ContactPerson": ContactPerson,
//   "MobileNo": MobileNo,
//   "DocStatus": DocStatus,
//   "Notes": Notes,
//   "MeetingType": MeetingType,
//   "Subject": Subject,
//   "MeetingLocation": MeetingLocation,
//   "GeoFancingDetails": GeoFancingDetails,
//   "StartTime": "2022-09-09T07:15:47.706Z",
//   "EndTime": "2022-09-09T07:15:47.706Z",
//   "CreatedBy": CreatedBy,
//   "StartDate": "2022-09-09T07:15:47.706Z",
//   "PostingDate": "2022-09-09T07:15:47.706Z",
//   "EndDate": "2022-09-09T07:15:47.706Z",
//   "createDate": "2022-09-09T07:15:47.706Z",
//   "updateDate": "2022-09-09T07:15:47.706Z"
// };
}

// Future<void> insertOACT(Database db)async{
//   if(postfix.toLowerCase().contains("all"))
//   await deleteOACT(db);
//   List customers= await dataSyncOACT();
//   print(customers);
//   var batch = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try
//     {
//       batch.insert('OACT', customer.toJson());
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
//   //       await db.insert('OACT', customer.toJson());
//   //     });
//   //   }
//   //   catch(e)
//   //   {
//   //     getErrorSnackBar("Sync Error "+e.toString());
//   //   }
//   //
//   // });
// }
// Future<void> insertOACT(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteOACT(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncOACT();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('OACT_Temp', customer.toJson());
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
//       "SELECT * FROM  OACT_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("OACT", element,
//         where: "TransId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["TransId"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from OACT_Temp where TransId  not in (Select TransId  from OACT)");
//   print(v.runtimeType);
//   v.forEach((element) {
//     print(element);
//     batch3.insert('OACT', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('OACT_Temp');
// }
Future<void> insertOACT(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteOACT(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncOACT();
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
      for (OACTModel record in batchRecords) {
        try {
          batch.insert('OACT_Temp', record.toJson());
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
			select * from OACT_Temp
			except
			select * from OACT
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
          batch.update("OACT", element,
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
  print('Time taken for OACT update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from OACT_Temp where TransId  not in (Select TransId  from OACT)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM OACT_Temp T0
LEFT JOIN OACT T1 ON T0.TransId = T1.TransId 
WHERE T1.TransId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('OACT', record);
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
      'Time taken for OACT_Temp and OACT compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('OACT_Temp');
  // stopwatch.stop();
}

Future<List<OACTModel>> dataSyncOACT() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "OACT" + postfix));
  print(res.body);
  return OACTModelFromJson(res.body);
}

Future<List<OACTModel>> retrieveOACT(BuildContext context,
    {String? orderBy}) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('OACT', orderBy: orderBy);
  return queryResult.map((e) => OACTModel.fromJson(e)).toList();
}

Future<List<OACTModel>> retrieveOACTForVisit(
    {required String RouteCode}) async {
  final Database db = await initializeDB(null);
  String query = '''
  SELECT T0.DocStatus,T0.* FROM OACT T0 WHERE 
CardCode IN (SELECT T1.Code FROM CRD2 T1 WHERE T1.RouteCode='$RouteCode')
  ''';
  final List<Map<String, Object?>> queryResult = await db.rawQuery(query);
  return queryResult.map((e) => OACTModel.fromJson(e)).toList();
}

Future<List<OACTModel>> retrieveOACTForSearch({required transId}) async {
  final Database db = await initializeDB(null);
  final List<Map<String, Object?>> queryResult = await db.rawQuery(
      "SELECT * FROM OACT where TransId LIKE '%$transId%' COLLATE NOCASE");
  return queryResult.map((e) => OACTModel.fromJson(e)).toList();
}

Future<void> updateOACT(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update("OACT", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteOACT(Database db) async {
  await db.delete('OACT');
}

Future<List<OACTModel>> retrieveOACTByBranch(BuildContext context,
    {String? orderBy}) async {
  // 1. Find BranchId using userCode from OUSR table. (done)
  //==> userModel.BranchId
  // 2. Find All users using that BranchId (done)
  // 3. Filter by userCode and Display their data only.

  List<String> list = [];
  String str = "userCode = ?";
  List<OUSRModel> ousrModel =
      await retrieveOUSRById(context, "BranchId = ?", [userModel.BranchId]);

  for (int i = 0; i < ousrModel.length; i++) {
    list.add(ousrModel[i].UserCode);
    if (i != 0) {
      str += " AND userCode = ?";
    }
  }
  if (list.isEmpty) {
    str = "";
  }
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query("OACT", where: str, whereArgs: list, orderBy: orderBy);
  return queryResult.map((e) => OACTModel.fromJson(e)).toList();
}

//SEND DATA TO SERVER
//--------------------------
Future<List<OACTModel>> retrieveOACTById(
    BuildContext? context, String str, List l,
    {String? orderBy}) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('OACT', where: str, whereArgs: l, orderBy: orderBy);
  return queryResult.map((e) => OACTModel.fromJson(e)).toList();
}

Future<void> insertOACTToServer(BuildContext? context,
    {String? TransId}) async {
  String response = "";
  List<OACTModel> list = await retrieveOACTById(
      context,
      TransId == null ? DataSync.getInsertToServerStr() : "TransId = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId]);
  if (TransId != null) {
    //only single entry
    var res = await http.post(Uri.parse(prefix + "OACT/Add"),
        headers: header, body: jsonEncode(list[0].toJson()));
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
        map['IsMeetingDone'] = map['IsMeetingDone'] == 1;
        String queryParams='TransId=${list[i].TransId}';
        var res = await http.post(Uri.parse(prefix + "OACT/Add?$queryParams"),
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
          OACTModel model=OACTModel.fromJson(jsonDecode(res.body));
          var x = await db.update("OACT", model.toJson(),
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
            var x = await db.update("OACT", map,
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

Future<void> updateOACTOnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<OACTModel> list = await retrieveOACTById(
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
          .put(Uri.parse(prefix + 'OACT/Update'),
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
          var x = await db.update("OACT", map,
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
