import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

class IMOGDI {
  int? ID;
  String? TransId;
  String? RequestedCode;
  String? RequestedName;
  String? RefNo;
  String? MobileNo;
  DateTime? PostingDate;
  DateTime? ValidUntill;
  String? Currency;
  double? CurrRate;
  String? ApprovalStatus;
  String? DocStatus;
  double? TotBDisc;
  double? DiscPer;
  double? DiscVal;
  double? TaxVal;
  double? DocTotal;
  String? PermanentTransId;
  int? DocEntry;
  String? DocNum;
  String? CreatedBy;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  String? ApprovedBy;
  String? Error;
  bool? IsPosted;
  String? DraftKey;
  String? Latitude;
  String? Longitude;
  String? ObjectCode;
  String? ToWhsCode;
  String? Remarks;
  String? BranchId;
  String? UpdatedBy;
  String? PostingAddress;
  String? TripTransId;
  String? DeptCode;
  String? DeptName;
  bool hasCreated;
  bool hasUpdated;

  IMOGDI({
    this.ID,
    this.TransId,
    this.RequestedCode,
    this.RequestedName,
    this.RefNo,
    this.MobileNo,
    this.PostingDate,
    this.ValidUntill,
    this.Currency,
    this.CurrRate,
    this.ApprovalStatus,
    this.DocStatus,
    this.TotBDisc,
    this.DiscPer,
    this.DiscVal,
    this.TaxVal,
    this.DocTotal,
    this.PermanentTransId,
    this.DocEntry,
    this.DocNum,
    this.CreatedBy,
    this.CreateDate,
    this.UpdateDate,
    this.ApprovedBy,
    this.Error,
    this.IsPosted,
    this.DraftKey,
    this.Latitude,
    this.Longitude,
    this.ObjectCode,
    this.ToWhsCode,
    this.Remarks,
    this.BranchId,
    this.UpdatedBy,
    this.PostingAddress,
    this.TripTransId,
    this.DeptCode,
    this.DeptName,
    this.hasCreated = false,
    this.hasUpdated = false,
  });

  factory IMOGDI.fromJson(Map<String, dynamic> json) => IMOGDI(
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        TransId: json['TransId'],
        RequestedCode: json['RequestedCode'],
        RequestedName: json['RequestedName'],
        RefNo: json['RefNo'],
        MobileNo: json['MobileNo'],
        PostingDate: DateTime.tryParse(json['PostingDate'].toString()),
        ValidUntill: DateTime.tryParse(json['ValidUntill'].toString()),
        Currency: json['Currency'],
        CurrRate: double.tryParse(json['CurrRate'].toString()) ?? 0.0,
        ApprovalStatus: json['ApprovalStatus'],
        DocStatus: json['DocStatus'],
        TotBDisc: double.tryParse(json['TotBDisc'].toString()) ?? 0.0,
        DiscPer: double.tryParse(json['DiscPer'].toString()) ?? 0.0,
        DiscVal: double.tryParse(json['DiscVal'].toString()) ?? 0.0,
        TaxVal: double.tryParse(json['TaxVal'].toString()) ?? 0.0,
        DocTotal: double.tryParse(json['DocTotal'].toString()) ?? 0.0,
        PermanentTransId: json['PermanentTransId'],
        DocEntry: int.tryParse(json['DocEntry'].toString()) ?? 0,
        DocNum: json['DocNum'],
        CreatedBy: json['CreatedBy'],
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()),
        ApprovedBy: json['ApprovedBy'],
        Error: json['Error'],
        IsPosted:
            json['IsPosted'] is bool ? json['IsPosted'] : json['IsPosted'] == 1,
        DraftKey: json['DraftKey'],
        Latitude: json['Latitude'],
        Longitude: json['Longitude'],
        ObjectCode: json['ObjectCode'],
        ToWhsCode: json['ToWhsCode'],
        Remarks: json['Remarks'],
        BranchId: json['BranchId'],
        UpdatedBy: json['UpdatedBy'],
        PostingAddress: json['PostingAddress'],
        TripTransId: json['TripTransId'],
        DeptCode: json['DeptCode'],
        DeptName: json['DeptName'],
        hasCreated: json['has_created'] == 1,
        hasUpdated: json['has_updated'] == 1,
      );

  Map<String, dynamic> toJson() => {
        'ID': ID,
        'TransId': TransId,
        'RequestedCode': RequestedCode,
        'RequestedName': RequestedName,
        'RefNo': RefNo,
        'MobileNo': MobileNo,
        'PostingDate': PostingDate?.toIso8601String(),
        'ValidUntill': ValidUntill?.toIso8601String(),
        'Currency': Currency,
        'CurrRate': CurrRate,
        'ApprovalStatus': ApprovalStatus,
        'DocStatus': DocStatus,
        'TotBDisc': TotBDisc,
        'DiscPer': DiscPer,
        'DiscVal': DiscVal,
        'TaxVal': TaxVal,
        'DocTotal': DocTotal,
        'PermanentTransId': PermanentTransId,
        'DocEntry': DocEntry,
        'DocNum': DocNum,
        'CreatedBy': CreatedBy,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'ApprovedBy': ApprovedBy,
        'Error': Error,
        'IsPosted': IsPosted,
        'DraftKey': DraftKey,
        'Latitude': Latitude,
        'Longitude': Longitude,
        'ObjectCode': ObjectCode,
        'ToWhsCode': ToWhsCode,
        'Remarks': Remarks,
        'BranchId': BranchId,
        'UpdatedBy': UpdatedBy,
        'PostingAddress': PostingAddress,
        'TripTransId': TripTransId,
        'DeptCode': DeptCode,
        'DeptName': DeptName,
        "has_created": hasCreated ? 1 : 0,
        "has_updated": hasUpdated ? 1 : 0,
      };
}

List<IMOGDI> iMOGDIFromJson(String str) =>
    List<IMOGDI>.from(json.decode(str).map((x) => IMOGDI.fromJson(x)));

String iMOGDIToJson(List<IMOGDI> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<IMOGDI>> dataSyncIMOGDI() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "IMOGDI" + postfix));
  print(res.body);
  return iMOGDIFromJson(res.body);
}

Future<void> insertIMOGDI(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteIMOGDI(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncIMOGDI();
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
      for (IMOGDI record in batchRecords) {
        try {
          batch.insert('IMOGDI_Temp', record.toJson());
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
			select * from IMOGDI_Temp
			except
			select * from IMOGDI
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
          batch.update("IMOGDI", element,
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
  print('Time taken for IMOGDI update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from IMOGDI_Temp where TransId not in (Select TransId from IMOGDI)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM IMOGDI_Temp T0
LEFT JOIN IMOGDI T1 ON T0.TransId = T1.TransId 
WHERE T1.TransId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('IMOGDI', record);
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
      'Time taken for IMOGDI_Temp and IMOGDI compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('IMOGDI_Temp');
}

Future<List<IMOGDI>> retrieveIMOGDI(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('IMOGDI');
  return queryResult.map((e) => IMOGDI.fromJson(e)).toList();
}

Future<void> updateIMOGDI(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('IMOGDI', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deleteIMOGDI(Database db) async {
  await db.delete('IMOGDI');
}

Future<List<IMOGDI>> retrieveIMOGDIById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('IMOGDI', where: str, whereArgs: l);
  return queryResult.map((e) => IMOGDI.fromJson(e)).toList();
}

Future<String> insertIMOGDIToServer(BuildContext? context,
    {String? TransId, int? id}) async {
  String response = "";
  List<IMOGDI> list = await retrieveIMOGDIById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "TransId = ? AND ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "IMOGDI/Add"),
        headers: header, body: jsonEncode(list[0].toJson()));
    response = res.body;
  } else if (list.isNotEmpty) {
    int i = 0;
    bool sentSuccessInServer = false;
    do {
      sentSuccessInServer = false;
      try {
        Map<String, dynamic> map = list[i].toJson();
        map.remove('ID');
        var res = await http
            .post(Uri.parse(prefix + "IMOGDI/Add"),
                headers: header, body: jsonEncode(map))
            .timeout(Duration(seconds: 30), onTimeout: () {
          return http.Response('Error', 500);
        });
        response = await res.body;
        print("eeaaae status");
        print(await res.statusCode);
        if (res.statusCode == 409) {
          ///Already added in server
          final Database db = await initializeDB(context);
          IMOGDI model = IMOGDI.fromJson(jsonDecode(res.body));
          map["ID"] = model.ID;
          map["has_created"] = 0;
          var x = await db.update("IMGDI1", map,
              where: "TransId = ?",
              whereArgs: [model.TransId]);
          print(x.toString());
        } else
        if (res.statusCode == 201 || res.statusCode == 500) {
          sentSuccessInServer = true;
          if (res.statusCode == 201) {
            map['ID'] = jsonDecode(res.body)['ID'];
            final Database db = await initializeDB(context);
            // map = jsonDecode(res.body);
            map["has_created"] = 0;
            var x = await db.update("IMOGDI", map,
                where: "TransId = ?", whereArgs: [map["TransId"]]);
            print(x.toString());
          }
        }
        print(res.body);
      } catch (e) {
        print("Timeout " + e.toString());
        sentSuccessInServer = true;
      }
      i++;
      print("INDEX = " + i.toString());
    } while (i < list.length && sentSuccessInServer == true);
  }
  return response;
}

Future<List<IMOGDI>> retrieveIMOGDIForSearch({
  int? limit,
  String? query,
}) async {
  query = "%$query%";
  final Database db = await initializeDB(null);
  final List<Map<String, Object?>> queryResult =
      await db.rawQuery("SELECT * FROM IMOGDI WHERE TransId LIKE '$query'");
  return queryResult.map((e) => IMOGDI.fromJson(e)).toList();
}

Future<void> updateIMOGDIOnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<IMOGDI> list = await retrieveIMOGDIById(
      context,
      l == null ? DataSync.getUpdateOnServerStr() : condition ?? "",
      l == null ? DataSync.getUpdateOnServerList() : l);
  print(list);
  int i = 0;
  bool sentSuccessInServer = false;
  do {
    sentSuccessInServer = false;
    try {
      Map<String, dynamic> map = list[i].toJson();
      var res = await http
          .put(Uri.parse(prefix + 'IMOGDI/Update'),
              headers: header, body: jsonEncode(map))
          .timeout(Duration(seconds: 30), onTimeout: () {
        return http.Response('Error', 500);
      });
      print(await res.statusCode);
      if (res.statusCode == 201 || res.statusCode == 500) {
        sentSuccessInServer = true;
        if (res.statusCode == 201) {
          final Database db = await initializeDB(context);
          map["has_updated"] = 0;
          var x = await db.update("IMOGDI", map,
              where: "TransId = ?", whereArgs: [map["TransId"]]);
          print(x.toString());
        }
      }
      print(res.body);
    } catch (e) {
      print("Timeout " + e.toString());
      sentSuccessInServer = true;
    }

    i++;
    print("INDEX = " + i.toString());
  } while (i < list.length && sentSuccessInServer == true);
}
