import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/main.dart';
import 'package:sqflite/sqlite_api.dart';

class ApprovalModel {
  int? Level;
  int? ACID;
  int? DocID;
  String? AUserName;
  String? AUserCode;
  String? OUserName;
  String? OUserCode;
  String? DocName;
  bool? Add;
  bool? Active;

  ApprovalModel({
    this.Level,
    this.ACID,
    this.DocID,
    this.AUserName,
    this.AUserCode,
    this.OUserName,
    this.OUserCode,
    this.DocName,
    this.Add,
    this.Active,
  });

  factory ApprovalModel.fromJson(Map<String, dynamic> json) => ApprovalModel(
        Level: int.tryParse(json['Level'].toString()) ?? 0,
        ACID: int.tryParse(json['ACID'].toString()) ?? 0,
        DocID: int.tryParse(json['DocID'].toString()) ?? 0,
        OUserName: json['OUserName'] ?? '',
        AUserCode: json['AUserCode'] ?? '',
        AUserName: json['AUserName'] ?? '',
        OUserCode: json['OUserCode'] ?? '',
        DocName: json['DocName'] ?? '',
        Add: json['Add'] is bool ? json['Add'] : json['Add'] == 1,
        Active: json['Active'] is bool ? json['Active'] : json['Active'] == 1,
      );

  Map<String, dynamic> toJson() => {
        'ACID': ACID,
        'Level': Level,
        'DocID': DocID,
        'AUserName': AUserName,
        'AUserCode': AUserCode,
        'OUserName': OUserName,
        'OUserCode': OUserCode,
        'DocName': DocName,
        'Add': Add == true ? 1 : 0,
        'Active': Active == true ? 1 : 0,
      };

  static Future<ApprovalModel?> getApprovalModel(
      {required String DocName, Transaction? txn}) async {
    var db;
    if (txn == null) {
      db = await initializeDB(null);
    } else {
      db = txn;
    }
    String str = '''
  SELECT oac1.UserCode as OUserCode,oac1.UserName as OUserName,
 oac2.Level,ooac.ACID,
oac2.UserCode as AUserCode,
oac2.UserName as AUserName , ooac.DocID ,ooac.DocName, ooac.Active,ooac.`Add`  from LITPL_OAC1 oac1
                 inner join LITPL_OOAC ooac on oac1.ACID=ooac.ACID 
                    inner join LITPL_OAC2 oac2 on oac2.ACID=oac1.ACID
                    where oac1.UserCode = '${userModel.UserCode}' AND oac2.Level = 1 AND ooac.DocName ='${DocName}' COLLATE NOCASE and ooac.Active=1
  ''';
    List<Map<String, dynamic>> map = await db.rawQuery(str);
    if (map.isNotEmpty) {
      return ApprovalModel.fromJson(map[0]);
    } else {
      return null;
    }
  }
}
