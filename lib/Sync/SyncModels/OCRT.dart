import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/MenuDescription.dart';
import 'package:maintenance/Component/Mode.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:maintenance/Sync/SyncModels/OUSR.dart';
import 'package:maintenance/main.dart';
import 'package:sqflite/sqlite_api.dart';

List<OCRTModel> OCRTModelFromJson(String str) =>
    List<OCRTModel>.from(json.decode(str).map((x) => OCRTModel.fromJson(x)));

String OCRTModelToJson(List<OCRTModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OCRTModel {
  OCRTModel({
    this.ID,
    this.hasCreated = false,
    this.hasUpdated = false,
    this.TransId,
    this.PermanentTransId,
    this.CardCode,
    this.CardName,
    this.ContactPersonId,
    this.ContactPersonName,
    this.MobileNo,
    this.PostingDate,
    this.Currency,
    this.CurrRate,
    this.DocStatus,
    this.INTransId,
    this.Amount,
    this.RPTransId,
    this.CreatedBy,
    this.DocType,
    this.DocEntry,
    this.DocNum,
    this.Error,
    this.CreateDate,
    this.UpdateDate,
    this.OpenAmt,
    this.UpdatedBy,
    this.BranchId,
    this.Remarks,
    this.LocalDate,
    this.AdAmount,
    this.ApprovalStatus,
    this.RouteCode,
    this.RouteName,
    this.Longitude,
    this.Latitude,
  });

  int? ID;
  String? RouteCode;
  String? RouteName;
  String? CreatedBy;
  String? TransId;
  String? PermanentTransId;
  String? CardCode;
  String? CardName;

  bool hasCreated;
  bool hasUpdated;
  int? ContactPersonId;
  String? ContactPersonName;
  String? MobileNo;
  DateTime? PostingDate;
  String? Currency;
  double? CurrRate;
  String? DocStatus;
  String? ApprovalStatus;
  String? INTransId;
  double? Amount;
  double? AdAmount;
  String? Longitude;
  String? Latitude;

  String? DocType;
  String? RPTransId;

  int? DocEntry;
  String? DocNum;
  String? Error;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  double? OpenAmt;
  String? UpdatedBy;
  String? BranchId;
  String? Remarks;
  String? LocalDate;

  factory OCRTModel.fromJson(Map<String, dynamic> json) => OCRTModel(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        RouteCode: json["RouteCode"] ?? "",
        RouteName: json["RouteName"] ?? "",
        RPTransId: json["RPTransId"] ?? "",
        DocType: json["DocType"] ?? "",
        CreatedBy: json["CreatedBy"] ?? "",
        hasCreated: json['has_created'] == 1,
        hasUpdated: json['has_updated'] == 1,
        TransId: json["TransId"] ?? "",
        PermanentTransId: json["PermanentTransId"] ?? "",
        CardCode: json["CardCode"] ?? "",
        ApprovalStatus: json["ApprovalStatus"] ?? "",
        CardName: json["CardName"] ?? "",
        ContactPersonId: int.tryParse(json["ContactPersonId"].toString()) ?? 0,
        ContactPersonName: json["ContactPersonName"] ?? "",
        MobileNo: json["MobileNo"] ?? "",
        PostingDate: DateTime.tryParse(json["PostingDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        Currency: json["Currency"] ?? "",
        CurrRate: double.tryParse(json["CurrRate"].toString()) ?? 0.0,
        DocStatus: json["DocStatus"] ?? "",
        INTransId: json["INTransId"] ?? "",
        Amount: double.tryParse(json["Amount"].toString()) ?? 0.0,
        AdAmount: double.tryParse(json["AdAmount"].toString()) ?? 0.0,
        DocEntry: int.tryParse(json['DocEntry'].toString()),
        DocNum: json['DocNum'] ?? '',
        Error: json['Error'] ?? '',
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()) ??
            DateTime.parse('1900-01-01'),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()) ??
            DateTime.parse('1900-01-01'),
        OpenAmt: double.tryParse(json['OpenAmt'].toString()) ?? 0.0,
        UpdatedBy: json['UpdatedBy'] ?? '',
        BranchId: json['BranchId'] ?? '',
        Remarks: json['Remarks'] ?? '',
        LocalDate: json['LocalDate'] ?? '',
        Longitude: json["Longitude"] ?? "",
        Latitude: json["Latitude"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "RPTransId": RPTransId,
        "has_created": hasCreated ? 1 : 0,
        "has_updated": hasUpdated ? 1 : 0,
        "PermanentTransId": PermanentTransId,
        "TransId": TransId,
        "CardCode": CardCode,
        "CardName": CardName,
        "ApprovalStatus": ApprovalStatus,
        "CreatedBy": CreatedBy,
        "DocType": DocType,
        "ContactPersonId": ContactPersonId,
        "ContactPersonName": ContactPersonName,
        "MobileNo": MobileNo,
        "PostingDate": PostingDate?.toIso8601String(),
        "Currency": Currency,
        "CurrRate": CurrRate,
        "Latitude": Latitude,
        "Longitude": Longitude,
        "DocStatus": DocStatus,
        "INTransId": INTransId,
        "Amount": Amount,
        "AdAmount": AdAmount,
        'DocEntry': DocEntry,
        'DocNum': DocNum,
        'Error': Error,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'OpenAmt': OpenAmt,
        'UpdatedBy': UpdatedBy,
        'BranchId': BranchId,
        'Remarks': Remarks,
        'LocalDate': LocalDate,
      };
}

Future<List<OCRTModel>> retrieveOCRT(BuildContext context,
    {String? orderBy}) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('OCRT', orderBy: orderBy);
  return queryResult.map((e) => OCRTModel.fromJson(e)).toList();
}

Future<List<OCRTModel>> retrieveOCRTRoutePlan() async {
  final Database db = await initializeDB(null);
  String query = '';
  if (await Mode.isCompany(MenuDescription.routePlan)) {
    query = '''SELECT DISTINCT T0.RPTransId,T1.RouteCode,T1.RouteName
FROM OCRT T0 INNER JOIN ORTP T1 ON T0.RPTransId=T1.TransId
WHERE T0.OpenAmt > 0 ORDER BY T0.RPTransId DESC;''';
  } else if (await Mode.isBranch(MenuDescription.routePlan)) {
    query = '''SELECT DISTINCT T0.RPTransId,T1.RouteCode,T1.RouteName
FROM OCRT T0 INNER JOIN ORTP T1 ON T0.RPTransId=T1.TransId
WHERE T0.OpenAmt > 0 AND T0.BranchId=${userModel.BranchId} ORDER BY T0.RPTransId DESC;''';
  } else if (await Mode.isSelf(MenuDescription.routePlan)) {
    query = '''SELECT DISTINCT T0.RPTransId,T1.RouteCode,T1.RouteName
FROM OCRT T0 INNER JOIN ORTP T1 ON T0.RPTransId=T1.TransId
WHERE T0.OpenAmt > 0 AND T0.CreatedBy='${userModel.UserCode}' ORDER BY T0.RPTransId DESC;''';
  } else {
    return [];
  }

  final List<Map<String, Object?>> queryResult = await db.rawQuery(query);
  return queryResult.map((e) => OCRTModel.fromJson(e)).toList();
}

// Future<void> insertOCRT(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteOCRT(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncOCRT();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('OCRT_Temp', customer.toJson());
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
//       "SELECT * FROM  OCRT_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("OCRT", element,
//         where: "TransId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["TransId"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from OCRT_Temp where TransId not in (Select TransId from OCRT)");
//   v.forEach((element) {
//     batch3.insert('OCRT', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('OCRT_Temp');
// }
Future<void> insertOCRT(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteOCRT(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncOCRT();
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
      for (OCRTModel record in batchRecords) {
        try {
          batch.insert('OCRT_Temp', record.toJson());
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
			select * from OCRT_Temp
			except
			select * from OCRT
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
          batch.update("OCRT", element,
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
  print('Time taken for OCRT update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from OCRT_Temp where TransId not in (Select TransId from OCRT)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM OCRT_Temp T0
LEFT JOIN OCRT T1 ON T0.TransId = T1.TransId 
WHERE T1.TransId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('OCRT', record);
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
      'Time taken for OCRT_Temp and OCRT compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('OCRT_Temp');
  // stopwatch.stop();
}

Future<List<OCRTModel>> dataSyncOCRT() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "OCRT" + postfix));
  print(res.body);
  return OCRTModelFromJson(res.body);
}

Future<void> updateOCRT(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update("OCRT", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteOCRT(Database db) async {
  await db.delete('OCRT');
}

Future<List<OCRTModel>> retrieveOCRTByBranch(BuildContext context) async {
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
      await db.query("OCRT", where: str, whereArgs: list);
  return queryResult.map((e) => OCRTModel.fromJson(e)).toList();
}

//SEND DATA TO SERVER
//--------------------------
Future<List<OCRTModel>> retrieveOCRTById(
    BuildContext? context, String str, List l,
    {String? orderBy}) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('OCRT', where: str, whereArgs: l, orderBy: orderBy);
  return queryResult.map((e) => OCRTModel.fromJson(e)).toList();
}

Future<void> insertOCRTToServer(BuildContext? context,
    {String? TransId}) async {
  String response = "";
  List<OCRTModel> list = await retrieveOCRTById(
      context,
      TransId == null ? DataSync.getInsertToServerStr() : "TransId = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "OCRT/Add"),
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
            .post(Uri.parse(prefix + "OCRT/Add?$queryParams"),
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
          OCRTModel model = OCRTModel.fromJson(jsonDecode(res.body));
          map["ID"] = model.ID;
          map["has_created"] = 0;
          var x = await db.update("OCRT", map,
              where: "TransId = ?", whereArgs: [model.TransId]);
          print(x.toString());
        } else if (res.statusCode == 201 || res.statusCode == 500) {
          if (res.statusCode == 201) {
            map['ID'] = jsonDecode(res.body)['ID'];
            map['PermanentTransId'] = jsonDecode(res.body)['PermanentTransId'];
            final Database db = await initializeDB(context);
            map["has_created"] = 0;
            var x = await db.update("OCRT", map,
                where: "TransId = ?", whereArgs: [map["TransId"]]);
            print(x.toString());
          } else {
            writeToLogFile(
                text: '500 error \nMap : $map',
                fileName: StackTrace.current.toString(),
                lineNo: 141);
          }
          sentSuccessInServer = true;
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

Future<void> updateOCRTOnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<OCRTModel> list = await retrieveOCRTById(
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
          .put(Uri.parse(prefix + 'OCRT/Update'),
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
          var x = await db.update("OCRT", map,
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
