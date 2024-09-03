import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:sqflite/sqlite_api.dart';

List<OCINModel> OCINModelFromJson(String str) =>
    List<OCINModel>.from(json.decode(str).map((x) => OCINModel.fromJson(x)));

String OCINModelToJson(List<OCINModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OCINModel {
  OCINModel({
    this.ID,
    this.CompanyName,
    this.CreateDate,
    this.UpdateDate,
    this.hasCreated = false,
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
    this.MobURL,
    this.MobDocPAth,
    this.StateName,
    this.CreatedBy,
    this.UpdatedBy,
    this.BranchId,
    this.IsLocalDate,
    this.IsMtv,
    this.IsPriceEditable,
    this.DateFormat,
    this.Longitude,
    this.Latitude,
    this.MapRange,
    this.MobSessionTimoutMinute,
    this.MobSyncTimeMinute,
    this.VATNumber,
    this.TPINNumber,
    this.NRCNumber,
    this.LicenseNumber,
    this.NAPSANumber,
    this.NHIMANumber,
    this.ConfigNumberStep,
    this.MinMobileVersion,
    this.MinMobileBuildNo,
    this.OrganizationLogoUrl,
    this.OrganizationBackgroundUrl,
    this.NoOfWhyAnalysis,
    // this.DBUploadPsw,
    this.IsAdditionalDeposit = false,
  });

  int? ID;
  int? NoOfWhyAnalysis;
  int? MobSessionTimoutMinute;
  int? MobSyncTimeMinute;
  String? ConfigNumberStep;
  String? NHIMANumber;
  String? NAPSANumber;
  String? LicenseNumber;
  String? NRCNumber;
  String? VATNumber;
  String? DateFormat;
  String? Longitude;
  String? Latitude;
  String? TPINNumber;
  String? CompanyName;
  String? Address;
  String? CountryCode;
  String? StateCode;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  bool hasCreated;
  bool IsAdditionalDeposit;
  String? CityCode;
  String? WebSite;
  String? Telephone;
  String? Fax;
  bool? SDRequired;
  String? PAN;
  String? TAN;
  String? CIN;
  String? SCurr;
  String? LCurr;
  String? Email;
  String? CountryName;
  String? MobDocPAth;
  String? MobURL;
  String? StateName;
  String? CreatedBy;
  String? UpdatedBy;
  String? BranchId;
  bool? IsLocalDate;
  bool? IsMtv;
  bool? IsPriceEditable;
  double? MapRange;
  String? OrganizationBackgroundUrl;
  String? OrganizationLogoUrl;
  String? MinMobileVersion;

  // String? DBUploadPsw;
  int? MinMobileBuildNo;

  factory OCINModel.fromJson(Map<String, dynamic> json) => OCINModel(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
    NoOfWhyAnalysis: int.tryParse(json["NoOfWhyAnalysis"].toString()) ?? 0,
        MobSessionTimoutMinute:
            int.tryParse(json["MobSessionTimoutMinute"].toString()) ?? 0,
        MobSyncTimeMinute:
            int.tryParse(json["MobSyncTimeMinute"].toString()) ?? 0,
        MinMobileBuildNo:
            int.tryParse(json["MinMobileBuildNo"].toString()) ?? 0,
        CompanyName: json["CompanyName"] ?? "",
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] == 1,
        LicenseNumber: json["LicenseNumber"] ?? "",
        ConfigNumberStep: json["ConfigNumberStep"] ?? "",
        NRCNumber: json["NRCNumber"] ?? "",
        VATNumber: json["VATNumber"] ?? "",
        Address: json["Address"] ?? "",
        NHIMANumber: json["NHIMANumber"] ?? "",
        NAPSANumber: json["NAPSANumber"] ?? "",
        TPINNumber: json["TPINNumber"] ?? "",
        CountryCode: json["CountryCode"] ?? "",
        StateCode: json["StateCode"] ?? "",
        CityCode: json["CityCode"] ?? "",
        WebSite: json["WebSite"] ?? "",
        Telephone: json["Telephone"] ?? "",
        MobURL: json["MobURL"] ?? "",
        // DBUploadPsw: json["DBUploadPsw"] ?? "",
        Longitude: json["Longitude"] ?? "",
        Latitude: json["Latitude"] ?? "",
        Fax: json["Fax"] ?? "",
        SDRequired: json["SDRequired"] is bool
            ? json["SDRequired"]
            : json["SDRequired"] == 1,
        IsAdditionalDeposit: json["IsAdditionalDeposit"] is bool
            ? json["IsAdditionalDeposit"]
            : json["IsAdditionalDeposit"] == 1,
        PAN: json["PAN"] ?? "",
        TAN: json["TAN"] ?? "",
        MobDocPAth: json["MobDocPAth"] ?? "",
        CIN: json["CIN"] ?? "",
        SCurr: json["SCurr"] ?? "",
        LCurr: json["LCurr"] ?? "",
        Email: json["Email"] ?? "",
        OrganizationBackgroundUrl: json["OrganizationBackgroundUrl"] ?? "",
        OrganizationLogoUrl: json["OrganizationLogoUrl"] ?? "",
        CountryName: json["CountryName"] ?? "",
        StateName: json["StateName"] ?? "",
        CreatedBy: json['CreatedBy'] ?? '',
        UpdatedBy: json['UpdatedBy'] ?? '',
        MinMobileVersion: json['MinMobileVersion'] ?? '',
        MapRange: double.tryParse(json['MapRange'].toString()) ?? 0.0,
        DateFormat: json['DateFormat'] ?? '',
        BranchId: json['BranchId'] ?? '',
        IsLocalDate: json['IsLocalDate'] is bool
            ? json['IsLocalDate']
            : json['IsLocalDate'] == 1,
        IsMtv: json['IsMtv'] is bool ? json['IsMtv'] : json['IsMtv'] == 1,
        IsPriceEditable: json['IsPriceEditable'] is bool
            ? json['IsPriceEditable']
            : json['IsPriceEditable'] == 1,
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "NoOfWhyAnalysis": NoOfWhyAnalysis,
        "OrganizationBackgroundUrl": OrganizationBackgroundUrl,
        "OrganizationLogoUrl": OrganizationLogoUrl,
        "ConfigNumberStep": ConfigNumberStep,
        // "DBUploadPsw": DBUploadPsw,
        "NHIMANumber": NHIMANumber,
        "NRCNumber": NRCNumber,
        "TPINNumber": TPINNumber,
        "MobSessionTimoutMinute": MobSessionTimoutMinute,
        "MobSyncTimeMinute": MobSyncTimeMinute,
        "LicenseNumber": LicenseNumber,
        "MapRange": MapRange,
        "CompanyName": CompanyName,
        "CreateDate": CreateDate?.toIso8601String(),
        "UpdateDate": UpdateDate?.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "IsAdditionalDeposit": IsAdditionalDeposit ? 1 : 0,
        "VATNumber": VATNumber,
        "Address": Address,
        "NAPSANumber": NAPSANumber,
        "CountryCode": CountryCode,
        "StateCode": StateCode,
        "CityCode": CityCode,
        "WebSite": WebSite,
        "Telephone": Telephone,
        "Fax": Fax,
        "Longitude": Longitude,
        "Latitude": Latitude,
        "MobDocPAth": MobDocPAth,
        "MobURL": MobURL,
        "SDRequired": SDRequired,
        "PAN": PAN,
        "TAN": TAN,
        "CIN": CIN,
        "SCurr": SCurr,
        "LCurr": LCurr,
        "Email": Email,
        "CountryName": CountryName,
        "StateName": StateName,
        'CreatedBy': CreatedBy,
        'UpdatedBy': UpdatedBy,
        'BranchId': BranchId,
        'DateFormat': DateFormat,
        'IsLocalDate': IsLocalDate,
        'IsMtv': IsMtv,
        'IsPriceEditable': IsPriceEditable,
        'MinMobileVersion': MinMobileVersion,
        'MinMobileBuildNo': MinMobileBuildNo,
      };
}

// Future<void> insertOCIN(Database db)async{
//   if(postfix.toLowerCase().contains("all"))
//   await deleteOCIN(db);
//   List customers= await dataSyncOCIN();
//   print(customers);
//   var batch = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try
//     {
//       batch.insert('OCIN', customer.toJson());
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
//   //       await db.insert('OCIN', customer.toJson());
//   //     });
//   //   }
//   //   catch(e)
//   //   {
//   //     getErrorSnackBar("Sync Error "+e.toString());
//   //   }
//   //
//   // });
// }
// Future<void> insertOCIN(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteOCIN(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncOCIN();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('OCIN_Temp', customer.toJson());
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
//       "SELECT * FROM  OCIN_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN UpdateDate IS NULL THEN CreateDate ELSE UpdateDate END)");
//   u.forEach((element) {
//     batch2.update("OCIN", element,
//         where: "CompanyName = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["CompanyName"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from OCIN_Temp where CompanyName not in (Select CompanyName from OCIN)");
//   v.forEach((element) {
//     batch3.insert('OCIN', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('OCIN_Temp');
// }
Future<void> insertOCIN(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteOCIN(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncOCIN();
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
      for (OCINModel record in batchRecords) {
        try {
          batch.insert('OCIN_Temp', record.toJson());
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
			select * from OCIN_Temp
			except
			select * from OCIN
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
          batch.update("OCIN", element,
              where:
                  "CompanyName = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
              whereArgs: [element["CompanyName"], 1, 1]);
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
  print('Time taken for OCIN update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from OCIN_Temp where CompanyName not in (Select CompanyName from OCIN)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM OCIN_Temp T0
LEFT JOIN OCIN T1 ON T0.CompanyName = T1.CompanyName 
WHERE T1.CompanyName IS NULL;
''');

  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('OCIN', record);
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
      'Time taken for OCIN_Temp and OCIN compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('OCIN_Temp');
  // stopwatch.stop();
}

Future<List<OCINModel>> dataSyncOCIN() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "OCIN" + postfix));
  print(res.body);
  return OCINModelFromJson(res.body);
}

Future<List<OCINModel>> retrieveOCIN(BuildContext? context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('OCIN');
  return queryResult.map((e) => OCINModel.fromJson(e)).toList();
}

Future<void> updateOCIN(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    await db.transaction((db) async {
      await db.update("OCIN", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteOCIN(Database db) async {
  await db.delete('OCIN');
}

//SEND DATA TO SERVER
//--------------------------
Future<List<OCINModel>> retrieveOCINById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('OCIN', where: str, whereArgs: l);
  return queryResult.map((e) => OCINModel.fromJson(e)).toList();
}

// Future<void> insertOCINToServer(BuildContext context) async {
//   retrieveOCINById(context, DataSync.getInsertToServerStr(),
//           DataSync.getInsertToServerList())
//       .then((snapshot) {
//     print(snapshot);
//     snapshot.forEach((data) async {
//       var res = await http.post(Uri.parse(prefix + "OCIN/Add"),
//           headers: header, body: jsonEncode(data.toJson()));
//       print(res.body);
//     });
//   });
// }
//
// Future<void> updateOCINOnServer(BuildContext? context) async {
//   retrieveOCINById(context, DataSync.getUpdateOnServerStr(),
//           DataSync.getUpdateOnServerList())
//       .then((snapshot) {
//     print(snapshot);
//     snapshot.forEach((data) async {
//       var res = await http.put(Uri.parse(prefix + 'OCIN/Update'),
//           headers: header, body: jsonEncode(data.toJson()));
//       print(res.body);
//     });
//   });
// }
