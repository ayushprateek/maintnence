import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:sqflite/sqlite_api.dart';

List<XPM1Model> XPM1ModelFromJson(String str) =>
    List<XPM1Model>.from(json.decode(str).map((x) => XPM1Model.fromJson(x)));

String XPM1ModelToJson(List<XPM1Model> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class XPM1Model {
  XPM1Model({
    required this.ID,
    required this.CreateDate,
    required this.UpdateDate,
    this.hasCreated = false,
    required this.EmpGroupId,
    required this.RowId,
    required this.ExpId,
    required this.ExpShortDesc,
    required this.Based,
    required this.ValidFrom,
    required this.ValidTo,
    required this.Remarks,
    required this.Mandatory,
    required this.Amount,
    required this.Code,
    this.Additional,
  });

  int ID;
  int EmpGroupId;
  int RowId;
  DateTime CreateDate;
  DateTime UpdateDate;
  bool hasCreated;
  int ExpId;
  double factor = 0.0;

  /// THIS VARIABLE IS ONLY FOR DEVELOPMENT PURPOSE
  double Amount;
  String ExpShortDesc;
  String Based;
  DateTime? ValidFrom;
  DateTime? ValidTo;
  String Code;
  String Remarks;
  bool Mandatory;
  double? Additional;

  factory XPM1Model.fromJson(Map<String, dynamic> json) => XPM1Model(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] == 1,
        Amount: double.tryParse(json["Amount"].toString()) ?? 0.0,
        EmpGroupId: int.tryParse(json["EmpGroupId"].toString()) ?? 0,
        RowId: int.tryParse(json["RowId"].toString()) ?? 0,
        ExpId: int.tryParse(json["ExpId"].toString()) ?? 0,
        ExpShortDesc: json["ExpShortDesc"] ?? "",
        Code: json["Code"] ?? "",
        Based: json["Based"] ?? "",
        ValidFrom: DateTime.tryParse(json["ValidFrom"].toString()) ??
            DateTime.parse("1900-01-01"),
        ValidTo: DateTime.tryParse(json["ValidTo"].toString()) ??
            DateTime.parse("1900-01-01"),
        Remarks: json["Remarks"] ?? "",
        Mandatory: json["Mandatory"] is bool
            ? json["Mandatory"]
            : json["Mandatory"] == 1,
        Additional: double.tryParse(json['Additional'].toString()) ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "Code": Code,
        "EmpGroupId": EmpGroupId,
        "RowId": RowId,
        "CreateDate": CreateDate.toIso8601String(),
        "UpdateDate": UpdateDate.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "ExpId": ExpId,
        "Amount": Amount,
        "ExpShortDesc": ExpShortDesc,
        "Based": Based,
        "ValidFrom": ValidFrom?.toIso8601String(),
        "ValidTo": ValidTo?.toIso8601String(),
        "Remarks": Remarks,
        "Mandatory": Mandatory == true ? 1 : 0,
        'Additional': Additional,
      };
}

Future<List<XPM1Model>> dataSyncXPM1() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "XPM1" + postfix));
  print(res.body);
  return XPM1ModelFromJson(res.body);
}

Future<List<XPM1Model>> retrieveXPM1(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('XPM1');
  return queryResult.map((e) => XPM1Model.fromJson(e)).toList();
}

Future<void> updateXPM1(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update("XPM1", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteXPM1(Database db) async {
  await db.delete('XPM1');
}

// Future<void> insertXPM1(Database db) async {
//   if(postfix.toLowerCase().contains("all"))
//   await deleteXPM1(db);
//   List customers = await dataSyncXPM1();
//   print(customers);
//   var batch = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try
//     {
//       batch.insert('XPM1', customer.toJson());
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
//   //       await db.insert('XPM1', customer.toJson());
//   //     });
//   //   }
//   //   catch(e)
//   //   {
//   //     getErrorSnackBar("Sync Error "+e.toString());
//   //   }
//   //
//   // });
// }
// Future<void> insertXPM1(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteXPM1(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncXPM1();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('XPM1_Temp', customer.toJson());
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
//       "SELECT * FROM  XPM1_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("XPM1", element,
//         where:
//             "Code = ? AND RowId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["Code"], element["RowId"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from XPM1_Temp where Code || RowId not in (Select Code || RowId from XPM1)");
//   v.forEach((element) {
//     batch3.insert('XPM1', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('XPM1_Temp');
// }
Future<void> insertXPM1(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteXPM1(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncXPM1();
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
      for (XPM1Model record in batchRecords) {
        try {
          batch.insert('XPM1_Temp', record.toJson());
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
			select * from XPM1_Temp
			except
			select * from XPM1
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
          batch.update("XPM1", element,
              where:
                  "Code = ? AND RowId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
              whereArgs: [element["Code"], element["RowId"], 1, 1]);
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
  print('Time taken for XPM1 update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from XPM1_Temp where Code || RowId not in (Select Code || RowId from XPM1)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM XPM1_Temp T0
LEFT JOIN XPM1 T1 ON T0.Code = T1.Code AND T0.RowId = T1.RowId
WHERE T1.Code IS NULL AND T1.RowId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('XPM1', record);
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
      'Time taken for XPM1_Temp and XPM1 compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('XPM1_Temp');
  // stopwatch.stop();
}

//SEND DATA TO SERVER
//--------------------------
Future<List<XPM1Model>> retrieveXPM1ById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('XPM1', where: str, whereArgs: l);
  return queryResult.map((e) => XPM1Model.fromJson(e)).toList();
}

// Future<List<XPM1Model>> retrieveXPM1ForCashRequisition(
//     {String? RouteCode}) async {
//   final Database db = await initializeDB(null);
//
//   List<Map<String, Object?>> queryResult = [];
//   String query = '';
//   if (RouteCode?.isNotEmpty == true) {
//     query = '''
//        SELECT T1.* FROM XPM1 T1  INNER JOIN OXPM T2 ON T1.Code=T2.Code
// WHERE RouteCode='$RouteCode' AND T1.EmpGroupId= '${EmployeeData.EmpGroupId}' AND T2.Active=1
// ''';
//     queryResult = await db.rawQuery(query);
//   }
//   if (RouteCode?.isEmpty == true || queryResult.isEmpty) {
//     query = '''
//        SELECT T1.* FROM XPM1 T1  INNER JOIN OXPM T2 ON T1.Code=T2.Code
// WHERE (RouteCode=null OR RouteCode = '') AND T1.EmpGroupId= '${EmployeeData.EmpGroupId}' AND T2.Active=1
// ''';
//     queryResult = await db.rawQuery(query);
//   }
//
//   return queryResult.map((e) => XPM1Model.fromJson(e)).toList();
// }

// Future<void> insertXPM1ToServer(BuildContext context) async {
//   retrieveXPM1ById(context, DataSync.getInsertToServerStr(),
//           DataSync.getInsertToServerList())
//       .then((snapshot) {
//     print(snapshot);
//     snapshot.forEach((data) async {
//       var res = await http.post(Uri.parse(prefix + "XPM1/Add"),
//           headers: header, body: jsonEncode(data.toJson()));
//       print(res.body);
//     });
//   });
// }
//
// Future<void> updateXPM1OnServer(BuildContext? context) async {
//   retrieveXPM1ById(context, DataSync.getUpdateOnServerStr(),
//           DataSync.getUpdateOnServerList())
//       .then((snapshot) {
//     print(snapshot);
//     snapshot.forEach((data) async {
//       var res = await http.put(Uri.parse(prefix + 'XPM1/Update'),
//           headers: header, body: jsonEncode(data.toJson()));
//       print(res.body);
//     });
//   });
// }
