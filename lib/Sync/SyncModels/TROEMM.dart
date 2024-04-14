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
class TROEMM{
  int? ID;
  String? Code;
  String? Name;
  double? FuelCapacity;
  double? FrontAxleWeight;
  double? RearAxleWeight;
  double? LoadingCapacity;
  int? XAxles;
  int? YTyres;
  int? NoOfTyres;
  String? BatteryCode;
  String? BatteryName;
  String? Attachment;
  bool? Active;
  String? ManufacturedBy;
  String? ManufacturedByName;
  String? Remarks;
  String? CreatedBy;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  String? BranchId;
  String? UpdatedBy;
  TROEMM({
    this.ID,
    this.Code,
    this.Name,
    this.FuelCapacity,
    this.FrontAxleWeight,
    this.RearAxleWeight,
    this.LoadingCapacity,
    this.XAxles,
    this.YTyres,
    this.NoOfTyres,
    this.BatteryCode,
    this.BatteryName,
    this.Attachment,
    this.Active,
    this.ManufacturedBy,
    this.ManufacturedByName,
    this.Remarks,
    this.CreatedBy,
    this.CreateDate,
    this.UpdateDate,
    this.BranchId,
    this.UpdatedBy,
  });
  factory TROEMM.fromJson(Map<String,dynamic> json)=>TROEMM(
    ID : int.tryParse(json['ID'].toString())??0,
    Code : json['Code'],
    Name : json['Name'],
    FuelCapacity : double.tryParse(json['FuelCapacity'].toString())??0.0,
    FrontAxleWeight : double.tryParse(json['FrontAxleWeight'].toString())??0.0,
    RearAxleWeight : double.tryParse(json['RearAxleWeight'].toString())??0.0,
    LoadingCapacity : double.tryParse(json['LoadingCapacity'].toString())??0.0,
    XAxles : int.tryParse(json['XAxles'].toString())??0,
    YTyres : int.tryParse(json['YTyres'].toString())??0,
    NoOfTyres : int.tryParse(json['NoOfTyres'].toString())??0,
    BatteryCode : json['BatteryCode'],
    BatteryName : json['BatteryName'],
    Attachment : json['Attachment'],
    Active : json['Active'] is bool ? json['Active'] : json['Active']==1,
    ManufacturedBy : json['ManufacturedBy'],
    ManufacturedByName : json['ManufacturedByName'],
    Remarks : json['Remarks'],
    CreatedBy : json['CreatedBy'],
    CreateDate : DateTime.tryParse(json['CreateDate'].toString()),
    UpdateDate : DateTime.tryParse(json['UpdateDate'].toString()),
    BranchId : json['BranchId'],
    UpdatedBy : json['UpdatedBy'],
  );
  Map<String,dynamic> toJson()=>{
    'ID' : ID,
    'Code' : Code,
    'Name' : Name,
    'FuelCapacity' : FuelCapacity,
    'FrontAxleWeight' : FrontAxleWeight,
    'RearAxleWeight' : RearAxleWeight,
    'LoadingCapacity' : LoadingCapacity,
    'XAxles' : XAxles,
    'YTyres' : YTyres,
    'NoOfTyres' : NoOfTyres,
    'BatteryCode' : BatteryCode,
    'BatteryName' : BatteryName,
    'Attachment' : Attachment,
    'Active' : Active,
    'ManufacturedBy' : ManufacturedBy,
    'ManufacturedByName' : ManufacturedByName,
    'Remarks' : Remarks,
    'CreatedBy' : CreatedBy,
    'CreateDate' : CreateDate?.toIso8601String(),
    'UpdateDate' : UpdateDate?.toIso8601String(),
    'BranchId' : BranchId,
    'UpdatedBy' : UpdatedBy,
  };
}
List<TROEMM> tROEMMFromJson(String str) => List<TROEMM>.from(
    json.decode(str).map((x) => TROEMM.fromJson(x)));
String tROEMMToJson(List<TROEMM> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
Future<List<TROEMM>> dataSyncTROEMM() async {
  var res = await http.get(headers: header, Uri.parse(prefix + "TROEMM" + postfix));
  print(res.body);
  return tROEMMFromJson(res.body);}
Future<void> insertTROEMM(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteTROEMM(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncTROEMM();
  }
  print(customers);
  Stopwatch stopwatch = Stopwatch();
  stopwatch.start();
  for (var i = 0; i < customers.length; i += batchSize) {
    var end = (i + batchSize < customers.length) ? i + batchSize : customers.length;
    var batchRecords = customers.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (TROEMM record in batchRecords) {
        try {
          batch.insert('TROEMM_Temp', record.toJson());
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
			select * from TROEMM_Temp
			except
			select * from TROEMM
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
          batch.update("TROEMM", element,
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
  print('Time taken for TROEMM update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from TROEMM_Temp where TransId not in (Select TransId from TROEMM)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM TROEMM_Temp T0
LEFT JOIN TROEMM T1 ON T0.TransId = T1.TransId 
WHERE T1.TransId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('TROEMM', record);
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
      'Time taken for TROEMM_Temp and TROEMM compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('TROEMM_Temp');
}

Future<List<TROEMM>> retrieveTROEMM(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('TROEMM');
  return queryResult.map((e) => TROEMM.fromJson(e)).toList();
}
Future<void> updateTROEMM(int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('TROEMM', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    getErrorSnackBar('Sync Error ' + e.toString());}}
Future<void> deleteTROEMM(Database db) async {
  await db.delete('TROEMM');
}
Future<List<TROEMM>> retrieveTROEMMById(BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('TROEMM', where: str, whereArgs: l);
  return queryResult.map((e) => TROEMM.fromJson(e)).toList();
}
Future<String> insertTROEMMToServer(BuildContext? context, {String? TransId, int? id}) async {
  String response = "";
  List<TROEMM> list = await retrieveTROEMMById(context, TransId == null ? DataSync.getInsertToServerStr() : "TransId = ? AND ID = ?", TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "TROEMM/Add"), headers: header, body: jsonEncode(list[0].toJson()));
    response = res.body;
  } else if (list.isNotEmpty) {
    int i = 0;
    bool sentSuccessInServer = false;
    do {
      sentSuccessInServer = false;
      try {
        Map<String, dynamic> map = list[i].toJson();
        map.remove('ID');
        var res = await http.post(Uri.parse(prefix + "TROEMM/Add"), headers: header,
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
            var x = await db.update("TROEMM", map, where: "TransId = ? AND RowId = ?", whereArgs: [map["TransId"], map["RowId"]]);
            print(x.toString());}}
        print(res.body);
      } catch (e) {
        print("Timeout " + e.toString());
        sentSuccessInServer = true;}
      print('i++;');
      print("INDEX = " + i.toString());
    } while (i < list.length && sentSuccessInServer == true);}
  return response;}
Future<void> updateTROEMMOnServer(BuildContext? context, {String? condition, List? l}) async {
  List<TROEMM> list = await retrieveTROEMMById(context, l == null ? DataSync.getUpdateOnServerStr() : condition ?? "", l == null ? DataSync.getUpdateOnServerList() : l);
  print(list);
  int i = 0;
  bool sentSuccessInServer = false;
  do {
    sentSuccessInServer = false;
    try {
      Map<String, dynamic> map = list[i].toJson();
      var res = await http.put(Uri.parse(prefix + 'TROEMM/Update'), headers: header, body: jsonEncode(map)).timeout(Duration(seconds: 30), onTimeout: () {
        return http.Response('Error', 500);
      });
      print(await res.statusCode);
      if (res.statusCode == 201 || res.statusCode == 500) {
        sentSuccessInServer = true;
        if (res.statusCode == 201) {
          final Database db = await initializeDB(context);
          map["has_updated"] = 0;
          var x = await db.update("TROEMM", map, where: "TransId = ? AND RowId = ?", whereArgs: [map["TransId"], map["RowId"]]);
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

