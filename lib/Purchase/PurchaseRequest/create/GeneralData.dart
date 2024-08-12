import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/CustomFont.dart';
import 'package:maintenance/Component/GetFormattedDate.dart';
import 'package:maintenance/Component/GetTextField.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/Lookups/DepartmentLookup.dart';
import 'package:maintenance/Lookups/EmployeeLookup.dart';
import 'package:maintenance/Lookups/TripLookup.dart';
import 'package:maintenance/Sync/SyncModels/OEMP.dart';
import 'package:maintenance/Sync/SyncModels/OPOTRP.dart';
import 'package:maintenance/Sync/SyncModels/OUDP.dart';
import 'package:maintenance/Sync/SyncModels/OWHS.dart';
import 'package:maintenance/Sync/SyncModels/PROPRQ.dart';

import '../../../Lookups/WarehouseLookup.dart';

class GeneralData extends StatefulWidget {
  const GeneralData({super.key});

  static bool isSelected = false, hasCreated = false, hasUpdated = false;

  static String? iD;
  static String? transId;
  static String? refNo;
  static String? mobileNo;
  static String? postingDate;
  static String? validUntill;
  static String? approvalStatus;
  static String? docStatus;
  static String? permanentTransId;
  static String? docEntry;
  static String? docNum;
  static String? createdBy;
  static String? createDate;
  static String? updateDate;
  static String? approvedBy;
  static String? error;
  static String? draftKey;
  static String? latitude;
  static String? longitude;
  static String? objectCode;
  static String? whsCode;
  static String? remarks;
  static String? branchId;
  static String? updatedBy;
  static String? postingAddress;
  static String? tripTransId;
  static String? deptCode;
  static String? deptName;
  static String? requestedCode;
  static String? requestedName;

  static bool isPosted = false;
  static bool isConsumption = false;
  static bool isRequest = false;

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
    if (requestedName == "" || requestedName == null) {
      getErrorSnackBar("Invalid Request Field");
      success = false;
    }

    if (whsCode == "" || whsCode == null) {
      getErrorSnackBar("Invalid toWhsCode");
      success = false;
    }

    return success;
  }

  static PROPRQ getGeneralData() {
    return PROPRQ(
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
        RequestedCode: requestedCode,
        RequestedName: requestedName,
        PostingAddress: postingAddress,
        MobileNo: mobileNo,
        RefNo: refNo,
        DeptCode: deptCode,
        DeptName: deptName,
        IsPosted: isPosted,
        ApprovalStatus: approvalStatus ?? "Pending",
        DocStatus: docStatus,
        WhsCode: whsCode);
  }

  @override
  State<GeneralData> createState() => _GeneralDataState();
}

class _GeneralDataState extends State<GeneralData> {
  final TextEditingController _iD = TextEditingController(text: GeneralData.iD);
  final TextEditingController _transId =
      TextEditingController(text: GeneralData.transId);
  final TextEditingController _refNo =
      TextEditingController(text: GeneralData.refNo);
  final TextEditingController _mobileNo =
      TextEditingController(text: GeneralData.mobileNo);
  final TextEditingController _postingDate =
      TextEditingController(text: GeneralData.postingDate);
  final TextEditingController _validUntill =
      TextEditingController(text: GeneralData.validUntill);
  final TextEditingController _approvalStatus =
      TextEditingController(text: GeneralData.approvalStatus);
  final TextEditingController _docStatus =
      TextEditingController(text: GeneralData.docStatus);
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
  final TextEditingController _whsCode =
      TextEditingController(text: GeneralData.whsCode);
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
  final TextEditingController _requestedCode =
      TextEditingController(text: GeneralData.requestedCode);
  final TextEditingController _requestedName =
      TextEditingController(text: GeneralData.requestedName);

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
                    GeneralData.transId = _transId.text = val;
                  }),
              getDisabledTextField(
                  controller: _deptName,
                  labelText: 'Department Name',
                  onChanged: (val) {
                    GeneralData.deptName = _deptName.text = val;
                  },
                  enableLookup: true,
                  onLookupPressed: () {
                    Get.to(() => DepartmentLookup(onSelection: (OUDP oudp) {
                          setState(() {
                            GeneralData.deptCode = oudp.Code ?? '';
                            GeneralData.deptName =
                                _deptName.text = oudp.Name ?? '';
                          });
                        }));
                  }),
              getDisabledTextField(
                  controller: _tripTransId,
                  labelText: 'TripTransId',
                  onChanged: (val) {
                    GeneralData.tripTransId = _tripTransId.text = val;
                  },
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
                    GeneralData.refNo = _refNo.text = val;
                  }),
              getDisabledTextField(
                  controller: _requestedName,
                  labelText: 'Requester Name*',
                  onChanged: (val) {
                    GeneralData.requestedName = _requestedName.text = val;
                  },
                  enableLookup: true,
                  onLookupPressed: () {
                    Get.to(() => EmployeeLookup(onSelection: (OEMPModel oemp) {
                          setState(() {
                            GeneralData.requestedCode = oemp.Code;
                            GeneralData.requestedName =
                                _requestedName.text = oemp.Name ?? '';
                          });
                        }));
                  }),
              getDisabledTextField(
                  controller: _whsCode,
                  labelText: 'WhsCode',
                  onChanged: (val) {
                    GeneralData.whsCode = _whsCode.text = val;
                  },
                  enableLookup: true,
                  onLookupPressed: () {
                    Get.to(() => WarehouseLookup(onSelection: (OWHS owhs) {
                          setState(() {
                            GeneralData.whsCode =
                                _whsCode.text = owhs.WhsCode ?? '';
                          });
                        }));
                  }),
              getDisabledTextField(
                  controller: TextEditingController(),
                  labelText: 'City',
                  onChanged: (val) {
                    //todo:
                    // GeneralData.permanentTransId = _permanentTransId.text = val;
                  }),
              getDisabledTextField(
                  controller: TextEditingController(),
                  labelText: 'State',
                  onChanged: (val) {
                    //todo:
                    // GeneralData.permanentTransId = _permanentTransId.text = val;
                  }),
              getDateTextField(
                  controller: _postingDate,
                  labelText: 'Posting Date',
                  onChanged: (val) {
                    GeneralData.postingDate = _postingDate.text = val;
                  },
                  localCurrController: TextEditingController()),
              getDateTextField(
                  controller: _validUntill,
                  labelText: 'Valid Until',
                  onChanged: (val) {
                    GeneralData.validUntill = _validUntill.text = val;
                  },
                  localCurrController: TextEditingController()),
              getDisabledTextField(
                  controller: _docStatus,
                  labelText: 'Doc Status',
                  onChanged: (val) {
                    GeneralData.docStatus = _docStatus.text = val;
                  }),
              getDisabledTextField(
                  controller: _approvalStatus,
                  labelText: 'Approval Status',
                  onChanged: (val) {
                    GeneralData.approvalStatus = _approvalStatus.text = val;
                  }),
              getTextField(
                  controller: _remarks,
                  labelText: 'Remarks',
                  onChanged: (val) {
                    GeneralData.remarks = _remarks.text = val;
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
                      controller: _docEntry,
                      labelText: 'Doc Entry',
                      onChanged: (val) {
                        GeneralData.docEntry = val;
                      },
                    ),
                    getDisabledTextField(
                      controller: TextEditingController(),
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
