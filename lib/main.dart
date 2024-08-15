import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:floating_overlay/floating_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/AppConfig.dart';
import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/GetCredentials.dart';
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Dashboard.dart';
import 'package:maintenance/LoginPage.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:maintenance/Sync/SyncModels/ACT1.dart';
import 'package:maintenance/Sync/SyncModels/OCIN.dart';
import 'package:maintenance/Sync/SyncModels/OCINMetaData.dart';
import 'package:maintenance/Sync/SyncModels/OUSR.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

// GoRouter _appRoute = GoRouter(routes: <RouteBase>[
//   GoRoute(
//     path: "/",
//     builder: (BuildContext context, GoRouterState state) {
//       return  LoginPage();
//     },
//   ),
//   GoRoute(
//     path: "/dashboard",
//     builder: (BuildContext context, GoRouterState state) {
//       return  Dashboard();
//     },
//   ),
//
// ]);

// class SampleBind extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut<IssueController>(() => IssueController());
//   }
// }

GlobalKey globalKey = GlobalKey();
// class NavigationService {
//   static GlobalKey<NavigatorState> navigatorKey =
//   GlobalKey<NavigatorState>();
// }

// OverlayEntry? entry;
// Offset offset = Offset(20, 40);
Timer? rootTimer;

// var controller = FloatingOverlayController.absoluteSize(
//   maxSize: const Size(200, 200),
//   minSize: const Size(100, 100),
//   padding: const EdgeInsets.all(20.0),
//   constrained: true,
// );
var imagesController = FloatingOverlayController.absoluteSize(
    maxSize: Size(Get.width, 170),
    minSize: Size(Get.width / 1.3, 150),
    padding: const EdgeInsets.all(20.0),
    constrained: true,
    start: Offset(Get.width - 20, Get.height)
    // start: Offset(0, 0)
    );
OUSRModel userModel = OUSRModel(
    CreateDate: DateTime.now(),
    MUser: true,
    Type: "",
    CreatedBy: "",
    IsPrice: false,
    UpdateDate: DateTime.parse("1900-01-01"),
    ID: 0,
    UserCode: "",
    Name: "",
    EmpId: '',
    EmpName: "",
    Email: "",
    MobileNo: "",
    BranchId: 0,
    BranchName: "",
    DeptId: 0,
    DeptCode: "",
    DeptName: "",
    Password: "",
    Active: false,
    RoleId: 0,
    RoleShortDesc: "",
    CardCode: "",
    CardName: "",
    MAC: "");

Future<void> setRequiredData() async {
  // String MAC = await getMACAddress();
  // Mode.loadFormVisibility();
  // Mode.loadModuleVisibility();
  // Approval.oaprvList.clear();
  // Approval.loadApproval(context);

  //todo: mobile user
  // if(!snapshot[i].muser)
  //   {
  //     Fluttertoast.showToast(msg: "User is not authorize to use mobile");
  //   }
  // if(MAC!=snapshot[i].mac)
  //   {
  //     Fluttertoast.showToast(msg: "Invalid Device");
  //   }
  // else
  //   {
  //     userModel=snapshot[i];
  //     Mode.ortuList.clear();
  //     Mode.loadModuleVisibility(context);
  //     Approval.oaprvList.clear();
  //     Approval.loadApproval(context);
  //     userExists=true;
  //     break;
  //   }
  await setCurrency();
}

int? MobSessionTimoutMinute;
int? MobSyncTimeMinute;
SharedPreferences? localStorage;

@pragma(
//     'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     await initializeSharedPref();
//     await dataSyncBackground(null);
//     await firstTimeSyncBackground(null);
//     return Future.value(true);
//   });
// }
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case Workmanager.iOSBackgroundTask:
        stderr.writeln("The iOS background fetch was triggered");
        break;
      case "SyncingInBackground":
        await initializeSharedPref();
        await dataSyncBackground(null);
        await firstTimeSyncBackground();
        return Future.value(true);
      case "SyncingDataInBackground":
        await updateLocationInBackground();
        return Future.value(true);
    }
    return Future.value(true);
  });
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  try {
    localStorage = await SharedPreferences.getInstance();
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    print(e.toString());
  }

  DateTime? syncDate = getDataSyncDate();
  if (syncDate == null) {
    // String credentials = 'Admin:MSL@DK@2022';
    // Codec<String, String> stringToBase64 = utf8.fuse(base64);
    // String encoded = stringToBase64.encode(credentials+secretKey);
    // Map<String, String>? header = {
    //   'Authorization': 'Basic $encoded',
    //   "content-type": "application/json",
    //   "connection": "keep-alive"
    // };
    // print(header);
    var response = await http.get(
      Uri.parse(
        prefix + 'ocin/metadata',
      ),
    );
    print(response.body);
    OCINMetaDataModel ocinMetaDataModel =
        OCINMetaDataModel.fromJson(jsonDecode(response.body));
    List<OCINMetaDataModel> list = [ocinMetaDataModel];
    if (list.isNotEmpty) {
      OCINMetaDataModel ocinModel = list[0];
      appName = ocinModel.CompanyName ?? appName;
      print(ocinModel.toJson());
      MobSessionTimoutMinute = ocinModel.MobSessionTimoutMinute;
      MobSyncTimeMinute = ocinModel.MobSyncTimeMinute;
    }
  } else {
    List<OCINModel> list = await retrieveOCIN(null);
    if (list.isNotEmpty) {
      OCINModel ocinModel = list[0];
      appName = ocinModel.CompanyName ?? appName;
      print(ocinModel.toJson());
      MobSessionTimoutMinute = ocinModel.MobSessionTimoutMinute;
      MobSyncTimeMinute = ocinModel.MobSyncTimeMinute;
    }
  }
  // #################

  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false,
  );

  // assign workmanager
  // Periodic task registration for background sync
  if (Platform.isIOS) {
    // TODO: THE BACKGROUND PROCESSING WILL WORK ON REAL DEVICE ONLY AND NOT ON SIMULATOR
    // Workmanager().registerOneOffTask(
    //   "periodic-task-identifier",
    //   "SyncingInBackground",
    //   backoffPolicyDelay: Duration(minutes: MobSyncTimeMinute ?? 45),
    //   initialDelay: Duration(minutes: 15),
    //   constraints: Constraints(
    //     // connected or metered mark the task as requiring internet
    //     networkType: NetworkType.connected,
    //
    //     // this will run work manager only if device is idle
    //     requiresDeviceIdle: false,
    //   ),
    // );

    // Periodic task registration for location getting
    // Workmanager().registerOneOffTask(
    //   "periodic-task-identifier2",
    //   "SyncingDataInBackground",
    //   backoffPolicyDelay: Duration(minutes: 15),
    //   initialDelay: Duration(minutes: 15),
    // );
  } else if (Platform.isAndroid) {
    Workmanager().registerPeriodicTask(
      "periodic-task-identifier",
      "SyncingInBackground",
      frequency: Duration(minutes: MobSyncTimeMinute ?? 45),
      initialDelay: Duration(minutes: 15),
      constraints: Constraints(
        // connected or metered mark the task as requiring internet
        networkType: NetworkType.connected,

        // this will run work manager only if device is idle
        requiresDeviceIdle: false,
      ),
    );

    // Periodic task registration for location getting
    Workmanager().registerPeriodicTask(
      "periodic-task-identifier2",
      "SyncingDataInBackground",
      frequency: Duration(minutes: 15),
      initialDelay: Duration(minutes: 15),
    );
  }

  // ##################
  //rgba(88, 115, 254, 0.04);
  Map<int, Color> color = {
    50: Color.fromRGBO(0, 55, 119, .1),
    100: Color.fromRGBO(0, 55, 119, .2),
    200: Color.fromRGBO(0, 55, 119, .3),
    300: Color.fromRGBO(0, 55, 119, .4),
    400: Color.fromRGBO(0, 55, 119, .5),
    500: Color.fromRGBO(0, 55, 119, .6),
    600: Color.fromRGBO(0, 55, 119, .7),
    700: Color.fromRGBO(0, 55, 119, .8),
    800: Color.fromRGBO(0, 55, 119, .9),
    900: Color.fromRGBO(0, 55, 119, 1),
  };
  MaterialColor colorCustom = MaterialColor(0xFF5b84b1, color);
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = new MyHttpOverrides();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  final routeObserver = RouteObserver();
  //todo:
  // Get.lazyPut(() => IssueController());
  if (Platform.isIOS) {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    String? payload =
        notificationAppLaunchDetails?.notificationResponse?.payload ?? '';
    print(payload);
  } else if (Platform.isAndroid) {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    final bool? granted = await androidImplementation?.requestPermission();
    print(granted);
  }
  // runApp(MaterialApp.router(
  //   routerConfig: _appRoute,
  // ));

  runApp(
    RepaintBoundary(
      key: globalKey,
      child: SizedBox.expand(
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          // navigatorKey:globalKey,
          navigatorObservers: [routeObserver],
          theme: ThemeData(
              primarySwatch: colorCustom,
              hintColor: barColor,
              appBarTheme: AppBarTheme(
                  backgroundColor: barColor,
                  iconTheme: IconThemeData(
                    color: Colors.white,
                  ),
                  titleTextStyle: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )),
              buttonTheme: ButtonThemeData(
                buttonColor: barColor,
              ),
              iconTheme: IconThemeData(
                color: Colors.white,
              )),

          home: Provider<RouteObserver>(
            create: (_) => routeObserver,
            child: MyApp(),
          ),
        ),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final key = GlobalKey<ScaffoldState>();

  // ScreenshotController screenshotController = ScreenshotController();
  @override
  void initState() {
    navigate();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void navigate() async {
    // if(!(await isValidAppVersion())){
    //   showUpdateAppAlertDialog();
    //   return;
    // }
    DateTime? loginTime = getLogInTime();
    DateTime currentTime = DateTime.now();
    if (loginTime != null) {
      print(currentTime.difference(loginTime).inMinutes);
    }
    if (loginTime == null ||
        currentTime.difference(loginTime).inMinutes >
            (MobSessionTimoutMinute ?? 45)) {
      // setCredentials(credentials: '');
      Timer(
          Duration(milliseconds: 500),
          () => Navigator.pushReplacement(context,
              new MaterialPageRoute(builder: (context) => new LoginPage())));
    } else {
      String user = localStorage?.getString('user') ?? '';
      userModel = OUSRModel.fromJson(jsonDecode(user));
      List<OUSRModel> ousrList =
          await retrieveOUSRById(null, 'UserCode = ?', [userModel.UserCode]);
      if (ousrList.isNotEmpty) {
        userModel = ousrList[0];
      }
      Timer(
          Duration(milliseconds: 500),
          () => Navigator.pushReplacement(context,
              new MaterialPageRoute(builder: (context) => new Dashboard())));
    }
    // if (userModel.UserCode.isNotEmpty) {
    //   Timer(Duration(milliseconds: 500), () async {
    //     // List user=await retrieveLoginData(userModel.Code,context);
    //     // List<OUSRModel> user = await retrieveOUSRById(context, "Code = ?", [userModel.Code]);
    //     // userModel = user[0];
    //     // userModel.Code=user[0].Code;
    //     // userModel.ID=user[0].ID;
    //     // userModel.Name=user[0].Name;
    //     // userModel.Password=user[0].Password;
    //     // Navigator.pushReplacement(
    //     //   context,
    //     //   new MaterialPageRoute(builder: (context) => Dashboard()),
    //     // );
    //   });
    // } else {
    //   Timer(
    //       Duration(milliseconds: 500),
    //       () => Navigator.pushReplacement(context,
    //           new MaterialPageRoute(builder: (context) => new LoginPage())));
    // }
  }

  //todo:
  // final issueController = Get.put(IssueController());

  @override
  Widget build(BuildContext context) {
    final routeObserver = Provider.of<RouteObserver>(context, listen: false);
    return Scaffold(
      key: key,
      backgroundColor: Colors.white,
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.asset(
                  logoPath,
                  // height: MediaQuery.of(context).size.height,
                  // width: MediaQuery.of(context).size.width,
                ),
              ),
            ),
            SpinKitRipple(
              color: backColor,
            )
          ]),
      //todo: bottomNavigationBar
      // bottomNavigationBar: FloatingOverlay(
      //   routeObserver: routeObserver,
      //   controller: imagesController,
      //   floatingChild: SizedBox(
      //     height: MediaQuery.of(context).size.height / 8,
      //     child: Column(
      //       children: [
      //         Expanded(
      //             child: Obx(() => Container(
      //                   color: Colors.transparent,
      //                   height: Get.height / 10,
      //                   width: Get.width,
      //                   child: ListView.builder(
      //                       itemCount: issueController.issueList.length + 1,
      //                       physics: const ScrollPhysics(),
      //                       scrollDirection: Axis.horizontal,
      //                       reverse: true,
      //                       shrinkWrap: true,
      //                       itemBuilder: (_, index) {
      //                         index -= 1;
      //                         if (index == -1) {
      //                           return Column(
      //                             crossAxisAlignment: CrossAxisAlignment.end,
      //                             children: [
      //                               Expanded(
      //                                   child: Padding(
      //                                 padding: const EdgeInsets.all(4.0),
      //                                 child: ElevatedButton(
      //                                   onPressed: () async {
      //                                     //todo:
      //                                     // if (issueController
      //                                     //     .issueList.isEmpty) {
      //                                     //   getErrorSnackBar(
      //                                     //       'Please add some screenshots');
      //                                     // }
      //                                     // else {
      //                                     //   await clearIssueRaisedData();
      //                                     //   getLastDocNum("IR", context)
      //                                     //       .then((snapshot) async {
      //                                     //     int DocNum =
      //                                     //         snapshot[0].DocNumber - 1;
      //                                     //     do {
      //                                     //       DocNum += 1;
      //                                     //       IssueRaise.suoisu?.TicketCode =
      //                                     //           DateTime.now().millisecondsSinceEpoch.toString()+"U0" +
      //                                     //               userModel.ID
      //                                     //                   .toString() +
      //                                     //               "_" +
      //                                     //               snapshot[0].DocName +
      //                                     //               "/" +
      //                                     //               DocNum.toString();
      //                                     //     } while (
      //                                     //         await isIRTransIdAvailable(
      //                                     //             context,
      //                                     //             IssueRaise.suoisu
      //                                     //                     ?.TicketCode ??
      //                                     //                 ""));
      //                                     //
      //                                     //     // updateDocNum(snapshot[0].ID, val, context);
      //                                     //
      //                                     //     Get.to(() => SupportTicket(0));
      //                                     //   });
      //                                     // }
      //                                   },
      //                                   child: Text('Done'),
      //                                   style: ButtonStyle(
      //                                     backgroundColor:
      //                                         MaterialStateProperty.all(
      //                                             Colors.red),
      //                                   ),
      //                                 ),
      //                               )),
      //                               Expanded(
      //                                   child: Padding(
      //                                 padding: const EdgeInsets.all(4.0),
      //                                 child: ElevatedButton(
      //                                   onPressed: () async {
      //                                     // await screenshotController.capture(delay: const Duration(milliseconds: 10)).then((image) async {
      //                                     //   if (image != null) {
      //                                     //     final directory = await getApplicationDocumentsDirectory();
      //                                     //     final imagePath = await File('${directory.path}/image.png').create();
      //                                     //     print(imagePath);
      //                                     //     SalesQuotationUI.screenshots.add(imagePath.path);
      //                                     //     // await imagePath.writeAsBytes(image);
      //                                     //     getSuccessSnackBar('SS Captured');
      //                                     //   }
      //                                     //   else
      //                                     //     {
      //                                     //       getSuccessSnackBar('SS Not Captured');
      //                                     //     }
      //                                     // });
      //                                     print(globalKey.currentContext);
      //                                     String? path =
      //                                         await captureScreenshot(
      //                                             context:
      //                                                 globalKey.currentContext);
      //                                     if (path != '' && path != null) {
      //                                       Future.delayed(Duration(seconds: 1),
      //                                           () {
      //                                         SalesQuotationUI.screenshots
      //                                             .add(path);
      //                                         SUISU1 suisu1 = SUISU1(
      //                                           Attachment: path,
      //                                         );
      //                                         issueController.issueList
      //                                             .add(suisu1);
      //
      //                                         // if(issueController.issueList.length==1)
      //                                         //   {
      //                                         //     imagesController.toggle();
      //                                         //   }
      //                                         getSuccessSnackBar('SS Captured');
      //                                       });
      //                                     } else {
      //                                       getSuccessSnackBar(
      //                                           'SS Not Captured');
      //                                     }
      //                                   },
      //                                   child: Text('Take SS'),
      //                                 ),
      //                               )),
      //                             ],
      //                           );
      //                         }
      //                         return Padding(
      //                           padding:
      //                               const EdgeInsets.symmetric(horizontal: 4.0),
      //                           child: Material(
      //                             child: InkWell(
      //                               onTap: () {
      //                                 // showCapturedImage(
      //                                 //     context, issueController.issueList[index].Attachment??'');
      //                                 Get.to(() => DisplaySS(
      //                                     path: issueController.issueList[index]
      //                                             .Attachment ??
      //                                         ''));
      //                               },
      //                               child: Container(
      //                                 decoration: BoxDecoration(
      //                                     border: Border.all(),
      //                                     color: Colors.transparent),
      //                                 child: Image.file(File(issueController
      //                                         .issueList[index].Attachment ??
      //                                     '')),
      //                               ),
      //                             ),
      //                           ),
      //                         );
      //                       }),
      //                 ))),
      //         // Expanded(child: GetBuilder<IssueController>(
      //         //   init: IssueController(),
      //         //     global: false,
      //         //     builder: (_) =>  Container(
      //         //       color: Colors.transparent,
      //         //       height:50,
      //         //       width:200,
      //         //       child: issueController.issueList.isEmpty?Text('Hello'):ListView.builder(
      //         //           itemCount: issueController.issueList.length,
      //         //           physics: const ScrollPhysics(),
      //         //           scrollDirection: Axis.horizontal,
      //         //           reverse: true,
      //         //           shrinkWrap: true,
      //         //           itemBuilder: (context, index) {
      //         //             return Padding(
      //         //               padding: const EdgeInsets.symmetric(horizontal: 4.0),
      //         //               child: InkWell(
      //         //                 onTap: () {
      //         //                   showCapturedImage(
      //         //                       context, issueController.issueList[index].Attachment??'');
      //         //                 },
      //         //                 child: Container(
      //         //                   decoration: BoxDecoration(
      //         //                       border: Border.all(),
      //         //                       color: Colors.transparent),
      //         //                   child: Image.file(
      //         //                       File(issueController.issueList[index].Attachment??'')),
      //         //                 ),
      //         //               ),
      //         //             );
      //         //           }),
      //         //     ))),
      //       ],
      //     ),
      //   ),
      //   child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       children: <Widget>[
      //         Center(
      //           child: ClipRRect(
      //             borderRadius: BorderRadius.circular(15.0),
      //             child: Image.asset(
      //               logoPath,
      //               // height: MediaQuery.of(context).size.height,
      //               // width: MediaQuery.of(context).size.width,
      //             ),
      //           ),
      //         ),
      //         SpinKitRipple(
      //           color: backColor,
      //         )
      //       ]),
      // ),
    );
  }
}

// initialize Shared Preference
Future<void> initializeSharedPref() async {
  localStorage = await SharedPreferences.getInstance();
}
