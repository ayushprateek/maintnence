import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance/CheckListDocument/CheckListDocument.dart';
import 'package:maintenance/Component/GetFormattedDate.dart';
import 'package:maintenance/Component/GetTextField.dart';

class GeneralData extends StatefulWidget {
  GeneralData({super.key});

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
  static String? currentReading;
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
  final TextEditingController _currentReading =
      TextEditingController(text: GeneralData.currentReading);
  List<String> status = ['Yes', 'No'];
  String Status = 'No';



  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          getTextFieldWithoutLookup(
              controller: _permanentTransId, labelText: 'Permanent Trans Id'),
          getTextFieldWithoutLookup(
              controller: _docNum, labelText: 'ERP Docnum'),
          getTextFieldWithoutLookup(
              controller: _transId, labelText: 'Trans Id'),
          getTextFieldWithoutLookup(
              controller: _docEntry, labelText: 'Doc Entry'),
          getTextFieldWithoutLookup(
              controller: _postingDate, labelText: 'Posting Date'),
          getTextFieldWithoutLookup(
              controller: _validUntill, labelText: 'Valid Until'),
          getTextFieldWithoutLookup(
              controller: _equipmentCode, labelText: 'Equipment Code'),
          getTextFieldWithoutLookup(
              controller: _equipmentName, labelText: 'Equipment Name'),
          getTextFieldWithoutLookup(
              controller: _checkListCode, labelText: 'Check List Code'),
          getTextFieldWithoutLookup(
              controller: _checkListName, labelText: 'CheckList Name'),
          getTextFieldWithoutLookup(
              controller: _workCenterCode, labelText: 'WorkCenter Code'),
          getTextFieldWithoutLookup(
              controller: _workCenterName, labelText: 'WorkCenter Name'),
          getTextFieldWithoutLookup(
              controller: _docStatus, labelText: 'Doc Status'),
          getTextFieldWithoutLookup(
              controller: _approvalStatus, labelText: 'Approval Status'),
          getTextFieldWithoutLookup(
              controller: _checkListStatus, labelText: 'Check List Status'),
          getTextFieldWithoutLookup(
              controller: _openDate, labelText: 'Open Date'),
          getTextFieldWithoutLookup(
              controller: _closeDate, labelText: 'Close Date'),
          getTextFieldWithoutLookup(
              controller: _currentReading, labelText: 'Current Reading'),
          getTextFieldWithoutLookup(
              controller: _lastReadingDate, labelText: 'Last Reading Date'),
          getTextFieldWithoutLookup(
              controller: _lastReading, labelText: 'Last Reading'),
          getTextFieldWithoutLookup(
              controller: _assignedUserCode, labelText: 'Technician Code'),
          getTextFieldWithoutLookup(
              controller: _assignedUserName, labelText: 'Technician Name'),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 6.0,
              left: 8,
              right: 8,
            ),
            child: Container(
              height: MediaQuery.of(context).size.height / 16,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      "Tyre Maintenance : ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: DropdownButton<String>(
                      items: status.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          Status = val ?? Status;
                          if (Status == 'Yes') {
                            CheckListDocument.numOfTabs.value=4;
                          } else {
                            CheckListDocument.numOfTabs.value=3;
                          }
                        });
                      },
                      value: Status,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.select_all,
                      color: Colors.white,
                    ),
                    onPressed: null,
                  )
                ],
              ),
            ),
          ),
          getTextFieldWithoutLookup(controller: _remarks, labelText: 'Remarks'),
        ],
      ),
    );
  }
}
