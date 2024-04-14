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

class ITMP {
  int? ID;
  String? PriceListCode;
  String? CurrencyCode;
  bool? Active;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  String? CreatedBy;
  String? BranchId;
  String? UpdatedBy;
  String? PriceListName;

  ITMP({
    this.ID,
    this.PriceListCode,
    this.CurrencyCode,
    this.Active,
    this.CreateDate,
    this.UpdateDate,
    this.CreatedBy,
    this.BranchId,
    this.UpdatedBy,
    this.PriceListName,
  });

  factory ITMP.fromJson(Map<String, dynamic> json) =>
      ITMP(
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        PriceListCode: json['PriceListCode'],
        CurrencyCode: json['CurrencyCode'],
        Active: json['Active'] is bool ? json['Active'] : json['Active'] == 1,
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()),
        CreatedBy: json['CreatedBy'],
        BranchId: json['BranchId'],
        UpdatedBy: json['UpdatedBy'],
        PriceListName: json['PriceListName'],
      );

  Map<String, dynamic> toJson() =>
      {
        'ID': ID,
        'PriceListCode': PriceListCode,
        'CurrencyCode': CurrencyCode,
        'Active': Active,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'CreatedBy': CreatedBy,
        'BranchId': BranchId,
        'UpdatedBy': UpdatedBy,
        'PriceListName': PriceListName,
      };
}

List<ITMP> iTMPFromJson(String str) =>
    List<ITMP>.from(json.decode(str).map((x) => ITMP.fromJson(x)));

String iTMPToJson(List<ITMP> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<ITMP>> dataSyncITMP() async {
  var res =
  await http.get(headers: header, Uri.parse(prefix + "ITMP" + postfix));
  print(res.body);
  return iTMPFromJson(res.body);
}

// Future<void> insertITMP(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteITMP(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncITMP();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('ITMP_Temp', customer.toJson());
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
//       "SELECT * FROM  ITMP_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("ITMP", element, where: "ID = ?", whereArgs: [element["ID"]]);
//   });
//   await batch2.commit(noResult: true);
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from ITMP_Temp where ID not in (Select ID from ITMP)");
//   v.forEach((element) {
//     batch3.insert('ITMP', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('ITMP_Temp');
// }

Future<List<ITMP>> retrieveITMPForDisplay({
  String dbQuery='',
  int limit=30
}) async {
  final Database db = await initializeDB(null);
  dbQuery='%$dbQuery%';
  String searchQuery='';

  searchQuery='''
     SELECT * FROM ITMP 
 WHERE Active = 1 AND (PriceListCode LIKE '$dbQuery' OR PriceListName LIKE '$dbQuery') 
 LIMIT $limit
      ''';
  final List<Map<String, Object?>> queryResult = await db.rawQuery(searchQuery);
  return queryResult.map((e) => ITMP.fromJson(e)).toList();
}
Future<void> insertITMP(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteITMP(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncITMP();
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
      for (ITMP record in batchRecords) {
        try {
          batch.insert('ITMP_Temp', record.toJson());
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
			select * from ITMP_Temp
			except
			select * from ITMP
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
          batch.update("ITMP", element,
              where: "ID = ?", whereArgs: [element["ID"]]);
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
  print('Time taken for ITMP update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from ITMP_Temp where ID not in (Select ID from ITMP)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM ITMP_Temp T0
LEFT JOIN ITMP T1 ON T0.ID = T1.ID 
WHERE T1.ID IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('ITMP', record);
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
      'Time taken for ITMP_Temp and ITMP compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('ITMP_Temp');
  // stopwatch.stop();
}

Future<List<ITMP>> retrieveITMP(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('ITMP');
  return queryResult.map((e) => ITMP.fromJson(e)).toList();
}

Future<void> updateITMP(int id, Map<String, dynamic> values,
    BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('ITMP', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deleteITMP(Database db) async {
  await db.delete('ITMP');
}

Future<List<ITMP>> retrieveITMPById(BuildContext? context, String str,
    List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
  await db.query('ITMP', where: str, whereArgs: l);
  return queryResult.map((e) => ITMP.fromJson(e)).toList();
}

Future<void> insertITMPToServer(BuildContext? context,
    {String? TransId, int? id}) async {
  String response = "";
  List<ITMP> list = await retrieveITMPById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "TransId = ? AND ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "ITMP/Add"),
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
        //todo: like others
        var res = await http
            .post(Uri.parse(prefix + "ITMP/Add"),
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
            var x = await db.update("ITMP", map,
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

Future<void> updateITMPOnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<ITMP> list = await retrieveITMPById(
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
          .put(Uri.parse(prefix + 'ITMP/Update'),
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
          var x = await db.update("ITMP", map,
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
