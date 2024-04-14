import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:maintenance/Component/GetCredentials.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/SyncModels/OUSR.dart';
import 'package:maintenance/main.dart';
import 'package:crypto/crypto.dart';

Future<bool> isAPIWorking() async {
  try {
    credentials = getCredentials();
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(credentials+secretKey);
     header = {
      'Authorization': 'Basic $encoded',
      "content-type": "application/json",
      "connection": "keep-alive",
      // 'Keep-Alive':' timeout=15, max=100'
    };
    var response = await http.get(
      Uri.parse(
        prefix + 'OCIN/GETALL',
      ),
      headers: header,
    );
    print(response.body);
    return response.statusCode == 200;
  } catch (e) {
    return false;
  }
}
