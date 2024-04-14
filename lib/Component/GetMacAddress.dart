import 'package:flutter/services.dart';

Future<String> getMACAddress() async {
  String MAC_address = "test";
  try {
//todo: GetMac dependency doesn't support null safety
    // MAC_address = await GetMac.macAddress;
  } on PlatformException {
    MAC_address = 'Failed to get Device MAC Address.';
  }
  print("MAC-: " + MAC_address);
  return MAC_address;
}
