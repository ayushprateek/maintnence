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

List<RDR1Model> RDR1ModelFromJson(String str) =>
    List<RDR1Model>.from(json.decode(str).map((x) => RDR1Model.fromJson(x)));

String RDR1ModelToJson(List<RDR1Model> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RDR1Model {
  RDR1Model({
    this.ID,
    this.TransId,
    this.RowId,
    this.ItemCode,
    this.ItemName,
    this.CreateDate,
    this.UpdateDate,
    this.hasCreated = false,
    this.hasUpdated = false,
    this.insertedIntoDatabase = true,
    this.Quantity,
    this.UOM,
    this.Price,
    this.TaxCode,
    this.TaxRate,
    this.Discount,
    this.LineTotal,
    this.BaseTransId,
    this.BaseRowId,
    this.OpenQty,
    this.LineStatus,
    this.MSP,
    this.BaseObjectCode,
    this.RoutePlanningQty,
    this.WhsCode,
  });

  int? ID;
  String? TransId;
  int? RowId;
  String? ItemCode;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  bool hasCreated;
  bool hasUpdated;
  String? ItemName;
  double? Quantity;
  String? UOM;
  double? Price;
  String? TaxCode;
  double? TaxRate;
  double? Discount;
  double? LineTotal;
  String? BaseTransId;
  String? BaseRowId;
  double? OpenQty;
  String? LineStatus;
  double? MSP;
  bool insertedIntoDatabase;

  String? BaseObjectCode;
  double? RoutePlanningQty;
  String? WhsCode;

  factory RDR1Model.fromJson(Map<String, dynamic> json) =>
      RDR1Model(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        TransId: json["TransId"] ?? "",
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] == 1,
        hasUpdated: json['has_updated'] == 1,
        RowId: int.tryParse(json["RowId"].toString()) ?? 0,
        ItemCode: json["ItemCode"].toString(),
        ItemName: json["ItemName"].toString(),
        Quantity: double.tryParse(json["Quantity"].toString()) ?? 0.0,
        UOM: json["UOM"].toString(),
        Price: double.tryParse(json["Price"].toString()) ?? 0.0,
        TaxCode: json["TaxCode"] ?? "",
        TaxRate: double.tryParse(json["TaxRate"].toString()) ?? 0.0,
        Discount: double.tryParse(json["Discount"].toString()) ?? 0.0,
        LineTotal: double.tryParse(json["LineTotal"].toString()) ?? 0.0,
        BaseTransId: json["BaseTransId"] ?? "",
        BaseRowId: json["BaseRowId"] ?? "",
        OpenQty: double.tryParse(json["OpenQty"].toString()) ?? 0.0,
        LineStatus: json["LineStatus"] ?? "",
        MSP: double.tryParse(json["MSP"].toString()) ?? 0.0,
        BaseObjectCode: json['BaseObjectCode'] ?? '',
        RoutePlanningQty:
        double.tryParse(json['RoutePlanningQty'].toString()) ?? 0.0,
        WhsCode: json['WhsCode'] ?? '',
      );

  Map<String, dynamic> toJson() =>
      {
        "ID": ID,
        "TransId": TransId,
        "RowId": RowId,
        "ItemCode": ItemCode,
        "ItemName": ItemName,
        "Quantity": Quantity,
        "CreateDate": CreateDate?.toIso8601String(),
        "UpdateDate": UpdateDate?.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "has_updated": hasUpdated ? 1 : 0,
        "UOM": UOM,
        "Price": Price,
        "TaxCode": TaxCode,
        "TaxRate": TaxRate,
        "Discount": Discount,
        "LineTotal": double.tryParse(LineTotal?.toStringAsFixed(2) ?? '') ?? 0.0,
        "BaseTransId": BaseTransId,
        "BaseRowId": BaseRowId,
        "OpenQty": OpenQty,
        "LineStatus": LineStatus,
        "MSP": MSP,
        'BaseObjectCode': BaseObjectCode,
        'RoutePlanningQty': RoutePlanningQty,
        'WhsCode': WhsCode,
      };
}

Future<List<RDR1Model>> dataSyncRDR1() async {
  var res =
  await http.get(headers: header, Uri.parse(prefix + "RDR1" + postfix));
  print(res.body);
  return RDR1ModelFromJson(res.body);
}

Future<List<RDR1Model>> retrieveRDR1(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('RDR1');
  return queryResult.map((e) => RDR1Model.fromJson(e)).toList();
}

Future<List<RDR1Model>> retrieveRDR1ById(BuildContext? context, String str,
    List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
  await db.query('RDR1', where: str, whereArgs: l);
  return queryResult.map((e) => RDR1Model.fromJson(e)).toList();
}

Future<void> updateRDR1(int id, Map<String, dynamic> values,
    BuildContext context) async {
  final db = await initializeDB(context);
  try {
    await db.transaction((db) async {
      await db.update("RDR1", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteRDR1(Database db) async {
  await db.delete('RDR1');
}

// Future<void> insertRDR1(Database db)async{
//   if(postfix.toLowerCase().contains("all"))
//   await deleteRDR1(db);
//   List customers= await dataSyncRDR1();
//   print(customers);
//   var batch = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try
//     {
//       batch.insert('RDR1', customer.toJson());
//     }
//     catch(e)
//     {
//       getErrorSnackBar("Sync Error "+e.toString());
//     }
//   });
//   await batch.commit(noResult: true);
//
//   // customers.forEach((customer) async {
//   //   print(customer.toJson());
//   //   try
//   //   {
//   //     db.transaction((db)async{
//   //       await db.insert('RDR1', customer.toJson());
//   //     });
//   //   }
//   //   catch(e)
//   //   {
//   //     getErrorSnackBar("Sync Error "+e.toString());
//   //   }
//   //
//   // });
// }
// Future<void> insertRDR1(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteRDR1(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncRDR1();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('RDR1_Temp', customer.toJson());
//     } catch (e) {
//       writeToLogFile(
//           text: e.toString(),
//           fileName: StackTrace.current.toString(),
//           lineNo: 141);
//       getErrorSnackBar("Sync Error " + e.toString());
//     }
//   });
//   await batch1.commit(noResult: true);
//   var u = await db.rawQuery(
//       "SELECT * FROM  RDR1_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("RDR1", element,
//         where: "RowId = ? AND TransId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["RowId"], element["TransId"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from RDR1_Temp where TransId || RowId not in (Select TransId || RowId from RDR1)");
//   v.forEach((element) {
//     batch3.insert('RDR1', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('RDR1_Temp');
// }
Future<void> insertRDR1(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteRDR1(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncRDR1();
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
      for (RDR1Model record in batchRecords) {
        try {
          batch.insert('RDR1_Temp', record.toJson());
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
			select * from RDR1_Temp
			except
			select * from RDR1
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
          batch.update("RDR1", element,
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
  print('Time taken for RDR1 update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from RDR1_Temp where TransId || RowId not in (Select TransId || RowId from RDR1)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM RDR1_Temp T0
LEFT JOIN RDR1 T1 ON T0.TransId = T1.TransId AND T0.RowId = T1.RowId
WHERE T1.TransId IS NULL AND T1.RowId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('RDR1', record);
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
      'Time taken for RDR1_Temp and RDR1 compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('RDR1_Temp');
  // stopwatch.stop();
}

//SEND DATA TO SERVER
//--------------------------

Future<void> insertRDR1ToServer(BuildContext? context,
    {String? TransId, int? ID}) async {
  String response = "";
  List<RDR1Model> list = await retrieveRDR1ById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "TransId = ? AND ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, ID]);
  // List<RDR1Model> list = await retrieveRDR1(context!);
  print(list.length);
  if (TransId != null) {
    //only single entry
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "RDR1/Add"),
        headers: header, body: jsonEncode(list[0].toJson()));
    print(res.body);
    response = res.body;
  } else if (list.isNotEmpty) {
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
        var res = await http.post(Uri.parse(prefix + "RDR1/Add?$queryParams"),
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
          RDR1Model model=RDR1Model.fromJson(jsonDecode(res.body));
          var x = await db.update("RDR1", model.toJson(),
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
            var x = await db.update("RDR1", map,
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
            text: '${e.toString()}\nMap : $map',
            fileName: StackTrace.current.toString(),
            lineNo: 141);
        sentSuccessInServer = true;
      }

      i++;
      print("INDEX = " + i.toString());
    } while (i < list.length && sentSuccessInServer == true);
  }
}

Future<void> updateRDR1OnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<RDR1Model> list = await retrieveRDR1ById(
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
          .put(Uri.parse(prefix + 'RDR1/Update'),
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
          var x = await db.update("RDR1", map,
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
