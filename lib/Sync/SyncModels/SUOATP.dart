import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:sqflite/sqlite_api.dart';

class SUOATP {
  int? ID;
  String? Code;
  String? Name;
  String? Remarks;
  String? CreatedBy;
  String? UpdatedBy;
  String? BranchId;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  bool? Active;

  SUOATP({
    this.ID,
    this.Code,
    this.Name,
    this.Remarks,
    this.CreatedBy,
    this.UpdatedBy,
    this.BranchId,
    this.CreateDate,
    this.UpdateDate,
    this.Active,
  });

  factory SUOATP.fromJson(Map<String, dynamic> json) => SUOATP(
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        Code: json['Code'],
        Name: json['Name'],
        Remarks: json['Remarks'],
        CreatedBy: json['CreatedBy'],
        UpdatedBy: json['UpdatedBy'],
        BranchId: json['BranchId'],
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()),
        Active: json['Active'] is bool ? json['Active'] : json['Active'] == 1,
      );

  Map<String, dynamic> toJson() => {
        'ID': ID,
        'Code': Code,
        'Name': Name,
        'Remarks': Remarks,
        'CreatedBy': CreatedBy,
        'UpdatedBy': UpdatedBy,
        'BranchId': BranchId,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'Active': Active,
      };
}

List<SUOATP> sUOATPFromJson(String str) =>
    List<SUOATP>.from(json.decode(str).map((x) => SUOATP.fromJson(x)));

String sUOATPToJson(List<SUOATP> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<SUOATP>> dataSyncSUOATP() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "SUOATP" + postfix));
  print(res.body);
  return sUOATPFromJson(res.body);
}

Future<List<SUOATP>> retrieveSUOATP(BuildContext context,
    {String? orderBy}) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('SUOATP', orderBy: orderBy);
  return queryResult.map((e) => SUOATP.fromJson(e)).toList();
}

Future<void> updateSUOATP(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    await db.transaction((db) async {
      await db.update("SUOATP", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteSUOATP(Database db) async {
  await db.delete('SUOATP');
}

// Future<void> insertSUOATP(Database db)async{
//   if(postfix.toLowerCase().contains("all"))
//   await deleteSUOATP(db);
//   List customers= await dataSyncSUOATP();
//   print(customers);
//   var batch = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try
//     {
//       batch.insert('SUOATP', customer.toJson());
//     }
//     catch(e)
//     {
//       getErrorSnackBar("Sync Error "+e.toString());
//     }
//   });
//   await batch.commit(noResult: true);
//
//
//   // customers.forEach((customer) async {
//   //   print(customer.toJson());
//   //   try
//   //   {
//   //     db.transaction((db)async{
//   //       await db.insert('SUOATP', customer.toJson());
//   //     });
//   //   }
//   //   catch(e)
//   //   {
//   //     getErrorSnackBar("Sync Error "+e.toString());
//   //   }
//   //
//   // });
// }
// Future<void> insertSUOATP(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteSUOATP(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncSUOATP();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('SUOATP_Temp', customer.toJson());
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
//       "SELECT * FROM  SUOATP_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("SUOATP", element,
//         where: "TransId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["TransId"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//
//   var v = await db.rawQuery(
//       "Select * from SUOATP_Temp where TransId not in (Select TransId from SUOATP)");
//   v.forEach((element) {
//     batch3.insert('SUOATP', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('SUOATP_Temp');
// }
Future<void> insertSUOATP(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteSUOATP(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncSUOATP();
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
      for (SUOATP record in batchRecords) {
        try {
          batch.insert('SUOATP_Temp', record.toJson());
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
			select * from SUOATP_Temp
			except
			select * from SUOATP
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
          batch.update("SUOATP", element,
              where:
                  "Code = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
              whereArgs: [element["Code"], 1, 1]);
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
  print('Time taken for SUOATP update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from SUOATP_Temp where TransId not in (Select TransId from SUOATP)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM SUOATP_Temp T0
LEFT JOIN SUOATP T1 ON T0.Code = T1.Code 
WHERE T1.Code IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('SUOATP', record);
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
      'Time taken for SUOATP_Temp and SUOATP compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('SUOATP_Temp');
  // stopwatch.stop();
}

//SEND DATA TO SERVER
//--------------------------
Future<List<SUOATP>> retrieveSUOATPById(
    BuildContext? context, String str, List l,
    {String? orderBy}) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query(
    'SUOATP',
    where: str,
    whereArgs: l,
    orderBy: orderBy,
  );
  return queryResult.map((e) => SUOATP.fromJson(e)).toList();
}

Future<List<SUOATP>> retrieveSUOATPForSearch({required String query}) async {
  final Database db = await initializeDB(null);
  final List<Map<String, Object?>> queryResult = await db.rawQuery(
      "SELECT FirstName || MiddleName || LastName as Name,* FROM OEMP where Name LIKE \'%$query%\' COLLATE NOCASE");
  return queryResult.map((e) => SUOATP.fromJson(e)).toList();
}

// Future<void> insertSUOATPToServer(BuildContext? context,
//     {String? TransId}) async {
//   String response = "";
//   List<SUOATP> list = await retrieveSUOATPById(
//       context,
//       TransId == null ? DataSync.getInsertToServerStr() : "TransId = ?",
//       TransId == null ? DataSync.getInsertToServerList() : [TransId]);
//   if (TransId != null) {
//     //only single entry
//     var res = await http.post(Uri.parse(prefix + "SUOATP/Add"),
//         headers: header, body: jsonEncode(list[0].toJson()));
//     response = res.body;
//   } else if (list.isNotEmpty) {
//     int i = 0;
//     bool sentSuccessInServer = false;
//     if (list.isEmpty) {
//       return;
//     }
//     do {
//       Map<String, dynamic> map = list[i].toJson();
//       sentSuccessInServer = false;
//       try {
//         print(map);
//         map.remove('ID');
//         var res = await http
//             .post(Uri.parse(prefix + "SUOATP/Add"),
//                 headers: header, body: jsonEncode(map))
//             .timeout(Duration(seconds: 30), onTimeout: () {
//           return http.Response("Error", 500);
//         });
//         response = await res.body;
//         if (res.statusCode != 201) {
//           await writeToLogFile(
//               text:
//                   '${res.statusCode} error \nMap : $map\nResponse : ${res.body}',
//               fileName: StackTrace.current.toString(),
//               lineNo: 141);
//         }
//         if (res.statusCode == 201 || res.statusCode == 500) {
//           sentSuccessInServer = true;
//           if (res.statusCode == 201) {
//             map['ID'] = jsonDecode(res.body)['ID'];
//             // map['PermanentTransId'] = jsonDecode(res.body)['PermanentTransId'];
//             final Database db = await initializeDB(context);
//             map["has_created"] = 0;
//             var x = await db.update("SUOATP", map,
//                 where: "Code = ?", whereArgs: [map["Code"]]);
//             print(x.toString());
//           } else {
//             writeToLogFile(
//                 text: '500 error \nMap : $map',
//                 fileName: StackTrace.current.toString(),
//                 lineNo: 141);
//           }
//         }
//         print(res.body);
//       } catch (e) {
//         writeToLogFile(
//             text: '${e.toString()}\nMap : $map',
//             fileName: StackTrace.current.toString(),
//             lineNo: 141);
//         sentSuccessInServer = true;
//       }
//       i++;
//       print("INDEX = " + i.toString());
//     } while (i < list.length && sentSuccessInServer == true);
//   }
// }
//
// Future<void> updateSUOATPOnServer(BuildContext? context,
//     {String? condition, List? l}) async {
//   List<SUOATP> list = await retrieveSUOATPById(
//       context,
//       l == null ? DataSync.getUpdateOnServerStr() : condition ?? "",
//       l == null ? DataSync.getUpdateOnServerList() : l);
//   print(list);
//   int i = 0;
//   bool sentSuccessInServer = false;
//   if (list.isEmpty) {
//     return;
//   }
//   do {
//     Map<String, dynamic> map = list[i].toJson();
//     sentSuccessInServer = false;
//     try {
//       if (list.isEmpty) {
//         return;
//       }
//       Map<String, dynamic> map = list[i].toJson();
//       var res = await http
//           .put(Uri.parse(prefix + 'SUOATP/Update'),
//               headers: header, body: jsonEncode(map))
//           .timeout(Duration(seconds: 30), onTimeout: () {
//         writeToLogFile(
//             text: '500 error \nMap : $map',
//             fileName: StackTrace.current.toString(),
//             lineNo: 141);
//         return http.Response('Error', 500);
//       });
//       print(await res.statusCode);
//       if (res.statusCode != 201) {
//         await writeToLogFile(
//             text:
//                 '${res.statusCode} error \nMap : $map\nResponse : ${res.body}',
//             fileName: StackTrace.current.toString(),
//             lineNo: 141);
//       }
//       if (res.statusCode == 201 || res.statusCode == 500) {
//         sentSuccessInServer = true;
//         if (res.statusCode == 201) {
//           final Database db = await initializeDB(context);
//           map["has_updated"] = 0;
//           var x = await db.update("SUOATP", map,
//               where: "TransId = ?", whereArgs: [map["TransId"]]);
//           print(x.toString());
//         } else {
//           writeToLogFile(
//               text: '500 error \nMap : $map',
//               fileName: StackTrace.current.toString(),
//               lineNo: 141);
//         }
//       }
//       print(res.body);
//     } catch (e) {
//       writeToLogFile(
//           text: '${e.toString()}\nMap : $map',
//           fileName: StackTrace.current.toString(),
//           lineNo: 141);
//       sentSuccessInServer = true;
//     }
//
//     i++;
//     print("INDEX = " + i.toString());
//   } while (i < list.length && sentSuccessInServer == true);
// }
