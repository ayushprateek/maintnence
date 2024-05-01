import 'package:flutter/material.dart';
import 'package:maintenance/Component/GetFormattedDate.dart';
import 'package:maintenance/Component/GetTextField.dart';
class GeneralData extends StatefulWidget {
  const GeneralData({super.key});
  static String? iD;
  static String? permanentTransId;
  static String? transId;
  static String? docEntry;
  static String? docNum;
  static String? canceled;
  static String? docStatus;
  static String? approvalStatus;
  static String? checkListStatus;
  static String? objectCode;
  static String? equipmentCode;
  static String? equipmentName;
  static String? checkListCode;
  static String? checkListName;
  static String? workCenterCode;
  static String? workCenterName;
  static DateTime? openDate;
  static DateTime? closeDate;
  static DateTime? postingDate;
  static DateTime? validUntill;
  static DateTime? lastReadingDate;
  static String? lastReading;
  static String? assignedUserCode;
  static String? assignedUserName;
  static String? mNJCTransId;
  static String? remarks;
  static String? createdBy;
  static String? updatedBy;
  static String? branchId;
  static DateTime? createDate;
  static DateTime? updateDate;

  static bool? isConsumption;
  static bool? isRequest;

  @override
  State<GeneralData> createState() => _GeneralDataState();
}

class _GeneralDataState extends State<GeneralData> {
  final TextEditingController _permanentTransId =
  TextEditingController(text: GeneralData.permanentTransId);
  final TextEditingController _transId =
  TextEditingController(text: GeneralData.transId);
  final TextEditingController _docEntry =
  TextEditingController(text: GeneralData.docEntry);
  final TextEditingController _docNum =
  TextEditingController(text: GeneralData.docNum);
  final TextEditingController _docStatus =
  TextEditingController(text: GeneralData.docStatus);
  final TextEditingController _approvalStatus =
  TextEditingController(text: GeneralData.approvalStatus);
  final TextEditingController _checkListStatus =
  TextEditingController(text: GeneralData.checkListStatus);
  final TextEditingController _equipmentCode =
  TextEditingController(text: GeneralData.equipmentCode);
  final TextEditingController _equipmentName =
  TextEditingController(text: GeneralData.equipmentName);
  final TextEditingController _checkListCode =
  TextEditingController(text: GeneralData.checkListCode);
  final TextEditingController _checkListName =
  TextEditingController(text: GeneralData.checkListName);
  final TextEditingController _workCenterCode =
  TextEditingController(text: GeneralData.workCenterCode);
  final TextEditingController _workCenterName =
  TextEditingController(text: GeneralData.workCenterName);
  final TextEditingController _openDate =
  TextEditingController(text: getFormattedDate(GeneralData.openDate));
  final TextEditingController _closeDate =
  TextEditingController(text: getFormattedDate(GeneralData.closeDate));
  final TextEditingController _postingDate =
  TextEditingController(text: getFormattedDate(GeneralData.postingDate));
  final TextEditingController _validUntill =
  TextEditingController(text: getFormattedDate(GeneralData.validUntill));
  final TextEditingController _lastReadingDate = TextEditingController(
      text: getFormattedDate(GeneralData.lastReadingDate));
  final TextEditingController _lastReading =
  TextEditingController(text: GeneralData.lastReading);
  final TextEditingController _assignedUserCode =
  TextEditingController(text: GeneralData.assignedUserCode);
  final TextEditingController _assignedUserName =
  TextEditingController(text: GeneralData.assignedUserName);
  final TextEditingController _remarks =
  TextEditingController(text: GeneralData.remarks);

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
              controller: _permanentTransId, labelText: 'Permanent Trans Id'),
          getDisabledTextField(controller: _docNum, labelText: 'ERP Docnum'),
          getDisabledTextField(controller: _transId, labelText: 'Trans Id'),
          getDisabledTextField(controller: _docEntry, labelText: 'Department Name'),
          getDisabledTextField(controller: _docEntry, labelText: 'Supplier Code'),
          getDisabledTextField(controller: _docEntry, labelText: 'Supplier Name'),
          getDisabledTextField(controller: _docEntry, labelText: 'Person Name'),
          getDisabledTextField(controller: _docEntry, labelText: 'Mobile No'),
          getDisabledTextField(
              controller: _postingDate, labelText: 'Posting Date'),
          getDisabledTextField(
              controller: _validUntill, labelText: 'Valid Until'),

          getDisabledTextField(controller: _docEntry, labelText: 'Currency'),
          getDisabledTextField(controller: _docEntry, labelText: 'Currency Rate'),
          getDisabledTextField(controller: _docEntry, labelText: 'Approval Status'),
          getDisabledTextField(controller: _docEntry, labelText: 'Doc Status'),
          getDisabledTextField(controller: _docEntry, labelText: 'Local Date'),
          getDisabledTextField(controller: _docEntry, labelText: 'Remarks'),


        ],
      ),
    );
  }
}