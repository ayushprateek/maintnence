import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

class PRPDN1 {
  int? ID;
  String? TransId;
  int? RowId;
  String? ItemCode;
  String? ItemName;
  double? Quantity;
  String? UOM;
  double? Price;
  String? TaxCode;
  double? TaxRate;
  double? Discount;
  double? LineTotal;
  String? RPTransId;
  String? DSTranId;
  String? CRTransId;
  int? DSRowId;
  String? BaseTransId;
  int? BaseRowId;
  String? BaseType;
  String? LineStatus;
  double? MSP;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  double? OpenQty;
  String? BaseObjectCode;
  String? WhsCode;
  int? DocEntry;
  String? DocNum;
  String? TripTransId;
  String? TruckNo;
  String? DriverCode;
  String? DriverName;
  String? RouteCode;
  String? RouteName;
  String? DeptCode;
  String? DeptName;
  double? NoOfPieces;
  String? Remarks;
  String? BaseTab;
  bool hasCreated;
  bool insertedIntoDatabase;

  bool hasUpdated;

  PRPDN1({
    this.ID,
    this.TransId,
    this.RowId,
    this.ItemCode,
    this.ItemName,
    this.Quantity,
    this.UOM,
    this.Price,
    this.TaxCode,
    this.TaxRate,
    this.Discount,
    this.LineTotal,
    this.RPTransId,
    this.DSTranId,
    this.CRTransId,
    this.DSRowId,
    this.BaseTransId,
    this.BaseRowId,
    this.BaseType,
    this.LineStatus,
    this.MSP,
    this.CreateDate,
    this.UpdateDate,
    this.OpenQty,
    this.BaseObjectCode,
    this.WhsCode,
    this.DocEntry,
    this.DocNum,
    this.TripTransId,
    this.TruckNo,
    this.DriverCode,
    this.DriverName,
    this.RouteCode,
    this.RouteName,
    this.DeptCode,
    this.DeptName,
    this.NoOfPieces,
    this.Remarks,
    this.BaseTab,
    this.hasCreated = false,
    this.hasUpdated = false,
    this.insertedIntoDatabase = true,
  });

  factory PRPDN1.fromJson(Map<String, dynamic> json) => PRPDN1(
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        TransId: json['TransId'],
        RowId: int.tryParse(json['RowId'].toString()) ?? 0,
        ItemCode: json['ItemCode'],
        ItemName: json['ItemName'],
        Quantity: double.tryParse(json['Quantity'].toString()) ?? 0.0,
        UOM: json['UOM'],
        Price: double.tryParse(json['Price'].toString()) ?? 0.0,
        TaxCode: json['TaxCode'],
        hasCreated: json['has_created'] == 1,
        hasUpdated: json['has_updated'] == 1,
        TaxRate: double.tryParse(json['TaxRate'].toString()) ?? 0.0,
        Discount: double.tryParse(json['Discount'].toString()) ?? 0.0,
        LineTotal: double.tryParse(json['LineTotal'].toString()) ?? 0.0,
        RPTransId: json['RPTransId'],
        DSTranId: json['DSTranId'],
        CRTransId: json['CRTransId'],
        DSRowId: int.tryParse(json['DSRowId'].toString()) ?? 0,
        BaseTransId: json['BaseTransId'],
        BaseRowId: int.tryParse(json['BaseRowId'].toString()) ?? 0,
        BaseType: json['BaseType'],
        LineStatus: json['LineStatus'],
        MSP: double.tryParse(json['MSP'].toString()) ?? 0.0,
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()),
        OpenQty: double.tryParse(json['OpenQty'].toString()) ?? 0.0,
        BaseObjectCode: json['BaseObjectCode'],
        WhsCode: json['WhsCode'],
        DocEntry: int.tryParse(json['DocEntry'].toString()) ?? 0,
        DocNum: json['DocNum'],
        TripTransId: json['TripTransId'],
        TruckNo: json['TruckNo'],
        DriverCode: json['DriverCode'],
        DriverName: json['DriverName'],
        RouteCode: json['RouteCode'],
        RouteName: json['RouteName'],
        DeptCode: json['DeptCode'],
        DeptName: json['DeptName'],
        NoOfPieces: double.tryParse(json['NoOfPieces'].toString()) ?? 0.0,
        Remarks: json['Remarks'],
        BaseTab: json['BaseTab'],
      );

  Map<String, dynamic> toJson() => {
        'ID': ID,
        'TransId': TransId,
        "has_created": hasCreated ? 1 : 0,
        "has_updated": hasUpdated ? 1 : 0,
        'RowId': RowId,
        'ItemCode': ItemCode,
        'ItemName': ItemName,
        'Quantity': Quantity,
        'UOM': UOM,
        'Price': Price,
        'TaxCode': TaxCode,
        'TaxRate': TaxRate,
        'Discount': Discount,
        'LineTotal': LineTotal,
        'RPTransId': RPTransId,
        'DSTranId': DSTranId,
        'CRTransId': CRTransId,
        'DSRowId': DSRowId,
        'BaseTransId': BaseTransId,
        'BaseRowId': BaseRowId,
        'BaseType': BaseType,
        'LineStatus': LineStatus,
        'MSP': MSP,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'OpenQty': OpenQty,
        'BaseObjectCode': BaseObjectCode,
        'WhsCode': WhsCode,
        'DocEntry': DocEntry,
        'DocNum': DocNum,
        'TripTransId': TripTransId,
        'TruckNo': TruckNo,
        'DriverCode': DriverCode,
        'DriverName': DriverName,
        'RouteCode': RouteCode,
        'RouteName': RouteName,
        'DeptCode': DeptCode,
        'DeptName': DeptName,
        'NoOfPieces': NoOfPieces,
        'Remarks': Remarks,
        'BaseTab': BaseTab,
      };
}

List<PRPDN1> pRPDN1FromJson(String str) =>
    List<PRPDN1>.from(json.decode(str).map((x) => PRPDN1.fromJson(x)));

String pRPDN1ToJson(List<PRPDN1> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<PRPDN1>> dataSyncPRPDN1() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "PRPDN1" + postfix));
  print(res.body);
  return pRPDN1FromJson(res.body);
}

Future<void> insertPRPDN1(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deletePRPDN1(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncPRPDN1();
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
      for (PRPDN1 record in batchRecords) {
        try {
          batch.insert('PRPDN1_Temp', record.toJson());
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
			select * from PRPDN1_Temp
			except
			select * from PRPDN1
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
          batch.update("PRPDN1", element,
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
  print('Time taken for PRPDN1 update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from PRPDN1_Temp where TransId not in (Select TransId from PRPDN1)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM PRPDN1_Temp T0
LEFT JOIN PRPDN1 T1 ON T0.TransId = T1.TransId 
WHERE T1.TransId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('PRPDN1', record);
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
      'Time taken for PRPDN1_Temp and PRPDN1 compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('PRPDN1_Temp');
}

Future<List<PRPDN1>> retrievePRPDN1(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('PRPDN1');
  return queryResult.map((e) => PRPDN1.fromJson(e)).toList();
}

Future<void> updatePRPDN1(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('PRPDN1', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deletePRPDN1(Database db) async {
  await db.delete('PRPDN1');
}

Future<List<PRPDN1>> retrievePRPDN1ById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('PRPDN1', where: str, whereArgs: l);
  return queryResult.map((e) => PRPDN1.fromJson(e)).toList();
}

Future<String> insertPRPDN1ToServer(BuildContext? context,
    {String? TransId, int? id}) async {
  String response = "";
  List<PRPDN1> list = await retrievePRPDN1ById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "TransId = ? AND ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "PRPDN1/Add"),
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
            .post(Uri.parse(prefix + "PRPDN1/Add"),
                headers: header, body: jsonEncode(map))
            .timeout(Duration(seconds: 30), onTimeout: () {
          return http.Response('Error', 500);
        });
        response = await res.body;
        print("eeaaae status");
        print(await res.statusCode);
        if (res.statusCode == 201 || res.statusCode == 500) {
          sentSuccessInServer = true;
          if (res.statusCode == 201) {
            map['ID'] = jsonDecode(res.body)['ID'];
            final Database db = await initializeDB(context);
            map = jsonDecode(res.body);
            map["has_created"] = 0;
            var x = await db.update("PRPDN1", map,
                where: "TransId = ? AND RowId = ?",
                whereArgs: [map["TransId"], map["RowId"]]);
            print(x.toString());
          }
        }
        print(res.body);
      } catch (e) {
        print("Timeout " + e.toString());
        sentSuccessInServer = true;
      }
      print('i++;');
      print("INDEX = " + i.toString());
    } while (i < list.length && sentSuccessInServer == true);
  }
  return response;
}

Future<void> updatePRPDN1OnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<PRPDN1> list = await retrievePRPDN1ById(
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
          .put(Uri.parse(prefix + 'PRPDN1/Update'),
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
          var x = await db.update("PRPDN1", map,
              where: "TransId = ? AND RowId = ?",
              whereArgs: [map["TransId"], map["RowId"]]);
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
