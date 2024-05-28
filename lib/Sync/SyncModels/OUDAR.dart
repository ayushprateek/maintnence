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

class OUDAR {
  int? ID;
  int? RoleId;
  int? OudaId;
  bool? Sel;
  bool? Readonly;
  String? BranchName;
  bool? Active;
  DateTime? UpdateDate;
  DateTime? CreateDate;
  String? CreatedBy;
  bool? Edit;
  bool? Created;
  String? UpdatedBy;
  String? BranchId;

  OUDAR({
    this.ID,
    this.RoleId,
    this.OudaId,
    this.Sel,
    this.Readonly,
    this.BranchName,
    this.Active,
    this.UpdateDate,
    this.CreateDate,
    this.CreatedBy,
    this.Edit,
    this.Created,
    this.UpdatedBy,
    this.BranchId,
  });

  factory OUDAR.fromJson(Map<String, dynamic> json) =>
      OUDAR(
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        RoleId: int.tryParse(json['RoleId'].toString()) ?? 0,
        OudaId: int.tryParse(json['OudaId'].toString()) ?? 0,
        Sel: json['Sel'] is bool ? json['Sel'] : json['Sel'] == 1,
        Readonly:
        json['Readonly'] is bool ? json['Readonly'] : json['Readonly'] == 1,
        BranchName: json['BranchName'] ?? '',
        Active: json['Active'] is bool ? json['Active'] : json['Active'] == 1,
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()) ??
            DateTime.parse('1900-01-01'),
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()) ??
            DateTime.parse('1900-01-01'),
        CreatedBy: json['CreatedBy'] ?? '',
        Edit: json['Edit'] is bool ? json['Edit'] : json['Edit'] == 1,
        Created:
        json['Created'] is bool ? json['Created'] : json['Created'] == 1,
        UpdatedBy: json['UpdatedBy'] ?? '',
        BranchId: json['BranchId'] ?? '',
      );

  Map<String, dynamic> toJson() =>
      {
        'ID': ID,
        'RoleId': RoleId,
        'OudaId': OudaId,
        'Sel': Sel,
        'Readonly': Readonly,
        'BranchName': BranchName,
        'Active': Active,
        'UpdateDate': UpdateDate?.toIso8601String(),
        'CreateDate': CreateDate?.toIso8601String(),
        'CreatedBy': CreatedBy,
        'Edit': Edit,
        'Created': Created,
        'UpdatedBy': UpdatedBy,
        'BranchId': BranchId,
      };
}

List<OUDAR> oUDARFromJson(String str) =>
    List<OUDAR>.from(json.decode(str).map((x) => OUDAR.fromJson(x)));

String oUDARToJson(List<OUDAR> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<OUDAR>> dataSyncOUDAR() async {
  var res =
  await http.get(headers: header, Uri.parse(prefix + "OUDAR" + postfix));
  print(res.body);
  return oUDARFromJson(res.body);
}

// Future<void> insertOUDAR(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteOUDAR(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncOUDAR();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('OUDAR_Temp', customer.toJson());
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
//       "SELECT * FROM  OUDAR_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN UpdateDate IS NULL THEN createDate ELSE UpdateDate END)");
//   u.forEach((element) {
//     batch2.update("OUDAR", element,
//         where: "ID = ? AND OudaId = ?",
//         whereArgs: [element["ID"], element["OudaId"]]);
//   });
//   await batch2.commit(noResult: true);
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from OUDAR_Temp where ID || OudaId not in (Select ID || OudaId from OUDAR)");
//   v.forEach((element) {
//     batch3.insert('OUDAR', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('OUDAR_Temp');
// }
Future<void> insertOUDAR(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteOUDAR(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncOUDAR();
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
      for (OUDAR record in batchRecords) {
        try {
          batch.insert('OUDAR_Temp', record.toJson());
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
			select * from OUDAR_Temp
			except
			select * from OUDAR
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
          batch.update("OUDAR", element,
              where: "ID = ? AND OudaId = ?",
              whereArgs: [element["ID"], element["OudaId"]]);
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
  print('Time taken for OUDAR update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from OUDAR_Temp where ID || OudaId not in (Select ID || OudaId from OUDAR)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM OUDAR_Temp T0
LEFT JOIN OUDAR T1 ON T0.ID = T1.ID AND T0.OudaId = T1.OudaId 
WHERE T1.ID IS NULL AND T1.OudaId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('OUDAR', record);
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
      'Time taken for OUDAR_Temp and OUDAR compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('OUDAR_Temp');
  // stopwatch.stop();
}

Future<List<OUDAR>> retrieveOUDAR(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('OUDAR');
  return queryResult.map((e) => OUDAR.fromJson(e)).toList();
}

Future<void> updateOUDAR(int id, Map<String, dynamic> values,
    BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('OUDAR', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deleteOUDAR(Database db) async {
  await db.delete('OUDAR');
}

Future<List<OUDAR>> retrieveOUDARById(BuildContext? context, String str,
    List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
  await db.query('OUDAR', where: str, whereArgs: l);
  return queryResult.map((e) => OUDAR.fromJson(e)).toList();
}

Future<void> insertOUDARToServer(BuildContext? context,
    {String? TransId, int? id}) async {
  String response = "";
  List<OUDAR> list = await retrieveOUDARById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "TransId = ? AND ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "OUDAR/Add"),
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
            .post(Uri.parse(prefix + "OUDAR/Add"),
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
            // map = jsonDecode(res.body);
            map["has_created"] = 0;
            var x = await db.update("OUDAR", map,
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

Future<void> updateOUDAROnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<OUDAR> list = await retrieveOUDARById(
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
          .put(Uri.parse(prefix + 'OUDAR/Update'),
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
          var x = await db.update("OUDAR", map,
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
