import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/CustomFont.dart';
import 'package:maintenance/Component/GetFormattedDate.dart';
import 'package:maintenance/JobCard/ClearJobCardDocument.dart';
import 'package:maintenance/JobCard/create/GeneralData.dart';
import 'package:maintenance/JobCard/create/ItemDetails/AddItem.dart';
import 'package:maintenance/JobCard/create/ItemDetails/EditJobCardItem.dart';
import 'package:maintenance/Sync/SyncModels/MNJCD1.dart';
import 'package:maintenance/Sync/SyncModels/OUOM.dart';

class ItemDetails extends StatefulWidget {
  const ItemDetails({super.key});

  static List<MNJCD1> items = [];

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
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
                  // if (GeneralData.customerCode?.isEmpty==true) {
                  //   getErrorSnackBar("Please select customer to continue");
                  // } else if (GeneralData.WhsCode?.isEmpty==true) {
                  //   getErrorSnackBar("Please select WhsCode to continue");
                  // } else if (isSelectedAndCancelled() ||
                  //     isSalesQuotationDocClosed()) {
                  //   getErrorSnackBar(
                  //       "This Document is already cancelled / closed");
                  // } else
                  //   Navigator.push(context,
                  //       MaterialPageRoute(builder: ((context) => AddItems())));
                  Get.to(() => AddItem());
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
            child: Container(
              decoration: ItemDetails.items.isNotEmpty
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
                    ListView.builder(
                      itemCount: ItemDetails.items.length,
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        MNJCD1 mnjcd1 = ItemDetails.items[index];

                        return Stack(
                          fit: StackFit.loose,
                          clipBehavior: Clip.none,
                          children: [
                            InkWell(
                              onDoubleTap: () async {
                                ClearJobCardDoc.clearEditItems();
                                List<OUOMModel> uomList =
                                    await retrieveOUOMById(
                                        null, 'UomCode = ?', [mnjcd1.UOM]);
                                if (uomList.isNotEmpty) {
                                  EditJobCardItem.uomName = uomList[0].UomName;
                                }

                                EditJobCardItem.transId = GeneralData.transId;
                                EditJobCardItem.itemCode = mnjcd1.ItemCode;
                                EditJobCardItem.itemName = mnjcd1.ItemName;
                                EditJobCardItem.requiredDate =
                                    getFormattedDate(mnjcd1.RequestDate);
                                EditJobCardItem.quantity =
                                    mnjcd1.Quantity?.toStringAsFixed(2);
                                EditJobCardItem.uomCode = mnjcd1.UOM;
                                EditJobCardItem.supplierCode =
                                    mnjcd1.SupplierCode;
                                EditJobCardItem.supplierName =
                                    mnjcd1.SupplierName;
                                EditJobCardItem.fromStock = mnjcd1.IsFromStock;
                                EditJobCardItem.consumption =
                                    mnjcd1.IsConsumption;
                                EditJobCardItem.request = mnjcd1.IsRequest;
                                EditJobCardItem.isUpdating = true;
                                Get.to(() => EditJobCardItem());
                              },
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
                                  child: Row(
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
                                                          text: 'Item'),
                                                      getPoppinsTextSpanDetails(
                                                          text:
                                                              mnjcd1.ItemCode ??
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
                                                          text: 'Quantity'),
                                                      getPoppinsTextSpanDetails(
                                                          text: mnjcd1.Quantity
                                                              ?.toStringAsFixed(
                                                                  2)),
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
                                                          text: 'UOM'),
                                                      getPoppinsTextSpanDetails(
                                                          text:
                                                              mnjcd1.UOM ?? ''),
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
                                                      value: mnjcd1.IsFromStock,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          mnjcd1.IsFromStock =
                                                              !mnjcd1
                                                                  .IsFromStock;
                                                        });
                                                      },
                                                    ),
                                                    Expanded(
                                                        child: getPoppinsText(
                                                            text: 'From Stock',
                                                            textAlign: TextAlign
                                                                .start)),
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
                                                      value:
                                                          mnjcd1.IsConsumption,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          mnjcd1.IsConsumption =
                                                              !mnjcd1
                                                                  .IsConsumption;
                                                        });
                                                      },
                                                    ),
                                                    Expanded(
                                                        child: getPoppinsText(
                                                            text: 'Consumption',
                                                            textAlign: TextAlign
                                                                .start)),
                                                  ],
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
                                                  top: 4.0, bottom: 4),
                                              child: SizedBox(
                                                height: 20,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Checkbox(
                                                      value: mnjcd1.IsRequest,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          mnjcd1.IsRequest =
                                                              !mnjcd1.IsRequest;
                                                        });
                                                      },
                                                    ),
                                                    Expanded(
                                                        child: getPoppinsText(
                                                            text: 'Request',
                                                            textAlign: TextAlign
                                                                .start)),
                                                  ],
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
                                                          text: 'Supplier'),
                                                      getPoppinsTextSpanDetails(
                                                          text: mnjcd1
                                                                  .SupplierName ??
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
                                                              'Required Date'),
                                                      getPoppinsTextSpanDetails(
                                                          text: getFormattedDate(
                                                              mnjcd1
                                                                  .RequestDate)),
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
                                ),
                              ),
                            ),
                            Positioned(
                              top: -27,
                              right: -4,
                              child: Card(
                                child: IconButton(
                                    onPressed: () async {
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
                                                  ItemDetails.items
                                                      .removeAt(index);
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      ).then((value) {
                                        setState(() {});
                                      });
                                    },
                                    icon: Icon(
                                      Icons.delete_forever,
                                      color: Colors.red,
                                    )),
                              ),
                            ),
                          ],
                        );
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
