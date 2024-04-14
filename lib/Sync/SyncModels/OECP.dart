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

List<OECPModel> OECPModelFromJson(String str) =>
    List<OECPModel>.from(json.decode(str).map((x) => OECPModel.fromJson(x)));

String OECPModelToJson(List<OECPModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OECPModel {
  OECPModel({
    this.ID,
    this.RouteCode,
    this.ReqDate,
    this.AprvDate,
    this.PostingDate,
    this.ApprovedAmt,
    this.ApprovedBy,
    this.CreateDate,
    this.UpdateDate,
    this.hasCreated = false,
    this.hasUpdated = false,
    this.isAddedToDB = false,
    this.CreatedBy,
    this.BranchId,
    this.UpdatedBy,
    this.LocalDate,
    this.TransId,
    this.PermanentTransId,
    this.EmpId,
    this.EmpName,
    this.EmpGroupId,
    this.EmpDesc,
    this.Remarks,
    this.RequestedAmt,
    this.OpenAmt,
    this.FromDate,
    this.ToDate,
    this.Factor,
    this.AdditionalCash,
    this.AdditionalApprovedCash,
    this.ApprovalStatus,
    this.RPTransId,
    this.Currency,
    this.Rate,
    this.DocEntry,
    this.DocNum,
    this.DraftKey,
    this.Error,
    this.DocStatus,
    this.RequisitionType,
    this.Latitude,
    this.Longitude,
  });

  int? ID;

  DateTime? ReqDate;
  DateTime? AprvDate;
  DateTime? PostingDate;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  bool hasCreated;
  bool hasUpdated;
  double? ApprovedAmt;
  String? DocStatus;
  String? RequisitionType;
  String? Latitude;
  String? Longitude;
  String? RouteCode;
  String? ApprovedBy;
  bool isAddedToDB;

  /// To be used only for development purpose
  double? diffAmt = 0.0;
  double? OpenAmt;
  String? CreatedBy;
  String? BranchId;
  String? UpdatedBy;
  String? LocalDate;
  String? TransId;
  String? PermanentTransId;
  String? EmpId;
  String? EmpName;
  String? EmpGroupId;
  String? EmpDesc;
  String? Remarks;
  double? RequestedAmt;
  DateTime? FromDate;
  DateTime? ToDate;
  double? Factor;
  double? AdditionalCash;
  double? AdditionalApprovedCash;
  String? ApprovalStatus;
  String? RPTransId;
  String? Currency;
  double? Rate;
  int? DocEntry;
  String? DocNum;
  String? DraftKey;
  String? Error;

  factory OECPModel.fromJson(Map<String, dynamic> json) => OECPModel(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        AprvDate: DateTime.tryParse(json["AprvDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        ReqDate: DateTime.tryParse(json["ReqDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        PostingDate: DateTime.tryParse(json["PostingDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        ApprovedAmt: double.tryParse(json["ApprovedAmt"].toString()) ?? 0.0,
        LocalDate: json["LocalDate"] ?? "",
        PermanentTransId: json["PermanentTransId"] ?? "",
        RequisitionType: json["RequisitionType"] ?? "",
        Latitude: json["Latitude"] ?? "",
        Longitude: json["Longitude"] ?? "",
        RouteCode: json["RouteCode"] ?? "",
        DocStatus: json["DocStatus"] ?? "",
        ApprovedBy: json["ApprovedBy"] ?? "",
        CreatedBy: json['CreatedBy'] ?? '',
        BranchId: json['BranchId'] ?? '',
        UpdatedBy: json['UpdatedBy'] ?? '',
        TransId: json['TransId'] ?? '',
        EmpId: json['EmpId'] ?? '',
        EmpName: json['EmpName'] ?? '',
        EmpGroupId: json['EmpGroupId'] ?? '',
        EmpDesc: json['EmpDesc'] ?? '',
        Remarks: json['Remarks'] ?? '',
        OpenAmt: double.tryParse(json['OpenAmt'].toString()) ?? 0.0,
        RequestedAmt: double.tryParse(json['RequestedAmt'].toString()) ?? 0.0,
        FromDate: DateTime.tryParse(json['FromDate'].toString()) ??
            DateTime.parse('1900-01-01'),
        ToDate: DateTime.tryParse(json['ToDate'].toString()) ??
            DateTime.parse('1900-01-01'),
        Factor: double.tryParse(json['Factor'].toString()) ?? 0.0,
        AdditionalCash:
            double.tryParse(json['AdditionalCash'].toString()) ?? 0.0,
        AdditionalApprovedCash:
            double.tryParse(json['AdditionalApprovedCash'].toString()) ?? 0.0,
        ApprovalStatus: json['ApprovalStatus'] ?? '',
        RPTransId: json['RPTransId'] ?? '',
        Currency: json['Currency'] ?? '',
        Rate: double.tryParse(json['Rate'].toString()) ?? 0.0,
        DocEntry: int.tryParse(json['DocEntry'].toString()),
        DocNum: json['DocNum'] ?? '',
        DraftKey: json['DraftKey'] ?? '',
        Error: json['Error'] ?? '',
        hasUpdated: json['has_updated'] == 1,
        hasCreated: json['has_created'] == 1,
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "RequisitionType": RequisitionType,
        "OpenAmt": OpenAmt,
        "DocStatus": DocStatus,
        "LocalDate": LocalDate,
        "Latitude": Latitude,
        "Longitude": Longitude,
        "TransId": TransId,
        "PermanentTransId": PermanentTransId,
        "BranchId": BranchId,
        "CreateDate": CreateDate?.toIso8601String(),
        "AprvDate": AprvDate?.toIso8601String(),
        "UpdateDate": UpdateDate?.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "has_updated": hasUpdated ? 1 : 0,
        "ReqDate": ReqDate?.toIso8601String(),
        "PostingDate": PostingDate?.toIso8601String(),
        "RequestedAmt": RequestedAmt,
        "CreatedBy": CreatedBy,
        "ApprovedAmt": ApprovedAmt,
        "ApprovedBy": ApprovedBy,
        'FromDate': FromDate?.toIso8601String(),
        'ToDate': ToDate?.toIso8601String(),
        'Factor': Factor,
        'AdditionalCash': AdditionalCash,
        'AdditionalApprovedCash': AdditionalApprovedCash,
        'ApprovalStatus': ApprovalStatus,
        'RPTransId': RPTransId,
        'RouteCode': RouteCode,
        'Currency': Currency,
        'Rate': Rate,
        'DocEntry': DocEntry,
        'DocNum': DocNum,
        'DraftKey': DraftKey,
        'Error': Error,
        'EmpId': EmpId,
        'EmpName': EmpName,
        'EmpGroupId': EmpGroupId,
        'EmpDesc': EmpDesc,
        'Remarks': Remarks,
      };
// Map<String, dynamic> toJson() => {
//   "ID": ID,
//   "RowId": RowId,
//   "ReqTransId": ReqTransId,
//   "ReqDate": "2022-09-09T07:07:54.328Z",
//   "Posting": "2022-09-09T07:07:54.328Z",
//   "ExpenseType": ExpenseType,
//   "DocName": DocName,
//   "Attachment": Attachment,
//   "Amount": Amount,
//   "ApprovedAmt": ApprovedAmt,
//   "ApprovedDate": "2022-09-09T07:07:54.328Z",
//   "ApprovedBy": ApprovedBy
// };
}

Future<List<OECPModel>> dataSyncOECP() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "OECP" + postfix));
  print(res.body);
  return OECPModelFromJson(res.body);
}

Future<void> dataSyncUpdateOECP(String ID, Map map) async {
  var res = await http.put(
      headers: header, Uri.parse(prefix + "OECP/Update?ID=$ID"), body: map);
  print(res.body);
}

Future<void> dataSyncAddOECP(Map map) async {
  var res = await http.post(
      headers: header, Uri.parse(prefix + prefix + "OECP/Add"), body: map);
  print(res.body);
}

// Future<void> insertOECP(Database db)async{
//   if(postfix.toLowerCase().contains("all"))
//   await deleteOECP(db);
//   List customers= await dataSyncOECP();
//   print(customers);
//   var batch = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try
//     {
//       batch.insert('OECP', customer.toJson());
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
//   //       await db.insert('OECP', customer.toJson());
//   //     });
//   //   }
//   //   catch(e)
//   //   {
//   //     getErrorSnackBar("Sync Error "+e.toString());
//   //   }
//   //
//   // });
// }
// Future<void> insertOECP(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteOECP(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncOECP();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('OECP_Temp', customer.toJson());
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
//       "SELECT * FROM  OECP_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN UpdateDate IS NULL THEN CreateDate ELSE UpdateDate END)");
//   u.forEach((element) {
//     batch2.update("OECP", element,
//         where: "TransId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["TransId"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from OECP_Temp where TransId  not in (Select TransId  from OECP)");
//
//   v.forEach((element) {
//     batch3.insert('OECP', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('OECP_Temp');
// }
Future<void> insertOECP(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteOECP(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncOECP();
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
      for (OECPModel record in batchRecords) {
        try {
          batch.insert('OECP_Temp', record.toJson());
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
			select * from OECP_Temp
			except
			select * from OECP
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
          batch.update("OECP", element,
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
  print('Time taken for OECP update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from OECP_Temp where TransId  not in (Select TransId  from OECP)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM OECP_Temp T0
LEFT JOIN OECP T1 ON T0.TransId = T1.TransId 
WHERE T1.TransId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('OECP', record);
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
      'Time taken for OECP_Temp and OECP compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('OECP_Temp');
  // stopwatch.stop();
}

Future<List<OECPModel>> retrieveOECP(BuildContext context) async {
  final Database db = await initializeDB(context);

  final List<Map<String, Object?>> queryResult = await db.query('OECP');

  return queryResult.map((e) => OECPModel.fromJson(e)).toList();
}

Future<List<OECPModel>> retrieveOECPById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('OECP', where: str, whereArgs: l);
  return queryResult.map((e) => OECPModel.fromJson(e)).toList();
}

Future<void> updateOECP(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update("OECP", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteOECP(Database db) async {
  await db.delete('OECP');
}

Future<List<OECPModel>> retrieveOECPByBranch(BuildContext context) async {
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
      await db.query("OECP", where: str, whereArgs: list);
  return queryResult.map((e) => OECPModel.fromJson(e)).toList();
}
//SEND DATA TO SERVER
//--------------------------

Future<void> insertOECPToServer(BuildContext? context,
    {String? TransId, int? ID}) async {
  String response = "";
  List<OECPModel> list = await retrieveOECPById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "TransId = ? AND ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, ID]);
  if (TransId != null) {
    //only single entry
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "OECP/Add"),
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
        print(jsonEncode(map));
        String queryParams='TransId=${list[i].TransId}';
        var res = await http.post(Uri.parse(prefix + "OECP/Add?$queryParams"),
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
          OECPModel model=OECPModel.fromJson(jsonDecode(res.body));
          var x = await db.update("OECP", model.toJson(),
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
            var x = await db.update("OECP", map,
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

Future<void> updateOECPOnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<OECPModel> list = await retrieveOECPById(
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
      print(map);
      var res = await http
          .put(Uri.parse(prefix + 'OECP/Update'),
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
          var x =
              await db.update("OECP", map, where: "TransId = ? ", whereArgs: [
            map["TransId"],
          ]);
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
