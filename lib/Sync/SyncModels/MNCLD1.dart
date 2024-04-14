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
class MNCLD1{
  int? ID;
  String? Code;
  String? FirstName;
  String? MiddleName;
  String? LastName;
  String? Group;
  String? SubGroup;
  String? Currency;
  String? Telephone;
  String? MobileNo;
  String? Address;
  String? CityCode;
  String? CityName;
  String? StateCode;
  String? StateName;
  String? CountryCode;
  String? CountryName;
  String? Email;
  String? Website;
  bool? SAPCustomer;
  String? PaymentTermCode;
  String? PaymentTermName;
  int? PaymentTermDays;
  double? CreditLimit;
  bool? Active;
  String? Latitude;
  String? Longitude;
  int? ShopSize;
  DateTime? CreateDate;
  bool? Competitor;
  bool? ISSAP;
  bool? ISPORTAL;
  String? BPType;
  String? CreatedBy;
  String? UpdatedBy;
  String? BranchId;
  String? PriceListCode;
  String? TerritoryCode;
  String? TerritoryName;
  bool? IsTemporary;
  String? CardGroupName;
  String? CardSubGroupName;
  String? SAPCARDCODE;
  DateTime? UpdateDate;
  int? hasCreated;
  int? hasUpdated;
  MNCLD1({
    this.ID,
    this.Code,
    this.FirstName,
    this.MiddleName,
    this.LastName,
    this.Group,
    this.SubGroup,
    this.Currency,
    this.Telephone,
    this.MobileNo,
    this.Address,
    this.CityCode,
    this.CityName,
    this.StateCode,
    this.StateName,
    this.CountryCode,
    this.CountryName,
    this.Email,
    this.Website,
    this.SAPCustomer,
    this.PaymentTermCode,
    this.PaymentTermName,
    this.PaymentTermDays,
    this.CreditLimit,
    this.Active,
    this.Latitude,
    this.Longitude,
    this.ShopSize,
    this.CreateDate,
    this.Competitor,
    this.ISSAP,
    this.ISPORTAL,
    this.BPType,
    this.CreatedBy,
    this.UpdatedBy,
    this.BranchId,
    this.PriceListCode,
    this.TerritoryCode,
    this.TerritoryName,
    this.IsTemporary,
    this.CardGroupName,
    this.CardSubGroupName,
    this.SAPCARDCODE,
    this.UpdateDate,
    this.hasCreated,
    this.hasUpdated,
  });
  factory MNCLD1.fromJson(Map<String,dynamic> json)=>MNCLD1(
    ID : int.tryParse(json['ID'].toString())??0,
    Code : json['Code'],
    FirstName : json['FirstName'],
    MiddleName : json['MiddleName'],
    LastName : json['LastName'],
    Group : json['Group'],
    SubGroup : json['SubGroup'],
    Currency : json['Currency'],
    Telephone : json['Telephone'],
    MobileNo : json['MobileNo'],
    Address : json['Address'],
    CityCode : json['CityCode'],
    CityName : json['CityName'],
    StateCode : json['StateCode'],
    StateName : json['StateName'],
    CountryCode : json['CountryCode'],
    CountryName : json['CountryName'],
    Email : json['Email'],
    Website : json['Website'],
    SAPCustomer : json['SAPCustomer'] is bool ? json['SAPCustomer'] : json['SAPCustomer']==1,
    PaymentTermCode : json['PaymentTermCode'],
    PaymentTermName : json['PaymentTermName'],
    PaymentTermDays : int.tryParse(json['PaymentTermDays'].toString())??0,
    CreditLimit : double.tryParse(json['CreditLimit'].toString())??0.0,
    Active : json['Active'] is bool ? json['Active'] : json['Active']==1,
    Latitude : json['Latitude'],
    Longitude : json['Longitude'],
    ShopSize : int.tryParse(json['ShopSize'].toString())??0,
    CreateDate : DateTime.tryParse(json['CreateDate'].toString()),
    Competitor : json['Competitor'] is bool ? json['Competitor'] : json['Competitor']==1,
    ISSAP : json['ISSAP'] is bool ? json['ISSAP'] : json['ISSAP']==1,
    ISPORTAL : json['ISPORTAL'] is bool ? json['ISPORTAL'] : json['ISPORTAL']==1,
    BPType : json['BPType'],
    CreatedBy : json['CreatedBy'],
    UpdatedBy : json['UpdatedBy'],
    BranchId : json['BranchId'],
    PriceListCode : json['PriceListCode'],
    TerritoryCode : json['TerritoryCode'],
    TerritoryName : json['TerritoryName'],
    IsTemporary : json['IsTemporary'] is bool ? json['IsTemporary'] : json['IsTemporary']==1,
    CardGroupName : json['CardGroupName'],
    CardSubGroupName : json['CardSubGroupName'],
    SAPCARDCODE : json['SAPCARDCODE'],
    UpdateDate : DateTime.tryParse(json['UpdateDate'].toString()),
    hasCreated : int.tryParse(json['has_created'].toString())??0,
    hasUpdated : int.tryParse(json['has_updated'].toString())??0,
  );
  Map<String,dynamic> toJson()=>{
    'ID' : ID,
    'Code' : Code,
    'FirstName' : FirstName,
    'MiddleName' : MiddleName,
    'LastName' : LastName,
    'Group' : Group,
    'SubGroup' : SubGroup,
    'Currency' : Currency,
    'Telephone' : Telephone,
    'MobileNo' : MobileNo,
    'Address' : Address,
    'CityCode' : CityCode,
    'CityName' : CityName,
    'StateCode' : StateCode,
    'StateName' : StateName,
    'CountryCode' : CountryCode,
    'CountryName' : CountryName,
    'Email' : Email,
    'Website' : Website,
    'SAPCustomer' : SAPCustomer,
    'PaymentTermCode' : PaymentTermCode,
    'PaymentTermName' : PaymentTermName,
    'PaymentTermDays' : PaymentTermDays,
    'CreditLimit' : CreditLimit,
    'Active' : Active,
    'Latitude' : Latitude,
    'Longitude' : Longitude,
    'ShopSize' : ShopSize,
    'CreateDate' : CreateDate?.toIso8601String(),
    'Competitor' : Competitor,
    'ISSAP' : ISSAP,
    'ISPORTAL' : ISPORTAL,
    'BPType' : BPType,
    'CreatedBy' : CreatedBy,
    'UpdatedBy' : UpdatedBy,
    'BranchId' : BranchId,
    'PriceListCode' : PriceListCode,
    'TerritoryCode' : TerritoryCode,
    'TerritoryName' : TerritoryName,
    'IsTemporary' : IsTemporary,
    'CardGroupName' : CardGroupName,
    'CardSubGroupName' : CardSubGroupName,
    'SAPCARDCODE' : SAPCARDCODE,
    'UpdateDate' : UpdateDate?.toIso8601String(),
    'has_created' : hasCreated,
    'has_updated' : hasUpdated,
  };
}
List<MNCLD1> mNCLD1FromJson(String str) => List<MNCLD1>.from(
    json.decode(str).map((x) => MNCLD1.fromJson(x)));
String mNCLD1ToJson(List<MNCLD1> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
Future<List<MNCLD1>> dataSyncMNCLD1() async {
  var res = await http.get(headers: header, Uri.parse(prefix + "MNCLD1" + postfix));
  print(res.body);
  return mNCLD1FromJson(res.body);}
Future<void> insertMNCLD1(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteMNCLD1(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncMNCLD1();
  }
  print(customers);
  Stopwatch stopwatch = Stopwatch();
  stopwatch.start();
  for (var i = 0; i < customers.length; i += batchSize) {
    var end = (i + batchSize < customers.length) ? i + batchSize : customers.length;
    var batchRecords = customers.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (MNCLD1 record in batchRecords) {
        try {
          batch.insert('MNCLD1_Temp', record.toJson());
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
			select * from MNCLD1_Temp
			except
			select * from MNCLD1
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
          batch.update("MNCLD1", element,
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
  print('Time taken for MNCLD1 update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from MNCLD1_Temp where TransId not in (Select TransId from MNCLD1)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM MNCLD1_Temp T0
LEFT JOIN MNCLD1 T1 ON T0.TransId = T1.TransId 
WHERE T1.TransId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('MNCLD1', record);
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
      'Time taken for MNCLD1_Temp and MNCLD1 compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('MNCLD1_Temp');
}

Future<List<MNCLD1>> retrieveMNCLD1(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('MNCLD1');
  return queryResult.map((e) => MNCLD1.fromJson(e)).toList();
}
Future<void> updateMNCLD1(int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('MNCLD1', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    getErrorSnackBar('Sync Error ' + e.toString());}}
Future<void> deleteMNCLD1(Database db) async {
  await db.delete('MNCLD1');
}
Future<List<MNCLD1>> retrieveMNCLD1ById(BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('MNCLD1', where: str, whereArgs: l);
  return queryResult.map((e) => MNCLD1.fromJson(e)).toList();
}
Future<String> insertMNCLD1ToServer(BuildContext? context, {String? TransId, int? id}) async {
  String response = "";
  List<MNCLD1> list = await retrieveMNCLD1ById(context, TransId == null ? DataSync.getInsertToServerStr() : "TransId = ? AND ID = ?", TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "MNCLD1/Add"), headers: header, body: jsonEncode(list[0].toJson()));
    response = res.body;
  } else if (list.isNotEmpty) {
    int i = 0;
    bool sentSuccessInServer = false;
    do {
      sentSuccessInServer = false;
      try {
        Map<String, dynamic> map = list[i].toJson();
        map.remove('ID');
        var res = await http.post(Uri.parse(prefix + "MNCLD1/Add"), headers: header,
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
            var x = await db.update("MNCLD1", map, where: "TransId = ? AND RowId = ?", whereArgs: [map["TransId"], map["RowId"]]);
            print(x.toString());}}
        print(res.body);
      } catch (e) {
        print("Timeout " + e.toString());
        sentSuccessInServer = true;}
      print('i++;');
      print("INDEX = " + i.toString());
    } while (i < list.length && sentSuccessInServer == true);}
  return response;}
Future<void> updateMNCLD1OnServer(BuildContext? context, {String? condition, List? l}) async {
  List<MNCLD1> list = await retrieveMNCLD1ById(context, l == null ? DataSync.getUpdateOnServerStr() : condition ?? "", l == null ? DataSync.getUpdateOnServerList() : l);
  print(list);
  int i = 0;
  bool sentSuccessInServer = false;
  do {
    sentSuccessInServer = false;
    try {
      Map<String, dynamic> map = list[i].toJson();
      var res = await http.put(Uri.parse(prefix + 'MNCLD1/Update'), headers: header, body: jsonEncode(map)).timeout(Duration(seconds: 30), onTimeout: () {
        return http.Response('Error', 500);
      });
      print(await res.statusCode);
      if (res.statusCode == 201 || res.statusCode == 500) {
        sentSuccessInServer = true;
        if (res.statusCode == 201) {
          final Database db = await initializeDB(context);
          map["has_updated"] = 0;
          var x = await db.update("MNCLD1", map, where: "TransId = ? AND RowId = ?", whereArgs: [map["TransId"], map["RowId"]]);
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

