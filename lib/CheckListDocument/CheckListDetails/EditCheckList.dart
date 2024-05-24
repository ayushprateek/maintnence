import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance/CheckListDocument/CheckListDetails/CheckListDetails.dart';
import 'package:maintenance/CheckListDocument/CheckListDocument.dart';
import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/GetTextField.dart';
import 'package:maintenance/Component/IsNumeric.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/Lookups/SupplierLookup.dart';
import 'package:maintenance/Lookups/UOMLookup.dart';
import 'package:maintenance/Sync/SyncModels/MNCLD1.dart';
import 'package:maintenance/Sync/SyncModels/OCRD.dart';
import 'package:maintenance/Sync/SyncModels/OUOM.dart';

class EditCheckList extends StatefulWidget {
  static String? id;
  static String? description;
  static String? transId;
  static String? rowId;
  static String? itemCode;
  static String? itemName;
  static String? consumptionQty;
  static String? uomCode;
  static String? uomName;
  static String? supplierName;
  static String? supplierCode;
  static String? userRemarks;
  static String? requiredDate;
  static String? remark;
  static bool isChecked = false;
  static bool fromStock = false;
  static bool consumption = false;
  static bool request = false;
  static bool isUpdating = false;

  EditCheckList({
    super.key,
  });

  @override
  State<EditCheckList> createState() => _EditCheckListState();
}

class _EditCheckListState extends State<EditCheckList> {
  final TextEditingController _description =
      TextEditingController(text: EditCheckList.description);
  final TextEditingController _itemCode =
      TextEditingController(text: EditCheckList.itemCode);
  final TextEditingController _itemName =
      TextEditingController(text: EditCheckList.itemName);
  final TextEditingController _consumptionQty =
      TextEditingController(text: EditCheckList.consumptionQty);
  final TextEditingController _uomCode =
      TextEditingController(text: EditCheckList.uomCode);
  final TextEditingController _uomName =
      TextEditingController(text: EditCheckList.uomName);
  final TextEditingController _supplierName =
      TextEditingController(text: EditCheckList.supplierName);
  final TextEditingController _supplierCode =
      TextEditingController(text: EditCheckList.supplierCode);
  final TextEditingController _userRemarks =
      TextEditingController(text: EditCheckList.userRemarks);
  final TextEditingController _remark =
      TextEditingController(text: EditCheckList.remark);
  final TextEditingController _requiredDate =
      TextEditingController(text: EditCheckList.requiredDate);

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
        title: Text("Edit Check List"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            getTextField(
                controller: _description,
                labelText: 'Description',
                onChanged: (val) {
                  EditCheckList.description = val;
                }),
            // getDisabledTextField(
            //     controller: _itemCode,
            //     labelText: 'Item Code',
            //     onChanged: (val) {
            //       EditCheckList.itemCode = val;
            //     }),
            getDisabledTextField(controller: _itemName, labelText: 'Item Name'),
            getTextField(
              controller: _consumptionQty,
              labelText: 'Consumption Qty',
              onChanged: (val) {
                EditCheckList.consumptionQty = val;
              },
              keyboardType: getDecimalKeyboardType(),
              inputFormatters: [getDecimalRegEx()],
            ),
            // if (uomCode.isNotEmpty)
            //   Padding(
            //     padding: const EdgeInsets.only(
            //       left: 10,
            //       right: 8,
            //     ),
            //     child: Row(
            //       children: [
            //         Container(
            //           color: Colors.white,
            //           child: getHeadingText(text: 'UOM : '),
            //         ),
            //         Align(
            //           alignment: Alignment.centerRight,
            //           child: Padding(
            //             padding:
            //             const EdgeInsets.only(left: 20.0),
            //             child: DropdownButton<String>(
            //               items: uomCode.map((String value) {
            //                 return DropdownMenuItem<String>(
            //                   value: value,
            //                   child: Text(value),
            //                 );
            //               }).toList(),
            //               onChanged: (val) {
            //                 setState(() {
            //                   EditCheckList.uom = val;
            //                 });
            //               },
            //               value: EditCheckList.uom,
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            getDisabledTextField(
                controller: _uomName,
                labelText: 'UOM',
                enableLookup: true,
                onLookupPressed: () {
                  Get.to(() => UOMLookup(onSelected: (OUOMModel ouomModel) {
                        setState(() {
                          EditCheckList.uomCode =
                              _uomCode.text = ouomModel.UomCode;
                          EditCheckList.uomName =
                              _uomName.text = ouomModel.UomName;
                        });
                      }));
                }),
            // getDisabledTextField(
            //     controller: _supplierCode,
            //     labelText: 'Supplier Code',
            //     ),
            getDisabledTextField(
                controller: _supplierName, labelText: 'Supplier',
                enableLookup: true,
                onLookupPressed: () {
                  Get.to(
                          () => SupplierLookup(onSelected: (OCRDModel ocrdModel) {
                        setState(() {
                          EditCheckList.supplierCode =
                              _supplierCode.text = ocrdModel.Code;
                          EditCheckList.supplierName =
                              _supplierName.text = ocrdModel.Name ?? '';
                        });
                      }));
                }),
            getTextField(
                controller: _userRemarks,
                labelText: 'User Remarks',
                onChanged: (val) {
                  EditCheckList.userRemarks = val;
                }),
            getTextField(
                controller: _remark,
                labelText: 'Remarks',
                onChanged: (val) {
                  EditCheckList.remark = val;
                }),
            getDateTextField(
                controller: _requiredDate,
                localCurrController: TextEditingController(),
                labelText: 'Required Date',
                onChanged: (val) {
                  _requiredDate.text = EditCheckList.requiredDate = val;
                }),
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              value: EditCheckList.fromStock,
              onChanged: (bool ?val) {
                setState(() {
                  EditCheckList.fromStock=val??!EditCheckList.fromStock;
                });
              },

              title: Text('From Stock'),

            ),
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              value: EditCheckList.consumption,
              onChanged: (bool ?val) {
                setState(() {
                  EditCheckList.consumption=val??!EditCheckList.consumption;
                });
              },

              title: Text('Consumption'),

            ),
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              value: EditCheckList.request,
              onChanged: (bool ?val) {
                setState(() {
                  EditCheckList.request=val??!EditCheckList.request;
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
                        if (_description.text.isEmpty) {
                          getErrorSnackBar("Description can not be empty");
                        } else if (!isNumeric(_consumptionQty.text)) {
                          getErrorSnackBar(
                              "Consumption Quantity must be numeric");
                        } else if (double.parse(_consumptionQty.text) <= 0.0) {
                          getErrorSnackBar(
                              "Consumption Quantity can not be less that or equal to 0");
                        } else if (_uomCode.text.isEmpty) {
                          getErrorSnackBar("UOM can not be empty");
                        } else if (_supplierCode.text.isEmpty) {
                          getErrorSnackBar("Supplier can not be empty");
                        } else if (_userRemarks.text.isEmpty) {
                          getErrorSnackBar("User Remarks can not be empty");
                        } else if (_requiredDate.text.isEmpty) {
                          getErrorSnackBar("Required Date can not be empty");
                        } else {
                          if (EditCheckList.isUpdating) {
                            for (int i = 0;
                                i < CheckListDetails.items.length;
                                i++)
                              if (EditCheckList.itemCode ==
                                  CheckListDetails.items[i].ItemCode) {
                                CheckListDetails.items[i].UOM =
                                    EditCheckList.uomCode;
                                //todo: updating
                              }

                            Get.offAll(() => CheckListDocument(1));

                            getSuccessSnackBar("Check List Updated");
                          } else {
                            MNCLD1 mncld1 = MNCLD1(
                              ID: int.tryParse(EditCheckList.id ?? ''),
                              TransId: EditCheckList.transId,
                              RowId: CheckListDetails.items.length,
                              ItemCode: EditCheckList.itemCode.toString() ?? '',
                              ItemName: EditCheckList.itemName.toString() ?? '',
                              UOM: EditCheckList.uomCode.toString() ?? '',
                              Description:
                                  EditCheckList.description.toString() ?? '',
                              Remarks: EditCheckList.remark.toString() ?? '',
                              UserRemarks:
                                  EditCheckList.userRemarks.toString() ?? '',
                              IsChecked: EditCheckList.isChecked,
                              IsFromStock: EditCheckList.fromStock,
                              ConsumptionQty: double.tryParse(EditCheckList
                                      .consumptionQty
                                      .toString()) ??
                                  0.0,
                              // MNGITransId :EditCheckList.MNGITransId.toString()??'',
                              // MNGIRowId : int.tryParse(json['MNGIRowId'].toString())??0,
                              // PRTransId :EditCheckList.PRTransId.toString()??'',
                              // PRRowId : int.tryParse(json['PRRowId'].toString())??0,
                              // MNITTransId :EditCheckList.MNITTransId.toString()??'',
                              // MNITRowId : int.tryParse(json['MNITRowId'].toString())??0,
                              SupplierCode:
                                  EditCheckList.supplierCode.toString() ?? '',
                              SupplierName:
                                  EditCheckList.supplierName.toString() ?? '',

                              IsConsumption: EditCheckList.consumption,
                              IsRequest: EditCheckList.request,
                              RequiredDate:
                                  DateTime.tryParse(_requiredDate.text),
                            );
                            CheckListDetails.items.add(mncld1);

                            Get.offAll(() => CheckListDocument(1));
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
