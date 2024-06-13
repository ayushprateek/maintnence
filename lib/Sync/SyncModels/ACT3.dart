import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/AppConfig.dart';
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/Component/UploadImageToServer.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

List<ACT3Model> ACT3ModelFromJson(String str) =>
    List<ACT3Model>.from(json.decode(str).map((x) => ACT3Model.fromJson(x)));

String ACT3ModelToJson(List<ACT3Model> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ACT3Model {
  ACT3Model({
    required this.ID,
    required this.TransId,
    required this.RowId,
    required this.DocName,
    required this.DocPath,
    required this.Remarks,
    required this.CreateDate,
    required this.UpdateDate,
    this.hasCreated = false,
    this.hasUpdated = false,
    this.isAddedToDB = true,
    this.isHeader = true,
    this.DocEntry,
    this.DocNum,
  });

  int ID;
  int RowId;
  String TransId;
  String DocName;
  String Remarks;
  String DocPath;

  DateTime CreateDate;
  DateTime? UpdateDate;
  bool hasCreated;
  bool hasUpdated;
  bool isAddedToDB;
  bool isHeader;
  int? DocEntry;
  String? DocNum;

  factory ACT3Model.fromJson(Map<String, dynamic> json) => ACT3Model(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] == 1,
        hasUpdated: json['has_updated'] == 1,
        isHeader: json['is_header'] == 1,
        RowId: int.tryParse(json["RowId"].toString()) ?? 0,
        TransId: json["TransId"] ?? "",
        Remarks: json["Remarks"] ?? "",
        DocName: json["DocName"] ?? "",
        DocPath: json["DocPath"] ?? "",
        DocEntry: json['DocEntry'],
        DocNum: json['DocNum'],
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "TransId": TransId,
        "RowId": RowId,
        "DocName": DocName,
        "is_header": isHeader ? 1 : 0,
        "DocPath": DocPath,
        "CreateDate": CreateDate.toIso8601String(),
        "UpdateDate": UpdateDate?.toIso8601String(),
        "has_updated": hasUpdated ? 1 : 0,
        "has_created": hasCreated ? 1 : 0,
        "Remarks": Remarks,
        'DocEntry': DocEntry,
        'DocNum': DocNum,
      };
}

Future<List<ACT3Model>> dataSyncACT3() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "ACT3" + postfix));
  print(res.body);
  return ACT3ModelFromJson(res.body);
}

// Future<void> insertACT3(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteACT3(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncACT3();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('ACT3_Temp', customer.toJson());
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
//       "SELECT * FROM  ACT3_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("ACT3", element,
//         where:
//             "RowId = ? AND TransId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["RowId"], element["TransId"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from ACT3_Temp where TransId || RowId not in (Select TransId || RowId from ACT3)");
//   v.forEach((element) {
//     batch3.insert('ACT3', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('ACT3_Temp');
// }

Future<void> insertACT3(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteACT3(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncACT3();
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
      for (ACT3Model record in batchRecords) {
        try {
          batch.insert('ACT3_Temp', record.toJson());
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
			select * from ACT3_Temp
			except
			select * from ACT3
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
          batch.update("ACT3", record,
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
  print('Time taken for ACT3 update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery(
  //     "Select * from ACT3_Temp where TransId || RowId not in (Select TransId || RowId from ACT3)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM ACT3_Temp T0
LEFT JOIN ACT3 T1 ON T0.TransId = T1.TransId AND T0.RowId = T1.RowId
WHERE T1.TransId IS NULL AND T1.RowId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('ACT3', record);
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
      'Time taken for ACT3_Temp and ACT3 compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('ACT3_Temp');
  // stopwatch.stop();
}

Future<List<ACT3Model>> retrieveACT3(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('ACT3');
  return queryResult.map((e) => ACT3Model.fromJson(e)).toList();
}

Future<void> updateACT3(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update("ACT3", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteACT3(Database db) async {
  await db.delete('ACT3');
}

//SEND DATA TO SERVER
//--------------------------
Future<List<ACT3Model>> retrieveACT3ById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('ACT3', where: str, whereArgs: l);
  return queryResult.map((e) => ACT3Model.fromJson(e)).toList();
}

Future<void> insertACT3ToServer(BuildContext? context,
    {String? TransId, int? id}) async {
  String response = "";
  List<ACT3Model> list = await retrieveACT3ById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "TransId = ? AND ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    //only single entry
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "ACT3/Add"),
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
        if (list[i].DocPath.contains(appPkg)) {
          File imageFile = File(list[i].DocPath);
          String url =
              await uploadImageToServer(imageFile, null, setURL: (url) {
            print(url);
          });

          //todo:
          // list[i].DocPath = prefix + url;
        }
        map.remove('ID');
        String queryParams =
            'TransId=${list[i].TransId}&RowId=${list[i].RowId}';
        var res = await http
            .post(Uri.parse(prefix + "ACT3/Add?$queryParams"),
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
          ACT3Model model = ACT3Model.fromJson(jsonDecode(res.body));
          map["ID"] = model.ID;
          map["has_created"] = 0;
          var x = await db.update("ACT3", map,
              where: "TransId = ? AND RowId = ?",
              whereArgs: [model.TransId, model.RowId]);
          print(x.toString());
        } else if (res.statusCode == 201 || res.statusCode == 500) {
          sentSuccessInServer = true;
          if (res.statusCode == 201) {
            map['ID'] = jsonDecode(res.body)['ID'];
            final Database db = await initializeDB(context);
            // map = jsonDecode(res.body);
            map["has_created"] = 0;

            var x = await db.update("ACT3", map,
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

Future<void> updateACT3OnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<ACT3Model> list = await retrieveACT3ById(
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
          .put(Uri.parse(prefix + 'ACT3/Update'),
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
          var x = await db.update("ACT3", map,
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
