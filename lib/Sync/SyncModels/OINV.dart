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
import 'package:maintenance/main.dart';
import 'package:sqflite/sqlite_api.dart';

List<OINVModel> OINVModelFromJson(String str) =>
    List<OINVModel>.from(json.decode(str).map((x) => OINVModel.fromJson(x)));

String OINVModelToJson(List<OINVModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OINVModel {
  OINVModel({
    this.ID,
    this.TransId,
    this.PermanentTransId,
    this.CreateDate,
    this.UpdateDate,
    this.hasCreated = false,
    this.hasUpdated = false,
    this.CardCode,
    this.CardName,
    this.Latitude,
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
    this.CreatedBy,
    this.Longitude,
    this.ApprovedBy,
    this.DraftKey,
    this.IsPosted,
    this.Error,
    this.LocalDate,
    this.Remarks,
    this.OpenAmt,
    this.UpdatedBy,
    this.BranchId,
    this.WhsCode,
    this.DocEntry,
    this.DocNum,
    this.ObjectCode,
    this.IsCashReceipt,
    this.DeliveryDate,
    this.Payment = 0.0
  });

  int? ID;
  int? DocEntry;
  String? TransId;
  String? DocNum;
  String? PermanentTransId;
  String? CardCode;
  String? CardName;
  String? RefNo;
  int? ContactPersonId;
  String? ContactPersonName;
  String? MobileNo;
  DateTime? PostingDate;
  DateTime? ValidUntill;
  String? Latitude;
  String? Currency;
  double? CurrRate;
  double Payment;

  ///to be used only for development purpose
  String? PaymentTermCode;
  String? PaymentTermName;
  int? PaymentTermDays;
  String? ApprovalStatus;
  String? DocStatus;
  String? RPTransId;
  String? DSTranId;
  String? CRTransId;
  String? BaseTab;
  DateTime? DeliveryDate;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  bool hasCreated;
  bool hasUpdated;
  double? TotBDisc;
  double? DiscPer;
  double? DiscVal;
  double? TaxVal;
  double? DocTotal;
  String? ApprovedBy;

  String? CreatedBy;
  String? Longitude;
  String? DraftKey;
  bool? IsPosted;
  String? Error;
  String? LocalDate;
  String? Remarks;
  double? OpenAmt;
  String? UpdatedBy;
  String? BranchId;
  String? WhsCode;
  String? ObjectCode;
  bool? IsCashReceipt;

  factory OINVModel.fromJson(Map<String, dynamic> json) =>
      OINVModel(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        DocEntry: int.tryParse(json["DocEntry"].toString()) ?? 0,
        DocNum: json["DocNum"] ?? "",
        ApprovedBy: json["ApprovedBy"] ?? "",
        TransId: json["TransId"] ?? "",
        PermanentTransId: json["PermanentTransId"] ?? "",
        CardCode: json["CardCode"] ?? "",
        CardName: json["CardName"] ?? "",
        Latitude: json["Latitude"] ?? "",
        RefNo: json["RefNo"] ?? "",
        ContactPersonId: int.tryParse(json["ContactPersonId"].toString()) ?? 0,
        ContactPersonName: json["ContactPersonName"] ?? "",
        MobileNo: json["MobileNo"] ?? "",
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] == 1,
        hasUpdated: json['has_updated'] == 1,
        PostingDate: DateTime.tryParse(json["PostingDate"].toString()) ?? DateTime.parse("1900-01-01"),
        DeliveryDate: DateTime.tryParse(json["DeliveryDate"].toString())?? DateTime.parse("1900-01-01"),
        ValidUntill: DateTime.tryParse(json["ValidUntill"].toString()) ??
            DateTime.parse("1900-01-01"),
        Currency: json["Currency"] ?? "",
        CurrRate: double.tryParse(json["CurrRate"].toString()) ?? 0.0,
        PaymentTermCode: json["PaymentTermCode"] ?? "",
        PaymentTermName: json["PaymentTermName"] ?? "",
        PaymentTermDays: int.tryParse(json["PaymentTermDays"].toString()) ?? 0,
        ApprovalStatus: json["ApprovalStatus"] ?? "",
        Longitude: json["Longitude"] ?? "",
        DocStatus: json["DocStatus"] ?? "",
        CreatedBy: json["CreatedBy"] ?? "",
        RPTransId: json["RPTransId"] ?? "",
        DSTranId: json["DSTranId"] ?? "",
        CRTransId: json["CRTransId"] ?? "",
        BaseTab: json["BaseTab"] ?? "",
        TotBDisc: double.tryParse(json["TotBDisc"].toString()) ?? 0.0,
        DiscPer: double.tryParse(json["DiscPer"].toString()) ?? 0.0,
        DiscVal: double.tryParse(json["DiscVal"].toString()) ?? 0.0,
        TaxVal: double.tryParse(json["TaxVal"].toString()) ?? 0.0,
        DocTotal: double.tryParse(json["DocTotal"].toString()) ?? 0.0,
        DraftKey: json['DraftKey'] ?? '',
        IsPosted:
        json['IsPosted'] is bool ? json['IsPosted'] : json['IsPosted'] == 1,
        Error: json['Error'] ?? '',
        LocalDate: json['LocalDate'] ?? '',
        Remarks: json['Remarks'] ?? '',
        OpenAmt: double.tryParse(json['OpenAmt'].toString()) ?? 0.0,
        UpdatedBy: json['UpdatedBy'] ?? '',
        BranchId: json['BranchId'] ?? '',
        WhsCode: json['WhsCode'] ?? '',
        ObjectCode: json['ObjectCode'] ?? '',
        IsCashReceipt: json['IsCashReceipt'] is bool
            ? json['IsCashReceipt']
            : json['IsCashReceipt'] == 1,
      );

  Map<String, dynamic> toJson() =>
      {
        "ID": ID,
        "ApprovedBy": ApprovedBy,
        "TransId": TransId,
        "CardCode": CardCode,
        "CardName": CardName,
        "DocEntry": DocEntry,
        "DocNum": DocNum,
        "RefNo": RefNo,
        "Longitude": Longitude,
        "ContactPersonId": ContactPersonId,
        "ContactPersonName": ContactPersonName,
        "Latitude": Latitude,
        "MobileNo": MobileNo,
        "CreateDate": CreateDate?.toIso8601String(),
        "UpdateDate": UpdateDate?.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "has_updated": hasUpdated ? 1 : 0,
        "DeliveryDate": DeliveryDate?.toIso8601String(),
        "PostingDate": PostingDate?.toIso8601String(),
        "ValidUntill": ValidUntill?.toIso8601String(),
        "Currency": Currency,
        "CurrRate": CurrRate,
        "CreatedBy": CreatedBy,
        "PaymentTermCode": PaymentTermCode,
        "PaymentTermName": PaymentTermName,
        "PaymentTermDays": PaymentTermDays,
        "ApprovalStatus": ApprovalStatus,
        "DocStatus": DocStatus,
        "PermanentTransId": PermanentTransId,
        "RPTransId": RPTransId,
        "DSTranId": DSTranId,
        "CRTransId": CRTransId,
        "BaseTab": BaseTab,
        "TotBDisc": TotBDisc,
        "DiscPer": DiscPer,
        "DiscVal": DiscVal,
        "TaxVal": TaxVal,
        "DocTotal": double.tryParse(DocTotal?.toStringAsFixed(2)??'0')??0.0,
        'DraftKey': DraftKey,
        'IsPosted': IsPosted,
        'Error': Error,
        'LocalDate': LocalDate,
        'Remarks': Remarks,
        'OpenAmt': OpenAmt,
        'UpdatedBy': UpdatedBy,
        'BranchId': BranchId,
        'WhsCode': WhsCode,
        'ObjectCode': ObjectCode,
        'IsCashReceipt': IsCashReceipt,
      };
}

Future<List<OINVModel>> dataSyncOINV() async {
  var res =
  await http.get(headers: header, Uri.parse(prefix + "OINV" + postfix));
  print(res.body);
  return OINVModelFromJson(res.body);
}

Future<List<OINVModel>> retrieveOINV(BuildContext? context,
    {String? orderBy,int? limit}) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
  await db.query('OINV', orderBy: orderBy,limit: limit);
  return queryResult.map((e) => OINVModel.fromJson(e)).toList();
}

Future<void> updateOINV(int id, Map<String, dynamic> values,
    BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update("OINV", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteOINV(Database db) async {
  await db.delete('OINV');
}

// Future<void> insertOINV(Database db)async{
//   if(postfix.toLowerCase().contains("all"))
//   await deleteOINV(db);
//   List customers= await dataSyncOINV();
//   print(customers);
//   var batch = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try
//     {
//       batch.insert('OINV', customer.toJson());
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
//   //       await db.insert('OINV', customer.toJson());
//   //     });
//   //   }
//   //   catch(e)
//   //   {
//   //     getErrorSnackBar("Sync Error "+e.toString());
//   //   }
//   //
//   // });
// }
// Future<void> insertOINV(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteOINV(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncOINV();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('OINV_Temp', customer.toJson());
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
//       "SELECT * FROM  OINV_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("OINV", element,
//         where: "TransId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["TransId"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from OINV_Temp where TransId not in (Select TransId from OINV)");
//   v.forEach((element) {
//     batch3.insert('OINV', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('OINV_Temp');
// }
Future<void> insertOINV(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteOINV(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncOINV();
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
      for (OINVModel record in batchRecords) {
        try {
          batch.insert('OINV_Temp', record.toJson());
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
			select * from OINV_Temp
			except
			select * from OINV
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
          batch.update("OINV", element,
              where: "TransId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
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
  print('Time taken for OINV update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from OINV_Temp where TransId not in (Select TransId from OINV)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM OINV_Temp T0
LEFT JOIN OINV T1 ON T0.TransId = T1.TransId 
WHERE T1.TransId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('OINV', record);
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
      'Time taken for OINV_Temp and OINV compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('OINV_Temp');
  // stopwatch.stop();
}

Future<List<OINVModel>> retrieveOINVByBranch(BuildContext context,
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
  await db.query("OINV", where: str, whereArgs: list, orderBy: orderBy);
  return queryResult.map((e) => OINVModel.fromJson(e)).toList();
}

//SEND DATA TO SERVER
//--------------------------
Future<List<OINVModel>> retrieveOINVById(BuildContext? context, String str,
    List l,
    {String? orderBy,int? limit}) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
  await db.query('OINV', where: str, whereArgs: l, orderBy: orderBy,limit: limit);
  return queryResult.map((e) => OINVModel.fromJson(e)).toList();
}

Future<List<OINVModel>> retrieveCashReceiptData(
    {required String CardCode}) async {
  final Database db = await initializeDB(null);
  final List<Map<String, Object?>> queryResult = await db.rawQuery(
      "Select * from oinv where CardCode='$CardCode' and OpenAmt > 0 ORDER BY CreateDate DESC");
  return queryResult.map((e) => OINVModel.fromJson(e)).toList();
}

Future<void> insertOINVToServer(BuildContext? context,
    {String? TransId}) async {
  List<OINVModel> list = await retrieveOINVById(
      context,
      TransId == null ? DataSync.getInsertToServerStr() : "TransId = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "OINV/Add"),
        headers: header, body: jsonEncode(list[0].toJson()));
    print(res.body);
  } else if (list.isNotEmpty) {
    int i = 0;
    bool sentSuccessInServer = false;
    if (list.isEmpty) {
      return;
    }
    do {Map<String, dynamic> map = list[i].toJson();
      sentSuccessInServer = false;
      try {
        map.remove('ID');
        String queryParams='TransId=${map['TransId']}';
        var res = await http.post(Uri.parse(prefix + "OINV/Add?$queryParams"),
            headers: header,
            body: jsonEncode(map))
        //     .timeout(Duration(seconds: 30), onTimeout: () {
        //   return http.Response("Error", 500);
        // })
            ;
        if(res.statusCode != 201)
        {
          await writeToLogFile(
              text: '${res.statusCode} error \nMap : $map\nResponse : ${res.body}',
              fileName: StackTrace.current.toString(),
              lineNo: 141);
        }
        if(res.statusCode ==409)
        {
          ///Already added in server
          final Database db = await initializeDB(context);
          OINVModel oinvModel=OINVModel.fromJson(jsonDecode(res.body));
          var x = await db.update("OINV", oinvModel.toJson(),
              where: "TransId = ?", whereArgs: [oinvModel.TransId]);
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
            var x = await db.update("OINV", map,
                where: "TransId = ?", whereArgs: [map["TransId"]]);
            print(x.toString());
          }
        }
        print(res.body);
      } catch (e) {
        writeToLogFile(
            text: '${e.toString()}\nMap : $map', fileName: StackTrace.current.toString(), lineNo: 141);
  sentSuccessInServer = true;
  }
  i++;
  print("INDEX = " + i.toString());
  } while (i < list.length && sentSuccessInServer == true);
}

}

Future<void> updateOINVOnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<OINVModel> list = await retrieveOINVById(
      context,
      l == null ? DataSync.getUpdateOnServerStr() : condition ?? "",
      l == null ? DataSync.getUpdateOnServerList() : l);
  print(list);
  int i = 0;
  bool sentSuccessInServer = false;
  if (list.isEmpty) {
    return;
  }
  do {Map<String, dynamic> map = list[i].toJson();
    sentSuccessInServer = false;
    try {
      if (list.isEmpty) {
        return;
      }
      Map<String, dynamic> map = list[i].toJson();
      var res = await http
          .put(Uri.parse(prefix + 'OINV/Update'),
          headers: header, body: jsonEncode(map))
          .timeout(Duration(seconds: 30), onTimeout: () {
        writeToLogFile(
            text: '500 error \nMap : $map', fileName: StackTrace.current.toString(), lineNo: 141);return http.Response('Error', 500);
      });
      print(await res.statusCode);
      if(res.statusCode != 201)
        {
          await writeToLogFile(
              text: '${res.statusCode} error \nMap : $map\nResponse : ${res.body}',
              fileName: StackTrace.current.toString(),
              lineNo: 141);
        }

        if (res.statusCode == 201 || res.statusCode == 500) {
        sentSuccessInServer = true;
        if (res.statusCode == 201) {
          final Database db = await initializeDB(context);
          map["has_updated"] = 0;
          var x = await db.update("OINV", map,
              where: "TransId = ?", whereArgs: [map["TransId"]]);
          print(x.toString());
        }
      }
      print(res.body);
    } catch (e) {
      writeToLogFile(
          text: '${e.toString()}\nMap : $map', fileName: StackTrace.current.toString(), lineNo: 141);
  sentSuccessInServer = true;
  }

  i++;
  print("INDEX = " + i.toString());
  } while (i < list.length && sentSuccessInServer == true);
}
