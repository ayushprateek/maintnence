import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maintenance/ApprovalStatus/ApprovalListUIComponent.dart';
import 'package:maintenance/CheckListDocument/edit/Attachments.dart';
import 'package:maintenance/CheckListDocument/edit/CheckListDetails/CheckListDetails.dart';
import 'package:maintenance/CheckListDocument/edit/GeneralData.dart';
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

class EditCheckListDocument extends StatefulWidget {
  static var address;
  static bool saveButtonPressed = false;
  int index = 0;
  static RxInt numOfTabs = RxInt(3);
  static ApprovalModel? approvalModel;

  EditCheckListDocument(int index, {this.onBackPressed}) {
    this.index = index;
  }

  Function? onBackPressed;

  @override
  _EditCheckListDocumentState createState() => _EditCheckListDocumentState();
}

class _EditCheckListDocumentState extends State<EditCheckListDocument> {
  List lists = [];
  int numOfAddress = 0;
  var future_address;

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
            length: EditCheckListDocument.numOfTabs.value,
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
                            if (EditCheckListDocument.numOfTabs.value == 4)
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
                  title: getHeadingText(
                      text: "Edit Check List Document",
                      color: headColor,
                      fontSize: 20)),
              body: TabBarView(
                children: [
                  GeneralData(),
                  CheckListDetails(),
                  Attachments(),
                  if (EditCheckListDocument.numOfTabs.value == 4) Container()
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

  bool isSelectedAndCancelled() {
    bool flag = GeneralData.isSelected && GeneralData.docStatus == "Cancelled";
    flag = flag || GeneralData.docStatus == "Close";
    return flag;
  }

  bool isSalesQuotationDocClosed() {
    return GeneralData.docStatus == null
        ? false
        : (GeneralData.docStatus!.toUpperCase().contains('CLOSE') ||
            GeneralData.approvalStatus != 'Pending');
  }

  bool isSelectedButNotCancelled() {
    return GeneralData.isSelected && GeneralData.docStatus != "Cancelled";
  }

  save() async {
    //GeneralData.isSelected
    EditCheckListDocument.saveButtonPressed = false;
    if (DataSync.isSyncing()) {
      getErrorSnackBar(DataSync.syncingErrorMsg);
    } else if (isSelectedAndCancelled()) {
      getErrorSnackBar("This Document is already cancelled / closed");
    } else if (!isSelectedButNotCancelled() &&
        !(await Mode.isCreate(MenuDescription.salesQuotation))) {
      getErrorSnackBar("You are not authorised to create this document");
    } else if (isSelectedButNotCancelled() &&
        !(await Mode.isEdit(MenuDescription.salesQuotation))) {
      getErrorSnackBar("You are not authorised to edit this document");
    } else {
      if (!GeneralData.validate()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid General')),
        );
      } else {
        if (!EditCheckListDocument.saveButtonPressed) {
          EditCheckListDocument.saveButtonPressed = true;
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


              print(generalData.toJson());
              generalData
                  .toJson()
                  .removeWhere((key, value) => value == null || value == '');
              print(generalData.toJson());
              print(generalData);
              //UpdateDate
              generalData.UpdateDate = DateTime.now();
              generalData.UpdatedBy = userModel.UserCode;
              generalData.hasUpdated = true;
              Map<String, Object?> map = generalData.toJson();
              map.removeWhere((key, value) => value == null || value == '');
              await database
                  .update('MNOCLD', map, where: str, whereArgs: [data]);

              //ITEM DETAILS
              print("Item Details ");
              for (int i = 0; i < CheckListDetails.items.length; i++) {
                MNCLD1 qut1model = CheckListDetails.items[i];
                qut1model.RowId = CheckListDetails.items[i].RowId;

                if (!qut1model.insertedIntoDatabase) {
                  qut1model.hasCreated = true;

                  qut1model.CreateDate = DateTime.now();
                  qut1model.UpdateDate = DateTime.now();

                  await database.insert('MNCLD1', qut1model.toJson());
                } else {
                  qut1model.hasUpdated = true;
                  qut1model.UpdateDate = DateTime.now();
                  Map<String, Object?> map = qut1model.toJson();
                  map.removeWhere(
                          (key, value) => value == null || value == '');
                  await database.update('MNCLD1', map,
                      where: 'TransId = ? AND RowId = ?',
                      whereArgs: [qut1model.TransId, qut1model.RowId]);
                }
              }

              for (int i = 0; i < Attachments.attachments.length; i++) {
                MNCLD2 qut1model = Attachments.attachments[i];
                qut1model.RowId = i;

                if (!qut1model.insertedIntoDatabase) {
                  qut1model.hasCreated = true;

                  qut1model.CreateDate = DateTime.now();
                  qut1model.UpdateDate = DateTime.now();

                  await database.insert('MNCLD2', qut1model.toJson());
                } else {
                  qut1model.hasUpdated = true;
                  qut1model.UpdateDate = DateTime.now();
                  Map<String, Object?> map = qut1model.toJson();
                  map.removeWhere(
                          (key, value) => value == null || value == '');
                  await database.update('MNCLD2', map,
                      where: 'TransId = ? AND RowId = ?',
                      whereArgs: [qut1model.TransId, qut1model.RowId]);
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
