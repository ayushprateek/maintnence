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
class OPOCNA{
  int? ID;
  String? TransId;
  String? CardCode;
  String? CardName;
  String? RefNo;
  int? ContactPersonId;
  String? ContactPersonName;
  String? MobileNo;
  DateTime? PostingDate;
  DateTime? ValidUntill;
  String? Currency;
  double? CurrRate;
  String? PaymentTermCode;
  String? PaymentTermName;
  int? PaymentTermDays;
  String? ApprovalStatus;
  String? DocStatus;
  String? BaseTransId;
  double? TotBDisc;
  double? DiscPer;
  double? DiscVal;
  double? TaxVal;
  double? DocTotal;
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
  String? RouteCode;
  String? RouteName;
  String? DeptCode;
  String? DeptName;
  OPOCNA({
    this.ID,
    this.TransId,
    this.CardCode,
    this.CardName,
    this.RefNo,
    this.ContactPersonId,
    this.ContactPersonName,
    this.MobileNo,
    this.PostingDate,
    this.ValidUntill,
    this.Currency,
    this.CurrRate,
    this.PaymentTermCode,
    this.PaymentTermName,
    this.PaymentTermDays,
    this.ApprovalStatus,
    this.DocStatus,
    this.BaseTransId,
    this.TotBDisc,
    this.DiscPer,
    this.DiscVal,
    this.TaxVal,
    this.DocTotal,
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
    this.RouteCode,
    this.RouteName,
    this.DeptCode,
    this.DeptName,
  });
  factory OPOCNA.fromJson(Map<String,dynamic> json)=>OPOCNA(
    ID : int.tryParse(json['ID'].toString())??0,
    TransId : json['TransId']?.toString() ?? '',
    CardCode : json['CardCode']?.toString() ?? '',
    CardName : json['CardName']?.toString() ?? '',
    RefNo : json['RefNo']?.toString() ?? '',
    ContactPersonId : int.tryParse(json['ContactPersonId'].toString())??0,
    ContactPersonName : json['ContactPersonName']?.toString() ?? '',
    MobileNo : json['MobileNo']?.toString() ?? '',
    PostingDate : DateTime.tryParse(json['PostingDate'].toString()),
    ValidUntill : DateTime.tryParse(json['ValidUntill'].toString()),
    Currency : json['Currency']?.toString() ?? '',
    CurrRate : double.tryParse(json['CurrRate'].toString())??0.0,
    PaymentTermCode : json['PaymentTermCode']?.toString() ?? '',
    PaymentTermName : json['PaymentTermName']?.toString() ?? '',
    PaymentTermDays : int.tryParse(json['PaymentTermDays'].toString())??0,
    ApprovalStatus : json['ApprovalStatus']?.toString() ?? '',
    DocStatus : json['DocStatus']?.toString() ?? '',
    BaseTransId : json['BaseTransId']?.toString() ?? '',
    TotBDisc : double.tryParse(json['TotBDisc'].toString())??0.0,
    DiscPer : double.tryParse(json['DiscPer'].toString())??0.0,
    DiscVal : double.tryParse(json['DiscVal'].toString())??0.0,
    TaxVal : double.tryParse(json['TaxVal'].toString())??0.0,
    DocTotal : double.tryParse(json['DocTotal'].toString())??0.0,
    PermanentTransId : json['PermanentTransId']?.toString() ?? '',
    DocEntry : int.tryParse(json['DocEntry'].toString())??0,
    DocNum : json['DocNum']?.toString() ?? '',
    CreatedBy : json['CreatedBy']?.toString() ?? '',
    CreateDate : DateTime.tryParse(json['CreateDate'].toString()),
    UpdateDate : DateTime.tryParse(json['UpdateDate'].toString()),
    ApprovedBy : json['ApprovedBy']?.toString() ?? '',
    Error : json['Error']?.toString() ?? '',
    IsPosted : json['IsPosted'] is bool ? json['IsPosted'] : json['IsPosted']==1,
    DraftKey : json['DraftKey']?.toString() ?? '',
    Latitude : json['Latitude']?.toString() ?? '',
    Longitude : json['Longitude']?.toString() ?? '',
    ObjectCode : json['ObjectCode']?.toString() ?? '',
    WhsCode : json['WhsCode']?.toString() ?? '',
    Remarks : json['Remarks']?.toString() ?? '',
    BranchId : json['BranchId']?.toString() ?? '',
    UpdatedBy : json['UpdatedBy']?.toString() ?? '',
    PostingAddress : json['PostingAddress']?.toString() ?? '',
    RouteCode : json['RouteCode']?.toString() ?? '',
    RouteName : json['RouteName']?.toString() ?? '',
    DeptCode : json['DeptCode']?.toString() ?? '',
    DeptName : json['DeptName']?.toString() ?? '',
  );
  Map<String,dynamic> toJson()=>{
    'ID' : ID,
    'TransId' : TransId,
    'CardCode' : CardCode,
    'CardName' : CardName,
    'RefNo' : RefNo,
    'ContactPersonId' : ContactPersonId,
    'ContactPersonName' : ContactPersonName,
    'MobileNo' : MobileNo,
    'PostingDate' : PostingDate?.toIso8601String(),
    'ValidUntill' : ValidUntill?.toIso8601String(),
    'Currency' : Currency,
    'CurrRate' : CurrRate,
    'PaymentTermCode' : PaymentTermCode,
    'PaymentTermName' : PaymentTermName,
    'PaymentTermDays' : PaymentTermDays,
    'ApprovalStatus' : ApprovalStatus,
    'DocStatus' : DocStatus,
    'BaseTransId' : BaseTransId,
    'TotBDisc' : TotBDisc,
    'DiscPer' : DiscPer,
    'DiscVal' : DiscVal,
    'TaxVal' : TaxVal,
    'DocTotal' : DocTotal,
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
    'RouteCode' : RouteCode,
    'RouteName' : RouteName,
    'DeptCode' : DeptCode,
    'DeptName' : DeptName,
  };
}
List<OPOCNA> oPOCNAFromJson(String str) => List<OPOCNA>.from(
    json.decode(str).map((x) => OPOCNA.fromJson(x)));
String oPOCNAToJson(List<OPOCNA> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
Future<List<OPOCNA>> dataSyncOPOCNA() async {
  var res = await http.get(headers: header, Uri.parse(prefix + "OPOCNA" + postfix));
  print(res.body);
  return oPOCNAFromJson(res.body);}
Future<void> insertOPOCNA(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteOPOCNA(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncOPOCNA();
  }
  print(customers);
  Stopwatch stopwatch = Stopwatch();
  stopwatch.start();
  for (var i = 0; i < customers.length; i += batchSize) {
    var end = (i + batchSize < customers.length) ? i + batchSize : customers.length;
    var batchRecords = customers.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (OPOCNA record in batchRecords) {
        try {
          batch.insert('OPOCNA_Temp', record.toJson());
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
			select * from OPOCNA_Temp
			except
			select * from OPOCNA
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
          batch.update("OPOCNA", element,
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
  print('Time taken for OPOCNA update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from OPOCNA_Temp where TransId not in (Select TransId from OPOCNA)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM OPOCNA_Temp T0
LEFT JOIN OPOCNA T1 ON T0.TransId = T1.TransId 
WHERE T1.TransId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('OPOCNA', record);
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
      'Time taken for OPOCNA_Temp and OPOCNA compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('OPOCNA_Temp');
}

Future<List<OPOCNA>> retrieveOPOCNA(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('OPOCNA');
  return queryResult.map((e) => OPOCNA.fromJson(e)).toList();
}
Future<void> updateOPOCNA(int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('OPOCNA', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    getErrorSnackBar('Sync Error ' + e.toString());}}
Future<void> deleteOPOCNA(Database db) async {
  await db.delete('OPOCNA');
}
Future<List<OPOCNA>> retrieveOPOCNAById(BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('OPOCNA', where: str, whereArgs: l);
  return queryResult.map((e) => OPOCNA.fromJson(e)).toList();
}
Future<String> insertOPOCNAToServer(BuildContext? context, {String? TransId, int? id}) async {
  String response = "";
  List<OPOCNA> list = await retrieveOPOCNAById(context, TransId == null ? DataSync.getInsertToServerStr() : "TransId = ? AND ID = ?", TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "OPOCNA/Add"), headers: header, body: jsonEncode(list[0].toJson()));
    response = res.body;
  } else if (list.isNotEmpty) {
    int i = 0;
    bool sentSuccessInServer = false;
    do {
      sentSuccessInServer = false;
      try {
        Map<String, dynamic> map = list[i].toJson();
        map.remove('ID');
        var res = await http.post(Uri.parse(prefix + "OPOCNA/Add"), headers: header,
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
            var x = await db.update("OPOCNA", map, where: "TransId = ? AND RowId = ?", whereArgs: [map["TransId"], map["RowId"]]);
            print(x.toString());}}
        print(res.body);
      } catch (e) {
        print("Timeout " + e.toString());
        sentSuccessInServer = true;}
      i++;
      print("INDEX = " + i.toString());
    } while (i < list.length && sentSuccessInServer == true);}
  return response;}
Future<void> updateOPOCNAOnServer(BuildContext? context, {String? condition, List? l}) async {
  List<OPOCNA> list = await retrieveOPOCNAById(context, l == null ? DataSync.getUpdateOnServerStr() : condition ?? "", l == null ? DataSync.getUpdateOnServerList() : l);
  print(list);
  int i = 0;
  bool sentSuccessInServer = false;
  do {
    sentSuccessInServer = false;
    try {
      Map<String, dynamic> map = list[i].toJson();
      var res = await http.put(Uri.parse(prefix + 'OPOCNA/Update'), headers: header, body: jsonEncode(map)).timeout(Duration(seconds: 30), onTimeout: () {
        return http.Response('Error', 500);
      });
      print(await res.statusCode);
      if (res.statusCode == 201 || res.statusCode == 500) {
        sentSuccessInServer = true;
        if (res.statusCode == 201) {
          final Database db = await initializeDB(context);
          map["has_updated"] = 0;
          var x = await db.update("OPOCNA", map, where: "TransId = ? AND RowId = ?", whereArgs: [map["TransId"], map["RowId"]]);
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

