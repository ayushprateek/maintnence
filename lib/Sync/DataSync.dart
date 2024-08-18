import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:maintenance/Component/CheckInternet.dart';
import 'package:maintenance/Component/CompanyDetails.dart';
import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/CustomFont.dart';
import 'package:maintenance/Component/GetCredentials.dart';
import 'package:maintenance/Component/GetCurrentLocation.dart';
import 'package:maintenance/Component/GetLiveLocation.dart';
import 'package:maintenance/Component/IsValidAppVersion.dart';
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/NotSyncDocument.dart';
import 'package:maintenance/Component/SendLocalNotification.dart';
import 'package:maintenance/Component/ShareDatabase.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/Component/UploadImageToServer.dart';
import 'package:maintenance/Dashboard.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/LoginPage.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/SyncModels/IMGDI1.dart';
import 'package:maintenance/Sync/SyncModels/IMOGDI.dart';
import 'package:maintenance/Sync/SyncModels/MNCLD1.dart';
import 'package:maintenance/Sync/SyncModels/MNCLD2.dart';
import 'package:maintenance/Sync/SyncModels/MNCLD3.dart';
import 'package:maintenance/Sync/SyncModels/MNJCD1.dart';
import 'package:maintenance/Sync/SyncModels/MNJCD2.dart';
import 'package:maintenance/Sync/SyncModels/MNJCD3.dart';
import 'package:maintenance/Sync/SyncModels/MNJCD5.dart';
import 'package:maintenance/Sync/SyncModels/MNJCD6.dart';
import 'package:maintenance/Sync/SyncModels/MNJCD7.dart';
import 'package:maintenance/Sync/SyncModels/MNOCLD.dart';
import 'package:maintenance/Sync/SyncModels/MNOJCD.dart';
import 'package:maintenance/Sync/SyncModels/OECLO.dart';
import 'package:maintenance/Sync/SyncModels/OUSR.dart';
import 'package:maintenance/Sync/SyncModels/PRITR1.dart';
import 'package:maintenance/Sync/SyncModels/PROITR.dart';
import 'package:maintenance/Sync/SyncModels/PROPDN.dart';
import 'package:maintenance/Sync/SyncModels/PROPOR.dart';
import 'package:maintenance/Sync/SyncModels/PROPRQ.dart';
import 'package:maintenance/Sync/SyncModels/PRPDN1.dart';
import 'package:maintenance/Sync/SyncModels/PRPDN2.dart';
import 'package:maintenance/Sync/SyncModels/PRPDN3.dart';
import 'package:maintenance/Sync/SyncModels/PRPOR1.dart';
import 'package:maintenance/Sync/SyncModels/PRPOR2.dart';
import 'package:maintenance/Sync/SyncModels/PRPOR3.dart';
import 'package:maintenance/Sync/SyncModels/PRPRQ1.dart';
import 'package:maintenance/Sync/SyncModels/SingleAPIs/Customer/Customer1.dart';
import 'package:maintenance/Sync/SyncModels/SingleAPIs/Customer/Customer2.dart';
import 'package:maintenance/Sync/SyncModels/SingleAPIs/Customer/CustomerTransaction1.dart';
import 'package:maintenance/Sync/SyncModels/SingleAPIs/Employee/GetAllMaster1.dart';
import 'package:maintenance/Sync/SyncModels/SingleAPIs/Employee/GetAllMaster2.dart';
import 'package:maintenance/Sync/SyncModels/SingleAPIs/Employee/Transaction1.dart';
import 'package:maintenance/Sync/SyncModels/SingleAPIs/Employee/Transaction2.dart';
import 'package:maintenance/main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class DataSync extends StatefulWidget {
  bool isComingFromLogin;
  static bool isSyncSuccessful = true;
  static String syncingErrorMsg = "Please wait while your data is being synced";

  static void setSyncing(bool isSyncing) {
    localStorage?.setBool("isSyncing", isSyncing);
  }

  static bool isSyncing() {
    bool isSyncing = localStorage?.getBool("isSyncing") ?? false;
    return false;
    // return isSyncing;
  }

  DataSync(
    String localPrefix, {
    required this.isComingFromLogin,
  }) {
    postfix = localPrefix;
  }

  static String getInsertToServerStr() {
    return 'has_created = ?';
  }

  static List getInsertToServerList() {
    return [1];
  }

  //---update
  static String getUpdateOnServerStr() {
    return 'has_updated = ? AND has_created <> ?';
  }

  static List getUpdateOnServerList() {
    return [1, 1];
  }

  @override
  _DataSyncState createState() => _DataSyncState();
}

class _DataSyncState extends State<DataSync> {
  String text = "Please wait while we are syncing your data";
  bool calledSyncFunc = false, isFirstTimeSync = false;
  final Connectivity _connectivity = Connectivity();

  // late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  int _totalSteps = 13, _currentStep = 0;

  dataSync(BuildContext context) async {
    setHeader();
    DataSync.setSyncing(true);
    DataSync.setSyncing(true);

    ///CheckList
    await insertMNOCLDToServer(null);
    await insertMNCLD1ToServer(null);
    await insertMNCLD2ToServer(null);
    await insertMNCLD3ToServer(null);
    setState(() {
      _currentStep = 1;
    });

    ///JobCard

    await insertMNOJCDToServer(null);
    await insertMNJCD1ToServer(null);
    await insertMNJCD2ToServer(null);
    await insertMNJCD3ToServer(null);
    await insertMNJCD5ToServer(null);
    await insertMNJCD6ToServer(null);
    await insertMNJCD7ToServer(null);
    // await insertMNJCD4ToServer(null);

    ///Goods Issue

    await insertIMOGDIToServer(null);
    await insertIMGDI1ToServer(null);

    ///Purchase request

    await insertPROPRQToServer(null);
    await insertPRPRQ1ToServer(null);

    ///Purchase order

    await insertPROPORToServer(null);
    await insertPRPOR1ToServer(null);
    await insertPRPOR2ToServer(null);
    await insertPRPOR3ToServer(null);

    setState(() {
      _currentStep = 2;
    });

    ///GRN
    await insertPROPDNToServer(null);
    await insertPRPDN1ToServer(null);
    await insertPRPDN2ToServer(null);
    await insertPRPDN3ToServer(null);
    setState(() {
      _currentStep = 3;
    });

    ///Internal request

    await insertPROITRToServer(null);
    await insertPRITR1ToServer(null);

    setState(() {
      _currentStep = 4;
    });
    // ----------------------UPDATE

    ///CheckList
    await updateMNOCLDOnServer(null);
    await updateMNCLD1OnServer(null);
    await updateMNCLD2OnServer(null);
    await updateMNCLD3OnServer(null);
    setState(() {
      _currentStep = 5;
    });

    ///JobCard

    await updateMNOJCDOnServer(null);
    await updateMNJCD1OnServer(null);
    await updateMNJCD2OnServer(null);
    await updateMNJCD3OnServer(null);
    await updateMNJCD5OnServer(null);
    await updateMNJCD6OnServer(null);
    await updateMNJCD7OnServer(null);
    // await updateMNJCD4OnServer(null);
    setState(() {
      _currentStep = 6;
    });

    ///Goods Issue

    await updateIMOGDIOnServer(null);
    await updateIMGDI1OnServer(null);

    ///Purchase request

    await updatePROPRQOnServer(null);
    await updatePRPRQ1OnServer(null);

    ///Purchase order

    await updatePROPOROnServer(null);
    await updatePRPOR1OnServer(null);
    await updatePRPOR2OnServer(null);
    await updatePRPOR3OnServer(null);

    setState(() {
      _currentStep = 7;
    });

    ///GRN
    await updatePROPDNOnServer(null);
    await updatePRPDN1OnServer(null);
    await updatePRPDN2OnServer(null);
    await updatePRPDN3OnServer(null);

    ///Internal request

    await updatePROITROnServer(null);
    await updatePRITR1OnServer(null);
    setState(() {
      _currentStep = 8;
    });
    // getSuccessSnackBar("Syncing your Data");
  }

  firstTimeSync(BuildContext context) async {
    bool? dbDeleted = localStorage?.getBool('db_deleted');
    if (dbDeleted == null) {
      await deleteDatabase();
      localStorage?.setBool('db_deleted', true);
    }
    DataSync.setSyncing(true);

    if (userModel.Type == 'Employee') {
      // GetAllMaster1.isFirstTimeSync = widget.isFirstTimeSync;
      // GetAllMaster2.isFirstTimeSync = widget.isFirstTimeSync;
      // Transaction1.isFirstTimeSync = widget.isFirstTimeSync;
      // Transaction2.isFirstTimeSync = widget.isFirstTimeSync;
      try {
        final stopwatch = Stopwatch()..start();

        GetAllMaster1 getAll = GetAllMaster1();
        await getAll.getGetAllMaster1FromWeb(isFirstTimeSync);
        setState(() {
          _currentStep = 9;
        });
        stopwatch.stop();
        Duration duration = stopwatch.elapsed;
        stopwatch.reset();

        print(
            'Function Execution Time GetAllMaster1 : ${duration.inMilliseconds}');
        stopwatch.start();
        GetAllMaster2 getAll2 = GetAllMaster2();
        await getAll2.getGetAllMaster2FromWeb(isFirstTimeSync);
        stopwatch.stop();
        duration = stopwatch.elapsed;
        print(
            'Function Execution Time GetAllMaster2 : ${duration.inMilliseconds}');

        // await getAll.getGetAllMaster1FromWeb(widget.isFirstTimeSync);
        stopwatch.reset();
        setState(() {
          _currentStep = 10;
        });
        // await Future.delayed(Duration(seconds: 5));
        stopwatch.start();
        Transaction1 transaction1 = Transaction1();
        await transaction1.getTransaction1FromWeb(isFirstTimeSync);
        stopwatch.stop();
        duration = stopwatch.elapsed;
        print(
            'Function Execution Time Transaction1 : ${duration.inMilliseconds}');

        // await getAll.getGetAllMaster1FromWeb(widget.isFirstTimeSync);
        stopwatch.reset();
        setState(() {
          _currentStep = 11;
        });
        // await Future.delayed(Duration(seconds: 5));
        stopwatch.start();
        Transaction2 transaction2 = Transaction2();
        await transaction2.getTransaction2FromWeb(isFirstTimeSync);
        setState(() {
          _currentStep = 12;
        });
        stopwatch.stop();
        duration = stopwatch.elapsed;
        print(
            'Function Execution Time Transaction2 : ${duration.inMilliseconds}');

        // await getAll.getGetAllMaster1FromWeb(widget.isFirstTimeSync);
        stopwatch.reset();
        await uploadLogFileToServer();
        // await sendEmail();
        setState(() {
          _currentStep = 13;
        });
        Timer(Duration(milliseconds: 500), () {
          CompanyDetails.loadCompanyDetails();
          setSyncDate(dateTime: DateTime.now());
          if (isFirstTimeSync) {
            setFirstTimeSyncDate(dateTime: DateTime.now());
          }
          DataSync.setSyncing(false);
          getApprovalListForNotification();
        });
      } catch (e) {
        print(e.toString());
        writeToLogFile(
            text: e.toString(),
            fileName: StackTrace.current.toString(),
            lineNo: 141);
        getErrorSnackBar('Data not sync');
      }
    } else if (userModel.Type == 'Customer') {
      if (isFirstTimeSync) {
        Customer1.isFirstTimeSync = isFirstTimeSync;
        Customer2.isFirstTimeSync = isFirstTimeSync;
        CustomerTransaction1.isFirstTimeSync = isFirstTimeSync;
      }
      try {
        Customer1 getAll = Customer1();
        await getAll.getCustomer1FromWeb(context);
        Customer2 getAll2 = Customer2();
        await getAll2.getCustomer2FromWeb(context);
        CustomerTransaction1 transaction1 = CustomerTransaction1();
        await transaction1.getCustomerTransaction1FromWeb(context);
        Timer(Duration(milliseconds: 500), () {
          CompanyDetails.loadCompanyDetails();
          setSyncDate(dateTime: DateTime.now());
          // localStorage?.setString("syncDate", DateTime.now().toIso8601String());
          DataSync.setSyncing(false);
          getApprovalListForNotification();
        });
      } catch (e) {
        writeToLogFile(
            text: e.toString(),
            fileName: StackTrace.current.toString(),
            lineNo: 141);
        // getErrorSnackBar(e.toString());
      }
    }
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      writeToLogFile(
          text: e.toString(),
          fileName: StackTrace.current.toString(),
          lineNo: 141);
      print(e.toString());
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.none:
        getSuccessSnackBar("Failed to get connectivity.");
        setState(() {
          text = "Please check your internet connection";
        });
        Connectivity()
            .onConnectivityChanged
            .listen((ConnectivityResult result) async {
          // Got a new connectivity status!
          try {
            result = await _connectivity.checkConnectivity();
          } on PlatformException {}
          if (!mounted) {
            return Future.value(null);
          }
          _updateConnectionStatus(result);
        });
        break;
      default:
        getErrorSnackBar("Data Sync Started");

        if (!calledSyncFunc) {
          calledSyncFunc = true;
          if (!isFirstTimeSync) {
            await dataSync(context);
            await firstTimeSync(context);
          } else {
            await firstTimeSync(context);
          }

          // try {
          //   await dataSync(context);
          // } catch (e) {
          //   // getErrorSnackBar(e.toString());
          //   log("eeaaae + ${e.toString()}");
          // }
        }
        await setRequiredData();
        await setRequiredData();

        int num = await retrieveNotSyncedDocument();
        if (num == 0 && (await isInternetAvailable())) {
          List<Widget> titleRowWidgets = [
            getHeadingText(
                text: 'Data sync completed', color: barColor, fontSize: 16),
            const SizedBox(
              width: 4,
            ),
            Icon(
              Icons.check_circle,
              color: Colors.green,
            )
          ];
          List<Widget> actions = [
            Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // if (!isShowNegative)
                    const Spacer(),

                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        if (widget.isComingFromLogin) {
                          LoginPage.hasSynced = true;
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Dashboard()),
                              (route) => false);
                        } else {
                          Navigator.pop(context);
                          await isValidAppVersion();
                        }
                      },
                      child: getHeadingText(
                        text: isFirstTimeSync ? 'Go to Dashboard' : 'Go Back',
                        color: barColor,
                      ),
                    ),
                  ],
                )),
          ];
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              if (Platform.isIOS) {
                return CupertinoAlertDialog(
                  title: Row(
                    children: titleRowWidgets,
                  ),
                  content: Text("Your syncing has been completed"),
                  actions: actions,
                );
              } else {
                return AlertDialog(
                  title: Row(
                    children: titleRowWidgets,
                  ),
                  content: Text("Your syncing has been completed"),
                  actions: actions,
                );
              }
            },
          );
        } else {
          setState(() {
            _currentStep = 0;
          });
          List<Widget> titleRowWidgets = [
            getHeadingText(
                text: 'Sync Not completed', color: Colors.red, fontSize: 16),
            const SizedBox(
              width: 4,
            ),
            Icon(
              Icons.error,
              color: Colors.red,
            )
          ];
          List<Widget> actions = [
            Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          if (widget.isComingFromLogin) {
                            LoginPage.hasSynced = true;
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Dashboard()),
                                (route) => false);
                          } else {
                            Navigator.pop(context);
                            await isValidAppVersion();
                          }
                        },
                        child: getHeadingText(
                          text: isFirstTimeSync ? 'Go to Dashboard' : 'Go Back',
                          color: barColor,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Get.to(() => ShareDatabase());
                        },
                        child: getHeadingText(
                          text: 'Share Info',
                          color: barColor,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          calledSyncFunc = false;
                          Navigator.pop(context);
                          initConnectivity();
                        },
                        child: getHeadingText(
                          text: 'Re sync',
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                )),
          ];
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              if (Platform.isIOS) {
                return CupertinoAlertDialog(
                  title: Row(
                    children: titleRowWidgets,
                  ),
                  content: Text("$num record(s) not synced with server"),
                  actions: actions,
                );
              } else {
                return AlertDialog(
                  title: Row(
                    children: titleRowWidgets,
                  ),
                  content: Row(
                    children: [
                      Text("$num ",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 22,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.red,
                              fontWeight: FontWeight.bold)),
                      Text("record(s) not synced with server"),
                    ],
                  ),
                  actions: actions,
                );
              }
            },
          );
        }
        getSuccessSnackBar("Data Sync Completed");
      // if (DataSync.isSyncSuccessful) {
      //   if (widget.isComingFromLogin) {
      //     LoginPage.hasSynced = true;
      //     Navigator.pushAndRemoveUntil(
      //         context,
      //         MaterialPageRoute(builder: (context) => Dashboard()),
      //         (route) => false);
      //   } else {
      //     await isValidAppVersion();
      //     // if(isAppVersionValid!=RxBool(true)){
      //     //   Get.offAll(() => LoginPage());
      //     //   // showUpdateAppAlertDialog();
      //     //   return;
      //     // }
      //     Navigator.pop(context);
      //   }
      // }
      // else {
      //   getErrorSnackBar("Data Sync could not Complete");
      //
      //   setState(() {
      //     _currentStep = 0;
      //   });
      // }
    }
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 500), () {
      checkSync();
    });
  }

  checkSync() async {
    DateTime? dateTime = getFirstTimeDataSyncDate();
    isFirstTimeSync = dateTime == null;
    print(isFirstTimeSync);
    if (isFirstTimeSync) {
      await deleteDatabase();
      setFirstTimeSyncDate(dateTime: null);
    }
    Timer(Duration(milliseconds: 500), () {
      // _connectivitySubscription =
      //     _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
      initConnectivity();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: barColor,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Data Sync",
          style: TextStyle(fontFamily: custom_font, color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StepProgressIndicator(
              totalSteps: _totalSteps,
              currentStep: _currentStep,
              selectedColor: Colors.red,
              unselectedColor: Colors.yellow,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                DataSync.isSyncSuccessful
                    ? text
                    : 'Data could not sync, please try again',
                style: TextStyle(
                    fontFamily: custom_font,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),
            ),
            if (!DataSync.isSyncSuccessful) ...[
              const SizedBox(
                height: 20,
              ),
              Material(
                borderRadius: BorderRadius.circular(20),
                child: MaterialButton(
                  color: barColor,
                  child: Text(
                    "Retry",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    setState(() {
                      DataSync.isSyncSuccessful = true;
                    });
                    calledSyncFunc = false;
                    Timer(Duration(seconds: 2), () {
                      initConnectivity();
                    });
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

dataSyncBackground(BuildContext? context) async {
  //todo: background sync
}
// dataSyncBackground(BuildContext? context) async {
//   print("Syncing in background");
//   setHeader();
//   DataSync.setSyncing(true);
//
//   // retrieveACT1(context).then((value) {
//   //   value.forEach((element) {
//   //     print(element);
//   //   });
//   // });
//
//   //----------------------INSERT
//
//   await insertACT1ToServer(context);
//   await insertACT2ToServer(context);
//   await insertACT3ToServer(context);
//   //todo:
//   //insertCRD1ToServer(context);
//   //todo:
//   //insertCRD2ToServer(context);
//   //todo:
//   //insertCRD3ToServer(context);
//   //todo:
//   //insertCRDDToServer(context);
//   // await insertDLN1ToServer(context);
//   // await insertDLN2ToServer(context);
//   // await insertDLN3ToServer(context);
//   //todo:
//   //insertDOC1ToServer(context);
//   //todo:
//   //insertDOCNToServer(context);
//   await insertDSC1ToServer(context);
//   await insertDSC2ToServer(context);
//   //todo:
//   //insertEMPDToServer(context);
//   await insertEXR1ToServer(context);
//   await insertINV1ToServer(context);
//   await insertINV2ToServer(context);
//   await insertINV3ToServer(context);
//   await insertOACTToServer(context);
//   await insertDPT1ToServer(context);
//   //todo:
//   //insertOAMRToServer(context);
//   //todo:
//   //insertOBDTToServer(context);
//   //todo:
//   //insertOBRNToServer(context);
//   //todo:
//   //insertOCCTToServer(context);
//   //todo:
//   //insertOECLOToServer(context);
//   //todo:
//   // insertOCINToServer(context);
//   //todo:
//   //insertOCRDToServer(context);
//   //todo:
//   //insertOCRNToServer(context);
//   await insertOCRTToServer(context);
//   await insertCRT1ToServer(context);
//   //todo:
//   //insertOCRYToServer(context);
//   await insertOCSHToServer(context);
//   //todo:
//   //insertOCSTToServer(context);
//   await insertODLNToServer(context);
//   await insertDLN1ToServer(context);
//   await insertDLN2ToServer(context);
//   await insertDLN3ToServer(context);
//   //todo:
//   //insertODOCToServer(context);
//   await insertODPTToServer(context);
//   await insertODSCToServer(context);
//   await insertOECPToServer(context);
//   await insertECP1ToServer(context);
//   //todo:
//   //insertOEMGToServer(context);
//   //todo:
//   //insertOEMPToServer(context);
//   //todo:
//   //insertOEMRToServer(context);
//   //todo:
//   //insertOEMSToServer(context);
//   await insertOEXRToServer(context);
//   //todo:
//   //insertOFTYToServer(context);
//   //todo:
//   //insertOGRAToServer(context);
//   //todo:
//   //insertOHPSToServer(context);
//   await insertOINVToServer(context);
//   //todo:
//   //insertOITMToServer(context);
//   //todo:
//   //insertOLEVToServer(context);
//   //todo:
//   //insertOMNUToServer(context);
//   //todo:
//   //insertOMSPToServer(context);
//   //todo:
//   //insertOPTRToServer(context);
//   //todo:
//   //insertOQEMToServer(context);
//   await insertOQUTToServer(context);
//   await insertORDRToServer(context);
//   //todo:
//   //insertOROLToServer(context);
//   // await insertORTNToServer(context);
//   // await insertORTPToServer(context);
//   //todo:
//   //insertORTTToServer(context);
//   //todo:
//   //insertORTUToServer(context);
//   //todo:
//   //insertOTAXToServer(context);
//   //todo:
//   //insertOUDPToServer(context);
//   //todo:
//   //insertOUSRToServer(context);
//   //todo:
//   //insertOVCLToServer(context);
//   // await insertOVLDToServer(context);
//   //todo:
//   //insertOXPMToServer(context);
//   //todo:
//   //insertOXPTToServer(context);
//   await insertQUT1ToServer(context);
//   await insertQUT2ToServer(context);
//   await insertQUT3ToServer(context);
//   await insertRDR1ToServer(context);
//   await insertRDR2ToServer(context);
//   await insertRDR3ToServer(context);
//   //todo:
//   //insertROUTToServer(context);
//   // await insertRTN1ToServer(context);
//   // await insertRTN2ToServer(context);
//   // await insertRTN3ToServer(context);
//   // await insertRTP1ToServer(context);
//   // await insertRTP2ToServer(context);
//   //todo:
//   //insertVCL1ToServer(context);
//   //todo:
//   //insertVCL2ToServer(context);
//   //todo:
//   //insertVCLDToServer(context);
//   // await insertVLD1ToServer(context);
//   // todo:
//   // insertXPM1ToServer(context);
//
//   // ----------------------UPDATE
//
//   await updateACT1OnServer(context);
//   await updateACT2OnServer(context);
//   await updateACT3OnServer(context);
//   //todo:
//   //updateCRD1OnServer(context);
//   //todo:
//   //updateCRD2OnServer(context);
//   //todo:
//   //updateCRD3OnServer(context);
//   //todo:
//   //updateCRDDOnServer(context);
//   await updateDLN1OnServer(context);
//   await updateDLN2OnServer(context);
//   await updateDLN3OnServer(context);
//   //todo:
//   //updateDOC1OnServer(context);
//   //todo:
//   //updateDOCNOnServer(context);
//   await updateDSC1OnServer(context);
//   await updateDSC2OnServer(context);
//   //todo:
//   //updateEMPDOnServer(context);
//   await updateEXR1OnServer(context);
//   await updateINV1OnServer(context);
//   await updateINV2OnServer(context);
//   await updateINV3OnServer(context);
//   await updateOACTOnServer(context);
//   await updateDPT1OnServer(context);
//   //todo:
//   //updateOAMROnServer(context);
//   //todo:
//   //updateOBDTOnServer(context);
//   //todo:
//   //updateOBRNOnServer(context);
//   //todo:
//   //updateOCCTOnServer(context);
//   //todo:
//   //updateOECLOOnServer(context);
//   //todo:
//   //updateOCINOnServer(context);
//   //todo:
//   //updateOCRDOnServer(context);
//   //todo:
//   //updateOCRNOnServer(context);
//   await updateOCRTOnServer(context);
//   await updateCRT1OnServer(context);
//   //todo:
//   //updateOCRYOnServer(context);
//   await updateOCSHOnServer(context);
//   //todo:
//   //updateOCSTOnServer(context);
//   await updateODLNOnServer(context);
//   //todo:
//   //updateODOCOnServer(context);
//   await updateODPTOnServer(context);
//   await updateODSCOnServer(context);
//   //todo:
//   await updateOECPOnServer(context);
//   await updateECP1OnServer(context);
//   //todo:
//   //updateOEMGOnServer(context);
//   //todo:
//   //updateOEMPOnServer(context);
//   //todo:
//   //updateOEMROnServer(context);
//   //todo:
//   //updateOEMSOnServer(context);
//   await updateOEXROnServer(context);
//   //todo:
//   //updateOFTYOnServer(context);
//   //todo:
//   //updateOGRAOnServer(context);
//   //todo:
//   //updateOHPSOnServer(context);
//   //todo:
//   //updateOINVOnServer(context);
//   //TODO:
//   //updateOITMOnServer(context);
//   //todo:
//   //updateOLEVOnServer(context);
//   //todo:
//   //updateOMNUOnServer(context);
//   //todo:
//   //updateOMSPOnServer(context);
//   //todo:
//   //updateOPTROnServer(context);
//   //todo:
//   //updateOQEMOnServer(context);
//   await updateOQUTOnServer(context);
//   await updateORDROnServer(context);
//   //todo:
//   //updateOROLOnServer(context);
//   await updateORTNOnServer(context);
//   await updateORTPOnServer(context);
//   //todo:
//   //updateORTTOnServer(context);
//   //todo:
//   //updateORTUOnServer(context);
//   //todo:
//   //updateOTAXOnServer(context);
//   //todo:
//   //updateOUDPOnServer(context);
//   //todo:
//   //updateOUSROnServer(context);
//   //todo:
//   //updateOVCLOnServer(context);
//   await updateOVLDOnServer(context);
//   //todo:
//   //updateOXPMOnServer(context);
//   //todo:
//   //updateOXPTOnServer(context);
//   await updateQUT1OnServer(context);
//   await updateQUT2OnServer(context);
//   await updateQUT3OnServer(context);
//   await updateRDR1OnServer(context);
//   await updateRDR2OnServer(context);
//   await updateRDR3OnServer(context);
//   //todo:
//   //updateROUTOnServer(context);
//   await updateRTN1OnServer(context);
//   await updateRTN2OnServer(context);
//   await updateRTN3OnServer(context);
//   await updateRTP1OnServer(context);
//   await updateRTP2OnServer(context);
//   //todo:
//   //OnServer(context);
//   //todo:
//   //updateVCL2OnServer(context);
//   //todo:
//   //updateVCLDOnServer(context);
//   await updateVLD1OnServer(context);
//   //todo:
//   //updateXPM1OnServer(context);
//
//   // getSuccessSnackBar("Syncing your Data");
//
//   //-------------------------------------
//   // await insertACT1(db);
//   // await insertACT2(db);
//   // await insertCRD1(db);
//   // await insertCRD2(db);
//   // await insertCRD3(db);
//   // await insertCRDD(db);
//   // await insertDLN1(db);
//   // await insertDLN2(db);
//   // await insertDLN3(db);
//   // await insertDOC1(db);
//   // await insertDOCN(db);
//   // await insertDSC1(db);
//   // await insertDSC2(db);
//   // await insertEMPD(db);
//   // await insertEXR1(db);
//   // await insertINV1(db);
//   // await insertINV2(db);
//   // await insertINV3(db);
//   // // await insertMAPS(db);
//   //
//   // await insertOACT(db);
//   // await insertOAMR(db);
//   // await insertOAPRV(db);
//   // await insertOBDT(db);
//   // await insertOBRN(db);
//   // await insertOCCT(db);
//   // // await insertOECLO(db);
//   // await insertOCIN(db);
//   // await insertDPT1(db);
//   // await insertOCRD(db);
//   // await insertOCRN(db);
//   // await insertOCRT(db);
//   // await insertOCRY(db);
//   // await insertOCSH(db);
//   // await insertOCST(db);
//   // await insertODLN(db);
//   // await insertODOC(db);
//   // await insertODPT(db);
//   // await insertODSC(db);
//   // await insertOECP(db);
//   // await insertOEMG(db);
//   // await insertOEMP(db);
//   // await insertOEMR(db);
//   // await insertOEMS(db);
//   // await insertOEXR(db);
//   // await insertOFTY(db);
//   // await insertOGRA(db);
//   // await insertOHPS(db);
//   // await insertOINV(db);
//   // await insertOITM(db);
//   // await insertOLEV(db);
//   // await insertOMNU(db);
//   // await insertOMSP(db);
//   // await insertOPTR(db);
//   // await insertOQEM(db);
//   // await insertOQUT(db);
//   // await insertORDR(db);
//   // await insertOROL(db);
//   // await insertORTN(db);
//   // await insertORTP(db);
//   // await insertORTU(db);
//   // await insertOTAX(db);
//   // await insertOUDP(db);
//   // await insertOUSR(db);
//   // await insertOVCL(db);
//   // await insertOVLD(db);
//   // await insertOXPM(db);
//   // await insertOXPT(db);
//   // await insertQUT1(db);
//   // await insertQUT2(db);
//   // await insertQUT3(db);
//   // await insertRDR1(db);
//   // await insertRDR2(db);
//   // await insertRDR3(db);
//   // await insertROUT(db);
//   // await insertRTN1(db);
//   // await insertRTN2(db);
//   // await insertRTN3(db);
//   // await insertRTP1(db);
//   // await insertRTP2(db);
//   // await insertVCL1(db);
//   // await insertVCL2(db);
//   // await insertVCLD(db);
//   // await insertVLD1(db);
//   // await insertXPM1(db);
//   // await insertORTT(db);
//   // await insertDGLMAPPING(db);
//
//   Timer(Duration(milliseconds: 500), () {
//     // localStorage.setInt("TIME", 0);
//     // autoSyncTimer();
//     // localStorage.setInt("syncDay", DateTime.now().day);
//     setSyncDate(dateTime: DateTime.now());
//     // localStorage?.setString("syncDate", DateTime.now().toIso8601String());
//     getApprovalListForNotification();
//   });
// }

firstTimeSyncBackground() async {
  print("Syncing in backgroung");
  DataSync.setSyncing(true);
  // GetAllMaster1.isFirstTimeSync = false;
  // GetAllMaster2.isFirstTimeSync = false;
  // Transaction1.isFirstTimeSync = false;
  postfix = "GetData";
  try {
    GetAllMaster1 getAll = GetAllMaster1();
    await getAll.getGetAllMaster1FromWeb(false);
    GetAllMaster2 getAll2 = GetAllMaster2();
    await getAll2.getGetAllMaster2FromWeb(false);
    Transaction1 transaction1 = Transaction1();
    await transaction1.getTransaction1FromWeb(false);
    Transaction2 transaction2 = Transaction2();
    await transaction2.getTransaction2FromWeb(false);
    Timer(Duration(milliseconds: 500), () {
      CompanyDetails.loadCompanyDetails();
      setSyncDate(dateTime: DateTime.now());
      // localStorage?.setString("syncDate", DateTime.now().toIso8601String());
      DataSync.setSyncing(false);
      getApprovalListForNotification();
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    // getErrorSnackBar(e.toString());
  }
}

Future<void> updateLocationInBackground() async {
  String user = localStorage?.getString('user') ?? '';
  userModel = OUSRModel.fromJson(jsonDecode(user));
  String userCode = userModel.UserCode;
  if (!(await Permission.locationAlways.isGranted ||
      await Permission.location.isGranted ||
      await Permission.locationWhenInUse.isGranted)) {
    return;
  }

  
  Database db = await initializeDB(null);
  OECLOModel oecloModel = OECLOModel(
      ID: 0,
      UserCode: userCode,
      CreateDate: DateTime.now(),
      // Time: DateTime.now(),
      Latitude: CustomLiveLocation.currentLocation?.latitude.toString()??'',
      Longitude: CustomLiveLocation.currentLocation?.longitude.toString()??'',
      UpdateDate: DateTime.now(),
      CreatedBy: userModel.UserCode,
      BranchId: userModel.BranchId.toString(),
      IsSync: false,
      hasCreated: true);
  await db.insert('OECLO', oecloModel.toJson());
  await insertOECLOToServer(null);
}
