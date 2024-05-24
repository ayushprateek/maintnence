import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:maintenance/Component/AppConfig.dart';
import 'package:maintenance/Component/CompanyDetails.dart';
import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/CustomDrawer.dart';
import 'package:maintenance/Component/CustomFont.dart';
import 'package:maintenance/Component/GetCurrentLocation.dart';
import 'package:maintenance/Component/IsValidAppVersion.dart';
import 'package:maintenance/Component/NotificationIcon.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/CustomLocationPermission.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/LoginPage.dart';
import 'package:maintenance/main.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sqflite/sqflite.dart';

class Dashboard extends StatefulWidget {
  static var address;
  RxInt dashboardId = 0.obs;

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  GlobalKey one = GlobalKey();
  final key = GlobalKey<ScaffoldState>();

  String? latestTransId;
  List<Map>? stockQueryResult = null;
  List<Map>? cashQueryResult = null;
  List<Map>? expenseQueryResult = null;
  TextEditingController routeId = TextEditingController();
  PackageInfo? packageInfo;
  Map dashboardData = {};

  Future getLocation() async {
    bool isLoading = true;
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: MediaQuery.of(context).size.height / 20,
            width: MediaQuery.of(context).size.width / 1.5,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    ).then((value) {
      print('Dialog dismissed. Perform your task here.');
      isLoading = false;
    });
    Position pos = await getCurrentLocation();
    if (isLoading) {
      Navigator.pop(context);
    }
    if (pos.latitude == 0.0) {
      CustomDrawer.hasEnabledLocation = false;
      getErrorSnackBar("Allow the app to access your location");
    } else {
      if (Platform.isAndroid) {
        CustomDrawer.hasEnabledLocation = true;
        // var methodChannel = MethodChannel("LITSales");
        // String data = await methodChannel.invokeMethod("startService", {"user_id": userModel.Code, "dbPath": path});
      } else if (Platform.isIOS) {
        CustomDrawer.hasEnabledLocation = true;
        // var methodChannel = MethodChannel("LITSales");
        // String data = await methodChannel
        //     .invokeMethod("track_location", {"user_id": "1", "dbPath": path});
      }
      dashboardQuery();
    }
  }

  dashboardQuery() async {
    Database db = await initializeDB(null);
    //TODO:UNCOMMENT (julianday('now') - julianday(IFNULL(MNOCLD.PostingDate, '1990-12-12'))) > MNOCLT.UnitValue AND

    String query = '''
    SELECT 
    OVCLs.code AS "EquipmentCode", 
    MNVCL1.CheckListCode, 
    MNOCLD.PostingDate AS "LastPostingDate",
    (julianday('now') - julianday(IFNULL(MNOCLD.PostingDate, '1990-12-12'))) AS "MaintenenceDueDays",
    CASE 
        WHEN (julianday('now') - julianday(IFNULL(MNOCLD.PostingDate, '1990-12-12'))) >= MNOCLT.UnitValue THEN 'Due'
        WHEN (julianday('now') - julianday(IFNULL(MNOCLD.PostingDate, '1990-12-12'))) > MNOCLT.HighPriorityDays AND (julianday('now') - julianday(IFNULL(MNOCLD.PostingDate, '1990-12-12'))) <  MNOCLT.UnitValue THEN 'HighPriority'
        WHEN (julianday('now') - julianday(IFNULL(MNOCLD.PostingDate, '1990-12-12'))) > MNOCLT.MediumPriorityDays AND (julianday('now') - julianday(IFNULL(MNOCLD.PostingDate, '1990-12-12'))) <= MNOCLT.HighPriorityDays THEN 'MediumPriority'
    END AS 'Priority',
    MNOCLT.UnitValue AS "MaintenenceFrequencyDays",
    *
FROM 
    ovcl OVCLs
    LEFT JOIN mnvcl1 MNVCL1 ON OVCLs.Code = MNVCL1.Code
    LEFT JOIN mnovcl MNOVCLs ON OVCLs.Code = MNOVCLs.Code
    LEFT JOIN MNOCLD MNOCLD ON MNOCLD.equipmentcode = OVCLs.code AND MNVCL1.CheckListCode = MNOCLD.CheckListCode
    LEFT JOIN MNOCLT MNOCLT ON MNOCLT.Code = MNVCL1.CheckListCode
WHERE 
   --(julianday('now') - julianday(IFNULL(MNOCLD.PostingDate, '1990-12-12'))) > MNOCLT.UnitValue AND
     MNOCLT.CheckType = 'Others'
    ''';
    List dataList = await db.rawQuery(query);
    if (dataList.isNotEmpty) {
      setState(() {
        dashboardData = dataList[0];
      });
    }
  }

  Future<void> setVersion() async {
    packageInfo = await PackageInfo.fromPlatform();
  }

  validateVersion({required bool openDrawer}) async {
    await isValidAppVersion();
    if (isAppVersionValid == RxBool(true)) {
      setVersion();

      CompanyDetails.loadCompanyDetails();
      if (displayTakeSS == true) {
        Timer(Duration(seconds: 2), () {
          if (!imagesController.isFloating) {
            imagesController.show();
          }
        });
      }

      // syncDate = DateTime.tryParse(localStorage?.getString("syncDate") ?? '');

      initializeTimer();
      if (!CustomDrawer.hasEnabledLocation) {
        var seen = localStorage?.get("seen_location_purpose");
        if (seen != "True")
          Timer(
              Duration(milliseconds: 500),
              () => Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new CustomLocationPermission())));
        else
          Timer(Duration(milliseconds: 500), () {
            getLocation();
          });
      } else {
        if (openDrawer)
          Timer(Duration(milliseconds: 100), () {
            key.currentState?.openDrawer();
          });
      }
      // LIND28279

      // fData
      //todo: if loading data
      // fetchData();
    } else {
      if (!CustomDrawer.hasEnabledLocation) {
        var seen = localStorage?.get("seen_location_purpose");
        if (seen != "True")
          Timer(
              Duration(milliseconds: 500),
              () => Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new CustomLocationPermission())));
        else
          Timer(Duration(milliseconds: 500), () async {
            await getLocation();
          });
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    validateVersion(openDrawer: true);
  }

  Future<void> initializeTimer() async {
    await setRequiredData();
    if (rootTimer != null) rootTimer?.cancel();
    var time = Duration(minutes: MobSessionTimoutMinute ?? 45);
    rootTimer = Timer(time, () {
      getErrorSnackBar("Session Expired !");
      Get.offAll(() => LoginPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      drawer: CustomDrawer(),
      onDrawerChanged: (bool xx) {
        validateVersion(openDrawer: false);
      },
      backgroundColor: backColor,
      appBar: AppBar(
        backgroundColor: barColor,
        title: Text(
          appName,
          style: TextStyle(color: headColor, fontFamily: custom_font),
        ),
        actions: [
          Obx(() {
            if (isAppVersionValid == RxBool(true))
              return getNotificationIcon();
            else
              return Container();
          })
        ],
      ),

      body: Obx(() => isAppVersionValid != RxBool(true)
          ? Center(
              child: getHeadingText(
                  text: 'Please update the app to its latest version'),
            )
          : SingleChildScrollView(
              child: Column(),
            )),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height / 24,
        decoration: BoxDecoration(border: Border.all()),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            "Developed by : - Link Ideas Technologies Pvt Ltd",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
        ),
      ),
      //bottomNavigationBar: StickyFooter(),
    );
  }
}
