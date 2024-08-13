import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

class IMGDI1 {
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
  String? LineStatus;
  double? OpenQty;
  double? MSP;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  String? BaseObjectCode;
  String? ToWhsCode;
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
  String? BaseTransId;
  int? BaseRowId;
  String? AdditionalStatus;
  String? BaseTab;
  bool hasCreated;
  bool hasUpdated;
  bool insertedIntoDatabase;

  IMGDI1({
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
    this.LineStatus,
    this.OpenQty,
    this.MSP,
    this.CreateDate,
    this.UpdateDate,
    this.BaseObjectCode,
    this.ToWhsCode,
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
    this.BaseTransId,
    this.BaseRowId,
    this.AdditionalStatus,
    this.BaseTab,
    this.hasCreated = false,
    this.hasUpdated = false,
    this.insertedIntoDatabase = true,
  });

  factory IMGDI1.fromJson(Map<String, dynamic> json) => IMGDI1(
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        TransId: json['TransId'],
        RowId: int.tryParse(json['RowId'].toString()) ?? 0,
        ItemCode: json['ItemCode'],
        ItemName: json['ItemName'],
        Quantity: double.tryParse(json['Quantity'].toString()) ?? 0.0,
        UOM: json['UOM'],
        Price: double.tryParse(json['Price'].toString()) ?? 0.0,
        TaxCode: json['TaxCode'],
        TaxRate: double.tryParse(json['TaxRate'].toString()) ?? 0.0,
        Discount: double.tryParse(json['Discount'].toString()) ?? 0.0,
        LineTotal: double.tryParse(json['LineTotal'].toString()) ?? 0.0,
        LineStatus: json['LineStatus'],
        OpenQty: double.tryParse(json['OpenQty'].toString()) ?? 0.0,
        MSP: double.tryParse(json['MSP'].toString()) ?? 0.0,
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()),
        BaseObjectCode: json['BaseObjectCode'],
        ToWhsCode: json['ToWhsCode'],
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
        BaseTransId: json['BaseTransId'],
        BaseRowId: int.tryParse(json['BaseRowId'].toString()) ?? 0,
        AdditionalStatus: json['AdditionalStatus'],
        BaseTab: json['BaseTab'],
        hasCreated: json['has_created'] == 1,
        hasUpdated: json['has_updated'] == 1,
      );

  Map<String, dynamic> toJson() => {
        'ID': ID,
        'TransId': TransId,
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
        'LineStatus': LineStatus,
        'OpenQty': OpenQty,
        'MSP': MSP,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'BaseObjectCode': BaseObjectCode,
        'ToWhsCode': ToWhsCode,
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
        'BaseTransId': BaseTransId,
        'BaseRowId': BaseRowId,
        'AdditionalStatus': AdditionalStatus,
        'BaseTab': BaseTab,
        "has_created": hasCreated ? 1 : 0,
        "has_updated": hasUpdated ? 1 : 0,
      };
}

List<IMGDI1> iMGDI1FromJson(String str) =>
    List<IMGDI1>.from(json.decode(str).map((x) => IMGDI1.fromJson(x)));

String iMGDI1ToJson(List<IMGDI1> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<IMGDI1>> dataSyncIMGDI1() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "IMGDI1" + postfix));
  print(res.body);
  return iMGDI1FromJson(res.body);
}

Future<void> insertIMGDI1(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteIMGDI1(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncIMGDI1();
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
      for (IMGDI1 record in batchRecords) {
        try {
          batch.insert('IMGDI1_Temp', record.toJson());
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
			select * from IMGDI1_Temp
			except
			select * from IMGDI1
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
          batch.update("IMGDI1", element,
              where:
                  "TransId = ? AND RowId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
              whereArgs: [element["TransId"], element["RowId"], 1, 1]);
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
  print('Time taken for IMGDI1 update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  var v = await db.rawQuery('''
    SELECT T0.*
FROM IMGDI1_Temp T0
LEFT JOIN IMGDI1 T1 ON T0.TransId = T1.TransId AND T0.RowId = T1.RowId
WHERE T1.TransId IS NULL AND T1.RowId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('IMGDI1', record);
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
      'Time taken for IMGDI1_Temp and IMGDI1 compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('IMGDI1_Temp');
}

Future<List<IMGDI1>> retrieveIMGDI1(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('IMGDI1');
  return queryResult.map((e) => IMGDI1.fromJson(e)).toList();
}

Future<void> updateIMGDI1(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('IMGDI1', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deleteIMGDI1(Database db) async {
  await db.delete('IMGDI1');
}

Future<List<IMGDI1>> retrieveIMGDI1ById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('IMGDI1', where: str, whereArgs: l);
  return queryResult.map((e) => IMGDI1.fromJson(e)).toList();
}

Future<String> insertIMGDI1ToServer(BuildContext? context,
    {String? TransId, int? id}) async {
  String response = "";
  List<IMGDI1> list = await retrieveIMGDI1ById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "TransId = ? AND ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "IMGDI1/Add"),
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
            .post(Uri.parse(prefix + "IMGDI1/Add"),
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
          IMGDI1 model = IMGDI1.fromJson(jsonDecode(res.body));
          map["ID"] = model.ID;
          map["has_created"] = 0;
          var x = await db.update("IMGDI1", map,
              where: "TransId = ? AND RowId = ?",
              whereArgs: [model.TransId, model.RowId]);
          print(x.toString());
        } else if (res.statusCode == 201 || res.statusCode == 500) {
          sentSuccessInServer = true;
          if (res.statusCode == 201) {
            map['ID'] = jsonDecode(res.body)['ID'];
            final Database db = await initializeDB(context);
            // map=jsonDecode(res.body);
            map["has_created"] = 0;
            var x = await db.update("IMGDI1", map,
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
  return response;
}

Future<void> updateIMGDI1OnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<IMGDI1> list = await retrieveIMGDI1ById(
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
          .put(Uri.parse(prefix + 'IMGDI1/Update'),
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
          var x = await db.update("IMGDI1", map,
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
