import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
import 'package:maintenance/GoodsReceiptNote/Address/BillingAddress.dart';
import 'package:maintenance/GoodsReceiptNote/Address/ShippingAddress.dart';
import 'package:maintenance/GoodsReceiptNote/GeneralData.dart';
import 'package:maintenance/GoodsReceiptNote/ItemDetails/ItemDetails.dart';
import 'package:maintenance/GoodsReceiptNote/SearchGoodsReceiptNote.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:maintenance/Sync/SyncModels/PROPDN.dart';
import 'package:maintenance/Sync/SyncModels/PRPDN1.dart';
import 'package:maintenance/Sync/SyncModels/PRPDN2.dart';
import 'package:maintenance/Sync/SyncModels/PRPDN3.dart';
import 'package:maintenance/main.dart';
import 'package:sqflite/sqflite.dart';

class GoodsRecepitNote extends StatefulWidget {
  static bool saveButtonPressed = false;
  int index = 0;

  GoodsRecepitNote(int index, {this.onBackPressed}) {
    this.index = index;
  }

  Function? onBackPressed;

  @override
  _JobCardState createState() => _JobCardState();
}

class _JobCardState extends State<GoodsRecepitNote> {
  List lists = [];
  int numOfAddress = 0;
  var future_address;

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
        length: 4,
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
                        Tab(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Shipping Address",
                          ),
                        )),
                        Tab(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Billing Address",
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
                    Get.to(()=>SearchGoodsReceiptNote());
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
                            goToNewGRNDocument();
                          });
                    } else {
                      goToNewGRNDocument();
                    }
                  },
                ),
              ],
              title: getHeadingText(
                  text: "Goods Receipt Note", color: headColor, fontSize: 20)),
          body: TabBarView(
            children: [
              GeneralData(),
              ItemDetails(),
              ShippingAddress(),
              BillingAddress(),
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
    GoodsRecepitNote.saveButtonPressed = false;
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
        if (!GoodsRecepitNote.saveButtonPressed) {
          GoodsRecepitNote.saveButtonPressed = true;
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
              PROPDN generalData = GeneralData.getGeneralData();
              //todo:
              // if (!GeneralData.isSelected) {
              //   if (GoodsRecepitNote.approvalModel?.Add == true &&
              //       GoodsRecepitNote.approvalModel?.Active == true) {
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
              if (isSelectedButNotCancelled()) {
                //UpdateDate
                generalData.UpdateDate = DateTime.now();
                generalData.UpdatedBy = userModel.UserCode;
                generalData.hasUpdated = true;
                Map<String, Object?> map = generalData.toJson();
                map.removeWhere((key, value) => value == null || value == '');
                await database
                    .update('PROPDN', map, where: str, whereArgs: [data]);
                getSuccessSnackBar("Sales Quotation Updated Successfully");
              } else {
                //CreateDate
                getSuccessSnackBar("Creating Sales Quotation...");
                generalData.CreateDate = DateTime.now();
                generalData.UpdateDate = DateTime.now();
                generalData.CreatedBy = userModel.UserCode;
                generalData.BranchId = userModel.BranchId.toString();
                generalData.hasCreated = true;
                Position pos = await getCurrentLocation();
                generalData.Latitude = pos.latitude.toString();
                generalData.Longitude = pos.longitude.toString();
                await database.insert('PROPDN', generalData.toJson());
              }

              //ITEM DETAILS
              print("Item Details ");
              if (isSelectedButNotCancelled()) {
                for (int i = 0; i < ItemDetails.items.length; i++) {
                  PRPDN1 qut1model = ItemDetails.items[i];
                  qut1model.RowId = i;

                  if (!qut1model.insertedIntoDatabase) {
                    qut1model.hasCreated = true;

                    qut1model.CreateDate = DateTime.now();
                    qut1model.UpdateDate = DateTime.now();

                    await database.insert('PRPDN1', qut1model.toJson());
                  } else {
                    qut1model.hasUpdated = true;
                    qut1model.UpdateDate = DateTime.now();
                    Map<String, Object?> map = qut1model.toJson();
                    map.removeWhere(
                        (key, value) => value == null || value == '');
                    await database.update('PRPDN1', map,
                        where: 'TransId = ? AND RowId = ?',
                        whereArgs: [qut1model.TransId, qut1model.RowId]);
                  }
                }
              } 
              else {
                for (int i = 0; i < ItemDetails.items.length; i++) {
                  PRPDN1 qut1model = ItemDetails.items[i];
                  qut1model.ID = i;
                  qut1model.RowId = i;
                  qut1model.hasCreated = true;
                  qut1model.CreateDate = DateTime.now();

                  if (!qut1model.insertedIntoDatabase) {
                    qut1model.CreateDate = DateTime.now();
                    qut1model.UpdateDate = DateTime.now();

                    await database.insert('PRPDN1', qut1model.toJson());
                  }
                }
              }

              PRPDN2 shippingAddress = ShippingAddress.getShippingAddress();
              print("Shipping address= $shippingAddress");
              if (isSelectedAndCancelled() || isSalesQuotationDocClosed()) {
                //getErrorSnackBar("This Document is already cancelled / closed");
              } else if (isSelectedButNotCancelled()) {
                shippingAddress.hasUpdated = true;
                shippingAddress.UpdateDate = DateTime.now();
                Map<String, Object?> map = shippingAddress.toJson();
                map.removeWhere((key, value) => value == null || value == '');
                await database
                    .update('PRPDN2', map, where: str, whereArgs: [data]);
                getSuccessSnackBar("Sales Quotation Updated Successfully");
              } else {
                shippingAddress.CreateDate = DateTime.now();
                shippingAddress.hasCreated = true;
                shippingAddress.CreateDate = DateTime.now();
                shippingAddress.UpdateDate = DateTime.now();
                await database.insert('PRPDN2', shippingAddress.toJson());
              }
              //BILLING ADDRESS
              PRPDN3 billingAddress = BillingAddress.getBillingAddress();
              print(billingAddress);
              if (isSelectedAndCancelled() || isSalesQuotationDocClosed()) {
                //getErrorSnackBar("This Document is already cancelled / closed");
              } else if (isSelectedButNotCancelled()) {
                billingAddress.hasUpdated = true;
                billingAddress.UpdateDate = DateTime.now();
                Map<String, Object?> map = billingAddress.toJson();
                map.removeWhere((key, value) => value == null || value == '');
                await database
                    .update('PRPDN3', map, where: str, whereArgs: [data]);
                getSuccessSnackBar("Sales Quotation Updated Successfully");
              } else {
                billingAddress.CreateDate = DateTime.now();
                billingAddress.UpdateDate = DateTime.now();
                billingAddress.hasCreated = true;
                await database.insert('PRPDN3', billingAddress.toJson());
                getSuccessSnackBar("Sales Quotation Successfully Created");
              }
            });
            goToNewGRNDocument();
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
