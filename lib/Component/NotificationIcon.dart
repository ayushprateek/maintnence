import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance/NotificationScreen.dart';
import 'package:maintenance/Sync/SyncModels/LITPL_OOAL.dart';
import 'package:maintenance/main.dart';

Widget getNotificationIcon() {
  return FutureBuilder(
      future: retrieveLITPL_OOALById(
          null,
          'AUserCode = ? AND Approve = ? AND Reject = ?',
          [userModel.UserCode, 0, 0]),
      builder: (context, AsyncSnapshot<List<LITPL_OOAL>> snapshot) {
        if (!snapshot.hasData || snapshot.data!.length == 0) {
          return Padding(
              padding: const EdgeInsets.only(top: 17.5, bottom: 8, right: 20),
              child: Icon(Icons.notifications,color: Colors.white,));
        }
        return InkWell(
          onTap: () {
            // navigateToExpenseCaptureApproval(TransId: 'EC/17');
            Get.to(() => NotificationScreen());
            // getApprovalListForNotification();
            // sendLocalNotification(title: "Hello",
            // body: "Hi",
            // id: 1,
            // payload: {
            //   'AAA':'111'
            // });
          },
          child: Padding(
              padding: const EdgeInsets.only(top: 17.5, bottom: 8, right: 20),
              child: Badge(
                label: Text(
                  snapshot.data?.length.toString() ?? '',
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
                // position: const BadgePosition(
                //   end: -5.0,
                //   bottom: 22,
                // ),
                child: Icon(Icons.notifications,color: Colors.white),
                // child: getSVGIcon(path: bagIconPath),
              )),
        );
      });
}
