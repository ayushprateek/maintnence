import 'dart:convert';

import 'package:maintenance/Component/GetLastDocNum.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/SyncModels/OUSR.dart';
import 'package:maintenance/main.dart';
import 'package:sqflite/sqlite_api.dart';

class GenerateTransId {
  static Future<String> getTransId({
    required String tableName,
    required String docName,
  }) async {
    String TransId = '';
    String user = localStorage?.getString('user') ?? '';
    userModel = OUSRModel.fromJson(jsonDecode(user));
    List<GetLastDocNum> list = await getLastDocNum(docName, null);

    if (list.isNotEmpty) {
      int DocNum = list[0].DocNumber - 1;

      do {
        DocNum += 1;
        TransId = DateTime.now().millisecondsSinceEpoch.toString() +
            "U0" +
            userModel.ID.toString() +
            "_" +
            list[0].DocName +
            "/" +
            DocNum.toString();
      } while (
          await isTransIdAvailable(TransId: TransId, tableName: tableName));
    }

    return TransId;
  }

  static Future<bool> isTransIdAvailable(
      {required String TransId,
      required String tableName,
      Transaction? txn})
  async {
    var db;
    if (txn == null) {
      db = await initializeDB(null);
    } else {
      db = txn;
    }
    TransId = TransId.substring(13);
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
        "SELECT * FROM $tableName WHERE SUBSTR(TransId,14) = '${TransId}'");
    return queryResult.isNotEmpty;
  }

  static updateDonNum({
    required String docName,
})async{
    Database db=await initializeDB(null);
    await db.rawQuery("UPDATE DOCN SET DocNumber=DocNumber+1 WHERE DocName='$docName'");
  }


}
