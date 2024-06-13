import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

List<DLN1Model> DLN1ModelFromJson(String str) =>
    List<DLN1Model>.from(json.decode(str).map((x) => DLN1Model.fromJson(x)));

String DLN1ModelToJson(List<DLN1Model> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DLN1Model {
  DLN1Model({
    this.ID,
    this.WhsCode,
    this.TransId,
    this.CreateDate,
    this.UpdateDate,
    this.hasCreated = false,
    this.hasUpdated = false,
    this.insertedIntoDatabase = false,
    this.RowId,
    this.ItemCode,
    this.ItemName,
    this.Quantity,
    this.UOM,
    this.Price,
    this.TaxCode,
    this.TaxRate,
    this.Discount,
    this.LineTotal,
    this.RPTransId,
    this.DSTranId,
    this.CRTransId,
    this.DSRowId,
    this.BaseTransId,
    this.BaseRowId,
    this.BaseType,
    this.LineStatus,
    this.MSP,
    this.OpenQty,
    this.BaseObjectCode,
    this.DocEntry,
    this.DocNum,
  });

  int? DocEntry;
  String? DocNum;
  int? ID;
  String? WhsCode;
  String? TransId;
  int? RowId;
  String? ItemCode;
  String? ItemName;
  double? Quantity;
  String? UOM;
  double? Price;
  String? BaseObjectCode;
  String? TaxCode;
  double? TaxRate;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  bool hasCreated;
  bool hasUpdated;
  bool insertedIntoDatabase;
  double? Discount;
  double? LineTotal;
  String? RPTransId;
  String? DSTranId;
  String? CRTransId;
  int? DSRowId;
  String? BaseTransId;
  int? BaseRowId;
  String? BaseType;
  String? LineStatus;
  double? OpenQty;
  double? MSP;

  factory DLN1Model.fromJson(Map<String, dynamic> json) => DLN1Model(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        BaseObjectCode: json["BaseObjectCode"] ?? "",
        TransId: json["TransId"] ?? "",
        RowId: int.tryParse(json["RowId"].toString()) ?? 0,
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] is bool
            ? json['has_created']
            : json['has_created'] == 1,
        hasUpdated: json['has_updated'] is bool
            ? json['has_updated']
            : json['has_updated'] == 1,
        WhsCode: json["WhsCode"] ?? "",
        ItemCode: json["ItemCode"] ?? "",
        ItemName: json["ItemName"] ?? "",
        OpenQty: double.tryParse(json["OpenQty"].toString()) ?? 0.0,
        Quantity: double.tryParse(json["Quantity"].toString()) ?? 0.0,
        UOM: json["UOM"] ?? "",
        Price: double.tryParse(json["Price"].toString()) ?? 0.0,
        TaxCode: json["TaxCode"] ?? "",
        TaxRate: double.tryParse(json["TaxRate"].toString()) ?? 0.0,
        Discount: double.tryParse(json["Discount"].toString()) ?? 0.0,
        LineTotal: double.tryParse(json["LineTotal"].toString()) ?? 0.0,
        RPTransId: json["RPTransId"] ?? "",
        DSTranId: json["DSTranId"] ?? "",
        CRTransId: json["CRTransId"] ?? "",
        DSRowId: int.tryParse(json["DSRowId"].toString()) ?? 0,
        BaseTransId: json["BaseTransId"] ?? "",
        BaseRowId: int.tryParse(json["BaseRowId"].toString()) ?? 0,
        BaseType: json["BaseType"] ?? "",
        LineStatus: json["LineStatus"] ?? "",
        MSP: double.tryParse(json["MSP"].toString()) ?? 0.0,
        DocEntry: json['DocEntry'],
        DocNum: json['DocNum'],
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "TransId": TransId,
        "WhsCode": WhsCode,
        "BaseObjectCode": BaseObjectCode,
        "RowId": RowId,
        "CreateDate": CreateDate?.toIso8601String(),
        "UpdateDate": UpdateDate?.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "has_updated": hasUpdated ? 1 : 0,
        "ItemCode": ItemCode,
        "ItemName": ItemName,
        "OpenQty": OpenQty,
        "Quantity": Quantity,
        "UOM": UOM,
        "Price": Price,
        "TaxCode": TaxCode,
        "TaxRate": TaxRate,
        "Discount": Discount,
        "LineTotal":
            double.tryParse(LineTotal?.toStringAsFixed(2) ?? '') ?? 0.0,
        "RPTransId": RPTransId,
        "DSTranId": DSTranId,
        "CRTransId": CRTransId,
        "DSRowId": DSRowId,
        "BaseTransId": BaseTransId,
        "BaseRowId": BaseRowId,
        "BaseType": BaseType,
        "LineStatus": LineStatus,
        "MSP": MSP,
        'DocEntry': DocEntry,
        'DocNum': DocNum,
      };
}

Future<List<DLN1Model>> dataSyncDLN1() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "DLN1" + postfix));
  print(res.body);
  return DLN1ModelFromJson(res.body);
}

// Future<void> insertDLN1(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteDLN1(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncDLN1();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('DLN1_Temp', customer.toJson());
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
//       "SELECT * FROM  DLN1_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("DLN1", element,
//         where: "RowId = ? AND TransId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["RowId"], element["TransId"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from DLN1_Temp where TransId || RowId not in (Select TransId || RowId from DLN1)");
//   v.forEach((element) {
//     batch3.insert('DLN1', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('DLN1_Temp');
// }

Future<void> insertDLN1(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteDLN1(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncDLN1();
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
      for (DLN1Model record in batchRecords) {
        try {
          batch.insert('DLN1_Temp', record.toJson());
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
			select * from DLN1_Temp
			except
			select * from DLN1
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
          batch.update("DLN1", element,
              where:
                  "RowId = ? AND TransId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
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
  print('Time taken for DLN1 update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from DLN1_Temp where TransId || RowId not in (Select TransId || RowId from DLN1)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM DLN1_Temp T0
LEFT JOIN DLN1 T1 ON T0.TransId = T1.TransId AND T0.RowId = T1.RowId
WHERE T1.TransId IS NULL AND T1.RowId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('DLN1', record);
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
      'Time taken for DLN1_Temp and DLN1 compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('DLN1_Temp');
  // stopwatch.stop();
}

Future<List<DLN1Model>> retrieveDLN1(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('DLN1');
  return queryResult.map((e) => DLN1Model.fromJson(e)).toList();
}

Future<List<DLN1Model>> retrieveDLN1ById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('DLN1', where: str, whereArgs: l);
  return queryResult.map((e) => DLN1Model.fromJson(e)).toList();
}

Future<void> updateDLN1(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update("DLN1", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteDLN1(Database db) async {
  await db.delete('DLN1');
}
//SEND DATA TO SERVER
//--------------------------

Future<void> insertDLN1ToServer(BuildContext? context,
    {String? TransId, int? ID}) async {
  String response = "";
  List<DLN1Model> list = await retrieveDLN1ById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "TransId = ? AND ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, ID]);
  if (TransId != null) {
    //only single entry
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "DLN1/Add"),
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
    do {
      Map<String, dynamic> map = list[i].toJson();
      sentSuccessInServer = false;
      try {
        map.remove('ID');
        String queryParams =
            'TransId=${list[i].TransId}&RowId=${list[i].RowId}';
        var res = await http
            .post(Uri.parse(prefix + "DLN1/Add?$queryParams"),
                headers: header, body: jsonEncode(map))
            .timeout(Duration(seconds: 30), onTimeout: () {
          writeToLogFile(
              text: '500 error \nMap : $map',
              fileName: StackTrace.current.toString(),
              lineNo: 141);
          return http.Response('Error', 500);
        });
        response = await res.body;

        print("eeaaae status");
        print(await res.statusCode);
        if (res.statusCode != 201) {
          await writeToLogFile(
              text:
                  '${res.statusCode} error \nMap : $map\nResponse : ${res.body}',
              fileName: StackTrace.current.toString(),
              lineNo: 141);
        }
        if (res.statusCode == 409) {
          ///Already added in server
          final Database db = await initializeDB(context);
          DLN1Model model = DLN1Model.fromJson(jsonDecode(res.body));
          var x = await db.update("DLN1", model.toJson(),
              where: "TransId = ? AND RowId = ?",
              whereArgs: [model.TransId, model.RowId]);
          print(x.toString());
        } else if (res.statusCode == 201 || res.statusCode == 500) {
          sentSuccessInServer = true;
          if (res.statusCode == 201) {
            map['ID'] = jsonDecode(res.body)['ID'];
            final Database db = await initializeDB(context);
            map["has_created"] = 0;
            var x = await db.update("DLN1", map,
                where: "TransId = ? AND RowId = ?",
                whereArgs: [map["TransId"], map["RowId"]]);
            print(x.toString());
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

Future<void> updateDLN1OnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<DLN1Model> list = await retrieveDLN1ById(
      context,
      l == null ? DataSync.getUpdateOnServerStr() : condition ?? "",
      l == null ? DataSync.getUpdateOnServerList() : l);
  print(list);
  int i = 0;
  bool sentSuccessInServer = false;
  if (list.isEmpty) {
    return;
  }
  do {
    Map<String, dynamic> map = list[i].toJson();
    sentSuccessInServer = false;
    try {
      if (list.isEmpty) {
        return;
      }
      Map<String, dynamic> map = list[i].toJson();
      var res = await http
          .put(Uri.parse(prefix + 'DLN1/Update'),
              headers: header, body: jsonEncode(map))
          .timeout(Duration(seconds: 30), onTimeout: () {
        writeToLogFile(
            text: '500 error \nMap : $map',
            fileName: StackTrace.current.toString(),
            lineNo: 141);
        return http.Response('Error', 500);
      });
      print(await res.statusCode);
      if (res.statusCode != 201) {
        await writeToLogFile(
            text:
                '${res.statusCode} error \nMap : $map\nResponse : ${res.body}',
            fileName: StackTrace.current.toString(),
            lineNo: 141);
      }
      if (res.statusCode == 201 || res.statusCode == 500) {
        sentSuccessInServer = true;
        if (res.statusCode == 201) {
          final Database db = await initializeDB(context);
          map["has_updated"] = 0;
          var x = await db.update("DLN1", map,
              where: "TransId = ? AND RowId = ?",
              whereArgs: [map["TransId"], map["RowId"]]);
          print(x.toString());
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
