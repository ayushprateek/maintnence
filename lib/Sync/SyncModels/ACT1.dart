import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

List<ACT1Model> ACT1ModelFromJson(String str) =>
    List<ACT1Model>.from(json.decode(str).map((x) => ACT1Model.fromJson(x)));

String ACT1ModelToJson(List<ACT1Model> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ACT1Model {
  ACT1Model({
    required this.ID,
    required this.TransId,
    required this.RowId,
    required this.Competitor,
    required this.ItemCode,
    required this.ItemName,
    required this.Quantity,
    required this.UOM,
    required this.Price,
    required this.CreateDate,
    required this.UpdateDate,
    this.hasCreated = false,
    this.hasUpdated = false,
    this.DocEntry,
    this.DocNum,
  });

  int ID;
  String TransId;
  int RowId;
  String Competitor;
  String ItemCode;
  String ItemName;
  double Quantity;
  String UOM;
  double Price;
  DateTime CreateDate;
  DateTime UpdateDate;
  bool hasCreated;
  bool hasUpdated;
  int? DocEntry;
  String? DocNum;

  factory ACT1Model.fromJson(Map<String, dynamic> json) => ACT1Model(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        TransId: json["TransId"] ?? "",
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] == 1,
        RowId: int.tryParse(json["RowId"].toString()) ?? 0,
        Competitor: json["Competitor"] ?? "",
        ItemCode: json["ItemCode"] ?? "",
        ItemName: json["ItemName"] ?? "",
        hasUpdated: json['has_updated'] == 1,
        DocEntry: json['DocEntry'],
        DocNum: json['DocNum'],
        Quantity: double.tryParse(json["Quantity"].toString()) ?? 0.0,
        UOM: json["UOM"] ?? "",
        Price: double.tryParse(json["Price"].toString()) ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "TransId": TransId,
        "CreateDate": CreateDate.toIso8601String(),
        "UpdateDate": UpdateDate.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "has_updated": hasUpdated ? 1 : 0,
        'DocEntry': DocEntry,
        'DocNum': DocNum,
        "RowId": RowId,
        "Competitor": Competitor,
        "ItemCode": ItemCode,
        "ItemName": ItemName,
        "Quantity": Quantity,
        "UOM": UOM,
        "Price": Price,
      };
}

Future<List<ACT1Model>> dataSyncACT1() async {
  var res = await http.get(
    headers: header,
    Uri.parse(prefix + "ACT1" + postfix),
  );
  print(res.body);
  return ACT1ModelFromJson(res.body);
}

// Future<void> insertACT1(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteACT1(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncACT1();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('ACT1_Temp', customer.toJson());
//     } catch (e) {
//       writeToLogFile(
//           text: e.toString(),
//           fileName: StackTrace.current.toString(),
//           lineNo: 141);
//       getErrorSnackBar("Sync Error " + e.toString());
//     }
//   });
//   await batch1.commit(noResult: true);
//
//   var u = await db.rawQuery(
//       "SELECT * FROM  ACT1_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN UpdateDate IS NULL THEN createDate ELSE UpdateDate END)");
//   u.forEach((element) {
//     batch2.update("ACT1", element,
//         where:
//             "RowId = ? AND TransId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["RowId"], element["TransId"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//
//   var v = await db.rawQuery(
//       "Select * from ACT1_Temp where TransId || RowId not in (Select TransId || RowId from ACT1)");
//   v.forEach((element) {
//     batch3.insert('ACT1', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('ACT1_Temp');
// }

Future<void> insertACT1(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteACT1(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncACT1();
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
      for (ACT1Model record in batchRecords) {
        try {
          batch.insert('ACT1_Temp', record.toJson());
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
			select * from ACT1_Temp
			except
			select * from ACT1
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
      for (var record in batchRecords) {
        try {
          batch.update("ACT1", record,
              where:
                  "RowId = ? AND TransId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
              whereArgs: [record["RowId"], record["TransId"], 1, 1]);
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
  print('Time taken for ACT1 update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from ACT1_Temp where TransId || RowId not in (Select TransId || RowId from ACT1)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM ACT1_Temp T0
LEFT JOIN ACT1 T1 ON T0.TransId = T1.TransId AND T0.RowId = T1.RowId
WHERE T1.TransId IS NULL AND T1.RowId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('ACT1', record);
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
      'Time taken for ACT1_Temp and ACT1 compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('ACT1_Temp');
  // stopwatch.stop();
}

Future<List<ACT1Model>> retrieveACT1(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('ACT1');
  return queryResult.map((e) {
    return ACT1Model.fromJson(e);
  }).toList();
}

Future<List<ACT1Model>> retrieveACT1ById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('ACT1', where: str, whereArgs: l);
  return queryResult.map((e) => ACT1Model.fromJson(e)).toList();
}

Future<void> updateACT1(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    await db.transaction((db) async {
      await db.update("ACT1", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteACT1(Database db) async {
  await db.delete('ACT1');
}

//SEND DATA TO SERVER
//--------------------------

Future<void> insertACT1ToServer(BuildContext? context,
    {String? TransId, int? id}) async {
  String response = "";
  List<ACT1Model> list = await retrieveACT1ById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "TransId = ? AND ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);

  if (TransId != null) {
    //only single entry
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "ACT1/Add"),
        headers: header, body: jsonEncode(list[0].toJson()));
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
            .post(Uri.parse(prefix + "ACT1/Add?$queryParams"),
                headers: header, body: jsonEncode(map))
            .timeout(Duration(seconds: 30), onTimeout: () {
          writeToLogFile(
              text: '500 error \nMap : $map',
              fileName: StackTrace.current.toString(),
              lineNo: 141);
          return http.Response('Error', 500);
        });
        response = await res.body;

        print("status");
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
          ACT1Model model = ACT1Model.fromJson(jsonDecode(res.body));
          map["ID"] = model.ID;
          map["has_created"] = 0;
          var x = await db.update("ACT1", map,
              where: "TransId = ? AND RowId = ?",
              whereArgs: [model.TransId, model.RowId]);
          print(x.toString());
        } else if (res.statusCode == 201 || res.statusCode == 500) {
          sentSuccessInServer = true;
          if (res.statusCode == 201) {
            map['ID'] = jsonDecode(res.body)['ID'];
            final Database db = await initializeDB(context);
            map["has_created"] = 0;
            var x = await db.update("ACT1", map,
                where: "TransId = ? AND RowId = ?",
                whereArgs: [map["TransId"], map["RowId"]]);
            print(x.toString());
          } else {
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

Future<void> updateACT1OnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<ACT1Model> list = await retrieveACT1ById(
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
          .put(Uri.parse(prefix + 'ACT1/Update'),
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
          var x = await db.update("ACT1", map,
              where: "TransId = ? AND RowId = ?",
              whereArgs: [map["TransId"], map["RowId"]]);
          print(x.toString());
        } else {
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
