import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance/CheckListDocument/CheckListDocument.dart';
import 'package:maintenance/Component/AppConfig.dart';
import 'package:maintenance/Component/CheckInternet.dart';
import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/CustomFont.dart';
import 'package:maintenance/Component/IsAPIWorking.dart';
import 'package:maintenance/Component/IsValidAppVersion.dart';
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/MenuDescription.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/GoodsIssue/GoodsIssue.dart';
import 'package:maintenance/GoodsReceiptNote/GoodsReceiptNote.dart';
import 'package:maintenance/InternalRequest/InternalRequest.dart';
import 'package:maintenance/JobCard/JobCard.dart';
import 'package:maintenance/Purchase/PurchaseRequest/PurchaseRequest.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:maintenance/Sync/SyncModels/ORTU.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../main.dart';

class CustomDrawer extends StatefulWidget {
  static bool hasEnabledLocation = false;

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  // List<ORTUModel> ortuList = [];
  bool displayDrawer = true;

  @override
  Widget build(BuildContext context) {
    if (displayDrawer) {
      return Drawer(
        backgroundColor: barColor,
        child: CustomDrawer.hasEnabledLocation
            ? ListView(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountName: Text(
                      userModel.Name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    // currentAccountPicture: ClipRRect(
                    //     borderRadius: BorderRadius.circular(15.0),
                    //     child: Image.asset(logoPath)),
                    currentAccountPicture: CachedNetworkImage(
                      imageUrl: "https://www.litpl.com/static/img/user.png",
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    decoration: new BoxDecoration(
                      color: barColor,
                    ),
                    accountEmail: null,
                  ),
                  if (isAppVersionValid == RxBool(true)) ...[
                    ExpansionTile(
                      // initiallyExpanded: true,
                      collapsedBackgroundColor: barColor,
                      backgroundColor: barColor,
                      leading: Icon(MdiIcons.currencyUsd, color: Colors.white),
                      title: Text(
                        "Maintenance",
                        style: TextStyle(color: headColor),
                      ),
                      children: [
                        ListTile(
                          onTap: (){
                            Get.to(()=>CheckListDocument(0));
                          },
                          // onTap: () async {
                          //   await clearSalesQuotationData();
                          //   getLastDocNum("SQ", context)
                          //       .then((snapshot) async {
                          //     int DocNum =
                          //         snapshot[0].DocNumber - 1;
                          //     // print("Last doc num is ${DocNum.toString()}");
                          //
                          //     do {
                          //       DocNum += 1;
                          //       salesQuotation.GeneralData
                          //           .TransId = DateTime.now()
                          //           .millisecondsSinceEpoch
                          //           .toString() +
                          //           "U0" +
                          //           userModel.ID.toString() +
                          //           "_" +
                          //           snapshot[0].DocName +
                          //           "/" +
                          //           DocNum.toString();
                          //     } while (
                          //     await isSQTransIdAvailable(
                          //         context,
                          //         salesQuotation
                          //             .GeneralData
                          //             .TransId ??
                          //             ""));
                          //
                          //     //
                          //     // updateDocNum(snapshot[0].ID, val, context);
                          //     //generalData['TransId']=DateTime.now().millisecondsSinceEpoch.toString()+"U0"+userModel.ID.toString()+"_"+generalData['MTransId'].substring(1);
                          //
                          //     if (userModel.Type ==
                          //         "Customer") {
                          //       salesQuotation.GeneralData
                          //           .customerCode =
                          //           userModel.UserCode;
                          //       salesQuotation.GeneralData
                          //           .customerName =
                          //           userModel.Name;
                          //       salesQuotation.GeneralData
                          //           .MobileNo =
                          //           userModel.MobileNo;
                          //     }
                          //
                          //     Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (context) =>
                          //                 SalesQuotation(0)));
                          //   });
                          // },
                          title: Text(
                            'Check List Document',
                            style: TextStyle(color: Colors.white),
                          ),
                          leading:
                              Icon(MdiIcons.account, color: Colors.white),
                          trailing: Icon(Icons.keyboard_arrow_right,
                              color: Colors.white),
                        ),
                        ListTile(
                          onTap: (){
                            Get.to(()=>JobCard(0));
                          },
                          // onTap: () async {
                          //   await clearSalesQuotationData();
                          //   getLastDocNum("SQ", context)
                          //       .then((snapshot) async {
                          //     int DocNum =
                          //         snapshot[0].DocNumber - 1;
                          //     // print("Last doc num is ${DocNum.toString()}");
                          //
                          //     do {
                          //       DocNum += 1;
                          //       salesQuotation.GeneralData
                          //           .TransId = DateTime.now()
                          //           .millisecondsSinceEpoch
                          //           .toString() +
                          //           "U0" +
                          //           userModel.ID.toString() +
                          //           "_" +
                          //           snapshot[0].DocName +
                          //           "/" +
                          //           DocNum.toString();
                          //     } while (
                          //     await isSQTransIdAvailable(
                          //         context,
                          //         salesQuotation
                          //             .GeneralData
                          //             .TransId ??
                          //             ""));
                          //
                          //     //
                          //     // updateDocNum(snapshot[0].ID, val, context);
                          //     //generalData['TransId']=DateTime.now().millisecondsSinceEpoch.toString()+"U0"+userModel.ID.toString()+"_"+generalData['MTransId'].substring(1);
                          //
                          //     if (userModel.Type ==
                          //         "Customer") {
                          //       salesQuotation.GeneralData
                          //           .customerCode =
                          //           userModel.UserCode;
                          //       salesQuotation.GeneralData
                          //           .customerName =
                          //           userModel.Name;
                          //       salesQuotation.GeneralData
                          //           .MobileNo =
                          //           userModel.MobileNo;
                          //     }
                          //
                          //     Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (context) =>
                          //                 SalesQuotation(0)));
                          //   });
                          // },
                          title: Text(
                            'Job Card',
                            style: TextStyle(color: Colors.white),
                          ),
                          leading:
                              Icon(MdiIcons.account, color: Colors.white),
                          trailing: Icon(Icons.keyboard_arrow_right,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    ExpansionTile(
                      // initiallyExpanded: true,
                      collapsedBackgroundColor: barColor,
                      backgroundColor: barColor,
                      leading: Icon(MdiIcons.currencyUsd, color: Colors.white),
                      title: Text(
                        "Inventory",
                        style: TextStyle(color: headColor),
                      ),
                      children: [
                        ListTile(
                          onTap: (){
                            Get.to(()=>GoodsIssue(0));
                          },
                          title: Text(
                            'Goods Issue',
                            style: TextStyle(color: Colors.white),
                          ),
                          leading:
                              Icon(MdiIcons.account, color: Colors.white),
                          trailing: Icon(Icons.keyboard_arrow_right,
                              color: Colors.white),
                        ),
                      ],
                    ),

                    ExpansionTile(
                      // initiallyExpanded: true,
                      collapsedBackgroundColor: barColor,
                      backgroundColor: barColor,
                      leading: Icon(MdiIcons.currencyUsd, color: Colors.white),
                      title: Text(
                        "Purchase",
                        style: TextStyle(color: headColor),
                      ),
                      children: [
                        ListTile(
                          onTap: (){
                            Get.to(()=>PurchaseRequest(0));
                          },
                          title: Text(
                            'Purchase Request',
                            style: TextStyle(color: Colors.white),
                          ),
                          leading:
                              Icon(MdiIcons.account, color: Colors.white),
                          trailing: Icon(Icons.keyboard_arrow_right,
                              color: Colors.white),
                        ),
                        ListTile(
                          onTap: (){
                            Get.to(()=>GoodsRecepitNote(0));
                          },
                          title: Text(
                            'Goods Receipt Note',
                            style: TextStyle(color: Colors.white),
                          ),
                          leading:
                              Icon(MdiIcons.account, color: Colors.white),
                          trailing: Icon(Icons.keyboard_arrow_right,
                              color: Colors.white),
                        ),
                        ListTile(
                          onTap: (){
                            Get.to(()=>InternalRequest(0));
                          },
                          title: Text(
                            'Internal Request',
                            style: TextStyle(color: Colors.white),
                          ),
                          leading:
                              Icon(MdiIcons.account, color: Colors.white),
                          trailing: Icon(Icons.keyboard_arrow_right,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    // FutureBuilder(
                    //     future: retrieveModuleVisibilityData(
                    //         ControllerName: 'SalesAndPlanning'),
                    //     builder:
                    //         (context, AsyncSnapshot<List<ORTUModel>> snapshot) {
                    //       if (!snapshot.hasData || snapshot.data?.length == 0) {
                    //         return Container();
                    //       } else {
                    //         if (snapshot.data![0].Active == true) {
                    //           return ExpansionTile(
                    //             // initiallyExpanded: true,
                    //             collapsedBackgroundColor: barColor,
                    //             backgroundColor: barColor,
                    //             leading: Icon(MdiIcons.currencyUsd,
                    //                 color: Colors.white),
                    //             title: Text(
                    //               "Sales & Planning",
                    //               style: TextStyle(color: headColor),
                    //             ),
                    //             children: [
                    //               FutureBuilder(
                    //                   future: retrieveFormVisibilityData(
                    //                       ControllerName:
                    //                           MenuDescription.salesQuotation),
                    //                   builder: (context,
                    //                       AsyncSnapshot<List<ORTUModel>>
                    //                           snapshot) {
                    //                     if (!snapshot.hasData ||
                    //                         snapshot.data?.length == 0) {
                    //                       return Container();
                    //                     }
                    //                     if (snapshot.data![0].Active == true) {
                    //                       return InkWell(
                    //                         // onTap: () async {
                    //                         //   await clearSalesQuotationData();
                    //                         //   getLastDocNum("SQ", context)
                    //                         //       .then((snapshot) async {
                    //                         //     int DocNum =
                    //                         //         snapshot[0].DocNumber - 1;
                    //                         //     // print("Last doc num is ${DocNum.toString()}");
                    //                         //
                    //                         //     do {
                    //                         //       DocNum += 1;
                    //                         //       salesQuotation.GeneralData
                    //                         //           .TransId = DateTime.now()
                    //                         //               .millisecondsSinceEpoch
                    //                         //               .toString() +
                    //                         //           "U0" +
                    //                         //           userModel.ID.toString() +
                    //                         //           "_" +
                    //                         //           snapshot[0].DocName +
                    //                         //           "/" +
                    //                         //           DocNum.toString();
                    //                         //     } while (
                    //                         //         await isSQTransIdAvailable(
                    //                         //             context,
                    //                         //             salesQuotation
                    //                         //                     .GeneralData
                    //                         //                     .TransId ??
                    //                         //                 ""));
                    //                         //
                    //                         //     //
                    //                         //     // updateDocNum(snapshot[0].ID, val, context);
                    //                         //     //generalData['TransId']=DateTime.now().millisecondsSinceEpoch.toString()+"U0"+userModel.ID.toString()+"_"+generalData['MTransId'].substring(1);
                    //                         //
                    //                         //     if (userModel.Type ==
                    //                         //         "Customer") {
                    //                         //       salesQuotation.GeneralData
                    //                         //               .customerCode =
                    //                         //           userModel.UserCode;
                    //                         //       salesQuotation.GeneralData
                    //                         //               .customerName =
                    //                         //           userModel.Name;
                    //                         //       salesQuotation.GeneralData
                    //                         //               .MobileNo =
                    //                         //           userModel.MobileNo;
                    //                         //     }
                    //                         //
                    //                         //     Navigator.push(
                    //                         //         context,
                    //                         //         MaterialPageRoute(
                    //                         //             builder: (context) =>
                    //                         //                 SalesQuotation(0)));
                    //                         //   });
                    //                         // },
                    //                         child: ListTile(
                    //                           title: Text(
                    //                             'Sales Quotation',
                    //                             style: TextStyle(
                    //                                 color: Colors.white),
                    //                           ),
                    //                           leading: Icon(MdiIcons.account,
                    //                               color: Colors.white),
                    //                           trailing: Icon(
                    //                               Icons.keyboard_arrow_right,
                    //                               color: Colors.white),
                    //                         ),
                    //                       );
                    //                     } else {
                    //                       return Container();
                    //                     }
                    //                   }),
                    //             ],
                    //           );
                    //         } else {
                    //           return Container();
                    //         }
                    //       }
                    //     }),

                    // InkWell(
                    //   onTap: (){
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) =>
                    //                 SupportTicket(0)));
                    //   },
                    //   child: ListTile(
                    //     title: Text(
                    //       "Issue Raise",
                    //       style: TextStyle(color: headColor),
                    //     ),
                    //     leading:
                    //     Icon(MdiIcons.account, color: Colors.white),
                    //     trailing: Icon(Icons.keyboard_arrow_right,
                    //         color: Colors.white),
                    //   ),
                    // ),
                    FutureBuilder(
                        future: retrieveFormVisibilityData(
                            ControllerName: MenuDescription.issueRaised),
                        builder:
                            (context, AsyncSnapshot<List<ORTUModel>> snapshot) {
                          if (!snapshot.hasData || snapshot.data?.length == 0) {
                            return Container();
                          }
                          if (snapshot.data![0].Active == true) {
                            return InkWell(
                              onTap: () async {
                                //todo:
                                // await clearIssueRaisedData();
                                // getLastDocNum("IR", context)
                                //     .then((snapshot) async {
                                //   int DocNum = snapshot[0].DocNumber - 1;
                                //   do {
                                //     DocNum += 1;
                                //     issueRaiseGenData.IssueRaise.suoisu
                                //         ?.TicketCode = DateTime.now()
                                //             .millisecondsSinceEpoch
                                //             .toString() +
                                //         "U0" +
                                //         userModel.ID.toString() +
                                //         "_" +
                                //         snapshot[0].DocName +
                                //         "/" +
                                //         DocNum.toString();
                                //   } while (await isIRTransIdAvailable(
                                //       context,
                                //       issueRaiseGenData
                                //               .IssueRaise.suoisu?.TicketCode ??
                                //           ""));
                                //
                                //   // updateDocNum(snapshot[0].ID, val, context);
                                //
                                //   Navigator.push(
                                //       context,
                                //       MaterialPageRoute(
                                //           builder: (context) =>
                                //               SupportTicket(0)));
                                // });
                              },
                              child: ListTile(
                                title: Text(
                                  "Issue Raise",
                                  style: TextStyle(color: headColor),
                                ),
                                leading:
                                    Icon(MdiIcons.account, color: Colors.white),
                                trailing: Icon(Icons.keyboard_arrow_right,
                                    color: Colors.white),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        }),
                    // InkWell(
                    //   onTap: () async {
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => ViewSupportTicket(0)));
                    //   },
                    //   child: ListTile(
                    //     title: Text(
                    //       "View Support Ticket",
                    //       style: TextStyle(color: headColor),
                    //     ),
                    //     leading: Icon(MdiIcons.account, color: Colors.white),
                    //     trailing:
                    //         Icon(Icons.keyboard_arrow_right, color: Colors.white),
                    //   ),
                    // ),

                    // InkWell(
                    //   onTap: () async {
                    //     double num1=getNumberWithoutComma(displayNumberWithComma('200000'));
                    //     double num2=getNumberWithoutComma(displayNumberWithComma('200000'));
                    //     print(num1+num1);
                    //   },
                    //   child: ListTile(
                    //     title: Text('printNumber();'),
                    //     leading: Icon(
                    //       Icons.sync,
                    //       color: barColor,
                    //     ),
                    //     trailing: Icon(Icons.keyboard_arrow_right),
                    //   ),
                    // ),
                  ],

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
                                      isFirstTimeSync: false,
                                    )))).then((value) {
                          setState(() {});
                        });
                        // getErrorSnackBar('API is working');
                      } else {
                        getErrorSnackBar('API is not working');
                      }
                    },
                    child: ListTile(
                      title: Text(
                        'Sync Data',
                        style: TextStyle(color: headColor),
                      ),
                      leading: Icon(Icons.sync, color: Colors.white),
                      trailing:
                          Icon(Icons.keyboard_arrow_right, color: Colors.white),
                    ),
                  ),
                  // InkWell(
                  //   onTap: () async {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: ((context) => CustomProgresor())));
                  //   },
                  //   child: ListTile(
                  //     title: Text(
                  //       'Custom Progresor',
                  //       style: TextStyle(color: headColor),
                  //     ),
                  //     leading: Icon(Icons.sync, color: Colors.white),
                  //     trailing:
                  //         Icon(Icons.keyboard_arrow_right, color: Colors.white),
                  //   ),
                  // ),
                  // InkWell(
                  //   onTap: () async {
                  //     final pdfFile =
                  //         await PdfInvoiceApi.generate(TransId: 'CR/15');
                  //     PdfApi.openFile(pdfFile);
                  //     // final dir = await getApplicationDocumentsDirectory();
                  //     // final file = File('${dir.path}/CashReceipt.pdf');
                  //     // final pdf = await rootBundle.load('${dir.path}/CashReceipt.pdf');
                  //     // bool val=await Printing.layoutPdf(onLayout: (_) => pdf.buffer.asUint8List());
                  //     // print(val);
                  //
                  //     // final pdf = await rootBundle.load('CashReceipt_U01_CR/1182.pdf');
                  //     // await Printing.layoutPdf(onLayout: (_) => pdf.buffer.asUint8List());
                  //   },
                  //   child: ListTile(
                  //     title: Text(
                  //       'Open PDF',
                  //       style: TextStyle(color: headColor),
                  //     ),
                  //     leading: Icon(Icons.sync, color: Colors.white),
                  //     trailing:
                  //         Icon(Icons.keyboard_arrow_right, color: Colors.white),
                  //   ),
                  // ),
                  // InkWell(
                  //   onTap: () async {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: ((context) => TestInsertion())));
                  //   },
                  //   child: ListTile(
                  //     title: Text(
                  //       'Test Insertion',
                  //       style: TextStyle(color: headColor),
                  //     ),
                  //     leading: Icon(Icons.sync, color: Colors.white),
                  //     trailing: Icon(Icons.keyboard_arrow_right, color: Colors.white),
                  //   ),
                  // ),
                  // InkWell(
                  //   onTap: () async {
                  //     Navigator.push(context, MaterialPageRoute(builder: ((context) => MapPolyLinesDemo())));
                  //   },
                  //   child: ListTile(
                  //     title: Text(
                  //       'Map Poly Lines Demo',
                  //       style: TextStyle(color: headColor),
                  //     ),
                  //     leading: Icon(Icons.sync, color: Colors.white),
                  //     trailing: Icon(Icons.keyboard_arrow_right, color: Colors.white),
                  //   ),
                  // ),
                  //

                  // InkWell(
                  //   onTap: () async {
                  //     Get.to(()=>LogFileScreen());
                  //   },
                  //   child: ListTile(
                  //     title: Text(
                  //       'Create Log',
                  //       style: TextStyle(color: headColor),
                  //     ),
                  //     leading: Icon(Icons.logout, color: Colors.white),
                  //     trailing:
                  //         Icon(Icons.keyboard_arrow_right, color: Colors.white),
                  //   ),
                  // ),
                  // InkWell(
                  //   onTap: () async {
                  //     List<INV1Model> list = await retrieveINV1ById(
                  //         context,
                  //         DataSync.getInsertToServerStr() ,
                  //         DataSync.getInsertToServerList());
                  //     for(INV1Model inv1 in list)
                  //       {
                  //         print('${inv1.TransId}--> ${inv1.LineTotal}');
                  //       }
                  //   },
                  //   child: ListTile(
                  //     title: Text(
                  //       'View',
                  //       style: TextStyle(color: headColor),
                  //     ),
                  //     leading: Icon(Icons.logout, color: Colors.white),
                  //     trailing:
                  //         Icon(Icons.keyboard_arrow_right, color: Colors.white),
                  //   ),
                  // ),
                  // InkWell(
                  //   onTap: () async {
                  //     print(await isValidAppVersion());
                  //   },
                  //   child: ListTile(
                  //     title: Text(
                  //       'isValidAppVersion',
                  //       style: TextStyle(color: headColor),
                  //     ),
                  //     leading: Icon(Icons.logout, color: Colors.white),
                  //     trailing:
                  //         Icon(Icons.keyboard_arrow_right, color: Colors.white),
                  //   ),
                  // ),
                  // InkWell(
                  //   onTap: () async {
                  //    Get.to(()=>CreateCustomer(0));
                  //   },
                  //   child: ListTile(
                  //     title: Text(
                  //       'Create Customer',
                  //       style: TextStyle(color: headColor),
                  //     ),
                  //     leading: Icon(Icons.share, color: Colors.white),
                  //     trailing:
                  //         Icon(Icons.keyboard_arrow_right, color: Colors.white),
                  //   ),
                  // ),

                  InkWell(
                    onTap: () async {
                      List<Widget> titleRowWidgets = [Text("Share Via")];
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
                                  onPressed: () {
                                    shareFileOnWhatsApp();
                                  },
                                  child: getSubHeadingText(
                                      text: "WhatsApp",
                                      color: Color(0XFF015C4B)),
                                ),
                                TextButton(
                                  onPressed: () {
                                    shareLogFile();
                                  },
                                  child: getSubHeadingText(
                                      text: "Other", color: barColor),
                                ),
                              ],
                            )),
                      ];
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          if (Platform.isIOS) {
                            return CupertinoAlertDialog(
                              title: Row(
                                children: titleRowWidgets,
                              ),
                              content: Text("How do you want to share?"),
                              actions: actions,
                            );
                          } else {
                            return AlertDialog(
                              title: Row(
                                children: titleRowWidgets,
                              ),
                              content: Text("How do you want to share?"),
                              actions: actions,
                            );
                          }
                        },
                      );
                    },
                    child: ListTile(
                      title: Text(
                        'Share Log File',
                        style: TextStyle(color: headColor),
                      ),
                      leading: Icon(Icons.share, color: Colors.white),
                      trailing:
                          Icon(Icons.keyboard_arrow_right, color: Colors.white),
                    ),
                  ),

                  // InkWell(
                  //   onTap: () async {
                  //     Navigator.push(context, MaterialPageRoute(builder: (context)=>TestUploadImage()));
                  //   },
                  //   child: ListTile(
                  //     title: Text(
                  //       'Upload Image',
                  //       style: TextStyle(color: headColor),
                  //     ),
                  //     leading: Icon(Icons.logout, color: Colors.white),
                  //     trailing:
                  //         Icon(Icons.keyboard_arrow_right, color: Colors.white),
                  //   ),
                  // ),
                  //
                  // InkWell(
                  //   onTap: () async {
                  //     Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomScanner()));
                  //   },
                  //   child: ListTile(
                  //     title: Text(
                  //       'CustomScanner',
                  //       style: TextStyle(color: headColor),
                  //     ),
                  //     leading: Icon(Icons.logout, color: Colors.white),
                  //     trailing:
                  //         Icon(Icons.keyboard_arrow_right, color: Colors.white),
                  //   ),
                  // ),

                  // InkWell(
                  //   onTap: () async {
                  //
                  //     // print("ACT1 before");
                  //     // retrieveACT1(context).then((snapshot) async {
                  //     //   snapshot.forEach((element) {
                  //     //     print(element.ID);
                  //     //   });
                  //     //   await dataSyncUpdateACT1("20",{
                  //     //     "ID":"20",
                  //     //     "TransId":"TransId1",
                  //     //     "Competitor":"Competitor1",
                  //     //     "ItemCode":"ItemCode1",
                  //     //     "ItemName":"ItemName1",
                  //     //     "Price":"500091",
                  //     //     "Quantity":"20091",
                  //     //     "UOM":"abcd1"
                  //     //   });
                  //     //   print("ACT1 After");
                  //     //   snapshot.forEach((element) {
                  //     //     print(element.ID);
                  //     //   });
                  //     // });
                  //   },
                  //   child: ListTile(
                  //     title: Text('Retrieve'),
                  //     leading: Icon(Icons.sync, color: barColor,),
                  //     trailing: Icon(Icons.keyboard_arrow_right),
                  //   ),
                  // ),
                  // InkWell(
                  //   onTap: () async {
                  //    Position pos=await  getCurrentLocation();
                  //    getErrorSnackBar( pos.longitude.toString()+" "+pos.latitude.toString());
                  //    print(pos.longitude.toString());
                  //    print(pos.latitude.toString());
                  //   },
                  //   child: ListTile(
                  //     title: Text('get location'),
                  //     leading: Icon(Icons.sync, color: barColor,),
                  //     trailing: Icon(Icons.keyboard_arrow_right),
                  //   ),
                  // ),
                  // InkWell(
                  //   onTap: () async {
                  //     Navigator.push(context, MaterialPageRoute(builder: ((context)=>GetUniqueDeviceNumber())));
                  //   },
                  //   child: ListTile(
                  //     title: Text('Get IMEI'),
                  //     leading: Icon(Icons.sync, color: barColor,),
                  //     trailing: Icon(Icons.keyboard_arrow_right),
                  //   ),
                  // ),
                  // InkWell(
                  //   onTap: () async {
                  //     Navigator.push(context, MaterialPageRoute(builder: ((context)=>GetMacScreen())));
                  //   },
                  //   child: ListTile(
                  //     title: Text('Get MAC'),
                  //     leading: Icon(Icons.sync, color: barColor,),
                  //     trailing: Icon(Icons.keyboard_arrow_right),
                  //   ),
                  // ),
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.push(context, MaterialPageRoute(builder: (context)=>CashReceipt()));
                  //   },
                  //   child: ListTile(
                  //     title: Text('Cash Receipt'),
                  //     leading: Icon(FlutterIcons.user_friends_faw5s, color: barColor,),
                  //     trailing: Icon(Icons.keyboard_arrow_right),
                  //   ),
                  // ),
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.push(context, MaterialPageRoute(builder: (context)=>BankingForm()));
                  //   },
                  //   child: ListTile(
                  //     title: Text('Banking Form'),
                  //     leading: Icon(FlutterIcons.user_friends_faw5s, color: barColor,),
                  //     trailing: Icon(Icons.keyboard_arrow_right),
                  //   ),
                  // ),
                ],
              )
            : ListView(
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Text(
                      userModel.Name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    accountEmail: Text(userModel.Email,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                    currentAccountPicture: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Image.asset(logoPath)),
                    decoration: new BoxDecoration(
                      color: barColor,
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Enable Location permission to continue',
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing:
                        Icon(Icons.keyboard_arrow_right, color: Colors.white),
                  ),
                ],
              ),
      );
    } else {
      return Drawer(
        child: CustomDrawer.hasEnabledLocation
            ? ListView(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountName: Text(
                      userModel.Name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    // accountEmail: Text("ayushpratiksrivastava@gmail.com",
                    //     style: TextStyle(
                    //         fontWeight: FontWeight.bold)),
                    currentAccountPicture: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Image.asset(logoPath)),
                    decoration: new BoxDecoration(
                      color: barColor,
                    ),
                    accountEmail: null,
                  ),
                ],
              )
            : ListView(
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Text(
                      userModel.Name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    accountEmail: Text(userModel.Email,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    currentAccountPicture: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Image.asset(logoPath)),
                    decoration: new BoxDecoration(
                      color: barColor,
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Enable Location permission to continue',
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing:
                        Icon(Icons.keyboard_arrow_right, color: Colors.white),
                  ),
                ],
              ),
      );
    }
  }
}
