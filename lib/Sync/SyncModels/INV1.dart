import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

List<INV1Model> INV1ModelFromJson(String str) =>
    List<INV1Model>.from(json.decode(str).map((x) => INV1Model.fromJson(x)));

String INV1ModelToJson(List<INV1Model> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class INV1Model {
  INV1Model({
    this.ID,
    this.WhsCode,
    this.TransId,
    this.RowId,
    this.ItemCode,
    this.ItemName,
    this.CreateDate,
    this.UpdateDate,
    this.hasCreated = false,
    this.insertedIntoDatabase = true,
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
    this.hasUpdated = false,
    this.isSelected = false,
    this.DocEntry,
    this.DocNum,
    this.DeliveredQty,
    this.Remarks,
  });

  int? ID;
  String? WhsCode;
  String? TransId;
  String? Remarks;
  int? RowId;
  bool hasUpdated;
  bool isSelected;
  String? ItemCode;
  String? ItemName;
  double? Quantity;
  String? UOM;
  double? DeliveredQty;
  double? Price;
  String? TaxCode;
  double? TaxRate;
  double? Discount;
  double? LineTotal;
  String? RPTransId;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  bool insertedIntoDatabase;
  int? DocEntry;
  String? DocNum;

  bool hasCreated;
  String? DSTranId;
  String? CRTransId;
  int? DSRowId;
  String? BaseTransId;
  int? BaseRowId;
  String? BaseType;
  String? LineStatus;
  double? MSP;
  double? OpenQty;
  String? BaseObjectCode;
  TextEditingController deliveredQtyController = TextEditingController();
  TextEditingController remarksController = TextEditingController();

  factory INV1Model.fromJson(Map<String, dynamic> json) => INV1Model(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        WhsCode: json["WhsCode"] ?? "",
        TransId: json["TransId"] ?? "",
        RowId: int.tryParse(json["RowId"].toString()) ?? 0,
        ItemCode: json["ItemCode"] ?? "",
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] == 1,
        hasUpdated: json['has_updated'] == 1,
        Remarks: json['Remarks'],
        DocEntry: json['DocEntry'],
        DocNum: json['DocNum'],
        ItemName: json["ItemName"] ?? "",
        Quantity: double.tryParse(json["Quantity"].toString()) ?? 0.0,
        UOM: json["UOM"] ?? "",
        Price: double.tryParse(json["Price"].toString()) ?? 0.0,
        TaxCode: json["TaxCode"] ?? "",
        TaxRate: double.tryParse(json["TaxRate"].toString()) ?? 0.0,
        DeliveredQty: double.tryParse(json["DeliveredQty"].toString()) ?? 0.0,
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
        OpenQty: double.tryParse(json['OpenQty'].toString()) ?? 0.0,
        BaseObjectCode: json['BaseObjectCode'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "TransId": TransId,
        "CreateDate": CreateDate?.toIso8601String(),
        "UpdateDate": UpdateDate?.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "has_updated": hasUpdated ? 1 : 0,
        "RowId": RowId,
        "ItemCode": ItemCode,
        "WhsCode": WhsCode,
        "ItemName": ItemName,
        "DeliveredQty": DeliveredQty,
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
        "Remarks": Remarks,
        "DSRowId": DSRowId,
        "BaseTransId": BaseTransId,
        "BaseRowId": BaseRowId,
        "BaseType": BaseType,
        "LineStatus": LineStatus,
        "MSP": MSP,
        'OpenQty': OpenQty,
        'DocEntry': DocEntry,
        'DocNum': DocNum,
        'BaseObjectCode': BaseObjectCode
      };
}

Future<List<INV1Model>> dataSyncINV1() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "INV1" + postfix));
  print(res.body);
  return INV1ModelFromJson(res.body);
}

// Future<void> insertINV1(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteINV1(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncINV1();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('INV1_Temp', customer.toJson());
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
//       "SELECT * FROM  INV1_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN UpdateDate IS NULL THEN CreateDate ELSE UpdateDate END)");
//   u.forEach((element) {
//     batch2.update("INV1", element,
//         where: "RowId = ? AND TransId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["RowId"], element["TransId"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from INV1_Temp where TransId || RowId not in (Select TransId || RowId from INV1)");
//   v.forEach((element) {
//     batch3.insert('INV1', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('INV1_Temp');
// }

Future<void> insertINV1(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteINV1(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncINV1();
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
      for (INV1Model record in batchRecords) {
        try {
          batch.insert('INV1_Temp', record.toJson());
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
			select * from INV1_Temp
			except
			select * from INV1
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
          batch.update("INV1", element,
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
  print('Time taken for INV1 update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from INV1_Temp where TransId || RowId not in (Select TransId || RowId from INV1)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM INV1_Temp T0
LEFT JOIN INV1 T1 ON T0.TransId = T1.TransId AND T0.RowId = T1.RowId
WHERE T1.TransId IS NULL AND T1.RowId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('INV1', record);
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
      'Time taken for INV1_Temp and INV1 compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('INV1_Temp');
  // stopwatch.stop();
}

Future<List<INV1Model>> retrieveINV1(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('INV1');
  return queryResult.map((e) => INV1Model.fromJson(e)).toList();
}

Future<List<INV1Model>> retrieveINV1ById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('INV1', where: str, whereArgs: l);
  return queryResult.map((e) => INV1Model.fromJson(e)).toList();
}

Future<List<INV1Model>> retrieveStockData({required String CardCode}) async {
  final Database db = await initializeDB(null);
  String query = '''
                            select ItemCode,ItemName,sum(Quantity) as Quantity,sum(OpenQty) as OpenQty   from inv1 
WHERE TransId IN (SELECT TransId from OINV WHERE CardCode='$CardCode') 
group by ItemCode
                            ''';
  final List<Map<String, Object?>> queryResult = await db.rawQuery(query);
  return queryResult.map((e) => INV1Model.fromJson(e)).toList();
}

Future<void> updateINV1(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update("INV1", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteINV1(Database db) async {
  await db.delete('INV1');
}
//SEND DATA TO SERVER
//--------------------------

Future<void> insertINV1ToServer(BuildContext? context,
    {String? TransId, int? ID}) async {
  String response = "";
  List<INV1Model> list = await retrieveINV1ById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "TransId = ? AND ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, ID]);
  // List<INV1Model> list = await retrieveINV1ById(context,"TransId = ? OR TransId = ?",['U01_IN/2874','U01_IN/2841']);
  print(list.length);
  if (TransId != null) {
    //only single entry
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "INV1/Add"),
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
        var res = await http
            .post(Uri.parse(prefix + "INV1/Add"),
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
        if (res.statusCode == 201 || res.statusCode == 500) {
          sentSuccessInServer = true;
          if (res.statusCode == 201) {
            map['ID'] = jsonDecode(res.body)['ID'];
            final Database db = await initializeDB(context);
            map["has_created"] = 0;
            var x = await db.update("INV1", map,
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

Future<void> updateINV1OnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<INV1Model> list = await retrieveINV1ById(
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
      String queryParams = 'TransId=${list[i].TransId}&RowId=${list[i].RowId}';
      var res = await http
          .post(Uri.parse(prefix + "INV1/Add?$queryParams"),
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
      if (res.statusCode == 409) {
        ///Already added in server
        final Database db = await initializeDB(context);
        INV1Model model = INV1Model.fromJson(jsonDecode(res.body));
        var x = await db.update("INV1", model.toJson(),
            where: "TransId = ? AND RowId = ?",
            whereArgs: [model.TransId, model.RowId]);
        print(x.toString());
      } else if (res.statusCode == 201 || res.statusCode == 500) {
        sentSuccessInServer = true;
        if (res.statusCode == 201) {
          final Database db = await initializeDB(context);
          map["has_updated"] = 0;
          var x = await db.update("INV1", map,
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
