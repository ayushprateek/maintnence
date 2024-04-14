import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

List<DSC1Model> DSC1ModelFromJson(String str) =>
    List<DSC1Model>.from(json.decode(str).map((x) => DSC1Model.fromJson(x)));

String DSC1ModelToJson(List<DSC1Model> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DSC1Model {
  DSC1Model({
    required this.ID,
    required this.CreateDate,
    required this.UpdateDate,
    this.hasCreated = false,
    this.hasUpdated = false,
    required this.TransId,
    required this.RowId,
    required this.BaseTransId,
    required this.BaseRowId,
    required this.CardCode,
    required this.CardName,
    required this.ItemCode,
    required this.ItemName,
    required this.Quantity,
    required this.OpenQty,
    required this.UOM,
    required this.DelDueDate,
    required this.ShipToAddress,
    required this.CollectCash,
    required this.LoadQty,
    required this.LineStatus,
    required this.InvoiceQty,
    this.IsSelected,
    this.enableCheckbox = true,
    this.DocEntry,
    this.DocNum,
    this.TransferredQty,
    this.OpenQtySum=0,
  });

  int ID;
  bool? IsSelected;
  String TransId;
  double? InvoiceQty;
  DateTime CreateDate;
  DateTime UpdateDate;
  bool hasCreated;
  bool hasUpdated;
  int RowId;
  String BaseTransId;
  int BaseRowId;
  String CardCode;
  String CardName;
  String ItemCode;
  String ItemName;
  double Quantity;
  double OpenQty;
  String UOM;
  DateTime DelDueDate;
  String ShipToAddress;
  bool CollectCash;
  double LoadQty;
  String LineStatus;
  bool checked = false,
      enableCheckbox;
  bool existsInDSC2 = false;
  int? DocEntry;
  String? DocNum;
  double OpenQtySum;
  double? TransferredQty;
  TextEditingController invoiceQty=TextEditingController();

  factory DSC1Model.fromJson(Map<String, dynamic> json) =>
      DSC1Model(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] == 1,
        hasUpdated: json['has_updated'] == 1,
        TransId: json["TransId"] ?? "",
        RowId: int.tryParse(json["RowId"].toString()) ?? 0,
        BaseTransId: json["BaseTransId"] ?? "",
        BaseRowId: int.tryParse(json["BaseRowId"].toString()) ?? 0,
        CardCode: json["CardCode"] ?? "",
        CardName: json["CardName"] ?? "",
        ItemCode: json["ItemCode"] ?? "",
        ItemName: json["ItemName"] ?? "",
        InvoiceQty: double.tryParse(json["InvoiceQty"].toString()) ?? 0.0,
        Quantity: double.tryParse(json["Quantity"].toString()) ?? 0.0,
        TransferredQty: double.tryParse(json["TransferredQty"].toString()) ?? 0.0,
        OpenQtySum: double.tryParse(json["OpenQtySum"].toString()) ?? 0.0,
        OpenQty: double.tryParse(json["OpenQty"].toString()) ?? 0.0,
        UOM: json["UOM"] ?? "",
        DelDueDate: DateTime.tryParse(json["DelDueDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        ShipToAddress: json["ShipToAddress"] ?? "",
        CollectCash: json["CollectCash"] is bool
            ? json["CollectCash"]
            : json["CollectCash"] == 1,
        LoadQty: double.tryParse(json["LoadQty"].toString()) ?? 0.0,
        LineStatus: json["LineStatus"] ?? "",
        enableCheckbox: json["LineStatus"] != 'Close',
        IsSelected: json['IsSelected'] is bool
            ? json['IsSelected']
            : json['IsSelected'] == 1,
        DocEntry: json['DocEntry'],
        DocNum: json['DocNum'],
      );

  Map<String, dynamic> toJson() =>
      {
        "ID": ID,
        "TransId": TransId,
        "RowId": RowId,
        "CreateDate": CreateDate.toIso8601String(),
        "UpdateDate": UpdateDate.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "has_updated": hasUpdated ? 1 : 0,
        "InvoiceQty": InvoiceQty,
        "BaseTransId": BaseTransId,
        "BaseRowId": BaseRowId,
        "CardCode": CardCode,
        "CardName": CardName,
        "ItemCode": ItemCode,
        "ItemName": ItemName,
        "Quantity": Quantity,
        "TransferredQty": TransferredQty,
        "OpenQty": OpenQty,
        "UOM": UOM,
        "DelDueDate": DelDueDate.toIso8601String(),
        "ShipToAddress": ShipToAddress,
        "CollectCash": CollectCash,
        "LoadQty": LoadQty,
        "LineStatus": LineStatus,
        'IsSelected': IsSelected,
        'DocEntry': DocEntry,
        'DocNum': DocNum,
      };
}

Future<List<DSC1Model>> dataSyncDSC1() async {
  var res =
  await http.get(headers: header, Uri.parse(prefix + "DSC1" + postfix));
  print(res.body);
  return DSC1ModelFromJson(res.body);
}



Future<void> insertDSC1(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteDSC1(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncDSC1();
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
      for (DSC1Model record in batchRecords) {
        try {
          batch.insert('DSC1_Temp', record.toJson());
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
			select * from DSC1_Temp
			except
			select * from DSC1
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
          batch.update("DSC1", element,
              where: "RowId = ? AND TransId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
              whereArgs: [element["RowId"], element["TransId"], 1, 1]);
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
  print('Time taken for DSC1 update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from DSC1_Temp where TransId || RowId not in (Select TransId || RowId from DSC1)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM DSC1_Temp T0
LEFT JOIN DSC1 T1 ON T0.TransId = T1.TransId AND T0.RowId = T1.RowId
WHERE T1.TransId IS NULL AND T1.RowId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('DSC1', record);
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
      'Time taken for DSC1_Temp and DSC1 compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('DSC1_Temp');
  // stopwatch.stop();
}


Future<List<DSC1Model>> retrieveDSC1(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('DSC1');
  return queryResult.map((e) => DSC1Model.fromJson(e)).toList();
}
// Future<List<DSC1Model>> matchDSC1AndDSC2({
//   required List<int> selectedItemsRowId,
//   required bool exists
// }) async {
//   String rowStr='(';
//   for(int i=0;i<selectedItemsRowId.length;i++){
//
//     if(i==selectedItemsRowId.length-1)
//     {
//       rowStr+='${selectedItemsRowId[i]}';
//     }
//     else
//     {
//       rowStr+='${selectedItemsRowId[i]},';
//     }
//
//   }
//   rowStr+=')';
//   print(rowStr);
//   final Database db = await initializeDB(null);
//   String condition='';
//   if(exists)
//   {
//     condition='IN';
//   }
//   else
//   {
//     condition='NOT IN';
//   }
//   String query='''
//   SELECT  ItemCode,SUM(OpenQty) AS OpenQtySum,* FROM DSC1
// WHERE TransId = '${GeneralData.TransId}' AND RowId IN $rowStr
// AND ItemCode $condition (SELECT  ItemCode FROM
// DSC2 WHERE TransId = '${GeneralData.TransId}')
// GROUP BY ItemCode;
//   ''';
//
//   final List<Map<String, Object?>> queryResult = await db.rawQuery(query);
//   return queryResult.map((e) => DSC1Model.fromJson(e)).toList();
// }

Future<void> updateDSC1(int id, Map<String, dynamic> values,
    BuildContext context) async {
  final db = await initializeDB(context);
  try {
    await db.transaction((db) async {
      await db.update("DSC1", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteDSC1(Database db) async {
  await db.delete(
    'DSC1',
  );
}

//SEND DATA TO SERVER
//--------------------------
Future<List<DSC1Model>> retrieveDSC1ById(BuildContext? context, String str,
    List l, {
      String? orderBy
    }) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
  await db.query('DSC1', where: str, whereArgs: l, orderBy: orderBy);
  return queryResult.map((e) => DSC1Model.fromJson(e)).toList();
}

Future<void> insertDSC1ToServer(BuildContext? context,
    {String? TransId, int? ID}) async {
  String response = "";
  List<DSC1Model> list = await retrieveDSC1ById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "TransId = ? AND ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, ID]);
  if (TransId != null) {
    //only single entry
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "DSC1/Add"),
        headers: header, body: jsonEncode(list[0].toJson()));
    print(res.body);
    response = res.body;
  } else if (list.isNotEmpty) {
    //asxkncuievbuefvbeivuehveubvbeuivuibervuierbvueir
    int i = 0;
    bool sentSuccessInServer = false;
    if (list.isEmpty) {
      return;
    }
    do {Map<String, dynamic> map = list[i].toJson();
      sentSuccessInServer = false;
      try {
        map.remove('ID');
        String queryParams='TransId=${list[i].TransId}&RowId=${list[i].RowId}';
        var res = await http.post(Uri.parse(prefix + "DSC1/Add?$queryParams"),
            headers: header, body: jsonEncode(map))
            .timeout(Duration(seconds: 30), onTimeout: () {
          writeToLogFile(
            text: '500 error \nMap : $map', fileName: StackTrace.current.toString(), lineNo: 141);return http.Response('Error', 500);
        });
        response = await res.body;

        print("eeaaae status");
        print(await res.statusCode);
        if(res.statusCode != 201)
        {
          await writeToLogFile(
              text: '${res.statusCode} error \nMap : $map\nResponse : ${res.body}',
              fileName: StackTrace.current.toString(),
              lineNo: 141);
        }
        if(res.statusCode ==409)
        {
          ///Already added in server
          final Database db = await initializeDB(context);
          DSC1Model model=DSC1Model.fromJson(jsonDecode(res.body));
          var x = await db.update("DSC1", model.toJson(),
              where: "TransId = ? AND RowId = ?", whereArgs: [model.TransId,model.RowId]);
          print(x.toString());
        }
        else
        if (res.statusCode == 201 || res.statusCode == 500) {
          sentSuccessInServer = true;
          if (res.statusCode == 201) {
            map['ID'] = jsonDecode(res.body)['ID'];
            final Database db = await initializeDB(context);
            map["has_created"] = 0;
            var x = await db.update("DSC1", map,
                where: "TransId = ? AND RowId = ?",
                whereArgs: [map["TransId"], map["RowId"]]);
            print(x.toString());
          }else{
            writeToLogFile(
                text: '500 error \nMap : $map',
                fileName: StackTrace.current.toString(),
                lineNo: 141);
          }
        }
        print(res.body);
      } catch (e) {
        writeToLogFile(
            text: '${e.toString()}\nMap : $map', fileName: StackTrace.current.toString(), lineNo: 141);
  sentSuccessInServer = true;
  }

  i++;
  print("INDEX = " + i.toString());
  } while (i < list.length && sentSuccessInServer == true);
}

}

Future<void> updateDSC1OnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<DSC1Model> list = await retrieveDSC1ById(
      context,
      l == null ? DataSync.getUpdateOnServerStr() : condition ?? "",
      l == null ? DataSync.getUpdateOnServerList() : l);
  print(list);
  int i = 0;
  bool sentSuccessInServer = false;
  if (list.isEmpty) {
    return;
  }
  do {Map<String, dynamic> map = list[i].toJson();
    sentSuccessInServer = false;
    try {
      if (list.isEmpty) {
        return;
      }
      Map<String, dynamic> map = list[i].toJson();
      var res = await http
          .put(Uri.parse(prefix + 'DSC1/Update'),
          headers: header, body: jsonEncode(map))
          .timeout(Duration(seconds: 30), onTimeout: () {
        writeToLogFile(
            text: '500 error \nMap : $map', fileName: StackTrace.current.toString(), lineNo: 141);return http.Response('Error', 500);
      });
      print(await res.statusCode);
      if(res.statusCode != 201)
        {
          await writeToLogFile(
              text: '${res.statusCode} error \nMap : $map\nResponse : ${res.body}',
              fileName: StackTrace.current.toString(),
              lineNo: 141);
        }
        if (res.statusCode == 201 || res.statusCode == 500) {
        sentSuccessInServer = true;
        if (res.statusCode == 201) {
          final Database db = await initializeDB(context);
          map["has_updated"] = 0;
          var x = await db.update("DSC1", map,
              where: "TransId = ? AND RowId = ?",
              whereArgs: [map["TransId"], map["RowId"]]);
          print(x.toString());
        }else{
          writeToLogFile(
              text: '500 error \nMap : $map',
              fileName: StackTrace.current.toString(),
              lineNo: 141);
        }
      }
      print(res.body);
    } catch (e) {
      writeToLogFile(
          text: '${e.toString()}\nMap : $map', fileName: StackTrace.current.toString(), lineNo: 141);
  sentSuccessInServer = true;
  }

  i++;
  print("INDEX = " + i.toString());
  } while (i < list.length && sentSuccessInServer == true);
}
