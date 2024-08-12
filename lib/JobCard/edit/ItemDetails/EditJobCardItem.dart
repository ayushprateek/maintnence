import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/GetTextField.dart';
import 'package:maintenance/Component/IsNumeric.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/JobCard/edit/ItemDetails/ItemDetails.dart';
import 'package:maintenance/JobCard/edit/JobCard.dart';
import 'package:maintenance/Lookups/SupplierLookup.dart';
import 'package:maintenance/Lookups/UOMLookup.dart';
import 'package:maintenance/Sync/SyncModels/MNJCD1.dart';
import 'package:maintenance/Sync/SyncModels/OCRD.dart';
import 'package:maintenance/Sync/SyncModels/OUOM.dart';

class EditJobCardItem extends StatefulWidget {
  static String? id;
  static String? transId;
  static String? rowId;
  static String? itemCode;
  static String? itemName;
  static String? quantity;
  static String? uomCode;
  static String? uomName;
  static String? supplierName;
  static String? supplierCode;

  static String? requiredDate;

  static bool isChecked = false;
  static bool fromStock = false;
  static bool consumption = false;
  static bool request = false;
  static bool isUpdating = false;

  EditJobCardItem({
    super.key,
  });

  @override
  State<EditJobCardItem> createState() => _EditJobCardItemState();
}

class _EditJobCardItemState extends State<EditJobCardItem> {
  final TextEditingController _itemCode =
      TextEditingController(text: EditJobCardItem.itemCode);
  final TextEditingController _itemName =
      TextEditingController(text: EditJobCardItem.itemName);
  final TextEditingController _quantity =
      TextEditingController(text: EditJobCardItem.quantity);
  final TextEditingController _uomCode =
      TextEditingController(text: EditJobCardItem.uomCode);
  final TextEditingController _uomName =
      TextEditingController(text: EditJobCardItem.uomName);
  final TextEditingController _supplierName =
      TextEditingController(text: EditJobCardItem.supplierName);
  final TextEditingController _supplierCode =
      TextEditingController(text: EditJobCardItem.supplierCode);

  final TextEditingController _requiredDate =
      TextEditingController(text: EditJobCardItem.requiredDate);

  // List<String>  uomCode = [];
  // // List<IWHS> whsCodeList = [];
  // List<IUOM> uomCodeList = [];
  @override
  void initState() {
    // getUOMCode();
    super.initState();
  }

  // getUOMCode() async {
  //
  //   uomCodeList =
  //   await retrieveIUOMById(context, 'ItemCode = ? AND Active = ?', [EditCheckList.itemCode,1]);
  //   uomCodeList.forEach((element) {
  //     uomCode.add(element.UOM ?? '');
  //   });
  //   print(uomCode);
  //   print(EditCheckList.uom ?? '');
  //   setState(() {});
  // }

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


            getDisabledTextField(controller: _itemName, labelText: 'Item Name',
              onChanged: (val) {
                EditJobCardItem.itemName  = val;
              },),
            getTextField(
              controller: _quantity,
              labelText: 'Quantity',
              onChanged: (val) {
                EditJobCardItem.quantity = val;
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
                          EditJobCardItem.uomCode =
                              _uomCode.text = ouomModel.UomCode;
                          EditJobCardItem.uomName =
                              _uomName.text = ouomModel.UomName;
                        });
                      }));
                }),

            getDisabledTextField(
                controller: _supplierName, labelText: 'Supplier',
                enableLookup: true,
                onLookupPressed: () {
                  Get.to(
                          () => SupplierLookup(onSelected: (OCRDModel ocrdModel) {
                        setState(() {
                          EditJobCardItem.supplierCode =
                              _supplierCode.text = ocrdModel.Code;
                          EditJobCardItem.supplierName =
                              _supplierName.text = ocrdModel.Name ?? '';
                        });
                      }));
                }),

            getDateTextField(
                controller: _requiredDate,
                localCurrController: TextEditingController(),
                labelText: 'Required Date',
                onChanged: (val) {
                  _requiredDate.text = EditJobCardItem.requiredDate = val;
                }),
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              value: EditJobCardItem.fromStock,
              onChanged: (bool? val) {
                setState(() {
                  EditJobCardItem.fromStock = val ?? !EditJobCardItem.fromStock;
                });
              },
              title: Text('From Stock'),
            ),
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              value: EditJobCardItem.consumption,
              onChanged: (bool? val) {
                setState(() {
                  EditJobCardItem.consumption =
                      val ?? !EditJobCardItem.consumption;
                });
              },
              title: Text('Consumption'),
            ),
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              value: EditJobCardItem.request,
              onChanged: (bool? val) {
                setState(() {
                  EditJobCardItem.request = val ?? !EditJobCardItem.request;
                });
              },
              title: Text('Request'),
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
                        if (!isNumeric(_quantity.text)) {
                          getErrorSnackBar(
                              "Consumption Quantity must be numeric");
                        } else if (double.parse(_quantity.text) <= 0.0) {
                          getErrorSnackBar(
                              "Consumption Quantity can not be less that or equal to 0");
                        } else if (_uomCode.text.isEmpty) {
                          getErrorSnackBar("UOM can not be empty");
                        } else if (_supplierCode.text.isEmpty) {
                          getErrorSnackBar("Supplier can not be empty");
                        } else if (_requiredDate.text.isEmpty) {
                          getErrorSnackBar("Required Date can not be empty");
                        } else {
                          if (EditJobCardItem.isUpdating) {
                            for (int i = 0; i < ItemDetails.items.length; i++)
                              if (EditJobCardItem.itemCode ==
                                  ItemDetails.items[i].ItemCode) {
                                ItemDetails.items[i].UOM =
                                    EditJobCardItem.uomCode;
                                //todo: updating
                              }

                            Get.offAll(() => EditJobCard(1));

                            getSuccessSnackBar("Check List Updated");
                          } else {
                            MNJCD1 mncld1 = MNJCD1(
                              ID: int.tryParse(EditJobCardItem.id ?? ''),
                              TransId: EditJobCardItem.transId,
                              RowId: ItemDetails.items.length,
                              ItemCode:
                                  EditJobCardItem.itemCode.toString() ?? '',
                              ItemName:
                                  EditJobCardItem.itemName.toString() ?? '',
                              UOM: EditJobCardItem.uomCode.toString() ?? '',
                              IsFromStock: EditJobCardItem.fromStock,
                              Quantity: double.tryParse(
                                      EditJobCardItem.quantity.toString()) ??
                                  0.0,
                              SupplierCode:
                                  EditJobCardItem.supplierCode.toString() ?? '',
                              SupplierName:
                                  EditJobCardItem.supplierName.toString() ?? '',
                              IsConsumption: EditJobCardItem.consumption,
                              IsRequest: EditJobCardItem.request,
                              insertedIntoDatabase: false
                            );
                            ItemDetails.items.add(mncld1);

                            Get.offAll(() => EditJobCard(1));
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
