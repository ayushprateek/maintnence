import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance/Component/Common.dart';
import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/CustomFont.dart';
import 'package:maintenance/JobCard/ClearJobCardDocument.dart';
import 'package:maintenance/JobCard/create/GeneralData.dart';
import 'package:maintenance/JobCard/create/ServiceDetails/AddServiceItem.dart';
import 'package:maintenance/JobCard/create/ServiceDetails/EditService.dart';
import 'package:maintenance/Sync/SyncModels/MNJCD2.dart';

class ServiceDetails extends StatefulWidget {
  const ServiceDetails({super.key});

  static List<MNJCD2> items = [];

  @override
  State<ServiceDetails> createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
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
                  "+ Add Service",
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
                  Get.to(() => AddServiceItem());
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
            child: Container(
              decoration: ServiceDetails.items.isNotEmpty
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
                      itemCount: ServiceDetails.items.length,
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        MNJCD2 mnjcd2 = ServiceDetails.items[index];

                        return InkWell(
                          onDoubleTap: () {
                            ClearJobCardDoc.clearEditService();
                            EditService.serviceCode = mnjcd2.ServiceCode;
                            EditService.serviceName = mnjcd2.ServiceName;
                            EditService.supplierCode = mnjcd2.SupplierCode;
                            EditService.supplierName = mnjcd2.SupplierName;
                            EditService.infoPrice =
                                mnjcd2.InfoPrice?.toStringAsFixed(2);
                            EditService.isSendable = mnjcd2.IsSendableItem;
                            EditService.isUpdating = true;
                            EditService.transId = GeneralData.transId;


                            EditService.remarks=mnjcd2.Remarks;
                            EditService.uom=mnjcd2.UOM;
                            EditService.itemCode=mnjcd2.ItemCode;
                            EditService.itemName=mnjcd2.ItemName;
                            EditService.quantity=mnjcd2.Quantity?.toStringAsFixed(2);
                            EditService.equipmentCode=mnjcd2.EquipmentCode;
                            EditService.isServiceConfirmation=mnjcd2.IsServiceConfirmation;
                            EditService.isSendToSupplier= mnjcd2.IsSendToSupplier;
                            EditService.isReceiveFromSupplier= mnjcd2.IsReceiveFromSupplier;
                            EditService.isPurchaseRequest= mnjcd2.IsPurchaseRequest;
                            EditService.isPurchaseOrder= mnjcd2.IsPurchaseOrder;

                            Get.to(() => EditService());
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
                                                          text: 'Equipment'),
                                                      getPoppinsTextSpanDetails(
                                                          text: mnjcd2
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
                                                          text: 'Service'),
                                                      getPoppinsTextSpanDetails(
                                                          text: mnjcd2
                                                                  .ServiceName ??
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
                                                          text: 'Item'),
                                                      getPoppinsTextSpanDetails(
                                                          text:
                                                              mnjcd2.ItemName ??
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
                                                          text: 'Supplier'),
                                                      getPoppinsTextSpanDetails(
                                                          text: mnjcd2
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
                                                          text: 'Quantity'),
                                                      getPoppinsTextSpanDetails(
                                                          text: mnjcd2.Quantity
                                                                  ?.toStringAsFixed(
                                                                      2) ??
                                                              '0'),
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
                                                          text: 'InfoPrice'),
                                                      getPoppinsTextSpanDetails(
                                                          text: mnjcd2.InfoPrice
                                                                  ?.toStringAsFixed(
                                                                      2) ??
                                                              '0'),
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
                                                          text: 'Remarks'),
                                                      getPoppinsTextSpanDetails(
                                                          text:
                                                              mnjcd2.Remarks ??
                                                                  ''),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 9,
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
                                                      value:
                                                          mnjcd2.IsSendableItem,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          mnjcd2.IsSendableItem =
                                                              !mnjcd2
                                                                  .IsSendableItem;
                                                        });
                                                      },
                                                    ),
                                                    Expanded(
                                                        child: getPoppinsText(
                                                            text:
                                                                'Sendable Item',
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
                                                      value: mnjcd2
                                                          .IsSendToSupplier,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          mnjcd2.IsSendToSupplier =
                                                              !mnjcd2
                                                                  .IsSendToSupplier;
                                                        });
                                                      },
                                                    ),
                                                    Expanded(
                                                        child: getPoppinsText(
                                                            text:
                                                                'Send To Supplier',
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
                                                      value: mnjcd2
                                                          .IsReceiveFromSupplier,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          mnjcd2.IsReceiveFromSupplier =
                                                              !mnjcd2
                                                                  .IsReceiveFromSupplier;
                                                        });
                                                      },
                                                    ),
                                                    Expanded(
                                                        child: getPoppinsText(
                                                            text:
                                                                'Receive From Supplier',
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
                                                      value: mnjcd2
                                                          .IsPurchaseRequest,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          mnjcd2.IsPurchaseRequest =
                                                              !mnjcd2
                                                                  .IsPurchaseRequest;
                                                        });
                                                      },
                                                    ),
                                                    Expanded(
                                                        child: getPoppinsText(
                                                            text:
                                                                'Purchase Request',
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
                                                      value: mnjcd2
                                                          .IsPurchaseOrder,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          mnjcd2.IsPurchaseOrder =
                                                              !mnjcd2
                                                                  .IsPurchaseOrder;
                                                        });
                                                      },
                                                    ),
                                                    Expanded(
                                                        child: getPoppinsText(
                                                            text:
                                                                'Purchase Order',
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
                                                      value: mnjcd2
                                                          .IsServiceConfirmation,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          mnjcd2.IsServiceConfirmation =
                                                              !mnjcd2
                                                                  .IsServiceConfirmation;
                                                        });
                                                      },
                                                    ),
                                                    Expanded(
                                                        child: getPoppinsText(
                                                            text:
                                                                'Service Confirmation',
                                                            textAlign: TextAlign
                                                                .start)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
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
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40),
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
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40),
                                                    ),
                                                    color: Colors.red,
                                                    child: Text(
                                                      'Yes',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    onPressed: () async {
                                                      Navigator.pop(context);
                                                      setState(() {
                                                        ServiceDetails.items
                                                            .removeAt(index);
                                                      });
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
