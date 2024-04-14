import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/CompanyDetails.dart';
import 'package:maintenance/Component/GetCredentials.dart';
import 'package:maintenance/Component/GetFormattedDate.dart';
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/main.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

Future<String> uploadImageToServer(File? imageFile, BuildContext? context,
    {required Function setURL}) async {
  String path = "";
  String? MobDocPAth = "C:/LitSal/LitSalP/Uploads/EmpMaster";
  // List<OCINModel> list = await retrieveOCIN(context);
  // if (list.isNotEmpty) {
  //   MobDocPAth = list[0].MobDocPAth;
  // }
  // // if(MobDocPAth==null|| MobDocPAth=="")
  // // {
  // //   Fluttertoast.showToast(msg: "Could not load server path");
  // // }
  // else {
  //   MobDocPAth = "Imageupload/uploadfile";
  //   String fileName = basename(imageFile!.path);
  //   var request = http.MultipartRequest("POST", Uri.parse(prefix + MobDocPAth));
  //
  //   var picture = http.MultipartFile.fromBytes('image',
  //       (await rootBundle.load('images/logo.png')).buffer.asUint8List(),
  //       filename: fileName);
  //
  //   request.files.add(picture);
  //
  //   var response = await request.send();
  //
  //   var responseData = await response.stream.toBytes();
  //
  //   var result = String.fromCharCodes(responseData);
  //
  //   print(result);
  // }

  var stream = http.ByteStream(DelegatingStream.typed(imageFile!.openRead()));
  var length = await imageFile.length();

  MobDocPAth = "LITPL_OAC1/UploadSingleImage";
  var request = http.MultipartRequest("POST", Uri.parse(prefix + MobDocPAth));

  var picture = http.MultipartFile('file', stream, length,
      filename: basename(imageFile.path));

  request.files.add(picture);

  credentials = getCredentials();
  String encoded = stringToBase64.encode(credentials+secretKey);
  header = {
    'Authorization': 'Basic $encoded',
    "content-type": "application/json",
    "connection": "keep-alive"
  };
  request.headers['Authorization'] = header!['Authorization']!;
  request.headers['content-type'] = header!['content-type']!;
  var response = await request.send();

  var responseData = await response.stream.toBytes();

  var result = String.fromCharCodes(responseData);

  //{"dbPath":"Attachment\\Documents\\a3c13b7b-f950-4dec-b1a1-3ccebe19fb15181182899660113005625b5aa6a-7ea9-4172-8e86-bb3c64b9a963.jpg"}

  print(result);
  Map map = json.decode(result);
  if (map['dbPath'] != null && map['dbPath'] != "") {
    imageFile.delete();
    localStorage?.setInt('LogId', 0);
    localStorage?.setString(logFileName, '');
    // var res=await http.post(Uri.parse(prefix + "LITPL_OAC1/DownloadFile",),
    // body: jsonEncode({
    //   'model':'Attachment\\Documents\\a3c13b7b-f950-4dec-b1a1-3ccebe19fb15181182899660113005625b5aa6a-7ea9-4172-8e86-bb3c64b9a963.jpg'
    // }));
    // print(res.body);

    path = map['dbPath'];
    setURL(map['dbPath']);
    return path;
  } else {
    return "";
  }
}

Future<String> uploadLogFileToServer() async {
  String path = "";
  final directory = await getExternalStorageDirectory();
  String? filePath = localStorage?.getString(logFileName);

  File imageFile = File(
    '${directory?.path}/$filePath.txt',
  );
  print(await imageFile.exists());
  bool fileExists = await imageFile.exists();
  if (!fileExists) {
    return '';
  }

  var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
  var length = await imageFile.length();

  String MobDocPAth = "LITPL_OAC1/UploadLogFile";
  var request = http.MultipartRequest("POST", Uri.parse(prefix + MobDocPAth));

  var picture = http.MultipartFile('file', stream, length,
      filename: basename(imageFile.path));

  request.files.add(picture);

  credentials = getCredentials();
  String encoded = stringToBase64.encode(credentials+secretKey);
  header = {
    'Authorization': 'Basic $encoded',
    "content-type": "application/json",
    "connection": "keep-alive"
  };
  request.headers['Authorization'] = header!['Authorization']!;
  request.headers['content-type'] = header!['content-type']!;
  var response = await request.send();

  var responseData = await response.stream.toBytes();

  var result = String.fromCharCodes(responseData);

  print(result);
  Map map = json.decode(result);
  if (map['dbPath'] != null && map['dbPath'] != "") {
    // var res=await http.post(Uri.parse(prefix + "LITPL_OAC1/DownloadFile",),
    // body: jsonEncode({
    //   'model':'Attachment\\Documents\\a3c13b7b-f950-4dec-b1a1-3ccebe19fb15181182899660113005625b5aa6a-7ea9-4172-8e86-bb3c64b9a963.jpg'
    // }));
    // print(res.body);
    imageFile.delete();
    localStorage?.setInt('LogId', 0);
    localStorage?.setString(logFileName, '');

    path = map['dbPath'];
    print(path);
    return path;
  } else {
    return "";
  }
}

Future<void> uploadLocalDBToServer() async {
  String path = await getDatabasesPath();
  File imageFile = File('${path}/LITSale.db');
  bool exists = await imageFile.exists();
  if (!exists) {
    return;
  }

  var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
  var length = await imageFile.length();

  String MobDocPAth = "LITPL_OAC1/UploadLogFile";
  var request = http.MultipartRequest("POST", Uri.parse(prefix + MobDocPAth));

  var picture = http.MultipartFile('file', stream, length,
      filename: basename(imageFile.path));

  request.files.add(picture);

  credentials = getCredentials();
  String encoded = stringToBase64.encode(credentials+secretKey);
  header = {
    'Authorization': 'Basic $encoded',
    "content-type": "application/json",
    "connection": "keep-alive"
  };
  request.headers['Authorization'] = header!['Authorization']!;
  request.headers['content-type'] = header!['content-type']!;
  var response = await request.send();

  var responseData = await response.stream.toBytes();

  var result = String.fromCharCodes(responseData);

  print(result);
  Map map = json.decode(result);
  print(map);
  if (map['dbPath'] != null && map['dbPath'] != "") {
    // var res=await http.post(Uri.parse(prefix + "LITPL_OAC1/DownloadFile",),
    // body: jsonEncode({
    //   'model':'Attachment\\Documents\\a3c13b7b-f950-4dec-b1a1-3ccebe19fb15181182899660113005625b5aa6a-7ea9-4172-8e86-bb3c64b9a963.jpg'
    // }));
    // print(res.body);
  }
}

Future<void> uploadDBQueryResultToServer() async {
  Database db = await initializeDB(null);
  String query1 = '''
    Select  BaseTransId as RouteId,ItemCode,ItemName,CreatedBy,  sum(LoadQty) as LoadQty,sum(SalesQty) as SalesQty,(sum(LoadQty) -sum(SalesQty)) as BalQty 
        ,RouteIdNum
        from(
        select T0.BaseTransId,cast(substr(T0.BaseTransId,4, length(T0.BaseTransId))as int) as RouteIdNum,T1.ItemCode,T1.ItemName,T0.CreatedBy, T0.CreateDate,T1.LoadQty,0 as SalesQty 
      from ODSC T0 inner join DSC1 T1 on T0.TransId=T1.TransId
        union all
        select T0.BaseTransId,cast(substr(T0.BaseTransId,4, length(T0.BaseTransId))as int) as RouteIdNum,T1.ItemCode,T1.ItemName,T0.CreatedBy, T0.CreateDate,T1.Quantity,0 as SalesQty 
      from ODSC T0 inner join DSC2 T1 on T0.TransId=T1.TransId
        union all
        select T0.RPTransId,cast(substr(T0.RPTransId,4, length(T0.RPTransId))as int) as RouteIdNum,T1.ItemCode,T1.ItemName,T0.CreatedBy, T0.CreateDate,0,T1.Quantity as SalesQty 
      from OINV T0 inner join INV1 T1 on T0.TransId=T1.TransId
        )a 
        where RouteIdNum = 125
        group by BaseTransId,ItemCode,ItemName,CreatedBy
    ''';

  final List<Map<String, Object?>> queryResult = await db.rawQuery(query1);
  if (queryResult.isEmpty) {
    return;
  }
  String text = '''\n${queryResult.toString()}''';

  await CompanyDetails.loadCompanyDetails();
  final directory = await getExternalStorageDirectory();
  String? filePath = localStorage?.getString(dbFileName);
  if (filePath == null || filePath == '') {
    ///FIRST DB Script
    ///CREATE DB Script FILE
    String companyName =
        CompanyDetails.ocinModel?.CompanyName?.split(' ')[0] ?? '';
    filePath = '${companyName}_${userModel.UserCode}';
    localStorage?.setString(dbFileName, filePath);
  }
  File file = File(
    '${directory?.path}/$filePath.txt',
  );

  int dbScriptId = localStorage?.getInt('DBScriptId') ?? 0;
  PackageInfo? packageInfo = await PackageInfo.fromPlatform();

  try {
    dbScriptId++;
    if (dbScriptId == 1) {
      text =
          '''Company Name --> "${CompanyDetails.ocinModel?.CompanyName}"\nApp Version - ${packageInfo.version ?? ''}(${packageInfo.buildNumber ?? ''})\nURL : $prefix\nUser : ${userModel.UserCode},${userModel.Name}\n\n\DBScript : $dbScriptId\nTime : ${getFormattedDateAndTime(DateTime.now())}\nResult : $text\n''';
    } else {
      text =
          '''DBScript : $dbScriptId\nTime : ${getFormattedDateAndTime(DateTime.now())}\nResult : $text''';
    }

    await file.writeAsString(text, mode: FileMode.append, flush: true);

    print(await file.exists());
    String fileContents = await file.readAsString();
    print(fileContents);
    await localStorage?.setInt('LogId', dbScriptId);
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    print('Error writing to file: $e');
  }

  String path = await getDatabasesPath();
  File imageFile = File('${path}/LITSale.db');
  bool exists = await imageFile.exists();
  if (!exists) {
    return;
  }

  var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
  var length = await imageFile.length();

  String MobDocPAth = "LITPL_OAC1/UploadLogFile";
  var request = http.MultipartRequest("POST", Uri.parse(prefix + MobDocPAth));

  var picture = http.MultipartFile('file', stream, length,
      filename: basename(imageFile.path));

  request.files.add(picture);

  credentials = getCredentials();
  String encoded = stringToBase64.encode(credentials+secretKey);
  header = {
    'Authorization': 'Basic $encoded',
    "content-type": "application/json",
    "connection": "keep-alive"
  };
  request.headers['Authorization'] = header!['Authorization']!;
  request.headers['content-type'] = header!['content-type']!;
  var response = await request.send();

  var responseData = await response.stream.toBytes();

  var result = String.fromCharCodes(responseData);

  print(result);
  Map map = json.decode(result);
  print(map);
  if (map['dbPath'] != null && map['dbPath'] != "") {
    // var res=await http.post(Uri.parse(prefix + "LITPL_OAC1/DownloadFile",),
    // body: jsonEncode({
    //   'model':'Attachment\\Documents\\a3c13b7b-f950-4dec-b1a1-3ccebe19fb15181182899660113005625b5aa6a-7ea9-4172-8e86-bb3c64b9a963.jpg'
    // }));
    // print(res.body);
  }
}

// Future<void> uploadImages() async {
//    var request = http.MultipartRequest(
//     'POST',
//     Uri.parse('http://localhost:5095/LITPL_OAC1/UploadMultipleImage'),
//    );
//
//    // Add files to be uploaded
//    request.files.add(
//     await http.MultipartFile.fromPath(
//      'files',
//      'download.jpg',
//      contentType: MediaType('image', 'jpeg'),
//     ),
//    );
//
//    request.files.add(
//     await http.MultipartFile.fromPath(
//      'files',
//      'DemoExcel.xlsx',
//      contentType: MediaType(
//       'application',
//       'vnd.openxmlformats-officedocument.spreadsheetml.sheet',
//      ),
//     ),
//    );
//
// // uploadExpenseCaptureImages(BuildContext context) async {
// //   for (int i = 0; i < ExpenseCaptureScreen.list.length; i++) {
// //     try {
// //       File imageFile = File(ExpenseCaptureScreen.list[i].Attachment ?? "");
// //       String? MobDocPAth = "Imageupload/uploadfile";
// //       var stream =
// //           http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
// //       var length = await imageFile.length();
// //       var request =
// //           http.MultipartRequest("POST", Uri.parse(prefix + MobDocPAth));
// //       var picture = http.MultipartFile('image', stream, length,
// //           filename: basename(imageFile.path));
// //       request.files.add(picture);
// //       String credentials = "MobileAdmin:MobIle@9/3/2022";
// //       Codec<String, String> stringToBase64 = utf8.fuse(base64);
// //       String encoded = stringToBase64.encode(credentials+secretKey);
// //       Map<String, String>? header = {
// //         'Authorization': 'Basic $encoded',
// //         "content-type": "application/json",
// //       };
// //       request.headers['Authorization'] = header['Authorization']!;
// //       request.headers['content-type'] = header['content-type']!;
// //       var response = await request.send();
// //
// //       var responseData = await response.stream.toBytes();
// //
// //       var result = String.fromCharCodes(responseData);
// //
// //       print(result);
// //       if (result != null) {
// //         Map map = json.decode(result);
// //         if (map['imagePath'] != null && map['imagePath'] != "") {
// //           ExpenseCaptureScreen.list[i].Attachment = map['imagePath'];
// //           print(prefix + map['imagePath']);
// //         }
// //       }
// //     } catch (e) {
// //       print(e.toString());
// //     }
// //   }
// // }
