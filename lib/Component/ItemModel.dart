import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/main.dart';
import 'package:sqflite/sqlite_api.dart';

class AssignedItemsModel {
  String ItemCode;
  String ItemName;
  String TaxCode;
  String WhsCode;
  String UOM;
  double Price;
  double TaxRate;
  double MSP;

  DateTime CreateDate;
  DateTime UpdateDate;
  bool hasCreated;
  String? PriceListCode;
  int? ID;
  DateTime? StartDate;
  DateTime? EndDate;

  AssignedItemsModel({
    required this.ItemCode,
    required this.ItemName,
    required this.TaxCode,
    required this.TaxRate,
    required this.WhsCode,
    required this.UOM,
    required this.Price,
    required this.MSP,
    required this.CreateDate,
    required this.UpdateDate,
    this.hasCreated = false,
    this.PriceListCode,
    this.ID,
    this.StartDate,
    this.EndDate,
  });

  factory AssignedItemsModel.fromJson(Map json) => AssignedItemsModel(
        ItemCode: json['ItemCode'] ?? '',
        ItemName: json['ItemName'] ?? '',
        TaxCode: json['TaxCode'] ?? '',
        WhsCode: json['WhsCode'] ?? '',
        UOM: json['UOM'] ?? '',
        TaxRate: double.tryParse(json['TaxRate'].toString()) ?? 0.0,
        Price: double.tryParse(json['Price'].toString()) ?? 0.0,
        MSP: double.tryParse(json['MSP'].toString()) ?? 0.0,
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] == 1,
        PriceListCode: json['PriceListCode'] ?? '',
        ID: int.tryParse(json['ID'].toString()) ?? 0,
        StartDate: DateTime.tryParse(json['StartDate'].toString()) ??
            DateTime.parse('1900-01-01'),
        EndDate: DateTime.tryParse(json['EndDate'].toString()) ??
            DateTime.parse('1900-01-01'),
      );

  Map<String, dynamic> toJson() => {
        'TaxRate': TaxRate,
        'ItemCode': ItemCode,
        'ItemName': ItemName,
        'TaxCode': TaxCode,
        'WhsCode': WhsCode,
        'UOM': UOM,
        'Price': Price,
        'MSP': MSP,
        "CreateDate": CreateDate.toIso8601String(),
        "UpdateDate": UpdateDate.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        'PriceListCode': PriceListCode,
        'ID': ID,
        'StartDate': StartDate?.toIso8601String(),
        'EndDate': EndDate?.toIso8601String(),
      };
}

Future<List<AssignedItemsModel>> retrieveAssignedItems(
    {
      required String priceListCode,
      String WhsCode='',
      String? itemCode, int? limit,
      String query=''}) async {
  final Database db = await initializeDB(null);
  query='%$query%';
  String str = '';
  if (priceListCode == '') {
    //REQUEST IS COMING FROM ADDITIONAL ITEM
    str = '''
       select distinct oi.ItemName,oms.*
,(select UOM from IUOM where ItemCode=oms.ItemCode limit 1 ) as"UOM"
from  OMSP  oms 
inner join IWHS iwhs on oi.ItemCode=iwhs.ItemCode
	inner join OITM  oi on oms.ItemCode = oi.ItemCode 
	where oi.Active=1 and  iwhs.WhsCode='$WhsCode' and  DATETIME('now')>=DATETIME(oms.StartDate) 
	and DATETIME('now') <=DATETIME(oms.EndDate) and oms.ItemCode='$itemCode'
	LIMIT 1
      ''';
  }
  else if (itemCode == null) {
    if (limit == null) {
      str = '''
      select distinct oi.ItemName,oms.*
,(select UOM from IUOM where ItemCode=oms.ItemCode limit 1 ) as"UOM"
from  OMSP  oms 
	inner join OITM  oi on oms.ItemCode = oi.ItemCode 
	inner join IWHS iwhs on oi.ItemCode=iwhs.ItemCode
	where oi.Active=1 and iwhs.WhsCode='$WhsCode' and oms.PriceListCode='$priceListCode' and DATETIME('now')>=DATETIME(oms.StartDate) 
	and DATETIME('now') <=DATETIME(oms.EndDate)
	 and( oi.ItemCode LIKE '$query' OR oi.ItemName LIKE '$query')  
      ''';
    } else {
      str = '''
      select distinct oi.ItemName,oms.*
,(select UOM from IUOM where ItemCode=oms.ItemCode limit 1 ) as"UOM"
from  OMSP  oms 
	inner join OITM  oi on oms.ItemCode = oi.ItemCode 
	inner join IWHS iwhs on oi.ItemCode=iwhs.ItemCode
	where oi.Active=1 and iwhs.WhsCode='$WhsCode' and oms.PriceListCode='$priceListCode' and DATETIME('now')>=DATETIME(oms.StartDate) 
	and DATETIME('now') <=DATETIME(oms.EndDate)
	 and( oi.ItemCode LIKE '$query' OR oi.ItemName LIKE '$query')
	limit $limit
      ''';
    }
  }
  else {
    str = '''
      select distinct oi.ItemName,oms.*
,(select UOM from IUOM where ItemCode=oms.ItemCode limit 1 ) as"UOM"
from  OMSP  oms 
	inner join OITM  oi on oms.ItemCode = oi.ItemCode 
	inner join IWHS iwhs on oi.ItemCode=iwhs.ItemCode
	where oi.Active=1 and iwhs.WhsCode='$WhsCode' and oms.PriceListCode='$priceListCode' and DATETIME('now')>=DATETIME(oms.StartDate) 
	and DATETIME('now') <=DATETIME(oms.EndDate)
	 and( oi.ItemCode LIKE '$query' OR oi.ItemName LIKE '$query')   AND oms.ItemCode='$itemCode'
      ''';
  }

  final List<Map<String, Object?>> queryResult = await db.rawQuery(str);
  return queryResult.map((e) => AssignedItemsModel.fromJson(e)).toList();
}
