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

class OCINP {
  int? ID;
  String? CompanyName;
  String? Address;
  String? CountryCode;
  String? StateCode;
  String? CityCode;
  String? WebSite;
  String? Telephone;
  String? Fax;
  String? SDRequired;
  String? PAN;
  String? TAN;
  String? CIN;
  String? SCurr;
  String? LCurr;
  String? Email;
  String? CountryName;
  String? StateName;
  String? MobURL;
  String? MobDocPAth;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  String? CreatedBy;
  String? BranchId;
  String? UpdatedBy;

  OCINP({
    this.ID,
    this.CompanyName,
    this.Address,
    this.CountryCode,
    this.StateCode,
    this.CityCode,
    this.WebSite,
    this.Telephone,
    this.Fax,
    this.SDRequired,
    this.PAN,
    this.TAN,
    this.CIN,
    this.SCurr,
    this.LCurr,
    this.Email,
    this.CountryName,
    this.StateName,
    this.MobURL,
    this.MobDocPAth,
    this.CreateDate,
    this.UpdateDate,
    this.CreatedBy,
    this.BranchId,
    this.UpdatedBy,
  });

  factory OCINP.fromJson(Map<String, dynamic> json) =>
      OCINP(
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        CompanyName: json['CompanyName'] ?? '',
        Address: json['Address'] ?? '',
        CountryCode: json['CountryCode'] ?? '',
        StateCode: json['StateCode'] ?? '',
        CityCode: json['CityCode'] ?? '',
        WebSite: json['WebSite'] ?? '',
        Telephone: json['Telephone'] ?? '',
        Fax: json['Fax'] ?? '',
        SDRequired: json['SDRequired'] ?? '',
        PAN: json['PAN'] ?? '',
        TAN: json['TAN'] ?? '',
        CIN: json['CIN'] ?? '',
        SCurr: json['SCurr'] ?? '',
        LCurr: json['LCurr'] ?? '',
        Email: json['Email'] ?? '',
        CountryName: json['CountryName'] ?? '',
        StateName: json['StateName'] ?? '',
        MobURL: json['MobURL'] ?? '',
        MobDocPAth: json['MobDocPAth'] ?? '',
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()),
        CreatedBy: json['CreatedBy'] ?? '',
        BranchId: json['BranchId'] ?? '',
        UpdatedBy: json['UpdatedBy'] ?? '',
      );

  Map<String, dynamic> toJson() =>
      {
        'ID': ID,
        'CompanyName': CompanyName,
        'Address': Address,
        'CountryCode': CountryCode,
        'StateCode': StateCode,
        'CityCode': CityCode,
        'WebSite': WebSite,
        'Telephone': Telephone,
        'Fax': Fax,
        'SDRequired': SDRequired,
        'PAN': PAN,
        'TAN': TAN,
        'CIN': CIN,
        'SCurr': SCurr,
        'LCurr': LCurr,
        'Email': Email,
        'CountryName': CountryName,
        'StateName': StateName,
        'MobURL': MobURL,
        'MobDocPAth': MobDocPAth,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'CreatedBy': CreatedBy,
        'BranchId': BranchId,
        'UpdatedBy': UpdatedBy,
      };
}

List<OCINP> oCINPFromJson(String str) =>
    List<OCINP>.from(json.decode(str).map((x) => OCINP.fromJson(x)));

String oCINPToJson(List<OCINP> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<OCINP>> dataSyncOCINP() async {
  var res =
  await http.get(headers: header, Uri.parse(prefix + "OCINP" + postfix));
  print(res.body);
  return oCINPFromJson(res.body);
}

// Future<void> insertOCINP(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteOCINP(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncOCINP();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('OCINP_Temp', customer.toJson());
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
//       "SELECT * FROM  OCINP_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2
//         .update("OCINP", element, where: "ID = ?", whereArgs: [element["ID"]]);
//   });
//   await batch2.commit(noResult: true);
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from OCINP_Temp where ID not in (Select ID from OCINP)");
//   v.forEach((element) {
//     batch3.insert('OCINP', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('OCINP_Temp');
// }
Future<void> insertOCINP(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteOCINP(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncOCINP();
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
      for (OCINP record in batchRecords) {
        try {
          batch.insert('OCINP_Temp', record.toJson());
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
			select * from OCINP_Temp
			except
			select * from OCINP
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
          batch.update("OCINP", element,
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
  print('Time taken for OCINP update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from OCINP_Temp where ID not in (Select ID from OCINP)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM OCINP_Temp T0
LEFT JOIN OCINP T1 ON T0.ID = T1.ID 
WHERE T1.ID IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('OCINP', record);
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
      'Time taken for OCINP_Temp and OCINP compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('OCINP_Temp');
  // stopwatch.stop();
}

Future<List<OCINP>> retrieveOCINP(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('OCINP');
  return queryResult.map((e) => OCINP.fromJson(e)).toList();
}

Future<void> updateOCINP(int id, Map<String, dynamic> values,
    BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('OCINP', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deleteOCINP(Database db) async {
  await db.delete('OCINP');
}

Future<List<OCINP>> retrieveOCINPById(BuildContext? context, String str,
    List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
  await db.query('OCINP', where: str, whereArgs: l);
  return queryResult.map((e) => OCINP.fromJson(e)).toList();
}

Future<void> insertOCINPToServer(BuildContext? context,
    {String? TransId, int? id}) async {
  String response = "";
  List<OCINP> list = await retrieveOCINPById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "TransId = ? AND ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "OCINP/Add"),
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
            .post(Uri.parse(prefix + "OCINP/Add"),
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
            var x = await db.update("OCINP", map,
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

}

Future<void> updateOCINPOnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<OCINP> list = await retrieveOCINPById(
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
          .put(Uri.parse(prefix + 'OCINP/Update'),
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
          var x = await db.update("OCINP", map,
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
