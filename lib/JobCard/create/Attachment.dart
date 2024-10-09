import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maintenance/Component/AnimatedDialogBox.dart';
import 'package:maintenance/Component/AppConfig.dart';
import 'package:maintenance/Component/Common.dart';
import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/CustomFont.dart';
import 'package:maintenance/Component/CustomPickFile.dart';
import 'package:maintenance/Component/CustomUrlLauncher.dart';
import 'package:maintenance/Component/CustomViewImage.dart';
import 'package:maintenance/Component/GetTextField.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/JobCard/create/GeneralData.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/SyncModels/MNJCD3.dart';

class Attachments extends StatefulWidget {
  static List<MNJCD3> attachments = [];
  static String? attachment, docName, rowId, Remarks;
  static File? imageFile;

  Attachments() {
    if (attachment != null && attachment != "")
      Attachments.imageFile = File(attachment!);
  }

  @override
  State<Attachments> createState() => _AttachmentsState();
}

class _AttachmentsState extends State<Attachments> {
  TextEditingController rowId = TextEditingController(text: Attachments.rowId);
  TextEditingController attachment =
      TextEditingController(text: Attachments.attachment);
  TextEditingController docName =
      TextEditingController(text: Attachments.docName);
  TextEditingController Remarks =
      TextEditingController(text: Attachments.Remarks);

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
                height: 15,
              ),
              getDisabledTextField(
                controller: rowId,
                labelText: 'Row Id',
                onChanged: (value) {
                  Attachments.rowId = value;
                },
              ),
              getTextField(
                controller: Remarks,
                labelText: 'Remarks',
                onChanged: (value) {
                  Attachments.Remarks = value;
                },
              ),
              Attachments.attachment == null ||
                      Attachments.attachment == "" ||
                      Attachments.attachment == "null"
                  ? getDisabledTextField(
                      controller: attachment,
                      labelText: 'File',
                      onChanged: (value) {
                        Attachments.attachment = value;
                      },
                      onTap: () async {
                        await AnimatedDialogBox.showScaleAlertBox(
                            title: Center(child: Text("Upload Document")),
                            // IF YOU WANT TO ADD
                            context: context,
                            firstButton: MaterialButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                              color: Colors.white,
                              child: Text('Camera'),
                              onPressed: () async {
                                Attachments.imageFile =
                                    await customPickImage(ImageSource.camera);
                                rowId.text =
                                    Attachments.attachments.length.toString();
                                Attachments.attachment = attachment.text =
                                    Attachments.imageFile?.path ?? '';

                                setState(() {});
                                Get.back();
                              },
                            ),
                            secondButton: MaterialButton(
                              // FIRST BUTTON IS REQUIRED
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                              color: barColor,
                              child: Text(
                                'Device storage',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                File? selectedFile =
                                    await customPickImage(ImageSource.gallery);
                                Get.back();
                              },
                            ),
                            icon: Icon(
                              Icons.upload_rounded,
                              color: barColor,
                            ),
                            // IF YOU WANT TO ADD ICON
                            yourWidget: Container(
                              child: Text('How do you want to upload?'),
                            ));
                      },
                    )
                  : InkWell(
                      onTap: () {
                        if (Attachments.attachment != null) {
                          if (Attachments.attachment!.contains(appPkg)) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CustomViewImage(
                                        imageFile:
                                            File(Attachments.attachment!))));
                          } else {
                            customLaunchURL(prefix +
                                Attachments.attachment!.replaceAll("\\", "/"));
                          }
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.folder,
                              color: folderColor,
                            ),
                            Flexible(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                Attachments.attachment ?? '',
                                style: TextStyle(color: Colors.blue),
                              ),
                            )),
                            IconButton(
                              icon: Icon(
                                Icons.select_all,
                                color: Colors.white,
                              ),
                              onPressed: null,
                            ),
                          ],
                        ),
                      ),
                    ),
              // Row(
              //   children: [
              //     Spacer(),
              //     Align(
              //       alignment: Alignment.centerRight,
              //       child: Container(
              //         width: MediaQuery.of(context).size.width / 2,
              //         child: Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: Material(
              //             borderRadius: BorderRadius.circular(10.0),
              //             color: barColor,
              //             elevation: 0.0,
              //             child: MaterialButton(
              //               onPressed: () async {
              //                 // print(Attachment.imageFile!.path);
              //                 // uploadImageToServer(Attachment.imageFile!, context, setURL: (String url){
              //                 //   print(url);
              //                 // });
              //               },
              //               minWidth: MediaQuery.of(context).size.width,
              //               child: Text(
              //                 "Upload",
              //                 textAlign: TextAlign.center,
              //                 style: TextStyle(
              //                     color: Colors.white,
              //                     fontWeight: FontWeight.bold,
              //                     fontSize: 20.0),
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //     IconButton(
              //       icon: Icon(
              //         Icons.select_all,
              //         color: Colors.white,
              //       ),
              //       onPressed: null,
              //     )
              //   ],
              // ),
              Row(
                children: [
                  Spacer(),
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
                            onPressed: () {
                              if (Attachments.attachment != null &&
                                  Attachments.attachment != "") {
                                setState(() {
                                  Attachments.attachments.add(MNJCD3(
                                      ID: 0,
                                      TransId: GeneralData.transId ?? "",
                                      RowId: Attachments.attachments.length,
                                      Attachment: Attachments.imageFile?.path,
                                      Remarks: Remarks.text,
                                      CreateDate: DateTime.now(),
                                      insertedIntoDatabase: false));
                                  //Attachment.documentPaths.add(Attachments.attachment ?? "");
                                  // Attachment.documentPaths.add(
                                  //     Attachments.attachment ?? "");
                                  Attachments.attachment = null;
                                  Attachments.imageFile = null;
                                  rowId.clear();
                                  attachment.clear();
                                  Remarks.clear();
                                });
                              } else {
                                getErrorSnackBar("Please select a document");
                              }
                            },
                            minWidth: MediaQuery.of(context).size.width,
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
                  IconButton(
                    icon: Icon(
                      Icons.select_all,
                      color: Colors.white,
                    ),
                    onPressed: null,
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              ListView.builder(
                  itemCount: Attachments.attachments.length,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemBuilder: (context, index) {
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
                            customLaunchURL(
                                prefix + attachment.replaceAll("\\", "/"));
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
                                    getPoppinsTextSpanHeading(text: 'Remarks'),
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
                                        decoration: TextDecoration.underline),
                                  )),
                                ],
                              ),
                              getDivider(),
                              Row(
                                children: [
                                  Expanded(
                                      child: InkWell(
                                    onTap: () async {
                                      await showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  20,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.5,
                                              child: Text(
                                                "Are you sure you want to delete this row?",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            actions: [
                                              MaterialButton(
                                                // OPTIONAL BUTTON
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                ),
                                                color: barColor,
                                                child: Text(
                                                  'No',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              MaterialButton(
                                                // OPTIONAL BUTTON
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                ),
                                                color: Colors.red,
                                                child: Text(
                                                  'Yes',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    Attachments.attachments
                                                        .removeAt(index);
                                                  });
                                                  Get.back();
                                                  //todo:
                                                  // String attachment = Attachments
                                                  //         .attachments[index]
                                                  //         .Attachment ??
                                                  //     '';
                                                  // if (attachment != '') {
                                                  //   if (attachment
                                                  //       .contains(appPkg)) {
                                                  //     //local image
                                                  //     setState(() {
                                                  //       Attachments.attachments
                                                  //           .removeAt(index);
                                                  //     });
                                                  //   } else {
                                                  //     //server image
                                                  //   }
                                                  // }
                                                  // Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: getPoppinsText(
                                        text: 'Delete',
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
