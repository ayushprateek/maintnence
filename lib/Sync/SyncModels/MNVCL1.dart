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
class MNVCL1{
  int? ID;
  String? Code;
  int? RowId;
  String? CheckListCode;
  String? CheckListName;
  int? Days;
  String? TechnicianCode;
  String? TechnicianName;
  String? Unit;
  String? WorkCenterCode;
  String? WorkCenterName;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  MNVCL1({
    this.ID,
    this.Code,
    this.RowId,
    this.CheckListCode,
    this.CheckListName,
    this.Days,
    this.TechnicianCode,
    this.TechnicianName,
    this.Unit,
    this.WorkCenterCode,
    this.WorkCenterName,
    this.CreateDate,
    this.UpdateDate,
  });
  factory MNVCL1.fromJson(Map<String,dynamic> json)=>MNVCL1(
    ID : int.tryParse(json['ID'].toString())??0,
    Code : json['Code'],
    RowId : int.tryParse(json['RowId'].toString())??0,
    CheckListCode : json['CheckListCode'],
    CheckListName : json['CheckListName'],
    Days : int.tryParse(json['Days'].toString())??0,
    TechnicianCode : json['TechnicianCode'],
    TechnicianName : json['TechnicianName'],
    Unit : json['Unit'],
    WorkCenterCode : json['WorkCenterCode'],
    WorkCenterName : json['WorkCenterName'],
    CreateDate : DateTime.tryParse(json['CreateDate'].toString()),
    UpdateDate : DateTime.tryParse(json['UpdateDate'].toString()),
  );
  Map<String,dynamic> toJson()=>{
    'ID' : ID,
    'Code' : Code,
    'RowId' : RowId,
    'CheckListCode' : CheckListCode,
    'CheckListName' : CheckListName,
    'Days' : Days,
    'TechnicianCode' : TechnicianCode,
    'TechnicianName' : TechnicianName,
    'Unit' : Unit,
    'WorkCenterCode' : WorkCenterCode,
    'WorkCenterName' : WorkCenterName,
    'CreateDate' : CreateDate?.toIso8601String(),
    'UpdateDate' : UpdateDate?.toIso8601String(),
  };
}
List<MNVCL1> mNVCL1FromJson(String str) => List<MNVCL1>.from(
    json.decode(str).map((x) => MNVCL1.fromJson(x)));
String mNVCL1ToJson(List<MNVCL1> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
Future<List<MNVCL1>> dataSyncMNVCL1() async {
  var res = await http.get(headers: header, Uri.parse(prefix + "MNVCL1" + postfix));
  print(res.body);
  return mNVCL1FromJson(res.body);}
Future<void> insertMNVCL1(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteMNVCL1(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncMNVCL1();
  }
  print(customers);
  Stopwatch stopwatch = Stopwatch();
  stopwatch.start();
  for (var i = 0; i < customers.length; i += batchSize) {
    var end = (i + batchSize < customers.length) ? i + batchSize : customers.length;
    var batchRecords = customers.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (MNVCL1 record in batchRecords) {
        try {
          batch.insert('MNVCL1_Temp', record.toJson());
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
			select * from MNVCL1_Temp
			except
			select * from MNVCL1
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
          batch.update("MNVCL1", element,
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
  print('Time taken for MNVCL1 update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from MNVCL1_Temp where TransId not in (Select TransId from MNVCL1)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM MNVCL1_Temp T0
LEFT JOIN MNVCL1 T1 ON T0.TransId = T1.TransId 
WHERE T1.TransId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('MNVCL1', record);
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
      'Time taken for MNVCL1_Temp and MNVCL1 compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('MNVCL1_Temp');
}

Future<List<MNVCL1>> retrieveMNVCL1(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('MNVCL1');
  return queryResult.map((e) => MNVCL1.fromJson(e)).toList();
}
Future<void> updateMNVCL1(int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('MNVCL1', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    getErrorSnackBar('Sync Error ' + e.toString());}}
Future<void> deleteMNVCL1(Database db) async {
  await db.delete('MNVCL1');
}
Future<List<MNVCL1>> retrieveMNVCL1ById(BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('MNVCL1', where: str, whereArgs: l);
  return queryResult.map((e) => MNVCL1.fromJson(e)).toList();
}
Future<String> insertMNVCL1ToServer(BuildContext? context, {String? TransId, int? id}) async {
  String response = "";
  List<MNVCL1> list = await retrieveMNVCL1ById(context, TransId == null ? DataSync.getInsertToServerStr() : "TransId = ? AND ID = ?", TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "MNVCL1/Add"), headers: header, body: jsonEncode(list[0].toJson()));
    response = res.body;
  } else if (list.isNotEmpty) {
    int i = 0;
    bool sentSuccessInServer = false;
    do {
      sentSuccessInServer = false;
      try {
        Map<String, dynamic> map = list[i].toJson();
        map.remove('ID');
        var res = await http.post(Uri.parse(prefix + "MNVCL1/Add"), headers: header,
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
            var x = await db.update("MNVCL1", map, where: "TransId = ? AND RowId = ?", whereArgs: [map["TransId"], map["RowId"]]);
            print(x.toString());}}
        print(res.body);
      } catch (e) {
        print("Timeout " + e.toString());
        sentSuccessInServer = true;}
      print('i++;');
      print("INDEX = " + i.toString());
    } while (i < list.length && sentSuccessInServer == true);}
  return response;}
Future<void> updateMNVCL1OnServer(BuildContext? context, {String? condition, List? l}) async {
  List<MNVCL1> list = await retrieveMNVCL1ById(context, l == null ? DataSync.getUpdateOnServerStr() : condition ?? "", l == null ? DataSync.getUpdateOnServerList() : l);
  print(list);
  int i = 0;
  bool sentSuccessInServer = false;
  do {
    sentSuccessInServer = false;
    try {
      Map<String, dynamic> map = list[i].toJson();
      var res = await http.put(Uri.parse(prefix + 'MNVCL1/Update'), headers: header, body: jsonEncode(map)).timeout(Duration(seconds: 30), onTimeout: () {
        return http.Response('Error', 500);
      });
      print(await res.statusCode);
      if (res.statusCode == 201 || res.statusCode == 500) {
        sentSuccessInServer = true;
        if (res.statusCode == 201) {
          final Database db = await initializeDB(context);
          map["has_updated"] = 0;
          var x = await db.update("MNVCL1", map, where: "TransId = ? AND RowId = ?", whereArgs: [map["TransId"], map["RowId"]]);
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

