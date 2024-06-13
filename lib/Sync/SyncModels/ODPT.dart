import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/Component/UploadImageToServer.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:maintenance/Sync/SyncModels/OUSR.dart';
import 'package:sqflite/sqlite_api.dart';

import '../../main.dart';

List<ODPTModel> ODPTModelFromJson(String str) =>
    List<ODPTModel>.from(json.decode(str).map((x) => ODPTModel.fromJson(x)));

String ODPTModelToJson(List<ODPTModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ODPTModel {
  ODPTModel({
    this.ID,
    this.PermanentTransId,
    this.TransId,
    this.EmpId,
    this.CreateDate,
    this.UpdateDate,
    this.hasCreated = false,
    this.hasUpdated = false,
    this.EmpName,
    this.EmpGroupId,
    this.EmpDesc,
    this.DocDate,
    this.Amount,
    this.CreatedBy,
    this.DepositType,
    this.AcctCode,
    this.Remarks,
    this.BranchName,
    this.Attachment,
    this.RefId,
    this.AdAmount,
    this.RPTransId,
    this.DocEntry,
    this.DocNum,
    this.Error,
    this.LocalDate,
    this.UpdatedBy,
    this.BranchId,
    this.Currency,
    this.CurrRate,
    this.ApprovalStatus,
    this.PostingDate,
    this.DocStatus,
    this.Longitude,
    this.Latitude,
  });

  int? ID;
  String? Currency;
  String? ApprovalStatus;
  String? DocStatus;
  String? TransId;
  String? PermanentTransId;
  DateTime? PostingDate;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  bool hasCreated;
  DateTime? DocDate;
  bool hasUpdated;
  String? EmpId;
  String? EmpName;
  String? EmpGroupId;
  String? EmpDesc;
  String? RPTransId;
  double? Amount;
  String? CreatedBy;
  double? CurrRate;
  double? AdAmount;
  String? DepositType;
  String? AcctCode;
  String? BranchName;
  String? Remarks;
  String? Attachment;
  String? RefId;
  int? DocEntry;
  String? DocNum;
  String? Error;
  String? LocalDate;
  String? UpdatedBy;
  String? BranchId;
  String? Longitude;
  String? Latitude;

  factory ODPTModel.fromJson(Map<String, dynamic> json) => ODPTModel(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        ApprovalStatus: json["ApprovalStatus"] ?? "",
        DocStatus: json["DocStatus"] ?? "",
        Currency: json["Currency"] ?? "",
        PermanentTransId: json["PermanentTransId"] ?? "",
        TransId: json["TransId"] ?? "",
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        PostingDate: DateTime.tryParse(json["PostingDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasUpdated: json['has_updated'] == 1,
        hasCreated: json['has_created'] == 1,
        RPTransId: json["RPTransId"] ?? "",
        Longitude: json["Longitude"] ?? "",
        Latitude: json["Latitude"] ?? "",
        EmpId: json["EmpId"] ?? "",
        EmpName: json["EmpName"] ?? "",
        EmpGroupId: json["EmpGroupId"] ?? "",
        EmpDesc: json["EmpDesc"] ?? "",
        CurrRate: double.tryParse(json["CurrRate"].toString()) ?? 0.0,
        Amount: double.tryParse(json["Amount"].toString()) ?? 0.0,
        DocDate: DateTime.tryParse(json["DocDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        CreatedBy: json["CreatedBy"] ?? "",
        DepositType: json["DepositType"] ?? "",
        AcctCode: json["AcctCode"] ?? "",
        Remarks: json["Remarks"] ?? "",
        BranchName: json["BranchName"] ?? "",
        Attachment: json["Attachment"] ?? "",
        RefId: json["RefId"] ?? "",
        AdAmount: double.tryParse(json["AdAmount"].toString()) ?? 0.0,
        DocEntry: int.tryParse(json['DocEntry'].toString()),
        DocNum: json['DocNum'] ?? '',
        Error: json['Error'] ?? '',
        LocalDate: json['LocalDate'] ?? '',
        UpdatedBy: json['UpdatedBy'] ?? '',
        BranchId: json['BranchId'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "DocStatus": DocStatus,
        "ApprovalStatus": ApprovalStatus,
        "PermanentTransId": PermanentTransId,
        "TransId": TransId,
        "PostingDate": PostingDate?.toIso8601String(),
        "CreateDate": CreateDate?.toIso8601String(),
        "UpdateDate": UpdateDate?.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "has_updated": hasUpdated ? 1 : 0,
        "Longitude": Longitude,
        "Latitude": Latitude,
        "CurrRate": CurrRate,
        "Currency": Currency,
        "EmpId": EmpId,
        "EmpName": EmpName,
        "EmpGroupId": EmpGroupId,
        "EmpDesc": EmpDesc,
        "DocDate": DocDate?.toIso8601String(),
        "Amount": Amount,
        "CreatedBy": CreatedBy,
        "DepositType": DepositType,
        "AcctCode": AcctCode,
        "RPTransId": RPTransId,
        "Remarks": Remarks,
        "BranchName": BranchName,
        "Attachment": Attachment,
        "RefId": RefId,
        "AdAmount": AdAmount,
        'DocEntry': DocEntry,
        'DocNum': DocNum,
        'Error': Error,
        'LocalDate': LocalDate,
        'UpdatedBy': UpdatedBy,
        'BranchId': BranchId,
      };
}

Future<List<ODPTModel>> dataSyncODPT() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "ODPT" + postfix));
  print(res.body);
  return ODPTModelFromJson(res.body);
}

Future<List<ODPTModel>> retrieveODPT(BuildContext context,
    {String? orderBy}) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('ODPT', orderBy: orderBy);
  return queryResult.map((e) => ODPTModel.fromJson(e)).toList();
}

Future<void> updateODPT(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update("ODPT", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteODPT(Database db) async {
  await db.delete('ODPT');
}

// Future<void> insertODPT(Database db) async {
//   if(postfix.toLowerCase().contains("all"))
//   await deleteODPT(db);
//   List customers = await dataSyncODPT();
//   print(customers);
//   var batch = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try
//     {
//       batch.insert('ODPT', customer.toJson());
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
//   //       await db.insert('ODPT', customer.toJson());
//   //     });
//   //   }
//   //   catch(e)
//   //   {
//   //     getErrorSnackBar("Sync Error "+e.toString());
//   //   }
//   //
//   // });
// }
// Future<void> insertODPT(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteODPT(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncODPT();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('ODPT_Temp', customer.toJson());
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
//       "SELECT * FROM  ODPT_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN UpdateDate IS NULL THEN CreateDate ELSE UpdateDate END)");
//   u.forEach((element) {
//     batch2.update("ODPT", element,
//         where: "TransId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["TransId"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from ODPT_Temp where TransId not in (Select TransId from ODPT)");
//   v.forEach((element) {
//     batch3.insert('ODPT', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('ODPT_Temp');
// }
Future<void> insertODPT(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteODPT(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncODPT();
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
      for (ODPTModel record in batchRecords) {
        try {
          batch.insert('ODPT_Temp', record.toJson());
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
			select * from ODPT_Temp
			except
			select * from ODPT
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
          batch.update("ODPT", element,
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
  print('Time taken for ODPT update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from ODPT_Temp where TransId not in (Select TransId from ODPT)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM ODPT_Temp T0
LEFT JOIN ODPT T1 ON T0.TransId = T1.TransId 
WHERE T1.TransId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('ODPT', record);
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
      'Time taken for ODPT_Temp and ODPT compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('ODPT_Temp');
  // stopwatch.stop();
}

Future<List<ODPTModel>> retrieveODPTByBranch(BuildContext context,
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
      await db.query("ODPT", where: str, whereArgs: list, orderBy: orderBy);

  return queryResult.map((e) => ODPTModel.fromJson(e)).toList();
}

//SEND DATA TO SERVER
//--------------------------
Future<List<ODPTModel>> retrieveODPTById(
    BuildContext? context, String str, List l,
    {String? orderBy}) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('ODPT', where: str, whereArgs: l, orderBy: orderBy);
  return queryResult.map((e) => ODPTModel.fromJson(e)).toList();
}

Future<void> insertODPTToServer(BuildContext? context,
    {String? TransId}) async {
  String response = "";
  List<ODPTModel> list = await retrieveODPTById(
      context,
      TransId == null ? DataSync.getInsertToServerStr() : "TransId = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId]);
  if (TransId != null) {
    //only single entry
    var res = await http.post(Uri.parse(prefix + "ODPT/Add"),
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
        if (list[i].Attachment?.contains("com.litsales.litsales") ?? false) {
          File imageFile = File(list[i].Attachment ?? '');
          String url =
              await uploadImageToServer(imageFile, null, setURL: (url) {});
          list[i].Attachment = prefix + url;
        }
        map.remove('ID');
        String queryParams = 'TransId=${list[i].TransId}';
        var res = await http
            .post(Uri.parse(prefix + "ODPT/Add?$queryParams"),
                headers: header, body: jsonEncode(jsonDecode(jsonEncode(map))))
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
          ODPTModel model = ODPTModel.fromJson(jsonDecode(res.body));
          var x = await db.update("ODPT", model.toJson(),
              where: "TransId = ?", whereArgs: [model.TransId]);
          print(x.toString());
        } else if (res.statusCode == 201 || res.statusCode == 500) {
          sentSuccessInServer = true;
          if (res.statusCode == 201) {
            map['ID'] = jsonDecode(res.body)['ID'];
            map['PermanentTransId'] = jsonDecode(res.body)['PermanentTransId'];
            final Database db = await initializeDB(context);
            map["has_created"] = 0;
            var x = await db.update("ODPT", map,
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

Future<void> updateODPTOnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<ODPTModel> list = await retrieveODPTById(
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
          .put(Uri.parse(prefix + 'ODPT/Update'),
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
          var x = await db.update("ODPT", map,
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
