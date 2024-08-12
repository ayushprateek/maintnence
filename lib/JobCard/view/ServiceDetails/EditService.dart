import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/GetTextField.dart';
import 'package:maintenance/Component/IsNumeric.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/JobCard/view/ItemDetails/ItemDetails.dart';
import 'package:maintenance/JobCard/view/JobCard.dart';
import 'package:maintenance/JobCard/view/ServiceDetails/ServiceDetails.dart';
import 'package:maintenance/Lookups/SupplierLookup.dart';
import 'package:maintenance/Sync/SyncModels/MNJCD2.dart';
import 'package:maintenance/Sync/SyncModels/OCRD.dart';

class EditService extends StatefulWidget {
  static String? id;
  static String? transId;
  static String? rowId;
  static String? serviceCode;
  static String? serviceName;
  static String? infoPrice;

  static String? supplierName;
  static String? supplierCode;

  static bool isSendable = false;

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
            getTextField(
              controller: _infoPrice,
              labelText: 'Info Price',
              onChanged: (val) {
                EditService.infoPrice = val;
              },
              keyboardType: getDecimalKeyboardType(),
              inputFormatters: [getDecimalRegEx()],
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
                            for (int i = 0; i < ItemDetails.items.length; i++)
                              if (EditService.serviceCode ==
                                  ItemDetails.items[i].ItemCode) {
                                //todo: updating
                              }

                            Get.offAll(() => ViewJobCard(2));

                            getSuccessSnackBar("Check List Updated");
                          } else {
                            MNJCD2 mncld1 = MNJCD2(
                                ID: int.tryParse(EditService.id ?? ''),
                                TransId: EditService.transId,
                                RowId: ItemDetails.items.length,
                                ServiceCode:
                                    EditService.serviceCode.toString() ?? '',
                                ServiceName:
                                    EditService.serviceName.toString() ?? '',
                                InfoPrice: double.tryParse(
                                        EditService.infoPrice.toString()) ??
                                    0.0,
                                SupplierCode:
                                    EditService.supplierCode.toString() ?? '',
                                SupplierName:
                                    EditService.supplierName.toString() ?? '',
                                insertedIntoDatabase: false);
                            ServiceDetails.items.add(mncld1);

                            Get.offAll(() => ViewJobCard(2));
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
