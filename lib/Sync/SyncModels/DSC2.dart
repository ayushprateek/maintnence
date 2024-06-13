import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

List<DSC2Model> DSC2ModelFromJson(String str) =>
    List<DSC2Model>.from(json.decode(str).map((x) => DSC2Model.fromJson(x)));

String DSC2ModelToJson(List<DSC2Model> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DSC2Model {
  DSC2Model({
    this.ID,
    this.TransId,
    this.RowId,
    this.ItemCode,
    this.ItemName,
    this.Quantity,
    this.OpenQty,
    this.UOM,
    this.DelDueDate,
    this.InvoiceQty,
    this.ShipToAddress,
    this.CollectCash = false,
    this.LineStatus,
    this.CreateDate,
    this.UpdateDate,
    this.hasCreated = false,
    this.hasUpdated = false,
    this.IsSelected,
    this.enableCheckbox = true,
    this.TransferredQty,
    this.DocEntry,
    this.DocNum,
    this.PermanentTransId,
  });

  int? ID;
  String? TransId;
  String? PermanentTransId;
  double? InvoiceQty;
  int? RowId;
  String? ItemCode;
  String? ItemName;
  double? Quantity;
  double? OpenQty;
  double? TransferredQty;
  String? UOM;
  DateTime? DelDueDate;
  String? ShipToAddress;
  bool CollectCash;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  bool hasCreated;
  bool hasUpdated;
  String? LineStatus;
  bool? IsSelected;
  bool checked = false, enableCheckbox;
  int? DocEntry;
  String? DocNum;

  factory DSC2Model.fromJson(Map<String, dynamic> json) => DSC2Model(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        TransId: json["TransId"] ?? "",
        PermanentTransId: json["PermanentTransId"] ?? "",
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasUpdated: json['has_updated'] == 1,
        hasCreated: json['has_created'] == 1,
        RowId: int.tryParse(json["RowId"].toString()) ?? 0,
        ItemCode: json["ItemCode"] ?? "",
        InvoiceQty: double.tryParse(json['InvoiceQty'].toString()) ?? 0.0,
        ItemName: json["ItemName"] ?? "",
        TransferredQty:
            double.tryParse(json["TransferredQty"].toString()) ?? 0.0,
        Quantity: double.tryParse(json["Quantity"].toString()) ?? 0.0,
        OpenQty: double.tryParse(json["OpenQty"].toString()) ?? 0.0,
        UOM: json["UOM"] ?? "",
        DelDueDate: DateTime.tryParse(json["DelDueDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        ShipToAddress: json["ShipToAddress"] ?? "",
        CollectCash: json["CollectCash"] is bool
            ? json["CollectCash"]
            : json["CollectCash"] == 1,
        LineStatus: json["LineStatus"] ?? "",
        enableCheckbox: json["LineStatus"] != 'Close',
        IsSelected: json['IsSelected'] is bool
            ? json['IsSelected']
            : json['IsSelected'] == 1,
        DocEntry: json['DocEntry'],
        DocNum: json['DocNum'],
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "CreateDate": CreateDate?.toIso8601String(),
        "UpdateDate": UpdateDate?.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "has_updated": hasUpdated ? 1 : 0,
        "TransferredQty": TransferredQty,
        "PermanentTransId": PermanentTransId,
        "TransId": TransId,
        "RowId": RowId,
        "ItemCode": ItemCode,
        'InvoiceQty': InvoiceQty,
        "ItemName": ItemName,
        "Quantity": Quantity,
        "OpenQty": OpenQty,
        "UOM": UOM,
        "DelDueDate": DelDueDate?.toIso8601String(),
        "ShipToAddress": ShipToAddress,
        "CollectCash": CollectCash,
        "LineStatus": LineStatus,
        'IsSelected': IsSelected,
        'DocEntry': DocEntry,
        'DocNum': DocNum,
      };

// Future<void> updateDSC2({required String str, List l}) async {
//   final db = await initializeDB(null);
//   try {
//     db.transaction((db) async {
//       await db.update("DSC2", this.toJson(), where: str, whereArgs: l);
//     });
//   } catch (e) {
//     writeToLogFile(
//         text: e.toString(),
//         fileName: StackTrace.current.toString(),
//         lineNo: 141);
//     getErrorSnackBar("Sync Error " + e.toString());
//   }
// }
}

Future<List<DSC2Model>> dataSyncDSC2() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "DSC2" + postfix));
  print(res.body);
  return DSC2ModelFromJson(res.body);
}

// Future<void> insertDSC2(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteDSC2(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncDSC2();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('DSC2_Temp', customer.toJson());
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
//       "SELECT * FROM  DSC2_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("DSC2", element,
//         where: "RowId = ? AND TransId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["RowId"], element["TransId"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from DSC2_Temp where TransId || RowId not in (Select TransId || RowId from DSC2)");
//   v.forEach((element) {
//     batch3.insert('DSC2', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('DSC2_Temp');
// }

Future<void> insertDSC2(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteDSC2(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncDSC2();
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
      for (DSC2Model record in batchRecords) {
        try {
          batch.insert('DSC2_Temp', record.toJson());
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
			select * from DSC2_Temp
			except
			select * from DSC2
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
          batch.update("DSC2", element,
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
  print('Time taken for DSC2 update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from DSC2_Temp where TransId || RowId not in (Select TransId || RowId from DSC2)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM DSC2_Temp T0
LEFT JOIN DSC2 T1 ON T0.TransId = T1.TransId AND T0.RowId = T1.RowId
WHERE T1.TransId IS NULL AND T1.RowId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('DSC2', record);
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
      'Time taken for DSC2_Temp and DSC2 compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('DSC2_Temp');
  // stopwatch.stop();
}

Future<List<DSC2Model>> retrieveDSC2(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('DSC2');
  return queryResult.map((e) => DSC2Model.fromJson(e)).toList();
}

Future<void> deleteDSC2(Database db) async {
  await db.delete('DSC2');
}

//SEND DATA TO SERVER
//--------------------------
Future<List<DSC2Model>> retrieveDSC2ById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('DSC2', where: str, whereArgs: l);
  return queryResult.map((e) => DSC2Model.fromJson(e)).toList();
}

Future<void> insertDSC2ToServer(BuildContext? context,
    {String? TransId, int? ID}) async {
  String response = "";
  List<DSC2Model> list = await retrieveDSC2ById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "TransId = ? AND ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, ID]);
  if (TransId != null) {
    //only single entry
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "DSC2/Add"),
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
            .post(Uri.parse(prefix + "DSC2/Add?$queryParams"),
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
          DSC2Model model = DSC2Model.fromJson(jsonDecode(res.body));
          var x = await db.update("DSC2", model.toJson(),
              where: "TransId = ? AND RowId = ?",
              whereArgs: [model.TransId, model.RowId]);
          print(x.toString());
        } else if (res.statusCode == 201 || res.statusCode == 500) {
          sentSuccessInServer = true;
          if (res.statusCode == 201) {
            map['ID'] = jsonDecode(res.body)['ID'];
            final Database db = await initializeDB(context);
            map["has_created"] = 0;
            var x = await db.update("DSC2", map,
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

Future<void> updateDSC2OnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<DSC2Model> list = await retrieveDSC2ById(
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
          .put(Uri.parse(prefix + 'DSC2/Update'),
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
          var x = await db.update("DSC2", map,
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
