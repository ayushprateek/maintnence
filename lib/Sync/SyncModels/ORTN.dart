import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

List<ORTNModel> ORTNModelFromJson(String str) =>
    List<ORTNModel>.from(json.decode(str).map((x) => ORTNModel.fromJson(x)));

String? ORTNModelToJson(List<ORTNModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ORTNModel {
  ORTNModel({
    this.ID,
    this.TransId,
    this.PermanentTransId,
    this.CreateDate,
    this.UpdateDate,
    this.hasCreated = false,
    this.CardCode,
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
    this.DocStatus,
    this.RPTransId,
    this.DSTranId,
    this.CRTransId,
    this.CreatedBy,
    this.BaseTab,
    this.TotBDisc,
    this.DiscPer,
    this.DiscVal,
    this.TaxVal,
    this.DocTotal,
    this.DocEntry,
    this.DocNum,
    this.ApprovedBy,
    this.WhsCode,
    this.Remarks,
    this.LocalDate,
    this.BranchId,
    this.UpdatedBy,
    this.hasUpdated = false,
  });

  int? ID;
  String? TransId;
  String? PermanentTransId;
  String? CardCode;
  String? CardName;
  String? RefNo;
  int? ContactPersonId;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  bool hasCreated;
  bool hasUpdated;
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
  String? CreatedBy;
  String? BaseTab;
  double? TotBDisc;
  double? DiscPer;
  double? DiscVal;
  double? TaxVal;
  double? DocTotal;
  int? DocEntry;
  String? DocNum;
  String? ApprovedBy;
  String? WhsCode;
  String? Remarks;
  String? LocalDate;
  String? BranchId;
  String? UpdatedBy;

  factory ORTNModel.fromJson(Map<String, dynamic> json) => ORTNModel(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        TransId: json["TransId"] ?? "",
        PermanentTransId: json["PermanentTransId"] ?? "",
        CreatedBy: json["CreatedBy"] ?? "",
        CardCode: json["CardCode"] ?? "",
        CardName: json["CardName"] ?? "",
        RefNo: json["RefNo"] ?? "",
        ContactPersonId: int.tryParse(json["ContactPersonId"].toString()) ?? 0,
        ContactPersonName: json["ContactPersonName"] ?? "",
        MobileNo: json["MobileNo"] ?? "",
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] is bool
            ? json['has_created']
            : json['has_created'] == 1,
        hasUpdated: json['has_updated'] is bool
            ? json['has_updated']
            : json['has_updated'] == 1,
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
        DocStatus: json["DocStatus"] ?? "",
        RPTransId: json["RPTransId"] ?? "",
        DSTranId: json["DSTranId"] ?? "",
        CRTransId: json["CRTransId"] ?? "",
        BaseTab: json["BaseTab"] ?? "",
        TotBDisc: double.tryParse(json['TotBDisc'].toString()) ?? 0.0,
        DiscPer: double.tryParse(json['DiscPer'].toString()) ?? 0.0,
        DiscVal: double.tryParse(json['DiscVal'].toString()) ?? 0.0,
        TaxVal: double.tryParse(json['TaxVal'].toString()) ?? 0.0,
        DocTotal: double.tryParse(json['DocTotal'].toString()) ?? 0.0,
        DocEntry: int.tryParse(json['DocEntry'].toString()) ?? 0,
        DocNum: json['DocNum'] ?? '',
        ApprovedBy: json['ApprovedBy'] ?? '',
        WhsCode: json['WhsCode'] ?? '',
        Remarks: json['Remarks'] ?? '',
        LocalDate: json['LocalDate'] ?? '',
        BranchId: json['BranchId'] ?? '',
        UpdatedBy: json['UpdatedBy'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "TransId": TransId,
        "PermanentTransId": PermanentTransId,
        "CardCode": CardCode,
        "CardName": CardName,
        "RefNo": RefNo,
        "ContactPersonId": ContactPersonId,
        "ContactPersonName": ContactPersonName,
        "MobileNo": MobileNo,
        "CreateDate": CreateDate?.toIso8601String(),
        "UpdateDate": UpdateDate?.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "has_updated": hasUpdated ? 1 : 0,
        "PostingDate": PostingDate?.toIso8601String(),
        "ValidUntill": ValidUntill?.toIso8601String(),
        "Currency": Currency,
        "CurrRate": CurrRate,
        "PaymentTermCode": PaymentTermCode,
        "PaymentTermName": PaymentTermName,
        "PaymentTermDays": PaymentTermDays,
        "ApprovalStatus": ApprovalStatus,
        "DocStatus": DocStatus,
        "RPTransId": RPTransId,
        "DSTranId": DSTranId,
        "CRTransId": CRTransId,
        "CreatedBy": CreatedBy,
        "BaseTab": BaseTab,
        'TotBDisc': TotBDisc,
        'DiscPer': DiscPer,
        'DiscVal': DiscVal,
        'TaxVal': TaxVal,
        'DocTotal': DocTotal,
        'DocEntry': DocEntry,
        'DocNum': DocNum,
        'ApprovedBy': ApprovedBy,
        'WhsCode': WhsCode,
        'Remarks': Remarks,
        'LocalDate': LocalDate,
        'BranchId': BranchId,
        'UpdatedBy': UpdatedBy,
      };
}

Future<List<ORTNModel>> dataSyncORTN() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "ORTN" + postfix));
  print(res.body);
  return ORTNModelFromJson(res.body);
}

Future<List<ORTNModel>> retrieveORTN(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('ORTN');
  return queryResult.map((e) => ORTNModel.fromJson(e)).toList();
}

Future<void> updateORTN(
    int? id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update("ORTN", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteORTN(Database db) async {
  await db.delete('ORTN');
}

// Future<void> insertORTN(Database db)async{
//   if(postfix.toLowerCase().contains("all"))
//   await deleteORTN(db);
//   List customers= await dataSyncORTN();
//   print(customers);
//   var batch = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try
//     {
//       batch.insert('ORTN', customer.toJson());
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
//   //       await db.insert('ORTN', customer.toJson());
//   //     });
//   //   }
//   //   catch(e)
//   //   {
//   //     getErrorSnackBar("Sync Error "+e.toString());
//   //   }
//   //
//   // });
// }
// Future<void> insertORTN(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteORTN(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncORTN();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('ORTN_Temp', customer.toJson());
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
//   var v = await db.rawQuery(
//       "Select * from ORTN_Temp where TransId not in (Select TransId from ORTN)");
//   v.forEach((element) {
//     batch2.insert('ORTN', element);
//   });
//   await batch2.commit(noResult: true);
//
//   var u = await db.rawQuery(
//       "SELECT * FROM  ORTN_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch3.update("ORTN", element,
//         where: "TransId = ?", whereArgs: [element["TransId"]]);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('ORTN_Temp');
// }
Future<void> insertORTN(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteORTN(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncORTN();
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
      for (ORTNModel record in batchRecords) {
        try {
          batch.insert('ORTN_Temp', record.toJson());
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
			select * from ORTN_Temp
			except
			select * from ORTN
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
          batch.update("ORTN", element,
              where: "TransId = ?", whereArgs: [element["TransId"]]);
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
  print('Time taken for ORTN update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from ORTN_Temp where TransId not in (Select TransId from ORTN)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM ORTN_Temp T0
LEFT JOIN ORTN T1 ON T0.TransId = T1.TransId 
WHERE T1.TransId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('ORTN', record);
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
      'Time taken for ORTN_Temp and ORTN compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('ORTN_Temp');
  // stopwatch.stop();
}

//SEND DATA TO SERVER
//--------------------------
Future<List<ORTNModel>> retrieveORTNById(
    BuildContext? context, String? str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('ORTN', where: str, whereArgs: l);
  return queryResult.map((e) => ORTNModel.fromJson(e)).toList();
}

// Future<void> insertORTNToServer(BuildContext context) async {
//   retrieveORTNById(context, DataSync.getInsertToServerStr(),
//           DataSync.getInsertToServerList())
//       .then((snapshot) {
//     print(snapshot);
//     snapshot.forEach((data) async {
//       var res = await http.post(Uri.parse(prefix + "ORTN/Add"),
//           headers: header, body: jsonEncode(data.toJson()));
//       print(res.body);
//     });
//   });
// }
//
// Future<void> updateORTNOnServer(BuildContext? context) async {
//   retrieveORTNById(context, DataSync.getUpdateOnServerStr(),
//           DataSync.getUpdateOnServerList())
//       .then((snapshot) {
//     print(snapshot);
//     snapshot.forEach((data) async {
//       var res = await http.put(Uri.parse(prefix + 'ORTN/Update'),
//           headers: header, body: jsonEncode(data.toJson()));
//       print(res.body);
//     });
//   });
// }
