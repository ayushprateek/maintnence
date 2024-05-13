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
class OPTRE1{
  int? ID;
  String? TransId;
  int? RowId;
  String? BaseTransId;
  int? BaseRowId;
  String? CardCode;
  String? CardName;
  String? ItemCode;
  String? ItemName;
  double? Quantity;
  double? OpenQty;
  String? UOM;
  DateTime? DelDueDate;
  String? ShipToAddress;
  bool? CollectCash;
  double? LoadQty;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  String? BaseObjectCode;
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
  String? ContractId;
  String? ContractTranId;
  String? LineStatus;
  double? LoadQtyWeight;
  double? OpenQtyWeight;
  String? Remarks;
  double? NoOfPieces;
  OPTRE1({
    this.ID,
    this.TransId,
    this.RowId,
    this.BaseTransId,
    this.BaseRowId,
    this.CardCode,
    this.CardName,
    this.ItemCode,
    this.ItemName,
    this.Quantity,
    this.OpenQty,
    this.UOM,
    this.DelDueDate,
    this.ShipToAddress,
    this.CollectCash,
    this.LoadQty,
    this.CreateDate,
    this.UpdateDate,
    this.BaseObjectCode,
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
    this.ContractId,
    this.ContractTranId,
    this.LineStatus,
    this.LoadQtyWeight,
    this.OpenQtyWeight,
    this.Remarks,
    this.NoOfPieces,
  });
  factory OPTRE1.fromJson(Map<String,dynamic> json)=>OPTRE1(
    ID : int.tryParse(json['ID'].toString())??0,
    TransId : json['TransId']?.toString() ?? '',
    RowId : int.tryParse(json['RowId'].toString())??0,
    BaseTransId : json['BaseTransId']?.toString() ?? '',
    BaseRowId : int.tryParse(json['BaseRowId'].toString())??0,
    CardCode : json['CardCode']?.toString() ?? '',
    CardName : json['CardName']?.toString() ?? '',
    ItemCode : json['ItemCode']?.toString() ?? '',
    ItemName : json['ItemName']?.toString() ?? '',
    Quantity : double.tryParse(json['Quantity'].toString())??0.0,
    OpenQty : double.tryParse(json['OpenQty'].toString())??0.0,
    UOM : json['UOM']?.toString() ?? '',
    DelDueDate : DateTime.tryParse(json['DelDueDate'].toString()),
    ShipToAddress : json['ShipToAddress']?.toString() ?? '',
    CollectCash : json['CollectCash'] is bool ? json['CollectCash'] : json['CollectCash']==1,
    LoadQty : double.tryParse(json['LoadQty'].toString())??0.0,
    CreateDate : DateTime.tryParse(json['CreateDate'].toString()),
    UpdateDate : DateTime.tryParse(json['UpdateDate'].toString()),
    BaseObjectCode : json['BaseObjectCode']?.toString() ?? '',
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
    ContractId : json['ContractId']?.toString() ?? '',
    ContractTranId : json['ContractTranId']?.toString() ?? '',
    LineStatus : json['LineStatus']?.toString() ?? '',
    LoadQtyWeight : double.tryParse(json['LoadQtyWeight'].toString())??0.0,
    OpenQtyWeight : double.tryParse(json['OpenQtyWeight'].toString())??0.0,
    Remarks : json['Remarks']?.toString() ?? '',
    NoOfPieces : double.tryParse(json['NoOfPieces'].toString())??0.0,
  );
  Map<String,dynamic> toJson()=>{
    'ID' : ID,
    'TransId' : TransId,
    'RowId' : RowId,
    'BaseTransId' : BaseTransId,
    'BaseRowId' : BaseRowId,
    'CardCode' : CardCode,
    'CardName' : CardName,
    'ItemCode' : ItemCode,
    'ItemName' : ItemName,
    'Quantity' : Quantity,
    'OpenQty' : OpenQty,
    'UOM' : UOM,
    'DelDueDate' : DelDueDate?.toIso8601String(),
    'ShipToAddress' : ShipToAddress,
    'CollectCash' : CollectCash,
    'LoadQty' : LoadQty,
    'CreateDate' : CreateDate?.toIso8601String(),
    'UpdateDate' : UpdateDate?.toIso8601String(),
    'BaseObjectCode' : BaseObjectCode,
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
    'ContractId' : ContractId,
    'ContractTranId' : ContractTranId,
    'LineStatus' : LineStatus,
    'LoadQtyWeight' : LoadQtyWeight,
    'OpenQtyWeight' : OpenQtyWeight,
    'Remarks' : Remarks,
    'NoOfPieces' : NoOfPieces,
  };
}
List<OPTRE1> oPTRE1FromJson(String str) => List<OPTRE1>.from(
    json.decode(str).map((x) => OPTRE1.fromJson(x)));
String oPTRE1ToJson(List<OPTRE1> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
Future<List<OPTRE1>> dataSyncOPTRE1() async {
  var res = await http.get(headers: header, Uri.parse(prefix + "OPTRE1" + postfix));
  print(res.body);
  return oPTRE1FromJson(res.body);}
Future<void> insertOPTRE1(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteOPTRE1(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncOPTRE1();
  }
  print(customers);
  Stopwatch stopwatch = Stopwatch();
  stopwatch.start();
  for (var i = 0; i < customers.length; i += batchSize) {
    var end = (i + batchSize < customers.length) ? i + batchSize : customers.length;
    var batchRecords = customers.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (OPTRE1 record in batchRecords) {
        try {
          batch.insert('OPTRE1_Temp', record.toJson());
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
			select * from OPTRE1_Temp
			except
			select * from OPTRE1
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
          batch.update("OPTRE1", element,
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
  print('Time taken for OPTRE1 update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from OPTRE1_Temp where TransId not in (Select TransId from OPTRE1)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM OPTRE1_Temp T0
LEFT JOIN OPTRE1 T1 ON T0.TransId = T1.TransId 
WHERE T1.TransId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('OPTRE1', record);
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
      'Time taken for OPTRE1_Temp and OPTRE1 compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('OPTRE1_Temp');
}

Future<List<OPTRE1>> retrieveOPTRE1(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('OPTRE1');
  return queryResult.map((e) => OPTRE1.fromJson(e)).toList();
}
Future<void> updateOPTRE1(int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('OPTRE1', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    getErrorSnackBar('Sync Error ' + e.toString());}}
Future<void> deleteOPTRE1(Database db) async {
  await db.delete('OPTRE1');
}
Future<List<OPTRE1>> retrieveOPTRE1ById(BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('OPTRE1', where: str, whereArgs: l);
  return queryResult.map((e) => OPTRE1.fromJson(e)).toList();
}
Future<String> insertOPTRE1ToServer(BuildContext? context, {String? TransId, int? id}) async {
  String response = "";
  List<OPTRE1> list = await retrieveOPTRE1ById(context, TransId == null ? DataSync.getInsertToServerStr() : "TransId = ? AND ID = ?", TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "OPTRE1/Add"), headers: header, body: jsonEncode(list[0].toJson()));
    response = res.body;
  } else if (list.isNotEmpty) {
    int i = 0;
    bool sentSuccessInServer = false;
    do {
      sentSuccessInServer = false;
      try {
        Map<String, dynamic> map = list[i].toJson();
        map.remove('ID');
        var res = await http.post(Uri.parse(prefix + "OPTRE1/Add"), headers: header,
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
            map=jsonDecode(res.body);
            map["has_created"] = 0;
            var x = await db.update("OPTRE1", map, where: "TransId = ? AND RowId = ?", whereArgs: [map["TransId"], map["RowId"]]);
            print(x.toString());}}
        print(res.body);
      } catch (e) {
        print("Timeout " + e.toString());
        sentSuccessInServer = true;}
      print('i++;');
      print("INDEX = " + i.toString());
    } while (i < list.length && sentSuccessInServer == true);}
  return response;}
Future<void> updateOPTRE1OnServer(BuildContext? context, {String? condition, List? l}) async {
  List<OPTRE1> list = await retrieveOPTRE1ById(context, l == null ? DataSync.getUpdateOnServerStr() : condition ?? "", l == null ? DataSync.getUpdateOnServerList() : l);
  print(list);
  int i = 0;
  bool sentSuccessInServer = false;
  do {
    sentSuccessInServer = false;
    try {
      Map<String, dynamic> map = list[i].toJson();
      var res = await http.put(Uri.parse(prefix + 'OPTRE1/Update'), headers: header, body: jsonEncode(map)).timeout(Duration(seconds: 30), onTimeout: () {
        return http.Response('Error', 500);
      });
      print(await res.statusCode);
      if (res.statusCode == 201 || res.statusCode == 500) {
        sentSuccessInServer = true;
        if (res.statusCode == 201) {
          final Database db = await initializeDB(context);
          map["has_updated"] = 0;
          var x = await db.update("OPTRE1", map, where: "TransId = ? AND RowId = ?", whereArgs: [map["TransId"], map["RowId"]]);
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

