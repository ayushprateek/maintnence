import 'package:maintenance/Component/LogFileFunctions.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'dart:convert';
import 'package:sqflite/sqlite_api.dart';
class OEJT{
  int? ID;
  String? Code;
  String? ShortDesc;
  bool? Active;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  String? CreatedBy;
  String? BranchId;
  String? UpdatedBy;
  OEJT({
    this.ID,
    this.Code,
    this.ShortDesc,
    this.Active,
    this.CreateDate,
    this.UpdateDate,
    this.CreatedBy,
    this.BranchId,
    this.UpdatedBy,
  });
  factory OEJT.fromJson(Map<String,dynamic> json)=>OEJT(
    ID : int.tryParse(json['ID'].toString())??0,
    Code : json['Code']??'',
    ShortDesc : json['ShortDesc']??'',
    Active : json['Active'] is bool ? json['Active'] : json['Active']==1,
    CreateDate : DateTime.tryParse(json['CreateDate'].toString()),
    UpdateDate : DateTime.tryParse(json['UpdateDate'].toString()),
    CreatedBy : json['CreatedBy']??'',
    BranchId : json['BranchId']??'',
    UpdatedBy : json['UpdatedBy']??'',
  );
  Map<String,dynamic> toJson()=>{
    'ID' : ID,
    'Code' : Code,
    'ShortDesc' : ShortDesc,
    'Active' : Active,
    'CreateDate' : CreateDate?.toIso8601String(),
    'UpdateDate' : UpdateDate?.toIso8601String(),
    'CreatedBy' : CreatedBy,
    'BranchId' : BranchId,
    'UpdatedBy' : UpdatedBy,
  };
}

Future<List<OEJT>> retrieveOEJTForDisplay({
  String dbQuery='',
  int limit=30
}) async {
  final Database db = await initializeDB(null);
  dbQuery='%$dbQuery%';
  String searchQuery='';

  searchQuery='''
     SELECT * FROM OEJT 
 WHERE Active = 1 AND (Code LIKE '$dbQuery' OR ShortDesc LIKE '$dbQuery') 
 LIMIT $limit
      ''';
  final List<Map<String, Object?>> queryResult = await db.rawQuery(searchQuery);
  return queryResult.map((e) => OEJT.fromJson(e)).toList();
}
List<OEJT> oEJTFromJson(String str) => List<OEJT>.from(
    json.decode(str).map((x) => OEJT.fromJson(x)));
String oEJTToJson(List<OEJT> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
Future<List<OEJT>> dataSyncOEJT() async {
  var res = await http.get(headers: header, Uri.parse(prefix + "OEJT" + postfix));
  print(res.body);
  return oEJTFromJson(res.body);}
Future<void> insertOEJT(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteOEJT(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncOEJT();
  }
  print(customers);
  Stopwatch stopwatch = Stopwatch();
  stopwatch.start();
  for (var i = 0; i < customers.length; i += batchSize) {
    var end = (i + batchSize < customers.length) ? i + batchSize : customers.length;
    var batchRecords = customers.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (OEJT record in batchRecords) {
        try {
          batch.insert('OEJT_Temp', record.toJson());
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
			select * from OEJT_Temp
			except
			select * from OEJT
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
          batch.update("OEJT", element,
              //todo: if creating from mobile
              // where: "ID = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
              where: "ID = ?",
              whereArgs: [element["ID"]]);

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
  print('Time taken for OEJT update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from OEJT_Temp where TransId not in (Select TransId from OEJT)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM OEJT_Temp T0
LEFT JOIN OEJT T1 ON T0.ID = T1.ID 
WHERE T1.ID IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('OEJT', record);
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
      'Time taken for OEJT_Temp and OEJT compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('OEJT_Temp');
}

Future<List<OEJT>> retrieveOEJT(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('OEJT');
  return queryResult.map((e) => OEJT.fromJson(e)).toList();
}
Future<void> updateOEJT(int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('OEJT', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    getErrorSnackBar('Sync Error ' + e.toString());}}
Future<void> deleteOEJT(Database db) async {
  await db.delete('OEJT');
}
Future<List<OEJT>> retrieveOEJTById(BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('OEJT', where: str, whereArgs: l);
  return queryResult.map((e) => OEJT.fromJson(e)).toList();
}
// Future<String> insertOEJTToServer(BuildContext? context, {String? TransId, int? id}) async {
//   String response = "";
//   List<OEJT> list = await retrieveOEJTById(context, TransId == null ? DataSync.getInsertToServerStr() : "TransId = ? AND ID = ?", TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
//   if (TransId != null) {
//     list[0].ID = 0;
//     var res = await http.post(Uri.parse(prefix + "OEJT/Add"), headers: header, body: jsonEncode(list[0].toJson()));
//     response = res.body;
//   } else if (list.isNotEmpty) {
//     int i = 0;
//     bool sentSuccessInServer = false;
//     do {
//       sentSuccessInServer = false;
//       try {
//         Map<String, dynamic> map = list[i].toJson();
//         map.remove('ID');
//         var res = await http.post(Uri.parse(prefix + "OEJT/Add"), headers: header,
//             body: jsonEncode(map)).timeout(Duration(seconds: 30), onTimeout: () {
//           return http.Response('Error', 500);});
//         response = await res.body;
//         print("eeaaae status");
//         print(await res.statusCode);
//         if (res.statusCode == 201 || res.statusCode == 500) {
//           sentSuccessInServer = true;
//           if (res.statusCode == 201) {
//             map['ID'] = jsonDecode(res.body)['ID'];
//             final Database db = await initializeDB(context);
//             map=jsonDecode(res.body);
//             map["has_created"] = 0;
//             var x = await db.update("OEJT", map, where: "ID = ?", whereArgs: [map["ID"]]);
//             print(x.toString());}}
//         print(res.body);
//       } catch (e) {
//         print("Timeout " + e.toString());
//         sentSuccessInServer = true;}
//       i++;
//       print("INDEX = " + i.toString());
//     } while (i < list.length && sentSuccessInServer == true);}
//   return response;}
// Future<void> updateOEJTOnServer(BuildContext? context, {String? condition, List? l}) async {
//   List<OEJT> list = await retrieveOEJTById(context, l == null ? DataSync.getUpdateOnServerStr() : condition ?? "", l == null ? DataSync.getUpdateOnServerList() : l);
//   print(list);
//   int i = 0;
//   bool sentSuccessInServer = false;
//   do {
//     sentSuccessInServer = false;
//     try {
//       Map<String, dynamic> map = list[i].toJson();
//       var res = await http.put(Uri.parse(prefix + 'OEJT/Update'), headers: header, body: jsonEncode(map)).timeout(Duration(seconds: 30), onTimeout: () {
//         return http.Response('Error', 500);
//       });
//       print(await res.statusCode);
//       if (res.statusCode == 201 || res.statusCode == 500) {
//         sentSuccessInServer = true;
//         if (res.statusCode == 201) {
//           final Database db = await initializeDB(context);
//           map["has_updated"] = 0;
//           var x = await db.update("OEJT", map, where: "ID = ?", whereArgs: [map["ID"]]);
//           print(x.toString());
//         }
//       }
//       print(res.body);
//     } catch (e) {
//       print("Timeout " + e.toString());
//       sentSuccessInServer = true;
//     }
//
//     i++;
//     print("INDEX = " + i.toString());
//   } while (i < list.length && sentSuccessInServer == true);
// }
  
