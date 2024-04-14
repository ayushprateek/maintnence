import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:maintenance/main.dart';
import 'package:sqflite/sqlite_api.dart';

class IWHS {
  int? ID;
  String? ItemCode;
  String? WhsCode;

  ///TO BE USED FOR DEVELOPMENT PURPOSE ONLY
  String? WhsName;

  double? Quantity;
  bool? Active;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  String? CreatedBy;
  String? BranchId;
  String? UpdatedBy;
  double? InStockQty;

  IWHS({
    this.ID,
    this.ItemCode,
    this.WhsCode,
    this.Quantity,
    this.Active,
    this.CreateDate,
    this.UpdateDate,
    this.CreatedBy,
    this.BranchId,
    this.UpdatedBy,
    this.InStockQty,
    this.WhsName,
  });

  factory IWHS.fromJson(Map<String, dynamic> json) =>
      IWHS(
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        ItemCode: json['ItemCode'] ?? '',
        WhsName: json['WhsName'] ?? '',
        WhsCode: json['WhsCode'] ?? '',
        Quantity: double.tryParse(json['Quantity'].toString()) ?? 0.0,
        Active: json['Active'] is bool ? json['Active'] : json['Active'] == 1,
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()),
        CreatedBy: json['CreatedBy'] ?? '',
        BranchId: json['BranchId'] ?? '',
        UpdatedBy: json['UpdatedBy'] ?? '',
        InStockQty: double.tryParse(json['InStockQty'].toString()) ?? 0.0,
      );

  Map<String, dynamic> toJson() =>
      {
        'ID': ID,
        'ItemCode': ItemCode,
        'WhsCode': WhsCode,
        'Quantity': Quantity,
        'Active': Active,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'CreatedBy': CreatedBy,
        'BranchId': BranchId,
        'UpdatedBy': UpdatedBy,
        'InStockQty': InStockQty,
      };
}

List<IWHS> iWHSFromJson(String str) =>
    List<IWHS>.from(json.decode(str).map((x) => IWHS.fromJson(x)));

String iWHSToJson(List<IWHS> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<IWHS>> dataSyncIWHS() async {
  var res =
  await http.get(headers: header, Uri.parse(prefix + "IWHS" + postfix));
  print(res.body);
  return iWHSFromJson(res.body);
}

// Future<void> insertIWHS(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteIWHS(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncIWHS();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('IWHS_Temp', customer.toJson());
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
//       "SELECT * FROM  IWHS_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("IWHS", element, where: "ID = ?", whereArgs: [element["ID"]]);
//   });
//   await batch2.commit(noResult: true);
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from IWHS_Temp where ID || ItemCode not in (Select ID || ItemCode from IWHS)");
//   v.forEach((element) {
//     batch3.insert('IWHS', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('IWHS_Temp');
// }
Future<void> insertIWHS(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteIWHS(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncIWHS();
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
      for (IWHS record in batchRecords) {
        try {
          batch.insert('IWHS_Temp', record.toJson());
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
			select * from IWHS_Temp
			except
			select * from IWHS
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
          batch.update("IWHS", element,
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
  print('Time taken for IWHS update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from IWHS_Temp where ID || ItemCode not in (Select ID || ItemCode from IWHS)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM IWHS_Temp T0
LEFT JOIN IWHS T1 ON T0.ID = T1.ID AND T0.ItemCode = T1.ItemCode
WHERE T1.ID IS NULL AND T1.ItemCode IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('IWHS', record);
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
      'Time taken for IWHS_Temp and IWHS compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('IWHS_Temp');
  // stopwatch.stop();
}

Future<List<IWHS>> retrieveIWHS(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('IWHS');
  return queryResult.map((e) => IWHS.fromJson(e)).toList();
}

Future<void> updateIWHS(int id, Map<String, dynamic> values,
    BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('IWHS', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deleteIWHS(Database db) async {
  await db.delete('IWHS');
}

Future<List<IWHS>> retrieveIWHSById(BuildContext? context, String str,
    List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
  await db.query('IWHS', where: str, whereArgs: l);
  return queryResult.map((e) => IWHS.fromJson(e)).toList();
}

Future<List<IWHS>> retrieveIWHSByIdForComboBox(
    {required String ItemCode}) async {
  final Database db = await initializeDB(null);
  String query =
  '''SELECT T2.WhsName,T1.* FROM IWHS T1 inner join OWHS T2 on T1.WhsCode=T2.WhsCode WHERE T1.ItemCode = '$ItemCode' AND T2.BranchId=${userModel.BranchId} ''';
  final List<Map<String, Object?>> queryResult = await db.rawQuery(query);
  return queryResult.map((e) => IWHS.fromJson(e)).toList();
}

Future<void> insertIWHSToServer(BuildContext? context,
    {String? TransId, int? id}) async {
  String response = "";
  List<IWHS> list = await retrieveIWHSById(
      context,
      TransId == null ? DataSync.getInsertToServerStr() : "ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "IWHS/Add"),
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
            .post(Uri.parse(prefix + "IWHS/Add"),
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
            var x = await db
                .update("IWHS", map, where: "ID = ?", whereArgs: [map["ID"]]);
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

Future<void> updateIWHSOnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<IWHS> list = await retrieveIWHSById(
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
          .put(Uri.parse(prefix + 'IWHS/Update'),
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
          var x = await db
              .update("IWHS", map, where: "ID = ?", whereArgs: [map["ID"]]);
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
