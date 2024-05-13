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
class MNOEQG{
  int? ID;
  String? Code;
  String? Name;
  String? Remarks;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  String? CreatedBy;
  String? UpdatedBy;
  String? BranchId;
  bool? Active;
  MNOEQG({
    this.ID,
    this.Code,
    this.Name,
    this.Remarks,
    this.CreateDate,
    this.UpdateDate,
    this.CreatedBy,
    this.UpdatedBy,
    this.BranchId,
    this.Active,
  });
  factory MNOEQG.fromJson(Map<String,dynamic> json)=>MNOEQG(
    ID : int.tryParse(json['ID'].toString())??0,
    Code : json['Code']?.toString() ?? '',
    Name : json['Name']?.toString() ?? '',
    Remarks : json['Remarks']?.toString() ?? '',
    CreateDate : DateTime.tryParse(json['CreateDate'].toString()),
    UpdateDate : DateTime.tryParse(json['UpdateDate'].toString()),
    CreatedBy : json['CreatedBy']?.toString() ?? '',
    UpdatedBy : json['UpdatedBy']?.toString() ?? '',
    BranchId : json['BranchId']?.toString() ?? '',
    Active : json['Active'] is bool ? json['Active'] : json['Active']==1,
  );
  Map<String,dynamic> toJson()=>{
    'ID' : ID,
    'Code' : Code,
    'Name' : Name,
    'Remarks' : Remarks,
    'CreateDate' : CreateDate?.toIso8601String(),
    'UpdateDate' : UpdateDate?.toIso8601String(),
    'CreatedBy' : CreatedBy,
    'UpdatedBy' : UpdatedBy,
    'BranchId' : BranchId,
    'Active' : Active,
  };
}
List<MNOEQG> mNOEQGFromJson(String str) => List<MNOEQG>.from(
    json.decode(str).map((x) => MNOEQG.fromJson(x)));
String mNOEQGToJson(List<MNOEQG> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
Future<List<MNOEQG>> dataSyncMNOEQG() async {
  var res = await http.get(headers: header, Uri.parse(prefix + "MNOEQG" + postfix));
  print(res.body);
  return mNOEQGFromJson(res.body);}
Future<void> insertMNOEQG(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteMNOEQG(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncMNOEQG();
  }
  print(customers);
  Stopwatch stopwatch = Stopwatch();
  stopwatch.start();
  for (var i = 0; i < customers.length; i += batchSize) {
    var end = (i + batchSize < customers.length) ? i + batchSize : customers.length;
    var batchRecords = customers.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (MNOEQG record in batchRecords) {
        try {
          batch.insert('MNOEQG_Temp', record.toJson());
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
			select * from MNOEQG_Temp
			except
			select * from MNOEQG
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
          batch.update("MNOEQG", element,
              where: "Code = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
              whereArgs: [element["Code"], 1, 1]);

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
  print('Time taken for MNOEQG update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from MNOEQG_Temp where TransId not in (Select TransId from MNOEQG)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM MNOEQG_Temp T0
LEFT JOIN MNOEQG T1 ON T0.Code = T1.Code 
WHERE T1.Code IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('MNOEQG', record);
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
      'Time taken for MNOEQG_Temp and MNOEQG compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('MNOEQG_Temp');
}

Future<List<MNOEQG>> retrieveMNOEQG(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('MNOEQG');
  return queryResult.map((e) => MNOEQG.fromJson(e)).toList();
}
Future<void> updateMNOEQG(int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('MNOEQG', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    getErrorSnackBar('Sync Error ' + e.toString());}}
Future<void> deleteMNOEQG(Database db) async {
  await db.delete('MNOEQG');
}
Future<List<MNOEQG>> retrieveMNOEQGById(BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('MNOEQG', where: str, whereArgs: l);
  return queryResult.map((e) => MNOEQG.fromJson(e)).toList();
}
Future<String> insertMNOEQGToServer(BuildContext? context, {String? TransId, int? id}) async {
  String response = "";
  List<MNOEQG> list = await retrieveMNOEQGById(context, TransId == null ? DataSync.getInsertToServerStr() : "TransId = ? AND ID = ?", TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "MNOEQG/Add"), headers: header, body: jsonEncode(list[0].toJson()));
    response = res.body;
  } else if (list.isNotEmpty) {
    int i = 0;
    bool sentSuccessInServer = false;
    do {
      sentSuccessInServer = false;
      try {
        Map<String, dynamic> map = list[i].toJson();
        map.remove('ID');
        var res = await http.post(Uri.parse(prefix + "MNOEQG/Add"), headers: header,
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
            var x = await db.update("MNOEQG", map, where: "Code = ?", whereArgs: [map["Code"]]);
            print(x.toString());}}
        print(res.body);
      } catch (e) {
        print("Timeout " + e.toString());
        sentSuccessInServer = true;}
      print('i++;');
      print("INDEX = " + i.toString());
    } while (i < list.length && sentSuccessInServer == true);}
  return response;}
Future<void> updateMNOEQGOnServer(BuildContext? context, {String? condition, List? l}) async {
  List<MNOEQG> list = await retrieveMNOEQGById(context, l == null ? DataSync.getUpdateOnServerStr() : condition ?? "", l == null ? DataSync.getUpdateOnServerList() : l);
  print(list);
  int i = 0;
  bool sentSuccessInServer = false;
  do {
    sentSuccessInServer = false;
    try {
      Map<String, dynamic> map = list[i].toJson();
      var res = await http.put(Uri.parse(prefix + 'MNOEQG/Update'), headers: header, body: jsonEncode(map)).timeout(Duration(seconds: 30), onTimeout: () {
        return http.Response('Error', 500);
      });
      print(await res.statusCode);
      if (res.statusCode == 201 || res.statusCode == 500) {
        sentSuccessInServer = true;
        if (res.statusCode == 201) {
          final Database db = await initializeDB(context);
          map["has_updated"] = 0;
          var x = await db.update("MNOEQG", map, where: "Code = ?", whereArgs: [map["Code"]]);
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

