import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance/Component/AppConfig.dart';
import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/CustomFont.dart';
import 'package:maintenance/Component/CustomViewImage.dart';
import 'package:maintenance/Component/DownloadFileFromServer.dart';
import 'package:maintenance/Component/GetFormattedDate.dart';
import 'package:maintenance/Component/GetTextField.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/JobCard/view/Attachment.dart';
import 'package:maintenance/Sync/SyncModels/MNOJCD.dart';

class GeneralData extends StatefulWidget {
  const GeneralData({super.key});

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
  static String? currentReading;
  static String? difference;
  static String? subject;
  static String? resolution;
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
  static String warranty = 'Yes';
  static String type = 'Breakdown';

  static bool isConsumption = false;
  static bool isRequest = false;

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

  static MNOJCD getGeneralData() {
    return MNOJCD(
      ID: int.tryParse(iD ?? ''),
      TransId: transId,
      Subject: subject,
      Resolution: resolution,

      //todo:
      // DocNum: docNum ?? '',
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
      EquipmentCode: equipmentCode,
      EquipmentName: equipmentName,
      IsConsumption: isConsumption,
      IsRequest: isRequest,
      WorkCenterCode: workCenterCode,
      WorkCenterName: workCenterName,
      OpenDate: getDateFromString(openDate ?? ""),
      CloseDate: getDateFromString(closeDate ?? ""),
      WarrentyApplicable: warranty == 'Yes',
      Type: type,
      //todo
      // LastReading: lastReading,
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
  final TextEditingController _currentReading =
      TextEditingController(text: GeneralData.currentReading);
  final TextEditingController _difference =
      TextEditingController(text: GeneralData.difference);
  final TextEditingController _subject =
      TextEditingController(text: GeneralData.subject);
  final TextEditingController _resolution =
      TextEditingController(text: GeneralData.resolution);
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

  List<String> typeList = ['Preventive', 'Breakdown'];

  List<String> warrantyList = ['Yes', 'No'];

  List<String> checkListStatusOptions = [
    'Open',
    'Close',
    'Hold',
    'WIP',
    'Update'
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

              getDisabledTextField(
                controller: _transId,
                labelText: 'Trans Id',
                onChanged: (val) {
                  GeneralData.transId = val;
                },
              ),
              getDateTextField(
                controller: _postingDate,
                labelText: 'Posting Date',
                onChanged: (val) {
                  GeneralData.postingDate = _postingDate.text = val;
                },
                localCurrController: TextEditingController(),
              ),
              getDateTextField(
                controller: _validUntill,
                labelText: 'Valid Until',
                onChanged: (val) {
                  GeneralData.validUntill = _validUntill.text = val;
                },
                localCurrController: TextEditingController(),
              ),
              // getDisabledTextField(
              //     controller: _equipmentCode,
              //     labelText: 'Equipment Code',
              //     ),

              getDisabledTextField(
                  controller: _equipmentName, labelText: 'Equipment'),
              // getDisabledTextField(
              //     controller: _checkListCode,
              //     labelText: 'Check List Code',
              //     ),

              getDisabledTextField(
                  controller: _checkListName, labelText: 'CheckList'),
              // getDisabledTextField(
              //   controller: _workCenterCode,
              //   labelText: 'WorkCenter Code',
              //
              // ),

              getDisabledTextField(
                controller: _workCenterName,
                labelText: 'WorkCenter',
              ),

              getDisabledTextField(
                controller: _docStatus,
                labelText: 'Doc Status',
                onChanged: (val) {
                  GeneralData.docStatus = val;
                },
              ),
              getDisabledTextField(
                controller: _approvalStatus,
                labelText: 'Approval Status',
                onChanged: (val) {
                  GeneralData.approvalStatus = val;
                },
              ),
              getDisabledTextField(
                controller:
                    TextEditingController(text: GeneralData.checkListStatus),
                labelText: 'Status',
                onChanged: (val) {
                  GeneralData.checkListStatus = val;
                },
              ),

              getDateTextField(
                controller: _openDate,
                labelText: 'Open Date',
                localCurrController: TextEditingController(),
                onChanged: (val) {
                  GeneralData.openDate = _openDate.text = val;
                },
              ),
              getDateTextField(
                controller: _closeDate,
                labelText: 'Close Date',
                onChanged: (val) {
                  GeneralData.closeDate = _closeDate.text = val;
                },
                localCurrController: TextEditingController(),
              ),

              getDisabledTextField(
                controller: TextEditingController(text: GeneralData.type),
                labelText: 'Type',
                onChanged: (val) {
                  GeneralData.type = val;
                },
              ),
              getDisabledTextField(
                controller: _currentReading,
                labelText: 'Current Reading',
                onChanged: (val) {
                  GeneralData.currentReading = val;
                },
              ),

              getDisabledTextField(
                controller: _difference,
                labelText: 'Difference',
                onChanged: (val) {
                  GeneralData.difference = val;
                },
              ),
              getDateTextField(
                controller: _lastReadingDate,
                labelText: 'Last Reading Date',
                localCurrController: TextEditingController(),
                onChanged: (val) {
                  GeneralData.lastReadingDate = _lastReadingDate.text = val;
                },
              ),

              getDisabledTextField(
                controller: _lastReading,
                labelText: 'Last Reading',
                onChanged: (val) {
                  GeneralData.lastReading = val;
                },
              ),

              getDisabledTextField(
                controller: _subject,
                labelText: 'Subject',
                onChanged: (val) {
                  GeneralData.subject = val;
                },
              ),

              getDisabledTextField(
                controller: _resolution,
                labelText: 'Resolution',
                onChanged: (val) {
                  GeneralData.resolution = val;
                },
              ),

              getDisabledTextField(
                  controller: _assignedUserName, labelText: 'Technician Code'),
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
                          "Warranty Applicable : ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: DropdownButton<String>(
                          items: warrantyList.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              GeneralData.warranty =
                                  val ?? GeneralData.warranty;
                              // if (Status == 'Yes') {
                              //   CheckListDocument.numOfTabs.value = 4;
                              // } else {
                              //   CheckListDocument.numOfTabs.value = 3;
                              // }
                            });
                          },
                          value: GeneralData.warranty,
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
              getDisabledTextField(
                controller: _remarks,
                labelText: 'Remarks',
                onChanged: (val) {
                  GeneralData.remarks = val;
                },
              ),
              if (Attachments.attachments.length > 3) ...[
                SizedBox(
                  height: Get.height / 4,
                  child: ListView.builder(
                      itemCount: 4,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      physics: const ScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(16.0),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4.0,
                                offset: Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                          margin: const EdgeInsets.all(15),
                          width: Get.width / 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      getPoppinsTextSpanHeading(text: 'Row ID'),
                                      getPoppinsTextSpanDetails(
                                          text: Attachments
                                              .attachments[index].RowId
                                              .toString()),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      getPoppinsTextSpanHeading(
                                          text: 'Remarks'),
                                      getPoppinsTextSpanDetails(
                                          text: Attachments
                                              .attachments[index].Remarks
                                              .toString()),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: FutureBuilder(
                                      future: downloadFileFromServer(
                                          path: Attachments.attachments[index]
                                                  .Attachment ??
                                              ''),
                                      builder:
                                          (context, AsyncSnapshot<File?> snap) {
                                        if (!snap.hasData ||
                                            snap.data == null) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                child: SizedBox(
                                                    height: Get.height / 8,
                                                    child: Image.asset(
                                                        'images/no_image.jpg'))),
                                          );
                                        } else {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              child: Image.file(
                                                snap.data!,
                                                fit: BoxFit.cover,
                                                height: Get.height / 8,
                                              ),
                                            ),
                                          );
                                        }
                                      }),
                                )
                              ],
                            ),
                          ),
                        );
                        return InkWell(
                          onTap: () {
                            String attachment =
                                Attachments.attachments[index].Attachment ?? '';
                            if (attachment != "") {
                              if (attachment.contains(appPkg)) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CustomViewImage(
                                            imageFile: File(attachment))));
                              } else {
                                //todo:
                                // customLaunchURL(
                                //     prefix + attachment.replaceAll("\\", "/"));
                              }
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(16.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4.0,
                                  offset: Offset(2.0, 2.0),
                                ),
                              ],
                            ),
                            margin: const EdgeInsets.all(15),
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        getPoppinsTextSpanHeading(
                                            text: 'Row ID'),
                                        getPoppinsTextSpanDetails(
                                            text: Attachments
                                                .attachments[index].RowId
                                                .toString()),
                                      ],
                                    ),
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        getPoppinsTextSpanHeading(
                                            text: 'Remarks'),
                                        getPoppinsTextSpanDetails(
                                            text: Attachments
                                                .attachments[index].Remarks
                                                .toString()),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.folder,
                                        color: folderColor,
                                      ),
                                      Flexible(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: getPoppinsText(
                                            text: Attachments.attachments[index]
                                                    .Attachment ??
                                                '',
                                            fontSize: 12,
                                            textAlign: TextAlign.start,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w500,
                                            decoration:
                                                TextDecoration.underline),
                                      )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ],
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
                      labelText: 'ERP Doc Num',
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
