import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/main.dart';
import 'package:sqflite/sqlite_api.dart';

List<OUSRModel> OUSRModelFromJson(String str) =>
    List<OUSRModel>.from(json.decode(str).map((x) => OUSRModel.fromJson(x)));

String OUSRModelToJson(List<OUSRModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OUSRModel {
  OUSRModel({
    required this.ID,
    required this.UserCode,
    required this.UpdateDate,
    this.hasCreated = false,
    required this.Name,
    required this.EmpId,
    required this.EmpName,
    required this.Email,
    required this.MobileNo,
    required this.BranchId,
    required this.BranchName,
    required this.DeptId,
    required this.DeptCode,
    required this.DeptName,
    required this.Password,
    required this.Active,
    required this.RoleId,
    required this.RoleShortDesc,
    required this.CardCode,
    required this.CardName,
    required this.MUser,
    required this.IsPrice,
    required this.CreatedBy,
    required this.CreateDate,
    required this.Type,
    required this.MAC,
    this.UpdatedBy,
  });

  int ID;
  String UserCode;
  String Name;
  String EmpId;
  String EmpName;
  String Email;
  String MobileNo;
  int BranchId;
  String BranchName;
  int DeptId;
  DateTime UpdateDate;
  bool hasCreated;
  String DeptCode;
  String DeptName;
  String Password;
  bool MUser;
  bool IsPrice;
  bool Active;
  int RoleId;
  String RoleShortDesc;
  String CardCode;
  String MAC;
  String CreatedBy;

  String Type;
  String? Currency;

  ///TO BE USED FOR DEVELOPMENT PURPOSE ONLY
  String? Rate;

  ///TO BE USED FOR DEVELOPMENT PURPOSE ONLY
  String CardName;
  String? EmpCode;
  String? EmpGID;
  DateTime CreateDate;
  String? UpdatedBy;

  factory OUSRModel.fromJson(Map<String, dynamic> json) => OUSRModel(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        UserCode: json["UserCode"] ?? "",
        Name: json["Name"] ?? "",
        EmpId: json["EmpId"] ?? '',
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] == 1,
        EmpName: json["EmpName"] ?? "",
        Email: json["Email"] ?? "",
        MobileNo: json["MobileNo"] ?? "",
        BranchId: int.tryParse(json["BranchId"].toString()) ?? 0,
        MAC: json["MAC"] ?? "",
        BranchName: json["BranchName"] ?? "",
        DeptId: int.tryParse(json["DeptId"].toString()) ?? 0,
        Type: json["Type"] ?? "",
        DeptCode: json["DeptCode"] ?? "",
        DeptName: json["DeptName"] ?? "",
        Password: json["Password"] ?? "",
        Active: json["Active"] is bool ? json["Active"] : json["Active"] == 1,
        MUser: json["MUser"] is bool ? json["MUser"] : json["MUser"] == 1,
        IsPrice:
            json["IsPrice"] is bool ? json["IsPrice"] : json["IsPrice"] == 1,
        RoleId: int.tryParse(json["RoleId"].toString()) ?? 0,
        CreatedBy: json["CreatedBy"] ?? "",
        RoleShortDesc: json["RoleShortDesc"] ?? "",
        CardCode: json["CardCode"] ?? "",
        CardName: json["CardName"] ?? "",
        UpdatedBy: json['UpdatedBy'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "UserCode": UserCode,
        "Name": Name,
        "UpdateDate": UpdateDate.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "EmpId": EmpId,
        "EmpName": EmpName,
        "Email": Email,
        "MobileNo": MobileNo,
        "BranchId": BranchId,
        "BranchName": BranchName,
        "DeptId": DeptId,
        "DeptCode": DeptCode,
        "DeptName": DeptName,
        "Password": Password,
        "Active": Active == true ? 1 : 0,
        "RoleId": RoleId,
        "RoleShortDesc": RoleShortDesc,
        "CardCode": CardCode,
        "CardName": CardName,
        "Type": Type,
        "CreatedBy": CreatedBy,
        "MUser": MUser == true ? 1 : 0,
        "IsPrice": IsPrice == true ? 1 : 0,
        "MAC": MAC,
        "CreateDate": CreateDate.toIso8601String(),
        'UpdatedBy': UpdatedBy,
      };
}

Future<List<OUSRModel>> dataSyncOUSR() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "OUSR" + postfix));
  print(res.body);
  return OUSRModelFromJson(res.body);
}

Future<void> setCurrency() async {
  final Database db = await initializeDB(null);
  var data = await db.rawQuery("SELECT LCurr FROM OCIN");
  if (data.length != 0) {
    userModel.Currency = data[0]['LCurr'].toString();
    userModel.Rate = 1.toString();
  }

  setEmployee();
}

Future<void> setEmployee() async {
  final Database db = await initializeDB(null);
  var data = await db.rawQuery(
      "SELECT T1.Code as EmpCode,T1.EmpGroupId as EmpGID, (T1.FirstName || ' ' || T1.MiddleName  || ' ' ||  T1.LastName) as EmpName FROM OUSR T0 INNER JOIN OEMP T1 ON T0.EmpId=T1.Code WHERE T0.UserCode=\'${userModel.UserCode}\'");
  if (data.isNotEmpty) {
    userModel.EmpName = data[0]['EmpName']?.toString() ?? '';
    userModel.EmpGID = data[0]['EmpGID']?.toString() ?? '';
    userModel.EmpCode = data[0]['EmpCode']?.toString() ?? '';
  }
}

Future<List<OUSRModel>> retrieveOUSR(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('OUSR');
  return queryResult.map((e) => OUSRModel.fromJson(e)).toList();
}

Future<List<OUSRModel>> retrieveLoginData(
    BuildContext context, String username, String password) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.rawQuery(
      'SELECT * FROM OUSR WHERE UserCode=\'$username\' COLLATE NOCASE and Password=\'$password\' AND Active=1');
  return queryResult.map((e) => OUSRModel.fromJson(e)).toList();
}

Future<void> updateOUSR(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    await db.transaction((db) async {
      await db.update("OUSR", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteOUSR(Database db) async {
  await db.delete('OUSR');
}

// Future<void> insertOUSR(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteOUSR(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncOUSR();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('OUSR_Temp', customer.toJson());
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
//       "SELECT * FROM  OUSR_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("OUSR", element,
//         where: "UserCode = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["UserCode"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from OUSR_Temp where UserCode not in (Select UserCode from OUSR)");
//   v.forEach((element) {
//     batch3.insert('OUSR', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('OUSR_Temp');
// }
Future<void> insertOUSR(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteOUSR(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncOUSR();
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
      for (OUSRModel record in batchRecords) {
        try {
          batch.insert('OUSR_Temp', record.toJson());
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
			select * from OUSR_Temp
			except
			select * from OUSR
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
          batch.update("OUSR", element,
              where:
                  "UserCode = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
              whereArgs: [element["UserCode"], 1, 1]);
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
  print('Time taken for OUSR update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from OUSR_Temp where UserCode not in (Select UserCode from OUSR)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM OUSR_Temp T0
LEFT JOIN OUSR T1 ON T0.UserCode = T1.UserCode 
WHERE T1.UserCode IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('OUSR', record);
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
      'Time taken for OUSR_Temp and OUSR compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('OUSR_Temp');
  // stopwatch.stop();
}

Future<OUSRModel?> loginUsingAPI({
  required String username,
  required String hashedPassword,
}) async {
  credentials = '$username:$hashedPassword';
  credentials = '$username:';
  print(header);
  var response =
      await http.get(Uri.parse(prefix + 'OCIN/GetAll'), headers: header);
  print(response.body);
  if (response.body.isEmpty) {
    return null;
  }
  return OUSRModel.fromJson(jsonDecode(response.body));
}

//SEND DATA TO SERVER
//--------------------------
Future<List<OUSRModel>> retrieveOUSRById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('OUSR', where: str, whereArgs: l);
  return queryResult.map((e) => OUSRModel.fromJson(e)).toList();
}

// Future<void> insertOUSRToServer(BuildContext context) async {
//   retrieveOUSRById(context, DataSync.getInsertToServerStr(),
//           DataSync.getInsertToServerList())
//       .then((snapshot) {
//     print(snapshot);
//     snapshot.forEach((data) async {
//       var res = await http.post(Uri.parse(prefix + "OUSR/Add"),
//           headers: header, body: jsonEncode(data.toJson()));
//       print(res.body);
//     });
//   });
// }
//
// Future<void> updateOUSROnServer(BuildContext? context) async {
//   retrieveOUSRById(context, DataSync.getUpdateOnServerStr(),
//           DataSync.getUpdateOnServerList())
//       .then((snapshot) {
//     print(snapshot);
//     snapshot.forEach((data) async {
//       var res = await http.put(Uri.parse(prefix + 'OUSR/Update'),
//           headers: header, body: jsonEncode(data.toJson()));
//       print(res.body);
//     });
//   });
// }
