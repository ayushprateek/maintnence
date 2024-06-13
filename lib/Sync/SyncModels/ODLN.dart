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

List<ODLNModel> ODLNModelFromJson(String str) =>
    List<ODLNModel>.from(json.decode(str).map((x) => ODLNModel.fromJson(x)));

String ODLNModelToJson(List<ODLNModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ODLNModel {
  ODLNModel({
    this.ID,
    this.TransId,
    this.PermanentTransId,
    this.CardCode,
    this.CreateDate,
    this.UpdateDate,
    this.hasCreated = false,
    this.hasUpdated = false,
    this.CardName,
    this.RefNo,
    this.ContactPersonId,
    this.ContactPersonName,
    this.MobileNo,
    this.PostingDate,
    this.ValidUntill,
    this.Currency,
    this.CurrRate,
    this.PaymentTermCode,
    this.PaymentTermName,
    this.PaymentTermDays,
    this.ApprovalStatus,
    this.DocEntry,
    this.DocNum,
    this.DocStatus,
    this.RPTransId,
    this.DSTranId,
    this.CRTransId,
    this.BaseTab,
    this.TotBDisc,
    this.DiscPer,
    this.DiscVal,
    this.TaxVal,
    this.DocTotal,
    this.CreatedBy,
    this.Longitude,
    this.Latitude,
    this.ApprovedBy,
    this.UpdatedBy,
    this.BranchId,
    this.Remarks,
    this.LocalDate,
    this.WhsCode,
    this.ObjectCode,
  });

  int? ID;
  int? DocEntry;
  String? DocNum;
  String? TransId;
  String? PermanentTransId;
  String? CardCode;
  String? CardName;
  String? RefNo;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  bool hasCreated;
  bool hasUpdated;
  int? ContactPersonId;
  String? ContactPersonName;
  String? MobileNo;
  DateTime? PostingDate;
  DateTime? ValidUntill;
  String? Currency;
  double? CurrRate;
  String? PaymentTermCode;
  String? PaymentTermName;
  int? PaymentTermDays;
  String? ApprovalStatus;
  String? DocStatus;
  String? RPTransId;
  String? DSTranId;
  String? CRTransId;
  String? BaseTab;
  double? TotBDisc;
  double? DiscPer;
  double? DiscVal;
  double? TaxVal;
  double? DocTotal;
  String? ApprovedBy;
  String? CreatedBy;
  String? Longitude;
  String? Latitude;
  String? UpdatedBy;
  String? BranchId;
  String? Remarks;
  String? LocalDate;
  String? WhsCode;
  String? ObjectCode;

  factory ODLNModel.fromJson(Map<String, dynamic> json) => ODLNModel(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        DocEntry: int.tryParse(json["DocEntry"].toString()) ?? 0,
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] == 1,
        hasUpdated: json['has_updated'] == 1,
        DocNum: json["DocNum"] ?? "",
        TransId: json["TransId"] ?? "",
        PermanentTransId: json["PermanentTransId"] ?? "",
        CardCode: json["CardCode"] ?? "",
        ApprovedBy: json["ApprovedBy"] ?? "",
        CardName: json["CardName"] ?? "",
        Latitude: json["Latitude"] ?? "",
        RefNo: json["RefNo"] ?? "",
        ContactPersonId: int.tryParse(json["ContactPersonId"].toString()) ?? 0,
        ContactPersonName: json["ContactPersonName"] ?? "",
        MobileNo: json["MobileNo"] ?? "",
        PostingDate: DateTime.tryParse(json["PostingDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        ValidUntill: DateTime.tryParse(json["ValidUntill"].toString()) ??
            DateTime.parse("1900-01-01"),
        Currency: json["Currency"] ?? "",
        CurrRate: double.tryParse(json["CurrRate"].toString()) ?? 0.0,
        PaymentTermCode: json["PaymentTermCode"] ?? "",
        PaymentTermName: json["PaymentTermName"] ?? "",
        PaymentTermDays: int.tryParse(json["PaymentTermDays"].toString()) ?? 0,
        ApprovalStatus: json["ApprovalStatus"] ?? "",
        CreatedBy: json["CreatedBy"] ?? "",
        DocStatus: json["DocStatus"] ?? "",
        RPTransId: json["RPTransId"] ?? "",
        DSTranId: json["DSTranId"] ?? "",
        Longitude: json["Longitude"] ?? "",
        CRTransId: json["CRTransId"] ?? "",
        BaseTab: json["BaseTab"] ?? "",
        TotBDisc: double.tryParse(json["TotBDisc"].toString()) ?? 0.0,
        DiscPer: double.tryParse(json["DiscPer"].toString()) ?? 0.0,
        DiscVal: double.tryParse(json["DiscVal"].toString()) ?? 0.0,
        TaxVal: double.tryParse(json["TaxVal"].toString()) ?? 0.0,
        DocTotal: double.tryParse(json["DocTotal"].toString()) ?? 0.0,
        UpdatedBy: json['UpdatedBy'] ?? '',
        BranchId: json['BranchId'] ?? '',
        Remarks: json['Remarks'] ?? '',
        LocalDate: json['LocalDate'] ?? '',
        WhsCode: json['WhsCode'] ?? '',
        ObjectCode: json['ObjectCode'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "DocNum": DocNum,
        "ID": ID,
        "CreateDate": CreateDate?.toIso8601String(),
        "UpdateDate": UpdateDate?.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "has_updated": hasUpdated ? 1 : 0,
        "TransId": TransId,
        "PermanentTransId": PermanentTransId,
        "CardCode": CardCode,
        "CardName": CardName,
        "RefNo": RefNo,
        "Latitude": Latitude,
        "ContactPersonId": ContactPersonId,
        "ContactPersonName": ContactPersonName,
        "MobileNo": MobileNo,
        "PostingDate": PostingDate?.toIso8601String(),
        "ValidUntill": ValidUntill?.toIso8601String(),
        "Currency": Currency,
        "CurrRate": CurrRate,
        "PaymentTermCode": PaymentTermCode,
        "PaymentTermName": PaymentTermName,
        "Longitude": Longitude,
        "PaymentTermDays": PaymentTermDays,
        "ApprovalStatus": ApprovalStatus,
        "DocStatus": DocStatus,
        "CreatedBy": CreatedBy,
        "RPTransId": RPTransId,
        "DSTranId": DSTranId,
        "CRTransId": CRTransId,
        "BaseTab": BaseTab,
        "TotBDisc": TotBDisc,
        "DiscPer": DiscPer,
        "DiscVal": DiscVal,
        "TaxVal": TaxVal,
        "ApprovedBy": ApprovedBy,
        "DocTotal": double.tryParse(DocTotal?.toStringAsFixed(2) ?? '0') ?? 0.0,
        'UpdatedBy': UpdatedBy,
        'BranchId': BranchId,
        'Remarks': Remarks,
        'LocalDate': LocalDate,
        'WhsCode': WhsCode,
        'ObjectCode': ObjectCode,
      };
}

// Future<void> insertODLN(Database db) async {
//   if(postfix.toLowerCase().contains("all"))
//   await deleteODLN(db);
//   List customers = await dataSyncODLN();
//   print(customers);
//   var batch = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try
//     {
//       batch.insert('ODLN', customer.toJson());
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
//   //       await db.insert('ODLN', customer.toJson());
//   //     });
//   //   }
//   //   catch(e)
//   //   {
//   //     getErrorSnackBar("Sync Error "+e.toString());
//   //   }
//   //
//   // });
// }
// Future<void> insertODLN(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteODLN(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncODLN();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('ODLN_Temp', customer.toJson());
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
//       "SELECT * FROM  ODLN_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN UpdateDate IS NULL THEN CreateDate ELSE UpdateDate END)");
//   u.forEach((element) {
//     batch2.update("ODLN", element,
//         where: "TransId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["TransId"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from ODLN_Temp where TransId not in (Select TransId from ODLN)");
//   v.forEach((element) {
//     batch3.insert('ODLN', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('ODLN_Temp');
// }
Future<void> insertODLN(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteODLN(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncODLN();
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
      for (ODLNModel record in batchRecords) {
        try {
          batch.insert('ODLN_Temp', record.toJson());
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
			select * from ODLN_Temp
			except
			select * from ODLN
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
          batch.update("ODLN", element,
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
  print('Time taken for ODLN update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from ODLN_Temp where TransId not in (Select TransId from ODLN)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM ODLN_Temp T0
LEFT JOIN ODLN T1 ON T0.TransId = T1.TransId 
WHERE T1.TransId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('ODLN', record);
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
      'Time taken for ODLN_Temp and ODLN compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('ODLN_Temp');
  // stopwatch.stop();
}

Future<List<ODLNModel>> dataSyncODLN() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "ODLN" + postfix));
  print(res.body);
  return ODLNModelFromJson(res.body);
}

Future<List<ODLNModel>> retrieveODLN(BuildContext context,
    {String? orderBy}) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('ODLN', orderBy: orderBy);
  return queryResult.map((e) => ODLNModel.fromJson(e)).toList();
}

Future<void> updateODLN(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update("ODLN", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteODLN(Database db) async {
  await db.delete('ODLN');
}

Future<List<ODLNModel>> retrieveODLNByBranch(BuildContext context,
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
      await db.query("ODLN", where: str, whereArgs: list, orderBy: orderBy);
  return queryResult.map((e) => ODLNModel.fromJson(e)).toList();
}

//SEND DATA TO SERVER
//--------------------------
Future<List<ODLNModel>> retrieveODLNById(
    BuildContext? context, String str, List l,
    {String? orderBy}) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('ODLN', where: str, whereArgs: l, orderBy: orderBy);
  return queryResult.map((e) => ODLNModel.fromJson(e)).toList();
}

Future<void> insertODLNToServer(BuildContext? context,
    {String? TransId}) async {
  String response = "";
  List<ODLNModel> list = await retrieveODLNById(
      context,
      TransId == null ? DataSync.getInsertToServerStr() : "TransId = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId]);
  if (TransId != null) {
    //only single entry
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "ODLN/Add"),
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
            .post(Uri.parse(prefix + "ODLN/Add?$queryParams"),
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
          ODLNModel model = ODLNModel.fromJson(jsonDecode(res.body));
          var x = await db.update("ODLN", model.toJson(),
              where: "TransId = ?", whereArgs: [model.TransId]);
          print(x.toString());
        } else if (res.statusCode == 201 || res.statusCode == 500) {
          sentSuccessInServer = true;
          if (res.statusCode == 201) {
            map['ID'] = jsonDecode(res.body)['ID'];
            map['PermanentTransId'] = jsonDecode(res.body)['PermanentTransId'];
            final Database db = await initializeDB(context);
            map["has_created"] = 0;
            var x = await db.update("ODLN", map,
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

Future<void> updateODLNOnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<ODLNModel> list = await retrieveODLNById(
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
          .put(Uri.parse(prefix + 'ODLN/Update'),
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
          var x = await db.update("ODLN", map,
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
