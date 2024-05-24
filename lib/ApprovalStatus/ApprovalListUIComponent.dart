import 'package:maintenance/main.dart';

GetApprovalConfiguration_Multiple(
    {required var db, required String docName}) async {
  String query = '''
    SELECT oac1.UserCode as OUserCode,oac1.UserName as OUserName,
         oac2.Level,ooac.ACID,
        oac2.UserCode as AUserCode,
        oac2.UserName as AUserName , ooac.DocID ,ooac.DocName, ooac.Active,ooac.`Add` FROM LITPL_OAC1 oac1 
INNER JOIN LITPL_OAC2 oac2 on oac1.ACID = oac2.ACID
INNER JOIN  LITPL_OOAC ooac on oac2.ACID = ooac.ACID
where oac1.UserCode = '${userModel.UserCode}' AND oac2.Level = 1
AND ooac.DocName = '$docName' AND ooac.Active = 1
    ''';
  print(query);

  List<Map> l = await db.rawQuery(query);
  print(l);
  return l;
}