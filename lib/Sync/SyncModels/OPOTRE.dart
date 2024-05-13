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
class OPOTRE{
  int? ID;
  String? TransId;
  String? RouteCode;
  String? RouteName;
  int? DocEntry;
  String? DocNum;
  String? CreatedBy;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  String? ApprovedBy;
  String? ApprovalStatus;
  String? SalesEmpId;
  String? SalesEmp;
  String? NrcNo;
  String? DriverMobileNo;
  String? WhsCode;
  bool? IsPosted;
  String? Error;
  String? Latitude;
  String? Longitude;
  String? Remarks;
  String? ObjectCode;
  String? LocalDate;
  String? BranchId;
  String? UpdatedBy;
  String? TrnsType;
  String? EmpMobileNo;
  String? DriverId;
  String? PermanentTransId;
  String? TripTransId;
  String? DeptCode;
  String? DeptName;
  OPOTRE({
    this.ID,
    this.TransId,
    this.RouteCode,
    this.RouteName,
    this.DocEntry,
    this.DocNum,
    this.CreatedBy,
    this.CreateDate,
    this.UpdateDate,
    this.ApprovedBy,
    this.ApprovalStatus,
    this.SalesEmpId,
    this.SalesEmp,
    this.NrcNo,
    this.DriverMobileNo,
    this.WhsCode,
    this.IsPosted,
    this.Error,
    this.Latitude,
    this.Longitude,
    this.Remarks,
    this.ObjectCode,
    this.LocalDate,
    this.BranchId,
    this.UpdatedBy,
    this.TrnsType,
    this.EmpMobileNo,
    this.DriverId,
    this.PermanentTransId,
    this.TripTransId,
    this.DeptCode,
    this.DeptName,
  });
  factory OPOTRE.fromJson(Map<String,dynamic> json)=>OPOTRE(
    ID : int.tryParse(json['ID'].toString())??0,
    TransId : json['TransId']?.toString() ?? '',
    RouteCode : json['RouteCode']?.toString() ?? '',
    RouteName : json['RouteName']?.toString() ?? '',
    DocEntry : int.tryParse(json['DocEntry'].toString())??0,
    DocNum : json['DocNum']?.toString() ?? '',
    CreatedBy : json['CreatedBy']?.toString() ?? '',
    CreateDate : DateTime.tryParse(json['CreateDate'].toString()),
    UpdateDate : DateTime.tryParse(json['UpdateDate'].toString()),
    ApprovedBy : json['ApprovedBy']?.toString() ?? '',
    ApprovalStatus : json['ApprovalStatus']?.toString() ?? '',
    SalesEmpId : json['SalesEmpId']?.toString() ?? '',
    SalesEmp : json['SalesEmp']?.toString() ?? '',
    NrcNo : json['NrcNo']?.toString() ?? '',
    DriverMobileNo : json['DriverMobileNo']?.toString() ?? '',
    WhsCode : json['WhsCode']?.toString() ?? '',
    IsPosted : json['IsPosted'] is bool ? json['IsPosted'] : json['IsPosted']==1,
    Error : json['Error']?.toString() ?? '',
    Latitude : json['Latitude']?.toString() ?? '',
    Longitude : json['Longitude']?.toString() ?? '',
    Remarks : json['Remarks']?.toString() ?? '',
    ObjectCode : json['ObjectCode']?.toString() ?? '',
    LocalDate : json['LocalDate']?.toString() ?? '',
    BranchId : json['BranchId']?.toString() ?? '',
    UpdatedBy : json['UpdatedBy']?.toString() ?? '',
    TrnsType : json['TrnsType']?.toString() ?? '',
    EmpMobileNo : json['EmpMobileNo']?.toString() ?? '',
    DriverId : json['DriverId']?.toString() ?? '',
    PermanentTransId : json['PermanentTransId']?.toString() ?? '',
    TripTransId : json['TripTransId']?.toString() ?? '',
    DeptCode : json['DeptCode']?.toString() ?? '',
    DeptName : json['DeptName']?.toString() ?? '',
  );
  Map<String,dynamic> toJson()=>{
    'ID' : ID,
    'TransId' : TransId,
    'RouteCode' : RouteCode,
    'RouteName' : RouteName,
    'DocEntry' : DocEntry,
    'DocNum' : DocNum,
    'CreatedBy' : CreatedBy,
    'CreateDate' : CreateDate?.toIso8601String(),
    'UpdateDate' : UpdateDate?.toIso8601String(),
    'ApprovedBy' : ApprovedBy,
    'ApprovalStatus' : ApprovalStatus,
    'SalesEmpId' : SalesEmpId,
    'SalesEmp' : SalesEmp,
    'NrcNo' : NrcNo,
    'DriverMobileNo' : DriverMobileNo,
    'WhsCode' : WhsCode,
    'IsPosted' : IsPosted,
    'Error' : Error,
    'Latitude' : Latitude,
    'Longitude' : Longitude,
    'Remarks' : Remarks,
    'ObjectCode' : ObjectCode,
    'LocalDate' : LocalDate,
    'BranchId' : BranchId,
    'UpdatedBy' : UpdatedBy,
    'TrnsType' : TrnsType,
    'EmpMobileNo' : EmpMobileNo,
    'DriverId' : DriverId,
    'PermanentTransId' : PermanentTransId,
    'TripTransId' : TripTransId,
    'DeptCode' : DeptCode,
    'DeptName' : DeptName,
  };
}
List<OPOTRE> oPOTREFromJson(String str) => List<OPOTRE>.from(
    json.decode(str).map((x) => OPOTRE.fromJson(x)));
String oPOTREToJson(List<OPOTRE> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
Future<List<OPOTRE>> dataSyncOPOTRE() async {
  var res = await http.get(headers: header, Uri.parse(prefix + "OPOTRE" + postfix));
  print(res.body);
  return oPOTREFromJson(res.body);}
Future<void> insertOPOTRE(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteOPOTRE(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncOPOTRE();
  }
  print(customers);
  Stopwatch stopwatch = Stopwatch();
  stopwatch.start();
  for (var i = 0; i < customers.length; i += batchSize) {
    var end = (i + batchSize < customers.length) ? i + batchSize : customers.length;
    var batchRecords = customers.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (OPOTRE record in batchRecords) {
        try {
          batch.insert('OPOTRE_Temp', record.toJson());
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
			select * from OPOTRE_Temp
			except
			select * from OPOTRE
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
          batch.update("OPOTRE", element,
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
  print('Time taken for OPOTRE update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from OPOTRE_Temp where TransId not in (Select TransId from OPOTRE)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM OPOTRE_Temp T0
LEFT JOIN OPOTRE T1 ON T0.TransId = T1.TransId 
WHERE T1.TransId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('OPOTRE', record);
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
      'Time taken for OPOTRE_Temp and OPOTRE compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('OPOTRE_Temp');
}

Future<List<OPOTRE>> retrieveOPOTRE(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('OPOTRE');
  return queryResult.map((e) => OPOTRE.fromJson(e)).toList();
}
Future<void> updateOPOTRE(int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('OPOTRE', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    getErrorSnackBar('Sync Error ' + e.toString());}}
Future<void> deleteOPOTRE(Database db) async {
  await db.delete('OPOTRE');
}
Future<List<OPOTRE>> retrieveOPOTREById(BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('OPOTRE', where: str, whereArgs: l);
  return queryResult.map((e) => OPOTRE.fromJson(e)).toList();
}
Future<String> insertOPOTREToServer(BuildContext? context, {String? TransId, int? id}) async {
  String response = "";
  List<OPOTRE> list = await retrieveOPOTREById(context, TransId == null ? DataSync.getInsertToServerStr() : "TransId = ? AND ID = ?", TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "OPOTRE/Add"), headers: header, body: jsonEncode(list[0].toJson()));
    response = res.body;
  } else if (list.isNotEmpty) {
    int i = 0;
    bool sentSuccessInServer = false;
    do {
      sentSuccessInServer = false;
      try {
        Map<String, dynamic> map = list[i].toJson();
        map.remove('ID');
        var res = await http.post(Uri.parse(prefix + "OPOTRE/Add"), headers: header,
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
            var x = await db.update("OPOTRE", map, where: "TransId = ? AND RowId = ?", whereArgs: [map["TransId"], map["RowId"]]);
            print(x.toString());}}
        print(res.body);
      } catch (e) {
        print("Timeout " + e.toString());
        sentSuccessInServer = true;}
      print('i++;');
      print("INDEX = " + i.toString());
    } while (i < list.length && sentSuccessInServer == true);}
  return response;}
Future<void> updateOPOTREOnServer(BuildContext? context, {String? condition, List? l}) async {
  List<OPOTRE> list = await retrieveOPOTREById(context, l == null ? DataSync.getUpdateOnServerStr() : condition ?? "", l == null ? DataSync.getUpdateOnServerList() : l);
  print(list);
  int i = 0;
  bool sentSuccessInServer = false;
  do {
    sentSuccessInServer = false;
    try {
      Map<String, dynamic> map = list[i].toJson();
      var res = await http.put(Uri.parse(prefix + 'OPOTRE/Update'), headers: header, body: jsonEncode(map)).timeout(Duration(seconds: 30), onTimeout: () {
        return http.Response('Error', 500);
      });
      print(await res.statusCode);
      if (res.statusCode == 201 || res.statusCode == 500) {
        sentSuccessInServer = true;
        if (res.statusCode == 201) {
          final Database db = await initializeDB(context);
          map["has_updated"] = 0;
          var x = await db.update("OPOTRE", map, where: "TransId = ? AND RowId = ?", whereArgs: [map["TransId"], map["RowId"]]);
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

