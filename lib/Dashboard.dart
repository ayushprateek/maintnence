import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance/CheckListDocument/ClearCheckListDocument.dart';
import 'package:maintenance/CheckListDocument/create/CheckListDetails/CheckListDetails.dart'
    as checkListDetails;
import 'package:maintenance/CheckListDocument/create/CheckListDocument.dart';
import 'package:maintenance/CheckListDocument/create/GeneralData.dart'
    as checkListGenData;
import 'package:maintenance/Component/AppConfig.dart';
import 'package:maintenance/Component/CheckInternet.dart';
import 'package:maintenance/Component/Common.dart';
import 'package:maintenance/Component/CompanyDetails.dart';
import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/CustomDrawer.dart';
import 'package:maintenance/Component/CustomFont.dart';
import 'package:maintenance/Component/GenerateTransId.dart';
import 'package:maintenance/Component/GetFormattedDate.dart';
import 'package:maintenance/Component/GetLiveLocation.dart';
import 'package:maintenance/Component/GetTextField.dart';
import 'package:maintenance/Component/IsValidAppVersion.dart';
import 'package:maintenance/Component/NotSyncDocument.dart';
import 'package:maintenance/Component/NotificationIcon.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/Component/StaticFunctions.dart';
import 'package:maintenance/CustomLocationPermission.dart';
import 'package:maintenance/DashboardQueryModel.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/LoginPage.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:maintenance/Sync/SyncModels/MNCLD1.dart';
import 'package:maintenance/Sync/SyncModels/MNCLM1.dart';
import 'package:maintenance/Sync/SyncModels/MNOCLT.dart';
import 'package:maintenance/Sync/SyncModels/MNOWCM.dart';
import 'package:maintenance/Sync/SyncModels/MNTTP1.dart';
import 'package:maintenance/main.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sqflite/sqflite.dart';

import 'Component/IsAPIWorking.dart';

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
  final TextEditingController _query = TextEditingController();

  Map priorityMap = {
    "Due": 0XFFDBEAFE,
    "HighPriority": 0XFFFEE2E2,
    "MediumPriority": 0XFFFFEDD5,
  };

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
    await CustomLiveLocation.getLiveLocation();
    if (isLoading) {
      Navigator.pop(context);
    }
    if (CustomLiveLocation.currentLocation == null) {
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
    OVCLs.UpdateDate AS LastServiceDate, 
    MNVCL1.CheckListCode,
    MNOCLT.CheckType,
    MNVCL1.CheckListName,  
    MNOCLD.PostingDate AS "LastPostingDate",
    MNOCLD.TransId,
    MNOCLD.CheckListStatus,
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
     MNOCLT.CheckType = 'Preventive'
     and (
     ifnull(OVCLs.code,'') Like "%${_query.text}%" or
ifnull(OVCLs.UpdateDate,'') Like "%${_query.text}%" or
ifnull(MNVCL1.CheckListCode,'') Like "%${_query.text}%" or
ifnull(MNOCLT.CheckType,'') Like "%${_query.text}%" or
ifnull(MNVCL1.CheckListName,'') Like "%${_query.text}%" or
ifnull(MNOCLD.PostingDate,'') Like "%${_query.text}%" or
ifnull(MNOCLD.CheckListStatus,'') Like "%${_query.text}%" or
ifnull(MNVCL1.WorkCenterCode,'') Like "%${_query.text}%" or
ifnull(MNVCL1.WorkCenterName,'') Like "%${_query.text}%" or
ifnull(MNVCL1.TechnicianCode,'') Like "%${_query.text}%" or
ifnull(MNVCL1.TechnicianName,'') Like "%${_query.text}%" )
    ''';
    List dataList = await db.rawQuery(query);
    print(dataList);
    if (dataList.isNotEmpty) {
      dashboardData = dataList.map((e) {
        return MaintenanceItemsQueryModel.fromJson(e);
      }).toList();
      print(dashboardData.toString());
    }
    setState(() {});
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
          // if (!imagesController.isFloating) {
          //   imagesController.show();
          // }
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
    await ClearCreateCheckListDoc.clearGeneralData();
    await ClearCreateCheckListDoc.clearEditCheckList();
    await ClearCreateCheckListDoc.clearCheckListAttachments();
    checkListDetails.CheckListDetails.items.clear();
    Database db = await initializeDB(null);
    String TransId =
        await GenerateTransId.getTransId(tableName: 'MNOCLD', docName: 'MNCL');
    print(TransId);
    checkListGenData.GeneralData.transId = TransId;

    try {
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
      checkListGenData.GeneralData.checkListStatus = 'Open';
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
          "SELECT OdometerReading FROM OVCL WHERE Code = '${dashboardItem.equipmentCode}'");
      if (lastReadingList.isNotEmpty) {
        checkListGenData.GeneralData.lastReading =
            lastReadingList[0]['OdometerReading']?.toString();
      }
      // checkListGenData.GeneralData.lastReading= db.MNOVCLs.FirstOrDefault(x => x.Code == checkListGenData.GeneralData.EquipmentCode).LastReading.ToString() ?? "0";

      print('CHILD DATA');
      // String EquipmentGroupCode = StaticFuntion.GetEquipmentGroupCodeByEquipmentCode(checkListGenData.GeneralData.EquipmentCode);
      String? EquipmentGroupCode = (await db.rawQuery(
                  "SELECT EquipmentGroupCode FROM OVCL WHERE Code='${dashboardItem.equipmentCode}'"))[
              0]['EquipmentGroupCode']
          ?.toString();

      // String CheckListTemplateCode = db.MNOCLMs.FirstOrDefault(x =>
      //     x.CheckListCode == checkListGenData.GeneralData.CheckListCode &&
      //     x.EquipmentGroupCode == EquipmentGroupCode)?.Code ?? "";

      String CheckListTemplateCode = '';
      List a = await db.rawQuery(
          "select Code from mnoclm where CheckListCode = '${dashboardItem.checkListCode}' and EquipmentGroupCode = '$EquipmentGroupCode'");
      if (a.isNotEmpty) {
        CheckListTemplateCode = a[0]['Code']?.toString() ?? '';
      }

      // bool checkIfTyreMiantenanceIsAplicable = db.MNEQG2.FirstOrDefault(x => x.CheckListCode == checkListGenData.GeneralData.CheckListCode && x.Code == EquipmentGroupCode).IsTyreMaintenence ?? false;
      bool checkIfTyreMiantenanceIsAplicable = false;
      List b = await db.rawQuery(
          "SELECT IsTyreMaintenence FROM MNEQG2 WHERE CheckListCode='${dashboardItem.checkListCode}' AND Code='$EquipmentGroupCode'");
      if (b.isNotEmpty) {
        checkIfTyreMiantenanceIsAplicable = b[0]['IsTyreMaintenence'] == 1;
      }

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
        // string wareHouseCode = db.MNOWCMs.FirstOrDefault(x => x.Code == MNOCLDViewModel.MNOCLD.WorkCenterCode)?.WhsCode;
        List<MNOWCM> whsList = await retrieveMNOWCMById(
            null, 'Code = ?', [dashboardItem.workCenterCode]);
        String? whsCode;
        if (whsList.isNotEmpty) {
          whsCode = whsList[0].WhsCode;
        }
        double availableQty = 0.0;
        List list = await db.rawQuery('''
        SELECT SUM(InQty)-SUM(OutQty) as AvailableQty FROM OINM WHERE ItemCode='${mnclm1.ItemCode}' AND WhsCode='$whsCode'
        ''');
        if (list.isNotEmpty) {
          availableQty =
              double.tryParse(list[0]['AvailableQty'].toString()) ?? 0.0;
          if (availableQty <= 0.0) {
            availableQty = 0.0;
          }
        }
        MNCLD1 mncld1 = MNCLD1(
          TransId: checkListGenData.GeneralData.transId,
          RowId: checkListDetails.CheckListDetails.items.length,
          ItemCode: mnclm1.ItemCode,
          ItemName: mnclm1.ItemName,
          UOM: mnclm1.UOM,
          Description: mnclm1.CheckListDesc,
          Remarks: mnclm1.Remarks,
          ConsumptionQty: mnclm1.Quantity,
          AvailableQty: availableQty,
          insertedIntoDatabase: false,
          EquipmentCode: dashboardItem.equipmentCode,
          Attachment: mnclm1.Attachment,
        );
        mncld1.consumptionQtyController.text =
            mnclm1.Quantity?.toStringAsFixed(2) ?? '';

        checkListDetails.CheckListDetails.items.add(mncld1);
      }
      //todo:
      // List<MNCLM1> attachmentList = await retrieveMNCLM1ById(
      //     null, 'Code = ?', [CheckListTemplateCode]);

      // for (int i = 0; i < attachmentList.length; i++) {
      //   MNCLM1 mnclm1 = attachmentList[i];
      //   checkListAttachment.Attachments.attachments.add(MNCLD2(
      //     TransId: TransId,
      //     insertedIntoDatabase: false,
      //     Attachment: mnclm1.Attachment,
      //     Remarks: mnclm1.Remarks??'',
      //     RowId: i,
      //   ));
      // }

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

  double getAvailableItemsFromOINM(String? ItemCode, String? WhsCode) {
    if (ItemCode == null || ItemCode == '' || WhsCode == null || WhsCode == '')
      return 0.0;
    double availableItems = 0.0;

    // double availableItems =
    //     (_db.OINMs.Where(x => x.ItemCode == ItemCode && x.WhsCode == WhsCode)?.
    //     Sum(y => y.InQty) ?? 0)
    //     -
    //     (_db.OINMs.Where(x => x.ItemCode == ItemCode && x.WhsCode == WhsCode)?.Sum(y => y.OutQty) ?? 0);

    return availableItems;
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
                  getTextFieldWithoutLookup(
                      controller: _query,
                      labelText: 'Search',
                      suffixIcon: InkWell(
                          onTap: () {
                            _query.clear();
                            dashboardQuery();
                          },
                          child: Icon(
                            Icons.clear,
                            color: barColor,
                          ))),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3.5,
                      height: 40,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 6.0,
                          left: 8,
                          right: 8,
                        ),
                        child: Material(
                          borderRadius: BorderRadius.circular(10.0),
                          color: barColor,
                          elevation: 0.0,
                          child: MaterialButton(
                            onPressed: () async {
                              dashboardQuery();
                            },
                            minWidth: MediaQuery.of(context).size.width,
                            child: Text(
                              "Search",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 35,
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
                              color: Color(
                                  priorityMap[data.Priority] ?? 0XFFFFFFFF),
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
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 8,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0,
                                                  right: 8.0,
                                                  top: 4.0),
                                              child: Align(
                                                alignment: Alignment.topLeft,
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
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0,
                                                  right: 8.0,
                                                  top: 4.0),
                                              child: Align(
                                                alignment: Alignment.topLeft,
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
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0,
                                                  right: 8.0,
                                                  top: 4.0),
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      getPoppinsTextSpanHeading(
                                                          text: 'Type'),
                                                      getPoppinsTextSpanDetails(
                                                          text:
                                                              data.checkType ??
                                                                  ""),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0,
                                                  right: 8.0,
                                                  top: 4.0),
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      getPoppinsTextSpanHeading(
                                                          text:
                                                              'Last Posting Date'),
                                                      getPoppinsTextSpanDetails(
                                                          text: getFormattedDate(
                                                              data.LastServiceDate)),
                                                    ],
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
                                                  left: 8.0,
                                                  right: 8.0,
                                                  top: 4.0),
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      getPoppinsTextSpanHeading(
                                                          text:
                                                              'Check List Status'),
                                                      getPoppinsTextSpanDetails(
                                                          text: data
                                                              .checkListStatus),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0,
                                                  right: 8.0,
                                                  top: 4.0),
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      getPoppinsTextSpanHeading(
                                                          text: 'Work Center'),
                                                      getPoppinsTextSpanDetails(
                                                          text: data
                                                              .workCenterName),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0,
                                                  right: 8.0,
                                                  top: 4.0),
                                              child: Align(
                                                alignment: Alignment.topLeft,
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
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (data.checkListStatus == 'Open') ...[
                                    getDivider(),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: InkWell(
                                          onTap: () async {

//                                             List<MNTTP1> mNTTP1s =
//                                                 await StaticFunctions
//                                                     .GetPairedEquipments(
//                                                         data.equipmentCode ??
//                                                             '');
//
//                                             List<String> equipmentCodes = [];
//                                             for (MNTTP1 mnttp1 in mNTTP1s) {
//                                               if (mnttp1.EquipmentCode !=
//                                                       null &&
//                                                   mnttp1.EquipmentCode != '') {
//                                                 equipmentCodes
//                                                     .add(mnttp1.EquipmentCode!);
//                                               }
//                                             }
//                                             equipmentCodes
//                                                 .add(data.equipmentCode!);
//
//                                             List<MNOWCM> mnocmList =
//                                                 await retrieveMNOWCMById(
//                                                     null,
//                                                     'Code = ?',
//                                                     [data.workCenterCode]);
//                                             String? wareHouseCode;
//                                             if (mnocmList.isNotEmpty) {
//                                               wareHouseCode =
//                                                   mnocmList[0].WhsCode;
//                                             }
//                                             String str = '';
//                                             for (int i = 0;
//                                                 i < equipmentCodes.length;
//                                                 i++) {
//                                               if (i ==
//                                                   equipmentCodes.length - 1) {
//                                                 str += "'${equipmentCodes[0]}'";
//                                               } else {
//                                                 str +=
//                                                     "'${equipmentCodes[0]}',";
//                                               }
//                                             }
//                                             print(str);
//                                             Database db =
//                                                 await initializeDB(null);
//                                             String query = '''
//                                             SELECT
//     ovcl.Code AS EquipmentCode,
//     mnclm1.ItemCode,
//     mnclm1.ItemName,
//     mnclm1.UOM,
//     mnclm1.CheckListDesc AS Description,
//     mnclm1.Remarks,
//     mnclm1.Attachment
// FROM OVCL ovcl
// JOIN MNOCLM mnoclm ON ovcl.EquipmentGroupCode = mnoclm.EquipmentGroupCode
// JOIN MNCLM1 mnclm1 ON mnoclm.Code = mnclm1.Code
// WHERE ovcl.Code IN ($str)
// AND mnoclm.CheckListCode ='${data.checkListCode}'
// AND mnoclm.Code = mnclm1.Code
//
//                                             ''';
//                                             List l = await db.rawQuery(query);
//                                             l.forEach((result) async {
//                                               result['AvailableQty'] =
//                                                   await StaticFunctions
//                                                       .GetAvailableItemsFromOINM(
//                                                           result.ItemCode,
//                                                           wareHouseCode ?? '');
//                                             });
                                          navigateToCheckListDocument(TransId: data.transId??'', isView: false);
                                          },
                                          child: getPoppinsText(
                                              text: 'Edit ${data.transId}',
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        )),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                          if (data.checkListStatus != 'Open')
                            Positioned(
                              top: -27,
                              right: -4,
                              child: InkWell(
                                onTap: () {
                                  setCheckListData(dashboardItem: data);
                                },
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Icon(
                                      Icons.add,
                                      color: barColor,
                                    ),
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
