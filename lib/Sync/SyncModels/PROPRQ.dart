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
class PROPRQ{
  int? ID;
  String? TransId;
  String? RefNo;
  String? MobileNo;
  DateTime? PostingDate;
  DateTime? ValidUntill;
  String? ApprovalStatus;
  String? DocStatus;
  String? PermanentTransId;
  int? DocEntry;
  String? DocNum;
  String? CreatedBy;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  String? ApprovedBy;
  String? Error;
  bool? IsPosted;
  String? DraftKey;
  String? Latitude;
  String? Longitude;
  String? ObjectCode;
  String? WhsCode;
  String? Remarks;
  String? BranchId;
  String? UpdatedBy;
  String? PostingAddress;
  String? TripTransId;
  String? DeptCode;
  String? DeptName;
  String? RequestedCode;
  String? RequestedName;
  PROPRQ({
    this.ID,
    this.TransId,
    this.RefNo,
    this.MobileNo,
    this.PostingDate,
    this.ValidUntill,
    this.ApprovalStatus,
    this.DocStatus,
    this.PermanentTransId,
    this.DocEntry,
    this.DocNum,
    this.CreatedBy,
    this.CreateDate,
    this.UpdateDate,
    this.ApprovedBy,
    this.Error,
    this.IsPosted,
    this.DraftKey,
    this.Latitude,
    this.Longitude,
    this.ObjectCode,
    this.WhsCode,
    this.Remarks,
    this.BranchId,
    this.UpdatedBy,
    this.PostingAddress,
    this.TripTransId,
    this.DeptCode,
    this.DeptName,
    this.RequestedCode,
    this.RequestedName,
  });
  factory PROPRQ.fromJson(Map<String,dynamic> json)=>PROPRQ(
    ID : int.tryParse(json['ID'].toString())??0,
    TransId : json['TransId'],
    RefNo : json['RefNo'],
    MobileNo : json['MobileNo'],
    PostingDate : DateTime.tryParse(json['PostingDate'].toString()),
    ValidUntill : DateTime.tryParse(json['ValidUntill'].toString()),
    ApprovalStatus : json['ApprovalStatus'],
    DocStatus : json['DocStatus'],
    PermanentTransId : json['PermanentTransId'],
    DocEntry : int.tryParse(json['DocEntry'].toString())??0,
    DocNum : json['DocNum'],
    CreatedBy : json['CreatedBy'],
    CreateDate : DateTime.tryParse(json['CreateDate'].toString()),
    UpdateDate : DateTime.tryParse(json['UpdateDate'].toString()),
    ApprovedBy : json['ApprovedBy'],
    Error : json['Error'],
    IsPosted : json['IsPosted'] is bool ? json['IsPosted'] : json['IsPosted']==1,
    DraftKey : json['DraftKey'],
    Latitude : json['Latitude'],
    Longitude : json['Longitude'],
    ObjectCode : json['ObjectCode'],
    WhsCode : json['WhsCode'],
    Remarks : json['Remarks'],
    BranchId : json['BranchId'],
    UpdatedBy : json['UpdatedBy'],
    PostingAddress : json['PostingAddress'],
    TripTransId : json['TripTransId'],
    DeptCode : json['DeptCode'],
    DeptName : json['DeptName'],
    RequestedCode : json['RequestedCode'],
    RequestedName : json['RequestedName'],
  );
  Map<String,dynamic> toJson()=>{
    'ID' : ID,
    'TransId' : TransId,
    'RefNo' : RefNo,
    'MobileNo' : MobileNo,
    'PostingDate' : PostingDate?.toIso8601String(),
    'ValidUntill' : ValidUntill?.toIso8601String(),
    'ApprovalStatus' : ApprovalStatus,
    'DocStatus' : DocStatus,
    'PermanentTransId' : PermanentTransId,
    'DocEntry' : DocEntry,
    'DocNum' : DocNum,
    'CreatedBy' : CreatedBy,
    'CreateDate' : CreateDate?.toIso8601String(),
    'UpdateDate' : UpdateDate?.toIso8601String(),
    'ApprovedBy' : ApprovedBy,
    'Error' : Error,
    'IsPosted' : IsPosted,
    'DraftKey' : DraftKey,
    'Latitude' : Latitude,
    'Longitude' : Longitude,
    'ObjectCode' : ObjectCode,
    'WhsCode' : WhsCode,
    'Remarks' : Remarks,
    'BranchId' : BranchId,
    'UpdatedBy' : UpdatedBy,
    'PostingAddress' : PostingAddress,
    'TripTransId' : TripTransId,
    'DeptCode' : DeptCode,
    'DeptName' : DeptName,
    'RequestedCode' : RequestedCode,
    'RequestedName' : RequestedName,
  };
}
List<PROPRQ> pROPRQFromJson(String str) => List<PROPRQ>.from(
    json.decode(str).map((x) => PROPRQ.fromJson(x)));
String pROPRQToJson(List<PROPRQ> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
Future<List<PROPRQ>> dataSyncPROPRQ() async {
  var res = await http.get(headers: header, Uri.parse(prefix + "PROPRQ" + postfix));
  print(res.body);
  return pROPRQFromJson(res.body);}
Future<void> insertPROPRQ(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deletePROPRQ(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncPROPRQ();
  }
  print(customers);
  Stopwatch stopwatch = Stopwatch();
  stopwatch.start();
  for (var i = 0; i < customers.length; i += batchSize) {
    var end = (i + batchSize < customers.length) ? i + batchSize : customers.length;
    var batchRecords = customers.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (PROPRQ record in batchRecords) {
        try {
          batch.insert('PROPRQ_Temp', record.toJson());
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
			select * from PROPRQ_Temp
			except
			select * from PROPRQ
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
          batch.update("PROPRQ", element,
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
  print('Time taken for PROPRQ update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from PROPRQ_Temp where TransId not in (Select TransId from PROPRQ)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM PROPRQ_Temp T0
LEFT JOIN PROPRQ T1 ON T0.TransId = T1.TransId 
WHERE T1.TransId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('PROPRQ', record);
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
      'Time taken for PROPRQ_Temp and PROPRQ compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('PROPRQ_Temp');
}

Future<List<PROPRQ>> retrievePROPRQ(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('PROPRQ');
  return queryResult.map((e) => PROPRQ.fromJson(e)).toList();
}
Future<void> updatePROPRQ(int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('PROPRQ', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    getErrorSnackBar('Sync Error ' + e.toString());}}
Future<void> deletePROPRQ(Database db) async {
  await db.delete('PROPRQ');
}
Future<List<PROPRQ>> retrievePROPRQById(BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('PROPRQ', where: str, whereArgs: l);
  return queryResult.map((e) => PROPRQ.fromJson(e)).toList();
}
Future<String> insertPROPRQToServer(BuildContext? context, {String? TransId, int? id}) async {
  String response = "";
  List<PROPRQ> list = await retrievePROPRQById(context, TransId == null ? DataSync.getInsertToServerStr() : "TransId = ? AND ID = ?", TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "PROPRQ/Add"), headers: header, body: jsonEncode(list[0].toJson()));
    response = res.body;
  } else if (list.isNotEmpty) {
    int i = 0;
    bool sentSuccessInServer = false;
    do {
      sentSuccessInServer = false;
      try {
        Map<String, dynamic> map = list[i].toJson();
        map.remove('ID');
        var res = await http.post(Uri.parse(prefix + "PROPRQ/Add"), headers: header,
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
            var x = await db.update("PROPRQ", map, where: "TransId = ? AND RowId = ?", whereArgs: [map["TransId"], map["RowId"]]);
            print(x.toString());}}
        print(res.body);
      } catch (e) {
        print("Timeout " + e.toString());
        sentSuccessInServer = true;}
      print('i++;');
      print("INDEX = " + i.toString());
    } while (i < list.length && sentSuccessInServer == true);}
  return response;}
Future<void> updatePROPRQOnServer(BuildContext? context, {String? condition, List? l}) async {
  List<PROPRQ> list = await retrievePROPRQById(context, l == null ? DataSync.getUpdateOnServerStr() : condition ?? "", l == null ? DataSync.getUpdateOnServerList() : l);
  print(list);
  int i = 0;
  bool sentSuccessInServer = false;
  do {
    sentSuccessInServer = false;
    try {
      Map<String, dynamic> map = list[i].toJson();
      var res = await http.put(Uri.parse(prefix + 'PROPRQ/Update'), headers: header, body: jsonEncode(map)).timeout(Duration(seconds: 30), onTimeout: () {
        return http.Response('Error', 500);
      });
      print(await res.statusCode);
      if (res.statusCode == 201 || res.statusCode == 500) {
        sentSuccessInServer = true;
        if (res.statusCode == 201) {
          final Database db = await initializeDB(context);
          map["has_updated"] = 0;
          var x = await db.update("PROPRQ", map, where: "TransId = ? AND RowId = ?", whereArgs: [map["TransId"], map["RowId"]]);
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

