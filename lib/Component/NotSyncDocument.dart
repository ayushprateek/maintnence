import 'package:flutter/material.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:sqflite/sqlite_api.dart';

Future<int> retrieveNotSyncedDocument() async {
  final Database db = await initializeDB(null);
  final List<Map<String, Object?>> queryResult = await db.rawQuery('''
  SELECT SUM(num) AS num FROM(
-- CHECK LIST DOCUMENT
SELECT IFNULL(COUNT(*),0) AS num FROM MNOCLD WHERE has_created=1 union all
SELECT IFNULL(COUNT(*),0) AS num FROM MNOCLD WHERE has_updated=1 union all
SELECT IFNULL(COUNT(*),0) AS num FROM MNCLD1 WHERE has_created=1 union all
SELECT IFNULL(COUNT(*),0) AS num FROM MNCLD1 WHERE has_updated=1 union all
SELECT IFNULL(COUNT(*),0) AS num FROM MNCLD2 WHERE has_created=1 union all
SELECT IFNULL(COUNT(*),0) AS num FROM MNCLD2 WHERE has_updated=1 union all
SELECT IFNULL(COUNT(*),0) AS num FROM MNCLD3 WHERE has_created=1 union all
SELECT IFNULL(COUNT(*),0) AS num FROM MNCLD3 WHERE has_updated=1 union all
-- SJOB CARD
SELECT IFNULL(COUNT(*),0) AS num FROM MNOJCD WHERE has_created=1 union all
SELECT IFNULL(COUNT(*),0) AS num FROM MNOJCD WHERE has_updated=1 union all
SELECT IFNULL(COUNT(*),0) AS num FROM MNJCD1 WHERE has_created=1 union all
SELECT IFNULL(COUNT(*),0) AS num FROM MNJCD1 WHERE has_updated=1 union all
SELECT IFNULL(COUNT(*),0) AS num FROM MNJCD2 WHERE has_created=1 union all
SELECT IFNULL(COUNT(*),0) AS num FROM MNJCD2 WHERE has_updated=1 union all
SELECT IFNULL(COUNT(*),0) AS num FROM MNJCD3 WHERE has_created=1 union all
SELECT IFNULL(COUNT(*),0) AS num FROM MNJCD3 WHERE has_updated=1 union all
-- GOODS ISSUE
SELECT IFNULL(COUNT(*),0) AS num FROM IMOGDI WHERE has_created=1 union all
SELECT IFNULL(COUNT(*),0) AS num FROM IMOGDI WHERE has_updated=1 union all
SELECT IFNULL(COUNT(*),0) AS num FROM IMGDI1 WHERE has_created=1 union all
SELECT IFNULL(COUNT(*),0) AS num FROM IMGDI1 WHERE has_updated=1 union all

-- PURCHASE REQUEST
SELECT IFNULL(COUNT(*),0) AS num FROM PROPRQ WHERE has_created=1 union all
SELECT IFNULL(COUNT(*),0) AS num FROM PROPRQ WHERE has_updated=1 union all
SELECT IFNULL(COUNT(*),0) AS num FROM PRPRQ1 WHERE has_created=1 union all
SELECT IFNULL(COUNT(*),0) AS num FROM PRPRQ1 WHERE has_updated=1 union all
-- GRN
SELECT IFNULL(COUNT(*),0) AS num FROM PROPDN WHERE has_created=1 union all
SELECT IFNULL(COUNT(*),0) AS num FROM PROPDN WHERE has_updated=1 union all
SELECT IFNULL(COUNT(*),0) AS num FROM PRPDN1 WHERE has_created=1 union all
SELECT IFNULL(COUNT(*),0) AS num FROM PRPDN1 WHERE has_updated=1 union all
SELECT IFNULL(COUNT(*),0) AS num FROM PRPDN2 WHERE has_created=1 union all
SELECT IFNULL(COUNT(*),0) AS num FROM PRPDN2 WHERE has_updated=1 union all
SELECT IFNULL(COUNT(*),0) AS num FROM PRPDN3 WHERE has_created=1 union all
SELECT IFNULL(COUNT(*),0) AS num FROM PRPDN3 WHERE has_updated=1 union all
-- INTERNAL REQUEST
SELECT IFNULL(COUNT(*),0) AS num FROM PROITR WHERE has_created=1 union all
SELECT IFNULL(COUNT(*),0) AS num FROM PROITR WHERE has_updated=1 union all
SELECT IFNULL(COUNT(*),0) AS num FROM PRITR1 WHERE has_created=1 union all
SELECT IFNULL(COUNT(*),0) AS num FROM PRITR1 WHERE has_updated=1 
)
''');
  int num = 0;
  if (queryResult.isNotEmpty) {
    num = int.tryParse(queryResult[0]['num'].toString()) ?? 0;
  }
  return num;
}

Widget getNotSyncedDocumentIcon() {
  return FutureBuilder(
      future: retrieveNotSyncedDocument(),
      builder: (context, AsyncSnapshot<int> snapshot) {
        if (!snapshot.hasData || snapshot.data == 0) {
          return Padding(
              padding: const EdgeInsets.only(top: 17.5, bottom: 8, right: 20),
              child: Icon(
                Icons.sync,
                color: Colors.white,
              ));
        }
        return Padding(
            padding: const EdgeInsets.only(top: 17.5, bottom: 8, right: 20),
            child: Badge(
              label: Text(
                snapshot.data?.toString() ?? '',
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
              offset: Offset(6, -6),
              child: Icon(Icons.sync, color: Colors.white),
              // child: getSVGIcon(path: bagIconPath),
            ));
      });
}
