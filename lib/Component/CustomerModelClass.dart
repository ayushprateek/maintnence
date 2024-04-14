import 'package:flutter/material.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:sqflite/sqlite_api.dart';

class CustomerModelClass {
  final int id, ContactPersonID;

  final String TransId,
      CardCode,
      CardName,
      RefNo,
      ContactPerson,
      MobileNo,
      PostingDate,
      ValidUntill,
      Currency,
      PaymentTermCode,
      PaymentTermName,
      PaymentTermDays,
      ApprovalStatus,
      DocStatus;
  double CurrRate;

  CustomerModelClass(
      {required this.id,
      required this.CardName,
      required this.MobileNo,
      required this.CardCode,
      required this.ValidUntill,
      required this.ContactPersonID,
      required this.TransId,
      required this.ContactPerson,
      required this.Currency,
      required this.RefNo,
      required this.CurrRate,
      required this.PostingDate,
      required this.ApprovalStatus,
      required this.DocStatus,
      required this.PaymentTermCode,
      required this.PaymentTermDays,
      required this.PaymentTermName});

  CustomerModelClass.fromMap(Map<String, dynamic> res)
      : id = res["ID"],
        PostingDate = res["PostingDate"],
        CurrRate = double.tryParse(res["CurrRate"].toString()) ?? 0,
        RefNo = res["RefNo"],
        Currency = res["Currency"],
        CardName = res["CardName"],
        ContactPerson = res["ContactPerson"],
        TransId = res["TransId"],
        ContactPersonID = res["ContactPersonID"],
        ValidUntill = res["ValidUntill"],
        CardCode = res["CardCode"],
        MobileNo = res["MobileNo"],
        ApprovalStatus = res["ApprovalStatus"],
        DocStatus = res["DocStatus"],
        PaymentTermCode = res["PaymentTermCode"],
        PaymentTermDays = res["PaymentTermDays"].toString(),
        PaymentTermName = res["PaymentTermName"];

  Map<String, Object> toMap() {
    return {
      'ID': id,
      'PostingDate': PostingDate,
      'CurrRate': CurrRate,
      'RefNo': RefNo,
      'Currency': Currency,
      'CardName': CardName,
      'ContactPerson': ContactPerson,
      'TransId': TransId,
      'ContactPersonID': ContactPersonID,
      'ValidUntill': ValidUntill,
      'CardCode': CardCode,
      'MobileNo': MobileNo,
      'ApprovalStatus': ApprovalStatus,
      'DocStatus': DocStatus,
      'PaymentTermCode': PaymentTermCode,
      'PaymentTermDays': PaymentTermDays,
      'PaymentTermName': PaymentTermName,
    };
  }
}

Future<List<CustomerModelClass>> retrieveCustomers(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('OCRD');
  return queryResult.map((e) => CustomerModelClass.fromMap(e)).toList();
}
