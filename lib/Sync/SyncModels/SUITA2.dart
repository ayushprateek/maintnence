import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

class SUITA2 {
  int? ID;
  String? TransId;
  int? RowId;
  String? EmpCode;
  String? EmpName;
  String? EmpRole;
  bool IsInternalEmp;
  String? Email;
  String? MobileNo;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  bool? Active;
  bool hasCreated;
  bool hasUpdated;
  TextEditingController role = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mobile = TextEditingController();

  SUITA2({
    this.ID,
    this.TransId,
    this.RowId,
    this.EmpCode,
    this.EmpName,
    this.EmpRole,
    this.IsInternalEmp = false,
    this.Email,
    this.MobileNo,
    this.CreateDate,
    this.UpdateDate,
    this.Active,
    this.hasCreated = false,
    this.hasUpdated = false,
  });

  factory SUITA2.fromJson(Map<String, dynamic> json) => SUITA2(
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        TransId: json['TransId'],
        RowId: int.tryParse(json['RowId'].toString()) ?? 0,
        EmpCode: json['EmpCode'],
        EmpName: json['EmpName'],
        EmpRole: json['EmpRole'],
        IsInternalEmp: json['IsInternalEmp'] is bool
            ? json['IsInternalEmp']
            : json['IsInternalEmp'] == 1,
        Email: json['Email'],
        MobileNo: json['MobileNo'],
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()),
        Active: json['Active'] is bool ? json['Active'] : json['Active'] == 1,
        hasCreated: json['has_created'] is bool
            ? json['has_created']
            : json['has_created'] == 1,
        hasUpdated: json['has_updated'] is bool
            ? json['has_updated']
            : json['has_updated'] == 1,
      );

  Map<String, dynamic> toJson() => {
        'ID': ID,
        'TransId': TransId,
        'RowId': RowId,
        'EmpCode': EmpCode,
        'EmpName': EmpName,
        'EmpRole': EmpRole,
        'IsInternalEmp': IsInternalEmp,
        'Email': Email,
        'MobileNo': MobileNo,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'Active': Active,
        'has_created': hasCreated ? 1 : 0,
        'has_updated': hasUpdated ? 1 : 0,
      };
}

List<SUITA2> sUITA2FromJson(String str) =>
    List<SUITA2>.from(json.decode(str).map((x) => SUITA2.fromJson(x)));

String sUITA2ToJson(List<SUITA2> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<SUITA2>> dataSyncSUITA2() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "SUITA2" + postfix));
  print(res.body);
  return sUITA2FromJson(res.body);
}

Future<List<SUITA2>> retrieveSUITA2(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('SUITA2');
  return queryResult.map((e) => SUITA2.fromJson(e)).toList();
}

Future<void> updateSUITA2(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update("SUITA2", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteSUITA2(Database db) async {
  await db.delete('SUITA2');
}

// Future<void> insertSUITA2(Database db)async{
//   if(postfix.toLowerCase().contains("all"))
//   await deleteSUITA2(db);
//   List customers= await dataSyncSUITA2();
//   print(customers);
//   var batch = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try
//     {
//       batch.insert('SUITA2', customer.toJson());
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
//   //       await db.insert('SUITA2', customer.toJson());
//   //     });
//   //   }
//   //   catch(e)
//   //   {
//   //     getErrorSnackBar("Sync Error "+e.toString());
//   //   }
//   //
//   // });
// }
//SEND DATA TO SERVER
//--------------------------
// Future<void> insertSUITA2(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteSUITA2(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncSUITA2();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('SUITA2_Temp', customer.toJson());
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
//       "SELECT * FROM  SUITA2_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("SUITA2", element,
//         where: "RowId = ? AND TransId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["RowId"], element["TransId"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from SUITA2_Temp where TransId || RowId not in (Select TransId || RowId from SUITA2)");
//   v.forEach((element) {
//     batch3.insert('SUITA2', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('SUITA2_Temp');
// }
Future<void> insertSUITA2(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteSUITA2(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncSUITA2();
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
      for (SUITA2 record in batchRecords) {
        try {
          batch.insert('SUITA2_Temp', record.toJson());
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
			select * from SUITA2_Temp
			except
			select * from SUITA2
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
          batch.update("SUITA2", element,
              where:
                  "TransId = ? AND RowId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
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
  print('Time taken for SUITA2 update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from SUITA2_Temp where TransId || RowId not in (Select TransId || RowId from SUITA2)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM SUITA2_Temp T0
LEFT JOIN SUITA2 T1 ON T0.TransId = T1.TransId AND T0.RowId = T1.RowId
WHERE T1.TransId IS NULL AND T1.RowId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('SUITA2', record);
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
      'Time taken for SUITA2_Temp and SUITA2 compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('SUITA2_Temp');
  // stopwatch.stop();
}

Future<List<SUITA2>> retrieveSUITA2ById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('SUITA2', where: str, whereArgs: l);
  return queryResult.map((e) => SUITA2.fromJson(e)).toList();
}

Future<void> insertSUITA2ToServer(BuildContext? context,
    {String? TransId}) async {
  String response = "";
  List<SUITA2> list = await retrieveSUITA2ById(
      context,
      TransId == null ? DataSync.getInsertToServerStr() : "TransId = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId]);
  if (TransId != null) {
    //only single entry
    var res = await http.post(Uri.parse(prefix + "SUITA2/Add"),
        headers: header, body: jsonEncode(list[0].toJson()));
    print(res.body);
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
        String queryParams='TransId=${list[i].TransId}&RowId=${list[i].RowId}';
        var res = await http.post(Uri.parse(prefix + "SUITA2/Add?$queryParams"),
                headers: header, body: jsonEncode(map))
            .timeout(Duration(seconds: 30), onTimeout: () {
          return http.Response("Error", 500);
        });
        response = await res.body;
        if (res.statusCode != 201) {
          await writeToLogFile(
              text:
                  '${res.statusCode} error \nMap : $map\nResponse : ${res.body}',
              fileName: StackTrace.current.toString(),
              lineNo: 141);
        }
        if(res.statusCode ==409)
        {
          ///Already added in server
          final Database db = await initializeDB(context);
          SUITA2 model=SUITA2.fromJson(jsonDecode(res.body));
          var x = await db.update("SUITA2", model.toJson(),
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
            var x = await db.update("SUITA2", map,
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

Future<void> updateSUITA2OnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<SUITA2> list = await retrieveSUITA2ById(
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
          .put(Uri.parse(prefix + 'SUITA2/Update'),
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
          var x = await db.update("SUITA2", map,
              where: "TransId = ?", whereArgs: [map["TransId"]]);
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
