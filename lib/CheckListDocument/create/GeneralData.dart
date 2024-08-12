import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance/CheckListDocument/create/CheckListDocument.dart';
import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/GetFormattedDate.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/Lookups/TechnicianCodeLookup.dart';
import 'package:maintenance/Lookups/WorkCenterLookup.dart';
import 'package:maintenance/Component/CustomFont.dart';
import 'package:maintenance/Component/GetTextField.dart';
import 'package:maintenance/Lookups/CheckListCodeLookup.dart';
import 'package:maintenance/Lookups/EquipmentCodeLokup.dart';
import 'package:maintenance/Sync/SyncModels/MNOCLD.dart';
import 'package:maintenance/Sync/SyncModels/MNOCLM.dart';
import 'package:maintenance/Sync/SyncModels/MNOWCM.dart';
import 'package:maintenance/Sync/SyncModels/OEMP.dart';
import 'package:maintenance/Sync/SyncModels/OVCL.dart';

class GeneralData extends StatefulWidget {
  GeneralData({super.key});

  static bool isSelected = false, hasCreated = false, hasUpdated = false;

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
  static bool validate() {
    bool success = true;


    if (transId == "" || transId == null) {
      getErrorSnackBar("Invalid TransId");
      success = false;
    }
    if (equipmentName == "" || equipmentName == null) {
      getErrorSnackBar("Invalid Equipment");
      success = false;
    }
    if (checkListName == "" || checkListName == null) {
      getErrorSnackBar("Invalid Check List");
      success = false;
    }

    if (workCenterName == "" || workCenterName == null) {
      getErrorSnackBar("Invalid Work Center");
      success = false;
    }
    if (assignedUserName == "" || assignedUserName == null) {
      getErrorSnackBar("Invalid Technician");
      success = false;
    }

    return success;
  }
  static MNOCLD getGeneralData() {
    return MNOCLD(
        ID: int.tryParse(iD ?? ''),
        TransId: transId,
        DocNum: docNum ?? '',
        PermanentTransId: permanentTransId ?? '',

        PostingDate: getDateFromString(postingDate ?? ""),
        ValidUntill: getDateFromString(validUntill ?? ''),

        hasCreated: hasCreated,
        hasUpdated: hasUpdated,
        ObjectCode: '23',
        Remarks: remarks,
        AssignedUserCode: assignedUserCode,
        AssignedUserName: assignedUserName,
        CheckListCode: checkListCode,
        CheckListName: checkListName,
        CheckListStatus: checkListStatus,
        CurrentReading: currentReading,
        EquipmentCode: equipmentCode,
        EquipmentName: equipmentName,
        IsConsumption: isConsumption,
        IsRequest: isRequest,
        WorkCenterCode: workCenterCode,
        WorkCenterName: workCenterName,
        MNJCTransId: mNJCTransId,
        OpenDate: getDateFromString(openDate ?? ""),
        CloseDate: getDateFromString(closeDate ?? ""),
        LastReading: lastReading,
        LastReadingDate: getDateFromString(lastReadingDate ?? ""),


        ApprovalStatus: approvalStatus ?? "Pending",
        DocStatus: docStatus,
       );
  }

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
  List<String> checkListStatusOptions = [
    'Open',
    'WIP',
    'Close',
    'Transfer To JobCard',
    'Hold'
  ];

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

              getDisabledTextField(controller: _transId, labelText: 'Trans Id',
                  onChanged: (val) {
                    GeneralData.transId  = val;
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
              // getDisabledTextField(
              //     controller: _equipmentCode,
              //     labelText: 'Equipment Code',
              //     ),
              getDisabledTextField(
                  controller: _equipmentName, labelText: 'Equipment',
                  enableLookup: true,
                  onLookupPressed: () {
                    Get.to(() => EquipmentCodeLookup(
                      onSelection: (OVCLModel ovcl) {
                        setState(() {
                          GeneralData.equipmentCode =
                              _equipmentCode.text = ovcl.Code;
                          GeneralData.equipmentName =
                              _equipmentName.text = ovcl.Code;
                        });
                      },
                    ));
                  }),
              // getDisabledTextField(
              //     controller: _checkListCode,
              //     labelText: 'Check List Code',
              //     ),
              getDisabledTextField(
                  controller: _checkListName, labelText: 'CheckList',
                  onLookupPressed: () {
                    Get.to(() => CheckListCodeLookup(
                      onSelection: (MNOCLM mnoclm) {
                        setState(() {
                          GeneralData.checkListCode =
                              _checkListCode.text = mnoclm.Code ?? '';
                          GeneralData.checkListName =
                              _checkListName.text = mnoclm.Name ?? '';
                        });
                      },
                    ));
                  },
                  enableLookup: true),
              // getDisabledTextField(
              //   controller: _workCenterCode,
              //   labelText: 'WorkCenter Code',
              //
              // ),
              getDisabledTextField(
                  controller: _workCenterName, labelText: 'WorkCenter',
                enableLookup: true,
                onLookupPressed: () {
                  Get.to(() => WorkCenterLookup(
                    onSelection: (MNOWCM mnowcm) {
                      setState(() {
                        GeneralData.workCenterCode =
                            _workCenterCode.text = mnowcm.Code ?? '';
                        GeneralData.workCenterName =
                            _workCenterName.text = mnowcm.Name ?? '';
                      });
                    },
                  ));
                },),
              getDisabledTextField(controller: _docStatus, labelText: 'Doc Status',
                  onChanged: (val) {
                    GeneralData.docStatus  = val;
                  }),
              getDisabledTextField(
                  controller: _approvalStatus, labelText: 'Approval Status',
                  onChanged: (val) {
                    GeneralData.approvalStatus  = val;
                  }),
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
                        padding: const EdgeInsets.only(left: 20.0),
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
                  onChanged: (val) {
                    GeneralData.currentReading  = val;
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    getIntegerRegEx(),
                  ]),
              getDateTextField(
                  controller: _lastReadingDate,
                  labelText: 'Last Reading Date',
                  localCurrController: TextEditingController(),
                  onChanged: (val) {
                    _lastReadingDate.text = GeneralData.lastReadingDate = val;
                  }),
              getDisabledTextField(
                  controller: _lastReading, labelText: 'Last Reading',
                onChanged: (val) {
                  GeneralData.lastReading  = val;
                },),
              // getDisabledTextField(
              //   controller: _assignedUserCode,
              //   labelText: 'Technician Code',
              //
              // ),
              getDisabledTextField(
                  controller: _assignedUserName, labelText: 'Technician',
                enableLookup: true,
                onLookupPressed: () {
                  Get.to(() => TechnicianCodeLookup(onSelection: (OEMPModel oemp){
                    setState(() {
                      GeneralData.assignedUserCode=_assignedUserCode.text=oemp.Code;
                      GeneralData.assignedUserName=_assignedUserName.text=oemp.Name??'';
                    });
                  },));
                },),
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
                              GeneralData.tyreMaintenance =
                                  val ?? GeneralData.tyreMaintenance;
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
              getTextField(controller: _remarks, labelText: 'Remarks',
                onChanged: (val) {
                  GeneralData.remarks  = val;
                },),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ExpansionTile(
                  collapsedBackgroundColor: barColor,
                  backgroundColor: barColor,
                  title: getHeadingText(text: "Details", color: headColor),
                  children: [
                    getDisabledTextField(
                        controller: _permanentTransId, labelText: 'Permanent Trans Id',
                      onChanged: (val) {
                        GeneralData.permanentTransId  = val;
                      },),
                    getDisabledTextField(controller: _docNum, labelText: 'ERP Docnum',
                      onChanged: (val) {
                        GeneralData.docNum  = val;
                      },),
                    getDisabledTextField(controller: _docEntry, labelText: 'Doc Entry',
                      onChanged: (val) {
                        GeneralData.docEntry  = val;
                      },),
                  ],
                ),
              ),
              const SizedBox(height: 70,),
            ],
          ),
        ),
      ),
    );
  }
}
