import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/main.dart';
import 'package:sqflite/sqlite_api.dart';

class RecentDocument {
  String? DocName;
  String? TableName;
  String? TransId;
  DateTime? CreateDate;
  String? CardName;
  String? Currency;
  double? DocTotal;

  RecentDocument({
    this.DocName,
    this.TableName,
    this.TransId,
    this.CreateDate,
    this.CardName,
    this.DocTotal,
    this.Currency,
  });

  factory RecentDocument.fromJson(Map json) => RecentDocument(
        DocName: json['DocName'],
        CreateDate: DateTime.tryParse(json['CreateDate'].toString()),
        TransId: json['TransId'],
        CardName: json['CardName'],
        DocTotal: double.tryParse(json['DocTotal'].toString()),
        TableName: json['TableName'],
        Currency: json['Currency'],
      );

  Map<String, dynamic> toJson() => {
        'CreateDate': CreateDate?.toIso8601String(),
        'TransId': TransId,
        'CardName': CardName,
        'DocTotal': DocTotal,
        'TableName': TableName,
        'Currency': Currency,
      };
}

Future<List<RecentDocument>> retrieveRecentDocument() async {
  final Database db = await initializeDB(null);
  final List<Map<String, Object?>> queryResult = await db.rawQuery('''
   --SALES & PLANNING QUERIES
SELECT DocName ,TableName,TransId,CreateDate,CardName,DocTotal,Currency,CreatedBy FROM 
(SELECT 'Sales Quotation' as DocName,'OQUT' as TableName,TransId,CreateDate,CardName,DocTotal,Currency,CreatedBy FROM OQUT UNION ALL 
SELECT 'Sales Order' as DocName,'ORDR' as TableName,TransId,CreateDate,CardName,DocTotal,Currency,CreatedBy FROM ORDR UNION ALL 
SELECT 'Delivery Schedule' as DocName,'ODSC' as TableName,TransId,CreateDate,SalesEmp,'','',CreatedBy FROM ODSC UNION ALL 
SELECT 'Delivery' as DocName,'ODLN' as TableName,TransId,CreateDate,CardName,DocTotal,Currency,CreatedBy FROM ODLN UNION ALL
SELECT 'Cash Receipt' as DocName,'OCRT' as TableName,TransId,CreateDate,CardName,Amount,Currency,CreatedBy FROM OCRT UNION ALL
SELECT 'Deposit' as DocName,'ODPT' as TableName,TransId,CreateDate,EmpName,Amount,Currency,CreatedBy FROM ODPT UNION ALL
SELECT 'Invoice' as DocName,'OINV' as TableName,TransId,CreateDate,CardName,DocTotal,Currency,CreatedBy FROM OINV UNION ALL
--EXPENSE QUERIES
SELECT 'Cash Requisition' as DcoNum,'OECP' as TableName,TransId,CreateDate,EmpName,RequestedAmt,Currency,CreatedBy FROM OECP UNION ALL
SELECT 'Cash Handover' as DocName,'OCSH' as TableName,T1.TransId,T1.CreateDate,T2.EmpName,T1.Amount,T1.Currency,T1.CreatedBy FROM OCSH T1 left join OECP T2 ON T1.CRTransId=T2.TransId UNION ALL
SELECT 'Expense Capture' as DocNum,'OEXR' as TableName,TransId,CreateDate,EmpName,RequestedAmt,Currency,CreatedBy FROM OEXR UNION ALL
SELECT 'Expense Reconciliation' as DocNum,'ORCT' as TableName,TransId,CreateDate,EmpName,TotalRequestedAmt,Currency,CreatedBy FROM ORCT
)
WHERE CreatedBy='${userModel.UserCode}'
order by CreateDate DESC limit 10
  ''');
  return queryResult.map((e) {
    return RecentDocument.fromJson(e);
  }).toList();
}
