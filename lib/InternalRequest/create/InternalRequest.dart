import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maintenance/Component/BackPressedWarning.dart';

import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/CustomFont.dart';
import 'package:maintenance/Component/GetCurrentLocation.dart';
import 'package:maintenance/Component/GetLiveLocation.dart';
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/MenuDescription.dart';
import 'package:maintenance/Component/Mode.dart';
import 'package:maintenance/Component/ShowLoader.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/Dashboard.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/InternalRequest/ClearInternalRequestDocument.dart';
import 'package:maintenance/InternalRequest/create/GeneralData.dart';
import 'package:maintenance/InternalRequest/create/ItemDetails/ItemDetails.dart';
import 'package:maintenance/InternalRequest/create/SearchInternalRequest.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:maintenance/Sync/SyncModels/PRITR1.dart';
import 'package:maintenance/Sync/SyncModels/PROITR.dart';
import 'package:maintenance/main.dart';
import 'package:sqflite/sqlite_api.dart';

class InternalRequest extends StatefulWidget {
  static bool saveButtonPressed = false;
  int index = 0;

  InternalRequest(int index, {this.onBackPressed}) {
    this.index = index;
  }

  Function? onBackPressed;

  @override
  InternalRequestState createState() => InternalRequestState();
}

class InternalRequestState extends State<InternalRequest> {
  @override
  void initState() {
    super.initState();
  }

  final key = GlobalKey<ScaffoldState>();

  _onBackButtonPressed() {
    if (GeneralData.deptName != '' || ItemDetails.items.isNotEmpty) {
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
        length: 2,
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
                      isScrollable: false,
                      unselectedLabelColor: Colors.white,
                      labelStyle:
                          GoogleFonts.poppins(fontWeight: FontWeight.w500),
                      tabs: [
                        Tab(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("General Data"),
                          ),
                        ),
                        Tab(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Item Details",
                          ),
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
                    Get.to(() => SearchInternalRequest());
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
                    if (GeneralData.deptName != '' ||
                        ItemDetails.items.isNotEmpty) {
                      showBackPressedWarning(
                          text:
                              'Your data is not saved. Are you sure you want to create new form?',
                          onBackPressed: () async {
                            goToNewInternalRequestDocument();
                          });
                    } else {
                      goToNewInternalRequestDocument();
                    }
                  },
                ),
              ],
              title: getHeadingText(
                  text: "Internal Request", color: headColor, fontSize: 20)),
          body: TabBarView(
            children: [
              GeneralData(),
              ItemDetails(),
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

  save() async {
    //GeneralData.isSelected
    InternalRequest.saveButtonPressed = false;
    if (DataSync.isSyncing()) {
      getErrorSnackBar(DataSync.syncingErrorMsg);
    } else if (!(await Mode.isCreate(MenuDescription.salesQuotation))) {
      getErrorSnackBar("You are not authorised to create this document");
    } else {
      if (!GeneralData.validate()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid General')),
        );
      } else {
        if (!InternalRequest.saveButtonPressed) {
          InternalRequest.saveButtonPressed = true;
          showLoader(context);
          


          final Database db = await initializeDB(context);
          try {
            await db.transaction((database) async {
              //GENERAL DATA
              PROITR generalData = GeneralData.getGeneralData();
              //todo:
              // if (!GeneralData.isSelected) {
              //   if (InternalRequest.approvalModel?.Add == true &&
              //       InternalRequest.approvalModel?.Active == true) {
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
              //CreateDate
              getSuccessSnackBar("Creating Internal Request...");
              generalData.CreateDate = DateTime.now();
              generalData.UpdateDate = DateTime.now();
              generalData.CreatedBy = userModel.UserCode;
              generalData.BranchId = userModel.BranchId.toString();
              generalData.hasCreated = true;
              
              generalData.Latitude = CustomLiveLocation.currentLocation?.latitude.toString();
              generalData.Longitude = CustomLiveLocation.currentLocation?.longitude.toString();
              await database.insert('PROITR', generalData.toJson());

              //ITEM DETAILS
              print("Item Details ");
              for (int i = 0; i < ItemDetails.items.length; i++) {
                PRITR1 qut1model = ItemDetails.items[i];
                qut1model.ID = i;
                qut1model.RowId = i;
                qut1model.hasCreated = true;
                qut1model.CreateDate = DateTime.now();

                if (!qut1model.insertedIntoDatabase) {
                  qut1model.CreateDate = DateTime.now();
                  qut1model.UpdateDate = DateTime.now();

                  await database.insert('PRITR1', qut1model.toJson());
                }
              }
            });
            goToNewInternalRequestDocument();
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
