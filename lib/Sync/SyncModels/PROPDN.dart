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
class PROPDN{
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
  String? RPTransId;
  String? DSTranId;
  String? CRTransId;
  String? BaseTab;
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
  String? Latitude;
  String? Longitude;
  String? UpdatedBy;
  String? BranchId;
  String? Remarks;
  String? LocalDate;
  String? WhsCode;
  String? ObjectCode;
  String? Error;
  String? PostingAddress;
  String? TripTransId;
  String? DeptCode;
  String? DeptName;
  bool hasCreated;
  bool hasUpdated;
  PROPDN({
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
    this.RPTransId,
    this.DSTranId,
    this.CRTransId,
    this.BaseTab,
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
    this.Latitude,
    this.Longitude,
    this.UpdatedBy,
    this.BranchId,
    this.Remarks,
    this.LocalDate,
    this.WhsCode,
    this.ObjectCode,
    this.Error,
    this.PostingAddress,
    this.TripTransId,
    this.DeptCode,
    this.DeptName,
    this.hasCreated = false,
    this.hasUpdated = false,
  });
  factory PROPDN.fromJson(Map<String,dynamic> json)=>PROPDN(
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
    RPTransId : json['RPTransId']?.toString() ?? '',
    DSTranId : json['DSTranId']?.toString() ?? '',
    CRTransId : json['CRTransId']?.toString() ?? '',
    BaseTab : json['BaseTab']?.toString() ?? '',
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
    Latitude : json['Latitude']?.toString() ?? '',
    Longitude : json['Longitude']?.toString() ?? '',
    UpdatedBy : json['UpdatedBy']?.toString() ?? '',
    BranchId : json['BranchId']?.toString() ?? '',
    Remarks : json['Remarks']?.toString() ?? '',
    LocalDate : json['LocalDate']?.toString() ?? '',
    WhsCode : json['WhsCode']?.toString() ?? '',
    ObjectCode : json['ObjectCode']?.toString() ?? '',
    Error : json['Error']?.toString() ?? '',
    PostingAddress : json['PostingAddress']?.toString() ?? '',
    TripTransId : json['TripTransId']?.toString() ?? '',
    DeptCode : json['DeptCode']?.toString() ?? '',
    DeptName : json['DeptName']?.toString() ?? '',
    hasCreated: json['has_created'] == 1,
    hasUpdated: json['has_updated'] == 1,
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
    'RPTransId' : RPTransId,
    'DSTranId' : DSTranId,
    'CRTransId' : CRTransId,
    'BaseTab' : BaseTab,
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
    'Latitude' : Latitude,
    'Longitude' : Longitude,
    'UpdatedBy' : UpdatedBy,
    'BranchId' : BranchId,
    'Remarks' : Remarks,
    'LocalDate' : LocalDate,
    'WhsCode' : WhsCode,
    'ObjectCode' : ObjectCode,
    'Error' : Error,
    'PostingAddress' : PostingAddress,
    'TripTransId' : TripTransId,
    'DeptCode' : DeptCode,
    'DeptName' : DeptName,
    "has_created": hasCreated ? 1 : 0,
    "has_updated": hasUpdated ? 1 : 0,
  };
}
List<PROPDN> pROPDNFromJson(String str) => List<PROPDN>.from(
    json.decode(str).map((x) => PROPDN.fromJson(x)));
String pROPDNToJson(List<PROPDN> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
Future<List<PROPDN>> dataSyncPROPDN() async {
  var res = await http.get(headers: header, Uri.parse(prefix + "PROPDN" + postfix));
  print(res.body);
  return pROPDNFromJson(res.body);}
Future<void> insertPROPDN(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deletePROPDN(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncPROPDN();
  }
  print(customers);
  Stopwatch stopwatch = Stopwatch();
  stopwatch.start();
  for (var i = 0; i < customers.length; i += batchSize) {
    var end = (i + batchSize < customers.length) ? i + batchSize : customers.length;
    var batchRecords = customers.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (PROPDN record in batchRecords) {
        try {
          batch.insert('PROPDN_Temp', record.toJson());
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
			select * from PROPDN_Temp
			except
			select * from PROPDN
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
          batch.update("PROPDN", element,
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
  print('Time taken for PROPDN update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from PROPDN_Temp where TransId not in (Select TransId from PROPDN)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM PROPDN_Temp T0
LEFT JOIN PROPDN T1 ON T0.TransId = T1.TransId 
WHERE T1.TransId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('PROPDN', record);
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
      'Time taken for PROPDN_Temp and PROPDN compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('PROPDN_Temp');
}

Future<List<PROPDN>> retrievePROPDN(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('PROPDN');
  return queryResult.map((e) => PROPDN.fromJson(e)).toList();
}
Future<void> updatePROPDN(int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('PROPDN', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    getErrorSnackBar('Sync Error ' + e.toString());}}
Future<void> deletePROPDN(Database db) async {
  await db.delete('PROPDN');
}
Future<List<PROPDN>> retrievePROPDNById(BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('PROPDN', where: str, whereArgs: l);
  return queryResult.map((e) => PROPDN.fromJson(e)).toList();
}
Future<String> insertPROPDNToServer(BuildContext? context, {String? TransId, int? id}) async {
  String response = "";
  List<PROPDN> list = await retrievePROPDNById(context, TransId == null ? DataSync.getInsertToServerStr() : "TransId = ? AND ID = ?", TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "PROPDN/Add"), headers: header, body: jsonEncode(list[0].toJson()));
    response = res.body;
  } else if (list.isNotEmpty) {
    int i = 0;
    bool sentSuccessInServer = false;
    do {
      sentSuccessInServer = false;
      try {
        Map<String, dynamic> map = list[i].toJson();
        map.remove('ID');
        var res = await http.post(Uri.parse(prefix + "PROPDN/Add"), headers: header,
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
            var x = await db.update("PROPDN", map, where: "TransId = ? AND RowId = ?", whereArgs: [map["TransId"], map["RowId"]]);
            print(x.toString());}}
        print(res.body);
      } catch (e) {
        print("Timeout " + e.toString());
        sentSuccessInServer = true;}
      print('i++;');
      print("INDEX = " + i.toString());
    } while (i < list.length && sentSuccessInServer == true);}
  return response;}
Future<void> updatePROPDNOnServer(BuildContext? context, {String? condition, List? l}) async {
  List<PROPDN> list = await retrievePROPDNById(context, l == null ? DataSync.getUpdateOnServerStr() : condition ?? "", l == null ? DataSync.getUpdateOnServerList() : l);
  print(list);
  int i = 0;
  bool sentSuccessInServer = false;
  do {
    sentSuccessInServer = false;
    try {
      Map<String, dynamic> map = list[i].toJson();
      var res = await http.put(Uri.parse(prefix + 'PROPDN/Update'), headers: header, body: jsonEncode(map)).timeout(Duration(seconds: 30), onTimeout: () {
        return http.Response('Error', 500);
      });
      print(await res.statusCode);
      if (res.statusCode == 201 || res.statusCode == 500) {
        sentSuccessInServer = true;
        if (res.statusCode == 201) {
          final Database db = await initializeDB(context);
          map["has_updated"] = 0;
          var x = await db.update("PROPDN", map, where: "TransId = ? AND RowId = ?", whereArgs: [map["TransId"], map["RowId"]]);
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

