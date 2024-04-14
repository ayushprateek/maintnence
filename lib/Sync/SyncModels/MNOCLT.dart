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
class MNOCLT{
  int? ID;
  String? Code;
  String? Name;
  String? Unit;
  String? UnitValue;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  String? CreatedBy;
  String? UpdatedBy;
  String? BranchId;
  bool? Active;
  int? MediumPriorityDays;
  int? HighPriorityDays;
  String? CheckType;
  MNOCLT({
    this.ID,
    this.Code,
    this.Name,
    this.Unit,
    this.UnitValue,
    this.CreateDate,
    this.UpdateDate,
    this.CreatedBy,
    this.UpdatedBy,
    this.BranchId,
    this.Active,
    this.MediumPriorityDays,
    this.HighPriorityDays,
    this.CheckType,
  });
  factory MNOCLT.fromJson(Map<String,dynamic> json)=>MNOCLT(
    ID : int.tryParse(json['ID'].toString())??0,
    Code : json['Code'],
    Name : json['Name'],
    Unit : json['Unit'],
    UnitValue : json['UnitValue'],
    CreateDate : DateTime.tryParse(json['CreateDate'].toString()),
    UpdateDate : DateTime.tryParse(json['UpdateDate'].toString()),
    CreatedBy : json['CreatedBy'],
    UpdatedBy : json['UpdatedBy'],
    BranchId : json['BranchId'],
    Active : json['Active'] is bool ? json['Active'] : json['Active']==1,
    MediumPriorityDays : int.tryParse(json['MediumPriorityDays'].toString())??0,
    HighPriorityDays : int.tryParse(json['HighPriorityDays'].toString())??0,
    CheckType : json['CheckType'],
  );
  Map<String,dynamic> toJson()=>{
    'ID' : ID,
    'Code' : Code,
    'Name' : Name,
    'Unit' : Unit,
    'UnitValue' : UnitValue,
    'CreateDate' : CreateDate?.toIso8601String(),
    'UpdateDate' : UpdateDate?.toIso8601String(),
    'CreatedBy' : CreatedBy,
    'UpdatedBy' : UpdatedBy,
    'BranchId' : BranchId,
    'Active' : Active,
    'MediumPriorityDays' : MediumPriorityDays,
    'HighPriorityDays' : HighPriorityDays,
    'CheckType' : CheckType,
  };
}
List<MNOCLT> mNOCLTFromJson(String str) => List<MNOCLT>.from(
    json.decode(str).map((x) => MNOCLT.fromJson(x)));
String mNOCLTToJson(List<MNOCLT> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
Future<List<MNOCLT>> dataSyncMNOCLT() async {
  var res = await http.get(headers: header, Uri.parse(prefix + "MNOCLT" + postfix));
  print(res.body);
  return mNOCLTFromJson(res.body);}
Future<void> insertMNOCLT(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteMNOCLT(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncMNOCLT();
  }
  print(customers);
  Stopwatch stopwatch = Stopwatch();
  stopwatch.start();
  for (var i = 0; i < customers.length; i += batchSize) {
    var end = (i + batchSize < customers.length) ? i + batchSize : customers.length;
    var batchRecords = customers.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (MNOCLT record in batchRecords) {
        try {
          batch.insert('MNOCLT_Temp', record.toJson());
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
			select * from MNOCLT_Temp
			except
			select * from MNOCLT
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
          batch.update("MNOCLT", element,
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
  print('Time taken for MNOCLT update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from MNOCLT_Temp where TransId not in (Select TransId from MNOCLT)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM MNOCLT_Temp T0
LEFT JOIN MNOCLT T1 ON T0.TransId = T1.TransId 
WHERE T1.TransId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('MNOCLT', record);
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
      'Time taken for MNOCLT_Temp and MNOCLT compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('MNOCLT_Temp');
}

Future<List<MNOCLT>> retrieveMNOCLT(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('MNOCLT');
  return queryResult.map((e) => MNOCLT.fromJson(e)).toList();
}
Future<void> updateMNOCLT(int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('MNOCLT', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    getErrorSnackBar('Sync Error ' + e.toString());}}
Future<void> deleteMNOCLT(Database db) async {
  await db.delete('MNOCLT');
}
Future<List<MNOCLT>> retrieveMNOCLTById(BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('MNOCLT', where: str, whereArgs: l);
  return queryResult.map((e) => MNOCLT.fromJson(e)).toList();
}
Future<String> insertMNOCLTToServer(BuildContext? context, {String? TransId, int? id}) async {
  String response = "";
  List<MNOCLT> list = await retrieveMNOCLTById(context, TransId == null ? DataSync.getInsertToServerStr() : "TransId = ? AND ID = ?", TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "MNOCLT/Add"), headers: header, body: jsonEncode(list[0].toJson()));
    response = res.body;
  } else if (list.isNotEmpty) {
    int i = 0;
    bool sentSuccessInServer = false;
    do {
      sentSuccessInServer = false;
      try {
        Map<String, dynamic> map = list[i].toJson();
        map.remove('ID');
        var res = await http.post(Uri.parse(prefix + "MNOCLT/Add"), headers: header,
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
            var x = await db.update("MNOCLT", map, where: "TransId = ? AND RowId = ?", whereArgs: [map["TransId"], map["RowId"]]);
            print(x.toString());}}
        print(res.body);
      } catch (e) {
        print("Timeout " + e.toString());
        sentSuccessInServer = true;}
      print('i++;');
      print("INDEX = " + i.toString());
    } while (i < list.length && sentSuccessInServer == true);}
  return response;}
Future<void> updateMNOCLTOnServer(BuildContext? context, {String? condition, List? l}) async {
  List<MNOCLT> list = await retrieveMNOCLTById(context, l == null ? DataSync.getUpdateOnServerStr() : condition ?? "", l == null ? DataSync.getUpdateOnServerList() : l);
  print(list);
  int i = 0;
  bool sentSuccessInServer = false;
  do {
    sentSuccessInServer = false;
    try {
      Map<String, dynamic> map = list[i].toJson();
      var res = await http.put(Uri.parse(prefix + 'MNOCLT/Update'), headers: header, body: jsonEncode(map)).timeout(Duration(seconds: 30), onTimeout: () {
        return http.Response('Error', 500);
      });
      print(await res.statusCode);
      if (res.statusCode == 201 || res.statusCode == 500) {
        sentSuccessInServer = true;
        if (res.statusCode == 201) {
          final Database db = await initializeDB(context);
          map["has_updated"] = 0;
          var x = await db.update("MNOCLT", map, where: "TransId = ? AND RowId = ?", whereArgs: [map["TransId"], map["RowId"]]);
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

