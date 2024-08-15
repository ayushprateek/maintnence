import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance/Component/Common.dart';
import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/CustomFont.dart';
import 'package:maintenance/Component/DownloadFileFromServer.dart';
import 'package:maintenance/Component/GetFormattedDate.dart';
import 'package:maintenance/Component/GetTextField.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/Component/ViewFile.dart';
import 'package:maintenance/Sync/SyncModels/MNCLD1.dart';

class CheckListDetails extends StatefulWidget {
  static List<MNCLD1> items = [];

  CheckListDetails({super.key});

  @override
  State<CheckListDetails> createState() => _CheckListDetailsState();
}

class _CheckListDetailsState extends State<CheckListDetails> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
            child: Container(
              decoration: CheckListDetails.items.isNotEmpty
                  ? BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16)))
                  : null,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    ListView.separated(
                      itemCount: CheckListDetails.items.length,
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        MNCLD1 mncld1 = CheckListDetails.items[index];

                        return Container(
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
                          margin: const EdgeInsets.only(
                              left: 15.0, right: 15.0, bottom: 10),
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 8,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0,
                                                right: 8.0,
                                                top: 4.0),
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Text.rich(
                                                TextSpan(
                                                  children: [
                                                    getPoppinsTextSpanHeading(
                                                        text: 'Equipment Code'),
                                                    getPoppinsTextSpanDetails(
                                                        text: mncld1
                                                                .EquipmentCode ??
                                                            ''),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0,
                                                right: 8.0,
                                                top: 4.0),
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Text.rich(
                                                TextSpan(
                                                  children: [
                                                    getPoppinsTextSpanHeading(
                                                        text: 'Description'),
                                                    getPoppinsTextSpanDetails(
                                                        text: mncld1
                                                                .Description ??
                                                            ''),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0,
                                                right: 8.0,
                                                top: 4.0),
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Text.rich(
                                                TextSpan(
                                                  children: [
                                                    getPoppinsTextSpanHeading(
                                                        text: 'Item Name'),
                                                    getPoppinsTextSpanDetails(
                                                        text: mncld1.ItemName ??
                                                            ''),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0,
                                                right: 8.0,
                                                top: 4.0),
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Text.rich(
                                                TextSpan(
                                                  children: [
                                                    getPoppinsTextSpanHeading(
                                                        text:
                                                            'Available Quantity'),
                                                    getPoppinsTextSpanDetails(
                                                        text: mncld1.AvailableQty
                                                                ?.toStringAsFixed(
                                                                    2) ??
                                                            '0.0'),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 8,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0,
                                                right: 8.0,
                                                top: 4.0),
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Text.rich(
                                                TextSpan(
                                                  children: [
                                                    getPoppinsTextSpanHeading(
                                                        text: 'UOM'),
                                                    getPoppinsTextSpanDetails(
                                                        text: mncld1.UOM ?? ''),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 4.0, bottom: 4),
                                            child: SizedBox(
                                              height: 20,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Checkbox(
                                                    value: mncld1.IsFromStock,
                                                    onChanged: (bool? value) {},
                                                  ),
                                                  Expanded(
                                                      child: getPoppinsText(
                                                          text: 'From Stock',
                                                          textAlign:
                                                              TextAlign.start)),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 4.0, bottom: 4),
                                            child: SizedBox(
                                              height: 20,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Checkbox(
                                                    value: mncld1.IsConsumption,
                                                    onChanged: (bool? value) {},
                                                  ),
                                                  Expanded(
                                                      child: getPoppinsText(
                                                          text: 'Consumption',
                                                          textAlign:
                                                              TextAlign.start)),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 4.0, bottom: 4),
                                            child: SizedBox(
                                              height: 20,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Checkbox(
                                                    value: mncld1.IsRequest,
                                                    onChanged: (bool? value) {},
                                                  ),
                                                  Expanded(
                                                      child: getPoppinsText(
                                                          text: 'Request',
                                                          textAlign:
                                                              TextAlign.start)),
                                                ],
                                              ),
                                            ),
                                          ),
                                          // Padding(
                                          //   padding: const EdgeInsets.only(
                                          //       left: 8.0,
                                          //       right: 8.0,
                                          //       top: 4.0),
                                          //   child: Align(
                                          //     alignment: Alignment.topLeft,
                                          //     child: Text.rich(
                                          //       TextSpan(
                                          //         children: [
                                          //           getPoppinsTextSpanHeading(
                                          //               text:
                                          //                   'Supplier Code'),
                                          //           getPoppinsTextSpanDetails(
                                          //               text: mncld1
                                          //                       .SupplierCode ??
                                          //                   ''),
                                          //         ],
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),

                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0,
                                                right: 8.0,
                                                top: 4.0),
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Text.rich(
                                                TextSpan(
                                                  children: [
                                                    getPoppinsTextSpanHeading(
                                                        text: 'Required Date'),
                                                    getPoppinsTextSpanDetails(
                                                        text: getFormattedDate(
                                                            mncld1
                                                                .RequiredDate)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0, top: 4.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          child: getPoppinsText(
                                              text: 'Section',
                                              fontSize: 13,
                                              textAlign: TextAlign.start,
                                              fontWeight: FontWeight.bold)),
                                      Expanded(
                                          child: MaterialButton(
                                        onPressed: () async {
                                          if (mncld1.Attachment != null &&
                                              mncld1.Attachment != '') {
                                            File? file =
                                                await downloadFileFromServer(
                                                    path: mncld1.Attachment ??
                                                        '');
                                            if (file != null) {
                                              Get.to(() => ViewImageFile(
                                                    file: file,
                                                  ));
                                            } else {
                                              getErrorSnackBar(
                                                  'Attachment does not exist');
                                            }
                                          } else {
                                            getErrorSnackBar(
                                                'Attachment does not exist');
                                          }
                                        },
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "View",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(color: barColor),
                                          ),
                                        ),
                                      ))
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0, top: 4.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: getPoppinsText(
                                              text: 'Supplier',
                                              textAlign: TextAlign.start,
                                              fontWeight: FontWeight.bold)),
                                      Expanded(
                                        child:
                                            getDisabledTextFieldWithoutLookup(
                                          height: 30,
                                          controller: TextEditingController(
                                              text: mncld1.SupplierName),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0, top: 4.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: getPoppinsText(
                                              text: 'Consumption Qty',
                                              textAlign: TextAlign.start,
                                              fontWeight: FontWeight.bold)),
                                      Expanded(
                                          child:
                                              getDisabledTextFieldWithoutLookup(
                                                  controller: mncld1
                                                      .consumptionQtyController,
                                                  height: 30,
                                                  labelText: '')),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return getDivider();
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 10,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
