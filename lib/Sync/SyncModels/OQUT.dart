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

List<OQUTModel> OQUTModelFromJson(String str) =>
    List<OQUTModel>.from(json.decode(str).map((x) => OQUTModel.fromJson(x)));

String OQUTModelToJson(List<OQUTModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OQUTModel {
  OQUTModel({
    this.ID,
    this.TransId,
    this.DocEntry,
    this.PermanentTransId,
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
    this.ApprovedBy,
    this.ApprovalStatus,
    this.DocStatus,
    this.BaseTransId,
    this.TotBDisc,
    this.DiscPer,
    this.DiscVal,
    this.TaxVal,
    this.DocTotal,
    this.UpdateDate,
    this.hasCreated = false,
    this.hasUpdated = false,
    this.CreateDate,
    this.CreatedBy,
    this.Longitude,
    this.Latitude,
    this.ObjectCode,
    this.WhsCode,
    this.Remarks,
    this.LocalDate,
    this.BranchId,
    this.UpdatedBy,
    this.DocNum,
  });

  int? ID;
  String? TransId;
  int? DocEntry;
  String? PermanentTransId;
  String? CardCode;
  String? CardName;
  String? RefNo;
  int? ContactPersonId;
  String? ContactPersonName;
  String? MobileNo;
  DateTime? UpdateDate;
  bool hasCreated;
  bool hasUpdated;
  DateTime? CreateDate;
  DateTime? PostingDate;
  DateTime? ValidUntill;
  String? DocNum;
  String? Currency;
  String? PaymentTermCode;
  String? PaymentTermName;
  int? PaymentTermDays;
  String? ApprovalStatus;
  String? ApprovedBy;
  String? DocStatus;
  String? BaseTransId;
  double? CurrRate;
  double? TotBDisc;
  double? DiscPer;
  double? DiscVal;
  double? TaxVal;
  double? DocTotal;
  String? CreatedBy;
  String? Longitude;
  String? Latitude;
  String? ObjectCode;
  String? WhsCode;
  String? Remarks;
  String? LocalDate;
  String? BranchId;
  String? UpdatedBy;

  factory OQUTModel.fromJson(Map<String, dynamic> json) =>
      OQUTModel(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        DocEntry: int.tryParse(json["DocEntry"].toString()) ?? 0,
        TransId: json["TransId"] ?? "",
        PermanentTransId: json["PermanentTransId"] ?? "",
        CardCode: json["CardCode"] ?? "",
        CardName: json["CardName"] ?? "",
        RefNo: json["RefNo"] ?? "",
        ContactPersonId: int.tryParse(json["ContactPersonId"].toString()) ?? 0,
        Latitude: json["Latitude"] ?? "",
        ContactPersonName: json["ContactPersonName"] ?? "",
        MobileNo: json["MobileNo"] ?? "",
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] == 1,
        hasUpdated: json['has_updated'] == 1,
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        PostingDate: DateTime.tryParse(json["PostingDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        ValidUntill: DateTime.tryParse(json["ValidUntill"].toString()) ??
            DateTime.parse("1900-01-01"),
        DocNum: json["DocNum"] ?? "",
        Currency: json["Currency"] ?? "",
        CurrRate: double.tryParse(json["CurrRate"].toString()) ?? 0.0,
        PaymentTermCode: json["PaymentTermCode"] ?? "",
        PaymentTermName: json["PaymentTermName"] ?? "",
        PaymentTermDays: int.tryParse(json["PaymentTermDays"].toString()) ?? 0,
        ApprovedBy: json["ApprovedBy"] ?? "",
        ApprovalStatus: json["ApprovalStatus"] ?? "",
        DocStatus: json["DocStatus"] ?? "",
        BaseTransId: json["BaseTransId"] ?? "",
        TotBDisc: double.tryParse(json["TotBDisc"].toString()) ?? 0.0,
        DiscPer: double.tryParse(json["DiscPer"].toString()) ?? 0.0,
        DiscVal: double.tryParse(json["DiscVal"].toString()) ?? 0.0,
        TaxVal: double.tryParse(json["TaxVal"].toString()) ?? 0.0,
        DocTotal: double.tryParse(json["DocTotal"].toString()) ?? 0.0,
        Longitude: json["Longitude"] ?? "",
        CreatedBy: json["CreatedBy"] ?? "",
        ObjectCode: json['ObjectCode'] ?? '',
        WhsCode: json['WhsCode'] ?? '',
        Remarks: json['Remarks'] ?? '',
        LocalDate: json['LocalDate'] ?? '',
        BranchId: json['BranchId'] ?? '',
        UpdatedBy: json['UpdatedBy'] ?? '',
      );

  Map<String, dynamic> toJson() =>
      {
        "ID": ID,
        "TransId": TransId,
        "PermanentTransId": PermanentTransId,
        "CardCode": CardCode,
        "CardName": CardName,
        "RefNo": RefNo,
        "ContactPersonId": ContactPersonId,
        "ContactPersonName": ContactPersonName,
        "MobileNo": MobileNo,
        "UpdateDate": UpdateDate?.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "has_updated": hasUpdated ? 1 : 0,
        "PostingDate": PostingDate?.toIso8601String(),
        "CreateDate": CreateDate?.toIso8601String(),
        "ValidUntill": ValidUntill?.toIso8601String(),
        "Currency": Currency,
        "CurrRate": CurrRate,
        "PaymentTermCode": PaymentTermCode,
        "PaymentTermName": PaymentTermName,
        "PaymentTermDays": PaymentTermDays,
        "Latitude": Latitude,
        "ApprovedBy": ApprovedBy,
        "ApprovalStatus": ApprovalStatus,
        "DocStatus": DocStatus,
        "BaseTransId": BaseTransId,
        "Longitude": Longitude,
        "TotBDisc": TotBDisc,
        "DiscPer": DiscPer,
        "DiscVal": DiscVal,
        "TaxVal": TaxVal,
        "DocTotal": double.tryParse(DocTotal?.toStringAsFixed(2)??'0'),
        "DocEntry": DocEntry,
        "DocNum": DocNum,
        "CreatedBy": CreatedBy,
        'ObjectCode': ObjectCode,
        'WhsCode': WhsCode,
        'Remarks': Remarks,
        'LocalDate': LocalDate,
        'BranchId': BranchId,
        'UpdatedBy': UpdatedBy,
      };
}

Future<List<OQUTModel>> dataSyncOQUT() async {
  var res =
  await http.get(headers: header, Uri.parse(prefix + "OQUT" + postfix));
  print(res.body);
  return OQUTModelFromJson(res.body);
}

Future<List<OQUTModel>> retrieveOQUT(BuildContext context,
    {String? orderBy}) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
  await db.query('OQUT', orderBy: orderBy);
  return queryResult.map((e) => OQUTModel.fromJson(e)).toList();
}

Future<void> updateOQUT(int id, Map<String, dynamic> values,
    BuildContext context) async {
  final db = await initializeDB(context);
  try {
    await db.transaction((db) async {
      await db.update("OQUT", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteOQUT(Database db) async {
  await db.delete('OQUT');
}

// Future<void> insertOQUT(Database db)async{
//   if(postfix.toLowerCase().contains("all"))
//   await deleteOQUT(db);
//   List customers= await dataSyncOQUT();
//   print(customers);
//   var batch = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try
//     {
//       batch.insert('OQUT', customer.toJson());
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
//   //       await db.insert('OQUT', customer.toJson());
//   //     });
//   //   }
//   //   catch(e)
//   //   {
//   //     getErrorSnackBar("Sync Error "+e.toString());
//   //   }
//   //
//   // });
// }
// Future<void> insertOQUT(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteOQUT(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncOQUT();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('OQUT_Temp', customer.toJson());
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
//       "SELECT * FROM  OQUT_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("OQUT", element,
//         where: "TransId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["TransId"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//
//   var v = await db.rawQuery(
//       "Select * from OQUT_Temp where TransId not in (Select TransId from OQUT)");
//   v.forEach((element) {
//     batch3.insert('OQUT', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('OQUT_Temp');
// }
Future<void> insertOQUT(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteOQUT(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncOQUT();
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
      for (OQUTModel record in batchRecords) {
        try {
          batch.insert('OQUT_Temp', record.toJson());
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
			select * from OQUT_Temp
			except
			select * from OQUT
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
          batch.update("OQUT", element,
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
  print('Time taken for OQUT update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from OQUT_Temp where TransId not in (Select TransId from OQUT)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM OQUT_Temp T0
LEFT JOIN OQUT T1 ON T0.TransId = T1.TransId 
WHERE T1.TransId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('OQUT', record);
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
      'Time taken for OQUT_Temp and OQUT compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('OQUT_Temp');
  // stopwatch.stop();
}

Future<List<OQUTModel>> retrieveOQUTByBranch(BuildContext context,
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
  await db.query("OQUT", where: str, whereArgs: list, orderBy: orderBy);

  return queryResult.map((e) => OQUTModel.fromJson(e)).toList();
}

//SEND DATA TO SERVER
//--------------------------
Future<List<OQUTModel>> retrieveOQUTById(BuildContext? context, String str,
    List l,
    {String? orderBy}) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
  await db.query('OQUT', where: str, whereArgs: l, orderBy: orderBy);
  return queryResult.map((e) => OQUTModel.fromJson(e)).toList();
}

Future<void> insertOQUTToServer(BuildContext? context,
    {String? TransId}) async {
  String response = "";
  List<OQUTModel> list = await retrieveOQUTById(
      context,
      TransId == null ? DataSync.getInsertToServerStr() : "TransId = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId]);
  if (TransId != null) {
    //only single entry
    var res = await http.post(Uri.parse(prefix + "OQUT/Add"),
        headers: header, body: jsonEncode(list[0].toJson()));
    response = res.body;
  } else if (list.isNotEmpty) {
    int i = 0;
    bool sentSuccessInServer = false;
    if (list.isEmpty) {
      return;
    }
    do {Map<String, dynamic> map = list[i].toJson();
      sentSuccessInServer = false;
      try {
        print(map);
        map.remove('ID');
        String queryParams='TransId=${list[i].TransId}';
        var res = await http.post(Uri.parse(prefix + "OQUT/Add?$queryParams"),
            headers: header, body: jsonEncode(map))
            .timeout(Duration(seconds: 30), onTimeout: () {
          return http.Response("Error", 500);
        });
        response = await res.body;
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
          OQUTModel model=OQUTModel.fromJson(jsonDecode(res.body));
          var x = await db.update("OQUT", model.toJson(),
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
            var x = await db.update("OQUT", map,
                where: "TransId = ?", whereArgs: [map["TransId"]]);
            print(x.toString());
          }else{
            writeToLogFile(
                text: '500 error \nMap : $map',
                fileName: StackTrace.current.toString(),
                lineNo: 141);
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

Future<void> updateOQUTOnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<OQUTModel> list = await retrieveOQUTById(
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
          .put(Uri.parse(prefix + 'OQUT/Update'),
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
          var x = await db.update("OQUT", map,
              where: "TransId = ?", whereArgs: [map["TransId"]]);
          print(x.toString());
        }else{
          writeToLogFile(
              text: '500 error \nMap : $map',
              fileName: StackTrace.current.toString(),
              lineNo: 141);
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
