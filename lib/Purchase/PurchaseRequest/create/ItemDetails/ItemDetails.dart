import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/CustomFont.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/Purchase/PurchaseRequest/create/ItemDetails/AddItems.dart';
import 'package:maintenance/Purchase/PurchaseRequest/create/ItemDetails/EditItems.dart';
import 'package:maintenance/Purchase/PurchaseRequest/create/PurchaseRequest.dart';
import 'package:maintenance/Sync/SyncModels/PRPRQ1.dart';

class ItemDetails extends StatefulWidget {
  const ItemDetails({super.key});

  static List<PRPRQ1> items = [];

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
                        PRPRQ1 item = ItemDetails.items[index];

                        return Stack(
                          fit: StackFit.loose,
                          clipBehavior: Clip.none,
                          children: [
                            InkWell(
                              onDoubleTap: () {
                                if (isSelectedAndCancelled() ||
                                    isSalesQuotationDocClosed()) {
                                  getErrorSnackBar(
                                      "This Document is already cancelled / closed");
                                } else {
                                  EditItems.isInserted = ItemDetails.items[index].insertedIntoDatabase;
                                  EditItems.isUpdating =true;
                                  EditItems.id = ItemDetails.items[index].ID?.toString();
                                  EditItems.tripTransId = ItemDetails.items[index].TripTransId??'';
                                  EditItems.supplierCode = ItemDetails.items[index].SupplierCode??'';
                                  EditItems.supplierName =ItemDetails.items[index].SupplierName?? '';
                                  EditItems.truckNo = ItemDetails.items[index].TruckNo??'';
                                  EditItems.toWhsCode = ItemDetails.items[index].WhsCode??'';
                                  EditItems.toWhsName = '';
                                  EditItems.driverCode = ItemDetails.items[index].DriverCode??'';
                                  EditItems.driverName = ItemDetails.items[index].DriverName??'';
                                  EditItems.routeCode = ItemDetails.items[index].RouteCode??'';
                                  EditItems.routeName = ItemDetails.items[index].RouteName??'';
                                  EditItems.transId = ItemDetails.items[index].TransId??'';
                                  EditItems.rowId = ItemDetails.items[index].RowId?.toString()??'';
                                  EditItems.itemCode = ItemDetails.items[index].ItemCode??'';
                                  EditItems.itemName = ItemDetails.items[index].ItemName??'';
                                  EditItems.consumptionQty = ItemDetails.items[index].Quantity?.toString()??'';
                                  EditItems.uomCode = ItemDetails.items[index].UOM??'';
                                  EditItems.uomName = '';
                                  EditItems.deptCode = ItemDetails.items[index].DeptCode??'';
                                  EditItems.deptName = ItemDetails.items[index].DeptName??'';
                                  EditItems.price = ItemDetails.items[index].Price?.toStringAsFixed(2)??'';
                                  EditItems.mtv = ItemDetails.items[index].MSP?.toStringAsFixed(2)??'';
                                  EditItems.taxCode = ItemDetails.items[index].TaxCode??'';
                                  EditItems.taxRate = ItemDetails.items[index].TaxRate?.toStringAsFixed(2)??'';
                                  EditItems.lineDiscount = ItemDetails.items[index].Discount?.toStringAsFixed(2)??'';
                                  EditItems.lineTotal = ItemDetails.items[index].LineTotal?.toStringAsFixed(2)??'';
                                  
                                  
                                  Get.to(()=>EditItems());
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: ((context) => EditItems(
                                  //             ItemDetails.items[index].ID ?? 0,
                                  //             1,
                                  //             ItemDetails.items[index].WhsCode ??
                                  //                 '',
                                  //             ItemDetails.items[index].TransId ??
                                  //                 '',
                                  //             ItemDetails.items[index].ItemCode ??
                                  //                 '',
                                  //             ItemDetails.items[index].ItemName ??
                                  //                 '',
                                  //             ItemDetails.items[index].UOM ?? '',
                                  //             ItemDetails.items[index].TaxCode ??
                                  //                 '',
                                  //             ItemDetails.items[index].Quantity ??
                                  //                 0.0,
                                  //             ItemDetails.items[index].Price ?? 0.0,
                                  //             ItemDetails.items[index].TaxRate ??
                                  //                 0.0,
                                  //             ItemDetails.items[index].Discount ??
                                  //                 0.0,
                                  //             ItemDetails.items[index].LineTotal ??
                                  //                 0.0,
                                  //             true))));
                                }
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
                                                          text:
                                                              'Supplier'),
                                                      getPoppinsTextSpanDetails(
                                                          text:
                                                              item.SupplierName ??
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
                                                              'Warehouse'),
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
                                  ).then((value){
                                    setState(() {

                                    });
                                  });
                                },
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Icon(
                                      Icons.delete_forever,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
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
