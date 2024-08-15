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

List<OEXRModel> OEXRModelFromJson(String str) =>
    List<OEXRModel>.from(json.decode(str).map((x) => OEXRModel.fromJson(x)));

String OEXRModelToJson(List<OEXRModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OEXRModel {
  OEXRModel({
    this.ID,
    this.TransId,
    this.PermanentTransId,
    // this.DocDate,
    this.EmpId,
    this.CreateDate,
    this.UpdateDate,
    this.hasCreated = false,
    this.hasUpdated = false,
    this.EmpName,
    this.EmpGroupId,
    this.EmpDesc,
    this.Remarks,
    this.RequestedAmt,
    this.ApprovedAmt,
    this.ApprovedBy,
    this.ApprovedByDesc,
    // this.ApprovedDate,
    this.FromDate,
    this.ToDate,
    this.Factor,
    this.AdditionalCash,
    this.AdditionalApprovedCash,
    // this.ReconDate,
    // this.ReconAmt,
    // this.ReconStatus,
    // this.ReconBy,
    this.ApprovalStatus,
    this.RPTransId,
    this.CreatedBy,
    this.Currency,
    this.Rate,
    this.DocEntry,
    this.DocNum,
    this.DraftKey,
    this.Error,
    this.UpdatedBy,
    this.BranchId,
    this.LocalDate,
    this.PostingDate,
    this.CRTransId,
    this.CRRequestedAmt,
    this.CRApprovedAmt,
    this.DocStatus,
  });

  int? ID;
  String? DocStatus;
  String? CRTransId;
  String? TransId;
  String? PermanentTransId;
  DateTime? PostingDate;

  // DateTime? DocDate;
  String? EmpId;
  String? EmpName;
  String? EmpGroupId;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  bool hasCreated;
  bool hasUpdated;
  String? EmpDesc;
  String? Remarks;

  double? CRRequestedAmt;
  double? RequestedAmt;
  double? ApprovedAmt;
  double? CRApprovedAmt;
  String? ApprovedBy;
  String? CreatedBy;
  String? ApprovedByDesc;

  // DateTime? ApprovedDate;
  DateTime? FromDate;
  DateTime? ToDate;
  double? Rate;
  double? Factor;
  double? AdditionalCash;
  double? AdditionalApprovedCash;

  // DateTime? ReconDate;
  // double? ReconAmt;
  // String? ReconStatus;
  // String? ReconBy;
  String? ApprovalStatus;
  String? RPTransId;
  String? Currency;

  int? DocEntry;
  String? DocNum;
  String? DraftKey;
  String? Error;
  String? UpdatedBy;
  String? BranchId;
  String? LocalDate;

  factory OEXRModel.fromJson(Map<String, dynamic> json) => OEXRModel(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        CRTransId: json["CRTransId"] ?? '',
        TransId: json["TransId"] ?? '',
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        PostingDate: DateTime.tryParse(json["PostingDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] == 1,
        hasUpdated: json['has_updated'] == 1,
        // DocDate: DateTime.tryParse(json["DocDate"].toString()) ??
        //     DateTime.parse("1900-01-01"),
        EmpId: json["EmpId"].toString(),
        EmpName: json["EmpName"].toString(),
        DocStatus: json["DocStatus"].toString(),
        RPTransId: json["RPTransId"].toString(),
        EmpGroupId: json["EmpGroupId"].toString(),
        CreatedBy: json["CreatedBy"].toString(),
        EmpDesc: json["EmpDesc"].toString(),
        Currency: json["Currency"] ?? json["Currency"].toString(),
        Remarks: json["Remarks"].toString(),
        CRRequestedAmt:
            double.tryParse(json["CRRequestedAmt"].toString()) ?? 0.0,
        CRApprovedAmt: double.tryParse(json["CRApprovedAmt"].toString()) ?? 0.0,
        Rate: double.tryParse(json["Rate"].toString()) ?? 0.0,
        RequestedAmt: double.tryParse(json['RequestedAmt'].toString()) ?? 0.0,
        ApprovedAmt: double.tryParse(json['ApprovedAmt'].toString()) ?? 0.0,
        ApprovedBy: json["ApprovedBy"] ?? "",
        PermanentTransId: json["PermanentTransId"] ?? "",
        ApprovedByDesc: json["ApprovedByDesc"] ?? "",
        // ApprovedDate: DateTime.tryParse(json["ApprovedDate"].toString()) ??
        //     DateTime.parse("1900-01-01"),
        FromDate: DateTime.tryParse(json["FromDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        ToDate: DateTime.tryParse(json["ToDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        Factor: double.tryParse(json["Factor"].toString()) ?? 0.0,
        AdditionalCash:
            double.tryParse(json["AdditionalCash"].toString()) ?? 0.0,
        AdditionalApprovedCash:
            double.tryParse(json["AdditionalApprovedCash"].toString()) ?? 0.0,
        // ReconDate: DateTime.tryParse(json["ReconDate"].toString()) ??
        //     DateTime.parse("1900-01-01"),
        // ReconAmt: double.tryParse(json["ReconAmt"].toString()) ?? 0.0,
        // ReconStatus: json["ReconStatus"].toString(),
        // ReconBy: json["ReconBy"] ?? "",
        ApprovalStatus: json["ApprovalStatus"] == null
            ? "Pending"
            : json["ApprovalStatus"] != 'Pending' &&
                    json["ApprovalStatus"] != 'Rejected' &&
                    json["ApprovalStatus"] != 'Approved'
                ? "Pending"
                : json["ApprovalStatus"],
        DocEntry: int.tryParse(json['DocEntry'].toString()),
        DocNum: json['DocNum'] ?? '',
        DraftKey: json['DraftKey'] ?? '',
        Error: json['Error'] ?? '',
        UpdatedBy: json['UpdatedBy'] ?? '',
        BranchId: json['BranchId'] ?? '',
        LocalDate: json['LocalDate'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "CRRequestedAmt": CRRequestedAmt,
        "CRApprovedAmt": CRApprovedAmt,
        "CRTransId": CRTransId,
        "TransId": TransId,
        "PermanentTransId": PermanentTransId,
        "PostingDate": PostingDate?.toIso8601String(),
        "CreateDate": CreateDate?.toIso8601String(),
        "UpdateDate": UpdateDate?.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "has_updated": hasUpdated ? 1 : 0,
        // "DocDate": DocDate?.toIso8601String(),
        "EmpId": EmpId,
        "DocStatus": DocStatus,
        "EmpName": EmpName,
        "RPTransId": RPTransId,
        "EmpGroupId": EmpGroupId,
        "EmpDesc": EmpDesc,
        "CreatedBy": CreatedBy,
        "Remarks": Remarks,
        'RequestedAmt': RequestedAmt,
        'ApprovedAmt': ApprovedAmt,
        "ApprovedBy": ApprovedBy,
        "ApprovedByDesc": "",
        // "ApprovedDate": ApprovedDate?.year == 1900 ? null : ApprovedDate?.toIso8601String(),
        "FromDate": FromDate?.toIso8601String(),
        "ToDate": ToDate?.toIso8601String(),
        "Factor": Factor,
        "Currency": Currency,
        // "ReconBy": ReconBy,
        "AdditionalCash": AdditionalCash,
        "AdditionalApprovedCash": AdditionalApprovedCash,
        // "ReconDate": ReconDate?.toIso8601String(),
        // "ReconAmt": ReconAmt,
        // "ReconStatus": ReconStatus,
        "ApprovalStatus": ApprovalStatus,
        "Rate": Rate,
        'DocEntry': DocEntry,
        'DocNum': DocNum,
        'DraftKey': DraftKey,
        'Error': Error,
        'UpdatedBy': UpdatedBy,
        'BranchId': BranchId,
        'LocalDate': LocalDate,
      };
}

Future<List<OEXRModel>> dataSyncOEXR() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "OEXR" + postfix));
  print(res.body);
  return OEXRModelFromJson(res.body);
}

Future<List<OEXRModel>> retrieveOEXR(BuildContext context,
    {String? orderBy}) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('OEXR', orderBy: orderBy);
  print("Total rows in OEXR" + queryResult.length.toString());
  return queryResult.map((e) => OEXRModel.fromJson(e)).toList();
}

Future<void> updateOEXR(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update("OEXR", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteOEXR(Database db) async {
  await db.delete('OEXR');
}

// Future<void> insertOEXR(Database db)async{
//   if(postfix.toLowerCase().contains("all"))
//   await deleteOEXR(db);
//   List customers= await dataSyncOEXR();
//   print(customers);
//   var batch = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try
//     {
//       batch.insert('OEXR', customer.toJson());
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
//   //       await db.insert('OEXR', customer.toJson());
//   //     });
//   //   }
//   //   catch(e)
//   //   {
//   //     getErrorSnackBar("Sync Error "+e.toString());
//   //   }
//   //
//   // });
// }
// Future<void> insertOEXR(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteOEXR(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncOEXR();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('OEXR_Temp', customer.toJson());
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
//       "SELECT * FROM  OEXR_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("OEXR", element,
//         where: "TransId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["TransId"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from OEXR_Temp where TransId not in (Select TransId from OEXR)");
//   v.forEach((element) {
//     batch3.insert('OEXR', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('OEXR_Temp');
// }
Future<void> insertOEXR(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteOEXR(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncOEXR();
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
      for (OEXRModel record in batchRecords) {
        try {
          batch.insert('OEXR_Temp', record.toJson());
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
			select * from OEXR_Temp
			except
			select * from OEXR
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
          batch.update("OEXR", element,
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
  print('Time taken for OEXR update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from OEXR_Temp where TransId not in (Select TransId from OEXR)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM OEXR_Temp T0
LEFT JOIN OEXR T1 ON T0.TransId = T1.TransId 
WHERE T1.TransId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('OEXR', record);
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
      'Time taken for OEXR_Temp and OEXR compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('OEXR_Temp');
  // stopwatch.stop();
}

Future<List<OEXRModel>> retrieveOEXRByBranch(BuildContext context) async {
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
      await db.query("OEXR", where: str, whereArgs: list);
  return queryResult.map((e) => OEXRModel.fromJson(e)).toList();
}

//SEND DATA TO SERVER
//--------------------------
Future<List<OEXRModel>> retrieveOEXRById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(null);
  final List<Map<String, Object?>> queryResult =
      await db.query('OEXR', where: str, whereArgs: l);
  return queryResult.map((e) => OEXRModel.fromJson(e)).toList();
}

Future<void> insertOEXRToServer(BuildContext? context,
    {String? TransId}) async {
  String response = "";
  List<OEXRModel> list = await retrieveOEXRById(
      context,
      TransId == null ? DataSync.getInsertToServerStr() : "TransId = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId]);
  if (TransId != null) {
    //only single entry
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "OEXR/Add"),
        headers: header, body: jsonEncode(list[0].toJson()));
    print(res.body);
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
            .post(Uri.parse(prefix + "OEXR/Add?$queryParams"),
                headers: header, body: jsonEncode(map))
            .timeout(Duration(seconds: 30), onTimeout: () {
          writeToLogFile(
              text: '500 error \nMap : $map',
              fileName: StackTrace.current.toString(),
              lineNo: 141);
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
        if (res.statusCode == 409) {
          ///Already added in server
          final Database db = await initializeDB(context);
          OEXRModel model = OEXRModel.fromJson(jsonDecode(res.body));
          map["ID"] = model.ID;
          map["has_created"] = 0;
          var x = await db.update("OEXR", map,
              where: "TransId = ?", whereArgs: [model.TransId]);
          print(x.toString());
        } else if (res.statusCode == 201 || res.statusCode == 500) {
          sentSuccessInServer = true;
          if (res.statusCode == 201) {
            map['ID'] = jsonDecode(res.body)['ID'];
            map['PermanentTransId'] = jsonDecode(res.body)['PermanentTransId'];
            final Database db = await initializeDB(context);
            map["has_created"] = 0;
            var x = await db.update("OEXR", map,
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

Future<void> updateOEXROnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<OEXRModel> list = await retrieveOEXRById(
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
          .put(Uri.parse(prefix + 'OEXR/Update'),
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
          var x = await db.update("OEXR", map,
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
