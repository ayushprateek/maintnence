import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance/Component/CompanyDetails.dart';
import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/GetTextField.dart';
import 'package:maintenance/Component/IsNumeric.dart';
import 'package:maintenance/Component/ItemModel.dart';
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/GoodsIssue/edit/GeneralData.dart';
import 'package:maintenance/GoodsIssue/edit/GoodsIssue.dart';
import 'package:maintenance/GoodsIssue/edit/ItemDetails/CalculateGoodIssue.dart';
import 'package:maintenance/GoodsIssue/edit/ItemDetails/ItemDetails.dart';
import 'package:maintenance/Lookups/DepartmentLookup.dart';
import 'package:maintenance/Lookups/EmployeeLookup.dart';
import 'package:maintenance/Lookups/RoutLookup.dart';
import 'package:maintenance/Lookups/TaxLookup.dart';
import 'package:maintenance/Lookups/UOMLookup.dart';
import 'package:maintenance/Lookups/VehicleCodeLookup.dart';
import 'package:maintenance/Lookups/WarehouseLookup.dart';
import 'package:maintenance/Sync/SyncModels/IMGDI1.dart';
import 'package:maintenance/Sync/SyncModels/OEMP.dart';
import 'package:maintenance/Sync/SyncModels/OTAX.dart';
import 'package:maintenance/Sync/SyncModels/OUDP.dart';
import 'package:maintenance/Sync/SyncModels/OUOM.dart';
import 'package:maintenance/Sync/SyncModels/OVCL.dart';
import 'package:maintenance/Sync/SyncModels/OWHS.dart';
import 'package:maintenance/Sync/SyncModels/ROUT.dart';

class EditItems extends StatefulWidget {
  static String? id;
  static String? truckNo;
  static String? toWhsCode;
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
  bool isSet = false;

  @override
  void initState() {
    super.initState();
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
            FutureBuilder(
                future: retrieveAssignedItems(
                    priceListCode: GeneralData.priceListCode ?? '',
                    itemCode: EditItems.itemCode,
                    WhsCode: GeneralData.toWhsCode ?? ''),
                builder: (BuildContext context,
                    AsyncSnapshot<List<AssignedItemsModel>> snapshot) {
                  if (snapshot.hasData && snapshot.data?.isNotEmpty==true) {
                    // MSP.text=snapshot.data![0].MSP.toString();
                    // EditItems.MSP=snapshot.data![0].MSP;
                    try {
                      if (!isSet) {
                        isSet = true;
                        if (CompanyDetails.ocinModel?.IsMtv == true) {
                          _mtv.text = snapshot.data![0].MSP.toString();
                          EditItems.mtv = snapshot.data![0].MSP.toStringAsFixed(2);
                        }

                        if (!EditItems.isUpdating) {
                          _price.text = snapshot.data![0].Price.toString();
                          EditItems.price = snapshot.data![0].Price.toStringAsFixed(2);
                          _taxCode.text =
                              snapshot.data![0].TaxCode.toString();
                          EditItems.taxCode = snapshot.data![0].TaxCode;
                          _taxRate.text =
                              snapshot.data![0].TaxRate.toString();
                          EditItems.taxRate = snapshot.data![0].TaxRate.toStringAsFixed(2);
                        }

                        // EditItems.WhsCode = snapshot.data![0].WhsCode.toString();
                        // EditItems.WhsCode = snapshot.data![0].WhsCode;
                      }
                    } catch (e) {
                      writeToLogFile(
                          text: e.toString(),
                          fileName: StackTrace.current.toString(),
                          lineNo: 141);
                      print(e.toString());
                      _mtv.text = "0.0";
                      EditItems.mtv = '0.0';
                      return AlertDialog(
                        content: Text(
                            "ItemCode : ${_itemName.text} and CustomerCode : ${GeneralData.requestedName} does not exist.Please update the price"),
                        title: Text("Error"),
                      );
                    }
                  }
                  return Column(
                    children: [
                      getDisabledTextField(controller: _itemName, labelText: 'Item ',
                        onChanged: (val) {
                          EditItems.itemName  = val;
                        },),
                      getDisabledTextField(
                          controller: _toWhs,
                          labelText: 'To Warehouse',
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
                                EditItems.truckNo = _truckNo.text = ovcl.Code??'';
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
                        onChanged: (val) {
                          EditItems.price  = val;
                        },
                        keyboardType: getDecimalKeyboardType(),
                        inputFormatters: [getDecimalRegEx()],
                      ),
                      getDisabledTextField(
                        controller: _mtv,
                        labelText: 'MTV',
                        onChanged: (val) {
                          EditItems.mtv  = val;
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
                              });
                            }));
                          }),
                      getDisabledTextField(
                        controller: _taxRate,
                        labelText: 'Tax Rate',
                        onChanged: (val) {
                          EditItems.taxRate  = val;
                        },
                      ),
                      getTextField(
                        controller: _lineDiscount,
                        labelText: 'Line Discount',
                        onChanged: (val) {
                          EditItems.lineDiscount  = val;
                        },
                        keyboardType: getDecimalKeyboardType(),
                        inputFormatters: [getDecimalRegEx()],
                      ),
                      getDisabledTextField(
                        controller: _lineTotal,
                        labelText: 'Line Total',
                        onChanged: (val) {
                          EditItems.lineTotal  = val;
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
                                          ItemDetails.items[i].UOM = EditItems.uomCode;
                                          //todo: updating
                                        }

                                      calculateGoodsIssue();
                                      Get.offAll(() => EditGoodsIssue(1));

                                      getSuccessSnackBar("Check List Updated");
                                    } else {
                                      IMGDI1 mncld1 = IMGDI1(
                                        ID: int.tryParse(EditItems.id ?? ''),
                                        TransId: EditItems.transId,
                                        RowId: ItemDetails.items.length,
                                        ItemCode: EditItems.itemCode.toString() ?? '',
                                        ItemName: EditItems.itemName.toString() ?? '',
                                        UOM: EditItems.uomCode.toString() ?? '',
                                        DeptCode: EditItems.deptCode,
                                        DeptName: EditItems.deptName,
                                        ToWhsCode: EditItems.toWhsCode,
                                        TripTransId: GeneralData.tripTransId,
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
                                        insertedIntoDatabase: false,
                                      );
                                      calculateGoodsIssue();
                                      ItemDetails.items.add(mncld1);

                                      Get.offAll(() => EditGoodsIssue(1));
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
                  );
                }),

          ],
        ),
      ),
    );
  }
}
