import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';

import 'package:sqflite/sqlite_api.dart';

List<CRD2Model> CRD2ModelFromJson(String str) =>
    List<CRD2Model>.from(json.decode(str).map((x) => CRD2Model.fromJson(x)));

String CRD2ModelToJson(List<CRD2Model> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CRD2Model {
  CRD2Model({
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
    required this.RouteCode,
    required this.RouteName,
    required this.ShopSize,
    required this.CreateDate,
    required this.UpdateDate,
    this.hasCreated = false,
    this.ShopSizeUom,
    this.Name,
  });

  int ID;
  int ShopSize;
  String Code;

  ///TO BE USED FOR DEVELOPMENT PURPOSE ONLY
  String? Name;
  int RowId;
  DateTime CreateDate;
  String? ShopSizeUom;
  DateTime UpdateDate;
  bool hasCreated;
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
  String RouteCode;
  String RouteName;

  factory CRD2Model.fromJson(Map<String, dynamic> json) => CRD2Model(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] == 1,
        ShopSize: int.tryParse(json["ShopSize"].toString()) ?? 0,
        Name: json["Name"] ?? "",
        Code: json["Code"] ?? "",
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
        RouteCode: json["RouteCode"] ?? "",
        ShopSizeUom: json["ShopSizeUom"] ?? "",
        RouteName: json["RouteName"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "ShopSizeUom": ShopSizeUom,
        "Code": Code,
        "RowId": RowId,
        "AddressCode": AddressCode,
        "Address": Address,
        "CreateDate": CreateDate.toIso8601String(),
        "UpdateDate": UpdateDate.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "CityCode": CityCode,
        "CityName": CityName,
        "StateCode": StateCode,
        "StateName": StateName,
        "CountryCode": CountryCode,
        "CountryName": CountryName,
        "Latitude": Latitude,
        "Longitude": Longitude,
        "RouteCode": RouteCode,
        "RouteName": RouteName,
      };
}

Future<List<CRD2Model>> dataSyncCRD2() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "CRD2" + postfix));
  print(res.body);
  return CRD2ModelFromJson(res.body);
}

// Future<void> insertCRD2(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteCRD2(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncCRD2();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('CRD2_Temp', customer.toJson());
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
//       "SELECT * FROM  CRD2_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("CRD2", element,
//         where:
//             "RowId = ? AND Code = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["RowId"], element["Code"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from CRD2_Temp where Code || RowId not in (Select Code || RowId from CRD2)");
//   print(v.runtimeType);
//   v.forEach((element) {
//     print(element);
//     batch3.insert('CRD2', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('CRD2_Temp');
// }

Future<void> insertCRD2(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteCRD2(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncCRD2();
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
      for (CRD2Model record in batchRecords) {
        try {
          batch.insert('CRD2_Temp', record.toJson());
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
			select * from CRD2_Temp
			except
			select * from CRD2
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
          batch.update("CRD2", element,
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
  print('Time taken for CRD2 update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from CRD2_Temp where Code || RowId not in (Select Code || RowId from CRD2)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM CRD2_Temp T0
LEFT JOIN CRD2 T1 ON T0.Code = T1.Code AND T0.RowId = T1.RowId
WHERE T1.Code IS NULL AND T1.RowId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('CRD2', record);
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
      'Time taken for CRD2_Temp and CRD2 compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('CRD2_Temp');
  // stopwatch.stop();
}

Future<List<CRD2Model>> retrieveCRD2(BuildContext context, {int? limit}) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('CRD2', limit: limit);
  return queryResult.map((e) => CRD2Model.fromJson(e)).toList();
}

Future<void> updateCRD2(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update("CRD2", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteCRD2(Database db) async {
  await db.delete('CRD2');
}

//SEND DATA TO SERVER
//--------------------------
Future<List<CRD2Model>> retrieveCRD2ById(
    BuildContext? context, String str, List l,
    {int? limit}) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('CRD2', where: str, whereArgs: l, limit: limit);
  return queryResult.map((e) => CRD2Model.fromJson(e)).toList();
}

// Future<List<CRD2Model>> retrieveMapDataForVisitPlan() async {
//   final Database db = await initializeDB(null);
//   final List<Map<String, Object?>> queryResult = await db.rawQuery(
//       "SELECT T2.Latitude,T2.Longitude,T1.ID,T1.Code,T2.FirstName || T2. MiddleName || T2.LastName as Name,T1.RouteCode FROM CRD2 T1 INNER JOIN OCRD T2 ON T1.Code=T2.Code  WHERE T2.Active=1 AND T2.Latitude <> ''  AND T2.Longitude <> '' AND T1.RouteCode='${GeneralData.RouteCode}' LIMIT 20");
//   return queryResult.map((e) => CRD2Model.fromJson(e)).toList();
// }

Future<void> insertCRD2ToServer(BuildContext? context,
    {String? TransId, int? id}) async {
  String response = "";
  List<CRD2Model> list = await retrieveCRD2ById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "TransId = ? AND ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);

  if (TransId != null) {
    //only single entry
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "CRD2/Add"),
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
        String queryParams='Code=${list[i].Code}&RowId=${list[i].RowId}';
        var res = await http
            .post(Uri.parse(prefix + "CRD2/Add?$queryParams"),
            headers: header, body: jsonEncode(map))
            .timeout(Duration(seconds: 30), onTimeout: () {
          writeToLogFile(
              text: '500 error \nMap : $map', fileName: StackTrace.current.toString(), lineNo: 141);return http.Response('Error', 500);
        });
        response = await res.body;

        print("status");
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
          CRD2Model model=CRD2Model.fromJson(jsonDecode(res.body));
          var x = await db.update("CRD2", model.toJson(),
              where: "Code = ? AND RowId = ?", whereArgs: [model.Code,model.RowId]);
          print(x.toString());
        }
        else
        if (res.statusCode == 201 || res.statusCode == 500) {
          sentSuccessInServer = true;
          if (res.statusCode == 201) {
            map['ID'] = jsonDecode(res.body)['ID'];
            final Database db = await initializeDB(context);
            map["has_created"] = 0;
            var x = await db.update("CRD2", map,
                where: "Code = ? AND RowId = ?",
                whereArgs: [map["Code"], map["RowId"]]);
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

Future<void> updateCRD2OnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<CRD2Model> list = await retrieveCRD2ById(
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
          .put(Uri.parse(prefix + 'CRD2/Update'),
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
          var x = await db.update("CRD2", map,
              where: "Code = ? AND RowId = ?",
              whereArgs: [map["Code"], map["RowId"]]);
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
