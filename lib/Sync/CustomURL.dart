import 'dart:convert';

import 'package:maintenance/Component/GetCredentials.dart';

///NOTE WHILE CREATING APK
///1. CHANGE THE VERSION
///2. CHANGE THE BUILD NUMBER
///3. CHANGE DATABASE VERSION
///4. CHANGE API KEY IN CUSTOM URL
///5. CHANGE API KEY IN MANIFEST FILE
///6. CHANGE URL IN CUSTOM URL
///7. CREATE A NEW BRANCH AFTER RELEASE OF
///EVERY BRANCH(CHANGE THE VERSION AFTER YOU
///CREATE AND CHECKOUT IN NEW BRANCH.
///THAT IS THE FIRST COMMIT IN NEW BRANCH SHOULD
///BE "Version changed")

String googleAPiKey =
    "AIzaSyBuDwHxhIiioaJHEDZYoJveXb9ZEVTn5vQ"; //DEVELOPMENT API KEY
// String googleAPiKey = "AIzaSyDClvq3oYi0iJzwGzxj1vBPncXrIKQ7SKg"; //LIVE API KEY

String prefix = "http://103.146.242.248:6006/"; //DEVELOPMENT
//http://103.146.242.248:6005/ DEVELOPMENT WEBSITE





// String prefix = "http://103.191.130.12:7000/";//MANSA
// http://103.191.130.12:7001/ MANSA WEBSITE

// String prefix = "http://45.115.219.49:6006/"; //MUKTINATH
// String prefix = "http://41.216.66.126:6005/API/";

String postfix = "/GetAll";

String credentials = '';
const batchSize = 1000;

Codec<String, String> stringToBase64 = utf8.fuse(base64);
String secretKey='IDH3FUSuifhiu4HUIFhsgu98fjeiujfU5H8fuishf8h84hfuishgusheg';
String encoded = stringToBase64.encode(credentials+secretKey);
Map<String, String>? header = {
  'Authorization': 'Basic $encoded',
  "content-type": "application/json",
  "connection": "keep-alive",
};

setHeader() {
  credentials = getCredentials();
  String encoded = stringToBase64.encode(credentials+secretKey);
  header = {
    'Authorization': 'Basic $encoded',
    "content-type": "application/json",
    "connection": "keep-alive"
  };
  print(header);
}
