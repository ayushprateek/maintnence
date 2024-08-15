import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/CustomFont.dart';
import 'package:maintenance/Component/GetFormattedDate.dart';
import 'package:maintenance/Component/GetTextField.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/GoodsReceiptNote/create/Address/BillingAddress.dart';
import 'package:maintenance/GoodsReceiptNote/create/Address/ShippingAddress.dart';
import 'package:maintenance/Lookups/DepartmentLookup.dart';
import 'package:maintenance/Lookups/SupplierLookup.dart';
import 'package:maintenance/Lookups/TripLookup.dart';
import 'package:maintenance/Lookups/WarehouseLookup.dart';
import 'package:maintenance/Sync/SyncModels/CRD1.dart';
import 'package:maintenance/Sync/SyncModels/CRD2.dart';
import 'package:maintenance/Sync/SyncModels/CRD3.dart';
import 'package:maintenance/Sync/SyncModels/OCRD.dart';
import 'package:maintenance/Sync/SyncModels/OPOTRP.dart';
import 'package:maintenance/Sync/SyncModels/OUDP.dart';
import 'package:maintenance/Sync/SyncModels/OWHS.dart';
import 'package:maintenance/Sync/SyncModels/PROPDN.dart';

class GeneralData extends StatefulWidget {
  const GeneralData({super.key});

  static bool isSelected = false, hasCreated = false, hasUpdated = false;

  static String? iD;
  static String? transId;
  static String? cardCode;
  static String? cardName;
  static String? refNo;
  static String? contactPersonId;
  static String? contactPersonName;
  static String? mobileNo;
  static String? postingDate;
  static String? validUntill;
  static String? currency;
  static String? currRate;
  static String? paymentTermCode;
  static String? paymentTermName;
  static String? paymentTermDays;
  static String? approvalStatus;
  static String? docStatus;
  static String? rPTransId;
  static String? dSTranId;
  static String? cRTransId;
  static String? baseTab;
  static String? totBDisc;
  static String? discPer;
  static String? discVal;
  static String? taxVal;
  static String? docTotal;
  static String? permanentTransId;
  static String? docEntry;
  static String? docNum;
  static String? createdBy;
  static String? createDate;
  static String? updateDate;
  static String? approvedBy;
  static String? latitude;
  static String? longitude;
  static String? updatedBy;
  static String? branchId;
  static String? remarks;
  static String? localDate;
  static String? whsCode;
  static String? objectCode;
  static String? error;
  static String? postingAddress;
  static String? tripTransId;
  static String? deptCode;
  static String? deptName;

  static bool validate() {
    bool success = true;
    if (transId == "" || transId == null) {
      getErrorSnackBar("Invalid TransId");
      success = false;
    }
    if (deptName == "" || deptName == null) {
      getErrorSnackBar("Invalid Department");
      success = false;
    }
    if (cardName == "" || cardName == null) {
      getErrorSnackBar("Invalid Supplier");
      success = false;
    }

    if (contactPersonName == "" || contactPersonName == null) {
      getErrorSnackBar("Invalid Person Name");
      success = false;
    }

    return success;
  }

  static PROPDN getGeneralData() {
    return PROPDN(
      ID: int.tryParse(iD ?? ''),
      TransId: transId,
      PermanentTransId: permanentTransId ?? '',
      PostingDate: getDateFromString(postingDate ?? ""),
      ValidUntill: getDateFromString(validUntill ?? ''),
      hasCreated: hasCreated,
      hasUpdated: hasUpdated,
      ObjectCode: '23',
      Remarks: remarks,
      TripTransId: tripTransId,
      TotBDisc: double.tryParse(totBDisc?.toString() ?? ''),
      TaxVal: double.tryParse(taxVal?.toString() ?? ''),
      CardCode: cardCode,
      CardName: cardName,
      WhsCode: whsCode,
      ContactPersonId: int.tryParse(contactPersonId.toString() ?? ''),
      PaymentTermCode: paymentTermCode,
      PaymentTermDays: int.tryParse(paymentTermDays.toString() ?? ''),
      PaymentTermName: paymentTermName,
      ContactPersonName: contactPersonName,
      PostingAddress: postingAddress,
      MobileNo: mobileNo,
      Currency: currency,
      CurrRate: double.tryParse(currRate?.toString() ?? ''),
      DocTotal: double.tryParse(docTotal?.toString() ?? ''),
      RefNo: refNo,
      DeptCode: deptCode,
      DeptName: deptName,
      DiscPer: double.tryParse(discPer?.toString() ?? ''),
      DiscVal: double.tryParse(discVal?.toString() ?? ''),
      ApprovalStatus: approvalStatus ?? "Pending",
      DocStatus: docStatus,
    );
  }

  @override
  State<GeneralData> createState() => _GeneralDataState();
}

class _GeneralDataState extends State<GeneralData> {
  final TextEditingController _iD = TextEditingController(text: GeneralData.iD);
  final TextEditingController _transId =
      TextEditingController(text: GeneralData.transId);
  final TextEditingController _cardCode =
      TextEditingController(text: GeneralData.cardCode);
  final TextEditingController _cardName =
      TextEditingController(text: GeneralData.cardName);
  final TextEditingController _refNo =
      TextEditingController(text: GeneralData.refNo);
  final TextEditingController _contactPersonId =
      TextEditingController(text: GeneralData.contactPersonId);
  final TextEditingController _contactPersonName =
      TextEditingController(text: GeneralData.contactPersonName);
  final TextEditingController _mobileNo =
      TextEditingController(text: GeneralData.mobileNo);
  final TextEditingController _postingDate =
      TextEditingController(text: GeneralData.postingDate);
  final TextEditingController _validUntill =
      TextEditingController(text: GeneralData.validUntill);
  final TextEditingController _currency =
      TextEditingController(text: GeneralData.currency);
  final TextEditingController _currRate =
      TextEditingController(text: GeneralData.currRate);

  // final TextEditingController _paymentTermCode =
  //     TextEditingController(text: GeneralData.paymentTermCode);
  // final TextEditingController _paymentTermName =
  //     TextEditingController(text: GeneralData.paymentTermName);
  final TextEditingController _paymentTermDays =
      TextEditingController(text: GeneralData.paymentTermDays);
  final TextEditingController _approvalStatus =
      TextEditingController(text: GeneralData.approvalStatus);
  final TextEditingController _docStatus =
      TextEditingController(text: GeneralData.docStatus);

  // final TextEditingController _rPTransId =
  //     TextEditingController(text: GeneralData.rPTransId);
  // final TextEditingController _dSTranId =
  //     TextEditingController(text: GeneralData.dSTranId);
  // final TextEditingController _cRTransId =
  //     TextEditingController(text: GeneralData.cRTransId);
  // final TextEditingController _baseTab =
  //     TextEditingController(text: GeneralData.baseTab);
  // final TextEditingController _totBDisc =
  //     TextEditingController(text: GeneralData.totBDisc);
  // final TextEditingController _discPer =
  //     TextEditingController(text: GeneralData.discPer);
  // final TextEditingController _discVal =
  //     TextEditingController(text: GeneralData.discVal);
  // final TextEditingController _taxVal =
  //     TextEditingController(text: GeneralData.taxVal);
  // final TextEditingController _docTotal =
  //     TextEditingController(text: GeneralData.docTotal);
  final TextEditingController _permanentTransId =
      TextEditingController(text: GeneralData.permanentTransId);

  // final TextEditingController _docEntry =
  //     TextEditingController(text: GeneralData.docEntry);
  final TextEditingController _docNum =
      TextEditingController(text: GeneralData.docNum);

  // final TextEditingController _createdBy =
  //     TextEditingController(text: GeneralData.createdBy);
  // final TextEditingController _createDate =
  //     TextEditingController(text: GeneralData.createDate);
  // final TextEditingController _updateDate =
  //     TextEditingController(text: GeneralData.updateDate);
  // final TextEditingController _approvedBy =
  //     TextEditingController(text: GeneralData.approvedBy);
  // final TextEditingController _latitude =
  //     TextEditingController(text: GeneralData.latitude);
  // final TextEditingController _longitude =
  //     TextEditingController(text: GeneralData.longitude);
  // final TextEditingController _updatedBy =
  //     TextEditingController(text: GeneralData.updatedBy);
  // final TextEditingController _branchId =
  //     TextEditingController(text: GeneralData.branchId);
  final TextEditingController _remarks =
      TextEditingController(text: GeneralData.remarks);

  // final TextEditingController _localDate =
  //     TextEditingController(text: GeneralData.localDate);
  final TextEditingController _whsCode =
      TextEditingController(text: GeneralData.whsCode);

  // final TextEditingController _objectCode =
  //     TextEditingController(text: GeneralData.objectCode);
  // final TextEditingController _error =
  //     TextEditingController(text: GeneralData.error);
  // final TextEditingController _postingAddress =
  //     TextEditingController(text: GeneralData.postingAddress);
  final TextEditingController _tripTransId =
      TextEditingController(text: GeneralData.tripTransId);

  // final TextEditingController _deptCode =
  //     TextEditingController(text: GeneralData.deptCode);
  final TextEditingController _deptName =
      TextEditingController(text: GeneralData.deptName);

  List<String> typeList = ['Preventive', 'Breakdown'];
  String type = 'Preventive';
  List<String> warrantyList = ['Yes', 'No'];
  String warranty = 'Yes';

  Future<void> setAddress() async {
    List<CRD2Model> shipping =
        await retrieveCRD2ById(context, "Code = ?", [GeneralData.cardCode]);
    if (shipping.isNotEmpty) {
      ShippingAddress.RouteName = shipping[0].RouteName;
      ShippingAddress.RouteCode = shipping[0].RouteCode;
      ShippingAddress.CityName = shipping[0].CityName;
      ShippingAddress.CityCode = shipping[0].CityCode;
      ShippingAddress.Addres = shipping[0].Address;
      ShippingAddress.CountryName = shipping[0].CountryName;
      ShippingAddress.CountryCode = shipping[0].CountryCode;
      ShippingAddress.StateName = shipping[0].StateName;
      ShippingAddress.StateCode = shipping[0].StateCode;
      ShippingAddress.Latitude = double.tryParse(shipping[0].Latitude) ?? 0.0;
      ShippingAddress.Longitude =
          double.tryParse(shipping[0].Longitude.toString()) ?? 0.0;
      ShippingAddress.RowId = shipping[0].RowId;
      ShippingAddress.AddCode = shipping[0].AddressCode;
    }

    //SET FIRST BILLING ADDRESS --> CRD3 WHERE Code = ? CUSTOMER CODE

    List<CRD3Model> billing =
        await retrieveCRD3ById(context, "Code = ?", [GeneralData.cardCode]);
    if (billing.isNotEmpty) {
      BillingAddress.CityName = billing[0].CityName;
      BillingAddress.CityCode = billing[0].CityCode;
      BillingAddress.Addres = billing[0].Address;
      BillingAddress.CountryName = billing[0].CountryName;
      BillingAddress.CountryCode = billing[0].CountryCode;
      BillingAddress.StateName = billing[0].StateName;
      BillingAddress.StateCode = billing[0].StateCode;
      BillingAddress.Latitude = double.tryParse(billing[0].Latitude) ?? 0.0;
      BillingAddress.Longitude =
          double.tryParse(billing[0].Longitude.toString()) ?? 0.0;
      BillingAddress.RowId = billing[0].RowId;
      BillingAddress.AddCode = billing[0].AddressCode;
    }

    //SET FIRST CONTACT PERSON --> OCRD WHERE Code = ? CUSTOMER CODE

    List<CRD1Model> contactPerson = await retrieveCRD1ById(
        context, "Code = ? AND Active = ?", [GeneralData.cardCode, 1]);
    if (contactPerson.isNotEmpty) {
      GeneralData.contactPersonId = contactPerson[0].ID.toString();
      _mobileNo.text =
          GeneralData.mobileNo = contactPerson[0].MobileNo.toString();
      _contactPersonName.text = GeneralData.contactPersonName =
          contactPerson[0].FirstName.toString() +
              " " +
              contactPerson[0].MiddleName.toString() +
              " " +
              contactPerson[0].LastName.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8, top: 20),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16))),
          child: Column(
            children: [
              const SizedBox(
                height: 25,
              ),
              getDisabledTextField(
                  controller: _transId,
                  labelText: 'Trans Id',
                  onChanged: (val) {
                    GeneralData.transId = val;
                  }),
              getDisabledTextField(
                  controller: _deptName,
                  labelText: 'Department Name',
                  enableLookup: true,
                  onLookupPressed: () {
                    Get.to(() => DepartmentLookup(
                          onSelection: (OUDP oudp) {
                            setState(() {
                              GeneralData.deptCode = oudp.Code ?? '';
                              GeneralData.deptName =
                                  _deptName.text = oudp.Name ?? '';
                            });
                          },
                        ));
                  }),
              getDisabledTextField(
                  controller: _tripTransId,
                  labelText: 'TripTransId',
                  enableLookup: true,
                  onLookupPressed: () {
                    Get.to(() => TripLookup(onSelection: (OPOTRP oemp) {
                          setState(() {
                            GeneralData.tripTransId =
                                _tripTransId.text = oemp.TransId ?? '';
                          });
                        }));
                  }),
              getDisabledTextField(
                  controller: _cardName,
                  labelText: 'Supplier',
                  onChanged: (val) {
                    GeneralData.cardName = val;
                  },
                  enableLookup: true,
                  onLookupPressed: () {
                    Get.to(() =>
                        SupplierLookup(onSelected: (OCRDModel ocrdModel) async {
                          GeneralData.cardCode =
                              _cardCode.text = ocrdModel.Code;
                          GeneralData.paymentTermDays = _paymentTermDays.text =
                              ocrdModel.PaymentTermDays.toString() ?? '';
                          GeneralData.paymentTermName =
                              ocrdModel.PaymentTermName;
                          GeneralData.paymentTermCode =
                              ocrdModel.PaymentTermCode;
                          GeneralData.cardName =
                              _cardName.text = ocrdModel.Name ?? '';
                          await setAddress();
                          setState(() {});
                        }));
                  }),
              getDisabledTextField(
                controller: _contactPersonName,
                labelText: 'Person Name',
                onChanged: (val) {
                  GeneralData.contactPersonName = val;
                },
              ),
              getDateTextField(
                  controller: _postingDate,
                  labelText: 'Posting Date',
                  localCurrController: TextEditingController(),
                  onChanged: (val) {
                    _postingDate.text = GeneralData.postingDate = val;
                  }),
              getDateTextField(
                  controller: _validUntill,
                  labelText: 'Valid Until',
                  localCurrController: TextEditingController(),
                  onChanged: (val) {
                    _validUntill.text = GeneralData.validUntill = val;
                  }),
              getDisabledTextField(
                  controller: _approvalStatus,
                  labelText: 'Approval Status',
                  onChanged: (val) {
                    GeneralData.approvalStatus = val;
                  }),
              getDisabledTextField(
                  controller: _docStatus,
                  labelText: 'Doc Status',
                  onChanged: (val) {
                    GeneralData.docStatus = val;
                  }),
              getDisabledTextField(
                  controller: _paymentTermDays,
                  labelText: 'Payment Days',
                  onChanged: (val) {
                    GeneralData.paymentTermDays = val;
                  }),
              getDisabledTextField(
                  controller: _whsCode,
                  labelText: 'Warehouse',
                  enableLookup: true,
                  onLookupPressed: () {
                    Get.to(() => WarehouseLookup(
                          onSelection: (OWHS owhs) {
                            setState(() {
                              GeneralData.whsCode =
                                  _whsCode.text = owhs.WhsCode ?? '';
                            });
                          },
                        ));
                  }),
              getTextField(
                  controller: _refNo,
                  labelText: 'Ref. No',
                  onChanged: (val) {
                    GeneralData.refNo = val;
                  }),
              getTextField(
                  controller: _remarks,
                  labelText: 'Remarks',
                  onChanged: (val) {
                    GeneralData.remarks = val;
                  }),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ExpansionTile(
                  collapsedBackgroundColor: barColor,
                  backgroundColor: barColor,
                  title: getHeadingText(text: "Details", color: headColor),
                  children: [
                    getDisabledTextField(
                      controller: _permanentTransId,
                      labelText: 'Permanent Trans Id',
                      onChanged: (val) {
                        GeneralData.permanentTransId = val;
                      },
                    ),
                    getDisabledTextField(
                      controller: _docNum,
                      labelText: 'ERP Docnum',
                      onChanged: (val) {
                        GeneralData.docNum = val;
                      },
                    ),
                    getDisabledTextField(
                        controller: _currency,
                        labelText: 'Currency',
                        onChanged: (val) {
                          GeneralData.currency = val;
                        }),
                    getDisabledTextField(
                        controller: _currRate,
                        labelText: 'Currency Rate',
                        onChanged: (val) {
                          GeneralData.currRate = val;
                        }),
                    getDisabledTextField(
                        controller: TextEditingController(),
                        labelText: 'Local Date'),
                  ],
                ),
              ),
              const SizedBox(
                height: 70,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
