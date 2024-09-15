import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance/Component/Common.dart';
import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/CustomFont.dart';
import 'package:maintenance/GoodsReceiptNote/edit/ItemDetails/AddItems.dart';
import 'package:maintenance/GoodsReceiptNote/edit/ItemDetails/EditItems.dart';
import 'package:maintenance/Sync/SyncModels/OUOM.dart';
import 'package:maintenance/Sync/SyncModels/OWHS.dart';
import 'package:maintenance/Sync/SyncModels/PRPDN1.dart';

class ItemDetails extends StatefulWidget {
  const ItemDetails({super.key});

  static List<PRPDN1> items = [];

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
              //todo: uncomment
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
                        PRPDN1 item = ItemDetails.items[index];

                        return InkWell(
                          onDoubleTap: () async {
                            EditItems.id = item.ID?.toString() ?? '';
                            EditItems.truckNo = item.TruckNo;
                            EditItems.tripTransId = item.TripTransId ?? '';
                            EditItems.toWhsCode = item.WhsCode ?? '';
                            EditItems.remarks = item.Remarks ?? '';
                            List<OWHS> wareHouseList =
                                await retrieveOWHSById(
                                    null, 'WhsCode = ?', [item.WhsCode]);
                            if (wareHouseList.isNotEmpty) {
                              EditItems.toWhsName =
                                  wareHouseList[0].WhsName;
                            }
                            EditItems.driverCode = item.DriverCode ?? '';
                            EditItems.driverName = item.DriverName ?? '';
                            EditItems.routeCode = item.RouteCode ?? '';
                            EditItems.routeName = item.RouteName ?? '';
                            EditItems.transId = item.TransId ?? '';
                            EditItems.rowId = item.RowId?.toString() ?? '';
                            EditItems.itemCode = item.ItemCode ?? '';
                            EditItems.itemName = item.ItemName ?? '';
                            EditItems.consumptionQty =
                                item.Quantity?.toStringAsFixed(2) ?? '';
                            EditItems.uomCode = item.UOM ?? '';
                            List<OUOMModel> uomList =
                                await retrieveOUOMById(
                                    null, 'UomCode = ?', [item.UOM]);
                            if (uomList.isNotEmpty) {
                              EditItems.uomName = uomList[0].UomName;
                            }
                            EditItems.deptCode = item.DeptCode ?? '';
                            EditItems.deptName = item.DeptName ?? '';
                            EditItems.price =
                                item.Price?.toStringAsFixed(2) ?? '';
                            EditItems.mtv =
                                item.MSP?.toStringAsFixed(2) ?? '';
                            EditItems.taxCode = item.TaxCode ?? '';
                            EditItems.taxRate =
                                item.TaxRate?.toStringAsFixed(2) ?? '';
                            EditItems.noOfPieces =
                                item.NoOfPieces?.toStringAsFixed(2) ?? '';
                            EditItems.lineDiscount =
                                item.Discount?.toStringAsFixed(2) ?? '';
                            EditItems.lineTotal =
                                item.LineTotal?.toStringAsFixed(2) ?? '';

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
                                                          text: 'Warehouse'),
                                                      getPoppinsTextSpanDetails(
                                                          text: item.WhsCode ??
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
                                                          text: item.Quantity
                                                                  ?.toStringAsFixed(
                                                                      2) ??
                                                              '0.00'),
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
                                                              item.DriverName ??
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
                                                          text: 'NoOfPieces'),
                                                      getPoppinsTextSpanDetails(
                                                          text: item.NoOfPieces
                                                                  ?.toStringAsFixed(
                                                                      2) ??
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
                                                child: Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      getPoppinsTextSpanHeading(
                                                          text: 'Route'),
                                                      getPoppinsTextSpanDetails(
                                                          text:
                                                              item.RouteName ??
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
                                                          text: 'Dept'),
                                                      getPoppinsTextSpanDetails(
                                                          text: item.DeptName ??
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
                                                          text: 'Info Price'),
                                                      getPoppinsTextSpanDetails(
                                                          text: item.Price
                                                                  ?.toStringAsFixed(
                                                                      2) ??
                                                              '0.00'),
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
                                                          text: 'Tax Code'),
                                                      getPoppinsTextSpanDetails(
                                                          text: item.TaxCode ??
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
                                                          text: 'Tax Rate'),
                                                      getPoppinsTextSpanDetails(
                                                          text: item.TaxRate
                                                                  ?.toStringAsFixed(
                                                                      2) ??
                                                              '0.00'),
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
                                                              '0.00'),
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
                                                          text: 'Remarks'),
                                                      getPoppinsTextSpanDetails(
                                                          text: item.Remarks ??
                                                              ''),
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
                                                            fontWeight: FontWeight.bold),
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
                                                          ItemDetails.items.removeAt(index);
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
