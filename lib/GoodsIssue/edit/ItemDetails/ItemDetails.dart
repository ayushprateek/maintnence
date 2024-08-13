import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/CustomFont.dart';
import 'package:maintenance/GoodsIssue/edit/ItemDetails/AddItems.dart';
import 'package:maintenance/GoodsIssue/edit/ItemDetails/EditItems.dart';
import 'package:maintenance/Sync/SyncModels/IMGDI1.dart';
import 'package:maintenance/Sync/SyncModels/OUOM.dart';
import 'package:maintenance/Sync/SyncModels/OWHS.dart';

class ItemDetails extends StatefulWidget {
  const ItemDetails({super.key});

  static List<IMGDI1> items = [];

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
                  Get.to(() => AddItems());
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
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
            child: Container(
              // decoration: ItemDetails.items.isNotEmpty
              decoration: true
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
                        IMGDI1 item = ItemDetails.items[index];
                        return Stack(
                          fit: StackFit.loose,
                          clipBehavior: Clip.none,
                          children: [
                            InkWell(
                              onDoubleTap: () async {
                                EditItems.id = item.ID?.toString();
                                EditItems.truckNo = item.TruckNo;
                                EditItems.toWhsCode = item.ToWhsCode;
                                List<OWHS> wareHouseList =
                                    await retrieveOWHSById(
                                        null, 'WhsCode = ?', [item.ToWhsCode]);
                                if (wareHouseList.isNotEmpty) {
                                  EditItems.toWhsName =
                                      wareHouseList[0].WhsName;
                                }
                                EditItems.driverCode = item.DriverCode;
                                EditItems.driverName = item.DriverName;
                                EditItems.routeCode = item.RouteCode;
                                EditItems.routeName = item.RouteName;
                                EditItems.transId = item.TransId;
                                EditItems.rowId = item.RowId?.toString();
                                EditItems.itemCode = item.ItemCode;
                                EditItems.itemName = item.ItemName;
                                EditItems.consumptionQty =
                                    item.Quantity?.toStringAsFixed(2);
                                EditItems.tripTransId = item.TripTransId;
                                EditItems.uomCode = item.UOM;
                                List<OUOMModel> uomList =
                                    await retrieveOUOMById(
                                        null, 'UomCode = ?', [item.UOM]);
                                if (uomList.isNotEmpty) {
                                  EditItems.uomName = uomList[0].UomName;
                                }

                                EditItems.deptCode = item.DeptCode;
                                EditItems.deptName = item.DeptName;
                                EditItems.price =
                                    item.Price?.toStringAsFixed(2);
                                EditItems.mtv = item.MSP?.toStringAsFixed(2);
                                EditItems.taxCode = item.TaxCode;
                                EditItems.taxRate =
                                    item.TaxRate?.toStringAsFixed(2);
                                EditItems.lineDiscount =
                                    item.Discount?.toStringAsFixed(2);
                                EditItems.lineTotal =
                                    item.LineTotal?.toStringAsFixed(2);

                                EditItems.isUpdating = true;
                                Get.to(() => EditItems());
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
                                                          text: 'TripTransId'),
                                                      getPoppinsTextSpanDetails(
                                                          text:
                                                              item.TripTransId ??
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
                                                          text: item.ItemName ??
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
                                                          text: 'To Warehouse'),
                                                      getPoppinsTextSpanDetails(
                                                          text: item.ToWhsCode),
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
                                                          text: item.Quantity
                                                                  ?.toStringAsFixed(
                                                                      2) ??
                                                              '0.0'),
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
                                                          text: item.UOM ?? ''),
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
                                                          text: 'TruckNo'),
                                                      getPoppinsTextSpanDetails(
                                                          text: item.TruckNo ??
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
                                                          text: 'Driver'),
                                                      getPoppinsTextSpanDetails(
                                                          text:
                                                              item.DriverName),
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
                                                          text: 'Route'),
                                                      getPoppinsTextSpanDetails(
                                                          text: item.RouteName),
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
                                                          text: 'Dept'),
                                                      getPoppinsTextSpanDetails(
                                                          text: item.DeptName),
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
                                                          text: 'Price'),
                                                      getPoppinsTextSpanDetails(
                                                          text: item.Price
                                                                  ?.toStringAsFixed(
                                                                      2) ??
                                                              '0.0'),
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
                                                          text: 'Tax Rate'),
                                                      getPoppinsTextSpanDetails(
                                                          text: item.TaxRate
                                                                  ?.toStringAsFixed(
                                                                      2) ??
                                                              '0.0'),
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
                                                              'Line Discount'),
                                                      getPoppinsTextSpanDetails(
                                                          text: item.Discount
                                                                  ?.toStringAsFixed(
                                                                      2) ??
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
                                                          text: 'Line Total'),
                                                      getPoppinsTextSpanDetails(
                                                          text: item.LineTotal
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
                    if (ItemDetails.items.isNotEmpty)
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
