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

class OUDP {
  int? ID;
  String? Code;
  String? Name;
  String? Remarks;
  String? CreatedBy;
  bool? Active;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  String? UpdatedBy;
  String? BranchId;

  OUDP({
    this.ID,
    this.Code,
    this.Name,
    this.Remarks,
    this.CreatedBy,
    this.Active,
    this.CreateDate,
    this.UpdateDate,
    this.UpdatedBy,
    this.BranchId,
  });

  factory OUDP.fromJson(Map<String, dynamic> json) =>
      OUDP(
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        Code: json['Code'] ?? '',
        Name: json['Name'] ?? '',
        Remarks: json['Remarks'] ?? '',
        CreatedBy: json['CreatedBy'] ?? '',
        Active: json['Active'] is bool ? json['Active'] : json['Active'] == 1,
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()) ??
            DateTime.parse('1900-01-01'),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()) ??
            DateTime.parse('1900-01-01'),
        UpdatedBy: json['UpdatedBy'] ?? '',
        BranchId: json['BranchId'] ?? '',
      );

  Map<String, dynamic> toJson() =>
      {
        'ID': ID,
        'Code': Code,
        'Name': Name,
        'Remarks': Remarks,
        'CreatedBy': CreatedBy,
        'Active': Active,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'UpdatedBy': UpdatedBy,
        'BranchId': BranchId,
      };
}
Future<List<OUDP>> retrieveOUDPForDisplay({
  String dbQuery='',
  int limit=30
}) async {
  final Database db = await initializeDB(null);
  dbQuery='%$dbQuery%';
  String searchQuery='';

  searchQuery='''
     SELECT * FROM OUDP 
 WHERE Active = 1 AND (Code LIKE '$dbQuery' OR Name LIKE '$dbQuery') 
 LIMIT $limit
      ''';
  final List<Map<String, Object?>> queryResult = await db.rawQuery(searchQuery);
  return queryResult.map((e) => OUDP.fromJson(e)).toList();
}
List<OUDP> oUDPFromJson(String str) =>
    List<OUDP>.from(json.decode(str).map((x) => OUDP.fromJson(x)));

String oUDPToJson(List<OUDP> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<OUDP>> dataSyncOUDP() async {
  var res =
  await http.get(headers: header, Uri.parse(prefix + "OUDP" + postfix));
  print(res.body);
  return oUDPFromJson(res.body);
}
Future<List<OUDP>> retrieveOUDPForSearch(
    {required String query, int? limit}) async {
  final Database db = await initializeDB(null);
  query="%$query%";
  String dbQuery="SELECT * FROM OUDP WHERE (Code LIKE '$query' OR Name LIKE '$query')  AND Active=1 LIMIT $limit";
  final List<Map<String, Object?>> queryResult = await db.rawQuery(
      dbQuery);
  return queryResult.map((e) => OUDP.fromJson(e)).toList();
}

// Future<void> insertOUDP(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteOUDP(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncOUDP();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('OUDP_Temp', customer.toJson());
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
//       "SELECT * FROM  OUDP_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("OUDP", element,
//         where: "ID = ? AND Code = ?",
//         whereArgs: [element["ID"], element["Code"]]);
//   });
//   await batch2.commit(noResult: true);
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from OUDP_Temp where Code not in (Select Code from OUDP)");
//   v.forEach((element) {
//     batch3.insert('OUDP', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('OUDP_Temp');
// }
Future<void> insertOUDP(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteOUDP(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncOUDP();
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
      for (OUDP record in batchRecords) {
        try {
          batch.insert('OUDP_Temp', record.toJson());
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
			select * from OUDP_Temp
			except
			select * from OUDP
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
          batch.update("OUDP", element,
              where: "ID = ? AND Code = ?",
              whereArgs: [element["ID"], element["Code"]]);
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
  print('Time taken for OUDP update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from OUDP_Temp where Code not in (Select Code from OUDP)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM OUDP_Temp T0
LEFT JOIN OUDP T1 ON T0.Code = T1.Code 
WHERE T1.Code IS NULL;
''');for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('OUDP', record);
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
      'Time taken for OUDP_Temp and OUDP compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('OUDP_Temp');
  // stopwatch.stop();
}

Future<List<OUDP>> retrieveOUDP(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('OUDP');
  return queryResult.map((e) => OUDP.fromJson(e)).toList();
}

Future<void> updateOUDP(int id, Map<String, dynamic> values,
    BuildContext context) async {
  final db = await initializeDB(context);
  try {
    await db.transaction((db) async {
      await db.update('OUDP', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deleteOUDP(Database db) async {
  await db.delete('OUDP');
}

Future<List<OUDP>> retrieveOUDPById(BuildContext? context, String str,
    List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
  await db.query('OUDP', where: str, whereArgs: l);
  return queryResult.map((e) => OUDP.fromJson(e)).toList();
}

Future<void> insertOUDPToServer(BuildContext? context,
    {String? TransId, int? id}) async {
  String response = "";
  List<OUDP> list = await retrieveOUDPById(
      context,
      TransId == null ? DataSync.getInsertToServerStr() : "Code = ? AND ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "OUDP/Add"),
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
            .post(Uri.parse(prefix + "OUDP/Add"),
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
            var x = await db.update("OUDP", map,
                where: "ID = ? AND Code = ?",
                whereArgs: [map["ID"], map["Code"]]);
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

Future<void> updateOUDPOnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<OUDP> list = await retrieveOUDPById(
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
          .put(Uri.parse(prefix + 'OUDP/Update'),
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
          var x = await db.update("OUDP", map,
              where: "ID = ? AND Code = ?",
              whereArgs: [map["ID"], map["Code"]]);
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
