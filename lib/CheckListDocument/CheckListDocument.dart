import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maintenance/CheckListDocument/Attachments.dart';
import 'package:maintenance/CheckListDocument/CheckListDetails.dart';
import 'package:maintenance/CheckListDocument/GeneralData.dart';
import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/CustomFont.dart';
import 'package:maintenance/Dashboard.dart';
import 'package:maintenance/Sync/SyncModels/ApprovalModel.dart';

class CheckListDocument extends StatefulWidget {
  static var address;
  static bool saveButtonPressed = false;
  int index = 0;
  static RxInt numOfTabs=RxInt(3);
  static ApprovalModel? approvalModel;

  CheckListDocument(int index, {this.onBackPressed}) {
    this.index = index;
  }

  Function? onBackPressed;

  @override
  _CheckListDocumentState createState() => _CheckListDocumentState();
}

class _CheckListDocumentState extends State<CheckListDocument> {
  List lists = [];
  int numOfAddress = 0;
  var future_address;

  @override
  void initState() {
    super.initState();
  }

  final key = GlobalKey<ScaffoldState>();

  _onBackButtonPressed() {
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => Dashboard()), (route) => false);
    // if (GeneralData.customerCode != '' || ItemDetails.items.isNotEmpty) {
    //   showBackPressedWarning(onBackPressed: widget.onBackPressed);
    // } else if (widget.onBackPressed != null) {
    //   widget.onBackPressed!();
    // } else {
    //   Navigator.pushAndRemoveUntil(
    //       context,
    //       MaterialPageRoute(builder: (context) => Dashboard()),
    //           (route) => false);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (bool bb) async {
        await _onBackButtonPressed();
      },
      canPop: false,
      child: Obx(()=>DefaultTabController(
        length: CheckListDocument.numOfTabs.value,
        initialIndex: widget.index,
        child: Scaffold(
          key: key,
          appBar: AppBar(
              leading: IconButton(
                onPressed: () async {
                  await _onBackButtonPressed();
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              elevation: 10.0,
              backgroundColor: barColor,
              bottom: PreferredSize(
                child: Column(
                  children: [
                    TabBar(
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          color: Colors.white),
                      labelColor: barColor,
                      isScrollable: true,
                      physics: const ScrollPhysics(),
                      unselectedLabelColor: Colors.white,
                      labelStyle:
                      GoogleFonts.poppins(fontWeight: FontWeight.w500),
                      tabs: [
                        Tab(
                          child: Text("General Data"),
                        ),
                        Tab(
                            child: Text(
                              "Check List Details",
                            )),
                        Tab(
                            child: Text(
                              "Attachments",
                            )),
                        if(CheckListDocument.numOfTabs.value==4)
                          Tab(
                              child: Text(
                                "Tyre Maintenance",
                              )),
                      ],
                    ),
                  ],
                ),
                preferredSize: Size.fromHeight(50.0),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    //showSearch(context: context, delegate: SearchCheckListDocument());
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: ((context) => AdvanceSearch())));
                  },
                ),
                IconButton(
                  tooltip: "Add New Document",
                  icon: Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                  onPressed: () {},
                  // onPressed: () async {
                  //   if (GeneralData.customerCode != '' ||
                  //       ItemDetails.items.isNotEmpty) {
                  //     showBackPressedWarning(
                  //         text:
                  //         'Your data is not saved. Are you sure you want to create new form?',
                  //         onBackPressed: () async {
                  //           await clearCheckListDocumentData();
                  //           getLastDocNum("SQ", context).then((snapshot) async {
                  //             int DocNum = snapshot[0].DocNumber - 1;
                  //
                  //             do {
                  //               DocNum += 1;
                  //               GeneralData.TransId = DateTime.now()
                  //                   .millisecondsSinceEpoch
                  //                   .toString() +
                  //                   "U0" +
                  //                   userModel.ID.toString() +
                  //                   "_" +
                  //                   snapshot[0].DocName +
                  //                   "/" +
                  //                   DocNum.toString();
                  //             } while (await isSQTransIdAvailable(
                  //                 context, GeneralData.TransId ?? ""));
                  //             // Map<String, dynamic> val = {"DocNumber": DocNum};
                  //             // updateDocNum(snapshot[0].ID, val, context);
                  //             // GeneralData.MTransID="M"+snapshot[0].DocName+"/"+DocNum.toString();
                  //             // GeneralData.TransId = DateTime.now().millisecondsSinceEpoch.toString()+"U0" + userModel.ID.toString() + "_" + snapshot[0].DocName + "/" + DocNum.toString();
                  //             GeneralData.isSelected = false;
                  //             Navigator.pop(context);
                  //             Navigator.push(
                  //                 context,
                  //                 MaterialPageRoute(
                  //                     builder: (context) => CheckListDocument(0)));
                  //           });
                  //         });
                  //   } else {
                  //     await clearCheckListDocumentData();
                  //     getLastDocNum("SQ", context).then((snapshot) async {
                  //       int DocNum = snapshot[0].DocNumber - 1;
                  //
                  //       do {
                  //         DocNum += 1;
                  //         GeneralData.TransId =
                  //             DateTime.now().millisecondsSinceEpoch.toString() +
                  //                 "U0" +
                  //                 userModel.ID.toString() +
                  //                 "_" +
                  //                 snapshot[0].DocName +
                  //                 "/" +
                  //                 DocNum.toString();
                  //       } while (await isSQTransIdAvailable(
                  //           context, GeneralData.TransId ?? ""));
                  //       // Map<String, dynamic> val = {"DocNumber": DocNum};
                  //       // updateDocNum(snapshot[0].ID, val, context);
                  //       // GeneralData.MTransID="M"+snapshot[0].DocName+"/"+DocNum.toString();
                  //       // GeneralData.TransId = DateTime.now().millisecondsSinceEpoch.toString()+"U0" + userModel.ID.toString() + "_" + snapshot[0].DocName + "/" + DocNum.toString();
                  //       GeneralData.isSelected = false;
                  //       Navigator.pop(context);
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => CheckListDocument(0)));
                  //     });
                  //   }
                  // },
                ),
                // IconButton(
                //   tooltip: "Cancel Document",
                //   icon: Icon(Icons.delete_forever,color: Colors.red,),
                //   onPressed: (){
                //     if(isSelectedAndCancelled() || isCheckListDocumentDocClosed())
                //       {
                //       getErrorSnackBar( "This Document is already cancelled / closed");
                //     }
                //     else if(isSelectedButNotCancelled())
                //     {
                //         AnimatedDialogBox.showScaleAlertBox(
                //             title:Center(child: Text("Cancel")) , // IF YOU WANT TO ADD
                //             context: context,
                //             firstButton: MaterialButton(
                //               // OPTIONAL BUTTON
                //               shape: RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.circular(40),
                //               ),
                //               color: barColor,
                //               child: Text('No',
                //                 style: TextStyle(
                //                     color: Colors.white
                //                 ),),
                //               onPressed: () {
                //                 Navigator.of(context).pop();
                //               },
                //             ),
                //             secondButton: MaterialButton(
                //               // OPTIONAL BUTTON
                //               shape: RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.circular(40),
                //               ),
                //               color: Colors.red,
                //               child: Text('Yes',
                //                 style: TextStyle(
                //                     color: Colors.white
                //                 ),),
                //               onPressed: () async {
                //                 GeneralData.DocStatus="Cancelled";
                //                 final db = await initializeDB(context);
                //                 Map<String,dynamic> values={
                //                   "DocStatus":"Cancelled",
                //                   "has_updated":1,
                //                 };
                //                 await db.update(DBName.ODB, values, where: 'MTransId = ?', whereArgs: [GeneralData.MTransID]);
                //                 Navigator.of(context).pop();
                //                 Navigator.pop(context);
                //                 Navigator.push(context, MaterialPageRoute(builder: (context)=>CheckListDocument(0)));
                //               },
                //             ),
                //             icon: Icon(Icons.info_outline,color: Colors.red,), // IF YOU WANT TO ADD ICON
                //             yourWidget: Container(
                //               child: Text('Are you sure you want to cancel this document?'),
                //             ));
                //
                //       }
                //   },
                // ),
              ],
              title: getHeadingText(
                  text: "Check List Documents",
                  color: headColor,
                  fontSize: 20)),
          body: TabBarView(
            children: [
              GeneralData(),
              CheckListDetails(),
              Attachments(),
              if(CheckListDocument.numOfTabs.value==4)
               Container()
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: barColor,
            tooltip: "Save Data",
            child: Text(
              "Save",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: save,
          ),
        ),
      )),
    );
  }

  save() {}

  syncWithServer() {}
}
