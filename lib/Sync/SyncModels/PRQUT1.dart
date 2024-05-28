import 'package:maintenance/Component/LogFileFunctions.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'dart:convert';
import 'package:sqflite/sqlite_api.dart';
class PRQUT1{
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
  String? BaseTransId;
  String? BaseRowId;
  double? OpenQty;
  String? LineStatus;
  double? MSP;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  String? BaseObjectCode;
  double? RoutePlanningQty;
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
  PRQUT1({
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
    this.BaseTransId,
    this.BaseRowId,
    this.OpenQty,
    this.LineStatus,
    this.MSP,
    this.CreateDate,
    this.UpdateDate,
    this.BaseObjectCode,
    this.RoutePlanningQty,
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
  });
  factory PRQUT1.fromJson(Map<String,dynamic> json)=>PRQUT1(
    ID : int.tryParse(json['ID'].toString())??0,
    TransId : json['TransId']?.toString() ?? '',
    RowId : int.tryParse(json['RowId'].toString())??0,
    ItemCode : json['ItemCode']?.toString() ?? '',
    ItemName : json['ItemName']?.toString() ?? '',
    Quantity : double.tryParse(json['Quantity'].toString())??0.0,
    UOM : json['UOM']?.toString() ?? '',
    Price : double.tryParse(json['Price'].toString())??0.0,
    TaxCode : json['TaxCode']?.toString() ?? '',
    TaxRate : double.tryParse(json['TaxRate'].toString())??0.0,
    Discount : double.tryParse(json['Discount'].toString())??0.0,
    LineTotal : double.tryParse(json['LineTotal'].toString())??0.0,
    BaseTransId : json['BaseTransId']?.toString() ?? '',
    BaseRowId : json['BaseRowId']?.toString() ?? '',
    OpenQty : double.tryParse(json['OpenQty'].toString())??0.0,
    LineStatus : json['LineStatus']?.toString() ?? '',
    MSP : double.tryParse(json['MSP'].toString())??0.0,
    CreateDate : DateTime.tryParse(json['CreateDate'].toString()),
    UpdateDate : DateTime.tryParse(json['UpdateDate'].toString()),
    BaseObjectCode : json['BaseObjectCode']?.toString() ?? '',
    RoutePlanningQty : double.tryParse(json['RoutePlanningQty'].toString())??0.0,
    WhsCode : json['WhsCode']?.toString() ?? '',
    DocEntry : int.tryParse(json['DocEntry'].toString())??0,
    DocNum : json['DocNum']?.toString() ?? '',
    TripTransId : json['TripTransId']?.toString() ?? '',
    TruckNo : json['TruckNo']?.toString() ?? '',
    DriverCode : json['DriverCode']?.toString() ?? '',
    DriverName : json['DriverName']?.toString() ?? '',
    RouteCode : json['RouteCode']?.toString() ?? '',
    RouteName : json['RouteName']?.toString() ?? '',
    DeptCode : json['DeptCode']?.toString() ?? '',
    DeptName : json['DeptName']?.toString() ?? '',
  );
  Map<String,dynamic> toJson()=>{
    'ID' : ID,
    'TransId' : TransId,
    'RowId' : RowId,
    'ItemCode' : ItemCode,
    'ItemName' : ItemName,
    'Quantity' : Quantity,
    'UOM' : UOM,
    'Price' : Price,
    'TaxCode' : TaxCode,
    'TaxRate' : TaxRate,
    'Discount' : Discount,
    'LineTotal' : LineTotal,
    'BaseTransId' : BaseTransId,
    'BaseRowId' : BaseRowId,
    'OpenQty' : OpenQty,
    'LineStatus' : LineStatus,
    'MSP' : MSP,
    'CreateDate' : CreateDate?.toIso8601String(),
    'UpdateDate' : UpdateDate?.toIso8601String(),
    'BaseObjectCode' : BaseObjectCode,
    'RoutePlanningQty' : RoutePlanningQty,
    'WhsCode' : WhsCode,
    'DocEntry' : DocEntry,
    'DocNum' : DocNum,
    'TripTransId' : TripTransId,
    'TruckNo' : TruckNo,
    'DriverCode' : DriverCode,
    'DriverName' : DriverName,
    'RouteCode' : RouteCode,
    'RouteName' : RouteName,
    'DeptCode' : DeptCode,
    'DeptName' : DeptName,
  };
}
List<PRQUT1> pRQUT1FromJson(String str) => List<PRQUT1>.from(
    json.decode(str).map((x) => PRQUT1.fromJson(x)));
String pRQUT1ToJson(List<PRQUT1> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
Future<List<PRQUT1>> dataSyncPRQUT1() async {
  var res = await http.get(headers: header, Uri.parse(prefix + "PRQUT1" + postfix));
  print(res.body);
  return pRQUT1FromJson(res.body);}
Future<void> insertPRQUT1(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deletePRQUT1(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncPRQUT1();
  }
  print(customers);
  Stopwatch stopwatch = Stopwatch();
  stopwatch.start();
  for (var i = 0; i < customers.length; i += batchSize) {
    var end = (i + batchSize < customers.length) ? i + batchSize : customers.length;
    var batchRecords = customers.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (PRQUT1 record in batchRecords) {
        try {
          batch.insert('PRQUT1_Temp', record.toJson());
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
			select * from PRQUT1_Temp
			except
			select * from PRQUT1
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
          batch.update("PRQUT1", element,
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
  print('Time taken for PRQUT1 update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from PRQUT1_Temp where TransId not in (Select TransId from PRQUT1)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM PRQUT1_Temp T0
LEFT JOIN PRQUT1 T1 ON T0.TransId = T1.TransId 
WHERE T1.TransId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('PRQUT1', record);
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
      'Time taken for PRQUT1_Temp and PRQUT1 compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('PRQUT1_Temp');
}

Future<List<PRQUT1>> retrievePRQUT1(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('PRQUT1');
  return queryResult.map((e) => PRQUT1.fromJson(e)).toList();
}
Future<void> updatePRQUT1(int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('PRQUT1', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    getErrorSnackBar('Sync Error ' + e.toString());}}
Future<void> deletePRQUT1(Database db) async {
  await db.delete('PRQUT1');
}
Future<List<PRQUT1>> retrievePRQUT1ById(BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('PRQUT1', where: str, whereArgs: l);
  return queryResult.map((e) => PRQUT1.fromJson(e)).toList();
}
Future<String> insertPRQUT1ToServer(BuildContext? context, {String? TransId, int? id}) async {
  String response = "";
  List<PRQUT1> list = await retrievePRQUT1ById(context, TransId == null ? DataSync.getInsertToServerStr() : "TransId = ? AND ID = ?", TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "PRQUT1/Add"), headers: header, body: jsonEncode(list[0].toJson()));
    response = res.body;
  } else if (list.isNotEmpty) {
    int i = 0;
    bool sentSuccessInServer = false;
    do {
      sentSuccessInServer = false;
      try {
        Map<String, dynamic> map = list[i].toJson();
        map.remove('ID');
        var res = await http.post(Uri.parse(prefix + "PRQUT1/Add"), headers: header,
            body: jsonEncode(map)).timeout(Duration(seconds: 30), onTimeout: () {
          return http.Response('Error', 500);});
        response = await res.body;
        print("eeaaae status");
        print(await res.statusCode);
        if (res.statusCode == 201 || res.statusCode == 500) {
          sentSuccessInServer = true;
          if (res.statusCode == 201) {
            map['ID'] = jsonDecode(res.body)['ID'];
            final Database db = await initializeDB(context);
            // map=jsonDecode(res.body);
            map["has_created"] = 0;
            var x = await db.update("PRQUT1", map, where: "TransId = ? AND RowId = ?", whereArgs: [map["TransId"], map["RowId"]]);
            print(x.toString());}}
        print(res.body);
      } catch (e) {
        print("Timeout " + e.toString());
        sentSuccessInServer = true;}
      i++;
      print("INDEX = " + i.toString());
    } while (i < list.length && sentSuccessInServer == true);}
  return response;}
Future<void> updatePRQUT1OnServer(BuildContext? context, {String? condition, List? l}) async {
  List<PRQUT1> list = await retrievePRQUT1ById(context, l == null ? DataSync.getUpdateOnServerStr() : condition ?? "", l == null ? DataSync.getUpdateOnServerList() : l);
  print(list);
  int i = 0;
  bool sentSuccessInServer = false;
  do {
    sentSuccessInServer = false;
    try {
      Map<String, dynamic> map = list[i].toJson();
      var res = await http.put(Uri.parse(prefix + 'PRQUT1/Update'), headers: header, body: jsonEncode(map)).timeout(Duration(seconds: 30), onTimeout: () {
        return http.Response('Error', 500);
      });
      print(await res.statusCode);
      if (res.statusCode == 201 || res.statusCode == 500) {
        sentSuccessInServer = true;
        if (res.statusCode == 201) {
          final Database db = await initializeDB(context);
          map["has_updated"] = 0;
          var x = await db.update("PRQUT1", map, where: "TransId = ? AND RowId = ?", whereArgs: [map["TransId"], map["RowId"]]);
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

