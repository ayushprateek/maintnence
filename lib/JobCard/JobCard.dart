import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maintenance/Component/BackPressedWarning.dart';
import 'package:maintenance/Component/ClearTextFieldData.dart';
import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/CustomFont.dart';
import 'package:maintenance/Dashboard.dart';
import 'package:maintenance/JobCard/Attachment.dart';
import 'package:maintenance/JobCard/GeneralData.dart';
import 'package:maintenance/JobCard/ItemDetails.dart';
import 'package:maintenance/JobCard/ServiceDetails.dart';
import 'package:maintenance/JobCard/TyreMaintenance.dart';

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
        length: 5,
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
              Attachment(),
              TyreMaintenance(),
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
