import 'package:flutter/material.dart';
import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/CustomFont.dart';
import 'package:maintenance/Component/GetFormattedDate.dart';
import 'package:maintenance/Component/GetTextField.dart';
import 'package:maintenance/Sync/SyncModels/PROPRQ.dart';
class SearchPurchaseRequest extends StatefulWidget {
  const SearchPurchaseRequest({super.key});

  @override
  State<SearchPurchaseRequest> createState() => _SearchPurchaseRequestState();
}

class _SearchPurchaseRequestState extends State<SearchPurchaseRequest> {
  ScrollController _scrollController = ScrollController();
  TextEditingController TransId = TextEditingController();
  int _currentMax = 15;
  List myList = [];
  bool openOnly=false;

  @override
  void initState() {
    super.initState();
    myList = List.generate(15, (index) => "Item : ${index + 1}");
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
  }

  _getMoreData() {
    for (int i = _currentMax; i < _currentMax + 15; i++) {
      myList.add("Item : ${i + 1}");
    }
    _currentMax = _currentMax + 15;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: barColor,
        title: Text(
          "Check Documents",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Container(
              height: 10,
            ),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(
                    height: 25,
                  ),
                  getTextFieldWithoutLookup(
                      controller: TransId, labelText: 'Trans ID'),
                  // getTextFieldWithoutLookup(
                  //     controller: CustomerCode, labelText: 'Customer Code'),
                  // getTextFieldWithoutLookup(
                  //     controller: CustomerName, labelText: 'Customer Name'),
                  // getTextFieldWithoutLookup(
                  //     controller: EmployeeName, labelText: 'Employee Name'),
                  // Padding(
                  //   padding: const EdgeInsets.only(
                  //       bottom: 6.0, left: 8, right: 8),
                  //   child: Align(
                  //       alignment: Alignment.centerLeft,
                  //       child: Text(
                  //         "Date Range : ",
                  //         style: TextStyle(
                  //             fontWeight: FontWeight.bold,
                  //             fontFamily: custom_font),
                  //       )),
                  // ),
                  // Row(
                  //   children: [
                  //     Expanded(child: getDisabledTextFieldWithoutLookup(
                  //       controller: FromDate,
                  //       labelText: 'From Date',
                  //       onTap: () {
                  //         customCalender(context, true);
                  //       },
                  //     )),
                  //     Expanded(child: getDisabledTextFieldWithoutLookup(
                  //       controller: ToDate,
                  //       labelText: 'To Date',
                  //       onTap: () {
                  //         customCalender(context, false);
                  //       },
                  //     ),)
                  //   ],
                  // ),


                  // Padding(
                  //   padding: const EdgeInsets.only(
                  //     bottom: 6.0,
                  //     left: 8,
                  //     right: 8,
                  //   ),
                  //   child: Align(
                  //       alignment: Alignment.centerLeft,
                  //       child: Text(
                  //         "Document Range :",
                  //         style: TextStyle(
                  //             fontWeight: FontWeight.bold,
                  //             fontFamily: custom_font),
                  //       )),
                  // ),
                  // Row(
                  //   children: [
                  //     Expanded(child: getTextFieldWithoutLookup(
                  //       controller: fromDoc,
                  //       labelText: 'From Document',
                  //       keyboardType: TextInputType.number,
                  //     ),),
                  //     Expanded(child:  getTextFieldWithoutLookup(
                  //       controller: toDoc,
                  //       labelText: 'To Document',
                  //       keyboardType: TextInputType.number,
                  //     ),),
                  //   ],
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(
                  //     bottom: 6.0,
                  //     left: 8,
                  //     right: 8,
                  //   ),
                  //   child: Container(
                  //     height: MediaQuery
                  //         .of(context)
                  //         .size
                  //         .height / 16,
                  //     child: Row(
                  //       children: [
                  //         Expanded(
                  //           child: Container(
                  //             child: Text(
                  //               "Approval Status : ",
                  //               style: TextStyle(fontWeight: FontWeight.bold),
                  //             ),
                  //           ),
                  //         ),
                  //         Expanded(
                  //           flex: 2,
                  //           child: DropdownButton<String>(
                  //             items: status.map((String value) {
                  //               return DropdownMenuItem<String>(
                  //                 value: value,
                  //                 child: Text(value),
                  //               );
                  //             }).toList(),
                  //             onChanged: (val) {
                  //               setState(() {
                  //                 GeneralData.ApprovalStatus = val!;
                  //                 Status = val;
                  //               });
                  //             },
                  //             value: Status,
                  //           ),
                  //         ),
                  //         IconButton(
                  //           icon: Icon(
                  //             Icons.select_all,
                  //             color: Colors.white,
                  //           ),
                  //           onPressed: null,
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  Row(
                    children: [
                      Checkbox(
                          value: openOnly,
                          onChanged: (value) {
                            setState(() {
                              openOnly = !openOnly;
                            });
                          }),
                      Text(
                        "Open Only: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: custom_font),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width / 2.5,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              bottom: 6.0,
                              left: 8,
                              right: 8,
                            ),
                            child: Material(
                              borderRadius: BorderRadius.circular(10.0),
                              color: barColor,
                              elevation: 0.0,
                              child: MaterialButton(
                                onPressed: () async {
                                  setState(() {});
                                },
                                minWidth: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                child: Text(
                                  "Search",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            FutureBuilder(
                future: retrievePROPRQForSearch(
                    query: TransId.text, limit: _currentMax),
                builder: (context, AsyncSnapshot<List<PROPRQ>> snapshot) {
                  if (!snapshot.hasData) return Container();

                  return ListView.separated(
                    itemCount: ((TransId.text == "") &&
                        ((snapshot.data?.length ?? 0) > 31)
                        ? myList.length + 1
                        : snapshot.data?.length) ??
                        0,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      if (index == snapshot.data!.length) {
                        return Container();
                      }
                      if (index > snapshot.data!.length) {
                        return Container(
                          height: 0.0,
                          width: 0.0,
                        );
                      }
                      return InkWell(
                        onDoubleTap: (){},
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(16.0),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4.0,
                                offset: Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                          margin: const EdgeInsets.all(15),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                if (snapshot.data![index].PermanentTransId ==
                                    '' ||
                                    snapshot.data![index].PermanentTransId ==
                                        null) ...[
                                  getPoppinsText(
                                      text:
                                      "*The document isn't generated on the web.",
                                      fontSize: 13,
                                      textAlign: TextAlign.start,
                                      color: Colors.red),
                                  Divider(
                                    thickness: 1.5,
                                    color: Colors.black,
                                  ),
                                ],
                                Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            // Text.rich(
                                            //   TextSpan(
                                            //     children: [
                                            //       getPoppinsTextSpanHeading(
                                            //           text: 'ID'),
                                            //       getPoppinsTextSpanDetails(
                                            //           text: snapshot.data![index]
                                            //                           .ID ==
                                            //                       null ||
                                            //                   snapshot
                                            //                           .data![
                                            //                               index]
                                            //                           .ID ==
                                            //                       ""
                                            //               ? ""
                                            //               : snapshot
                                            //                   .data![index].ID
                                            //                   .toString()),
                                            //     ],
                                            //   ),
                                            // ),
                                            Text.rich(
                                              TextSpan(
                                                children: [
                                                  getPoppinsTextSpanHeading(
                                                      text: 'TransId'),
                                                  getPoppinsTextSpanDetails(
                                                      text: snapshot
                                                          .data![index]
                                                          .TransId ==
                                                          null ||
                                                          snapshot
                                                              .data![
                                                          index]
                                                              .TransId ==
                                                              ""
                                                          ? ""
                                                          : snapshot
                                                          .data![index]
                                                          .TransId
                                                          .toString()),
                                                ],
                                              ),
                                            ),
                                            Text.rich(
                                              TextSpan(
                                                children: [
                                                  getPoppinsTextSpanHeading(
                                                      text: 'Web TransId'),
                                                  getPoppinsTextSpanDetails(
                                                      text: snapshot
                                                          .data![index]
                                                          .PermanentTransId ==
                                                          null
                                                          ? ""
                                                          : snapshot
                                                          .data![index]
                                                          .PermanentTransId
                                                          .toString()),
                                                ],
                                              ),
                                            ),
                                            Text.rich(
                                              TextSpan(
                                                children: [
                                                  getPoppinsTextSpanHeading(
                                                      text: 'ERP DocNum'),
                                                  getPoppinsTextSpanDetails(
                                                      text: snapshot
                                                          .data![index]
                                                          .DocNum?.toString() ??
                                                          ''),
                                                ],
                                              ),
                                            ),

                                            Text.rich(
                                              TextSpan(
                                                children: [
                                                  getPoppinsTextSpanHeading(
                                                      text: 'TransId'),
                                                  getPoppinsTextSpanDetails(
                                                      text: snapshot
                                                          .data![index]
                                                          .TransId??''),
                                                ],
                                              ),
                                            ),
                                            Text.rich(
                                              TextSpan(
                                                children: [
                                                  getPoppinsTextSpanHeading(
                                                      text: 'DeptName'),
                                                  getPoppinsTextSpanDetails(
                                                      text: snapshot
                                                          .data![index].DeptName),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )),
                                    Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text.rich(
                                              TextSpan(
                                                children: [
                                                  getPoppinsTextSpanHeading(
                                                      text: 'Posting Date'),
                                                  getPoppinsTextSpanDetails(
                                                      text:  getFormattedDate(
                                                          snapshot
                                                              .data![index]
                                                              .PostingDate)),
                                                ],
                                              ),
                                            ),
                                            Text.rich(
                                              TextSpan(
                                                children: [
                                                  getPoppinsTextSpanHeading(
                                                      text: 'Valid Until'),
                                                  getPoppinsTextSpanDetails(
                                                      text:  getFormattedDate(
                                                          snapshot
                                                              .data![index]
                                                              .ValidUntill)),
                                                ],
                                              ),
                                            ),

                                            // TotalPrice(
                                            //   database: DBName.DB1,
                                            //   l: [
                                            //     snapshot.data![index].TransId
                                            //   ],
                                            //   str: "TransId = ?",
                                            // ),
                                            Text.rich(
                                              TextSpan(
                                                children: [
                                                  getPoppinsTextSpanHeading(
                                                      text: 'Document Status'),
                                                  getPoppinsTextSpanDetails(
                                                      text: snapshot
                                                          .data![index]
                                                          .DocStatus ==
                                                          null ||
                                                          snapshot
                                                              .data![
                                                          index]
                                                              .DocStatus ==
                                                              ""
                                                          ? ""
                                                          : snapshot
                                                          .data![index]
                                                          .DocStatus
                                                          .toString()),
                                                ],
                                              ),
                                            ),
                                            Text.rich(
                                              TextSpan(
                                                children: [
                                                  getPoppinsTextSpanHeading(
                                                      text: 'Approval Status'),
                                                  getPoppinsTextSpanDetails(
                                                      text: snapshot
                                                          .data![index]
                                                          .ApprovalStatus ==
                                                          null ||
                                                          snapshot
                                                              .data![
                                                          index]
                                                              .ApprovalStatus ==
                                                              ""
                                                          ? ""
                                                          : snapshot
                                                          .data![index]
                                                          .ApprovalStatus
                                                          .toString()),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      if (index == snapshot.data!.length) {
                        return Container();
                      }
                      if (index > snapshot.data!.length) {
                        return Container(
                          height: 0.0,
                          width: 0.0,
                        );
                      }
                      return Divider(
                        thickness: 1.5,
                      );
                    },
                  );
                }),
          ],
        ),
      ),
    );
  }
}
