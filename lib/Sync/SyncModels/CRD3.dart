import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

List<CRD3Model> CRD3ModelFromJson(String str) =>
    List<CRD3Model>.from(json.decode(str).map((x) => CRD3Model.fromJson(x)));

String CRD3ModelToJson(List<CRD3Model> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CRD3Model {
  CRD3Model({
    required this.ID,
    required this.Code,
    required this.RowId,
    required this.AddressCode,
    required this.Address,
    required this.CityCode,
    required this.CityName,
    required this.StateCode,
    required this.StateName,
    required this.CountryCode,
    required this.CountryName,
    required this.Latitude,
    required this.Longitude,
    required this.CreateDate,
    required this.UpdateDate,
    this.hasCreated = false,
  });

  int ID;
  String Code;
  int RowId;
  String AddressCode;
  String Address;
  String CityCode;
  String CityName;
  String StateCode;
  String StateName;
  String CountryCode;
  String CountryName;
  String Latitude;
  String Longitude;
  DateTime CreateDate;
  DateTime UpdateDate;
  bool hasCreated;

  factory CRD3Model.fromJson(Map<String, dynamic> json) => CRD3Model(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        Code: json["Code"] ?? "",
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] == 1,
        RowId: int.tryParse(json["RowId"].toString()) ?? 0,
        AddressCode: json["AddressCode"] ?? "",
        Address: json["Address"] ?? "",
        CityCode: json["CityCode"] ?? "",
        CityName: json["CityName"] ?? "",
        StateCode: json["StateCode"] ?? "",
        StateName: json["StateName"] ?? "",
        CountryCode: json["CountryCode"] ?? "",
        CountryName: json["CountryName"] ?? "",
        Latitude: json["Latitude"] ?? "",
        Longitude: json["Longitude"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "Code": Code,
        "CreateDate": CreateDate.toIso8601String(),
        "UpdateDate": UpdateDate.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "RowId": RowId,
        "AddressCode": AddressCode,
        "Address": Address,
        "CityCode": CityCode,
        "CityName": CityName,
        "StateCode": StateCode,
        "StateName": StateName,
        "CountryCode": CountryCode,
        "CountryName": CountryName,
        "Latitude": Latitude,
        "Longitude": Longitude,
      };
}

Future<List<CRD3Model>> dataSyncCRD3() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "CRD3" + postfix));
  print(res.body);
  return CRD3ModelFromJson(res.body);
}

// Future<void> insertCRD3(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteCRD3(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncCRD3();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('CRD3_Temp', customer.toJson());
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
//       "SELECT * FROM  CRD3_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("CRD3", element,
//         where:
//             "RowId = ? AND Code = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["RowId"], element["Code"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//
//   var v = await db.rawQuery(
//       "Select * from CRD3_Temp where Code || RowId not in (Select Code || RowId from CRD3)");
//   print(v.runtimeType);
//   v.forEach((element) {
//     print(element);
//     batch3.insert('CRD3', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('CRD3_Temp');
// }

Future<void> insertCRD3(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteCRD3(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncCRD3();
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
      for (CRD3Model record in batchRecords) {
        try {
          batch.insert('CRD3_Temp', record.toJson());
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
			select * from CRD3_Temp
			except
			select * from CRD3
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
          batch.update("CRD3", element,
              where:
                  "RowId = ? AND Code = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
              whereArgs: [element["RowId"], element["Code"], 1, 1]);
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
  print('Time taken for CRD3 update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from CRD3_Temp where Code || RowId not in (Select Code || RowId from CRD3)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM CRD3_Temp T0
LEFT JOIN CRD3 T1 ON T0.Code = T1.Code AND T0.RowId = T1.RowId
WHERE T1.Code IS NULL AND T1.RowId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('CRD3', record);
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
      'Time taken for CRD3_Temp and CRD3 compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('CRD3_Temp');
  // stopwatch.stop();
}

Future<List<CRD3Model>> retrieveCRD3(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('CRD3');
  return queryResult.map((e) => CRD3Model.fromJson(e)).toList();
}

Future<void> updateCRD3(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update("CRD3", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteCRD3(Database db) async {
  await db.delete('CRD3');
}

//SEND DATA TO SERVER
//--------------------------
Future<List<CRD3Model>> retrieveCRD3ById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('CRD3', where: str, whereArgs: l);
  return queryResult.map((e) => CRD3Model.fromJson(e)).toList();
}

Future<void> insertCRD3ToServer(BuildContext? context,
    {String? TransId, int? id}) async {
  String response = "";
  List<CRD3Model> list = await retrieveCRD3ById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "TransId = ? AND ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);

  if (TransId != null) {
    //only single entry
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "CRD3/Add"),
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
        String queryParams = 'Code=${list[i].Code}&RowId=${list[i].RowId}';
        var res = await http
            .post(Uri.parse(prefix + "CRD3/Add?$queryParams"),
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
          CRD3Model model = CRD3Model.fromJson(jsonDecode(res.body));
          map["ID"] = model.ID;
          map["has_created"] = 0;
          var x = await db.update("CRD3", map,
              where: "Code = ? AND RowId = ?",
              whereArgs: [model.Code, model.RowId]);
          print(x.toString());
        } else if (res.statusCode == 201 || res.statusCode == 500) {
          sentSuccessInServer = true;
          if (res.statusCode == 201) {
            map['ID'] = jsonDecode(res.body)['ID'];
            final Database db = await initializeDB(context);
            map["has_created"] = 0;
            var x = await db.update("CRD3", map,
                where: "Code = ? AND RowId = ?",
                whereArgs: [map["Code"], map["RowId"]]);
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

Future<void> updateCRD3OnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<CRD3Model> list = await retrieveCRD3ById(
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
          .put(Uri.parse(prefix + 'CRD3/Update'),
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
          var x = await db.update("CRD3", map,
              where: "Code = ? AND RowId = ?",
              whereArgs: [map["Code"], map["RowId"]]);
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
