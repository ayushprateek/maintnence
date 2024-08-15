import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance/Component/CompanyDetails.dart';
import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/GetTextField.dart';
import 'package:maintenance/Component/IsNumeric.dart';
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/GoodsReceiptNote/edit/GoodsReceiptNote.dart';
import 'package:maintenance/GoodsReceiptNote/edit/ItemDetails/ItemDetails.dart';
import 'package:maintenance/Lookups/DepartmentLookup.dart';
import 'package:maintenance/Lookups/EmployeeLookup.dart';
import 'package:maintenance/Lookups/RoutLookup.dart';
import 'package:maintenance/Lookups/TaxLookup.dart';
import 'package:maintenance/Lookups/TripLookup.dart';
import 'package:maintenance/Lookups/UOMLookup.dart';
import 'package:maintenance/Lookups/VehicleCodeLookup.dart';
import 'package:maintenance/Lookups/WarehouseLookup.dart';
import 'package:maintenance/Sync/SyncModels/OEMP.dart';
import 'package:maintenance/Sync/SyncModels/OPOTRP.dart';
import 'package:maintenance/Sync/SyncModels/OTAX.dart';
import 'package:maintenance/Sync/SyncModels/OUDP.dart';
import 'package:maintenance/Sync/SyncModels/OUOM.dart';
import 'package:maintenance/Sync/SyncModels/OVCL.dart';
import 'package:maintenance/Sync/SyncModels/OWHS.dart';
import 'package:maintenance/Sync/SyncModels/PRPDN1.dart';
import 'package:maintenance/Sync/SyncModels/ROUT.dart';

class EditItems extends StatefulWidget {
  static String? id;
  static String? truckNo;
  static String? tripTransId;
  static String? toWhsCode;
  static String? remarks;
  static String? toWhsName;
  static String? driverCode;
  static String? driverName;
  static String? routeCode;
  static String? routeName;
  static String? transId;
  static String? rowId;
  static String? itemCode;
  static String? itemName;
  static String? consumptionQty;
  static String? uomCode;
  static String? uomName;
  static String? deptCode;
  static String? deptName;
  static String? price;
  static String? mtv;
  static String? taxCode;
  static String? taxRate;
  static String? noOfPieces;
  static String? lineDiscount;
  static String? lineTotal;

  static bool isUpdating = false;

  EditItems({
    super.key,
  });

  @override
  State<EditItems> createState() => _EditCheckListState();
}

class _EditCheckListState extends State<EditItems> {
  final TextEditingController _truckNo =
      TextEditingController(text: EditItems.truckNo);
  final TextEditingController _remarks =
      TextEditingController(text: EditItems.remarks);
  final TextEditingController _noOfPieces =
      TextEditingController(text: EditItems.noOfPieces);
  final TextEditingController _tripTransId =
      TextEditingController(text: EditItems.tripTransId);
  final TextEditingController _routeName =
      TextEditingController(text: EditItems.routeName);
  final TextEditingController _deptName =
      TextEditingController(text: EditItems.deptName);
  final TextEditingController _itemName =
      TextEditingController(text: EditItems.itemName);
  final TextEditingController _toWhs =
      TextEditingController(text: EditItems.toWhsName);
  final TextEditingController _consumptionQty =
      TextEditingController(text: EditItems.consumptionQty);
  final TextEditingController _uomCode =
      TextEditingController(text: EditItems.uomCode);
  final TextEditingController _uomName =
      TextEditingController(text: EditItems.uomName);
  final TextEditingController _driverName =
      TextEditingController(text: EditItems.driverName);
  final TextEditingController _price =
      TextEditingController(text: EditItems.price);
  final TextEditingController _mtv = TextEditingController(text: EditItems.mtv);
  final TextEditingController _taxCode =
      TextEditingController(text: EditItems.taxCode);
  final TextEditingController _taxRate =
      TextEditingController(text: EditItems.taxRate);
  final TextEditingController _lineDiscount =
      TextEditingController(text: EditItems.lineDiscount);
  final TextEditingController _lineTotal =
      TextEditingController(text: EditItems.lineTotal);

  @override
  void initState() {
    super.initState();
  }

  void calculate() {
    try {
      double qty = roundToTwoDecimal(double.tryParse(_consumptionQty.text));
      double price = roundToTwoDecimal(double.tryParse(_price.text.toString()));
      double taxRate = roundToTwoDecimal(double.tryParse(_taxRate.text));
      double discount = roundToTwoDecimal(double.tryParse(_lineDiscount.text));
      // double msp = roundToTwoDecimal(double.tryParse(EditItems.MSP.toString()));
      double msp = 0.0;
      double total_tax;
      if (CompanyDetails.ocinModel?.IsMtv == true) {
        if (price > msp) {
          total_tax = ((price * qty) - discount) * taxRate / 100;
        } else {
          total_tax = ((msp * qty) - discount) * taxRate / 100;
        }
      } else {
        total_tax = ((price * qty) - discount) * taxRate / 100;
      }
      double lineTotal = roundToTwoDecimal(total_tax);
      lineTotal += roundToTwoDecimal(price * qty - discount);
      EditItems.lineTotal = _lineTotal.text = lineTotal.toStringAsFixed(2);
      setState(() {});
    } catch (e) {
      writeToLogFile(
          text: e.toString(),
          fileName: StackTrace.current.toString(),
          lineNo: 141);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Item"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            getDisabledTextField(
                controller: _tripTransId,
                labelText: 'Trip ',
                enableLookup: true,
                onLookupPressed: () {
                  Get.to(() => TripLookup(onSelection: (OPOTRP oemp) {
                        setState(() {
                          EditItems.tripTransId =
                              _tripTransId.text = oemp.TransId ?? '';
                        });
                      }));
                }),
            getDisabledTextField(
              controller: _itemName,
              labelText: 'Item ',
              onChanged: (val) {
                EditItems.itemName = val;
              },
            ),
            getDisabledTextField(
                controller: _toWhs,
                labelText: 'Warehouse',
                enableLookup: true,
                onLookupPressed: () {
                  Get.to(() => WarehouseLookup(onSelection: (OWHS owhs) {
                        setState(() {
                          EditItems.toWhsName =
                              _toWhs.text = owhs.WhsName ?? '';
                          EditItems.toWhsCode = owhs.WhsCode ?? '';
                        });
                      }));
                }),
            getTextField(
              controller: _consumptionQty,
              labelText: 'Consumption Qty',
              onChanged: (val) {
                EditItems.consumptionQty = val;
                calculate();
              },
              keyboardType: getDecimalKeyboardType(),
              inputFormatters: [getDecimalRegEx()],
            ),
            getTextField(
              controller: _noOfPieces,
              labelText: 'No Of Pieces',
              onChanged: (val) {
                EditItems.noOfPieces = val;
                calculate();
              },
              keyboardType: getDecimalKeyboardType(),
              inputFormatters: [getDecimalRegEx()],
            ),
            getDisabledTextField(
                controller: _uomName,
                labelText: 'UOM',
                enableLookup: true,
                onLookupPressed: () {
                  Get.to(() => UOMLookup(onSelected: (OUOMModel ouomModel) {
                        setState(() {
                          EditItems.uomCode = _uomCode.text = ouomModel.UomCode;
                          EditItems.uomName = _uomName.text = ouomModel.UomName;
                        });
                      }));
                }),
            getDisabledTextField(
                controller: _truckNo,
                labelText: 'Truck No',
                enableLookup: true,
                onLookupPressed: () {
                  Get.to(() => VehicleCodeLookup(onSelected: (OVCLModel ovcl) {
                        setState(() {
                          EditItems.truckNo = _truckNo.text = ovcl.Code ?? '';
                        });
                      }));
                }),
            getDisabledTextField(
                controller: _driverName,
                labelText: 'Driver',
                enableLookup: true,
                onLookupPressed: () {
                  Get.to(() => EmployeeLookup(onSelection: (OEMPModel oemp) {
                        setState(() {
                          EditItems.driverCode = oemp.Code;
                          EditItems.driverName =
                              _driverName.text = oemp.Name ?? '';
                        });
                      }));
                }),
            getDisabledTextField(
                controller: _routeName,
                labelText: 'Route',
                enableLookup: true,
                onLookupPressed: () {
                  Get.to(() => RouteLookup(onSelected: (ROUTModel rout) {
                        setState(() {
                          EditItems.routeCode = rout.RouteCode;
                          EditItems.routeName =
                              _routeName.text = rout.RouteName ?? '';
                        });
                      }));
                }),
            getDisabledTextField(
                controller: _deptName,
                labelText: 'Department',
                enableLookup: true,
                onLookupPressed: () {
                  Get.to(() => DepartmentLookup(onSelection: (OUDP oudp) {
                        setState(() {
                          EditItems.deptCode = oudp.Code ?? '';
                          EditItems.deptName = _deptName.text = oudp.Name ?? '';
                        });
                      }));
                }),
            getTextField(
              controller: _price,
              labelText: 'Price',
              keyboardType: getDecimalKeyboardType(),
              inputFormatters: [getDecimalRegEx()],
              onChanged: (val) {
                EditItems.price = val;
                calculate();
              },
            ),
            getTextField(
              controller: _remarks,
              labelText: 'Remarks',
              onChanged: (val) {
                EditItems.remarks = val;
              },
            ),
            getDisabledTextField(
              controller: _mtv,
              labelText: 'MTV',
              onChanged: (val) {
                EditItems.mtv = val;
              },
            ),
            getDisabledTextField(
                controller: _taxCode,
                labelText: 'Tax',
                enableLookup: true,
                onLookupPressed: () {
                  Get.to(() => TaxLookup(onSelected: (OTAXModel oudp) {
                        setState(() {
                          EditItems.taxCode = _taxCode.text = oudp.TaxCode;
                          EditItems.taxRate =
                              _taxRate.text = oudp.Rate.toStringAsFixed(2);
                          calculate();
                        });
                      }));
                }),
            getDisabledTextField(
              controller: _taxRate,
              labelText: 'Tax Rate',
              onChanged: (val) {
                EditItems.taxRate = val;
              },
            ),
            getTextField(
              controller: _lineDiscount,
              labelText: 'Line Discount',
              keyboardType: getDecimalKeyboardType(),
              inputFormatters: [getDecimalRegEx()],
              onChanged: (val) {
                EditItems.lineDiscount = val;
                calculate();
              },
            ),
            getDisabledTextField(
              controller: _lineTotal,
              labelText: 'Line Total',
              onChanged: (val) {
                EditItems.lineTotal = val;
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(10.0),
                    color: barColor,
                    elevation: 0.0,
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      onPressed: () async {
                        if (_toWhs.text.isEmpty) {
                          getErrorSnackBar("To Warehouse can not be empty");
                        } else if (!isNumeric(_consumptionQty.text)) {
                          getErrorSnackBar(
                              "Consumption Quantity must be numeric");
                        } else if (double.parse(_consumptionQty.text) <= 0.0) {
                          getErrorSnackBar(
                              "Consumption Quantity can not be less that or equal to 0");
                        } else if (_uomCode.text.isEmpty) {
                          getErrorSnackBar("UOM can not be empty");
                        } else {
                          if (EditItems.isUpdating) {
                            for (int i = 0; i < ItemDetails.items.length; i++)
                              if (EditItems.itemCode ==
                                  ItemDetails.items[i].ItemCode) {
                                ItemDetails.items[i] = PRPDN1(
                                  ID: int.tryParse(EditItems.id ?? ''),
                                  TransId: EditItems.transId,
                                  RowId: ItemDetails.items[i].RowId,
                                  ItemCode: EditItems.itemCode.toString() ?? '',
                                  ItemName: EditItems.itemName.toString() ?? '',
                                  UOM: EditItems.uomCode.toString() ?? '',
                                  DeptCode: EditItems.deptCode,
                                  DeptName: EditItems.deptName,
                                  TripTransId: EditItems.tripTransId,
                                  WhsCode: EditItems.toWhsCode,
                                  Discount: double.tryParse(
                                      EditItems.lineDiscount ?? ''),
                                  DriverCode: EditItems.driverCode,
                                  DriverName: EditItems.driverName,
                                  TruckNo: EditItems.truckNo,
                                  TaxCode: EditItems.taxCode,
                                  TaxRate:
                                      double.tryParse(EditItems.taxRate ?? ''),
                                  RouteCode: EditItems.routeCode,
                                  RouteName: EditItems.routeName,
                                  Quantity: double.tryParse(
                                      EditItems.consumptionQty ?? ''),
                                  Price: double.tryParse(EditItems.price ?? ''),
                                  OpenQty: double.tryParse(
                                      EditItems.consumptionQty ?? ''),
                                  MSP: double.tryParse(EditItems.mtv ?? ''),
                                  LineTotal: double.tryParse(
                                      EditItems.lineTotal ?? ''),
                                  LineStatus: 'Open',
                                  CreateDate: DateTime.now(),
                                  NoOfPieces: double.tryParse(_noOfPieces.text),
                                  Remarks: _remarks.text,
                                  insertedIntoDatabase: false,
                                );
                              }

                            Get.offAll(() => EditGoodsRecepitNote(1));

                            getSuccessSnackBar("Check List Updated");
                          } else {
                            PRPDN1 mncld1 = PRPDN1(
                              ID: int.tryParse(EditItems.id ?? ''),
                              TransId: EditItems.transId,
                              RowId: ItemDetails.items.length,
                              ItemCode: EditItems.itemCode.toString() ?? '',
                              ItemName: EditItems.itemName.toString() ?? '',
                              UOM: EditItems.uomCode.toString() ?? '',
                              DeptCode: EditItems.deptCode,
                              DeptName: EditItems.deptName,
                              TripTransId: EditItems.tripTransId,
                              WhsCode: EditItems.toWhsCode,
                              Discount:
                                  double.tryParse(EditItems.lineDiscount ?? ''),
                              DriverCode: EditItems.driverCode,
                              DriverName: EditItems.driverName,
                              TruckNo: EditItems.truckNo,
                              TaxCode: EditItems.taxCode,
                              TaxRate: double.tryParse(EditItems.taxRate ?? ''),
                              RouteCode: EditItems.routeCode,
                              RouteName: EditItems.routeName,
                              Quantity: double.tryParse(
                                  EditItems.consumptionQty ?? ''),
                              Price: double.tryParse(EditItems.price ?? ''),
                              OpenQty: double.tryParse(
                                  EditItems.consumptionQty ?? ''),
                              MSP: double.tryParse(EditItems.mtv ?? ''),
                              LineTotal:
                                  double.tryParse(EditItems.lineTotal ?? ''),
                              LineStatus: 'Open',
                              CreateDate: DateTime.now(),
                              NoOfPieces: double.tryParse(_noOfPieces.text),
                              Remarks: _remarks.text,
                              insertedIntoDatabase: false,
                            );
                            ItemDetails.items.add(mncld1);

                            Get.offAll(() => EditGoodsRecepitNote(1));
                          }
                        }
                      },
                      child: Text(
                        "Save",
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
      ),
    );
  }
}
