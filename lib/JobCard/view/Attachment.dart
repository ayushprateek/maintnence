import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance/Component/CustomFont.dart';
import 'package:maintenance/Component/DownloadFileFromServer.dart';
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
              SizedBox(
                height: 20,
              ),
              ListView.builder(
                  itemCount: Attachments.attachments.length,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemBuilder: (context, index) {
                    if (Attachments.attachments.length > 3 && index <= 3) {
                      return SizedBox(
                        height: 0,
                        width: 0,
                      );
                    }
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
                                      text: Attachments.attachments[index].RowId
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
                            Align(
                              alignment: Alignment.center,
                              child: FutureBuilder(
                                  future: downloadFileFromServer(
                                      path: Attachments
                                              .attachments[index].Attachment ??
                                          ''),
                                  builder:
                                      (context, AsyncSnapshot<File?> snap) {
                                    if (!snap.hasData || snap.data == null) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            child: SizedBox(
                                                height: Get.height / 5,
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
                                            height: Get.height / 5,
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
                  })
            ],
          ),
        ),
      ),
    );
  }
}
