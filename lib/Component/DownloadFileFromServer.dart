import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:path_provider/path_provider.dart';

Future<File?> downloadFileFromServer({required String path}) async {
  setHeader();
  final response = await http.post(
    Uri.parse("${prefix}LITPL_OAC1/DownloadFile?model=$path"),
    headers: header,
  );

  if (response.statusCode == 200) {
    final output = await getTemporaryDirectory();
    final file =
        File('${output.path}/${DateTime.now().millisecondsSinceEpoch}.jpg');

    await file.writeAsBytes(response.bodyBytes);
    return file;
  } else {
    return null;
  }
}
