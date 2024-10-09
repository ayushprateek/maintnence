import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maintenance/Component/BackPressedWarning.dart';
import 'package:maintenance/Component/CompanyDetails.dart';
import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/CustomFont.dart';
import 'package:maintenance/Component/GenerateTransId.dart';
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/MenuDescription.dart';
import 'package:maintenance/Component/Mode.dart';
import 'package:maintenance/Component/ShowLoader.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/Dashboard.dart';
import 'package:maintenance/DatabaseInitialization.dart';


import 'package:maintenance/JobCard/ClearJobCardDocument.dart';
import 'package:maintenance/JobCard/edit/Attachment.dart';
import 'package:maintenance/JobCard/edit/GeneralData.dart';
import 'package:maintenance/JobCard/edit/ItemDetails/ItemDetails.dart';
import 'package:maintenance/JobCard/edit/ProblemDetails.dart';
import 'package:maintenance/JobCard/edit/ServiceDetails/ServiceDetails.dart';
import 'package:maintenance/JobCard/edit/TyreMaintenance.dart';
import 'package:maintenance/JobCard/edit/WhyWhyAnalysis.dart';
import 'package:maintenance/Sync/DataSync.dart';

import 'package:maintenance/Sync/SyncModels/MNJCD1.dart';
import 'package:maintenance/Sync/SyncModels/MNJCD2.dart';
import 'package:maintenance/Sync/SyncModels/MNJCD3.dart';
import 'package:maintenance/Sync/SyncModels/MNJCD5.dart';
import 'package:maintenance/Sync/SyncModels/MNJCD6.dart';
import 'package:maintenance/Sync/SyncModels/MNOJCD.dart';
import 'package:maintenance/Sync/SyncModels/PRITR1.dart';
import 'package:maintenance/Sync/SyncModels/PROITR.dart';
import 'package:maintenance/Sync/SyncModels/PROPRQ.dart';
import 'package:maintenance/Sync/SyncModels/PRPRQ1.dart';
import 'package:maintenance/main.dart';
import 'package:sqflite/sqlite_api.dart';

class EditJobCard extends StatefulWidget {
  static bool saveButtonPressed = false;
  RxInt index = RxInt(0);

  EditJobCard(int index, {this.onBackPressed}) {
    this.index.value = index;
  }

  Function? onBackPressed;

  @override
  _EditJobCardState createState() => _EditJobCardState();
}

class _EditJobCardState extends State<EditJobCard> {
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
        length: 7,
        initialIndex: widget.index.value,
        child: Builder(builder: (BuildContext context) {
          final TabController controller = DefaultTabController.of(context);
          controller.addListener(() {
            if (!controller.indexIsChanging) {
              print(controller.index);
              if (controller.index != 1 && controller.index != 2) {
                setState(() {
                  // displaySaveButton = true;
                });
              } else {
                setState(() {
                  // displaySaveButton = false;
                });
              }
              // add code to be executed on TabBar change
            }
          });
          return Scaffold(
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
                        ],
                      ),
                    ],
                  ),
                  preferredSize: Size.fromHeight(50.0),
                ),
                // actions: [
                //   PopupMenuButton<int>(
                //     onSelected: (item) {
                //       if (item == 1) {
                //         navigateToPurchaseRequest();
                //       } else if (item == 2) {
                //         navigateToInternalRequest();
                //       } else if (item == 3) {
                //         navigateToGoodsIssue();
                //       }
                //     },
                //     itemBuilder: (context) => [
                //       const PopupMenuItem<int>(
                //           value: 1, child: Text('Purchase Request')),
                //       const PopupMenuItem<int>(
                //           value: 2, child: Text('Internal Request')),
                //       const PopupMenuItem<int>(
                //           value: 3, child: Text('Goods Issue')),
                //     ],
                //   )
                // ],
                title: getHeadingText(
                    text: "Edit Job Card", color: headColor, fontSize: 20)),
            body: TabBarView(
              children: [
                GeneralData(),
                ItemDetails(),
                ServiceDetails(),
                Attachments(),
                TyreMaintenance(),
                WhyWhyAnalysis(),
                ProblemDetails(),
              ],
            ),
            // bottomNavigationBar: getBottomNavigationBar(controller: controller),
            bottomNavigationBar: GeneralData.approvalStatus=='Approved'?
            (controller.index == 1
                ? SizedBox(
              width: Get.width,
              height: Get.height / 16,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(10.0),
                        color: barColor,
                        elevation: 0.0,
                        child: MaterialButton(
                          onPressed: () {
                            ItemDetails.createPurchaseRequest();
                          },
                          child: Text(
                            "Purchase Request",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(10.0),
                        color: barColor,
                        elevation: 0.0,
                        child: MaterialButton(
                          onPressed: () {
                            ItemDetails.createInternalRequest();
                          },
                          child: Text(
                            "Internal Request",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(10.0),
                        color: barColor,
                        elevation: 0.0,
                        child: MaterialButton(
                          onPressed: () {
                            ItemDetails.createGoodsIssue();
                          },
                          child: Text(
                            "Goods Issue",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
                : controller.index == 2
                ? SizedBox(
              width: Get.width,
              height: Get.height / 16,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(10.0),
                        color: barColor,
                        elevation: 0.0,
                        child: MaterialButton(
                          onPressed: () {
                            ServiceDetails.sendToSupplier();
                          },
                          child: Text(
                            "Send To Supplier",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(10.0),
                        color: barColor,
                        elevation: 0.0,
                        child: MaterialButton(
                          onPressed: () {
                            ServiceDetails.createPurchaseOrder();
                          },
                          child: Text(
                            "New Purchase Order",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(10.0),
                        color: barColor,
                        elevation: 0.0,
                        child: MaterialButton(
                          onPressed: () {
                            ServiceDetails.receiveFromSupplier();
                          },
                          child: Text(
                            "Receive from Supplier",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(10.0),
                        color: barColor,
                        elevation: 0.0,
                        child: MaterialButton(
                          onPressed: () {
                            ServiceDetails.createPurchaseRequest();
                          },
                          child: Text(
                            "Purchase Request",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(10.0),
                        color: barColor,
                        elevation: 0.0,
                        child: MaterialButton(
                          onPressed: () {
                            ServiceDetails.serviceConfirmation();
                          },
                          child: Text(
                            "Service Confirmation",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
                : null):null,

            floatingActionButton: FloatingActionButton(
              backgroundColor: barColor,
              tooltip: "Save Data",
              child: Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: save,
            ),
          );
        }),
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
        if (!EditJobCard.saveButtonPressed) {
          EditJobCard.saveButtonPressed = true;
          showLoader(context);

          final Database db = await initializeDB(context);
          try {
            await db.transaction((database) async {
              //GENERAL DATA
              MNOJCD generalData = GeneralData.getGeneralData();

              print(generalData.toJson());
              generalData
                  .toJson()
                  .removeWhere((key, value) => value == null || value == '');
              print(generalData.toJson());
              print(generalData);
              generalData.UpdateDate = DateTime.now();
              generalData.UpdatedBy = userModel.UserCode;
              generalData.hasUpdated = true;
              Map<String, Object?> map = generalData.toJson();
              map.removeWhere((key, value) => value == null || value == '');
              await database.update('MNOJCD', map,
                  where: 'TransId = ?', whereArgs: [GeneralData.transId]);

              //ITEM DETAILS
              print("Item Details ");

              for (int i = 0; i < ItemDetails.items.length; i++) {
                MNJCD1 qut1model = ItemDetails.items[i];
                qut1model.RowId = qut1model.RowId;

                if (!qut1model.insertedIntoDatabase) {
                  qut1model.hasCreated = true;

                  qut1model.CreateDate = DateTime.now();
                  qut1model.UpdateDate = DateTime.now();

                  await database.insert('MNJCD1', qut1model.toJson());
                } else {
                  qut1model.hasUpdated = true;
                  qut1model.UpdateDate = DateTime.now();
                  Map<String, Object?> map = qut1model.toJson();
                  map.removeWhere((key, value) => value == null || value == '');
                  await database.update('MNJCD1', map,
                      where: 'TransId = ? AND RowId = ?',
                      whereArgs: [qut1model.TransId, qut1model.RowId]);
                }
              }
              for (int i = 0; i < ServiceDetails.items.length; i++) {
                MNJCD2 qut1model = ServiceDetails.items[i];
                qut1model.RowId = qut1model.RowId;

                if (!qut1model.insertedIntoDatabase) {
                  qut1model.hasCreated = true;

                  qut1model.CreateDate = DateTime.now();
                  qut1model.UpdateDate = DateTime.now();

                  await database.insert('MNJCD2', qut1model.toJson());
                } else {
                  qut1model.hasUpdated = true;
                  qut1model.UpdateDate = DateTime.now();
                  Map<String, Object?> map = qut1model.toJson();
                  map.removeWhere((key, value) => value == null || value == '');
                  await database.update('MNJCD2', map,
                      where: 'TransId = ? AND RowId = ?',
                      whereArgs: [qut1model.TransId, qut1model.RowId]);
                }
              }

              for (int i = 0; i < Attachments.attachments.length; i++) {
                MNJCD3 qut1model = Attachments.attachments[i];
                qut1model.RowId = qut1model.RowId;

                if (!qut1model.insertedIntoDatabase) {
                  qut1model.hasCreated = true;

                  qut1model.CreateDate = DateTime.now();
                  qut1model.UpdateDate = DateTime.now();

                  await database.insert('MNJCD3', qut1model.toJson());
                } else {
                  qut1model.hasUpdated = true;
                  qut1model.UpdateDate = DateTime.now();
                  Map<String, Object?> map = qut1model.toJson();
                  map.removeWhere((key, value) => value == null || value == '');
                  await database.update('MNJCD3', map,
                      where: 'TransId = ? AND RowId = ?',
                      whereArgs: [qut1model.TransId, qut1model.RowId]);
                }
              }

              for (int i = 0; i < WhyWhyAnalysis.list.length; i++) {
                MNJCD5 qut1model = WhyWhyAnalysis.list[i];
                qut1model.Code = generalData.TransId;
                qut1model.RowId = qut1model.RowId;

                qut1model.CreateDate = DateTime.now();

                if (!qut1model.insertedIntoDatabase) {
                  qut1model.hasCreated = true;
                  qut1model.CreateDate = DateTime.now();
                  qut1model.UpdateDate = DateTime.now();

                  await database.insert('MNJCD5', qut1model.toJson());
                } else {
                  qut1model.hasUpdated = true;
                  qut1model.UpdateDate = DateTime.now();

                  await database.update('MNJCD5', qut1model.toJson(),
                      where: 'Code = ? AND RowId = ?',
                      whereArgs: [qut1model.Code, qut1model.RowId]);
                }
              }
              for (int i = 0; i < ProblemDetails.list.length; i++) {
                MNJCD6 qut1model = ProblemDetails.list[i];
                qut1model.ID = i;
                qut1model.RowId = i;

                qut1model.CreateDate = DateTime.now();

                if (!qut1model.insertedIntoDatabase) {
                  qut1model.hasCreated = true;
                  qut1model.CreateDate = DateTime.now();
                  qut1model.UpdateDate = DateTime.now();

                  await database.insert('MNJCD6', qut1model.toJson());
                } else {
                  qut1model.hasUpdated = true;
                  qut1model.UpdateDate = DateTime.now();

                  await database.update('MNJCD6', qut1model.toJson(),
                      where: 'TransId = ? AND RowId = ?',
                      whereArgs: [qut1model.TransId, qut1model.RowId]);
                }
              }
            });
            getSuccessSnackBar('Job Card updated successfully');
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
