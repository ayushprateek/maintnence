import 'dart:io';

import 'package:flutter_share/flutter_share.dart';
import 'package:maintenance/Component/AppConfig.dart';
import 'package:maintenance/Component/CompanyDetails.dart';
import 'package:maintenance/Component/GetFormattedDate.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/main.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whatsapp_share/whatsapp_share.dart';

String logFileName = 'FILE_NAME';
String dbFileName = 'DB_FILE_NAME';

Future<void> writeToLogFile(
    {required String text,
    required String fileName,
    required int lineNo}) async {
  await CompanyDetails.loadCompanyDetails();
  final directory = await getExternalStorageDirectory();
  String? filePath = localStorage?.getString(logFileName);
  if (filePath == null||filePath == '') {
    ///FIRST LOG
    ///CREATE LOG FILE
    String companyName =
        CompanyDetails.ocinModel?.CompanyName?.split(' ')[0] ?? '';
    filePath =
        '${companyName}_${userModel.UserCode}';
    localStorage?.setString(logFileName, filePath);
  }
  File file = File(
    '${directory?.path}/$filePath.txt',
  );

  int logId = localStorage?.getInt('LogId') ?? 0;
  PackageInfo? packageInfo = await PackageInfo.fromPlatform();

  try {
    logId++;
    if (logId == 1) {
      text =
          '''Company Name --> "${CompanyDetails.ocinModel?.CompanyName}"\nApp Version - ${packageInfo.version ?? ''}(${packageInfo.buildNumber ?? ''})\nURL : $prefix\nUser : ${userModel.UserCode},${userModel.Name}\n\n\nLog : $logId\nTime : ${getFormattedDateAndTime(DateTime.now())}\nError : $text\nStack Trace : $fileName\n''';
    } else {
      text =
          '''Log : $logId\nTime : ${getFormattedDateAndTime(DateTime.now())}\nError : $text\nStack Trace : $fileName\n''';
    }
    await file.writeAsString(text, mode: FileMode.append, flush: true);
    print('Text written to file successfully.');
    print(text);
    print(await file.exists());
    String fileContents = await file.readAsString();
    print(fileContents);
    await localStorage?.setInt('LogId', logId);
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    print('Error writing to file: $e');
  }
}

Future<String> readLogFile() async {
  try {
    final directory = await getExternalStorageDirectory();
    String? filePath = localStorage?.getString(logFileName);
    if (filePath == null||filePath == '') {
      return '';
    }
    File file = File(
      '${directory?.path}/$filePath.txt',
    );

    if (await file.exists()) {
      String fileContents = await file.readAsString();
      print(fileContents);
      return fileContents;
    } else {
      print('File not found.');
      return "File not found.";
    }
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    return "Error reading file: $e";
  }
}
// Future<void> openLogFile() async {
//   try {
//     final directory = await getExternalStorageDirectory();
//     File file = File('${directory?.path}/log.txt');
//
//     if (await file.exists()) {
//       OpenFile.open(file.path);
//     } else {
//       getErrorSnackBar('Can not open file');
//     }
//   } catch (e) {
//     getErrorSnackBar('Can not open file');
//   }
// }

Future<void> shareLogFile() async {
  final directory = await getExternalStorageDirectory();
  File file = File('${directory?.path}/log.txt');
  print(file.path);

  // Directory? downloadsDirectory = await DownloadsPath.downloadsDirectory();
  // // copy file to downloadsDirectory
  // String fileBasename = basename(file.path);
  // String pubPath = '${downloadsDirectory?.path}/$fileBasename';
  // await file.copy(pubPath);
  // FlutterShare.shareFile(
  //   title: 'share image',
  //   text: "share image",
  //   filePath: pubPath,
  // );

  await FlutterShare.shareFile(
    title: appName,
    text: 'Log File',
    filePath: file.path,
    // fileType: '*.txt'
  );
}

Future<void> shareFileOnWhatsApp() async {
  final directory = await getExternalStorageDirectory();
  File file = File('${directory?.path}/log.txt');
  print(file.path);
  bool logFileExists = await file.exists();
  if (!logFileExists) {
    getErrorSnackBar('You do not have any log');
    return;
  }
  await WhatsappShare.shareFile(
    phone: '*',
    filePath: [file.path],
  );
}
