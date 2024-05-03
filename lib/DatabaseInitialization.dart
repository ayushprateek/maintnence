import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Database/DatabaseHandler.dart';
import 'package:maintenance/main.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:xml/xml.dart' as xml;

Future<Database> initializeDB(BuildContext? context) async {
  String path = await getDatabasesPath();


  String? str = localStorage?.getString('tableScript');
  Map m = jsonDecode(str ?? '');
  // print(m);
  // String xmlString = m['MaintenanceTableCreationScript'];
  String maintenanceCommonTableScript = m['MaintenanceCommonTableScript'];
  String maintenanceMasterTableScript = m['MaintenanceMasterTableScript'];
  String maintenanceTransactionTableCreationScript = m['MaintenanceTransactionTableCreationScript'];
  String xmlString='''
      <data>
      $maintenanceCommonTableScript
      $maintenanceMasterTableScript
      $maintenanceTransactionTableCreationScript
      </data>
      ''';
  // Map m = jsonDecode(str ?? '');
  // // print(m);
  // String xmlString = m['MaintenanceTransactionTableCreationScript'];
  bool databaseExists =
      await databaseFactory.databaseExists(path + "/LITSale.db");
  if (databaseExists) {
    var d = await openDatabase(path + "/LITSale.db");
    int oldDBVersion = await d.getVersion();
    if (DatabaseHandler.currentDBVersion != oldDBVersion) {
      await databaseFactory.deleteDatabase(path + "/LITSale.db");
    }
  }
  return openDatabase(
    join(path, 'LITSale.db'),
    onCreate: (database, version) async {
      var elements = xml.XmlDocument.parse(xmlString).findAllElements("table");
      elements.map((e) async {
        print(e.findElements("create_statement").first.text);
        try {
          // print(e.findElements("create_statement").first.text);
          // print(e.findElements("create_statement").first.value);
          // print(e.findElements("create_statement").first.innerText);
          await database
              .execute(e.findElements("create_statement").first.innerText);
        } catch (e) {
          writeToLogFile(
              text: e.toString(), fileName: StackTrace.current.toString(), lineNo: 141);
          print(e.toString());
        }
      }).toList();
    },
    onUpgrade: (Database db, int oldVersion, int newVersion) {},
    onDowngrade: (Database db, int oldVersion, int newVersion) {},
    version: DatabaseHandler.currentDBVersion,
  );
}

deleteDatabase() async {
  String path = await getDatabasesPath();
  bool databaseExists =
      await databaseFactory.databaseExists(path + "/LITSale.db");
  if (databaseExists) {
    await databaseFactory.deleteDatabase(path + "/LITSale.db");
  }
}
