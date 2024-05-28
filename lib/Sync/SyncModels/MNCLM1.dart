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
class MNCLM1{
  int? ID;
  String? Code;
  int? RowId;
  String? ItemCode;
  String? ItemName;
  String? CheckListDesc;
  String? Remarks;
  double? Quantity;
  String? UOM;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  MNCLM1({
    this.ID,
    this.Code,
    this.RowId,
    this.ItemCode,
    this.ItemName,
    this.CheckListDesc,
    this.Remarks,
    this.Quantity,
    this.UOM,
    this.CreateDate,
    this.UpdateDate,
  });
  factory MNCLM1.fromJson(Map<String,dynamic> json)=>MNCLM1(
    ID : int.tryParse(json['ID'].toString())??0,
    Code : json['Code'],
    RowId : int.tryParse(json['RowId'].toString())??0,
    ItemCode : json['ItemCode'],
    ItemName : json['ItemName'],
    CheckListDesc : json['CheckListDesc'],
    Remarks : json['Remarks'],
    Quantity : double.tryParse(json['Quantity'].toString())??0.0,
    UOM : json['UOM'],
    CreateDate : DateTime.tryParse(json['CreateDate'].toString()),
    UpdateDate : DateTime.tryParse(json['UpdateDate'].toString()),
  );
  Map<String,dynamic> toJson()=>{
    'ID' : ID,
    'Code' : Code,
    'RowId' : RowId,
    'ItemCode' : ItemCode,
    'ItemName' : ItemName,
    'CheckListDesc' : CheckListDesc,
    'Remarks' : Remarks,
    'Quantity' : Quantity,
    'UOM' : UOM,
    'CreateDate' : CreateDate?.toIso8601String(),
    'UpdateDate' : UpdateDate?.toIso8601String(),
  };
}
List<MNCLM1> mNCLM1FromJson(String str) => List<MNCLM1>.from(
    json.decode(str).map((x) => MNCLM1.fromJson(x)));
String mNCLM1ToJson(List<MNCLM1> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
Future<List<MNCLM1>> dataSyncMNCLM1() async {
  var res = await http.get(headers: header, Uri.parse(prefix + "MNCLM1" + postfix));
  print(res.body);
  return mNCLM1FromJson(res.body);}
Future<void> insertMNCLM1(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteMNCLM1(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncMNCLM1();
  }
  print(customers);
  Stopwatch stopwatch = Stopwatch();
  stopwatch.start();
  for (var i = 0; i < customers.length; i += batchSize) {
    var end = (i + batchSize < customers.length) ? i + batchSize : customers.length;
    var batchRecords = customers.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (MNCLM1 record in batchRecords) {
        try {
          batch.insert('MNCLM1_Temp', record.toJson());
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
			select * from MNCLM1_Temp
			except
			select * from MNCLM1
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
          batch.update("MNCLM1", element,
              where: "Code = ? AND RowId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
              whereArgs: [element["Code"],element["RowId"], 1, 1]);

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
  print('Time taken for MNCLM1 update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from MNCLM1_Temp where TransId not in (Select TransId from MNCLM1)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM MNCLM1_Temp T0
LEFT JOIN MNCLM1 T1 ON T0.Code = T1.Code AND T0.RowId = T1.RowId  
WHERE T1.Code IS NULL AND T1.RowId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('MNCLM1', record);
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
      'Time taken for MNCLM1_Temp and MNCLM1 compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('MNCLM1_Temp');
}

Future<List<MNCLM1>> retrieveMNCLM1(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('MNCLM1');
  return queryResult.map((e) => MNCLM1.fromJson(e)).toList();
}
Future<void> updateMNCLM1(int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('MNCLM1', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    getErrorSnackBar('Sync Error ' + e.toString());}}
Future<void> deleteMNCLM1(Database db) async {
  await db.delete('MNCLM1');
}
Future<List<MNCLM1>> retrieveMNCLM1ById(BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('MNCLM1', where: str, whereArgs: l);
  return queryResult.map((e) => MNCLM1.fromJson(e)).toList();
}
Future<String> insertMNCLM1ToServer(BuildContext? context, {String? TransId, int? id}) async {
  String response = "";
  List<MNCLM1> list = await retrieveMNCLM1ById(context, TransId == null ? DataSync.getInsertToServerStr() : "TransId = ? AND ID = ?", TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "MNCLM1/Add"), headers: header, body: jsonEncode(list[0].toJson()));
    response = res.body;
  } else if (list.isNotEmpty) {
    int i = 0;
    bool sentSuccessInServer = false;
    do {
      sentSuccessInServer = false;
      try {
        Map<String, dynamic> map = list[i].toJson();
        map.remove('ID');
        var res = await http.post(Uri.parse(prefix + "MNCLM1/Add"), headers: header,
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
            var x = await db.update("MNCLM1", map, where: "Code = ? AND RowId = ?", whereArgs: [map["Code"], map["RowId"]]);
            print(x.toString());}}
        print(res.body);
      } catch (e) {
        print("Timeout " + e.toString());
        sentSuccessInServer = true;}
      i++;
      print("INDEX = " + i.toString());
    } while (i < list.length && sentSuccessInServer == true);}
  return response;}
Future<void> updateMNCLM1OnServer(BuildContext? context, {String? condition, List? l}) async {
  List<MNCLM1> list = await retrieveMNCLM1ById(context, l == null ? DataSync.getUpdateOnServerStr() : condition ?? "", l == null ? DataSync.getUpdateOnServerList() : l);
  print(list);
  int i = 0;
  bool sentSuccessInServer = false;
  do {
    sentSuccessInServer = false;
    try {
      Map<String, dynamic> map = list[i].toJson();
      var res = await http.put(Uri.parse(prefix + 'MNCLM1/Update'), headers: header, body: jsonEncode(map)).timeout(Duration(seconds: 30), onTimeout: () {
        return http.Response('Error', 500);
      });
      print(await res.statusCode);
      if (res.statusCode == 201 || res.statusCode == 500) {
        sentSuccessInServer = true;
        if (res.statusCode == 201) {
          final Database db = await initializeDB(context);
          map["has_updated"] = 0;
          var x = await db.update("MNCLM1", map, where: "Code = ? AND RowId = ?", whereArgs: [map["Code"], map["RowId"]]);
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

