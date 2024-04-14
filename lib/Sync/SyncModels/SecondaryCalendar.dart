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

class SecondaryCalendar {
  int? ID;
  String? MonthName;
  DateTime? EnglishDate;
  String? SecondaryDate;
  int? MapId;
  DateTime? CreateDate;
  DateTime? UpdateDate;

  SecondaryCalendar({
    this.ID,
    this.MonthName,
    this.EnglishDate,
    this.SecondaryDate,
    this.MapId,
    this.CreateDate,
    this.UpdateDate,
  });

  factory SecondaryCalendar.fromJson(Map<String, dynamic> json) =>
      SecondaryCalendar(
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        MonthName: json['MonthName'],
        EnglishDate: DateTime.tryParse(json['EnglishDate'].toString()),
        SecondaryDate: json['SecondaryDate'],
        MapId: int.tryParse(json['MapId'].toString()) ?? 0,
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()),
      );

  Map<String, dynamic> toJson() =>
      {
        'ID': ID,
        'MonthName': MonthName,
        'EnglishDate': EnglishDate?.toIso8601String(),
        'SecondaryDate': SecondaryDate,
        'MapId': MapId,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
      };
}

List<SecondaryCalendar> secondaryCalendarFromJson(String str) =>
    List<SecondaryCalendar>.from(
        json.decode(str).map((x) => SecondaryCalendar.fromJson(x)));

String secondaryCalendarToJson(List<SecondaryCalendar> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<SecondaryCalendar>> dataSyncSecondaryCalendar() async {
  var res = await http.get(
      headers: header, Uri.parse(prefix + "SecondaryCalendar" + postfix));
  print(res.body);
  return secondaryCalendarFromJson(res.body);
}

// Future<void> insertSecondaryCalendar(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteSecondaryCalendar(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncSecondaryCalendar();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('SecondaryCalendar_Temp', customer.toJson());
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
//       "SELECT * FROM  SecondaryCalendar_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("SecondaryCalendar", element,
//         where: "ID = ?", whereArgs: [element["ID"]]);
//   });
//   await batch2.commit(noResult: true);
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from SecondaryCalendar_Temp where ID not in (Select ID from SecondaryCalendar)");
//   v.forEach((element) {
//     batch3.insert('SecondaryCalendar', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('SecondaryCalendar_Temp');
// }
Future<void> insertSecondaryCalendar(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteSecondaryCalendar(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncSecondaryCalendar();
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
      for (SecondaryCalendar record in batchRecords) {
        try {
          batch.insert('SecondaryCalendar_Temp', record.toJson());
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
			select * from SecondaryCalendar_Temp
			except
			select * from SecondaryCalendar
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
          batch.update("SecondaryCalendar", element,
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
  print('Time taken for SecondaryCalendar update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from SecondaryCalendar_Temp where ID not in (Select ID from SecondaryCalendar)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM SecondaryCalendar_Temp T0
LEFT JOIN SecondaryCalendar T1 ON T0.ID = T1.ID 
WHERE T1.ID IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('SecondaryCalendar', record);
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
      'Time taken for SecondaryCalendar_Temp and SecondaryCalendar compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('SecondaryCalendar_Temp');
  // stopwatch.stop();
}

Future<List<SecondaryCalendar>> retrieveSecondaryCalendar() async {
  final Database db = await initializeDB(null);
  final List<Map<String, Object?>> queryResult =
  await db.query('SecondaryCalendar');
  return queryResult.map((e) => SecondaryCalendar.fromJson(e)).toList();
}

Future<void> updateSecondaryCalendar(int id, Map<String, dynamic> values,
    BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('SecondaryCalendar', values,
          where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deleteSecondaryCalendar(Database db) async {
  await db.delete('SecondaryCalendar');
}

Future<List<SecondaryCalendar>> retrieveSecondaryCalendarById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
  await db.query('SecondaryCalendar', where: str, whereArgs: l);
  return queryResult.map((e) => SecondaryCalendar.fromJson(e)).toList();
}

Future<void> insertSecondaryCalendarToServer(BuildContext? context,
    {String? TransId, int? id}) async {
  String response = "";
  List<SecondaryCalendar> list = await retrieveSecondaryCalendarById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "TransId = ? AND ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "SecondaryCalendar/Add"),
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
            .post(Uri.parse(prefix + "SecondaryCalendar/Add"),
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
            var x = await db.update("SecondaryCalendar", map,
                where: "ID = ?", whereArgs: [map["ID"]]);
            print(x.toString());
          }
        }
        print(res.body);
      } catch (e) {
        writeToLogFile(
            text: '${e.toString()}\nMap : $map', fileName: StackTrace.current.toString(), lineNo: 141);
  sentSuccessInServer = true;
  }
  print('i++;');
  print("INDEX = " + i.toString());
  } while (i < list.length && sentSuccessInServer ==
  true
  );
}

}

Future<void> updateSecondaryCalendarOnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<SecondaryCalendar> list = await retrieveSecondaryCalendarById(
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
          .put(Uri.parse(prefix + 'SecondaryCalendar/Update'),
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
          var x = await db.update("SecondaryCalendar", map,
              where: "ID = ?", whereArgs: [map["ID"]]);
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
