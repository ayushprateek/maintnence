import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/CustomFont.dart';
import 'package:maintenance/Component/GetFormattedDate.dart';
import 'package:maintenance/Component/GetTextField.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/GoodsIssue/edit/ItemDetails/CalculateGoodIssue.dart';
import 'package:maintenance/Lookups/DepartmentLookup.dart';
import 'package:maintenance/Lookups/OCRDLookup.dart';
import 'package:maintenance/Lookups/TripLookup.dart';
import 'package:maintenance/Sync/SyncModels/CRD1.dart';
import 'package:maintenance/Sync/SyncModels/IMOGDI.dart';
import 'package:maintenance/Sync/SyncModels/OCRD.dart';
import 'package:maintenance/Sync/SyncModels/OPOTRP.dart';
import 'package:maintenance/Sync/SyncModels/OUDP.dart';
import 'package:maintenance/Sync/SyncModels/OWHS.dart';

import '../../Lookups/WarehouseLookup.dart';

class GeneralData extends StatefulWidget {
  GeneralData({super.key});

  static bool isSelected = false, hasCreated = false, hasUpdated = false;

  static String? iD;
  static String? transId;
  static String? priceListCode;
  static String? requestedCode;
  static String? requestedName;
  static String? refNo;
  static String? mobileNo;
  static String? postingDate;
  static String? validUntill;
  static String? currency;
  static String? currRate;
  static String? approvalStatus;
  static String? docStatus;
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
  static String? error;
  static bool? isPosted;
  static String? draftKey;
  static String? latitude;
  static String? longitude;
  static String? objectCode;
  static String? toWhsCode;
  static String? remarks;
  static String? branchId;
  static String? updatedBy;
  static String? postingAddress;
  static String? tripTransId;
  static String? deptCode;
  static String? deptName;

  static bool validate() {
    calculateGoodsIssue();
    bool success = true;
    if (transId == "" || transId == null) {
      getErrorSnackBar("Invalid TransId");
      success = false;
    }
    if (deptName == "" || deptName == null) {
      getErrorSnackBar("Invalid Department");
      success = false;
    }
    if (requestedName == "" || requestedName == null) {
      getErrorSnackBar("Invalid Request Field");
      success = false;
    }

    if (toWhsCode == "" || toWhsCode == null) {
      getErrorSnackBar("Invalid toWhsCode");
      success = false;
    }

    return success;
  }

  static IMOGDI getGeneralData() {
    return IMOGDI(
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
      ToWhsCode: toWhsCode,
      RequestedCode: requestedCode,
      RequestedName: requestedName,
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
      IsPosted: isPosted,
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
  final TextEditingController _requestedCode =
      TextEditingController(text: GeneralData.requestedCode);
  final TextEditingController _requestedName =
      TextEditingController(text: GeneralData.requestedName);
  final TextEditingController _refNo =
      TextEditingController(text: GeneralData.refNo);
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
  final TextEditingController _approvalStatus =
      TextEditingController(text: GeneralData.approvalStatus);
  final TextEditingController _docStatus =
      TextEditingController(text: GeneralData.docStatus);
  final TextEditingController _totBDisc =
      TextEditingController(text: GeneralData.totBDisc);
  final TextEditingController _discPer =
      TextEditingController(text: GeneralData.discPer);
  final TextEditingController _discVal =
      TextEditingController(text: GeneralData.discVal);
  final TextEditingController _taxVal =
      TextEditingController(text: GeneralData.taxVal);
  final TextEditingController _docTotal =
      TextEditingController(text: GeneralData.docTotal);
  final TextEditingController _permanentTransId =
      TextEditingController(text: GeneralData.permanentTransId);
  final TextEditingController _docEntry =
      TextEditingController(text: GeneralData.docEntry);
  final TextEditingController _docNum =
      TextEditingController(text: GeneralData.docNum);
  final TextEditingController _createdBy =
      TextEditingController(text: GeneralData.createdBy);
  final TextEditingController _createDate =
      TextEditingController(text: GeneralData.createDate);
  final TextEditingController _updateDate =
      TextEditingController(text: GeneralData.updateDate);
  final TextEditingController _approvedBy =
      TextEditingController(text: GeneralData.approvedBy);
  final TextEditingController _error =
      TextEditingController(text: GeneralData.error);

  final TextEditingController _draftKey =
      TextEditingController(text: GeneralData.draftKey);
  final TextEditingController _latitude =
      TextEditingController(text: GeneralData.latitude);
  final TextEditingController _longitude =
      TextEditingController(text: GeneralData.longitude);
  final TextEditingController _objectCode =
      TextEditingController(text: GeneralData.objectCode);
  final TextEditingController _toWhsCode =
      TextEditingController(text: GeneralData.toWhsCode);
  final TextEditingController _remarks =
      TextEditingController(text: GeneralData.remarks);
  final TextEditingController _branchId =
      TextEditingController(text: GeneralData.branchId);
  final TextEditingController _updatedBy =
      TextEditingController(text: GeneralData.updatedBy);
  final TextEditingController _postingAddress =
      TextEditingController(text: GeneralData.postingAddress);
  final TextEditingController _tripTransId =
      TextEditingController(text: GeneralData.tripTransId);
  final TextEditingController _deptCode =
      TextEditingController(text: GeneralData.deptCode);
  final TextEditingController _deptName =
      TextEditingController(text: GeneralData.deptName);
  final TextEditingController _contactPersonCode = TextEditingController();
  final TextEditingController _contactPersonName = TextEditingController();
  final TextEditingController _localDate = TextEditingController();

  List<String> typeList = ['Preventive', 'Breakdown'];
  String type = 'Preventive';
  List<String> warrantyList = ['Yes', 'No'];
  String warranty = 'Yes';

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
                },
              ),
              // getDisabledTextField(
              //     controller: _deptCode,
              //     labelText: 'Department Code',
              //     ),
              getDisabledTextField(
                  controller: _deptName,
                  labelText: 'Department',
                  enableLookup: true,
                  onLookupPressed: () {
                    Get.to(() => DepartmentLookup(
                          onSelection: (OUDP oudp) {
                            setState(() {
                              GeneralData.deptCode =
                                  _deptCode.text = oudp.Code ?? '';
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
              getTextField(
                  controller: _refNo,
                  labelText: 'Reference No',
                  onChanged: (val) {
                    _refNo.text = GeneralData.refNo = val;
                  }),
              getDisabledTextField(
                  controller: _requestedName,
                  labelText: 'Request*',
                  enableLookup: true,
                  onLookupPressed: () {
                    Get.to(() => OCRDLookup(onSelection:
                            (OCRDModel ocrdModel, CRD1Model? crd1Model) {
                          setState(() {
                            GeneralData.requestedCode =
                                _requestedCode.text = ocrdModel.Code;
                            GeneralData.priceListCode = ocrdModel.PriceListCode;
                            GeneralData.requestedName =
                                _requestedName.text = ocrdModel.Name ?? '';
                            GeneralData.mobileNo =
                                _mobileNo.text = ocrdModel.MobileNo;
                            if (crd1Model != null) {
                              _contactPersonName.text =
                                  "${crd1Model.FirstName} ${crd1Model.MiddleName} ${crd1Model.LastName}";
                            }
                          });
                        }));
                  }),
              getDisabledTextField(
                  controller: _contactPersonName,
                  labelText: 'Person Name',
                  onChanged: (val) {
                    //todo:
                    // _contactPersonName.text = GeneralData. = val;
                  }),
              getDisabledTextField(
                  controller: _mobileNo,
                  labelText: 'Mobile Number',
                  onChanged: (val) {
                    _mobileNo.text = GeneralData.mobileNo = val;
                  }),
              getDisabledTextField(
                  controller: _toWhsCode,
                  labelText: 'To Warehouse',
                  enableLookup: true,
                  onLookupPressed: () {
                    Get.to(() => WarehouseLookup(
                          onSelection: (OWHS owhs) {
                            setState(() {
                              GeneralData.toWhsCode =
                                  _toWhsCode.text = owhs.WhsCode ?? '';
                            });
                          },
                        ));
                  }),
              getTextField(
                  controller: _remarks,
                  labelText: 'Remarks',
                  onChanged: (val) {
                    _remarks.text = GeneralData.remarks = val;
                  }),
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
                  controller: _docStatus,
                  labelText: 'Doc Status',
                  onChanged: (val) {
                    _docStatus.text = GeneralData.docStatus = val;
                  }),
              getDisabledTextField(
                  controller: _approvalStatus,
                  labelText: 'Approval Status',
                  onChanged: (val) {
                    _approvalStatus.text = GeneralData.approvalStatus = val;
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
                          _permanentTransId.text =
                              GeneralData.permanentTransId = val;
                        }),
                    getDisabledTextField(
                        controller: _docNum,
                        labelText: 'ERP Doc Num',
                        onChanged: (val) {
                          _docNum.text = GeneralData.docNum = val;
                        }),
                    getDisabledTextField(
                        controller: _docEntry,
                        labelText: 'Doc Entry',
                        onChanged: (val) {
                          _docEntry.text = GeneralData.docEntry = val;
                        }),
                    getDisabledTextField(
                        controller: _currency,
                        labelText: 'Currency',
                        onChanged: (val) {
                          _currency.text = GeneralData.currency = val;
                        }),
                    getDisabledTextField(
                        controller: _currRate,
                        labelText: 'Currency Rate',
                        onChanged: (val) {
                          _currRate.text = GeneralData.currRate = val;
                        }),
                    getDisabledTextField(
                      controller: _localDate,
                      labelText: 'Local Date',
                    ),
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
