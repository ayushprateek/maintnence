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
class OIBT{
  int? ID;
  String? ItemCode;
  String? ItemName;
  double? Quantity;
  String? BaseObjectCode;
  int? BaseID;
  String? BaseTransId;
  int? BaseRowId;
  String? WhsCode;
  int? Direction;
  DateTime? InDate;
  DateTime? ExpDate;
  String? CreatedBy;
  String? BranchId;
  String? UpdatedBy;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  int? hasCreated;
  int? hasUpdated;
  OIBT({
    this.ID,
    this.ItemCode,
    this.ItemName,
    this.Quantity,
    this.BaseObjectCode,
    this.BaseID,
    this.BaseTransId,
    this.BaseRowId,
    this.WhsCode,
    this.Direction,
    this.InDate,
    this.ExpDate,
    this.CreatedBy,
    this.BranchId,
    this.UpdatedBy,
    this.CreateDate,
    this.UpdateDate,
    this.hasCreated,
    this.hasUpdated,
  });
  factory OIBT.fromJson(Map<String,dynamic> json)=>OIBT(
    ID : int.tryParse(json['ID'].toString())??0,
    ItemCode : json['ItemCode'],
    ItemName : json['ItemName'],
    Quantity : double.tryParse(json['Quantity'].toString())??0.0,
    BaseObjectCode : json['BaseObjectCode'],
    BaseID : int.tryParse(json['BaseID'].toString())??0,
    BaseTransId : json['BaseTransId'],
    BaseRowId : int.tryParse(json['BaseRowId'].toString())??0,
    WhsCode : json['WhsCode'],
    Direction : int.tryParse(json['Direction'].toString())??0,
    InDate : DateTime.tryParse(json['InDate'].toString()),
    ExpDate : DateTime.tryParse(json['ExpDate'].toString()),
    CreatedBy : json['CreatedBy'],
    BranchId : json['BranchId'],
    UpdatedBy : json['UpdatedBy'],
    CreateDate : DateTime.tryParse(json['CreateDate'].toString()),
    UpdateDate : DateTime.tryParse(json['UpdateDate'].toString()),
    hasCreated : int.tryParse(json['has_created'].toString())??0,
    hasUpdated : int.tryParse(json['has_updated'].toString())??0,
  );
  Map<String,dynamic> toJson()=>{
    'ID' : ID,
    'ItemCode' : ItemCode,
    'ItemName' : ItemName,
    'Quantity' : Quantity,
    'BaseObjectCode' : BaseObjectCode,
    'BaseID' : BaseID,
    'BaseTransId' : BaseTransId,
    'BaseRowId' : BaseRowId,
    'WhsCode' : WhsCode,
    'Direction' : Direction,
    'InDate' : InDate?.toIso8601String(),
    'ExpDate' : ExpDate?.toIso8601String(),
    'CreatedBy' : CreatedBy,
    'BranchId' : BranchId,
    'UpdatedBy' : UpdatedBy,
    'CreateDate' : CreateDate?.toIso8601String(),
    'UpdateDate' : UpdateDate?.toIso8601String(),
    'has_created' : hasCreated,
    'has_updated' : hasUpdated,
  };
}
List<OIBT> oIBTFromJson(String str) => List<OIBT>.from(
    json.decode(str).map((x) => OIBT.fromJson(x)));
String oIBTToJson(List<OIBT> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
Future<List<OIBT>> dataSyncOIBT() async {
  var res = await http.get(headers: header, Uri.parse(prefix + "OIBT" + postfix));
  print(res.body);
  return oIBTFromJson(res.body);}
Future<void> insertOIBT(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteOIBT(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncOIBT();
  }
  print(customers);
  Stopwatch stopwatch = Stopwatch();
  stopwatch.start();
  for (var i = 0; i < customers.length; i += batchSize) {
    var end = (i + batchSize < customers.length) ? i + batchSize : customers.length;
    var batchRecords = customers.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (OIBT record in batchRecords) {
        try {
          batch.insert('OIBT_Temp', record.toJson());
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
			select * from OIBT_Temp
			except
			select * from OIBT
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
          batch.update("OIBT", element,
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
  print('Time taken for OIBT update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from OIBT_Temp where TransId not in (Select TransId from OIBT)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM OIBT_Temp T0
LEFT JOIN OIBT T1 ON T0.TransId = T1.TransId 
WHERE T1.TransId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('OIBT', record);
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
      'Time taken for OIBT_Temp and OIBT compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('OIBT_Temp');
}

Future<List<OIBT>> retrieveOIBT(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('OIBT');
  return queryResult.map((e) => OIBT.fromJson(e)).toList();
}
Future<void> updateOIBT(int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('OIBT', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    getErrorSnackBar('Sync Error ' + e.toString());}}
Future<void> deleteOIBT(Database db) async {
  await db.delete('OIBT');
}
Future<List<OIBT>> retrieveOIBTById(BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('OIBT', where: str, whereArgs: l);
  return queryResult.map((e) => OIBT.fromJson(e)).toList();
}
Future<String> insertOIBTToServer(BuildContext? context, {String? TransId, int? id}) async {
  String response = "";
  List<OIBT> list = await retrieveOIBTById(context, TransId == null ? DataSync.getInsertToServerStr() : "TransId = ? AND ID = ?", TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "OIBT/Add"), headers: header, body: jsonEncode(list[0].toJson()));
    response = res.body;
  } else if (list.isNotEmpty) {
    int i = 0;
    bool sentSuccessInServer = false;
    do {
      sentSuccessInServer = false;
      try {
        Map<String, dynamic> map = list[i].toJson();
        map.remove('ID');
        var res = await http.post(Uri.parse(prefix + "OIBT/Add"), headers: header,
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
            var x = await db.update("OIBT", map, where: "TransId = ? AND RowId = ?", whereArgs: [map["TransId"], map["RowId"]]);
            print(x.toString());}}
        print(res.body);
      } catch (e) {
        print("Timeout " + e.toString());
        sentSuccessInServer = true;}
      print('i++;');
      print("INDEX = " + i.toString());
    } while (i < list.length && sentSuccessInServer == true);}
  return response;}
Future<void> updateOIBTOnServer(BuildContext? context, {String? condition, List? l}) async {
  List<OIBT> list = await retrieveOIBTById(context, l == null ? DataSync.getUpdateOnServerStr() : condition ?? "", l == null ? DataSync.getUpdateOnServerList() : l);
  print(list);
  int i = 0;
  bool sentSuccessInServer = false;
  do {
    sentSuccessInServer = false;
    try {
      Map<String, dynamic> map = list[i].toJson();
      var res = await http.put(Uri.parse(prefix + 'OIBT/Update'), headers: header, body: jsonEncode(map)).timeout(Duration(seconds: 30), onTimeout: () {
        return http.Response('Error', 500);
      });
      print(await res.statusCode);
      if (res.statusCode == 201 || res.statusCode == 500) {
        sentSuccessInServer = true;
        if (res.statusCode == 201) {
          final Database db = await initializeDB(context);
          map["has_updated"] = 0;
          var x = await db.update("OIBT", map, where: "TransId = ? AND RowId = ?", whereArgs: [map["TransId"], map["RowId"]]);
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

