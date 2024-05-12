import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:maintenance/main.dart';
import 'package:sqflite/sqlite_api.dart';

List<OCRDModel> OCRDModelFromJson(String str) =>
    List<OCRDModel>.from(json.decode(str).map((x) => OCRDModel.fromJson(x)));

String OCRDModelToJson(List<OCRDModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OCRDModel {
  OCRDModel({
    required this.ID,
    this.hasCreated = false,
    required this.Code,
    required this.FirstName,
    required this.MiddleName,
    required this.LastName,
    required this.Group,
    required this.SubGroup,
    required this.Currency,
    required this.Telephone,
    required this.MobileNo,
    required this.Address,
    required this.CityCode,
    required this.CityName,
    required this.StateCode,
    required this.StateName,
    required this.CountryCode,
    required this.CountryName,
    required this.Email,
    required this.Website,
    required this.SAPCustomer,
    required this.PaymentTermCode,
    required this.PaymentTermName,
    required this.PaymentTermDays,
    required this.CreditLimit,
    required this.Active,
    required this.Latitude,
    required this.Longitude,
    required this.ShopSize,
    required this.Competitor,
    this.ISSAP,
    this.ISPORTAL,
    this.IsTemporary,
    this.SAPCARDCODE,
    this.CreateDate,
    this.UpdateDate,
    this.BPType,
    this.CreatedBy,
    this.UpdatedBy,
    this.BranchId,
    this.PriceListCode,
    this.ShopSizeUom,

    this.ATTransId,
    this.CustomerBalance,
    this.CardGroupName,
    this.CardSubGroupName,
    this.Name,
    this.isNearby = false,
  });

  int ID;

  ///TO BE USED ONLY FOR DEVELOPMENT PURPOSE
  String? ATTransId;
  String Code;
  String? CardSubGroupName;
  String? CardGroupName;
  String FirstName;
  String MiddleName;
  String LastName;
  String Group;
  String SubGroup;
  String Currency;
  String Telephone;
  bool hasCreated;
  String MobileNo;
  String Address;
  String CityCode;
  String CityName;
  String StateCode;
  String StateName;
  String CountryCode;
  String CountryName;
  String Email;
  String Website;
  bool SAPCustomer;
  String PaymentTermCode;
  String PaymentTermName;
  int PaymentTermDays;
  int ShopSize;
  String? ShopSizeUom;
  double CreditLimit;
  bool Competitor;
  bool Active;
  bool isNearby;
  String Latitude;
  String Longitude;
  bool? ISSAP;
  bool? ISPORTAL;
  bool? IsTemporary;
  String? SAPCARDCODE;
  DateTime? CreateDate;
  DateTime? UpdateDate;
  String? BPType;

  ///CREATE CustomerBalance FORT DEVELOPMENT PURPOSE ONLY
  double? CustomerBalance;
  String? Name;
  String? CreatedBy;
  String? UpdatedBy;
  String? BranchId;
  String? PriceListCode;

  factory OCRDModel.fromJson(Map<String, dynamic> json) => OCRDModel(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        hasCreated: json['has_created'] == 1,
        ShopSize: int.tryParse(json["ShopSize"].toString()) ?? 0,
        CustomerBalance:
            double.tryParse(json["CustomerBalance"].toString()) ?? 0,
        CardSubGroupName: json["CardSubGroupName"] ?? "",
        Name: json["Name"] ?? "",
        Code: json["Code"] ?? "",
        FirstName: json["FirstName"] ?? "",
        MiddleName: json["MiddleName"] ?? "",
        LastName: json["LastName"] ?? "",
        ATTransId: json["ATTransId"] ?? "",
        Group: json["Group"] ?? "",
        CardGroupName: json["CardGroupName"] ?? "",
        SubGroup: json["SubGroup"] ?? "",
        Currency: json["Currency"] ?? "",
        Telephone: json["Telephone"] ?? "",
        MobileNo: json["MobileNo"] ?? "",
        Address: json["Address"] ?? "",
        ShopSizeUom: json["ShopSizeUom"] ?? "",
        CityCode: json["CityCode"] ?? "",
        CityName: json["CityName"] ?? "",
        StateCode: json["StateCode"] ?? "",
        StateName: json["StateName"] ?? "",
        CountryCode: json["CountryCode"] ?? "",
        CountryName: json["CountryName"] ?? "",
        Email: json["Email"] ?? "",
        Website: json["Website"] ?? "",
        SAPCustomer: json["SAPCustomer"] is bool
            ? json["SAPCustomer"]
            : json["SAPCustomer"] == 1,
        PaymentTermCode: json["PaymentTermCode"] ?? "",
        PaymentTermName: json["PaymentTermName"] ?? "",
        PaymentTermDays: int.tryParse(json["PaymentTermDays"].toString()) ?? 0,
        CreditLimit: double.tryParse(json["CreditLimit"].toString()) ?? 0.0,
        Competitor: json["Competitor"] is bool
            ? json["Competitor"]
            : json["Competitor"] == 1,
        Active: json["Active"] is bool ? json["Active"] : json["Active"] == 1,
        Latitude: json["Latitude"].toString(),
        Longitude: json["Longitude"] ?? "",
        ISSAP: json['ISSAP'] is bool ? json['ISSAP'] : json['ISSAP'] == 1,
        ISPORTAL: json['ISPORTAL'] is bool ? json['ISPORTAL'] : json['ISPORTAL'] == 1,
    IsTemporary: json['IsTemporary'] is bool ? json['IsTemporary'] : json['IsTemporary'] == 1,
        SAPCARDCODE: json['SAPCARDCODE'] ?? '',
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()),
        UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()),
        BPType: json['BPType'] ?? '',
        CreatedBy: json['CreatedBy'] ?? '',
        UpdatedBy: json['UpdatedBy'] ?? '',
        BranchId: json['BranchId'] ?? '',
        PriceListCode: json['PriceListCode'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "ShopSizeUom": ShopSizeUom,
        "CardGroupName": CardGroupName,
        "ShopSize": ShopSize,
        "Code": Code,
        "has_created": hasCreated ? 1 : 0,
        "FirstName": FirstName,
        "MiddleName": MiddleName,
        "LastName": LastName,
        "Group": Group,
        "SubGroup": SubGroup,
        "Currency": Currency,
        "Telephone": Telephone,
        "MobileNo": MobileNo,
        "Address": Address,
        "CityCode": CityCode,
        "CityName": CityName,
        "StateCode": StateCode,
        "CardSubGroupName": CardSubGroupName,
        "StateName": StateName,
        "CountryCode": CountryCode,
        "CountryName": CountryName,
        "Email": Email,
        "Website": Website,
        "SAPCustomer": SAPCustomer == true ? 1 : 0,
        "PaymentTermCode": PaymentTermCode,
        "PaymentTermName": PaymentTermName,
        "PaymentTermDays": PaymentTermDays,
        "Competitor": Competitor == true ? 1 : 0,
        "CreditLimit": CreditLimit,
        "Active": Active == true ? 1 : 0,
        "Latitude": Latitude,
        "Longitude": Longitude,
        'ISSAP': ISSAP,
        'ISPORTAL': ISPORTAL,
        'IsTemporary': IsTemporary,
        'SAPCARDCODE': SAPCARDCODE,
        'CreateDate': CreateDate?.toIso8601String(),
        'UpdateDate': UpdateDate?.toIso8601String(),
        'BPType': BPType,
        'CreatedBy': CreatedBy,
        'UpdatedBy': UpdatedBy,
        'BranchId': BranchId,
        'PriceListCode': PriceListCode,
      };
}

Future<List<OCRDModel>> retrieveSupplierForSearch({
  int? limit,
  String? query,
}) async {
  query="%$query%";
  final Database db = await initializeDB(null);
  final List<Map<String, Object?>> queryResult = await db.rawQuery('SELECT FirstName || MiddleName ||  LastName as Name,* FROM OCRD WHERE (BPType="T" OR BPType="S") and (Code LIKE "$query" OR Name LIKE "$query") LIMIT $limit');
  return queryResult.map((e) => OCRDModel.fromJson(e)).toList();
}

// Future<void> insertOCRD(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteOCRD(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncOCRD();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('OCRD_Temp', customer.toJson());
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
//       "SELECT * FROM  OCRD_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("OCRD", element,
//         where: "Code = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["Code"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from OCRD_Temp where Code not in (Select Code || ID from OCRD)");
//   print(v.runtimeType);
//   v.forEach((element) {
//     print(element);
//     batch3.insert('OCRD', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('OCRD_Temp');
// }
Future<void> insertOCRD(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteOCRD(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncOCRD();
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
      for (OCRDModel record in batchRecords) {
        try {
          batch.insert('OCRD_Temp', record.toJson());
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
			select * from OCRD_Temp
			except
			select * from OCRD
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
          batch.update("OCRD", element,
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
  print('Time taken for OCRD update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from OCRD_Temp where Code not in (Select Code || ID from OCRD)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM OCRD_Temp T0
LEFT JOIN OCRD T1 ON T0.Code = T1.Code 
WHERE T1.Code IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('OCRD', record);
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
      'Time taken for OCRD_Temp and OCRD compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('OCRD_Temp');
  // stopwatch.stop();
}

Future<List<OCRDModel>> dataSyncOCRD() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "OCRD" + postfix));
  print(res.body);
  return OCRDModelFromJson(res.body);
}

Future<List<OCRDModel>> retrieveOCRD(BuildContext context, {int? limit}) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('OCRD', where: 'Active=?', whereArgs: [1], limit: limit);
  return queryResult.map((e) => OCRDModel.fromJson(e)).toList();
}

// Future<List<OCRDModel>> retrieveOCRDForPagination(
//     BuildContext context, int limit,{
//       bool isCompetitor=false
// }) async {
//   final Database db = await initializeDB(context);
//   String query='';
//   if(isCompetitor)
//     {
//       query='''
//   SELECT DISTINCT IFNULL(T2.DocTotal,0.0)-IFNULL(T3.DocTotal,0.0) as CustomerBalance,T1.*
//       FROM OCRD T1 LEFT JOIN OINV T2 ON T1.Code=T2.CardCode LEFT JOIN ORTN T3 ON T1.Code=T3.CardCode WHERE Active=1 AND T1.Competitor=1 LIMIT $limit''';
//     }
//   else
//     {
//       query='''
//   SELECT DISTINCT IFNULL(T2.DocTotal,0.0)-IFNULL(T3.DocTotal,0.0) as CustomerBalance,T1.*
//       FROM OCRD T1 LEFT JOIN OINV T2 ON T1.Code=T2.CardCode LEFT JOIN ORTN T3 ON T1.Code=T3.CardCode WHERE Active=1 LIMIT $limit''';
//     }
//   final List<Map<String, Object?>> queryResult = await db.rawQuery(query);
//   return queryResult.map((e) => OCRDModel.fromJson(e)).toList();
// }

Future<List<OCRDModel>> retrieveOCRDById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('OCRD', where: str, whereArgs: l);
  return queryResult.map((e) => OCRDModel.fromJson(e)).toList();
}

Future<List<OCRDModel>> retrieveOCRDForDisplay({
  String dbQuery='',
  int limit=15,
  bool isCompetitor=false
}) async {
  final Database db = await initializeDB(null);
  dbQuery='%$dbQuery%';
  String searchQuery='';
  if(isCompetitor)
    {
      searchQuery='''
     SELECT DISTINCT T1.Latitude,T1.Longitude,IFNULL(T2.DocTotal,0.0)-IFNULL(T3.DocTotal,0.0)-IFNULL(T4.Amount,0.0) as CustomerBalance,T1.* 
 FROM OCRD T1 
 Inner join CRD8 T5 on T1.Code=T5.Code
 Inner join USR1 T6 on T6.BranchId=T5.BPLID
 Inner join OUSR T7 on T7.UserCode=T6.UserCode 

 LEFT JOIN OINV T2 ON T1.Code=T2.CardCode 
 LEFT JOIN ORTN T3 ON T1.Code=T3.CardCode 
 LEFT JOIN OCRT T4 ON T1.Code=T4.CardCode 

 WHERE T7.UserCode='${userModel.UserCode}' AND BPType = 'C' AND T1.Active = 1 AND T1.Competitor=1 AND ( T1.FirstName || T1.MiddleName||T1.LastName LIKE '$dbQuery' OR T1.Code LIKE '$dbQuery') GROUP BY T1.Code LIMIT $limit
      ''';
    }
  else
    {
      searchQuery='''
     SELECT DISTINCT T1.Latitude,T1.Longitude,IFNULL(T2.DocTotal,0.0)-IFNULL(T3.DocTotal,0.0)-IFNULL(T4.Amount,0.0) as CustomerBalance,T1.* 
 FROM OCRD T1 
 Inner join CRD8 T5 on T1.Code=T5.Code
 Inner join USR1 T6 on T6.BranchId=T5.BPLID
 Inner join OUSR T7 on T7.UserCode=T6.UserCode 

 LEFT JOIN OINV T2 ON T1.Code=T2.CardCode 
 LEFT JOIN ORTN T3 ON T1.Code=T3.CardCode 
 LEFT JOIN OCRT T4 ON T1.Code=T4.CardCode 

 WHERE T7.UserCode='${userModel.UserCode}' AND BPType = 'C' AND T1.Active = 1 AND (T1.FirstName || T1.MiddleName||T1.LastName LIKE '$dbQuery' OR T1.Code LIKE '$dbQuery') GROUP BY T1.Code LIMIT $limit
      ''';
    }
  final List<Map<String, Object?>> queryResult = await db.rawQuery(searchQuery);
  return queryResult.map((e) => OCRDModel.fromJson(e)).toList();
}

// Future<List<OCRDModel>> retrieveOCRDForVisitPlanMap() async {
//   final Database db = await initializeDB(null);
//   String data = '';
//   VisitList.planList.forEach((element) {
//     data += "\'" + (element.CardCode ?? '') + "\',";
//   });
//   data = data.substring(0, data.length - 1);
//
//   // final List<Map<String, Object?>> queryResult = await db.rawQuery("SELECT T1.TransId as ATTransId,T2.* FROM CVCVP1 T1 INNER JOIN OCRD T2 ON T2.Code=T1.CardCode where T1.TransId in (Select TransId from CVOCVP WHERE TransId='$TransId')");
//   String query =
//       "SELECT * FROM OCRD WHERE Code IN ($data)  AND Active = 1 AND BPType = 'C'";
//   print(query);
//   List<Map<String, Object?>> queryResult = [];
//   queryResult = await db.rawQuery(query);
//
//   return queryResult.map((e) => OCRDModel.fromJson(e)).toList();
// }

Future<List<OCRDModel>> GetNearByCustomer(List<OCRDModel> queryModel) async {
  // Database db=await initializeDB(null);
  List<OCRDModel> oCRDQueryModelsInsider = [];
  // OCRDModel oCRDQueryModels = new OCRDModel();
  // oCRDQueryModelsInsider = db.OCRDs.Where(o => o.Code == "FC0001").ToList().Select(x => oCRDQueryModels.ConvertQueryModel(x)).ToList();
  // await db.rawQuery("SELECT * FROM OCRD WHERE CODE='FC0001'");
  for (OCRDModel oCRDQueryModels1 in queryModel) {
    oCRDQueryModelsInsider.addAll(await GetNearByLocation(oCRDQueryModels1));
    // oCRDQueryModelsInsider= await GetNearByLocation(oCRDQueryModels1);
  }
  oCRDQueryModelsInsider.forEach((element) {
    element.isNearby = true;
  });

  return oCRDQueryModelsInsider;
}

Future<List<OCRDModel>> GetNearByLocation(OCRDModel oCRD) async {
  Database db = await initializeDB(null);
  String query =
      "select * from OCRD where Active=1 AND  (6371*2*ASIN(SQRT(POWER(SIN(RADIANS(23.2599)-RADIANS(${oCRD.Latitude})/2),2)+COS(RADIANS(${oCRD.Latitude}))*COS(RADIANS(23.2599))*POWER(SIN((RADIANS(77.4126)-RADIANS(${oCRD.Longitude}))/2),2)))) <=1000";
  List<OCRDModel> oCRDQueryModels = [];
  var result = await db.rawQuery(query);
  result.forEach((element) {
    oCRDQueryModels.add(OCRDModel.fromJson(element));
  });

  // using (SqlConnection con = new SqlConnection(strcon))
  // {
  // SqlCommand command = new SqlCommand(query, con);
  // SqlDataAdapter adapter = new SqlDataAdapter(command);
  // adapter.Fill(dt);
  // }
  // var ocrd = dt.Tables[0].ToList<OCRDModel>();
// OCRDModel oCRDQueryModels1 = new OCRDModel();

// oCRDQueryModels = ocrd.Select(x => oCRDQueryModels1.ConvertQueryModel(x)).ToList();
  return oCRDQueryModels;
  //Console.ReadLine();
}

Future<void> updateOCRD(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update("OCRD", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteOCRD(Database db) async {
  await db.delete('OCRD');
}
//SEND DATA TO SERVER
//--------------------------

Future<void> insertOCRDToServer(BuildContext context) async {
  retrieveOCRDById(context, DataSync.getInsertToServerStr(),
          DataSync.getInsertToServerList())
      .then((snapshot) {
    print(snapshot);
    snapshot.forEach((data) async {
      var res = await http.post(Uri.parse(prefix + "OCRD/Add"),
          headers: header, body: jsonEncode(data.toJson()));
      print(res.body);
    });
  });
}

Future<void> updateOCRDOnServer(BuildContext? context) async {
  retrieveOCRDById(context, DataSync.getUpdateOnServerStr(),
          DataSync.getUpdateOnServerList())
      .then((snapshot) {
    print(snapshot);
    snapshot.forEach((data) async {
      var res = await http.put(Uri.parse(prefix + 'OCRD/Update'),
          headers: header, body: jsonEncode(data.toJson()));
      print(res.body);
    });
  });
}
