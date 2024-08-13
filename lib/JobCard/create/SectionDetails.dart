import 'package:flutter/material.dart';
import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/GetTextField.dart';
import 'package:maintenance/Sync/SyncModels/MNJCD7.dart';

class SectionDetails extends StatefulWidget {
  static List<MNJCD7> list = [];

  const SectionDetails({super.key});

  @override
  State<SectionDetails> createState() => _SectionDetailsState();
}

class _SectionDetailsState extends State<SectionDetails> {
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
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    child: Text(
                      "+ Add Section",
                      style: TextStyle(
                        color: barColor,
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        SectionDetails.list.add(MNJCD7(insertedIntoDatabase: false));
                      });
                    },
                  ),
                ),
              ),
              ListView.builder(
                  itemCount: SectionDetails.list.length,
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Stack(
                      fit: StackFit.loose,
                      clipBehavior: Clip.none,
                      children: [
                        Container(
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
                          margin: const EdgeInsets.only(
                              left: 15.0, right: 15.0, bottom: 10),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: getTextFieldWithoutLookup(
                                    controller: TextEditingController(
                                        text:
                                            SectionDetails.list[index].Section),
                                    onChanged: (val) {
                                      SectionDetails.list[index].Section = val;
                                    },
                                    labelText: "Section"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: getTextFieldWithoutLookup(
                                    controller: TextEditingController(
                                        text:
                                            SectionDetails.list[index].Remarks),
                                    onChanged: (val) {
                                      SectionDetails.list[index].Remarks = val;
                                    },
                                    labelText: "Remarks"),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: -27,
                          right: -4,
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
                                            onPressed: () async {
                                              SectionDetails.list
                                                  .removeAt(index);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  ).then((value) {
                                    setState(() {});
                                  });
                                },
                                icon: Icon(
                                  Icons.delete_forever,
                                  color: Colors.red,
                                )),
                          ),
                        ),
                      ],
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
