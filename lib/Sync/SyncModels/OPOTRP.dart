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
class OPOTRP{
  int? ID;
  String? TransId;
  String? RouteCode;
  String? RouteName;
  String? DocStatus;
  int? DocEntry;
  String? DocNum;
  String? CreatedBy;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  String? ApprovalStatus;
  String? WhsCode;
  bool? IsPosted;
  String? Error;
  String? Latitude;
  String? Longitude;
  String? Remarks;
  String? ObjectCode;
  String? BranchId;
  String? UpdatedBy;
  String? PermanentTransId;
  String? DeptCode;
  String? DeptName;
  OPOTRP({
    this.ID,
    this.TransId,
    this.RouteCode,
    this.RouteName,
    this.DocStatus,
    this.DocEntry,
    this.DocNum,
    this.CreatedBy,
    this.CreateDate,
    this.UpdateDate,
    this.ApprovalStatus,
    this.WhsCode,
    this.IsPosted,
    this.Error,
    this.Latitude,
    this.Longitude,
    this.Remarks,
    this.ObjectCode,
    this.BranchId,
    this.UpdatedBy,
    this.PermanentTransId,
    this.DeptCode,
    this.DeptName,
  });
  factory OPOTRP.fromJson(Map<String,dynamic> json)=>OPOTRP(
    ID : int.tryParse(json['ID'].toString())??0,
    TransId : json['TransId']?.toString() ?? '',
    RouteCode : json['RouteCode']?.toString() ?? '',
    RouteName : json['RouteName']?.toString() ?? '',
    DocStatus : json['DocStatus']?.toString() ?? '',
    DocEntry : int.tryParse(json['DocEntry'].toString())??0,
    DocNum : json['DocNum']?.toString() ?? '',
    CreatedBy : json['CreatedBy']?.toString() ?? '',
    CreateDate : DateTime.tryParse(json['CreateDate'].toString()),
    UpdateDate : DateTime.tryParse(json['UpdateDate'].toString()),
    ApprovalStatus : json['ApprovalStatus']?.toString() ?? '',
    WhsCode : json['WhsCode']?.toString() ?? '',
    IsPosted : json['IsPosted'] is bool ? json['IsPosted'] : json['IsPosted']==1,
    Error : json['Error']?.toString() ?? '',
    Latitude : json['Latitude']?.toString() ?? '',
    Longitude : json['Longitude']?.toString() ?? '',
    Remarks : json['Remarks']?.toString() ?? '',
    ObjectCode : json['ObjectCode']?.toString() ?? '',
    BranchId : json['BranchId']?.toString() ?? '',
    UpdatedBy : json['UpdatedBy']?.toString() ?? '',
    PermanentTransId : json['PermanentTransId']?.toString() ?? '',
    DeptCode : json['DeptCode']?.toString() ?? '',
    DeptName : json['DeptName']?.toString() ?? '',
  );
  Map<String,dynamic> toJson()=>{
    'ID' : ID,
    'TransId' : TransId,
    'RouteCode' : RouteCode,
    'RouteName' : RouteName,
    'DocStatus' : DocStatus,
    'DocEntry' : DocEntry,
    'DocNum' : DocNum,
    'CreatedBy' : CreatedBy,
    'CreateDate' : CreateDate?.toIso8601String(),
    'UpdateDate' : UpdateDate?.toIso8601String(),
    'ApprovalStatus' : ApprovalStatus,
    'WhsCode' : WhsCode,
    'IsPosted' : IsPosted,
    'Error' : Error,
    'Latitude' : Latitude,
    'Longitude' : Longitude,
    'Remarks' : Remarks,
    'ObjectCode' : ObjectCode,
    'BranchId' : BranchId,
    'UpdatedBy' : UpdatedBy,
    'PermanentTransId' : PermanentTransId,
    'DeptCode' : DeptCode,
    'DeptName' : DeptName,
  };
}
List<OPOTRP> oPOTRPFromJson(String str) => List<OPOTRP>.from(
    json.decode(str).map((x) => OPOTRP.fromJson(x)));
String oPOTRPToJson(List<OPOTRP> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
Future<List<OPOTRP>> dataSyncOPOTRP() async {
  var res = await http.get(headers: header, Uri.parse(prefix + "OPOTRP" + postfix));
  print(res.body);
  return oPOTRPFromJson(res.body);}
Future<void> insertOPOTRP(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteOPOTRP(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncOPOTRP();
  }
  print(customers);
  Stopwatch stopwatch = Stopwatch();
  stopwatch.start();
  for (var i = 0; i < customers.length; i += batchSize) {
    var end = (i + batchSize < customers.length) ? i + batchSize : customers.length;
    var batchRecords = customers.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (OPOTRP record in batchRecords) {
        try {
          batch.insert('OPOTRP_Temp', record.toJson());
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
			select * from OPOTRP_Temp
			except
			select * from OPOTRP
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
          batch.update("OPOTRP", element,
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
  print('Time taken for OPOTRP update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from OPOTRP_Temp where TransId not in (Select TransId from OPOTRP)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM OPOTRP_Temp T0
LEFT JOIN OPOTRP T1 ON T0.TransId = T1.TransId 
WHERE T1.TransId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('OPOTRP', record);
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
      'Time taken for OPOTRP_Temp and OPOTRP compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('OPOTRP_Temp');
}

Future<List<OPOTRP>> retrieveOPOTRP(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('OPOTRP');
  return queryResult.map((e) => OPOTRP.fromJson(e)).toList();
}
Future<void> updateOPOTRP(int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('OPOTRP', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    getErrorSnackBar('Sync Error ' + e.toString());}}
Future<void> deleteOPOTRP(Database db) async {
  await db.delete('OPOTRP');
}
Future<List<OPOTRP>> retrieveOPOTRPById(BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('OPOTRP', where: str, whereArgs: l);
  return queryResult.map((e) => OPOTRP.fromJson(e)).toList();
}
Future<String> insertOPOTRPToServer(BuildContext? context, {String? TransId, int? id}) async {
  String response = "";
  List<OPOTRP> list = await retrieveOPOTRPById(context, TransId == null ? DataSync.getInsertToServerStr() : "TransId = ? AND ID = ?", TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "OPOTRP/Add"), headers: header, body: jsonEncode(list[0].toJson()));
    response = res.body;
  } else if (list.isNotEmpty) {
    int i = 0;
    bool sentSuccessInServer = false;
    do {
      sentSuccessInServer = false;
      try {
        Map<String, dynamic> map = list[i].toJson();
        map.remove('ID');
        var res = await http.post(Uri.parse(prefix + "OPOTRP/Add"), headers: header,
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
            var x = await db.update("OPOTRP", map, where: "TransId = ? AND RowId = ?", whereArgs: [map["TransId"], map["RowId"]]);
            print(x.toString());}}
        print(res.body);
      } catch (e) {
        print("Timeout " + e.toString());
        sentSuccessInServer = true;}
      print('i++;');
      print("INDEX = " + i.toString());
    } while (i < list.length && sentSuccessInServer == true);}
  return response;}
Future<void> updateOPOTRPOnServer(BuildContext? context, {String? condition, List? l}) async {
  List<OPOTRP> list = await retrieveOPOTRPById(context, l == null ? DataSync.getUpdateOnServerStr() : condition ?? "", l == null ? DataSync.getUpdateOnServerList() : l);
  print(list);
  int i = 0;
  bool sentSuccessInServer = false;
  do {
    sentSuccessInServer = false;
    try {
      Map<String, dynamic> map = list[i].toJson();
      var res = await http.put(Uri.parse(prefix + 'OPOTRP/Update'), headers: header, body: jsonEncode(map)).timeout(Duration(seconds: 30), onTimeout: () {
        return http.Response('Error', 500);
      });
      print(await res.statusCode);
      if (res.statusCode == 201 || res.statusCode == 500) {
        sentSuccessInServer = true;
        if (res.statusCode == 201) {
          final Database db = await initializeDB(context);
          map["has_updated"] = 0;
          var x = await db.update("OPOTRP", map, where: "TransId = ? AND RowId = ?", whereArgs: [map["TransId"], map["RowId"]]);
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

