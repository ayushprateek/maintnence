import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance/CheckListDocument/edit/CheckListDetails/AddCheckList.dart';
import 'package:maintenance/Component/Common.dart';
import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/CustomFont.dart';
import 'package:maintenance/Component/DownloadFileFromServer.dart';
import 'package:maintenance/Component/GetFormattedDate.dart';
import 'package:maintenance/Component/GetTextField.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/Component/ViewFile.dart';
import 'package:maintenance/Lookups/SupplierLookup.dart';
import 'package:maintenance/Sync/SyncModels/MNCLD1.dart';
import 'package:maintenance/Sync/SyncModels/OCRD.dart';

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
            padding: const EdgeInsets.only(top: 10.0, bottom: 10),
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                child: Text(
                  "+ Add Item",
                  style: TextStyle(
                    color: barColor,
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                onPressed: () {
                  Get.to(() => AddCheckList());
                },
              ),
            ),
          ),
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

                        return InkWell(
                          // onDoubleTap: () {
                          //   if (isSelectedAndCancelled() ||
                          //       isSalesQuotationDocClosed()) {
                          //     getErrorSnackBar(
                          //         "This Document is already cancelled / closed");
                          //   } else {
                          //     EditItems.isInserted =
                          //         CheckListDetails.items[index].insertedIntoDatabase;
                          //     EditItems.TaxCode =
                          //         CheckListDetails.items[index].TaxCode.toString();
                          //     EditItems.TaxRate =
                          //         CheckListDetails.items[index].TaxRate;
                          //     Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: ((context) => EditItems(
                          //                 CheckListDetails.items[index].ID ?? 0,
                          //                 1,
                          //                 CheckListDetails.items[index].WhsCode ??
                          //                     '',
                          //                 CheckListDetails.items[index].TransId ??
                          //                     '',
                          //                 CheckListDetails.items[index].ItemCode ??
                          //                     '',
                          //                 CheckListDetails.items[index].ItemName ??
                          //                     '',
                          //                 CheckListDetails.items[index].UOM ?? '',
                          //                 CheckListDetails.items[index].TaxCode ??
                          //                     '',
                          //                 CheckListDetails.items[index].Quantity ??
                          //                     0.0,
                          //                 CheckListDetails.items[index].Price ?? 0.0,
                          //                 CheckListDetails.items[index].TaxRate ??
                          //                     0.0,
                          //                 CheckListDetails.items[index].Discount ??
                          //                     0.0,
                          //                 CheckListDetails.items[index].LineTotal ??
                          //                     0.0,
                          //                 true))));
                          //   }
                          // },
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
                            margin: const EdgeInsets.only(
                                left: 15.0, right: 15.0, bottom: 10),
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 8,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(
                                                      left: 8.0,
                                                      right: 8.0,
                                                      top: 4.0),
                                              child: Align(
                                                alignment:
                                                    Alignment.topLeft,
                                                child: Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      getPoppinsTextSpanHeading(
                                                          text:
                                                              'Equipment Code'),
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
                                              padding:
                                                  const EdgeInsets.only(
                                                      left: 8.0,
                                                      right: 8.0,
                                                      top: 4.0),
                                              child: Align(
                                                alignment:
                                                    Alignment.topLeft,
                                                child: Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      getPoppinsTextSpanHeading(
                                                          text:
                                                              'Description'),
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
                                              padding:
                                                  const EdgeInsets.only(
                                                      left: 8.0,
                                                      right: 8.0,
                                                      top: 4.0),
                                              child: Align(
                                                alignment:
                                                    Alignment.topLeft,
                                                child: Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      getPoppinsTextSpanHeading(
                                                          text:
                                                              'Item Name'),
                                                      getPoppinsTextSpanDetails(
                                                          text: mncld1
                                                                  .ItemName ??
                                                              ''),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(
                                                      left: 8.0,
                                                      right: 8.0,
                                                      top: 4.0),
                                              child: Align(
                                                alignment:
                                                    Alignment.topLeft,
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
                                              padding:
                                                  const EdgeInsets.only(
                                                      left: 8.0,
                                                      right: 8.0,
                                                      top: 4.0),
                                              child: Align(
                                                alignment:
                                                    Alignment.topLeft,
                                                child: Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      getPoppinsTextSpanHeading(
                                                          text: 'UOM'),
                                                      getPoppinsTextSpanDetails(
                                                          text:
                                                              mncld1.UOM ??
                                                                  ''),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(
                                                      top: 4.0, bottom: 4),
                                              child: SizedBox(
                                                height: 20,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .start,
                                                  children: [
                                                    Checkbox(
                                                      value: mncld1
                                                          .IsChecked,
                                                      onChanged:
                                                          (bool? value) {
                                                        setState(() {
                                                          mncld1.IsChecked =
                                                              !mncld1
                                                                  .IsChecked;
                                                        });
                                                      },
                                                    ),
                                                    Expanded(
                                                        child: getPoppinsText(
                                                            text:
                                                                'Is Checked',
                                                            textAlign:
                                                                TextAlign
                                                                    .start)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(
                                                      top: 4.0, bottom: 4),
                                              child: SizedBox(
                                                height: 20,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .start,
                                                  children: [
                                                    Checkbox(
                                                      value: mncld1
                                                          .IsFromStock,
                                                      onChanged:
                                                          (bool? value) {
                                                        setState(() {
                                                          mncld1.IsFromStock =
                                                              !mncld1
                                                                  .IsFromStock;
                                                        });
                                                      },
                                                    ),
                                                    Expanded(
                                                        child: getPoppinsText(
                                                            text:
                                                                'From Stock',
                                                            textAlign:
                                                                TextAlign
                                                                    .start)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(
                                                      top: 4.0, bottom: 4),
                                              child: SizedBox(
                                                height: 20,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .start,
                                                  children: [
                                                    Checkbox(
                                                      value: mncld1
                                                          .IsConsumption,
                                                      onChanged:
                                                          (bool? value) {
                                                        setState(() {
                                                          mncld1.IsConsumption =
                                                              !mncld1
                                                                  .IsConsumption;
                                                        });
                                                      },
                                                    ),
                                                    Expanded(
                                                        child: getPoppinsText(
                                                            text:
                                                                'Consumption',
                                                            textAlign:
                                                                TextAlign
                                                                    .start)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(
                                                      top: 4.0, bottom: 4),
                                              child: SizedBox(
                                                height: 20,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .start,
                                                  children: [
                                                    Checkbox(
                                                      value:
                                                          mncld1.IsRequest,
                                                      onChanged:
                                                          (bool? value) {
                                                        setState(() {
                                                          mncld1.IsRequest =
                                                              !mncld1
                                                                  .IsRequest;
                                                        });
                                                      },
                                                    ),
                                                    Expanded(
                                                        child: getPoppinsText(
                                                            text: 'Request',
                                                            textAlign:
                                                                TextAlign
                                                                    .start)),
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
                                              padding:
                                                  const EdgeInsets.only(
                                                      left: 8.0,
                                                      right: 8.0,
                                                      top: 4.0),
                                              child: Align(
                                                alignment:
                                                    Alignment.topLeft,
                                                child: Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      getPoppinsTextSpanHeading(
                                                          text:
                                                              'Required Date'),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: getPoppinsText(
                                                text: 'Section',
                                                fontSize: 13,
                                                textAlign: TextAlign.start,
                                                fontWeight:
                                                    FontWeight.bold)),
                                        Expanded(
                                            child: MaterialButton(
                                          onPressed: () async {
                                            if (mncld1.Attachment != null &&
                                                mncld1.Attachment != '') {
                                              File? file =
                                                  await downloadFileFromServer(
                                                      path: mncld1
                                                              .Attachment ??
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
                                              style: TextStyle(
                                                  color: barColor),
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
                                                fontWeight:
                                                    FontWeight.bold)),
                                        Expanded(
                                          child: getDisabledTextField(
                                              height: 30,
                                              controller:
                                                  TextEditingController(
                                                      text: mncld1
                                                          .SupplierName),
                                              enableLookup: true,
                                              onLookupPressed: () {
                                                Get.to(() => SupplierLookup(
                                                        onSelected: (OCRDModel
                                                            ocrdModel) async {
                                                      mncld1.SupplierCode =
                                                          ocrdModel.Code;
                                                      mncld1.SupplierName =
                                                          ocrdModel.Name;

                                                      setState(() {});
                                                    }));
                                              }),
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
                                                fontWeight:
                                                    FontWeight.bold)),
                                        Expanded(
                                            child: getTextFieldWithoutLookup(
                                                controller: mncld1
                                                    .consumptionQtyController,
                                                height: 30,
                                                labelText: '')),
                                      ],
                                    ),
                                  ),
                                  getDivider(),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: InkWell(
                                            onTap: () async {
                                              await showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    content: Container(
                                                      height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                          20,
                                                      width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                          1.5,
                                                      child: Text(
                                                        "Are you sure you want to delete this row?",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                            FontWeight.bold),
                                                      ),
                                                    ),
                                                    actions: [
                                                      MaterialButton(
                                                        // OPTIONAL BUTTON
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius.circular(40),
                                                        ),
                                                        color: barColor,
                                                        child: Text(
                                                          'No',
                                                          style: TextStyle(
                                                              color: Colors.white),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                        },
                                                      ),
                                                      MaterialButton(
                                                        // OPTIONAL BUTTON
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius.circular(40),
                                                        ),
                                                        color: Colors.red,
                                                        child: Text(
                                                          'Yes',
                                                          style: TextStyle(
                                                              color: Colors.white),
                                                        ),
                                                        onPressed: () async {
                                                          setState(() {
                                                            CheckListDetails.items
                                                                .removeAt(index);
                                                          });

                                                          Navigator.pop(context);
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: getPoppinsText(
                                                text: 'Delete',
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
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
