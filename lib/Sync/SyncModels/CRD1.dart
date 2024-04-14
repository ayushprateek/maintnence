import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

List<CRD1Model> CRD1ModelFromJson(String str) =>
    List<CRD1Model>.from(json.decode(str).map((x) => CRD1Model.fromJson(x)));

String CRD1ModelToJson(List<CRD1Model> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CRD1Model {
  CRD1Model({
    required this.ID,
    required this.Code,
    required this.RowId,
    required this.FirstName,
    required this.MiddleName,
    required this.LastName,
    required this.JobTitle,
    required this.Position,
    required this.Department,
    required this.MobileNo,
    required this.Email,
    required this.Gender,
    required this.DateOfBirth,
    required this.Active,
    required this.Attachment,
    required this.Address,
    required this.CreateDate,
    required this.UpdateDate,
    this.hasCreated = false,
  });

  int ID;
  String Code;
  int RowId;
  String FirstName;
  String MiddleName;
  String LastName;
  String JobTitle;
  String Position;
  String Department;
  String MobileNo;
  String Email;
  String Gender;
  DateTime DateOfBirth;
  bool Active;
  String Attachment;
  String Address;
  DateTime CreateDate;
  DateTime UpdateDate;
  bool hasCreated;

  factory CRD1Model.fromJson(Map<String, dynamic> json) => CRD1Model(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        Code: json["Code"] ?? "",
        RowId: int.tryParse(json["RowId"].toString()) ?? 0,
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] == 1,
        FirstName: json["FirstName"] ?? "",
        MiddleName: json["MiddleName"] ?? "",
        LastName: json["LastName"] ?? "",
        JobTitle: json["JobTitle"] ?? "",
        Position: json["Position"] ?? "",
        Department: json["Department"] ?? "",
        MobileNo: json["MobileNo"] ?? "",
        Email: json["Email"] ?? "",
        Gender: json["Gender"] ?? "",
        DateOfBirth: DateTime.tryParse(json["DateOfBirth"].toString()) ??
            DateTime.parse("1900-01-01"),
        Active: json["Active"] is bool ? json["Active"] : json["Active"] == 1,
        Attachment: json["Attachment"] ?? "",
        Address: json["Address"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "Code": Code,
        "RowId": RowId,
        "FirstName": FirstName,
        "MiddleName": MiddleName,
        "LastName": LastName,
        "JobTitle": JobTitle,
        "Position": Position,
        "Department": Department,
        "MobileNo": MobileNo,
        "Email": Email,
        "Gender": Gender,
        "DateOfBirth": DateOfBirth.toIso8601String(),
        "CreateDate": CreateDate.toIso8601String(),
        "UpdateDate": UpdateDate.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "Active": Active == true ? 1 : 0,
        "Attachment": Attachment,
        "Address": Address,
      };
}

Future<List<CRD1Model>> dataSyncCRD1() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "CRD1" + postfix));
  print(res.body);
  return CRD1ModelFromJson(res.body);
}

// Future<void> insertCRD1(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteCRD1(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncCRD1();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('CRD1_Temp', customer.toJson());
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
//       "SELECT * FROM  CRD1_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("CRD1", element,
//         where:
//             "RowId = ? AND Code = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["RowId"], element["Code"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from CRD1_Temp where Code || RowId not in (Select Code || RowId from CRD1)");
//   print(v.runtimeType);
//   v.forEach((element) {
//     print(element);
//     batch3.insert('CRD1', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('CRD1_Temp');
// }

Future<void> insertCRD1(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteCRD1(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncCRD1();
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
      for (CRD1Model record in batchRecords) {
        try {
          batch.insert('CRD1_Temp', record.toJson());
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
			select * from CRD1_Temp
			except
			select * from CRD1
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
          batch.update("CRD1", element,
              where:
              "RowId = ? AND Code = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
              whereArgs: [element["RowId"], element["Code"], 1, 1]);
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
  print('Time taken for CRD1 update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from CRD1_Temp where Code || RowId not in (Select Code || RowId from CRD1)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM CRD1_Temp T0
LEFT JOIN CRD1 T1 ON T0.Code = T1.Code AND T0.RowId = T1.RowId
WHERE T1.Code IS NULL AND T1.RowId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('CRD1', record);
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
      'Time taken for CRD1_Temp and CRD1 compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('CRD1_Temp');
  // stopwatch.stop();
}


Future<List<CRD1Model>> retrieveCRD1(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('CRD1');
  return queryResult.map((e) => CRD1Model.fromJson(e)).toList();
}

Future<void> updateCRD1(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update("CRD1", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteCRD1(Database db) async {
  await db.delete('CRD1');
}

//SEND DATA TO SERVER
//--------------------------
Future<List<CRD1Model>> retrieveCRD1ById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('CRD1', where: str, whereArgs: l);
  return queryResult.map((e) => CRD1Model.fromJson(e)).toList();
}

Future<void> insertCRD1ToServer(BuildContext? context,
    {String? TransId, int? id}) async {
  String response = "";
  List<CRD1Model> list = await retrieveCRD1ById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "TransId = ? AND ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);

  if (TransId != null) {
    //only single entry
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "CRD1/Add"),
        headers: header, body: jsonEncode(list[0].toJson()));
    response = res.body;
  } else if (list.isNotEmpty) {
    //asxkncuievbuefvbeivuehveubvbeuivuibervuierbvueir
    int i = 0;
    bool sentSuccessInServer = false;
    if (list.isEmpty) {
      return;
    }

    do {
      Map<String, dynamic> map = list[i].toJson();
      sentSuccessInServer = false;
      try {
        map.remove('ID');
        String queryParams='Code=${list[i].Code}&RowId=${list[i].RowId}';
        var res = await http
            .post(Uri.parse(prefix + "CRD1/Add?$queryParams"),
            headers: header, body: jsonEncode(map))
            .timeout(Duration(seconds: 30), onTimeout: () {
          writeToLogFile(
              text: '500 error \nMap : $map', fileName: StackTrace.current.toString(), lineNo: 141);return http.Response('Error', 500);
        });
        response = await res.body;

        print("status");
        print(await res.statusCode);
        if(res.statusCode != 201)
        {
          await writeToLogFile(
              text: '${res.statusCode} error \nMap : $map\nResponse : ${res.body}',
              fileName: StackTrace.current.toString(),
              lineNo: 141);
        }
        if(res.statusCode ==409)
        {
          ///Already added in server
          final Database db = await initializeDB(context);
          CRD1Model model=CRD1Model.fromJson(jsonDecode(res.body));
          var x = await db.update("CRD1", model.toJson(),
              where: "Code = ? AND RowId = ?", whereArgs: [model.Code,model.RowId]);
          print(x.toString());
        }
        else
        if (res.statusCode == 201 || res.statusCode == 500) {
          sentSuccessInServer = true;
          if (res.statusCode == 201) {
            map['ID'] = jsonDecode(res.body)['ID'];
            final Database db = await initializeDB(context);
            map["has_created"] = 0;
            var x = await db.update("CRD1", map,
                where: "Code = ? AND RowId = ?",
                whereArgs: [map["Code"], map["RowId"]]);
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
            text: '${e.toString()}\nMap : $map',
            fileName: StackTrace.current.toString(),
            lineNo: 141);
        sentSuccessInServer = true;
      }

      i++;
      print("INDEX = " + i.toString());
    } while (i < list.length && sentSuccessInServer == true);
  }
}

Future<void> updateCRD1OnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<CRD1Model> list = await retrieveCRD1ById(
      context,
      l == null ? DataSync.getUpdateOnServerStr() : condition ?? "",
      l == null ? DataSync.getUpdateOnServerList() : l);
  print(list);

  int i = 0;
  bool sentSuccessInServer = false;
  if (list.isEmpty) {
    return;
  }
  do {
    Map<String, dynamic> map = list[i].toJson();
    sentSuccessInServer = false;
    try {
      if (list.isEmpty) {
        return;
      }
      Map<String, dynamic> map = list[i].toJson();
      var res = await http
          .put(Uri.parse(prefix + 'CRD1/Update'),
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
          var x = await db.update("CRD1", map,
              where: "Code = ? AND RowId = ?",
              whereArgs: [map["Code"], map["RowId"]]);
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
          text: '${e.toString()}\nMap : $map',
          fileName: StackTrace.current.toString(),
          lineNo: 141);
      sentSuccessInServer = true;
    }

    i++;
    print("INDEX = " + i.toString());
  } while (i < list.length && sentSuccessInServer == true);
}
