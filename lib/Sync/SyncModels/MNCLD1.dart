import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

class MNCLD1 {
  int? ID;
  String? TransId;
  int? RowId;
  String? ItemCode;
  String? ItemName;
  String? UOM;
  String? Description;
  String? Remarks;
  String? UserRemarks;
  bool IsChecked;
  bool IsFromStock;
  double? ConsumptionQty;
  String? MNGITransId;
  int? MNGIRowId;
  String? PRTransId;
  int? PRRowId;
  String? MNITTransId;
  int? MNITRowId;
  String? SupplierCode;
  String? SupplierName;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  bool IsConsumption;
  bool IsRequest;
  DateTime? RequiredDate;
  bool? hasCreated;
  bool? hasUpdated;
  bool insertedIntoDatabase;

  MNCLD1({
    this.ID,
    this.TransId,
    this.RowId,
    this.ItemCode,
    this.ItemName,
    this.UOM,
    this.Description,
    this.Remarks,
    this.UserRemarks,
    this.IsChecked = false,
    this.IsFromStock = false,
    this.ConsumptionQty,
    this.MNGITransId,
    this.MNGIRowId,
    this.PRTransId,
    this.PRRowId,
    this.MNITTransId,
    this.MNITRowId,
    this.SupplierCode,
    this.SupplierName,
    this.CreateDate,
    this.UpdateDate,
    this.IsConsumption = false,
    this.IsRequest = false,
    this.RequiredDate,
    this.hasCreated,
    this.hasUpdated,
    this.insertedIntoDatabase = true,
  });

  factory MNCLD1.fromJson(Map<String, dynamic> json) => MNCLD1(
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        TransId: json['TransId']?.toString() ?? '',
        RowId: int.tryParse(json['RowId'].toString()) ?? 0,
        ItemCode: json['ItemCode']?.toString() ?? '',
        ItemName: json['ItemName']?.toString() ?? '',
        UOM: json['UOM']?.toString() ?? '',
        Description: json['Description']?.toString() ?? '',
        Remarks: json['Remarks']?.toString() ?? '',
        UserRemarks: json['UserRemarks']?.toString() ?? '',
        IsChecked: json['IsChecked'] is bool
            ? json['IsChecked']
            : json['IsChecked'] == 1,
        IsFromStock: json['IsFromStock'] is bool
            ? json['IsFromStock']
            : json['IsFromStock'] == 1,
        ConsumptionQty:
            double.tryParse(json['ConsumptionQty'].toString()) ?? 0.0,
        MNGITransId: json['MNGITransId']?.toString() ?? '',
        MNGIRowId: int.tryParse(json['MNGIRowId'].toString()) ?? 0,
        PRTransId: json['PRTransId']?.toString() ?? '',
        PRRowId: int.tryParse(json['PRRowId'].toString()) ?? 0,
        MNITTransId: json['MNITTransId']?.toString() ?? '',
        MNITRowId: int.tryParse(json['MNITRowId'].toString()) ?? 0,
        SupplierCode: json['SupplierCode']?.toString() ?? '',
        SupplierName: json['SupplierName']?.toString() ?? '',
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()),
        IsConsumption: json['IsConsumption'] is bool
            ? json['IsConsumption']
            : json['IsConsumption'] == 1,
        IsRequest: json['IsRequest'] is bool
            ? json['IsRequest']
            : json['IsRequest'] == 1,
        RequiredDate: DateTime.tryParse(json['RequiredDate'].toString()),
        hasCreated: json['has_created'] is bool
            ? json['has_created']
            : json['has_created'] == 1,
        hasUpdated: json['has_updated'] is bool
            ? json['has_updated']
            : json['has_updated'] == 1,
      );

  Map<String, dynamic> toJson() => {
        'ID': ID,
        'TransId': TransId,
        'RowId': RowId,
        'ItemCode': ItemCode,
        'ItemName': ItemName,
        'UOM': UOM,
        'Description': Description,
        'Remarks': Remarks,
        'UserRemarks': UserRemarks,
        'IsChecked': IsChecked,
        'IsFromStock': IsFromStock,
        'ConsumptionQty': ConsumptionQty,
        'MNGITransId': MNGITransId,
        'MNGIRowId': MNGIRowId,
        'PRTransId': PRTransId,
        'PRRowId': PRRowId,
        'MNITTransId': MNITTransId,
        'MNITRowId': MNITRowId,
        'SupplierCode': SupplierCode,
        'SupplierName': SupplierName,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'IsConsumption': IsConsumption,
        'IsRequest': IsRequest,
        'RequiredDate': RequiredDate?.toIso8601String(),
        'has_created': hasCreated,
        'has_updated': hasUpdated,
      };
}

List<MNCLD1> mNCLD1FromJson(String str) =>
    List<MNCLD1>.from(json.decode(str).map((x) => MNCLD1.fromJson(x)));

String mNCLD1ToJson(List<MNCLD1> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<MNCLD1>> dataSyncMNCLD1() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "MNCLD1" + postfix));
  print(res.body);
  return mNCLD1FromJson(res.body);
}

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
    var end =
        (i + batchSize < customers.length) ? i + batchSize : customers.length;
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
              where:
                  "TransId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
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

Future<void> updateMNCLD1(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('MNCLD1', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deleteMNCLD1(Database db) async {
  await db.delete('MNCLD1');
}

Future<List<MNCLD1>> retrieveMNCLD1ById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('MNCLD1', where: str, whereArgs: l);
  return queryResult.map((e) => MNCLD1.fromJson(e)).toList();
}

Future<String> insertMNCLD1ToServer(BuildContext? context,
    {String? TransId, int? id}) async {
  String response = "";
  List<MNCLD1> list = await retrieveMNCLD1ById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "TransId = ? AND ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "MNCLD1/Add"),
        headers: header, body: jsonEncode(list[0].toJson()));
    response = res.body;
  } else if (list.isNotEmpty) {
    int i = 0;
    bool sentSuccessInServer = false;
    do {
      sentSuccessInServer = false;
      try {
        Map<String, dynamic> map = list[i].toJson();
        map.remove('ID');
        var res = await http
            .post(Uri.parse(prefix + "MNCLD1/Add"),
                headers: header, body: jsonEncode(map))
            .timeout(Duration(seconds: 30), onTimeout: () {
          return http.Response('Error', 500);
        });
        response = await res.body;
        print("eeaaae status");
        print(await res.statusCode);
        if (res.statusCode == 409) {
          ///Already added in server
          final Database db = await initializeDB(context);
          MNCLD1 model = MNCLD1.fromJson(jsonDecode(res.body));
          map["ID"] = model.ID;
          map["has_created"] = 0;
          var x = await db.update("MNCLD1", map,
              where: "TransId = ? AND RowId = ?",
              whereArgs: [model.TransId, model.RowId]);
          print(x.toString());
        } else
        if (res.statusCode == 201 || res.statusCode == 500) {
          sentSuccessInServer = true;
          if (res.statusCode == 201) {
            map['ID'] = jsonDecode(res.body)['ID'];
            final Database db = await initializeDB(context);
            // map=jsonDecode(res.body);
            map["has_created"] = 0;
            var x = await db.update("MNCLD1", map,
                where: "TransId = ? AND RowId = ?",
                whereArgs: [map["TransId"], map["RowId"]]);
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
  return response;
}

Future<void> updateMNCLD1OnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<MNCLD1> list = await retrieveMNCLD1ById(
      context,
      l == null ? DataSync.getUpdateOnServerStr() : condition ?? "",
      l == null ? DataSync.getUpdateOnServerList() : l);
  print(list);
  int i = 0;
  bool sentSuccessInServer = false;
  do {
    sentSuccessInServer = false;
    try {
      Map<String, dynamic> map = list[i].toJson();
      var res = await http
          .put(Uri.parse(prefix + 'MNCLD1/Update'),
              headers: header, body: jsonEncode(map))
          .timeout(Duration(seconds: 30), onTimeout: () {
        return http.Response('Error', 500);
      });
      print(await res.statusCode);
      if (res.statusCode == 201 || res.statusCode == 500) {
        sentSuccessInServer = true;
        if (res.statusCode == 201) {
          final Database db = await initializeDB(context);
          map["has_updated"] = 0;
          var x = await db.update("MNCLD1", map,
              where: "TransId = ? AND RowId = ?",
              whereArgs: [map["TransId"], map["RowId"]]);
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

// static String? iD;
// static String? transId;
// static String? rowId;
// static String? itemCode;
// static String? itemName;
// static String? uOM;
// static String? description;
// static String? remarks;
// static String? userRemarks;
// static bool? isChecked;
// static bool? isFromStock;
// static String? consumptionQty;
// static String? mNGITransId;
// static String? mNGIRowId;
// static String? pRTransId;
// static String? pRRowId;
// static String? mNITTransId;
// static String? mNITRowId;
// static String? supplierCode;
// static String? supplierName;
// static DateTime? createDate;
// static DateTime? updateDate;
// static bool? isConsumption;
// static bool? isRequest;
// static DateTime? requiredDate;
// static bool? has_created;
// static bool? has_updated;
// final TextEditingController _iD=TextEditingController(text:GeneralData.iD);
// final TextEditingController _transId=TextEditingController(text:GeneralData.transId);
// final TextEditingController _rowId=TextEditingController(text:GeneralData.rowId);
// final TextEditingController _itemCode=TextEditingController(text:GeneralData.itemCode);
// final TextEditingController _itemName=TextEditingController(text:GeneralData.itemName);
// final TextEditingController _uOM=TextEditingController(text:GeneralData.uOM);
// final TextEditingController _description=TextEditingController(text:GeneralData.description);
// final TextEditingController _remarks=TextEditingController(text:GeneralData.remarks);
// final TextEditingController _userRemarks=TextEditingController(text:GeneralData.userRemarks);
// final TextEditingController _isChecked=TextEditingController(text:GeneralData.isChecked);
// final TextEditingController _isFromStock=TextEditingController(text:GeneralData.isFromStock);
// final TextEditingController _consumptionQty=TextEditingController(text:GeneralData.consumptionQty);
// final TextEditingController _mNGITransId=TextEditingController(text:GeneralData.mNGITransId);
// final TextEditingController _mNGIRowId=TextEditingController(text:GeneralData.mNGIRowId);
// final TextEditingController _pRTransId=TextEditingController(text:GeneralData.pRTransId);
// final TextEditingController _pRRowId=TextEditingController(text:GeneralData.pRRowId);
// final TextEditingController _mNITTransId=TextEditingController(text:GeneralData.mNITTransId);
// final TextEditingController _mNITRowId=TextEditingController(text:GeneralData.mNITRowId);
// final TextEditingController _supplierCode=TextEditingController(text:GeneralData.supplierCode);
// final TextEditingController _supplierName=TextEditingController(text:GeneralData.supplierName);
// final TextEditingController _createDate=TextEditingController(text:GeneralData.createDate);
// final TextEditingController _updateDate=TextEditingController(text:GeneralData.updateDate);
// final TextEditingController _isConsumption=TextEditingController(text:GeneralData.isConsumption);
// final TextEditingController _isRequest=TextEditingController(text:GeneralData.isRequest);
// final TextEditingController _requiredDate=TextEditingController(text:GeneralData.requiredDate);
// final TextEditingController _has_created=TextEditingController(text:GeneralData.has_created);
// final TextEditingController _has_updated=TextEditingController(text:GeneralData.has_updated);
// clearMNCLD1TextFields(){
//   GeneralData.iD='';
//   GeneralData.transId='';
//   GeneralData.rowId='';
//   GeneralData.itemCode='';
//   GeneralData.itemName='';
//   GeneralData.uOM='';
//   GeneralData.description='';
//   GeneralData.remarks='';
//   GeneralData.userRemarks='';
//   GeneralData.isChecked=false;
//   GeneralData.isFromStock=false;
//   GeneralData.consumptionQty='';
//   GeneralData.mNGITransId='';
//   GeneralData.mNGIRowId='';
//   GeneralData.pRTransId='';
//   GeneralData.pRRowId='';
//   GeneralData.mNITTransId='';
//   GeneralData.mNITRowId='';
//   GeneralData.supplierCode='';
//   GeneralData.supplierName='';
//   GeneralData.createDate=DateTime.now();
//   GeneralData.updateDate=DateTime.now();
//   GeneralData.isConsumption=false;
//   GeneralData.isRequest=false;
//   GeneralData.requiredDate=DateTime.now();
//   GeneralData.has_created=false;
//   GeneralData.has_updated=false;
// }
