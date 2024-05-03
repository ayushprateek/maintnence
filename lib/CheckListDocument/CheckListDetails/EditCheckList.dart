import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/CustomFont.dart';
import 'package:maintenance/Component/GetTextField.dart';
import 'package:maintenance/Component/IsNumeric.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/Lookups/SupplierLookup.dart';
import 'package:maintenance/Lookups/UOMLookup.dart';
import 'package:maintenance/Sync/SyncModels/IUOM.dart';
import 'package:maintenance/Sync/SyncModels/OCRD.dart';
import 'package:maintenance/Sync/SyncModels/OUOM.dart';

class EditCheckList extends StatefulWidget {
  static String? description;
  static String? itemCode;
  static String? itemName;
  static String? consumptionQty;
  static String? uomCode;
  static String? uomName;
  static String? supplierName;
  static String? supplierCode;
  static String? userRemarks;
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
            getTextField(controller: _description, labelText: 'Description'),
            getDisabledTextField(controller: _itemCode, labelText: 'Item Code'),
            getDisabledTextField(controller: _itemName, labelText: 'Item Name'),
            getTextField(
                controller: _consumptionQty, labelText: 'Consumption Qty',
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
                controller: _uomName, labelText: 'UOM', enableLookup: true,
              onLookupPressed: (){
                  Get.to(()=>UOMLookup(onSelected: (OUOMModel ouomModel){

                    setState(() {
                      _uomCode.text=ouomModel.UomCode;
                      _uomName.text=ouomModel.UomName;
                    });
                  }));
              }
            ),
            getDisabledTextField(
                controller: _supplierCode,
                labelText: 'Supplier Code',
                enableLookup: true,
              onLookupPressed: (){
                  Get.to(()=>SupplierLookup(onSelected: (OCRDModel ocrdModel){
                    setState(() {
                      _supplierCode.text=ocrdModel.Code;
                      _supplierName.text=ocrdModel.Name??'';
                    });
                  }));
              }
            ),
            getDisabledTextField(
                controller: _supplierName, labelText: 'Supplier Name'),
            getTextField(controller: _userRemarks, labelText: 'User Remarks'),
            getTextField(controller: _remark, labelText: 'Remarks'),
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
                      // onPressed: () async {
                      //   if (!isNumeric(_consumptionQty.text)) {
                      //     getErrorSnackBar(
                      //         "Quantity must be numeric");
                      //   } else if (double.parse(_consumptionQty.text) <=
                      //       0.0) {
                      //     getErrorSnackBar(
                      //         "Quantity can not be less that or equal to 0");
                      //   } else {
                      //     if (EditCheckList.isUpdating) {
                      //
                      //
                      //       for (int i = 0;
                      //       i < ItemDetails.items.length;
                      //       i++)
                      //         if (EditCheckList.originaltemCode ==
                      //             ItemDetails.items[i].ItemCode) {
                      //           ItemDetails.items[i].UOM =
                      //               UOM.text;
                      //           ItemDetails.items[i].TaxRate =
                      //               double.parse(TaxRate.text);
                      //           ItemDetails.items[i].TaxCode =
                      //               TaxCode.text;
                      //           ItemDetails.items[i].Quantity =
                      //               double.parse(Quantity.text);
                      //           ItemDetails.items[i].Price =
                      //               double.parse(Price.text);
                      //           ItemDetails.items[i].LineTotal =
                      //               double.parse(LineTotal.text);
                      //           ItemDetails.items[i].ItemName =
                      //               ItemName.text;
                      //           ItemDetails.items[i].ItemCode =
                      //               ItemCode.text;
                      //           ItemDetails.items[i].ID =
                      //               int.parse(ID.text);
                      //           ItemDetails.items[i].Discount =
                      //               double.parse(Discount.text);
                      //           ItemDetails.items[i].MSP =
                      //               double.tryParse(MSP.text) ??
                      //                   0.0;
                      //           if (ItemDetails.items[i]
                      //               .insertedIntoDatabase) {
                      //             Map<String, dynamic> values = {
                      //               "UOM": UOM.text,
                      //               "RowId": ItemDetails
                      //                   .items[i].RowId,
                      //               "TaxRate": double.parse(
                      //                   TaxRate.text),
                      //               "TaxCode": TaxCode.text,
                      //               "Quantity": double.parse(
                      //                   Quantity.text),
                      //               "Price":
                      //               double.parse(Price.text),
                      //               "LineTotal": double.parse(
                      //                   LineTotal.text),
                      //               "ItemName": ItemName.text,
                      //               "ItemCode": ItemCode.text,
                      //               "ID": int.parse(ID.text),
                      //               "Discount": double.parse(
                      //                   Discount.text),
                      //               "MSP": double.tryParse(
                      //                   MSP.text) ??
                      //                   0.0,
                      //               "UpdateDate":DateTime.now().toIso8601String(),
                      //               "has_updated":1
                      //             };
                      //             final Database db =
                      //             await initializeDB(context);
                      //             await db.update(
                      //                 DBName.DB1, values,
                      //                 where: "ItemCode = ?",
                      //                 whereArgs: [
                      //                   EditCheckList.originaltemCode
                      //                 ]);
                      //           }
                      //         }
                      //       calculateINV();
                      //       getSuccessSnackBar("Data Updated");
                      //       Navigator.pop(context);
                      //       Navigator.pop(context);
                      //       Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //               builder: ((context) =>
                      //                   ARInvoice(1))));
                      //     } else {
                      //       INV1Model i = INV1Model(
                      //         DSTranId: "",
                      //         RowId: 0,
                      //         OpenQty: 0.0,
                      //         LineStatus: "",
                      //         insertedIntoDatabase: false,
                      //         ID: int.parse(ID.text),
                      //         BaseTransId: "",
                      //         Discount:
                      //         double.parse(Discount.text),
                      //         ItemCode: ItemCode.text,
                      //         ItemName: ItemName.text,
                      //         LineTotal:
                      //         double.parse(LineTotal.text),
                      //         Price: double.parse(Price.text),
                      //         Quantity:
                      //         double.parse(Quantity.text),
                      //         TaxCode: TaxCode.text,
                      //         TaxRate: double.parse(TaxRate.text),
                      //         MSP: double.tryParse(MSP.text) ??
                      //             0.0,
                      //         TransId: TransId.text,
                      //         UOM: UOM.text,
                      //       );
                      //       ItemDetails.items.add(i);
                      //       calculateINV();
                      //
                      //       Navigator.pop(context);
                      //       Navigator.pop(context);
                      //       Navigator.pop(context);
                      //       Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //               builder: ((context) =>
                      //                   ARInvoice(1))));
                      //     }
                      //   }
                      // },
                      minWidth: MediaQuery.of(context).size.width,
                      onPressed: () {  },
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
