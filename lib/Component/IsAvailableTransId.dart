// import 'package:flutter/cupertino.dart';
// import 'package:maintenance/DatabaseInitialization.dart';
// import 'package:sqflite/sqlite_api.dart';
//
// Future<bool> isSQTransIdAvailable(BuildContext context, String TransId,
//     {Transaction? txn}) async {
//   var db;
//   if (txn == null) {
//     db = await initializeDB(context);
//   } else {
//     db = txn;
//   }
//   TransId = TransId.substring(13);
//   final List<Map<String, Object?>> queryResult = await db
//       .rawQuery("SELECT * FROM OQUT WHERE SUBSTR(TransId,14) = '${TransId}'");
//   return queryResult.isNotEmpty;
// }
//
// Future<bool> isMNCLTransIdAvailable(BuildContext? context, String TransId,
//     {Transaction? txn}) async {
//   var db;
//   if (txn == null) {
//     db = await initializeDB(context);
//   } else {
//     db = txn;
//   }
//   TransId = TransId.substring(13);
//   final List<Map<String, Object?>> queryResult = await db
//       .rawQuery("SELECT * FROM MNOCLD WHERE SUBSTR(TransId,14) = '${TransId}'");
//   return queryResult.isNotEmpty;
// }
//
// Future<bool> isPROPRQTransIdAvailable(BuildContext? context, String TransId,
//     {Transaction? txn})
// async {
//   var db;
//   if (txn == null) {
//     db = await initializeDB(context);
//   } else {
//     db = txn;
//   }
//   TransId = TransId.substring(13);
//   final List<Map<String, Object?>> queryResult = await db
//       .rawQuery("SELECT * FROM PROPRQ WHERE SUBSTR(TransId,14) = '${TransId}'");
//   return queryResult.isNotEmpty;
// }
//
// Future<bool> isPROITRTransIdAvailable(BuildContext? context, String TransId,
//     {Transaction? txn})
// async {
//   var db;
//   if (txn == null) {
//     db = await initializeDB(context);
//   } else {
//     db = txn;
//   }
//   TransId = TransId.substring(13);
//   final List<Map<String, Object?>> queryResult = await db
//       .rawQuery("SELECT * FROM PROITR WHERE SUBSTR(TransId,14) = '${TransId}'");
//   return queryResult.isNotEmpty;
// }
//
// Future<bool> isSOTransIdAvailable(BuildContext context, String TransId,
//     {Transaction? txn}) async {
//   var db;
//   if (txn == null) {
//     db = await initializeDB(context);
//   } else {
//     db = txn;
//   }
//
//   TransId = TransId.substring(13);
//   final List<Map<String, Object?>> queryResult = await db
//       .rawQuery("SELECT * FROM ORDR WHERE SUBSTR(TransId,14) = '${TransId}'");
//   return queryResult.isNotEmpty;
//   // List l = await retrieveORDRById(context, "TransId = ?", [TransId.substring(13)]);
//   // return l.isNotEmpty;
// }
//
// Future<bool> isRTTransIdAvailable(BuildContext context, String TransId) async {
//   final Database db = await initializeDB(context);
//   TransId = TransId.substring(13);
//   final List<Map<String, Object?>> queryResult = await db
//       .rawQuery("SELECT * FROM ORTN WHERE SUBSTR(TransId,14) = '${TransId}'");
//   return queryResult.isNotEmpty;
//   // List l = await retrieveORTNById(context, "TransId = ?", [TransId.substring(13)]);
//   // return l.isNotEmpty;
// }
//
// Future<bool> isDOTransIdAvailable(BuildContext context, String TransId) async {
//   final Database db = await initializeDB(context);
//   TransId = TransId.substring(13);
//   final List<Map<String, Object?>> queryResult = await db
//       .rawQuery("SELECT * FROM ODLN WHERE SUBSTR(TransId,14) = '${TransId}'");
//   return queryResult.isNotEmpty;
// }
//
// Future<bool> isINTransIdAvailable(BuildContext context, String TransId) async {
//   final Database db = await initializeDB(context);
//   TransId = TransId.substring(13);
//   final List<Map<String, Object?>> queryResult = await db
//       .rawQuery("SELECT * FROM OINV WHERE SUBSTR(TransId,14) = '${TransId}'");
//   return queryResult.isNotEmpty;
//
//   // List l = await retrieveOINVById(context, "TransId = ?", [TransId.substring(13)]);
//   // return l.isNotEmpty;
// }
//
// Future<bool> isDSTransIdAvailable(BuildContext context, String TransId) async {
//   final Database db = await initializeDB(context);
//   TransId = TransId.substring(13);
//   final List<Map<String, Object?>> queryResult = await db
//       .rawQuery("SELECT * FROM ODSC WHERE SUBSTR(TransId,14) = '${TransId}'");
//   return queryResult.isNotEmpty;
//   // List l = await retrieveODSCById(context, "TransId = ?", [TransId.substring(13)]);
//   // return l.isNotEmpty;
// }
//
// Future<bool> isDTTransIdAvailable(BuildContext context, String TransId) async {
//   final Database db = await initializeDB(context);
//   TransId = TransId.substring(13);
//   final List<Map<String, Object?>> queryResult = await db
//       .rawQuery("SELECT * FROM ODPT WHERE SUBSTR(TransId,14) = '${TransId}'");
//   return queryResult.isNotEmpty;
//   // List l = await retrieveODPTById(context, "TransId = ?", [TransId.substring(13)]);
//   // return l.isNotEmpty;
// }
//
// Future<bool> isRQTransIdAvailable(BuildContext context, String TransId) async {
//   final Database db = await initializeDB(context);
//   TransId = TransId.substring(13);
//   final List<Map<String, Object?>> queryResult = await db
//       .rawQuery("SELECT * FROM OECP WHERE SUBSTR(TransId,14) = '${TransId}'");
//   return queryResult.isNotEmpty;
//   // List l = await retrieveOECPById(context, "TransId = ?", [TransId.substring(13)]);
//   // return l.isNotEmpty;
// }
//
// Future<bool> isCDTransIdAvailable(BuildContext context, String TransId) async {
//   final Database db = await initializeDB(context);
//   TransId = TransId.substring(13);
//   final List<Map<String, Object?>> queryResult = await db
//       .rawQuery("SELECT * FROM OCSH WHERE SUBSTR(TransId,14) = '${TransId}'");
//   return queryResult.isNotEmpty;
//   // List l = await retrieveOCSHById(context, "TransId = ?", [TransId.substring(13)]);
//   // return l.isNotEmpty;
// }
//
// Future<bool> isATTransIdAvailable(BuildContext context, String TransId) async {
//   final Database db = await initializeDB(context);
//   TransId = TransId.substring(13);
//   final List<Map<String, Object?>> queryResult = await db
//       .rawQuery("SELECT * FROM OACT WHERE SUBSTR(TransId,14) = '${TransId}'");
//   return queryResult.isNotEmpty;
//   // List l = await retrieveOACTById(context, "TransId = ?", [TransId.substring(13)]);
//   // return l.isNotEmpty;
// }
//
// Future<bool> isSTTransIdAvailable(BuildContext context, String TransId) async {
//   final Database db = await initializeDB(context);
//   TransId = TransId.substring(13);
//   final List<Map<String, Object?>> queryResult = await db
//       .rawQuery("SELECT * FROM OSTK WHERE SUBSTR(TransId,14) = '${TransId}'");
//   return queryResult.isNotEmpty;
//   // List l = await retrieveOSTKById(context, "TransId = ?", [TransId.substring(13)]);
//   // return l.isNotEmpty;
// }
//
// Future<bool> isIRTransIdAvailable(
//     BuildContext context, String TicketCode) async {
//   final Database db = await initializeDB(context);
//   TicketCode = TicketCode.substring(13);
//   final List<Map<String, Object?>> queryResult = await db.rawQuery(
//       "SELECT * FROM SUOISU WHERE SUBSTR(TicketCode,14) = '${TicketCode}'");
//   return queryResult.isNotEmpty;
//   // List l = await retrieveSUOISUById(context, "TicketCode = ?", [TicketCode]);
//   // return l.isNotEmpty;
// }
//
// Future<bool> isVPTransIdAvailable(BuildContext context, String TransId) async {
//   final Database db = await initializeDB(context);
//   TransId = TransId.substring(13);
//   final List<Map<String, Object?>> queryResult = await db
//       .rawQuery("SELECT * FROM CVOCVP WHERE SUBSTR(TransId,14) = '${TransId}'");
//   return queryResult.isNotEmpty;
//   // List l = await retrieveCVOCVPById(context, "TransId = ?", [TransId.substring(13)]);
//   // return l.isNotEmpty;
// }
//
// Future<bool> isSUIRTransIdAvailable(
//     BuildContext? context, String TransId) async {
//   final Database db = await initializeDB(context);
//   TransId = TransId.substring(13);
//   final List<Map<String, Object?>> queryResult = await db
//       .rawQuery("SELECT * FROM SUOISU WHERE SUBSTR(TransId,14) = '${TransId}'");
//   return queryResult.isNotEmpty;
//   // List l = await retrieveCVOCVPById(context, "TransId = ?", [TransId.substring(13)]);
//   // return l.isNotEmpty;
// }
//
// Future<bool> isOCRTTransIdAvailable(
//     BuildContext context, String TransId) async {
//   final Database db = await initializeDB(context);
//   TransId = TransId.substring(13);
//   final List<Map<String, Object?>> queryResult = await db
//       .rawQuery("SELECT * FROM OCRT WHERE SUBSTR(TransId,14) = '${TransId}'");
//   return queryResult.isNotEmpty;
//   // List l = await retrieveOCRTById(context, "TransId = ?", [TransId.substring(13)]);
//   // return l.isNotEmpty;
// }
//
// Future<bool> isOEXRTransIdAvailable(
//     BuildContext? context, String TransId) async {
//   final Database db = await initializeDB(context);
//   TransId = TransId.substring(13);
//   final List<Map<String, Object?>> queryResult = await db
//       .rawQuery("SELECT * FROM OEXR WHERE SUBSTR(TransId,14) = '${TransId}'");
//   return queryResult.isNotEmpty;
//   // List l = await retrieveOEXRById(context, "TransId = ?", [TransId.substring(13)]);
//   // return l.isNotEmpty;
// }
//
// Future<bool> isORCTTransIdAvailable(
//     BuildContext? context, String TransId) async {
//   final Database db = await initializeDB(context);
//   TransId = TransId.substring(13);
//   final List<Map<String, Object?>> queryResult = await db
//       .rawQuery("SELECT * FROM ORCT WHERE SUBSTR(TransId,14) = '${TransId}'");
//   return queryResult.isNotEmpty;
//   // List l = await retrieveORCTById(context, "TransId = ?", [TransId.substring(13)]);
//   // return l.isNotEmpty;
// }
