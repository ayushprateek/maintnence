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

List<OPTRModel> OPTRModelFromJson(String str) =>
    List<OPTRModel>.from(json.decode(str).map((x) => OPTRModel.fromJson(x)));

String OPTRModelToJson(List<OPTRModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OPTRModel {
  OPTRModel({
    required this.ID,
    required this.Code,
    required this.Name,
    required this.Days,
    required this.Active,
    required this.CreateDate,
    required this.UpdateDate,
    this.hasCreated = false,
    this.CreatedBy,
    this.UpdatedBy,
    this.BranchId,
  });

  int ID;
  String Code;
  String Name;
  double Days;
  bool Active;
  DateTime CreateDate;
  DateTime UpdateDate;
  bool hasCreated;
  String? CreatedBy;
  String? UpdatedBy;
  String? BranchId;

  factory OPTRModel.fromJson(Map<String, dynamic> json) =>
      OPTRModel(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] == 1,
        Code: json["Code"] ?? "",
        Name: json["Name"] ?? "",
        Days: double.tryParse(json["Days"].toString()) ?? 0.0,
        Active: json["Active"] is bool ? json["Active"] : json["Active"] == 1,
        CreatedBy: json['CreatedBy'] ?? '',
        UpdatedBy: json['UpdatedBy'] ?? '',
        BranchId: json['BranchId'] ?? '',
      );

  Map<String, dynamic> toJson() =>
      {
        "ID": ID,
        "Code": Code,
        "Name": Name,
        "CreateDate": CreateDate.toIso8601String(),
        "UpdateDate": UpdateDate.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "Days": Days,
        "Active": Active == true ? 1 : 0,
        'CreatedBy': CreatedBy,
        'UpdatedBy': UpdatedBy,
        'BranchId': BranchId,
      };
}
Future<List<OPTRModel>> retrieveOPTRForDisplay({
  String dbQuery='',
  int limit=30
}) async {
  final Database db = await initializeDB(null);
  dbQuery='%$dbQuery%';
  String searchQuery='';

  searchQuery='''
     SELECT * FROM OPTR 
 WHERE Active = 1 AND (Code LIKE '$dbQuery' OR Name LIKE '$dbQuery' OR Days LIKE '$dbQuery') 
 LIMIT $limit
      ''';
  final List<Map<String, Object?>> queryResult = await db.rawQuery(searchQuery);
  return queryResult.map((e) => OPTRModel.fromJson(e)).toList();
}

Future<List<OPTRModel>> dataSyncOPTR() async {
  var res =
  await http.get(headers: header, Uri.parse(prefix + "OPTR" + postfix));
  print(res.body);
  return OPTRModelFromJson(res.body);
}

Future<List<OPTRModel>> retrieveOPTR(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('OPTR');
  return queryResult.map((e) => OPTRModel.fromJson(e)).toList();
}

Future<void> updateOPTR(int id, Map<String, dynamic> values,
    BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update("OPTR", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteOPTR(Database db) async {
  await db.delete('OPTR');
}

// Future<void> insertOPTR(Database db,{List? list})async{
//   if(postfix.toLowerCase().contains("all"))
//   await deleteOPTR(db);
//   List customers;
//   if(list!=null)
//   {
//     customers=list;
//   }
//   else
//   {
//     customers= await dataSyncOPTR();
//   }
//
//   // List customers= await dataSyncOPTR();
//   print(customers);
//   var batch = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try
//     {
//       batch.insert('OPTR', customer.toJson());
//     }
//     catch(e)
//     {
//       getErrorSnackBar("Sync Error "+e.toString());
//     }
//   });
//   await batch.commit(noResult: true);
//   // customers.forEach((customer) async {
//   //   print(customer.toJson());
//   //   try
//   //   {
//   //     db.transaction((db)async{
//   //       await db.insert('OPTR', customer.toJson());
//   //     });
//   //   }
//   //   catch(e)
//   //   {
//   //     getErrorSnackBar("Sync Error "+e.toString());
//   //   }
//   //
//   // });
// }
// Future<void> insertOPTR(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteOPTR(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncOPTR();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('OPTR_Temp', customer.toJson());
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
//       "SELECT * FROM  OPTR_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("OPTR", element,
//         where: "Code = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["Code"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from OPTR_Temp where Code not in (Select Code from OPTR)");
//   v.forEach((element) {
//     batch3.insert('OPTR', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('OPTR_Temp');
// }
Future<void> insertOPTR(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteOPTR(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncOPTR();
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
      for (OPTRModel record in batchRecords) {
        try {
          batch.insert('OPTR_Temp', record.toJson());
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
			select * from OPTR_Temp
			except
			select * from OPTR
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
          batch.update("OPTR", element,
              where: "Code = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
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
  print('Time taken for OPTR update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from OPTR_Temp where Code not in (Select Code from OPTR)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM OPTR_Temp T0
LEFT JOIN OPTR T1 ON T0.Code = T1.Code 
WHERE T1.Code IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('OPTR', record);
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
      'Time taken for OPTR_Temp and OPTR compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('OPTR_Temp');
  // stopwatch.stop();
}

//SEND DATA TO SERVER
//--------------------------
Future<List<OPTRModel>> retrieveOPTRById(BuildContext? context, String str,
    List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
  await db.query('OPTR', where: str, whereArgs: l);
  return queryResult.map((e) => OPTRModel.fromJson(e)).toList();
}

// Future<void> insertOPTRToServer(BuildContext context) async {
//   retrieveOPTRById(context, DataSync.getInsertToServerStr(), DataSync.getInsertToServerList()).then((snapshot) {
//     print(snapshot);
//     snapshot.forEach((data) async {
//       var res = await http.post(Uri.parse(prefix + "OPTR/Add"), headers: header, body: jsonEncode(data.toJson()));
//       print(res.body);
//     });
//   });
// }

Future<void> insertOPTRToServer(BuildContext? context,
    {String? TransId}) async {
  String response = "";
  List<OPTRModel> list = await retrieveOPTRById(
      context,
      TransId == null ? DataSync.getInsertToServerStr() : "TransId = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "OPTR/Add"),
        headers: header, body: jsonEncode(list[0].toJson()));
    print(res.body);
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
            .post(Uri.parse(prefix + "OPTR/Add"),
            headers: header, body: jsonEncode(map))
            .timeout(Duration(seconds: 30), onTimeout: () {
          return http.Response("Error", 500);
        });
        response = await res.body;
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
            map["has_created"] = 0;
            var x = await db.update("OPTR", map,
                where: "Code = ?", whereArgs: [map["Code"]]);
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

Future<void> updateOPTROnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<OPTRModel> list = await retrieveOPTRById(
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
          .put(Uri.parse(prefix + 'OPTR/Update'),
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
              .update("OPTR", map, where: "Code = ?", whereArgs: [map["Code"]]);
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
