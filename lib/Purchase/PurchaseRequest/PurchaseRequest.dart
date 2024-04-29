import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/CustomFont.dart';
import 'package:maintenance/Dashboard.dart';
import 'package:maintenance/Purchase/PurchaseRequest/GeneralData.dart';
import 'package:maintenance/Purchase/PurchaseRequest/ItemDetails.dart';

class PurchaseRequest extends StatefulWidget {
  static bool saveButtonPressed = false;
  int index = 0;

  PurchaseRequest(int index, {this.onBackPressed}) {
    this.index = index;
  }

  Function? onBackPressed;

  @override
  _JobCardState createState() => _JobCardState();
}

class _JobCardState extends State<PurchaseRequest> {
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
                  onPressed: () {},
                  // onPressed: () async {
                  //   if (GeneralData.customerCode != '' ||
                  //       ItemDetails.items.isNotEmpty) {
                  //     showBackPressedWarning(
                  //         text:
                  //         'Your data is not saved. Are you sure you want to create new form?',
                  //         onBackPressed: () async {
                  //           await clearJobCardData();
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
                  //                     builder: (context) => PurchaseRequest(0)));
                  //           });
                  //         });
                  //   } else {
                  //     await clearJobCardData();
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
                  //               builder: (context) => PurchaseRequest(0)));
                  //     });
                  //   }
                  // },
                ),

              ],
              title: getHeadingText(
                  text: "Purchase Request", color: headColor, fontSize: 20)),
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

  save() {}

  syncWithServer() {}
}
