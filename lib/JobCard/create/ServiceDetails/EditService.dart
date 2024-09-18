import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/GetTextField.dart';
import 'package:maintenance/Component/IsNumeric.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/JobCard/create/JobCard.dart';
import 'package:maintenance/JobCard/create/ServiceDetails/ServiceDetails.dart';
import 'package:maintenance/Lookups/EquipmentCodeLokup.dart';
import 'package:maintenance/Lookups/ItemLookup.dart';
import 'package:maintenance/Lookups/SupplierLookup.dart';
import 'package:maintenance/Sync/SyncModels/MNJCD2.dart';
import 'package:maintenance/Sync/SyncModels/OCRD.dart';
import 'package:maintenance/Sync/SyncModels/OITM.dart';
import 'package:maintenance/Sync/SyncModels/OVCL.dart';

class EditService extends StatefulWidget {
  static String? id;
  static String? transId;
  static String? rowId;
  static String? serviceCode;
  static String? serviceName;
  static String? infoPrice;

  static String? supplierName;
  static String? supplierCode;


  static String? remarks;
  static String? uom;
  static String? itemCode;
  static String? itemName;
  static String? quantity;
  static String? equipmentCode;
  // static String? equipmentName;

  static bool isSendable = false;

  static bool isServiceConfirmation=false;
  static bool isSendToSupplier= false;
  static bool isReceiveFromSupplier= false;
  static bool isPurchaseRequest= false;
  static bool isPurchaseOrder= false;

  static bool isUpdating = false;

  EditService({
    super.key,
  });

  @override
  State<EditService> createState() => _EditServiceState();
}

class _EditServiceState extends State<EditService> {
  final TextEditingController _serviceCode =
      TextEditingController(text: EditService.serviceCode);
  final TextEditingController _serviceName =
      TextEditingController(text: EditService.serviceName);
  final TextEditingController _supplierName =
      TextEditingController(text: EditService.supplierName);
  final TextEditingController _supplierCode =
      TextEditingController(text: EditService.supplierCode);

  final TextEditingController _infoPrice =
      TextEditingController(text: EditService.infoPrice);

  final TextEditingController _remarks =
  TextEditingController(text: EditService.remarks);
  final TextEditingController _uom =
  TextEditingController(text: EditService.uom);
  final TextEditingController _itemCode =
  TextEditingController(text: EditService.itemCode);
  final TextEditingController _itemName =
  TextEditingController(text: EditService.itemName);
  final TextEditingController _quantity =
  TextEditingController(text: EditService.quantity);
  final TextEditingController _equipmentCode =
  TextEditingController(text: EditService.equipmentCode);
  // final TextEditingController _equipmentName =
  // TextEditingController(text: EditService.equipmentName);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Service"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),

            // getDisabledTextField(
            //     controller: _serviceCode,
            //     labelText: 'Service Code',
            //     onChanged: (val) {
            //       EditService.serviceCode = val;
            //     }),

            getDisabledTextField(
              controller: _equipmentCode,
              labelText: 'Equipment Code',
              onChanged: (val) {
                EditService.equipmentCode = val;
              },
              enableLookup: true,
              onLookupPressed: (){
                Get.to(() => EquipmentCodeLookup(
                  onSelection: (OVCLModel ovcl) {
                    setState(() {
                      EditService.equipmentCode =
                          _equipmentCode.text = ovcl.Code ?? '';
                      // EditService.equipmentName =
                      //     _equipmentName.text = ovcl.Name ?? '';
                    });
                  },
                ));
              }
            ),
            getDisabledTextField(
              controller: _serviceName,
              labelText: 'Service Name',
              onChanged: (val) {
                EditService.serviceName = val;
              },
            ),

            // getDisabledTextField(
            //     controller: _supplierCode,
            //     labelText: 'Supplier Code',
            //     ),
            getDisabledTextField(
                controller: _supplierName,
                labelText: 'Supplier',
                enableLookup: true,
                onLookupPressed: () {
                  Get.to(
                      () => SupplierLookup(onSelected: (OCRDModel ocrdModel) {
                            setState(() {
                              EditService.supplierCode =
                                  _supplierCode.text = ocrdModel.Code;
                              EditService.supplierName =
                                  _supplierName.text = ocrdModel.Name ?? '';
                            });
                          }));
                }),

            getDisabledTextField(
                controller: _itemName,
                labelText: 'Item',
                enableLookup: true,
                onLookupPressed: () {
                  Get.to(
                      () => ItemLookup(onSelection: (OITMModel oitmModel) {
                            setState(() {
                              EditService.itemCode =
                                  _itemCode.text = oitmModel.ItemCode;
                              EditService.itemName =
                                  _itemName.text = oitmModel.ItemName ?? '';
                            });
                          }));
                }),
            getTextField(
              controller: _quantity,
              labelText: 'Quantity',
              onChanged: (val) {
                EditService.quantity = val;
              },
              keyboardType: getDecimalKeyboardType(),
              inputFormatters: [getDecimalRegEx()],
            ),
            getTextField(
              controller: _infoPrice,
              labelText: 'Info Price',
              onChanged: (val) {
                EditService.infoPrice = val;
              },
              keyboardType: getDecimalKeyboardType(),
              inputFormatters: [getDecimalRegEx()],
            ),
            getTextField(
              controller: _remarks,
              labelText: 'Remarks',
              onChanged: (val) {
                EditService.remarks = val;
              },
            ),
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              value: EditService.isSendable,
              onChanged: (bool? val) {
                setState(() {
                  EditService.isSendable = val ?? !EditService.isSendable;
                });
              },
              title: Text('Is Sendable'),
            ),
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              value: EditService.isSendToSupplier,
              onChanged: (bool? val) {
                setState(() {
                  EditService.isSendToSupplier = val ?? !EditService.isSendToSupplier;
                });
              },
              title: Text('Is Send ToSupplier'),
            ),
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              value: EditService.isReceiveFromSupplier,
              onChanged: (bool? val) {
                setState(() {
                  EditService.isReceiveFromSupplier = val ?? !EditService.isReceiveFromSupplier;
                });
              },
              title: Text('Is Receive FromSupplier'),
            ),
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              value: EditService.isPurchaseRequest,
              onChanged: (bool? val) {
                setState(() {
                  EditService.isPurchaseRequest = val ?? !EditService.isPurchaseRequest;
                });
              },
              title: Text('Is Purchase Request'),
            ),
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              value: EditService.isPurchaseOrder,
              onChanged: (bool? val) {
                setState(() {
                  EditService.isPurchaseOrder = val ?? !EditService.isPurchaseOrder;
                });
              },
              title: Text('Is Purchase Order'),
            ),
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              value: EditService.isServiceConfirmation,
              onChanged: (bool? val) {
                setState(() {
                  EditService.isServiceConfirmation = val ?? !EditService.isServiceConfirmation;
                });
              },
              title: Text('Is Service Confirmation'),
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
                        if (!isNumeric(_infoPrice.text)) {
                          getErrorSnackBar(
                              "Consumption Quantity must be numeric");
                        } else if (double.parse(_infoPrice.text) <= 0.0) {
                          getErrorSnackBar(
                              "Consumption Quantity can not be less that or equal to 0");
                        } else if (_supplierCode.text.isEmpty) {
                          getErrorSnackBar("Supplier can not be empty");
                        } else {
                          if (EditService.isUpdating) {
                            for (int i = 0;
                                i < ServiceDetails.items.length;
                                i++)
                              if (EditService.serviceCode ==
                                  ServiceDetails.items[i].ServiceCode) {
                                MNJCD2 mncld1 = MNJCD2(
                                    ID: int.tryParse(EditService.id ?? ''),
                                    TransId: EditService.transId,

                                    IsServiceConfirmation: EditService.isServiceConfirmation,
                                    IsSendToSupplier: EditService.isSendToSupplier,
                                    IsReceiveFromSupplier: EditService.isReceiveFromSupplier,
                                    IsPurchaseRequest: EditService.isPurchaseRequest,
                                    IsPurchaseOrder: EditService.isPurchaseOrder,


                                    EquipmentCode: EditService.equipmentCode,
                                    ItemCode: EditService.itemCode,
                                    ItemName: EditService.itemName,
                                    Remarks: EditService.remarks,
                                    UOM: EditService.uom,
                                    Quantity: double.tryParse(EditService.quantity??'0'),


                                    RowId: ServiceDetails.items[i].RowId,
                                    ServiceCode:
                                        EditService.serviceCode.toString() ??
                                            '',
                                    ServiceName:
                                        EditService.serviceName.toString() ??
                                            '',
                                    InfoPrice: double.tryParse(
                                            EditService.infoPrice.toString()) ??
                                        0.0,
                                    IsSendableItem: EditService.isSendable,
                                    SupplierCode:
                                        EditService.supplierCode.toString() ??
                                            '',
                                    SupplierName:
                                        EditService.supplierName.toString() ??
                                            '',
                                    insertedIntoDatabase: false);
                                ServiceDetails.items[i] = mncld1;
                              }

                            Get.offAll(() => JobCard(2));
                            getSuccessSnackBar("Check List Updated");
                          } else {
                            MNJCD2 mncld1 = MNJCD2(
                                ID: int.tryParse(EditService.id ?? ''),
                                IsServiceConfirmation: EditService.isServiceConfirmation,
                                IsSendToSupplier: EditService.isSendToSupplier,
                                IsReceiveFromSupplier: EditService.isReceiveFromSupplier,
                                IsPurchaseRequest: EditService.isPurchaseRequest,
                                IsPurchaseOrder: EditService.isPurchaseOrder,

                                EquipmentCode: EditService.equipmentCode,
                                ItemCode: EditService.itemCode,
                                ItemName: EditService.itemName,
                                Remarks: EditService.remarks,
                                UOM: EditService.uom,
                                Quantity: double.tryParse(EditService.quantity??'0'),

                                TransId: EditService.transId,
                                RowId: ServiceDetails.items.length,
                                ServiceCode:
                                    EditService.serviceCode.toString() ?? '',
                                ServiceName:
                                    EditService.serviceName.toString() ?? '',
                                InfoPrice: double.tryParse(
                                        EditService.infoPrice.toString()) ??
                                    0.0,
                                IsSendableItem: EditService.isSendable,
                                SupplierCode:
                                    EditService.supplierCode.toString() ?? '',
                                SupplierName:
                                    EditService.supplierName.toString() ?? '',
                                insertedIntoDatabase: false);
                            ServiceDetails.items.add(mncld1);

                            Get.offAll(() => JobCard(2));
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
