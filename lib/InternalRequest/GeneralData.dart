import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance/Component/GetFormattedDate.dart';
import 'package:maintenance/Component/GetTextField.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/Lookups/DepartmentLookup.dart';
import 'package:maintenance/Lookups/EmployeeLookup.dart';
import 'package:maintenance/Lookups/TripLookup.dart';
import 'package:maintenance/Lookups/WarehouseLookup.dart';
import 'package:maintenance/Sync/SyncModels/OEMP.dart';
import 'package:maintenance/Sync/SyncModels/OPOTRP.dart';
import 'package:maintenance/Sync/SyncModels/OUDP.dart';
import 'package:maintenance/Sync/SyncModels/OWHS.dart';
import 'package:maintenance/Sync/SyncModels/PROITR.dart';

class GeneralData extends StatefulWidget {
  const GeneralData({super.key});

  static String? iD;
  static String? transId;
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
  static String? fromWhsCode;
  static String? toWhsCode;
  static String? remarks;
  static String? branchId;
  static String? updatedBy;
  static String? postingAddress;
  static String? tripTransId;
  static String? deptCode;
  static String? deptName;

  static bool isConsumption = false;
  static bool isRequest = false;
  static bool isSelected = false, hasCreated = false, hasUpdated = false;

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

    if (toWhsCode == "" || toWhsCode == null) {
      getErrorSnackBar("Invalid toWhsCode");
      success = false;
    }

    return success;
  }

  static PROITR getGeneralData() {
    return PROITR(
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
      ToWhsCode: toWhsCode,
      RequestedCode: requestedCode,
      RequestedName: requestedName,
      PostingAddress: postingAddress,
      MobileNo: mobileNo,
      Currency: currency,
      CurrRate: double.tryParse(currRate?.toString() ?? ''),
      RefNo: refNo,
      DeptCode: deptCode,
      DeptName: deptName,
      IsPosted: isPosted,
      FromWhsCode: fromWhsCode,
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
  final TextEditingController _fromWhsCode =
      TextEditingController(text: GeneralData.fromWhsCode);
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

  List<String> typeList = ['Preventive', 'Breakdown'];
  String type = 'Preventive';
  List<String> warrantyList = ['Yes', 'No'];
  String warranty = 'Yes';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 25,
          ),
          getDisabledTextField(
              controller: _permanentTransId,
              labelText: 'Permanent Trans Id',
              onChanged: (val) {
                GeneralData.permanentTransId = val;
              }),
          getDisabledTextField(
              controller: _docNum,
              labelText: 'ERP Docnum',
              onChanged: (val) {
                GeneralData.docNum = val;
              }),
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
                Get.to(() => DepartmentLookup(onSelection: (OUDP oudp) {
                      setState(() {
                        GeneralData.deptCode = oudp.Code ?? '';
                        GeneralData.deptName = _deptName.text = oudp.Name ?? '';
                      });
                    }));
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
                GeneralData.refNo = val;
              }),
          getDisabledTextField(
              controller: _requestedName,
              labelText: 'Request Name*',
              onChanged: (val) {
                GeneralData.requestedName = val;
              },
              enableLookup: true,
              onLookupPressed: () {
                Get.to(() => EmployeeLookup(onSelection: (OEMPModel oemp) {
                      setState(() {
                        GeneralData.requestedName = oemp.Code;
                        GeneralData.requestedName =
                            _requestedName.text = oemp.Name ?? '';
                      });
                    }));
              }),
          getDisabledTextField(
              controller: _mobileNo,
              labelText: 'Mobile Number',
              onChanged: (val) {
                GeneralData.mobileNo = val;
              }),
          getDisabledTextField(
              controller: _fromWhsCode,
              labelText: 'From Warehouse',
              onChanged: (val) {
                GeneralData.fromWhsCode = val;
              },
              enableLookup: true,
              onLookupPressed: () {
                Get.to(() => WarehouseLookup(onSelection: (OWHS owhs) {
                      setState(() {
                        GeneralData.fromWhsCode =
                            _fromWhsCode.text = owhs.WhsCode ?? '';
                      });
                    }));
              }),
          getDisabledTextField(
              controller: _toWhsCode,
              labelText: 'To Warehouse',
              onChanged: (val) {
                GeneralData.toWhsCode = val;
              },
              enableLookup: true,
              onLookupPressed: () {
                Get.to(() => WarehouseLookup(onSelection: (OWHS owhs) {
                      setState(() {
                        GeneralData.toWhsCode =
                            _toWhsCode.text = owhs.WhsCode ?? '';
                      });
                    }));
              }),
          getTextField(
              controller: _remarks,
              labelText: 'Remarks',
              onChanged: (val) {
                GeneralData.remarks = val;
              }),
          getDateTextField(
              controller: _postingDate,
              labelText: 'Posting Date',
              localCurrController: TextEditingController(),
              onChanged: (val) {
                GeneralData.postingDate = val;
              }),
          getDateTextField(
              controller: _validUntill,
              labelText: 'Valid Until',
              localCurrController: TextEditingController(),
              onChanged: (val) {
                GeneralData.validUntill = val;
              }),
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
              controller: _docStatus,
              labelText: 'Doc Status',
              onChanged: (val) {
                GeneralData.docStatus = val;
              }),
          getDisabledTextField(
              controller: _approvalStatus,
              labelText: 'Approval Status',
              onChanged: (val) {
                GeneralData.approvalStatus = val;
              }),
          getDisabledTextField(
              controller: TextEditingController(), labelText: 'Local Date'),
        ],
      ),
    );
  }
}
