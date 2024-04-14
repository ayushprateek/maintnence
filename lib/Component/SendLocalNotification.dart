import 'dart:convert';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/NavogateToForm.dart';
import 'package:maintenance/Sync/SyncModels/LITPL_OADM.dart';
import 'package:maintenance/Sync/SyncModels/LITPL_OOAL.dart';
import 'package:maintenance/main.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  print('onDidReceiveNotificationResponse called');
  try {
    Map payload = jsonDecode(notificationResponse.payload ?? '');
    print(payload);
    LITPL_OOAL ooal = LITPL_OOAL.fromJson(payload['LITPL_OOAL']);
    LITPL_OADM oadm = LITPL_OADM.fromJson(payload['LITPL_OADM']);
    //todo:
  } catch (e) {
    writeToLogFile(text: e.toString(), fileName: StackTrace.current.toString(), lineNo: 141);
    print(e.toString());
  }
}

sendLocalNotification(
    {String? title, String? body, int? id, Map? payload}) async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  if (Platform.isIOS) {
    final List<DarwinNotificationCategory> darwinNotificationCategories =
        <DarwinNotificationCategory>[
      DarwinNotificationCategory(
        'darwinNotificationCategoryText',
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.text(
            'text_1',
            'Action 1',
            buttonTitle: 'Send',
            placeholder: 'Placeholder',
          ),
        ],
      ),
      DarwinNotificationCategory(
        'darwinNotificationCategoryPlain',
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.plain('id_1', 'Action 1'),
          DarwinNotificationAction.plain(
            'id_2',
            'Action 2 (destructive)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.destructive,
            },
          ),
          DarwinNotificationAction.plain(
            'navigationActionId',
            'Action 3 (foreground)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.foreground,
            },
          ),
          DarwinNotificationAction.plain(
            'id_4',
            'Action 4 (auth required)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.authenticationRequired,
            },
          ),
        ],
        options: <DarwinNotificationCategoryOption>{
          DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
        },
      )
    ];

    /// Note: permissions aren't requested here just to demonstrate that can be
    /// done later
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
        print('Hii');
      },
      notificationCategories: darwinNotificationCategories,
    );
    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(
      defaultActionName: 'Open notification',
      defaultIcon: AssetsLinuxIcon('icons/app_icon.png'),
    );
    final InitializationSettings initializationSettings =
        InitializationSettings(
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
      linux: initializationSettingsLinux,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: notificationTapBackground,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    // final List<DarwinNotificationCategory> darwinNotificationCategories =
    // <DarwinNotificationCategory>[
    //   DarwinNotificationCategory(
    //     'darwinNotificationCategoryText',
    //     actions: <DarwinNotificationAction>[
    //       DarwinNotificationAction.text(
    //         'text_1',
    //         'Action 1',
    //         buttonTitle: 'Send',
    //         placeholder: 'Placeholder',
    //       ),
    //     ],
    //   ),
    //   DarwinNotificationCategory(
    //     'darwinNotificationCategoryPlain',
    //     actions: <DarwinNotificationAction>[
    //       DarwinNotificationAction.plain('id_1', 'Action 1'),
    //       DarwinNotificationAction.plain(
    //         'id_2',
    //         'Action 2 (destructive)',
    //         options: <DarwinNotificationActionOption>{
    //           DarwinNotificationActionOption.destructive,
    //         },
    //       ),
    //       DarwinNotificationAction.plain(
    //         'navigationActionId',
    //         'Action 3 (foreground)',
    //         options: <DarwinNotificationActionOption>{
    //           DarwinNotificationActionOption.foreground,
    //         },
    //       ),
    //       DarwinNotificationAction.plain(
    //         'id_4',
    //         'Action 4 (auth required)',
    //         options: <DarwinNotificationActionOption>{
    //           DarwinNotificationActionOption.authenticationRequired,
    //         },
    //       ),
    //     ],
    //     options: <DarwinNotificationCategoryOption>{
    //       DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
    //     },
    //   )
    // ];
    // final DarwinInitializationSettings initializationSettingsDarwin =
    // DarwinInitializationSettings(
    //   requestAlertPermission: false,
    //   requestBadgePermission: false,
    //   requestSoundPermission: false,
    //   onDidReceiveLocalNotification:
    //       (int id, String? title, String? body, String? payload) async {
    //     print(payload);
    //     print('Received');
    //   },
    //   notificationCategories: darwinNotificationCategories,
    // );
    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
      categoryIdentifier: 'darwinNotificationCategoryPlain',
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(iOS: iosNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
      id ?? 0,
      title,
      body,
      notificationDetails,
      payload: jsonEncode(payload),
    );
  } else {
    ////Set the settings for various platform
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    IOSFlutterLocalNotificationsPlugin;
    // const IOSInitializationSettings initializationSettingsIOS =
    // IOSInitializationSettings(
    //   requestAlertPermission: true,
    //   requestBadgePermission: true,
    //   requestSoundPermission: true,
    // );
    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(
      defaultActionName: 'hello',
    );
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            // iOS: initializationSettingsIOS,
            linux: initializationSettingsLinux);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: notificationTapBackground,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    ///
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_channel', 'High Importance Notification',
        description: "This channel is for important notification",
        importance: Importance.max);

    flutterLocalNotificationsPlugin.show(
      id ?? 0,
      title,
      body,
      payload: jsonEncode(payload),
      NotificationDetails(
        android: AndroidNotificationDetails(channel.id, channel.name,
            channelDescription: channel.description),
      ),
    );
  }
}

getApprovalListForNotification() async {
  List<LITPL_OOAL> list = await retrieveLITPL_OOALById(
      null,
      'AUserCode = ? AND Approve = ? AND Reject = ?',
      [userModel.UserCode, 0, 0]);
  sendApprovalNotification(list: list, index: 0);
}

sendApprovalNotification({
  required List<LITPL_OOAL> list,
  required int index,
}) async {
  if (index == list.length) {
    return;
  }
  LITPL_OOAL ooal = list[index];

  LITPL_OADM oadm =
      (await retrieveLITPL_OADMById(null, 'ID = ?', [ooal.DocID]))[0];
  String? title = list[index].DocNum;
  String? body = list[index].TransId;
  Map payload = {
    'LITPL_OOAL': ooal.toJson(),
    'LITPL_OADM': oadm.toJson(),
    'title': title,
    'body': body
  };
  await sendLocalNotification(
      title: title, body: body, id: index, payload: payload);
  return sendApprovalNotification(list: list, index: index + 1);
}
