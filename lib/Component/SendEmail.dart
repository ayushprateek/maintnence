// import 'dart:io';
//
// import 'package:maintenance/Component/CompanyDetails.dart';
// import 'package:maintenance/Component/LogFileFunctions.dart';
// import 'package:maintenance/Component/SnackbarComponent.dart';
// import 'package:maintenance/main.dart';
// import 'package:mailer/mailer.dart';
// import 'package:mailer/smtp_server.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';
//
// sendEmail({
//   Function? onSuccess,
//   Function(String error)? onError,
// }) async {
//   final directory = await getExternalStorageDirectory();
//   String? filePath = localStorage?.getString(logFileName);
//   if (filePath == null||filePath == '') {
//     return;
//   }
//   File logFile = File(
//     '${directory?.path}/$filePath.txt',
//   );
//   // File dbFile = File('${path}/LITSale.db');
//   bool logFileExists = await logFile.exists();
//   // bool dbFileExists = await dbFile.exists();
//   List<Attachment> attachments = [];
//   if (logFileExists) {
//     attachments.add(FileAttachment(logFile));
//   }
//   // if (dbFileExists) {
//   //   attachments.add(FileAttachment(dbFile));
//   // }
//
//   // if (!logFileExists) {
//   //   getErrorSnackBar('You do not have any log');
//   //   return;
//   // }
//   await CompanyDetails.loadCompanyDetails();
//
//   String imagePath = CompanyDetails.ocinModel?.OrganizationLogoUrl??'';
//
//   // body +=
//   //     "<br><I>If you have any query then kindly reply to this email or contact us at contact@kishul.com</I>";
//   String username = 'ayush.kishul@gmail.com';
//   String password = 'rfizqgzxzavkwhtm';
//   //also use for gmail smtp
//   final smtpServer = gmail(username, password);
//   // final domainSmtp = value['email_domain_smtp'];
//   // final smtpServer = SmtpServer(domainSmtp,
//   //     username: username, password: password, port: value['email_port']);
//   final message = Message()
//     ..from = Address(username, '${CompanyDetails.ocinModel?.CompanyName ?? ''}')
//     ..recipients.add('ayushpratiksrivastava@gmail.com')
//     ..subject = 'Log file'
//     ..text = 'This is the plain text.\nThis is line 2 of the text part.'
//     ..html =
//         "<img src=$imagePath width=180><h1>Hi</h1>\n\n<h2>Greetings from '${userModel.Name}'</h2>\n\n<p>I am attaching my logfile with this email</p>"
//     ..attachments = attachments;
//
//   try {
//     print(smtpServer.toString());
//     final sendReport = await send(message, smtpServer);
//     print('Message sent: $sendReport');
//     logFile.delete();
//     localStorage?.setInt('LogId',0);
//     localStorage?.setString(logFileName,'');
//     if (onSuccess != null) {
//       onSuccess();
//     }
//   } catch (e) {
//     print('Message not sent.');
//     print(e.toString());
//     if (onError != null) {
//       onError(e.toString());
//     }
//     getErrorSnackBar(e.toString());
//   }
// }
//
// sendEmail2({
//   Function? onSuccess,
//   Function(String error)? onError,
// }) async {
//   final directory = await getExternalStorageDirectory();
//   String? filePath = localStorage?.getString(logFileName);
//   if (filePath == null||filePath == '') {
//     return;
//   }
//   File logFile = File(
//     '${directory?.path}/$filePath.txt',
//   );
//
//   bool logFileExists = await logFile.exists();
//
//   List<Attachment> attachments = [];
//   if (logFileExists) {
//     attachments.add(FileAttachment(logFile));
//   }
//   await CompanyDetails.loadCompanyDetails();
//   String imagePath = CompanyDetails.ocinModel?.OrganizationLogoUrl??'';
//   String username = 'ayush.kishul@gmail.com';
//   String password = 'rfizqgzxzavkwhtm';
//   final smtpServer = gmail(username, password);
//   // final domainSmtp = value['email_domain_smtp'];
//   // final smtpServer = SmtpServer(domainSmtp,
//   //     username: username, password: password, port: value['email_port']);
//   final message = Message()
//     ..from = Address(username, '${CompanyDetails.ocinModel?.CompanyName ?? ''}')
//     ..recipients.add('ayushpratiksrivastava@gmail.com')
//     ..subject = 'Log file'
//     ..text = 'This is the plain text.\nThis is line 2 of the text part.'
//     ..html =
//         "<img src=$imagePath width=180><h1>Hi</h1>\n\n<h2>Greetings from '${userModel.Name}'</h2>\n\n<p>I am attaching my logfile with this email</p>"
//     ..attachments = attachments;
//
//   try {
//     print(smtpServer.toString());
//     final sendReport = await send(message, smtpServer);
//     print('Message sent: $sendReport');
//     logFile.delete();
//     localStorage?.setInt('LogId',0);
//     localStorage?.setString(logFileName,'');
//     if (onSuccess != null) {
//       onSuccess();
//     }
//   } catch (e) {
//     print('Message not sent.');
//     print(e.toString());
//     if (onError != null) {
//       onError(e.toString());
//     }
//     getErrorSnackBar(e.toString());
//   }
// }
