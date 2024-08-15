import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/GetCredentials.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/SyncModels/OCIN.dart';
import 'package:maintenance/Sync/SyncModels/OCINMetaData.dart';
import 'package:package_info_plus/package_info_plus.dart';

RxBool isAppVersionValid = RxBool(true);

Future<void> isValidAppVersion() async {
  PackageInfo? packageInfo = await PackageInfo.fromPlatform();
  String currentVersion = packageInfo.version;
  int currentBuildNo = int.tryParse(packageInfo.buildNumber) ?? 0;
  DateTime? syncDate = getDataSyncDate();
  if (syncDate == null) {
    try {
      var response = await http.get(
        Uri.parse(
          prefix + 'ocin/metadata',
        ),
      );
      print(response.body);
      OCINMetaDataModel ocinMetaDataModel =
          OCINMetaDataModel.fromJson(jsonDecode(response.body));
      String latestVersion = ocinMetaDataModel.MinMobileVersion ?? '';
      int latestBuildNo = ocinMetaDataModel.MinMobileBuildNo ?? 0;
      if (latestVersion != '') {
        bool isValid =
            latestVersion == currentVersion && latestBuildNo == currentBuildNo;
        isAppVersionValid = RxBool(isValid);
      }
    } catch (e) {}
  } else {
    List<OCINModel> list = await retrieveOCIN(null);
    if (list.isNotEmpty) {
      String latestVersion = list[0].MinMobileVersion ?? '';
      int latestBuildNo = list[0].MinMobileBuildNo ?? 0;
      if (latestVersion != '') {
        bool isValid =
            latestVersion == currentVersion && latestBuildNo == currentBuildNo;
        isAppVersionValid = RxBool(isValid);
      }
    }
  }

  // int v1Number = getExtendedVersionNumber(v1);
  // int v2Number = getExtendedVersionNumber(v2);
  // print(v1Number == v2Number);
  // return v1Number != v2Number;
}

int getExtendedVersionNumber(String version) {
  List versionCells = version.split('.');
  versionCells = versionCells.map((i) => int.parse(i)).toList();
  return versionCells[0] * 100000 + versionCells[1] * 1000 + versionCells[2];
}
