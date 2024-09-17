import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maintenance/Component/BackPressedWarning.dart';
import 'package:maintenance/Component/CompanyDetails.dart';
import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/CustomFont.dart';
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/MenuDescription.dart';
import 'package:maintenance/Component/Mode.dart';
import 'package:maintenance/Component/ShowLoader.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/Dashboard.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/JobCard/ClearJobCardDocument.dart';
import 'package:maintenance/JobCard/create/Attachment.dart';
import 'package:maintenance/JobCard/create/GeneralData.dart';
import 'package:maintenance/JobCard/create/ItemDetails/ItemDetails.dart';
import 'package:maintenance/JobCard/create/ProblemDetails.dart';
import 'package:maintenance/JobCard/create/SearchJobCardDoc.dart';
import 'package:maintenance/JobCard/create/SectionDetails.dart';
import 'package:maintenance/JobCard/create/ServiceDetails/ServiceDetails.dart';
import 'package:maintenance/JobCard/create/TyreMaintenance.dart';
import 'package:maintenance/JobCard/create/WhyWhyAnalysis.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:maintenance/Sync/SyncModels/MNJCD1.dart';
import 'package:maintenance/Sync/SyncModels/MNJCD2.dart';
import 'package:maintenance/Sync/SyncModels/MNJCD3.dart';
import 'package:maintenance/Sync/SyncModels/MNJCD5.dart';
import 'package:maintenance/Sync/SyncModels/MNJCD6.dart';
import 'package:maintenance/Sync/SyncModels/MNOJCD.dart';
import 'package:maintenance/main.dart';
import 'package:sqflite/sqlite_api.dart';

class JobCard extends StatefulWidget {
  static bool saveButtonPressed = false;
  int index = 0;

  JobCard(int index, {this.onBackPressed}) {
    this.index = index;
  }

  Function? onBackPressed;

  @override
  _JobCardState createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  @override
  void initState() {
    super.initState();
  }

  final key = GlobalKey<ScaffoldState>();

  _onBackButtonPressed() {
    if (GeneralData.equipmentCode != '' || ItemDetails.items.isNotEmpty) {
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
      child: DefaultTabController(
        length: 8,
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
                          "Item Details",
                        )),
                        Tab(
                            child: Text(
                          "Service Details",
                        )),
                        Tab(
                            child: Text(
                          "Attachments",
                        )),
                        Tab(
                            child: Text(
                          "Tyre Maintenance",
                        )),
                        Tab(
                            child: Text(
                          "Why Why Analysis",
                        )),
                        Tab(
                            child: Text(
                          "Problem Details",
                        )),
                        Tab(
                            child: Text(
                          "Section Details",
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
                    Get.to(() => SearchJobCardDoc());
                    //showSearch(context: context, delegate: SearchJobCard());
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
                        ItemDetails.items.isNotEmpty) {
                      showBackPressedWarning(
                          text:
                              'Your data is not saved. Are you sure you want to create new form?',
                          onBackPressed: () {
                            goToNewJobCardDocument();
                          });
                    } else {
                      goToNewJobCardDocument();
                    }
                  },
                ),
                // IconButton(
                //   tooltip: "Cancel Document",
                //   icon: Icon(Icons.delete_forever,color: Colors.red,),
                //   onPressed: (){
                //     if(isSelectedAndCancelled() || isJobCardDocClosed())
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
                //                 Navigator.push(context, MaterialPageRoute(builder: (context)=>JobCard(0)));
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
                  text: "Job Card", color: headColor, fontSize: 20)),
          body: TabBarView(
            children: [
              GeneralData(),
              ItemDetails(),
              ServiceDetails(),
              Attachments(),
              TyreMaintenance(),
              WhyWhyAnalysis(),
              ProblemDetails(),
              SectionDetails(),
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
      ),
    );
  }

  bool checkWhyWhyAnalysis() {
    bool isValid = true;
    double num = double.tryParse(
            CompanyDetails.ocinModel?.NoOfWhyAnalysis?.toString() ?? "") ??
        0.0;
    if (WhyWhyAnalysis.list.length < num) {
      getErrorSnackBar('Please add at least $num Why Why Analysis');
      return false;
    }
    for (MNJCD5 mnjcd5 in WhyWhyAnalysis.list) {
      if (mnjcd5.Remarks == null || mnjcd5.Remarks?.isNotEmpty == false) {
        isValid = false;
        getErrorSnackBar('Please add remarks in all Why Why Analysis');
        break;
      }
    }
    return isValid;
  }

  save() async {
    if (!checkWhyWhyAnalysis()) {
    } else if (DataSync.isSyncing()) {
      getErrorSnackBar(DataSync.syncingErrorMsg);
    } else if (!(await Mode.isCreate(MenuDescription.salesQuotation))) {
      getErrorSnackBar("You are not authorised to create this document");
    } else {
      if (!GeneralData.validate()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid General')),
        );
      } else {
        if (!JobCard.saveButtonPressed) {
          JobCard.saveButtonPressed = true;
          showLoader(context);

          String str = 'TransId = ?';

          final Database db = await initializeDB(context);
          try {
            await db.transaction((database) async {
              //GENERAL DATA
              MNOJCD generalData = GeneralData.getGeneralData();
              //todo:
              // if (!GeneralData.isSelected) {
              //   if (JobCard.approvalModel?.Add == true &&
              //       JobCard.approvalModel?.Active == true) {
              //     List approvalList = await GetApprovalConfiguration_Multiple(
              //         db: database, docName: 'Check List Document');
              //     for (int i = 0; i < approvalList.length; i++) {
              //       ApprovalModel approvalModel =
              //       ApprovalModel.fromJson(approvalList[i]);
              //
              //       LITPL_OOAL ooal = LITPL_OOAL(
              //         Level: 1,
              //         ACID: approvalModel.ACID,
              //         DocID: approvalModel.DocID,
              //         OUserCode: approvalModel.OUserCode,
              //         OUserName: approvalModel.OUserName,
              //         AUserCode: approvalModel.AUserCode,
              //         AUserName: approvalModel.AUserName,
              //         BranchId: userModel.BranchId.toString(),
              //         CreatedBy: userModel.UserCode,
              //         CreatedDate: DateTime.now(),
              //         TransDocID: generalData.ID,
              //         TransId: generalData.TransId,
              //         DocDate: generalData.PostingDate,
              //         DocStatus: generalData.DocStatus,
              //         DocNum: approvalModel.DocName,
              //         Approve: false,
              //         Reject: false,
              //         hasCreated: true,
              //       );
              //       if (generalData.DocStatus != 'Draft') {
              //         generalData.ApprovalStatus = 'Pending';
              //         await database.insert('LITPL_OOAL', ooal.toJson());
              //       }
              //     }
              //   } else {
              //     generalData.ApprovalStatus = 'Approved';
              //   }
              // }

              print(generalData.toJson());
              generalData
                  .toJson()
                  .removeWhere((key, value) => value == null || value == '');
              print(generalData.toJson());
              print(generalData);
              generalData.CreateDate = DateTime.now();
              generalData.UpdateDate = DateTime.now();
              generalData.CreatedBy = userModel.UserCode;
              generalData.BranchId = userModel.BranchId.toString();
              generalData.hasCreated = true;
              await database.insert('MNOJCD', generalData.toJson());
              //ITEM DETAILS
              print("Item Details ");
              for (int i = 0; i < ItemDetails.items.length; i++) {
                MNJCD1 qut1model = ItemDetails.items[i];
                qut1model.ID = i;
                qut1model.RowId = i;
                qut1model.hasCreated = true;
                qut1model.CreateDate = DateTime.now();

                if (!qut1model.insertedIntoDatabase) {
                  qut1model.CreateDate = DateTime.now();
                  qut1model.UpdateDate = DateTime.now();

                  await database.insert('MNJCD1', qut1model.toJson());
                }
              }
              for (int i = 0; i < ServiceDetails.items.length; i++) {
                MNJCD2 qut1model = ServiceDetails.items[i];
                qut1model.ID = i;
                qut1model.RowId = i;
                qut1model.hasCreated = true;
                qut1model.CreateDate = DateTime.now();

                if (!qut1model.insertedIntoDatabase) {
                  qut1model.CreateDate = DateTime.now();
                  qut1model.UpdateDate = DateTime.now();

                  await database.insert('MNJCD2', qut1model.toJson());
                }
              }
              for (int i = 0; i < Attachments.attachments.length; i++) {
                MNJCD3 qut1model = Attachments.attachments[i];
                qut1model.ID = i;
                qut1model.RowId = i;
                qut1model.hasCreated = true;
                qut1model.CreateDate = DateTime.now();

                if (!qut1model.insertedIntoDatabase) {
                  qut1model.CreateDate = DateTime.now();
                  qut1model.UpdateDate = DateTime.now();

                  await database.insert('MNJCD3', qut1model.toJson());
                }
              }
              for (int i = 0; i < WhyWhyAnalysis.list.length; i++) {
                MNJCD5 qut1model = WhyWhyAnalysis.list[i];
                qut1model.ID = i;
                qut1model.RowId = i;
                qut1model.hasCreated = true;
                qut1model.CreateDate = DateTime.now();

                if (!qut1model.insertedIntoDatabase) {
                  qut1model.CreateDate = DateTime.now();
                  qut1model.UpdateDate = DateTime.now();

                  await database.insert('MNJCD5', qut1model.toJson());
                }
              }
              for (int i = 0; i < ProblemDetails.list.length; i++) {
                MNJCD6 qut1model = ProblemDetails.list[i];
                qut1model.ID = i;
                qut1model.RowId = i;
                qut1model.hasCreated = true;
                qut1model.CreateDate = DateTime.now();

                if (!qut1model.insertedIntoDatabase) {
                  qut1model.CreateDate = DateTime.now();
                  qut1model.UpdateDate = DateTime.now();

                  await database.insert('MNJCD6', qut1model.toJson());
                }
              }
              getSuccessSnackBar('Job Card created successfully');
              // for (int i = 0; i < SectionDetails.list.length; i++) {
              //   MNJCD7 qut1model = SectionDetails.list[i];
              //   qut1model.ID = i;
              //   qut1model.RowId = i;
              //   qut1model.hasCreated = true;
              //   qut1model.CreateDate = DateTime.now();
              //
              //   if (!qut1model.insertedIntoDatabase) {
              //     qut1model.CreateDate = DateTime.now();
              //     qut1model.UpdateDate = DateTime.now();
              //
              //     await database.insert('MNJCD7', qut1model.toJson());
              //   }
              // }
            });
            goToNewJobCardDocument();
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
