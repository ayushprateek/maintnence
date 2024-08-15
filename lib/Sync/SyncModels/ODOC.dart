import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:sqflite/sqlite_api.dart';

class ODOC {
  int? ID;
  String? TransId;
  String? CardCode;
  String? CardName;
  String? RefNo;
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
  int? DocEntry;
  String? DocNum;
  String? CreatedBy;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  String? ApprovedBy;
  String? Latitude;
  String? Longitude;
  String? UpdatedBy;
  String? BranchId;
  String? Remarks;
  String? LocalDate;
  String? WhsCode;
  String? ObjectCode;

  ODOC({
    this.ID,
    this.TransId,
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
    this.BaseTab,
    this.TotBDisc,
    this.DiscPer,
    this.DiscVal,
    this.TaxVal,
    this.DocTotal,
    this.DocEntry,
    this.DocNum,
    this.CreatedBy,
    this.CreateDate,
    this.UpdateDate,
    this.ApprovedBy,
    this.Latitude,
    this.Longitude,
    this.UpdatedBy,
    this.BranchId,
    this.Remarks,
    this.LocalDate,
    this.WhsCode,
    this.ObjectCode,
  });

  factory ODOC.fromJson(Map<String, dynamic> json) => ODOC(
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        TransId: json['TransId'] ?? '',
        CardCode: json['CardCode'] ?? '',
        CardName: json['CardName'] ?? '',
        RefNo: json['RefNo'] ?? '',
        ContactPersonId: int.tryParse(json['ContactPersonId'].toString()) ?? 0,
        ContactPersonName: json['ContactPersonName'] ?? '',
        MobileNo: json['MobileNo'] ?? '',
        PostingDate: DateTime.tryParse(json['PostingDate'].toString()) ??
            DateTime.parse('1900-01-01'),
        ValidUntill: DateTime.tryParse(json['ValidUntill'].toString()) ??
            DateTime.parse('1900-01-01'),
        Currency: json['Currency'] ?? '',
        CurrRate: double.tryParse(json['CurrRate'].toString()) ?? 0.0,
        PaymentTermCode: json['PaymentTermCode'] ?? '',
        PaymentTermName: json['PaymentTermName'] ?? '',
        PaymentTermDays: int.tryParse(json['PaymentTermDays'].toString()) ?? 0,
        ApprovalStatus: json['ApprovalStatus'] ?? '',
        DocStatus: json['DocStatus'] ?? '',
        RPTransId: json['RPTransId'] ?? '',
        DSTranId: json['DSTranId'] ?? '',
        CRTransId: json['CRTransId'] ?? '',
        BaseTab: json['BaseTab'] ?? '',
        TotBDisc: double.tryParse(json['TotBDisc'].toString()) ?? 0.0,
        DiscPer: double.tryParse(json['DiscPer'].toString()) ?? 0.0,
        DiscVal: double.tryParse(json['DiscVal'].toString()) ?? 0.0,
        TaxVal: double.tryParse(json['TaxVal'].toString()) ?? 0.0,
        DocTotal: double.tryParse(json['DocTotal'].toString()) ?? 0.0,
        DocEntry: int.tryParse(json['DocEntry'].toString()) ?? 0,
        DocNum: json['DocNum'] ?? '',
        CreatedBy: json['CreatedBy'] ?? '',
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()) ??
            DateTime.parse('1900-01-01'),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()) ??
            DateTime.parse('1900-01-01'),
        ApprovedBy: json['ApprovedBy'] ?? '',
        Latitude: json['Latitude'] ?? '',
        Longitude: json['Longitude'] ?? '',
        UpdatedBy: json['UpdatedBy'] ?? '',
        BranchId: json['BranchId'] ?? '',
        Remarks: json['Remarks'] ?? '',
        LocalDate: json['LocalDate'] ?? '',
        WhsCode: json['WhsCode'] ?? '',
        ObjectCode: json['ObjectCode'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'ID': ID,
        'TransId': TransId,
        'CardCode': CardCode,
        'CardName': CardName,
        'RefNo': RefNo,
        'ContactPersonId': ContactPersonId,
        'ContactPersonName': ContactPersonName,
        'MobileNo': MobileNo,
        'PostingDate': PostingDate?.toIso8601String(),
        'ValidUntill': ValidUntill?.toIso8601String(),
        'Currency': Currency,
        'CurrRate': CurrRate,
        'PaymentTermCode': PaymentTermCode,
        'PaymentTermName': PaymentTermName,
        'PaymentTermDays': PaymentTermDays,
        'ApprovalStatus': ApprovalStatus,
        'DocStatus': DocStatus,
        'RPTransId': RPTransId,
        'DSTranId': DSTranId,
        'CRTransId': CRTransId,
        'BaseTab': BaseTab,
        'TotBDisc': TotBDisc,
        'DiscPer': DiscPer,
        'DiscVal': DiscVal,
        'TaxVal': TaxVal,
        'DocTotal': DocTotal,
        'DocEntry': DocEntry,
        'DocNum': DocNum,
        'CreatedBy': CreatedBy,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'ApprovedBy': ApprovedBy,
        'Latitude': Latitude,
        'Longitude': Longitude,
        'UpdatedBy': UpdatedBy,
        'BranchId': BranchId,
        'Remarks': Remarks,
        'LocalDate': LocalDate,
        'WhsCode': WhsCode,
        'ObjectCode': ObjectCode,
      };
}

List<ODOC> oDOCFromJson(String str) =>
    List<ODOC>.from(json.decode(str).map((x) => ODOC.fromJson(x)));

String oDOCToJson(List<ODOC> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<ODOC>> dataSyncODOC() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "ODOC" + postfix));
  print(res.body);
  return oDOCFromJson(res.body);
}

// Future<void> insertODOC(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteODOC(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncODOC();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('ODOC_Temp', customer.toJson());
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
//       "SELECT * FROM  ODOC_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("ODOC", element,
//         where: "RowId = ? AND TransId = ?",
//         whereArgs: [element["RowId"], element["TransId"]]);
//   });
//   await batch2.commit(noResult: true);
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from ODOC_Temp where TransId || RowId not in (Select TransId || RowId from ODOC)");
//   v.forEach((element) {
//     batch3.insert('ODOC', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('ODOC_Temp');
// }
Future<void> insertODOC(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteODOC(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncODOC();
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
      for (ODOC record in batchRecords) {
        try {
          batch.insert('ODOC_Temp', record.toJson());
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
			select * from ODOC_Temp
			except
			select * from ODOC
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
          batch.update("ODOC", element,
              where: "RowId = ? AND TransId = ?",
              whereArgs: [element["RowId"], element["TransId"]]);
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
  print('Time taken for ODOC update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from ODOC_Temp where TransId || RowId not in (Select TransId || RowId from ODOC)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM ODOC_Temp T0
LEFT JOIN ODOC T1 ON T0.TransId = T1.TransId AND T0.RowId = T1.RowId 
WHERE T1.TransId IS NULL AND T1.RowId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('ODOC', record);
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
      'Time taken for ODOC_Temp and ODOC compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('ODOC_Temp');
  // stopwatch.stop();
}

Future<List<ODOC>> retrieveODOC(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('ODOC');
  return queryResult.map((e) => ODOC.fromJson(e)).toList();
}

Future<void> updateODOC(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('ODOC', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deleteODOC(Database db) async {
  await db.delete('ODOC');
}

Future<List<ODOC>> retrieveODOCById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('ODOC', where: str, whereArgs: l);
  return queryResult.map((e) => ODOC.fromJson(e)).toList();
}

// Future<void> insertODOCToServer(BuildContext? context,
//     {String? TransId, int? id}) async {
//   String response = "";
//   List<ODOC> list = await retrieveODOCById(
//       context,
//       TransId == null
//           ? DataSync.getInsertToServerStr()
//           : "TransId = ? AND ID = ?",
//       TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
//   if (TransId != null) {
//     list[0].ID = 0;
//     var res = await http.post(Uri.parse(prefix + "ODOC/Add"),
//         headers: header, body: jsonEncode(list[0].toJson()));
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
//         var res = await http
//             .post(Uri.parse(prefix + "ODOC/Add"),
//                 headers: header, body: jsonEncode(map))
//             .timeout(Duration(seconds: 30), onTimeout: () {
//           writeToLogFile(
//               text: '500 error \nMap : $map',
//               fileName: StackTrace.current.toString(),
//               lineNo: 141);
//           return http.Response('Error', 500);
//         });
//         response = await res.body;
//         print("eeaaae status");
//         print(await res.statusCode);
//         if (res.statusCode != 201) {
//           await writeToLogFile(
//               text:
//                   '${res.statusCode} error \nMap : $map\nResponse : ${res.body}',
//               fileName: StackTrace.current.toString(),
//               lineNo: 141);
//         }
//         if (res.statusCode == 201 || res.statusCode == 500) {
//           sentSuccessInServer = true;
//           if (res.statusCode == 201) {
//             map['ID'] = jsonDecode(res.body)['ID'];
//             final Database db = await initializeDB(context);
//             // map = jsonDecode(res.body);
//             map["has_created"] = 0;
//             var x = await db.update("ODOC", map,
//                 where: "TransId = ? AND RowId = ?",
//                 whereArgs: [map["TransId"], map["RowId"]]);
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
// Future<void> updateODOCOnServer(BuildContext? context,
//     {String? condition, List? l}) async {
//   List<ODOC> list = await retrieveODOCById(
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
//           .put(Uri.parse(prefix + 'ODOC/Update'),
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
//           var x = await db.update("ODOC", map,
//               where: "TransId = ? AND RowId = ?",
//               whereArgs: [map["TransId"], map["RowId"]]);
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
