import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maintenance/ApprovalStatus/ApprovalListUIComponent.dart';
import 'package:maintenance/CheckListDocument/create/Attachments.dart';
import 'package:maintenance/CheckListDocument/create/CheckListDetails/CheckListDetails.dart';
import 'package:maintenance/CheckListDocument/create/GeneralData.dart';
import 'package:maintenance/CheckListDocument/create/SearchCheckListDoc.dart';
import 'package:maintenance/Component/BackPressedWarning.dart';
import 'package:maintenance/Component/ClearTextFieldData.dart';
import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/CustomFont.dart';
import 'package:maintenance/Component/GetCurrentLocation.dart';
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/MenuDescription.dart';
import 'package:maintenance/Component/Mode.dart';
import 'package:maintenance/Component/ShowLoader.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/Dashboard.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:maintenance/Sync/SyncModels/ApprovalModel.dart';
import 'package:maintenance/Sync/SyncModels/LITPL_OOAL.dart';
import 'package:maintenance/Sync/SyncModels/MNCLD1.dart';
import 'package:maintenance/Sync/SyncModels/MNCLD2.dart';
import 'package:maintenance/Sync/SyncModels/MNOCLD.dart';
import 'package:maintenance/main.dart';
import 'package:sqflite/sqlite_api.dart';

class CheckListDocument extends StatefulWidget {
  static var address;
  static bool saveButtonPressed = false;
  int index = 0;
  static RxInt numOfTabs = RxInt(3);
  static ApprovalModel? approvalModel;

  CheckListDocument(int index, {this.onBackPressed}) {
    this.index = index;
  }

  Function? onBackPressed;

  @override
  _CheckListDocumentState createState() => _CheckListDocumentState();
}

class _CheckListDocumentState extends State<CheckListDocument> {
  
  
  

  @override
  void initState() {
    super.initState();
  }

  final key = GlobalKey<ScaffoldState>();

  _onBackButtonPressed() {
    if (GeneralData.equipmentCode != '' || CheckListDetails.items.isNotEmpty) {
      showBackPressedWarning(onBackPressed: widget.onBackPressed);
    } else if (widget.onBackPressed != null) {
      widget.onBackPressed!();
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (bool bb) async {
        await _onBackButtonPressed();
      },
      canPop: false,
      child: Obx(() => DefaultTabController(
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
                            if (CheckListDocument.numOfTabs.value == 4)
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
                        Get.to(() => SearchCheckListDoc());
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
                      onPressed: () async {
                        if (GeneralData.equipmentCode != '' ||
                            CheckListDetails.items.isNotEmpty) {
                          showBackPressedWarning(
                              text:
                                  'Your data is not saved. Are you sure you want to create new form?',
                              onBackPressed: () {
                                goToNewCheckListDocument();
                              });
                        } else {
                          goToNewCheckListDocument();
                        }
                      },
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
                    //                 GeneralData.docStatus="Cancelled";
                    //                 final db = await initializeDB(context);
                    //                 Map<String,dynamic> values={
                    //                   "docStatus":"Cancelled",
                    //                   "has_updated":1,
                    //                 };
                    //                 await db.update(MNOCLD, values, where: 'MTransId = ?', whereArgs: [GeneralData.MTransID]);
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
                  if (CheckListDocument.numOfTabs.value == 4) Container()
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


  save() async {
    //GeneralData.isSelected
    CheckListDocument.saveButtonPressed = false;
    if (DataSync.isSyncing()) {
      getErrorSnackBar(DataSync.syncingErrorMsg);
    } else {
      if (!GeneralData.validate()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid General')),
        );
      } else {
        if (!CheckListDocument.saveButtonPressed) {
          CheckListDocument.saveButtonPressed = true;
          showLoader(context);
          Position pos = await getCurrentLocation();
          print(pos.latitude.toString());
          print(pos.longitude.toString());
          String str = 'TransId = ?';

          String? data = GeneralData.transId;

          final Database db = await initializeDB(context);
          try {
            await db.transaction((database) async {
              //GENERAL DATA
              MNOCLD generalData = GeneralData.getGeneralData();
              if (!GeneralData.isSelected) {
                if (CheckListDocument.approvalModel?.Add == true &&
                    CheckListDocument.approvalModel?.Active == true) {
                  List approvalList = await GetApprovalConfiguration_Multiple(
                      db: database, docName: 'Check List Document');
                  for (int i = 0; i < approvalList.length; i++) {
                    ApprovalModel approvalModel =
                        ApprovalModel.fromJson(approvalList[i]);

                    LITPL_OOAL ooal = LITPL_OOAL(
                      Level: 1,
                      ACID: approvalModel.ACID,
                      DocID: approvalModel.DocID,
                      OUserCode: approvalModel.OUserCode,
                      OUserName: approvalModel.OUserName,
                      AUserCode: approvalModel.AUserCode,
                      AUserName: approvalModel.AUserName,
                      BranchId: userModel.BranchId.toString(),
                      CreatedBy: userModel.UserCode,
                      CreatedDate: DateTime.now(),
                      TransDocID: generalData.ID,
                      TransId: generalData.TransId,
                      DocDate: generalData.PostingDate,
                      DocStatus: generalData.DocStatus,
                      DocNum: approvalModel.DocName,
                      Approve: false,
                      Reject: false,
                      hasCreated: true,
                    );
                    if (generalData.DocStatus != 'Draft') {
                      generalData.ApprovalStatus = 'Pending';
                      await database.insert('LITPL_OOAL', ooal.toJson());
                    }
                  }
                } else {
                  generalData.ApprovalStatus = 'Approved';
                }
              }

              print(generalData.toJson());
              generalData
                  .toJson()
                  .removeWhere((key, value) => value == null || value == '');
              print(generalData.toJson());
              print(generalData);
              //CreateDate
              getSuccessSnackBar("Creating Sales Quotation...");
              generalData.CreateDate = DateTime.now();
              generalData.UpdateDate = DateTime.now();
              generalData.CreatedBy = userModel.UserCode;
              generalData.BranchId = userModel.BranchId.toString();
              generalData.hasCreated = true;
              await database.insert('MNOCLD', generalData.toJson());

              //ITEM DETAILS
              print("Item Details ");
              for (int i = 0; i < CheckListDetails.items.length; i++) {
                MNCLD1 qut1model = CheckListDetails.items[i];
                qut1model.ID = i;
                qut1model.RowId = i;
                qut1model.hasCreated = true;
                qut1model.CreateDate = DateTime.now();

                if (!qut1model.insertedIntoDatabase) {
                  qut1model.CreateDate = DateTime.now();
                  qut1model.UpdateDate = DateTime.now();

                  await database.insert('MNCLD1', qut1model.toJson());
                }
              }
              for (int i = 0; i < Attachments.attachments.length; i++) {
                MNCLD2 qut1model = Attachments.attachments[i];
                qut1model.ID = i;
                qut1model.RowId = i;
                qut1model.hasCreated = true;
                qut1model.CreateDate = DateTime.now();

                if (!qut1model.insertedIntoDatabase) {
                  qut1model.CreateDate = DateTime.now();
                  qut1model.UpdateDate = DateTime.now();

                  await database.insert('MNCLD2', qut1model.toJson());
                }
              }
            });
            goToNewCheckListDocument();
          } catch (e) {
            writeToLogFile(
                text: e.toString(),
                fileName: StackTrace.current.toString(),
                lineNo: 141);
            getErrorSnackBar("Something went wrong.\nData not saved...");
          }
        }
      }
    }
  }
}
