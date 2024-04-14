import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/AppConfig.dart';
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/Component/UploadImageToServer.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

List<EXR1Model> EXR1ModelFromJson(String str) =>
    List<EXR1Model>.from(json.decode(str).map((x) => EXR1Model.fromJson(x)));

String EXR1ModelToJson(List<EXR1Model> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EXR1Model {
  EXR1Model({
    this.ID,
    this.ExpenseDate,
    this.CreateDate,
    this.ApprDate,
    this.UpdateDate,
    this.hasCreated = false,
    this.selected = false,
    this.isDisabled = false,
    this.TransId,
    this.EmpGroupId,
    this.RowId,
    this.ExpId,
    this.ExpShortDesc,
    this.Based,
    this.ValidFrom,
    this.ValidTo,
    this.Remarks,
    this.Mandatory = false,
    this.Amount,
    this.Factor,
    this.RAmount,
    this.RRemarks,
    this.AAmount,
    this.ARemarks,
    this.ReconAmt,
    // this.DiffAmount,
    this.isAddedToDB = false,
    this.hasUpdated = false,
    this.DocEntry,
    this.DocNum,
    this.LineApprovalStatus,
    this.Attachment,
  });

  int? ID;
  int? EmpGroupId;
  int? ExpId;
  int? RowId;
  String? TransId;
  String? ExpShortDesc;
  String? Based;
  String? Attachment;
  String? LineApprovalStatus;
  DateTime? ValidFrom;
  DateTime? ExpenseDate;
  DateTime? CreateDate;
  DateTime? ApprDate;
  DateTime? UpdateDate;
  bool isAddedToDB;
  bool hasCreated;
  bool selected;
  bool isDisabled;
  DateTime? ValidTo;
  String? Remarks;
  bool Mandatory;
  double? Amount;
  double? Factor;
  double? RAmount;
  String? RRemarks;
  double? AAmount;
  String? ARemarks;
  double? ReconAmt;
  bool hasUpdated;
  int? DocEntry;
  String? DocNum;

  // double? DiffAmount;

  factory EXR1Model.fromJson(Map<String, dynamic> json) => EXR1Model(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        Attachment: json["Attachment"] ?? "",
        TransId: json["TransId"] ?? "",
        EmpGroupId: int.tryParse(json["EmpGroupId"].toString()) ?? 0,
        RowId: int.tryParse(json["RowId"].toString()) ?? 0,
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        ApprDate: DateTime.tryParse(json["ApprDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] == 1,
        LineApprovalStatus: json['LineApprovalStatus'],
        DocEntry: json['DocEntry'],
        DocNum: json['DocNum'],
        ExpId: int.tryParse(json["ExpId"].toString()) ?? 0,
        ExpShortDesc: json["ExpShortDesc"] ?? "",
        Based: json["Based"] ?? "",
        Remarks: json["Remarks"] ?? "",
        ValidFrom: DateTime.tryParse(json["ValidFrom"].toString()) ??
            DateTime.parse("1900-01-01"),
        ExpenseDate: DateTime.tryParse(json["ExpenseDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        ValidTo: DateTime.tryParse(json["ValidTo"].toString()) ??
            DateTime.parse("1900-01-01"),
        Mandatory: json["Mandatory"] is bool
            ? json["Mandatory"]
            : json["Mandatory"] == 1,
        Amount: double.tryParse(json["Amount"].toString()) ?? 0.0,
        Factor: double.tryParse(json["Factor"].toString()) ?? 0.0,
        RAmount: double.tryParse(json["RAmount"].toString()) ?? 0.0,
        AAmount: double.tryParse(json["AAmount"].toString()) ?? 0.0,
        RRemarks: json["RRemarks"] ?? "",
        ARemarks: json["ARemarks"] ?? "",
        ReconAmt: double.tryParse(json["ReconAmt"].toString()) ?? 0.0,
        // DiffAmount: double.tryParse(json["DiffAmount"].toString()) ?? 0.0,
        hasUpdated: json['has_updated'] == 1,
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "TransId": TransId,
        "Attachment": Attachment,
        "RowId": RowId,
        "EmpGroupId": EmpGroupId,
        'LineApprovalStatus': LineApprovalStatus,
        'DocEntry': DocEntry,
        'DocNum': DocNum,
        "ExpenseDate": ExpenseDate?.toIso8601String(),
        "CreateDate": CreateDate?.toIso8601String(),
        "ApprDate": ApprDate?.toIso8601String(),
        "UpdateDate": UpdateDate?.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "has_updated": hasUpdated ? 1 : 0,
        "ExpId": ExpId,
        "ExpShortDesc": ExpShortDesc,
        "Based": Based,
        "ValidFrom": ValidFrom?.toIso8601String(),
        "ValidTo": ValidTo?.toIso8601String(),
        "Remarks": Remarks,
        "Mandatory": Mandatory ? 1 : 0,
        "Amount": Amount,
        "Factor": Factor,
        "RAmount": RAmount,
        "RRemarks": RRemarks,
        "AAmount": AAmount,
        "ARemarks": ARemarks,
        "ReconAmt": ReconAmt,
        // "DiffAmount": DiffAmount,
      };
}

Future<List<EXR1Model>> dataSyncEXR1() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "EXR1" + postfix));
  print(res.body);
  return EXR1ModelFromJson(res.body);
}

Future<List<EXR1Model>> retrieveEXR1(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('EXR1');
  return queryResult.map((e) => EXR1Model.fromJson(e)).toList();
}

Future<List<EXR1Model>> retrieveReconciliationData(
    {required String CRTransId}) async {
  final Database db = await initializeDB(null);
  final List<Map<String, Object?>> queryResult = await db.rawQuery('''
  SELECT exr1.* FROM OEXR oexr  INNER JOIN EXR1 exr1 ON oexr.TransId=exr1.TransId
 WHERE oexr.CRTransId='$CRTransId'
  ''');
  return queryResult.map((e) => EXR1Model.fromJson(e)).toList();
}

Future<void> updateEXR1(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    await db.transaction((db) async {
      await db.update("EXR1", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteEXR1(Database db) async {
  await db.delete('EXR1');
}

// Future<void> insertEXR1(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteEXR1(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncEXR1();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('EXR1_Temp', customer.toJson());
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
//       "SELECT * FROM  EXR1_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN UpdateDate IS NULL THEN CreateDate ELSE UpdateDate END)");
//   u.forEach((element) {
//     batch2.update("EXR1", element,
//         where:
//             "RowId = ? AND TransId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["RowId"], element["TransId"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from EXR1_Temp where TransId || RowId not in (Select TransId || RowId from EXR1)");
//   v.forEach((element) {
//     batch3.insert('EXR1', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('EXR1_Temp');
// }
Future<void> insertEXR1(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteEXR1(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncEXR1();
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
      for (EXR1Model record in batchRecords) {
        try {
          batch.insert('EXR1_Temp', record.toJson());
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
			select * from EXR1_Temp
			except
			select * from EXR1
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
          batch.update("EXR1", element,
              where:
                  "RowId = ? AND TransId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
              whereArgs: [element["RowId"], element["TransId"], 1, 1]);
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
  print('Time taken for EXR1 update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from EXR1_Temp where TransId || RowId not in (Select TransId || RowId from EXR1)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM EXR1_Temp T0
LEFT JOIN EXR1 T1 ON T0.TransId = T1.TransId AND T0.RowId = T1.RowId
WHERE T1.TransId IS NULL AND T1.RowId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('EXR1', record);
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
      'Time taken for EXR1_Temp and EXR1 compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('EXR1_Temp');
  // stopwatch.stop();
}

//SEND DATA TO SERVER
//--------------------------
Future<List<EXR1Model>> retrieveEXR1ById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('EXR1', where: str, whereArgs: l);
  return queryResult.map((e) => EXR1Model.fromJson(e)).toList();
}

Future<List<EXR1Model>> retrieveEXR1ForRecon({
  required String CRTransId,
  required String ExpShortDesc,
}) async {
  final Database db = await initializeDB(null);
  String query = '''
   SELECT  exr1.* FROM OEXR oexr  INNER JOIN EXR1 exr1 ON oexr.TransId=exr1.TransId
 WHERE oexr.CRTransId='$CRTransId' AND exr1.ExpShortDesc='$ExpShortDesc'
  ''';
  final List<Map<String, Object?>> queryResult = await db.rawQuery(query);
  return queryResult.map((e) => EXR1Model.fromJson(e)).toList();
}

Future<void> insertEXR1ToServer(BuildContext? context,
    {String? TransId, int? ID}) async {
  String response = "";
  List<EXR1Model> list = await retrieveEXR1ById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "TransId = ? AND ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, ID]);
  if (TransId != null) {
    //only single entry
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "EXR1/Add"),
        headers: header, body: jsonEncode(list[0].toJson()));
    print(res.body);
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
        print(list[i].Attachment);
        if (list[i].Attachment?.contains(appPkg) == true) {
          File imageFile = File(list[i].Attachment ?? '');
          String url =
              await uploadImageToServer(imageFile, null, setURL: (url) {
            print(url);
          });

          //todo:
          list[i].Attachment = prefix + url;
        }
        String queryParams='TransId=${list[i].TransId}&RowId=${list[i].RowId}';
        var res = await http.post(Uri.parse(prefix + "EXR1/Add?$queryParams"),
                headers: header, body: jsonEncode(map))
            .timeout(Duration(seconds: 30), onTimeout: () {
          writeToLogFile(
              text: '500 error \nMap : $map',
              fileName: StackTrace.current.toString(),
              lineNo: 141);
          return http.Response('Error', 500);
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
        if(res.statusCode ==409)
        {
          ///Already added in server
          final Database db = await initializeDB(context);
          EXR1Model model=EXR1Model.fromJson(jsonDecode(res.body));
          var x = await db.update("EXR1", model.toJson(),
              where: "TransId = ? AND RowId = ?", whereArgs: [model.TransId,model.RowId]);
          print(x.toString());
        }
        else
        if (res.statusCode == 201 || res.statusCode == 500) {
          sentSuccessInServer = true;
          if (res.statusCode == 201) {
            map['ID'] = jsonDecode(res.body)['ID'];
            final Database db = await initializeDB(context);
            map["has_created"] = 0;
            var x = await db.update("EXR1", map,
                where: "TransId = ? AND RowId = ?",
                whereArgs: [map["TransId"], map["RowId"]]);
            print(x.toString());
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
/////////////////////////////////
    // list.forEach((data) async {
    //   print(data.toJson());
    //   var res = await http.post(Uri.parse(prefix + "EXR1/Add"), headers: header, body: jsonEncode(data.toJson()));
    //   response = res.body;
    // });
  }

  // retrieveEXR1ById(context,DataSync.getInsertToServerStr(),DataSync.getInsertToServerList()).then((snapshot){
  //   print(snapshot);
  //   snapshot.forEach((data) async {
  //     var res = await http.post(
  //         Uri.parse(prefix + "EXR1/Add"),
  //         headers:header, body: jsonEncode(data.toJson())
  //     );
  //     print(res.body);
  //   });
  // });
}

// Future<void> updateEXR1OnServer(BuildContext? context,
//     {String? condition, List? l}) async {
//
//   retrieveEXR1ById(
//           context,
//           l == null ? DataSync.getUpdateOnServerStr() : condition ?? "",
//           l == null ? DataSync.getUpdateOnServerList() : l)
//       .then((snapshot) {
//     print(snapshot);
//     snapshot.forEach((data) async {
//       var res = await http.put(Uri.parse(prefix + 'EXR1/Update'),
//           headers: header, body: jsonEncode(data.toJson()));
//       print(res.body);
//     });
//   });
// }

Future<void> updateEXR1OnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<EXR1Model> list = await retrieveEXR1ById(
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
          .put(Uri.parse(prefix + 'EXR1/Update'),
              headers: header, body: jsonEncode(map))
          .timeout(Duration(seconds: 30), onTimeout: () {
        writeToLogFile(
            text: '500 error \nMap : $map',
            fileName: StackTrace.current.toString(),
            lineNo: 141);
        return http.Response('Error', 500);
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
          var x = await db.update("EXR1", map,
              where: "TransId = ? AND RowId = ?",
              whereArgs: [map["TransId"], map["RowId"]]);
          print(x.toString());
        } else {
          await writeToLogFile(
              text: '500 error \nMap : $map',
              fileName: StackTrace.current.toString(),
              lineNo: 141);
        }
      }
      print(res.body);
    } catch (e) {
      await writeToLogFile(
          text: '${e.toString()}\nMap : $map',
          fileName: StackTrace.current.toString(),
          lineNo: 141);
      sentSuccessInServer = true;
    }

    i++;
    print("INDEX = " + i.toString());
  } while (i < list.length && sentSuccessInServer == true);
}
