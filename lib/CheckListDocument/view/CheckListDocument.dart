import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maintenance/CheckListDocument/view/Attachments.dart';
import 'package:maintenance/CheckListDocument/view/CheckListDetails/CheckListDetails.dart';
import 'package:maintenance/CheckListDocument/view/GeneralData.dart';
import 'package:maintenance/Component/BackPressedWarning.dart';

import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/CustomFont.dart';
import 'package:maintenance/Dashboard.dart';
import 'package:maintenance/Sync/SyncModels/ApprovalModel.dart';

class ViewCheckListDocument extends StatefulWidget {
  static var address;
  static bool saveButtonPressed = false;
  int index = 0;
  static RxInt numOfTabs = RxInt(3);
  static ApprovalModel? approvalModel;

  ViewCheckListDocument(int index, {this.onBackPressed}) {
    this.index = index;
  }

  Function? onBackPressed;

  @override
  _ViewCheckListDocumentState createState() => _ViewCheckListDocumentState();
}

class _ViewCheckListDocumentState extends State<ViewCheckListDocument> {
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
            length: ViewCheckListDocument.numOfTabs.value,
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
                            if (ViewCheckListDocument.numOfTabs.value == 4)
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
                      text: "View Check List Document",
                      color: headColor,
                      fontSize: 20)),
              body: TabBarView(
                children: [
                  GeneralData(),
                  CheckListDetails(),
                  Attachments(),
                  if (ViewCheckListDocument.numOfTabs.value == 4) Container()
                ],
              ),
              // floatingActionButton: FloatingActionButton(
              //   backgroundColor: barColor,
              //   tooltip: "Save Data",
              //   child: Text(
              //     "Save",
              //     style: TextStyle(color: Colors.white),
              //   ),
              //   onPressed: save,
              // ),
            ),
          )),
    );
  }
}
