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

class Supplier {
  int? ID;
  String? Name;
  String? Address;
  double? Balance;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  String? BizId;
  int? hasCreated;
  int? hasUpdated;

  Supplier({
    this.ID,
    this.Name,
    this.Address,
    this.Balance,
    this.CreateDate,
    this.UpdateDate,
    this.BizId,
    this.hasCreated,
    this.hasUpdated,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) =>
      Supplier(
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        Name: json['Name'] ?? '',
        Address: json['Address'] ?? '',
        Balance: double.tryParse(json['Balance'].toString()) ?? 0.0,
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()) ??
            DateTime.parse('1900-01-01'),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()) ??
            DateTime.parse('1900-01-01'),
        BizId: json['BizId'] ?? '',
        hasCreated: int.tryParse(json['has_created'].toString()) ?? 0,
        hasUpdated: int.tryParse(json['has_updated'].toString()) ?? 0,
      );

  Map<String, dynamic> toJson() =>
      {
        'ID': ID,
        'Name': Name,
        'Address': Address,
        'Balance': Balance,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'BizId': BizId,
        'has_created': hasCreated,
        'has_updated': hasUpdated,
      };
}

List<Supplier> supplierFromJson(String str) =>
    List<Supplier>.from(json.decode(str).map((x) => Supplier.fromJson(x)));

String supplierToJson(List<Supplier> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<Supplier>> dataSyncSupplier() async {
  var res =
  await http.get(headers: header, Uri.parse(prefix + "Supplier" + postfix));
  print(res.body);
  return supplierFromJson(res.body);
}

// Future<void> insertSupplier(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteSupplier(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncSupplier();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('Supplier_Temp', customer.toJson());
//     } catch (e) {
//       writeToLogFile(
//           text: e.toString(),
//           fileName: StackTrace.current.toString(),
//           lineNo: 141);
//       getErrorSnackBar('Sync Error ' + e.toString());
//     }
//   });
//   await batch1.commit(noResult: true);
//   var u = await db.rawQuery(
//       "SELECT * FROM  Supplier_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("Supplier", element,
//         where: "RowId = ? AND TransId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["RowId"], element["TransId"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from Supplier_Temp where TransId || RowId not in (Select TransId || RowId from Supplier)");
//   v.forEach((element) {
//     batch3.insert('Supplier', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('Supplier_Temp');
// }
Future<void> insertSupplier(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteSupplier(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncSupplier();
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
      for (Supplier record in batchRecords) {
        try {
          batch.insert('Supplier_Temp', record.toJson());
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
			select * from Supplier_Temp
			except
			select * from Supplier
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
          batch.update("Supplier", element,
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
  print('Time taken for Supplier update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from Supplier_Temp where TransId || RowId not in (Select TransId || RowId from Supplier)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM Supplier_Temp T0
LEFT JOIN Supplier T1 ON T0.TransId = T1.TransId AND T0.RowId = T1.RowId
WHERE T1.TransId IS NULL AND T1.RowId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('Supplier', record);
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
      'Time taken for Supplier_Temp and Supplier compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('Supplier_Temp');
  // stopwatch.stop();
}

Future<List<Supplier>> retrieveSupplier(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('Supplier');
  return queryResult.map((e) => Supplier.fromJson(e)).toList();
}

Future<void> updateSupplier(int id, Map<String, dynamic> values,
    BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('Supplier', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deleteSupplier(Database db) async {
  await db.delete('Supplier');
}

Future<List<Supplier>> retrieveSupplierById(BuildContext? context, String str,
    List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
  await db.query('Supplier', where: str, whereArgs: l);
  return queryResult.map((e) => Supplier.fromJson(e)).toList();
}

Future<void> insertSupplierToServer(BuildContext? context,
    {String? TransId, int? id}) async {
  String response = "";
  List<Supplier> list = await retrieveSupplierById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "TransId = ? AND ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "Supplier/Add"),
        headers: header, body: jsonEncode(list[0].toJson()));
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
        var res = await http
            .post(Uri.parse(prefix + "Supplier/Add"),
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
        if (res.statusCode == 201 || res.statusCode == 500) {
          sentSuccessInServer = true;
          if (res.statusCode == 201) {
            map['ID'] = jsonDecode(res.body)['ID'];
            final Database db = await initializeDB(context);
            map = jsonDecode(res.body);
            map["has_created"] = 0;
            var x = await db.update("Supplier", map,
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

Future<void> updateSupplierOnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<Supplier> list = await retrieveSupplierById(
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
          .put(Uri.parse(prefix + 'Supplier/Update'),
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
          var x = await db.update("Supplier", map,
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
