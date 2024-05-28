import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/CustomFont.dart';
import 'package:maintenance/JobCard/ServiceDetails/AddServiceItem.dart';
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

                        return Stack(
                          fit: StackFit.loose,
                          clipBehavior: Clip.none,
                          children: [
                            InkWell(
                              // onDoubleTap: () {
                              //   if (isSelectedAndCancelled() ||
                              //       isSalesQuotationDocClosed()) {
                              //     getErrorSnackBar(
                              //         "This Document is already cancelled / closed");
                              //   } else {
                              //     EditItems.isInserted =
                              //         ItemDetails.items[index].insertedIntoDatabase;
                              //     EditItems.TaxCode =
                              //         ItemDetails.items[index].TaxCode.toString();
                              //     EditItems.TaxRate =
                              //         ItemDetails.items[index].TaxRate;
                              //     Navigator.push(
                              //         context,
                              //         MaterialPageRoute(
                              //             builder: ((context) => EditItems(
                              //                 ItemDetails.items[index].ID ?? 0,
                              //                 1,
                              //                 ItemDetails.items[index].WhsCode ??
                              //                     '',
                              //                 ItemDetails.items[index].TransId ??
                              //                     '',
                              //                 ItemDetails.items[index].ItemCode ??
                              //                     '',
                              //                 ItemDetails.items[index].ItemName ??
                              //                     '',
                              //                 ItemDetails.items[index].UOM ?? '',
                              //                 ItemDetails.items[index].TaxCode ??
                              //                     '',
                              //                 ItemDetails.items[index].Quantity ??
                              //                     0.0,
                              //                 ItemDetails.items[index].Price ?? 0.0,
                              //                 ItemDetails.items[index].TaxRate ??
                              //                     0.0,
                              //                 ItemDetails.items[index].Discount ??
                              //                     0.0,
                              //                 ItemDetails.items[index].LineTotal ??
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
                                                          text: 'Service Name'),
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
                                                          text:
                                                              'Supplier Name'),
                                                      getPoppinsTextSpanDetails(
                                                          text: mnjcd2
                                                                  .SupplierName ??
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
                                                child: FittedBox(
                                                  fit: BoxFit.contain,
                                                  child: Text.rich(
                                                    TextSpan(
                                                      children: [
                                                        getPoppinsTextSpanHeading(
                                                            text: 'Info Price'),
                                                        getPoppinsTextSpanDetails(
                                                            text: mnjcd2.InfoPrice
                                                                    ?.toStringAsFixed(
                                                                        2) ??
                                                                '0.0'),
                                                      ],
                                                    ),
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
                                                                'Is Sendable Item',
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
                                                  Navigator.pop(context);
                                                  setState(() {
                                                    ServiceDetails.items.removeAt(index);
                                                  });
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
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
