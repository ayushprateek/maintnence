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
class TROBTY{
  int? ID;
  String? Code;
  String? Name;
  String? ManufacturedBy;
  String? ManufacturedByName;
  double? Capacity;
  double? Voltage;
  String? Remarks;
  String? CreatedBy;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  String? BranchId;
  String? UpdatedBy;
  TROBTY({
    this.ID,
    this.Code,
    this.Name,
    this.ManufacturedBy,
    this.ManufacturedByName,
    this.Capacity,
    this.Voltage,
    this.Remarks,
    this.CreatedBy,
    this.CreateDate,
    this.UpdateDate,
    this.BranchId,
    this.UpdatedBy,
  });
  factory TROBTY.fromJson(Map<String,dynamic> json)=>TROBTY(
    ID : int.tryParse(json['ID'].toString())??0,
    Code : json['Code']?.toString() ?? '',
    Name : json['Name']?.toString() ?? '',
    ManufacturedBy : json['ManufacturedBy']?.toString() ?? '',
    ManufacturedByName : json['ManufacturedByName']?.toString() ?? '',
    Capacity : double.tryParse(json['Capacity'].toString())??0.0,
    Voltage : double.tryParse(json['Voltage'].toString())??0.0,
    Remarks : json['Remarks']?.toString() ?? '',
    CreatedBy : json['CreatedBy']?.toString() ?? '',
    CreateDate : DateTime.tryParse(json['CreateDate'].toString()),
    UpdateDate : DateTime.tryParse(json['UpdateDate'].toString()),
    BranchId : json['BranchId']?.toString() ?? '',
    UpdatedBy : json['UpdatedBy']?.toString() ?? '',
  );
  Map<String,dynamic> toJson()=>{
    'ID' : ID,
    'Code' : Code,
    'Name' : Name,
    'ManufacturedBy' : ManufacturedBy,
    'ManufacturedByName' : ManufacturedByName,
    'Capacity' : Capacity,
    'Voltage' : Voltage,
    'Remarks' : Remarks,
    'CreatedBy' : CreatedBy,
    'CreateDate' : CreateDate?.toIso8601String(),
    'UpdateDate' : UpdateDate?.toIso8601String(),
    'BranchId' : BranchId,
    'UpdatedBy' : UpdatedBy,
  };
}
List<TROBTY> tROBTYFromJson(String str) => List<TROBTY>.from(
    json.decode(str).map((x) => TROBTY.fromJson(x)));
String tROBTYToJson(List<TROBTY> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
Future<List<TROBTY>> dataSyncTROBTY() async {
  var res = await http.get(headers: header, Uri.parse(prefix + "TROBTY" + postfix));
  print(res.body);
  return tROBTYFromJson(res.body);}
Future<void> insertTROBTY(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteTROBTY(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncTROBTY();
  }
  print(customers);
  Stopwatch stopwatch = Stopwatch();
  stopwatch.start();
  for (var i = 0; i < customers.length; i += batchSize) {
    var end = (i + batchSize < customers.length) ? i + batchSize : customers.length;
    var batchRecords = customers.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (TROBTY record in batchRecords) {
        try {
          batch.insert('TROBTY_Temp', record.toJson());
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
			select * from TROBTY_Temp
			except
			select * from TROBTY
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
          batch.update("TROBTY", element,
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
  print('Time taken for TROBTY update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from TROBTY_Temp where TransId not in (Select TransId from TROBTY)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM TROBTY_Temp T0
LEFT JOIN TROBTY T1 ON T0.Code = T1.Code 
WHERE T1.Code IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('TROBTY', record);
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
      'Time taken for TROBTY_Temp and TROBTY compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('TROBTY_Temp');
}

Future<List<TROBTY>> retrieveTROBTY(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('TROBTY');
  return queryResult.map((e) => TROBTY.fromJson(e)).toList();
}
Future<void> updateTROBTY(int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('TROBTY', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    getErrorSnackBar('Sync Error ' + e.toString());}}
Future<void> deleteTROBTY(Database db) async {
  await db.delete('TROBTY');
}
Future<List<TROBTY>> retrieveTROBTYById(BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('TROBTY', where: str, whereArgs: l);
  return queryResult.map((e) => TROBTY.fromJson(e)).toList();
}
Future<String> insertTROBTYToServer(BuildContext? context, {String? TransId, int? id}) async {
  String response = "";
  List<TROBTY> list = await retrieveTROBTYById(context, TransId == null ? DataSync.getInsertToServerStr() : "TransId = ? AND ID = ?", TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "TROBTY/Add"), headers: header, body: jsonEncode(list[0].toJson()));
    response = res.body;
  } else if (list.isNotEmpty) {
    int i = 0;
    bool sentSuccessInServer = false;
    do {
      sentSuccessInServer = false;
      try {
        Map<String, dynamic> map = list[i].toJson();
        map.remove('ID');
        var res = await http.post(Uri.parse(prefix + "TROBTY/Add"), headers: header,
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
            var x = await db.update("TROBTY", map, where: "Code = ?", whereArgs: [map["Code"]]);
            print(x.toString());}}
        print(res.body);
      } catch (e) {
        print("Timeout " + e.toString());
        sentSuccessInServer = true;}
      i++;
      print("INDEX = " + i.toString());
    } while (i < list.length && sentSuccessInServer == true);}
  return response;}
Future<void> updateTROBTYOnServer(BuildContext? context, {String? condition, List? l}) async {
  List<TROBTY> list = await retrieveTROBTYById(context, l == null ? DataSync.getUpdateOnServerStr() : condition ?? "", l == null ? DataSync.getUpdateOnServerList() : l);
  print(list);
  int i = 0;
  bool sentSuccessInServer = false;
  do {
    sentSuccessInServer = false;
    try {
      Map<String, dynamic> map = list[i].toJson();
      var res = await http.put(Uri.parse(prefix + 'TROBTY/Update'), headers: header, body: jsonEncode(map)).timeout(Duration(seconds: 30), onTimeout: () {
        return http.Response('Error', 500);
      });
      print(await res.statusCode);
      if (res.statusCode == 201 || res.statusCode == 500) {
        sentSuccessInServer = true;
        if (res.statusCode == 201) {
          final Database db = await initializeDB(context);
          map["has_updated"] = 0;
          var x = await db.update("TROBTY", map, where: "Code = ?", whereArgs: [map["Code"]]);
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

