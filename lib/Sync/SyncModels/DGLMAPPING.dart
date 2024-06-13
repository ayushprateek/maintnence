import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

class DGLMAPPING {
  String? AcctCode;
  String? AcctName;
  String? UBranch;
  String? UType;
  String? USalesAppDeposit;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  String? CreatedBy;
  String? UpdatedBy;
  String? BranchId;
  bool? Active;
  int? ID;

  DGLMAPPING({
    this.AcctCode,
    this.AcctName,
    this.UBranch,
    this.UType,
    this.USalesAppDeposit,
    this.CreateDate,
    this.UpdateDate,
    this.CreatedBy,
    this.UpdatedBy,
    this.BranchId,
    this.Active,
    this.ID,
  });

  factory DGLMAPPING.fromJson(Map<String, dynamic> json) => DGLMAPPING(
        AcctCode: json['AcctCode'] ?? '',
        AcctName: json['AcctName'] ?? '',
        UBranch: json['U_Branch'] ?? '',
        UType: json['U_Type'] ?? '',
        USalesAppDeposit: json['U_SalesAppDeposit'] ?? '',
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()),
        CreatedBy: json['CreatedBy'] ?? '',
        UpdatedBy: json['UpdatedBy'] ?? '',
        BranchId: json['BranchId']?.toString(),
        Active: json['Active'] is bool ? json['Active'] : json['Active'] == 1,
        ID: int.tryParse(json['ID'].toString()),
      );

  Map<String, dynamic> toJson() => {
        'AcctCode': AcctCode,
        'AcctName': AcctName,
        'U_Branch': UBranch,
        'U_Type': UType,
        'U_SalesAppDeposit': USalesAppDeposit,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'CreatedBy': CreatedBy,
        'UpdatedBy': UpdatedBy,
        'BranchId': BranchId,
        'Active': Active,
        'ID': ID,
      };
}

List<DGLMAPPING> dGLMAPPINGFromJson(String str) =>
    List<DGLMAPPING>.from(json.decode(str).map((x) => DGLMAPPING.fromJson(x)));

String dGLMAPPINGToJson(List<DGLMAPPING> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<DGLMAPPING>> dataSyncDGLMAPPING() async {
  var res = await http.get(
      headers: header, Uri.parse(prefix + "DGLMAPPING" + postfix));
  print(res.body);
  return dGLMAPPINGFromJson(res.body);
}

// Future<void> insertDGLMAPPING(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteDGLMAPPING(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncDGLMAPPING();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('DGLMAPPING_Temp', customer.toJson());
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
//       "SELECT * FROM  DGLMAPPING_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("DGLMAPPING", element,
//         where: "ID = ? AND AcctCode = ?",
//         whereArgs: [element["ID"], element["AcctCode"]]);
//   });
//   await batch2.commit(noResult: true);
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from DGLMAPPING_Temp where AcctCode not in (Select AcctCode from DGLMAPPING)");
//   v.forEach((element) {
//     batch3.insert('DGLMAPPING', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('DGLMAPPING_Temp');
// }

Future<void> insertDGLMAPPING(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteDGLMAPPING(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncDGLMAPPING();
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
      for (DGLMAPPING record in batchRecords) {
        try {
          batch.insert('DGLMAPPING_Temp', record.toJson());
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
			select * from DGLMAPPING_Temp
			except
			select * from DGLMAPPING
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
          batch.update("DGLMAPPING", element,
              where: "ID = ? AND AcctCode = ?",
              whereArgs: [element["ID"], element["AcctCode"]]);
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
  print('Time taken for DGLMAPPING update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from DGLMAPPING_Temp where AcctCode not in (Select AcctCode from DGLMAPPING)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM DGLMAPPING_Temp T0
LEFT JOIN DGLMAPPING T1 ON T0.AcctCode = T1.AcctCode 
WHERE T1.AcctCode IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('DGLMAPPING', record);
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
      'Time taken for DGLMAPPING_Temp and DGLMAPPING compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('DGLMAPPING_Temp');
  // stopwatch.stop();
}

Future<List<DGLMAPPING>> retrieveDGLMAPPING(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('DGLMAPPING');
  return queryResult.map((e) => DGLMAPPING.fromJson(e)).toList();
}

Future<void> updateDGLMAPPING(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    await db.transaction((db) async {
      await db.update('DGLMAPPING', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deleteDGLMAPPING(Database db) async {
  await db.delete('DGLMAPPING');
}

Future<List<DGLMAPPING>> retrieveDGLMAPPINGById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('DGLMAPPING', where: str, whereArgs: l);
  return queryResult.map((e) => DGLMAPPING.fromJson(e)).toList();
}

Future<void> insertDGLMAPPINGToServer(BuildContext? context,
    {String? TransId, int? id}) async {
  String response = "";
  List<DGLMAPPING> list = await retrieveDGLMAPPINGById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "ID = ? AND AcctCode = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "DGLMAPPING/Add"),
        headers: header, body: jsonEncode(list[0].toJson()));
    response = res.body;
  } else if (list.isNotEmpty) {
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
        String queryParams = 'TransId=${list[i].AcctCode}';
        var res = await http
            .post(Uri.parse(prefix + "DGLMAPPING/Add?$queryParams"),
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
          DGLMAPPING model = DGLMAPPING.fromJson(jsonDecode(res.body));
          var x = await db.update("DGLMAPPING", model.toJson(),
              where: "AcctCode = ?", whereArgs: [model.AcctCode]);
          print(x.toString());
        } else if (res.statusCode == 201 || res.statusCode == 500) {
          sentSuccessInServer = true;
          if (res.statusCode == 201) {
            map['ID'] = jsonDecode(res.body)['ID'];
            final Database db = await initializeDB(context);
            // map = jsonDecode(res.body);
            map["has_created"] = 0;
            var x = await db.update("DGLMAPPING", map,
                where: "ID = ? AND AcctCode = ?",
                whereArgs: [map["ID"], map["AcctCode"]]);
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

Future<void> updateDGLMAPPINGOnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<DGLMAPPING> list = await retrieveDGLMAPPINGById(
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
          .put(Uri.parse(prefix + 'DGLMAPPING/Update'),
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
          var x = await db.update("DGLMAPPING", map,
              where: "ID = ? AND AcctCode = ?",
              whereArgs: [map["ID"], map["AcctCode"]]);
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
