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

List<RTN2Model> RTN2ModelFromJson(String str) =>
    List<RTN2Model>.from(json.decode(str).map((x) => RTN2Model.fromJson(x)));

String RTN2ModelToJson(List<RTN2Model> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RTN2Model {
  RTN2Model({
    this.ID,
    this.TransId,
    this.RowId,
    this.AddressCode,
    this.Address,
    this.CityCode,
    this.CityName,
    this.StateCode,
    this.StateName,
    this.CreateDate,
    this.UpdateDate,
    this.hasCreated = false,
    this.hasUpdated = false,
    this.CountryCode,
    this.CountryName,
    this.BaseObjectCode,
  });

  int? ID;
  String? TransId;
  int? RowId;
  String? AddressCode;
  String? Address;
  String? CityCode;
  String? CityName;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  bool hasCreated;
  bool hasUpdated;
  String? StateCode;
  String? StateName;
  String? CountryCode;
  String? CountryName;
  String? BaseObjectCode;

  factory RTN2Model.fromJson(Map<String, dynamic> json) =>
      RTN2Model(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
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
        AddressCode: json["AddressCode"] ?? "",
        Address: json["Address"] ?? "",
        CityCode: json["CityCode"] ?? "",
        CityName: json["CityName"] ?? "",
        StateCode: json["StateCode"] ?? "",
        StateName: json["StateName"] ?? "",
        CountryCode: json["CountryCode"] ?? "",
        CountryName: json["CountryName"] ?? "",
        BaseObjectCode: json['BaseObjectCode'] ?? '',
      );

  Map<String, dynamic> toJson() =>
      {
        "ID": ID,
        "TransId": TransId,
        "RowId": RowId,
        "AddressCode": AddressCode,
        "Address": Address,
        "CityCode": CityCode,
        "CityName": CityName,
        "CreateDate": CreateDate?.toIso8601String(),
        "UpdateDate": UpdateDate?.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "has_updated": hasUpdated ? 1 : 0,
        "StateCode": StateCode,
        "StateName": StateName,
        "CountryCode": CountryCode,
        "CountryName": CountryName,
        'BaseObjectCode': BaseObjectCode,
      };
}

Future<List<RTN2Model>> dataSyncRTN2() async {
  var res =
  await http.get(headers: header, Uri.parse(prefix + "RTN2" + postfix));
  print(res.body);
  return RTN2ModelFromJson(res.body);
}

Future<List<RTN2Model>> retrieveRTN2(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('RTN2');
  return queryResult.map((e) => RTN2Model.fromJson(e)).toList();
}

Future<void> updateRTN2(int id, Map<String, dynamic> values,
    BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update("RTN2", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteRTN2(Database db) async {
  await db.delete('RTN2');
}

// Future<void> insertRTN2(Database db)async{
//   if(postfix.toLowerCase().contains("all"))
//   await deleteRTN2(db);
//   List customers= await dataSyncRTN2();
//   print(customers);
//   var batch = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try
//     {
//       batch.insert('RTN2', customer.toJson());
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
//   //       await db.insert('RTN2', customer.toJson());
//   //     });
//   //   }
//   //   catch(e)
//   //   {
//   //     getErrorSnackBar("Sync Error "+e.toString());
//   //   }
//   //
//   // });
// }
// Future<void> insertRTN2(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteRTN2(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncRTN2();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('RTN2_Temp', customer.toJson());
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
//       "SELECT * FROM  RTN2_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("RTN2", element,
//         where: "RowId = ? AND TransId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["RowId"], element["TransId"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from RTN2_Temp where TransId || RowId not in (Select TransId || RowId from RTN2)");
//   v.forEach((element) {
//     batch3.insert('RTN2', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('RTN2_Temp');
// }
Future<void> insertRTN2(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteRTN2(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncRTN2();
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
      for (RTN2Model record in batchRecords) {
        try {
          batch.insert('RTN2_Temp', record.toJson());
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
			select * from RTN2_Temp
			except
			select * from RTN2
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
          batch.update("RTN2", element,
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
  print('Time taken for RTN2 update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from RTN2_Temp where TransId || RowId not in (Select TransId || RowId from RTN2)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM RTN2_Temp T0
LEFT JOIN RTN2 T1 ON T0.TransId = T1.TransId AND T0.RowId = T1.RowId
WHERE T1.TransId IS NULL AND T1.RowId IS NULL;
''');for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('RTN2', record);
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
      'Time taken for RTN2_Temp and RTN2 compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('RTN2_Temp');
  // stopwatch.stop();
}

//SEND DATA TO SERVER
//--------------------------
Future<List<RTN2Model>> retrieveRTN2ById(BuildContext? context, String str,
    List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
  await db.query('RTN2', where: str, whereArgs: l);
  return queryResult.map((e) => RTN2Model.fromJson(e)).toList();
}

Future<void> insertRTN2ToServer(BuildContext? context,
    {String? TransId, int? ID}) async {
  String response = "";
  List<RTN2Model> list = await retrieveRTN2ById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "TransId = ? AND ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, ID]);
  // List<RTN2Model> list = await retrieveRTN2(context!);
  print(list.length);
  if (TransId != null) {
    //only single entry
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "RTN2/Add"),
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
        var res = await http.post(Uri.parse(prefix + "RTN2/Add?$queryParams"),
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
          RTN2Model model=RTN2Model.fromJson(jsonDecode(res.body));
          var x = await db.update("RTN2", model.toJson(),
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
            var x = await db.update("RTN2", map,
                where: "TransId = ? AND RowId = ?",
                whereArgs: [map["TransId"], map["RowId"]]);
            print(x.toString());
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

Future<void> updateRTN2OnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<RTN2Model> list = await retrieveRTN2ById(
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
          .put(Uri.parse(prefix + 'RTN2/Update'),
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
          var x = await db.update("RTN2", map,
              where: "TransId = ? AND RowId = ?",
              whereArgs: [map["TransId"], map["RowId"]]);
          print(x.toString());
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
