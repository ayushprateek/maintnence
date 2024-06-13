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

class MNVCL2 {
  int? ID;
  String? Code;
  int? RowId;
  String? TyreCode;
  String? SerialNo;
  int? XAxles;
  int? YTyres;
  double? Tread;
  String? Pressure;
  String? TyreStatus;
  int? ZPosition;
  int? LR;
  String? Attachment;
  String? Remarks;
  DateTime? CreateDate;
  DateTime? UpdateDate;

  MNVCL2({
    this.ID,
    this.Code,
    this.RowId,
    this.TyreCode,
    this.SerialNo,
    this.XAxles,
    this.YTyres,
    this.Tread,
    this.Pressure,
    this.TyreStatus,
    this.ZPosition,
    this.LR,
    this.Attachment,
    this.Remarks,
    this.CreateDate,
    this.UpdateDate,
  });

  factory MNVCL2.fromJson(Map<String, dynamic> json) => MNVCL2(
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        Code: json['Code']?.toString() ?? '',
        RowId: int.tryParse(json['RowId'].toString()) ?? 0,
        TyreCode: json['TyreCode']?.toString() ?? '',
        SerialNo: json['SerialNo']?.toString() ?? '',
        XAxles: int.tryParse(json['XAxles'].toString()) ?? 0,
        YTyres: int.tryParse(json['YTyres'].toString()) ?? 0,
        Tread: double.tryParse(json['Tread'].toString()) ?? 0.0,
        Pressure: json['Pressure']?.toString() ?? '',
        TyreStatus: json['TyreStatus']?.toString() ?? '',
        ZPosition: int.tryParse(json['ZPosition'].toString()) ?? 0,
        LR: int.tryParse(json['LR'].toString()) ?? 0,
        Attachment: json['Attachment']?.toString() ?? '',
        Remarks: json['Remarks']?.toString() ?? '',
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()),
      );

  Map<String, dynamic> toJson() => {
        'ID': ID,
        'Code': Code,
        'RowId': RowId,
        'TyreCode': TyreCode,
        'SerialNo': SerialNo,
        'XAxles': XAxles,
        'YTyres': YTyres,
        'Tread': Tread,
        'Pressure': Pressure,
        'TyreStatus': TyreStatus,
        'ZPosition': ZPosition,
        'LR': LR,
        'Attachment': Attachment,
        'Remarks': Remarks,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
      };
}

List<MNVCL2> mNVCL2FromJson(String str) =>
    List<MNVCL2>.from(json.decode(str).map((x) => MNVCL2.fromJson(x)));

String mNVCL2ToJson(List<MNVCL2> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<MNVCL2>> dataSyncMNVCL2() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "MNVCL2" + postfix));
  print(res.body);
  return mNVCL2FromJson(res.body);
}

Future<void> insertMNVCL2(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteMNVCL2(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncMNVCL2();
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
      for (MNVCL2 record in batchRecords) {
        try {
          batch.insert('MNVCL2_Temp', record.toJson());
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
			select * from MNVCL2_Temp
			except
			select * from MNVCL2
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
          batch.update("MNVCL2", element,
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
  print('Time taken for MNVCL2 update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from MNVCL2_Temp where TransId not in (Select TransId from MNVCL2)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM MNVCL2_Temp T0
LEFT JOIN MNVCL2 T1 ON T0.Code = T1.Code AND T0.RowId = T1.RowId
WHERE T1.Code IS NULL AND T1.RowId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('MNVCL2', record);
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
      'Time taken for MNVCL2_Temp and MNVCL2 compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('MNVCL2_Temp');
}

Future<List<MNVCL2>> retrieveMNVCL2(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('MNVCL2');
  return queryResult.map((e) => MNVCL2.fromJson(e)).toList();
}

Future<void> updateMNVCL2(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update('MNVCL2', values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    getErrorSnackBar('Sync Error ' + e.toString());
  }
}

Future<void> deleteMNVCL2(Database db) async {
  await db.delete('MNVCL2');
}

Future<List<MNVCL2>> retrieveMNVCL2ById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('MNVCL2', where: str, whereArgs: l);
  return queryResult.map((e) => MNVCL2.fromJson(e)).toList();
}

Future<String> insertMNVCL2ToServer(BuildContext? context,
    {String? TransId, int? id}) async {
  String response = "";
  List<MNVCL2> list = await retrieveMNVCL2ById(
      context,
      TransId == null
          ? DataSync.getInsertToServerStr()
          : "TransId = ? AND ID = ?",
      TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
  if (TransId != null) {
    list[0].ID = 0;
    var res = await http.post(Uri.parse(prefix + "MNVCL2/Add"),
        headers: header, body: jsonEncode(list[0].toJson()));
    response = res.body;
  } else if (list.isNotEmpty) {
    int i = 0;
    bool sentSuccessInServer = false;
    do {
      sentSuccessInServer = false;
      try {
        Map<String, dynamic> map = list[i].toJson();
        map.remove('ID');
        var res = await http
            .post(Uri.parse(prefix + "MNVCL2/Add"),
                headers: header, body: jsonEncode(map))
            .timeout(Duration(seconds: 30), onTimeout: () {
          return http.Response('Error', 500);
        });
        response = await res.body;
        print("eeaaae status");
        print(await res.statusCode);
        if (res.statusCode == 409) {
          ///Already added in server
          final Database db = await initializeDB(context);
          MNVCL2 model = MNVCL2.fromJson(jsonDecode(res.body));
          map["ID"] = model.ID;
          map["has_created"] = 0;
          var x = await db.update("MNVCL2", map,
              where: "Code = ? AND RowId = ?",
              whereArgs: [model.Code,model.RowId]);
          print(x.toString());
        } else
        if (res.statusCode == 201 || res.statusCode == 500) {
          sentSuccessInServer = true;
          if (res.statusCode == 201) {
            map['ID'] = jsonDecode(res.body)['ID'];
            final Database db = await initializeDB(context);
            // map=jsonDecode(res.body);
            map["has_created"] = 0;
            var x = await db.update("MNVCL2", map,
                where: "Code = ? AND RowId = ?",
                whereArgs: [map["Code"], map["RowId"]]);
            print(x.toString());
          }
        }
        print(res.body);
      } catch (e) {
        print("Timeout " + e.toString());
        sentSuccessInServer = true;
      }
      i++;
      print("INDEX = " + i.toString());
    } while (i < list.length && sentSuccessInServer == true);
  }
  return response;
}

Future<void> updateMNVCL2OnServer(BuildContext? context,
    {String? condition, List? l}) async {
  List<MNVCL2> list = await retrieveMNVCL2ById(
      context,
      l == null ? DataSync.getUpdateOnServerStr() : condition ?? "",
      l == null ? DataSync.getUpdateOnServerList() : l);
  print(list);
  int i = 0;
  bool sentSuccessInServer = false;
  do {
    sentSuccessInServer = false;
    try {
      Map<String, dynamic> map = list[i].toJson();
      var res = await http
          .put(Uri.parse(prefix + 'MNVCL2/Update'),
              headers: header, body: jsonEncode(map))
          .timeout(Duration(seconds: 30), onTimeout: () {
        return http.Response('Error', 500);
      });
      print(await res.statusCode);
      if (res.statusCode == 201 || res.statusCode == 500) {
        sentSuccessInServer = true;
        if (res.statusCode == 201) {
          final Database db = await initializeDB(context);
          map["has_updated"] = 0;
          var x = await db.update("MNVCL2", map,
              where: "Code = ? AND RowId = ?",
              whereArgs: [map["Code"], map["RowId"]]);
          print(x.toString());
        }
      }
      print(res.body);
    } catch (e) {
      print("Timeout " + e.toString());
      sentSuccessInServer = true;
    }

    i++;
    print("INDEX = " + i.toString());
  } while (i < list.length && sentSuccessInServer == true);
}
