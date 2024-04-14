// import 'package:flutter/material.dart';
// import 'package:maintenance/Sync/SyncModels/OAPRV.dart';
// import 'package:maintenance/main.dart';
//
// class Approval {
//   static List<OAPRVModel> oaprvList = [];
//
//   static bool canApprove(String DocName) {
//     bool canApprove = false;
//     for (int i = 0; i < oaprvList.length; i++) {
//       if (oaprvList[i].Active && oaprvList[i].Add && oaprvList[i].DocName == DocName) {
//         canApprove = true;
//         break;
//       }
//     }
//     return canApprove;
//   }
//
//   static Future<void> loadApproval(BuildContext context) async {
//     List<OAPRVModel> l = await retrieveOAPRVById(
//         context, "CreatedBy = ? ", [userModel.UserCode]);
//     l.forEach((oaprv) {
//       oaprvList.add(oaprv);
//     });
//   }
// }
