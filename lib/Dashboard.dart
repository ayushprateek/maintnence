import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:maintenance/CheckListDocument/CheckListDetails/CheckListDetails.dart'
    as checkListDetails;
import 'package:maintenance/CheckListDocument/CheckListDocument.dart';
import 'package:maintenance/CheckListDocument/GeneralData.dart'
    as checkListGenData;
import 'package:maintenance/Component/AppConfig.dart';
import 'package:maintenance/Component/CheckInternet.dart';
import 'package:maintenance/Component/ClearTextFieldData.dart';
import 'package:maintenance/Component/CompanyDetails.dart';
import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/CustomDrawer.dart';
import 'package:maintenance/Component/CustomFont.dart';
import 'package:maintenance/Component/GetCurrentLocation.dart';
import 'package:maintenance/Component/GetFormattedDate.dart';
import 'package:maintenance/Component/GetLastDocNum.dart';
import 'package:maintenance/Component/IsAPIWorking.dart';
import 'package:maintenance/Component/IsAvailableTransId.dart';
import 'package:maintenance/Component/IsValidAppVersion.dart';
import 'package:maintenance/Component/NotSyncDocument.dart';
import 'package:maintenance/Component/NotificationIcon.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/CustomLocationPermission.dart';
import 'package:maintenance/DashboardQueryModel.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/LoginPage.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:maintenance/Sync/SyncModels/MNCLD1.dart';
import 'package:maintenance/Sync/SyncModels/MNCLM1.dart';
import 'package:maintenance/Sync/SyncModels/MNOCLT.dart';
import 'package:maintenance/Sync/SyncModels/MNOWCM.dart';
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
  List<MaintenanceItemsQueryModel> dashboardData = [];

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
    }
  }

  dashboardQuery() async {
    Database db = await initializeDB(null);
    //TODO:UNCOMMENT (julianday('now') - julianday(IFNULL(MNOCLD.PostingDate, '1990-12-12'))) > MNOCLT.UnitValue AND

    String query = '''
    SELECT 
    OVCLs.code AS EquipmentCode, 
    MNVCL1.CheckListCode,
    MNVCL1.CheckListName,  
    MNOCLD.PostingDate AS "LastPostingDate",
    MNVCL1.WorkCenterCode,
    MNVCL1.WorkCenterName,
    MNVCL1.TechnicianCode,
    MNVCL1.TechnicianName,
    (julianday('now') - julianday(IFNULL(MNOCLD.PostingDate, '1990-12-12'))) AS "MaintenenceDueDays",
    CASE 
        WHEN (julianday('now') - julianday(IFNULL(MNOCLD.PostingDate, '1990-12-12'))) >= MNOCLT.UnitValue THEN 'Due'
        WHEN (julianday('now') - julianday(IFNULL(MNOCLD.PostingDate, '1990-12-12'))) > MNOCLT.HighPriorityDays AND (julianday('now') - julianday(IFNULL(MNOCLD.PostingDate, '1990-12-12'))) <  MNOCLT.UnitValue THEN 'HighPriority'
        WHEN (julianday('now') - julianday(IFNULL(MNOCLD.PostingDate, '1990-12-12'))) > MNOCLT.MediumPriorityDays AND (julianday('now') - julianday(IFNULL(MNOCLD.PostingDate, '1990-12-12'))) <= MNOCLT.HighPriorityDays THEN 'MediumPriority'
    END AS 'Priority',
    MNOCLT.UnitValue AS "MaintenenceFrequencyDays"
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
    print(dataList);
    if (dataList.isNotEmpty) {
      dashboardData = dataList.map((e) {
        return MaintenanceItemsQueryModel.fromJson(e);
      }).toList();
      print(dashboardData.toString());
      setState(() {});
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
      await dashboardQuery();
      // LIND28279

      // fData
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
      await dashboardQuery();
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    validateVersion(openDrawer: true);
  }

  setCheckListData({required MaintenanceItemsQueryModel dashboardItem}) async {
    await ClearCheckListDoc.clearCheckListDocTextFields();
    await ClearCheckListDoc.clearEditCheckList();
    await ClearCheckListDoc.clearCheckListAttachments();
    checkListDetails.CheckListDetails.items.clear();
    Database db = await initializeDB(null);
    await getLastDocNum("MNCL", null).then((snapshot) async {
      int DocNum = snapshot[0].DocNumber - 1;

      do {
        DocNum += 1;
        checkListGenData.GeneralData.transId =
            DateTime.now().millisecondsSinceEpoch.toString() +
                "U0" +
                userModel.ID.toString() +
                "_" +
                snapshot[0].DocName +
                "/" +
                DocNum.toString();
      } while (await isMNCLTransIdAvailable(
          null, checkListGenData.GeneralData.transId ?? ""));
      print(checkListGenData.GeneralData.transId);
    });

    try {
      // make it come from session instead of query param
      // String from = Request.QueryString["from"];

      // MaintenanceItemsQueryModel MaintenanceItemsQueryModel = (MaintenanceItemsQueryModel)System.Web.HttpContext.Current.Session["MaintenanceItemsQueryModel"];
      // Session.Remove("MaintenanceItemsQueryModel");

      // MNOCLDViewModel.MaintenanceItemsQueryModel = MaintenanceItemsQueryModel;
      checkListGenData.GeneralData.checkListCode = dashboardItem.checkListCode;
      checkListGenData.GeneralData.workCenterCode =
          dashboardItem.workCenterCode;
      checkListGenData.GeneralData.assignedUserCode =
          dashboardItem.technicianCode;
      checkListGenData.GeneralData.equipmentCode = dashboardItem.equipmentCode;

      // checkListGenData.GeneralData.checkListName = db.MNOCLTs.FirstOrDefault(x => x.Code == dashboardItem.checkListCode)?.Name ?? "";
      checkListGenData.GeneralData.checkListName = (await db.rawQuery(
                      "SELECT Name FROM MNOCLT WHERE Code = '${dashboardItem.checkListCode}'"))[
                  0]['Name']
              ?.toString() ??
          '';
      List<MNOCLT> mnocltList = await retrieveMNOCLTById(
          null, 'Code = ?', [dashboardItem.checkListCode]);
      if (mnocltList.isNotEmpty) {
        checkListGenData.GeneralData.checkListCode = mnocltList[0].Code;
        checkListGenData.GeneralData.checkListName = mnocltList[0].Name;
      }
      List<MNOWCM> mnowcmList = await retrieveMNOWCMById(
          null, 'Code = ?', [dashboardItem.workCenterCode]);
      if (mnowcmList.isNotEmpty) {
        checkListGenData.GeneralData.workCenterCode = mnowcmList[0].Code;
        checkListGenData.GeneralData.workCenterName = mnowcmList[0].Name;
      }

      // checkListGenData.GeneralData.assignedUserName = StaticFuntion.GetEmployeeName(db, dashboardItem.TechnicianCode);
      checkListGenData.GeneralData.assignedUserName =
          dashboardItem.technicianName;
      checkListGenData.GeneralData.assignedUserCode =
          dashboardItem.technicianCode;
      checkListGenData.GeneralData.equipmentName = dashboardItem.equipmentCode;
      // checkListGenData.GeneralData.lastReadingDate = db.MNOCLDs.Where( x=> x.EquipmentCode == checkListGenData.GeneralData.EquipmentCode)
      // checkListGenData.GeneralData.lastReadingDate = db.MNOCLDs
      //     .Where( x=> x.EquipmentCode == checkListGenData.GeneralData.EquipmentCode)
      //     .OrderByDescending(x => x.UpdateDate).Select(x => x.UpdateDate)
      //     .FirstOrDefault() ?? DateTime.Now;
      List lastReadingDateList = await await db.rawQuery(
          "SELECT UpdateDate FROM MNOCLD WHERE EquipmentCode = '${dashboardItem.equipmentCode}' ORDER BY UpdateDate DESC");
      if (lastReadingDateList.isNotEmpty) {
        checkListGenData.GeneralData.lastReadingDate = getFormattedDate(
            lastReadingDateList[0]['UpdateDate'] == null ||
                    lastReadingDateList[0]['UpdateDate'] == ''
                ? DateTime.now()
                : DateTime.tryParse(
                    lastReadingDateList[0]['UpdateDate'].toString()));
      }
      List lastReadingList = await await db.rawQuery(
          "SELECT LastReading FROM MNOVCL WHERE Code = '${dashboardItem.equipmentCode}'");
      if (lastReadingList.isNotEmpty) {
        checkListGenData.GeneralData.lastReading =
            lastReadingList[0]['LastReading']?.toString();
      }
      // checkListGenData.GeneralData.lastReading= db.MNOVCLs.FirstOrDefault(x => x.Code == checkListGenData.GeneralData.EquipmentCode).LastReading.ToString() ?? "0";

      print('CHILD DATA');
      // String EquipmentGroupCode = StaticFuntion.GetEquipmentGroupCodeByEquipmentCode(checkListGenData.GeneralData.EquipmentCode);
      String? EquipmentGroupCode = (await db.rawQuery(
                  "SELECT EquipmentGroupCode FROM MNOVCL WHERE Code='${dashboardItem.equipmentCode}'"))[
              0]['EquipmentGroupCode']
          ?.toString();

      // String CheckListTemplateCode = db.MNOCLMs.FirstOrDefault(x =>
      //     x.CheckListCode == checkListGenData.GeneralData.CheckListCode &&
      //     x.EquipmentGroupCode == EquipmentGroupCode)?.Code ?? "";

      String CheckListTemplateCode = (await db.rawQuery(
                      "select Code from mnoclm where CheckListCode = '${dashboardItem.checkListCode}' and EquipmentGroupCode = '$EquipmentGroupCode'"))[
                  0]['Code']
              ?.toString() ??
          '';

      // bool checkIfTyreMiantenanceIsAplicable = db.MNEQG2.FirstOrDefault(x => x.CheckListCode == checkListGenData.GeneralData.CheckListCode && x.Code == EquipmentGroupCode).IsTyreMaintenence ?? false;
      bool checkIfTyreMiantenanceIsAplicable = (await db.rawQuery(
                  "SELECT IsTyreMaintenence FROM MNEQG2 WHERE CheckListCode='${dashboardItem.checkListCode}' AND Code='$EquipmentGroupCode'"))[
              0]['IsTyreMaintenence'] ==
          1;
      if (checkIfTyreMiantenanceIsAplicable) {
        CheckListDocument.numOfTabs.value = 4;
      }

      // ViewBag.TyreMaintenace = checkIfTyreMiantenanceIsAplicable;
      checkListGenData.GeneralData.tyreMaintenance =
          checkIfTyreMiantenanceIsAplicable ? 'Yes' : 'No';
      checkListDetails.CheckListDetails.items.clear();
      List<MNCLM1> checkListMaster =
          await retrieveMNCLM1ById(null, 'Code = ?', [CheckListTemplateCode]);
      for (MNCLM1 mnclm1 in checkListMaster) {
        checkListDetails.CheckListDetails.items.add(MNCLD1(
          TransId: checkListGenData.GeneralData.transId,
          RowId: checkListDetails.CheckListDetails.items.length,
          ItemCode: mnclm1.ItemCode,
          ItemName: mnclm1.ItemName,
          UOM: mnclm1.UOM,
          Description: mnclm1.CheckListDesc,
          Remarks: mnclm1.Remarks,
          ConsumptionQty: mnclm1.Quantity,
        ));
      }
      Get.to(() => CheckListDocument(0));

      // MNOCLDViewModel.MNCLD1 = db.MNCLM1.Where(x => x.Code == CheckListTemplateCode).ToList().Select(y => new MNCLD1
      //     {
      //     ItemCode = y.ItemCode,
      //     ItemName = y.ItemName,
      //     UOM = y.UOM,
      //     Description = y.CheckListDesc,
      //     Remarks = y.Remarks,
      //     ConsumptionQty = y.Quantity,
      //     }).ToList();
    } catch (e) {
      print(e.toString());
    }
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
          InkWell(
              onTap: () async {
                if (!(await isInternetAvailable())) {
                  getErrorSnackBar('No internet');
                } else if (await isAPIWorking()) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => DataSync(
                            "/GetData",
                            isComingFromLogin: false,

                          )))).then((value) {
                    validateVersion(openDrawer: true);
                  });
                } else {
                  getErrorSnackBar('API is not working');
                }
              },
              child: getNotSyncedDocumentIcon()),
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
              child: Column(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  ListView.separated(
                    itemCount: dashboardData.length,
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemBuilder: (context, index) {
                      MaintenanceItemsQueryModel data = dashboardData[index];
                      return Stack(
                        fit: StackFit.loose,
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(16.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4.0,
                                  offset: Offset(2.0, 2.0),
                                ),
                              ],
                            ),
                            margin: const EdgeInsets.only(
                                left: 15.0, right: 15.0, bottom: 10),
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 8,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, right: 8.0, top: 4.0),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: FittedBox(
                                              fit: BoxFit.contain,
                                              child: Text.rich(
                                                TextSpan(
                                                  children: [
                                                    getPoppinsTextSpanHeading(
                                                        text: 'Equipment'),
                                                    getPoppinsTextSpanDetails(
                                                        text:
                                                            data.equipmentCode ??
                                                                ''),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, right: 8.0, top: 4.0),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: FittedBox(
                                              fit: BoxFit.contain,
                                              child: Text.rich(
                                                TextSpan(
                                                  children: [
                                                    getPoppinsTextSpanHeading(
                                                        text: 'Check List'),
                                                    getPoppinsTextSpanDetails(
                                                        text:
                                                            data.checkListName ??
                                                                ""),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 8,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, right: 8.0, top: 4.0),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Text.rich(
                                              TextSpan(
                                                children: [
                                                  getPoppinsTextSpanHeading(
                                                      text: 'Work Center'),
                                                  getPoppinsTextSpanDetails(
                                                      text:
                                                          data.workCenterName),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, right: 8.0, top: 4.0),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: FittedBox(
                                              fit: BoxFit.contain,
                                              child: Text.rich(
                                                TextSpan(
                                                  children: [
                                                    getPoppinsTextSpanHeading(
                                                        text: 'Technician'),
                                                    getPoppinsTextSpanDetails(
                                                        text: data
                                                            .technicianName),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: -27,
                            right: -4,
                            child: Card(
                              child: IconButton(
                                onPressed: () {
                                  setCheckListData(dashboardItem: data);
                                },
                                icon: Icon(
                                  Icons.add,
                                  color: barColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        thickness: 1,
                      );
                    },
                  ),
                ],
              ),
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
