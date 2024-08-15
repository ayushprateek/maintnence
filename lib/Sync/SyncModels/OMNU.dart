import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:sqflite/sqlite_api.dart';

List<OMNUModel> OMNUModelFromJson(String str) =>
    List<OMNUModel>.from(json.decode(str).map((x) => OMNUModel.fromJson(x)));

String OMNUModelToJson(List<OMNUModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OMNUModel {
  OMNUModel({
    required this.ID,
    required this.MenuDesc,
    required this.CreateDate,
    required this.UpdateDate,
    this.hasCreated = false,
    required this.ParentMenu,
    required this.Type,
    required this.Notes,
    required this.MenuId,
    required this.ReadOnly,
    required this.Self,
    required this.BranchName,
    required this.Sel,
    this.Url,
    this.MenuPath,
    this.ControllerName,
    this.CreatedBy,
    this.BranchId,
    this.UpdatedBy,
    this.Company,
    this.NoOfPrints,
    this.Code,
  });

  int ID;
  int? NoOfPrints;
  String? Code;
  String MenuDesc;
  int ParentMenu;
  int Type;
  String Notes;
  int MenuId;
  bool ReadOnly;
  bool Self;
  bool BranchName;
  DateTime CreateDate;
  DateTime UpdateDate;
  bool hasCreated;
  bool Sel;
  String? Url;
  String? MenuPath;
  String? ControllerName;
  String? CreatedBy;
  String? BranchId;
  String? UpdatedBy;
  bool? Company;

  factory OMNUModel.fromJson(Map<String, dynamic> json) => OMNUModel(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        NoOfPrints: int.tryParse(json["NoOfPrints"].toString()) ?? 1,
        MenuDesc: json["MenuDesc"] ?? "",
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] == 1,
        ParentMenu: int.tryParse(json["ParentMenu"].toString()) ?? 0,
        Type: int.tryParse(json["Type"].toString()) ?? 0,
        Notes: json["Notes"] ?? "",
        MenuId: int.tryParse(json["MenuId"].toString()) ?? 0,
        Sel: json["Sel"] is bool ? json["Sel"] : json["Sel"] == 1,
        ReadOnly:
            json["ReadOnly"] is bool ? json["ReadOnly"] : json["ReadOnly"] == 1,
        BranchName: json["BranchName"] is bool
            ? json["BranchName"]
            : json["BranchName"] == 1,
        Self: json["Self"] is bool ? json["Self"] : json["Self"] == 1,
        Url: json['Url'] ?? '',
        Code: json['Code'] ?? '',
        MenuPath: json['MenuPath'] ?? '',
        ControllerName: json['ControllerName'] ?? '',
        CreatedBy: json['CreatedBy'] ?? '',
        BranchId: json['BranchId'] ?? '',
        UpdatedBy: json['UpdatedBy'] ?? '',
        Company:
            json['Company'] is bool ? json['Company'] : json['Company'] == 1,
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "NoOfPrints": NoOfPrints,
        "MenuDesc": MenuDesc,
        "ParentMenu": ParentMenu,
        "Code": Code,
        "Type": Type,
        "CreateDate": CreateDate.toIso8601String(),
        "UpdateDate": UpdateDate.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "Notes": Notes,
        "MenuId": MenuId,
        "ReadOnly": ReadOnly == true ? 1 : 0,
        "Self": Self == true ? 1 : 0,
        "BranchName": BranchName == true ? 1 : 0,
        "Sel": Sel == true ? 1 : 0,
        'Url': Url,
        'MenuPath': MenuPath,
        'ControllerName': ControllerName,
        'CreatedBy': CreatedBy,
        'BranchId': BranchId,
        'UpdatedBy': UpdatedBy,
        'Company': Company,
      };
}

Future<List<OMNUModel>> dataSyncOMNU() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "OMNU" + postfix));
  print(res.body);
  return OMNUModelFromJson(res.body);
}

Future<List<OMNUModel>> retrieveOMNU(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('OMNU');
  return queryResult.map((e) => OMNUModel.fromJson(e)).toList();
}

Future<void> updateOMNU(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    await db.transaction((db) async {
      await db.update("OMNU", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteOMNU(Database db) async {
  await db.delete('OMNU');
}

// Future<void> insertOMNU(Database db)async{
//   if(postfix.toLowerCase().contains("all"))
//   await deleteOMNU(db);
//   List customers= await dataSyncOMNU();
//   print(customers);
//   var batch = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try
//     {
//       batch.insert('OMNU', customer.toJson());
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
//   //       await db.insert('OMNU', customer.toJson());
//   //     });
//   //   }
//   //   catch(e)
//   //   {
//   //     getErrorSnackBar("Sync Error "+e.toString());
//   //   }
//   //
//   // });
// }
// Future<void> insertOMNU(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteOMNU(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncOMNU();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('OMNU_Temp', customer.toJson());
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
//       "SELECT * FROM  OMNU_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("OMNU", element,
//         where: "MenuDesc = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["MenuDesc"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from OMNU_Temp where MenuDesc not in (Select  MenuDesc from OMNU)");
//   v.forEach((element) {
//     batch3.insert('OMNU', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('OMNU_Temp');
// }
Future<void> insertOMNU(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteOMNU(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncOMNU();
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
      for (OMNUModel record in batchRecords) {
        try {
          batch.insert('OMNU_Temp', record.toJson());
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
			select * from OMNU_Temp
			except
			select * from OMNU
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
          batch.update("OMNU", element,
              where:
                  "MenuDesc = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
              whereArgs: [element["MenuDesc"], 1, 1]);
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
  print('Time taken for OMNU update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from OMNU_Temp where MenuDesc not in (Select  MenuDesc from OMNU)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM OMNU_Temp T0
LEFT JOIN OMNU T1 ON T0.MenuDesc = T1.MenuDesc 
WHERE T1.MenuDesc IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('OMNU', record);
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
      'Time taken for OMNU_Temp and OMNU compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('OMNU_Temp');
  // stopwatch.stop();
}

//SEND DATA TO SERVER
//--------------------------
Future<List<OMNUModel>> retrieveOMNUById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('OMNU', where: str, whereArgs: l);
  return queryResult.map((e) => OMNUModel.fromJson(e)).toList();
}

// Future<void> insertOMNUToServer(BuildContext context) async {
//   retrieveOMNUById(context, DataSync.getInsertToServerStr(),
//           DataSync.getInsertToServerList())
//       .then((snapshot) {
//     print(snapshot);
//     snapshot.forEach((data) async {
//       var res = await http.post(Uri.parse(prefix + "OMNU/Add"),
//           headers: header, body: jsonEncode(data.toJson()));
//       print(res.body);
//     });
//   });
// }
//
// Future<void> updateOMNUOnServer(BuildContext? context) async {
//   retrieveOMNUById(context, DataSync.getUpdateOnServerStr(),
//           DataSync.getUpdateOnServerList())
//       .then((snapshot) {
//     print(snapshot);
//     snapshot.forEach((data) async {
//       var res = await http.put(Uri.parse(prefix + 'OMNU/Update'),
//           headers: header, body: jsonEncode(data.toJson()));
//       print(res.body);
//     });
//   });
// }
