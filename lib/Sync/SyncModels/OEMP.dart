import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/MenuDescription.dart';
import 'package:maintenance/Component/Mode.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/SyncModels/CVOCVP.dart';
import 'package:maintenance/Sync/SyncModels/ORTP.dart';
import 'package:maintenance/main.dart';
import 'package:sqflite/sqlite_api.dart';

List<OEMPModel> OEMPModelFromJson(String str) =>
    List<OEMPModel>.from(json.decode(str).map((x) => OEMPModel.fromJson(x)));

String OEMPModelToJson(List<OEMPModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OEMPModel {
  OEMPModel({
    required this.ID,
    required this.Code,
    required this.CreateDate,
    required this.UpdateDate,
    this.hasCreated = false,
    required this.FirstName,
    required this.MiddleName,
    required this.LastName,
    required this.JobTitle,
    required this.Position,
    required this.MobileNo,
    required this.Gender,
    required this.StartDate,
    required this.TerminationDate,
    required this.DateOfBirth,
    required this.BranchId,
    required this.BranchShortDesc,
    required this.DeptId,
    required this.DeptCode,
    required this.DeptShortDesc,
    required this.Address,
    required this.CityCode,
    required this.CityName,
    required this.StateCode,
    required this.StateName,
    required this.CountryCode,
    required this.CountryName,
    required this.Active,
    this.IsSalesExecutive = false,
    this.IsTeamLeader = false,
    this.IsTechnician = false,
    required this.Attachment,
    required this.EmpGroupId,
    required this.EMPGD,
    this.NrcNo,
    this.CreatedBy,
    this.SapEmpCode,
    this.UpdatedBy,
    this.ReportingToEmpCode,
    this.ReportingToEmpName,
    this.EngagedRPTransId,
    this.AvailabilityStatus,
    this.Name,
  });

  int ID;
  String Code;

  String FirstName;
  String MiddleName;
  String LastName;
  String JobTitle;
  DateTime CreateDate;
  DateTime UpdateDate;
  bool hasCreated;
  bool IsTechnician;
  String Position;
  String MobileNo;
  String Gender;
  DateTime StartDate;
  DateTime TerminationDate;
  DateTime DateOfBirth;
  int BranchId;
  String BranchShortDesc;
  int DeptId;
  String EmpGroupId;
  String DeptCode;
  String DeptShortDesc;
  String Address;
  String CityCode;
  String CityName;
  String StateCode;
  String StateName;
  String CountryCode;
  String CountryName;
  String EMPGD;
  bool IsTeamLeader;
  bool Active;
  bool IsSalesExecutive;
  String Attachment;
  String? NrcNo;
  String? SapEmpCode;
  String? CreatedBy;
  String? ReportingToEmpName;
  String? ReportingToEmpCode;
  String? UpdatedBy;
  String? EngagedRPTransId;
  String? AvailabilityStatus;

  /// FOR DEV PURPOSE ONLY
  String? Name;

  factory OEMPModel.fromJson(Map<String, dynamic> json) => OEMPModel(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        ReportingToEmpCode: json["ReportingToEmpCode"] ?? "",
        Code: json["Code"] ?? "",
        EmpGroupId: json["EmpGroupId"] ?? "",
        EMPGD: json["EMPGD"] ?? "",
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] == 1,
        FirstName: json["FirstName"] ?? "",
        MiddleName: json["MiddleName"] ?? "",
        LastName: json["LastName"] ?? "",
        ReportingToEmpName: json["ReportingToEmpName"] ?? "",
        SapEmpCode: json["SapEmpCode"] ?? "",
        JobTitle: json["JobTitle"] ?? "",
        Position: json["Position"] ?? "",
        MobileNo: json["MobileNo"] ?? "",
        Gender: json["Gender"] ?? "",
        StartDate: DateTime.tryParse(json["StartDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        TerminationDate:
            DateTime.tryParse(json["TerminationDate"].toString()) ??
                DateTime.parse("1900-01-01"),
        DateOfBirth: DateTime.tryParse(json["DateOfBirth"].toString()) ??
            DateTime.parse("1900-01-01"),
        BranchId: int.tryParse(json["BranchId"].toString()) ?? 0,
        BranchShortDesc: json["BranchShortDesc"] ?? "",
        DeptId: int.tryParse(json["DeptId"].toString()) ?? 0,
        DeptCode: json["DeptCode"] ?? "",
        DeptShortDesc: json["DeptShortDesc"] ?? "",
        Address: json["Address"] ?? "",
        CityCode: json["CityCode"] ?? "",
        CityName: json["CityName"] ?? "",
        StateCode: json["StateCode"] ?? "",
        StateName: json["StateName"] ?? "",
        CountryCode: json["CountryCode"] ?? "",
        CountryName: json["CountryName"] ?? "",
        Name: json["Name"] ?? "",
        NrcNo: json['NrcNo'] ?? '',
        CreatedBy: json['CreatedBy'] ?? '',
        UpdatedBy: json['UpdatedBy'] ?? '',
        IsTeamLeader: json["IsTeamLeader"] is bool
            ? json["IsTeamLeader"]
            : json["IsTeamLeader"] == 1,
        IsTechnician: json["IsTechnician"] is bool
            ? json["IsTechnician"]
            : json["IsTechnician"] == 1,
        IsSalesExecutive: json["IsSalesExecutive"] is bool
            ? json["IsSalesExecutive"]
            : json["IsSalesExecutive"] == 1,
        Active: json["Active"] is bool ? json["Active"] : json["Active"] == 1,
        Attachment: json["Attachment"] ?? "",
        EngagedRPTransId: json["EngagedRPTransId"] ?? "",
        AvailabilityStatus: json["AvailabilityStatus"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "ReportingToEmpName": ReportingToEmpName,
        "Code": Code,
        "CreateDate": CreateDate.toIso8601String(),
        "UpdateDate": UpdateDate.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        "FirstName": FirstName,
        "ReportingToEmpCode": ReportingToEmpCode,
        "EMPGD": EMPGD,
        "SapEmpCode": SapEmpCode,
        "MiddleName": MiddleName,
        "EmpGroupId": EmpGroupId,
        "LastName": LastName,
        "JobTitle": JobTitle,
        "Position": Position,
        "MobileNo": MobileNo,
        "Gender": Gender,
        "StartDate": StartDate.toIso8601String(),
        "TerminationDate": TerminationDate.toIso8601String(),
        "DateOfBirth": DateOfBirth.toIso8601String(),
        "BranchId": BranchId,
        "BranchShortDesc": BranchShortDesc,
        "DeptId": DeptId,
        "DeptCode": DeptCode,
        "DeptShortDesc": DeptShortDesc,
        "Address": Address,
        "CityCode": CityCode,
        "CityName": CityName,
        "StateCode": StateCode,
        "StateName": StateName,
        "CountryCode": CountryCode,
        "CountryName": CountryName,
        'NrcNo': NrcNo,
        'CreatedBy': CreatedBy,
        'UpdatedBy': UpdatedBy,
        "IsTeamLeader": IsTeamLeader == true ? 1 : 0,
        "IsTechnician": IsTechnician == true ? 1 : 0,
        "IsSalesExecutive": IsSalesExecutive == true ? 1 : 0,
        "Active": Active == true ? 1 : 0,
        "EngagedRPTransId": EngagedRPTransId,
        "Attachment": Attachment,
        "AvailabilityStatus": AvailabilityStatus,
      };
}

Future<List<OEMPModel>> dataSyncOEMP() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "OEMP" + postfix));
  print(res.body);
  return OEMPModelFromJson(res.body);
}

Future<List<OEMPModel>> retrieveOEMP(BuildContext? context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('OEMP');
  return queryResult.map((e) => OEMPModel.fromJson(e)).toList();
}

Future<List<OEMPModel>> retrieveOEMPForSearch(
    {required String query, int? limit}) async {
  final Database db = await initializeDB(null);
  final List<Map<String, Object?>> queryResult = await db.rawQuery(
      "SELECT FirstName || MiddleName || LastName as Name,* FROM OEMP where Name LIKE \'%$query%\' COLLATE NOCASE LIMIT $limit");
  return queryResult.map((e) => OEMPModel.fromJson(e)).toList();
}

Future<List<OEMPModel>> retrieveTechnicianForSearch(
    {required String query, int? limit}) async {
  final Database db = await initializeDB(null);
  final List<Map<String, Object?>> queryResult = await db.rawQuery(
      "SELECT FirstName || MiddleName || LastName as Name,* FROM OEMP where IsTechnician=1 AND Active=1 AND  Name LIKE \'%$query%\' COLLATE NOCASE LIMIT $limit");
  return queryResult.map((e) => OEMPModel.fromJson(e)).toList();
}

Future<List<OEMPModel>> retrieveOEMPForCashRequisition(BuildContext? context,
    {String? RPTransId}) async {
  final Database db = await initializeDB(context);
  String query = '';
//   if (RPTransId == "" || RPTransId == null) {
//     if (await Mode.isBranch(MenuDescription.cashRequisition)) {
//       query = '''
//  select distinct emp.CreateDate,emp.* from oxpm as oxpms  inner
//    join OEMP emp on oxpms.EmpGroupId = emp.EmpGroupId
// where oxpms.Active =1 and emp.Active =1 and  (oxpms.RouteCode='' or oxpms.RouteCode=null) AND emp.BranchId=${userModel.BranchId}'
//     ''';
//     } else if (await Mode.isSelf(MenuDescription.cashRequisition)) {
//     query = '''
//      select distinct emp.CreateDate,emp.* from oxpm as oxpms  inner
//    join OEMP emp on oxpms.EmpGroupId = emp.EmpGroupId
// where oxpms.Active =1 and emp.Active =1 and  (oxpms.RouteCode='' or oxpms.RouteCode=null) AND emp.Code='${userModel.UserCode}'
//     ''';
//   } else {
//     query = '''
//     select distinct emp.CreateDate,emp.* from oxpm as oxpms  inner
//    join OEMP emp on oxpms.EmpGroupId = emp.EmpGroupId
// where oxpms.Active =1 and emp.Active =1 and  (oxpms.RouteCode='' or oxpms.RouteCode=null)
//     ''';
//   }
//
//     final List<Map<String, Object?>> queryResult = await db.rawQuery(query);
//     return queryResult.map((e) => OEMPModel.fromJson(e)).toList();
//   } else {
//     return getEmployeeDataBasedOnRoute(RPTransId);
//   }
  //todo: remove joining from oxpm
  if (await Mode.isCompany(MenuDescription.cashRequisition)) {
    query = '''
    select distinct emp.CreateDate,emp.* from oxpm as oxpms  inner
   join OEMP emp on oxpms.EmpGroupId = emp.EmpGroupId
where oxpms.Active =1 and emp.Active =1 and  (oxpms.RouteCode='' or oxpms.RouteCode=null)
    ''';
  } else if (await Mode.isBranch(MenuDescription.cashRequisition)) {
    query = '''
 select distinct emp.CreateDate,emp.* from oxpm as oxpms  inner
   join OEMP emp on oxpms.EmpGroupId = emp.EmpGroupId
where oxpms.Active =1 and emp.Active =1 and  (oxpms.RouteCode='' or oxpms.RouteCode=null) AND emp.BranchId=${userModel.BranchId}'
    ''';
  } else if (await Mode.isSelf(MenuDescription.cashRequisition)) {
    query = '''
     select distinct emp.CreateDate,emp.* from oxpm as oxpms  inner
   join OEMP emp on oxpms.EmpGroupId = emp.EmpGroupId
where oxpms.Active =1 and emp.Active =1 and  (oxpms.RouteCode='' or oxpms.RouteCode=null) AND emp.Code='${userModel.UserCode}'
    ''';
  } else {
    return [];
  }

  final List<Map<String, Object?>> queryResult = await db.rawQuery(query);
  return queryResult.map((e) => OEMPModel.fromJson(e)).toList();
}

Future<List<OEMPModel>> getEmployeeDataBasedOnRoute(String RPTransId) async {
  List<OEMPModel> results = [];
  try {
    if (RPTransId.startsWith("RP")) {
      List<ORTPModel> oRTPList =
          await retrieveORTPById(null, 'TransId = ?', [RPTransId]);
      if (oRTPList.isNotEmpty) {
        ORTPModel oRTP = oRTPList[0];
        List<OEMPModel> oneList = await retrieveOEMPById(
            null, 'Code = ? AND Active = ?', [oRTP.SalesEmpId, 1]);
        if (oneList.isNotEmpty) {
          results.add(oneList[0]);
        }
        if (oRTP.SalesEmpId != oRTP.DriverId) {
          List<OEMPModel> twoList = await retrieveOEMPById(
              null, 'Code = ? AND Active = ?', [oRTP.DriverId, 1]);
          if (twoList.isNotEmpty) {
            results.add(twoList[0]);
          }
        }
      }
    } else {
      List<CVOCVP> cVOCVPList =
          await retrieveCVOCVPById(null, 'TransId = ?', [RPTransId]);
      if (cVOCVPList.isNotEmpty) {
        CVOCVP cVOCVP = cVOCVPList[0];

        List<OEMPModel> oneList = await retrieveOEMPById(
            null, 'Code = ? AND Active = ?', [cVOCVP.EmpCode1]);
        List<OEMPModel> twoList = await retrieveOEMPById(
            null, 'Code = ? AND Active = ?', [cVOCVP.EmpCode2]);
        List<OEMPModel> threeList = await retrieveOEMPById(
            null, 'Code = ? AND Active = ?', [cVOCVP.EmpCode3]);

        if (oneList.isNotEmpty) {
          results.add(oneList[0]);
        }
        if (twoList.isNotEmpty) {
          results.add(twoList[0]);
        }
        if (threeList.isNotEmpty) {
          results.add(threeList[0]);
        }
      }
    }
    return results;
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    return results;
  }
}

Future<void> updateOEMP(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update("OEMP", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteOEMP(Database db) async {
  await db.delete('OEMP');
}

// Future<void> insertOEMP(Database db,{List? list})async{
//   if(postfix.toLowerCase().contains("all"))
//   await deleteOEMP(db);
//   List customers;
//   if(list!=null)
//   {
//     customers=list;
//   }
//   else
//   {
//     customers= await dataSyncOEMP();
//   }
//   print(customers);
//   var batch = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try
//     {
//       batch.insert('OEMP', customer.toJson());
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
//   //       await db.insert('OEMP', customer.toJson());
//   //     });
//   //   }
//   //   catch(e)
//   //   {
//   //     getErrorSnackBar("Sync Error "+e.toString());
//   //   }
//   //
//   // });
// }
// Future<void> insertOEMP(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteOEMP(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncOEMP();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('OEMP_Temp', customer.toJson());
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
//       "SELECT * FROM  OEMP_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN UpdateDate IS NULL THEN CreateDate ELSE UpdateDate END)");
//   u.forEach((element) {
//     batch2.update("OEMP", element,
//         where: "Code = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["Code"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from OEMP_Temp where  Code not in (Select Code from OEMP)");
//   v.forEach((element) {
//     batch3.insert('OEMP', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('OEMP_Temp');
// }
Future<void> insertOEMP(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteOEMP(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncOEMP();
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
      for (OEMPModel record in batchRecords) {
        try {
          batch.insert('OEMP_Temp', record.toJson());
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
			select * from OEMP_Temp
			except
			select * from OEMP
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
          batch.update("OEMP", element,
              where:
                  "Code = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
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
  print('Time taken for OEMP update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from OEMP_Temp where  Code not in (Select Code from OEMP)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM OEMP_Temp T0
LEFT JOIN OEMP T1 ON T0.Code = T1.Code 
WHERE T1.Code IS NULL;
''');

  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('OEMP', record);
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
      'Time taken for OEMP_Temp and OEMP compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('OEMP_Temp');
  // stopwatch.stop();
}

//SEND DATA TO SERVER
//--------------------------
Future<List<OEMPModel>> retrieveOEMPById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('OEMP', where: str, whereArgs: l);
  return queryResult.map((e) => OEMPModel.fromJson(e)).toList();
}

// Future<void> insertOEMPToServer(BuildContext context) async {
//   retrieveOEMPById(context, DataSync.getInsertToServerStr(),
//           DataSync.getInsertToServerList())
//       .then((snapshot) {
//     print(snapshot);
//     snapshot.forEach((data) async {
//       var res = await http.post(Uri.parse(prefix + "OEMP/Add"),
//           headers: header, body: jsonEncode(data.toJson()));
//       print(res.body);
//     });
//   });
// }
//
// Future<void> updateOEMPOnServer(BuildContext? context) async {
//   retrieveOEMPById(context, DataSync.getUpdateOnServerStr(),
//           DataSync.getUpdateOnServerList())
//       .then((snapshot) {
//     print(snapshot);
//     snapshot.forEach((data) async {
//       var res = await http.put(Uri.parse(prefix + 'OEMP/Update'),
//           headers: header, body: jsonEncode(data.toJson()));
//       print(res.body);
//     });
//   });
// }
