import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:maintenance/CheckListDocument/CheckListCodeLookup.dart';
import 'package:maintenance/CheckListDocument/CheckListDocument.dart';
import 'package:maintenance/CheckListDocument/EquipmentCodeLokup.dart';
import 'package:maintenance/CheckListDocument/TechnicianCodeLookup.dart';
import 'package:maintenance/CheckListDocument/WorkCenterLookup.dart';
import 'package:maintenance/Component/CustomFont.dart';
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
  static String? openDate;
  static String? closeDate;
  static String? postingDate;
  static String? validUntill;
  static String? lastReadingDate;
  static String? lastReading;
  static String? assignedUserCode;
  static String? assignedUserName;
  static String? mNJCTransId;
  static String? remarks;
  static String? createdBy;
  static String? updatedBy;
  static String? branchId;
  static String? createDate;
  static String? updateDate;
  static String? currentReading;
  static bool? isConsumption;
  static bool? isRequest;
  static String tyreMaintenance = 'No';

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
      TextEditingController(text: GeneralData.openDate);
  final TextEditingController _closeDate =
      TextEditingController(text: GeneralData.closeDate);
  final TextEditingController _postingDate =
      TextEditingController(text: GeneralData.postingDate);
  final TextEditingController _validUntill =
      TextEditingController(text: GeneralData.validUntill);
  final TextEditingController _lastReadingDate =
      TextEditingController(text: GeneralData.lastReadingDate);
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
  List<String> tyreMaintenanceOptions = ['Yes', 'No'];
  List<String> checkListStatusOptions=['Open','WIP','Close','Transfer To JobCard','Hold'];

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
          getDisabledTextField(controller: _docEntry, labelText: 'Doc Entry'),
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
              controller: _equipmentCode,
              labelText: 'Equipment Code',
              enableLookup: true,
              onLookupPressed: () {
                Get.to(() => EquipmentCodeLookup());
              }),
          getDisabledTextField(
              controller: _equipmentName, labelText: 'Equipment Name'),
          getDisabledTextField(
              controller: _checkListCode,
              labelText: 'Check List Code',
              onLookupPressed: () {
                Get.to(() => CheckListCodeLookup());
              },
              enableLookup: true),
          getDisabledTextField(
              controller: _checkListName, labelText: 'CheckList Name'),
          getDisabledTextField(
            controller: _workCenterCode,
            labelText: 'WorkCenter Code',
            enableLookup: true,
            onLookupPressed: () {
              Get.to(() => WorkCenterLookup());
            },
          ),
          getDisabledTextField(
              controller: _workCenterName, labelText: 'WorkCenter Name'),
          getDisabledTextField(controller: _docStatus, labelText: 'Doc Status'),
          getDisabledTextField(
              controller: _approvalStatus, labelText: 'Approval Status'),

            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 8,
              ),
              child: Row(
                children: [
                  Container(
                    color: Colors.white,
                    child: getHeadingText(text: 'Check List Status : '),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding:
                      const EdgeInsets.only(left: 20.0),
                      child: DropdownButton<String>(
                        items: checkListStatusOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            GeneralData.checkListStatus = val;
                          });
                        },
                        value: GeneralData.checkListStatus,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          getDateTextField(
              controller: _openDate,
              labelText: 'Open Date',
              localCurrController: TextEditingController(),
              onChanged: (val) {
                _openDate.text = GeneralData.openDate = val;
              }),
          getDateTextField(
              controller: _closeDate,
              labelText: 'Close Date',
              localCurrController: TextEditingController(),
              onChanged: (val) {
                _closeDate.text = GeneralData.closeDate = val;
              }),

          getTextField(
              controller: _currentReading,
              labelText: 'Current Reading',
              keyboardType: TextInputType.number,
            inputFormatters: [
              getIntegerRegEx(),
            ]
          ),
          getDateTextField(
              controller: _lastReadingDate,
              labelText: 'Last Reading Date',
              localCurrController: TextEditingController(),
              onChanged: (val) {
                _lastReadingDate.text = GeneralData.lastReadingDate = val;
              }),
          getDisabledTextField(
              controller: _lastReading, labelText: 'Last Reading'),
          getDisabledTextField(
            controller: _assignedUserCode,
            labelText: 'Technician Code',
            enableLookup: true,
            onLookupPressed: () {
              Get.to(() => TechnicianCodeLookup());
            },
          ),
          getDisabledTextField(
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
                      items: tyreMaintenanceOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          GeneralData.tyreMaintenance = val ?? GeneralData.tyreMaintenance;
                          if (GeneralData.tyreMaintenance == 'Yes') {
                            CheckListDocument.numOfTabs.value = 4;
                          } else {
                            CheckListDocument.numOfTabs.value = 3;
                          }
                        });
                      },
                      value: GeneralData.tyreMaintenance,
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
          getTextField(controller: _remarks, labelText: 'Remarks'),
        ],
      ),
    );
  }
}
