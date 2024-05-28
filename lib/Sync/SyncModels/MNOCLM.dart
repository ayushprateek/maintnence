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
class MNOCLM{
  int? ID;
  String? Code;
  String? Remarks;
  String? ObjectCode;
  String? EquipmentGroupCode;
  String? EquipmentGroupName;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  String? CreatedBy;
  String? UpdatedBy;
  String? BranchId;
  bool? Active;
  String? CheckListName;
  String? CheckListCode;
  String? Name;
  MNOCLM({
    this.ID,
    this.Code,
    this.Remarks,
    this.ObjectCode,
    this.EquipmentGroupCode,
    this.EquipmentGroupName,
    this.CreateDate,
    this.UpdateDate,
    this.CreatedBy,
    this.UpdatedBy,
    this.BranchId,
    this.Active,
    this.CheckListName,
    this.CheckListCode,
    this.Name,
  });
  factory MNOCLM.fromJson(Map<String,dynamic> json)=>MNOCLM(
    ID : int.tryParse(json['ID'].toString())??0,
    Code : json['Code'],
    Remarks : json['Remarks'],
    ObjectCode : json['ObjectCode'],
    EquipmentGroupCode : json['EquipmentGroupCode'],
    EquipmentGroupName : json['EquipmentGroupName'],
    CreateDate : DateTime.tryParse(json['CreateDate'].toString()),
    UpdateDate : DateTime.tryParse(json['UpdateDate'].toString()),
    CreatedBy : json['CreatedBy'],
    UpdatedBy : json['UpdatedBy'],
    BranchId : json['BranchId'],
    Active : json['Active'] is bool ? json['Active'] : json['Active']==1,
    CheckListName : json['CheckListName'],
    CheckListCode : json['CheckListCode'],
    Name : json['Name'],
  );
  Map<String,dynamic> toJson()=>{
    'ID' : ID,
    'Code' : Code,
    'Remarks' : Remarks,
    'ObjectCode' : ObjectCode,
    'EquipmentGroupCode' : EquipmentGroupCode,
    'EquipmentGroupName' : EquipmentGroupName,
    'CreateDate' : CreateDate?.toIso8601String(),
    'UpdateDate' : UpdateDate?.toIso8601String(),
    'CreatedBy' : CreatedBy,
    'UpdatedBy' : UpdatedBy,
    'BranchId' : BranchId,
    'Active' : Active,
    'CheckListName' : CheckListName,
    'CheckListCode' : CheckListCode,
    'Name' : Name,
  };
}
List<MNOCLM> mNOCLMFromJson(String str) => List<MNOCLM>.from(
    json.decode(str).map((x) => MNOCLM.fromJson(x)));
String mNOCLMToJson(List<MNOCLM> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
Future<List<MNOCLM>> dataSyncMNOCLM() async {
  var res = await http.get(headers: header, Uri.parse(prefix + "MNOCLM" + postfix));
  print(res.body);
  return mNOCLMFromJson(res.body);}
Future<void> insertMNOCLM(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteMNOCLM(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncMNOCLM();
  }
  print(customers);
  Stopwatch stopwatch = Stopwatch();
  stopwatch.start();
  for (var i = 0; i < customers.length; i += batchSize) {
    var end = (i + batchSize < customers.length) ? i + batchSize : customers.length;
    var batchRecords = customers.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (MNOCLM record in batchRecords) {
        try {
          batch.insert('MNOCLM_Temp', record.toJson());
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
			select * from MNOCLM_Temp
			except
			select * from MNOCLM
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
          batch.update("MNOCLM", element,
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
  print('Time taken for MNOCLM update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from MNOCLM_Temp where TransId not in (Select TransId from MNOCLM)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM MNOCLM_Temp T0
LEFT JOIN MNOCLM T1 ON T0.Code = T1.Code 
WHERE T1.Code IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('MNOCLM', record);
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
      'Time taken for MNOCLM_Temp and MNOCLM compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('MNOCLM_Temp');
}

Future<List<MNOCLM>> retrieveMNOCLM(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('MNOCLM');
  return queryResult.map((e) => MNOCLM.fromJson(e)).toList();
}
Future<void> updateMNOCLM(int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('MNOCLM', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    getErrorSnackBar('Sync Error ' + e.toString());}}
Future<void> deleteMNOCLM(Database db) async {
  await db.delete('MNOCLM');
}
Future<List<MNOCLM>> retrieveMNOCLMById(BuildContext? context, String str, List l,{
  int? limit
}) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('MNOCLM', where: str, whereArgs: l,limit: limit);
  return queryResult.map((e) => MNOCLM.fromJson(e)).toList();
}
Future<List<MNOCLM>> retrieveMNOCLMForSearch({
  int? limit,
  String? query,
}) async {
  query="%$query%";
  final Database db = await initializeDB(null);
  final List<Map<String, Object?>> queryResult = await db.rawQuery('SELECT * FROM MNOCLM WHERE Code LIKE "$query" OR Name LIKE "$query" LIMIT $limit');
  return queryResult.map((e) => MNOCLM.fromJson(e)).toList();
}
Future<String> insertMNOCLMToServer(BuildContext? context, {String? TransId, int? id}) async {
  String response = "";
  List<MNOCLM> list = await retrieveMNOCLMById(context, TransId == null ? DataSync.getInsertToServerStr() : "TransId = ? AND ID = ?", TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "MNOCLM/Add"), headers: header, body: jsonEncode(list[0].toJson()));
    response = res.body;
  } else if (list.isNotEmpty) {
    int i = 0;
    bool sentSuccessInServer = false;
    do {
      sentSuccessInServer = false;
      try {
        Map<String, dynamic> map = list[i].toJson();
        map.remove('ID');
        var res = await http.post(Uri.parse(prefix + "MNOCLM/Add"), headers: header,
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
            var x = await db.update("MNOCLM", map, where: "Code = ?", whereArgs: [map["Code"]]);
            print(x.toString());}}
        print(res.body);
      } catch (e) {
        print("Timeout " + e.toString());
        sentSuccessInServer = true;}
      i++;
      print("INDEX = " + i.toString());
    } while (i < list.length && sentSuccessInServer == true);}
  return response;}
Future<void> updateMNOCLMOnServer(BuildContext? context, {String? condition, List? l}) async {
  List<MNOCLM> list = await retrieveMNOCLMById(context, l == null ? DataSync.getUpdateOnServerStr() : condition ?? "", l == null ? DataSync.getUpdateOnServerList() : l);
  print(list);
  int i = 0;
  bool sentSuccessInServer = false;
  do {
    sentSuccessInServer = false;
    try {
      Map<String, dynamic> map = list[i].toJson();
      var res = await http.put(Uri.parse(prefix + 'MNOCLM/Update'), headers: header, body: jsonEncode(map)).timeout(Duration(seconds: 30), onTimeout: () {
        return http.Response('Error', 500);
      });
      print(await res.statusCode);
      if (res.statusCode == 201 || res.statusCode == 500) {
        sentSuccessInServer = true;
        if (res.statusCode == 201) {
          final Database db = await initializeDB(context);
          map["has_updated"] = 0;
          var x = await db.update("MNOCLM", map, where: "Code = ?", whereArgs: [map["Code"]]);
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

