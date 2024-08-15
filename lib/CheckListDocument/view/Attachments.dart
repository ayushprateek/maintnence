import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance/Component/AppConfig.dart';
import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/CustomFont.dart';
import 'package:maintenance/Component/CustomUrlLauncher.dart';
import 'package:maintenance/Component/CustomViewImage.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/SyncModels/MNCLD2.dart';

class Attachments extends StatefulWidget {
  static List<MNCLD2> attachments = [];
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
              ListView.builder(
                  itemCount: Attachments.attachments.length,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Stack(
                      fit: StackFit.loose,
                      clipBehavior: Clip.none,
                      children: [
                        InkWell(
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
                        ),
                        Positioned(
                          top: -18,
                          right: -1,
                          child: Card(
                            child: IconButton(
                                onPressed: () async {
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
                                                fontWeight: FontWeight.bold),
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
                                icon: Icon(
                                  Icons.delete_forever,
                                  color: Colors.red,
                                )),
                          ),
                        ),
                      ],
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
