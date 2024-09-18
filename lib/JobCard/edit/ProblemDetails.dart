import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance/Component/Common.dart';
import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/CustomFont.dart';
import 'package:maintenance/Component/GetTextField.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/JobCard/edit/GeneralData.dart';
import 'package:maintenance/Lookups/MNEQG3Lookup.dart';
import 'package:maintenance/Sync/SyncModels/MNEQG3.dart';
import 'package:maintenance/Sync/SyncModels/MNJCD6.dart';

class ProblemDetails extends StatefulWidget {
  static List<MNJCD6> list = [];

  const ProblemDetails({super.key});

  @override
  State<ProblemDetails> createState() => _ProblemDetailsState();
}

class _ProblemDetailsState extends State<ProblemDetails> {
  final TextEditingController _rowId = TextEditingController();
  final TextEditingController _section = TextEditingController();
  final TextEditingController _subSection = TextEditingController();
  final TextEditingController _problem = TextEditingController();
  final TextEditingController _subProblem = TextEditingController();
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
              // getDisabledTextField(
              //     controller: _rowId,
              //     labelText: 'RowId'),
              getDisabledTextField(
                  controller: _section,
                  labelText: 'Section',
                  enableLookup: true,
                  onLookupPressed: () {
                    Get.to(() => MNEQG3Lookup(onSelection: (MNEQG3 mneqg3) {
                      _section.text = mneqg3.Section ?? '';
                    }));
                  }),
              getDisabledTextField(
                  controller: _subSection,
                  labelText: 'Sub Section',
                  enableLookup: true,
                  onLookupPressed: () {
                    Get.to(() => MNEQG3Lookup(
                      onSelection: (MNEQG3 mneqg3) {
                        _subSection.text = mneqg3.SubSection ?? '';
                      },
                      condition: "Section='${_section.text}'",
                    ));
                  }),
              getDisabledTextField(
                  controller: _problem,
                  labelText: 'Problem',
                  enableLookup: true,
                  onLookupPressed: () {
                    Get.to(() => MNEQG3Lookup(
                      onSelection: (MNEQG3 mneqg3) {
                        _problem.text = mneqg3.Problem ?? '';
                      },
                      condition: "SubSection='${_subSection.text}'",
                    ));
                  }),
              getDisabledTextField(
                  controller: _subProblem,
                  labelText: 'Sub Problem',
                  enableLookup: true,
                  onLookupPressed: () {
                    Get.to(() => MNEQG3Lookup(
                      onSelection: (MNEQG3 mneqg3) {
                        _subProblem.text = mneqg3.SubProblem ?? '';
                      },
                      condition: "Problem='${_problem.text}'",
                    ));
                  }),

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
                              if (_section.text.isEmpty) {
                                getErrorSnackBar('Please fill section');
                              } else if (_subSection.text.isEmpty) {
                                getErrorSnackBar('Please fill sub section');
                              } else if (_problem.text.isEmpty) {
                                getErrorSnackBar('Please fill problem');
                              } else if (_subProblem.text.isEmpty) {
                                getErrorSnackBar('Please fill sub problem');
                              } else if (_rowId.text.isNotEmpty) {
                                ///updating
                                for (MNJCD6 mnjcd6 in ProblemDetails.list) {
                                  if (mnjcd6.RowId ==
                                      (int.tryParse(_rowId.text) ?? 0)) {
                                    mnjcd6.Section = _section.text;
                                    mnjcd6.SubSection = _subSection.text;
                                    mnjcd6.Problem = _problem.text;
                                    mnjcd6.SubProblem = _subProblem.text;
                                  }
                                }
                              } else {
                                ///inserting
                                ProblemDetails.list.add(MNJCD6(
                                  RowId: ProblemDetails.list.length,
                                  insertedIntoDatabase: false,
                                  TransId: GeneralData.transId,
                                  Section: _section.text,
                                  SubSection: _subSection.text,
                                  Problem: _problem.text,
                                  SubProblem: _subProblem.text,
                                ));
                              }
                              setState(() {
                                _rowId.clear();
                                _section.clear();
                                _subSection.clear();
                                _problem.clear();
                                _subProblem.clear();
                              });
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
              const SizedBox(
                height: 16,
              ),
              ListView.builder(
                  itemCount: ProblemDetails.list.length,
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemBuilder: (context, index) {
                    MNJCD6 mnjcd6 = ProblemDetails.list[index];
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
                      margin: const EdgeInsets.only(
                          left: 15.0, right: 15.0, bottom: 10),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 8,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0, top: 4.0),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text.rich(
                                          TextSpan(
                                            children: [
                                              getPoppinsTextSpanHeading(
                                                  text: 'Section'),
                                              getPoppinsTextSpanDetails(
                                                  text: mnjcd6.Section ?? ''),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0, top: 4.0),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text.rich(
                                          TextSpan(
                                            children: [
                                              getPoppinsTextSpanHeading(
                                                  text: 'SubSection'),
                                              getPoppinsTextSpanDetails(
                                                  text:
                                                  mnjcd6.SubSection ?? ''),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 9,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0, top: 4.0),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text.rich(
                                          TextSpan(
                                            children: [
                                              getPoppinsTextSpanHeading(
                                                  text: 'Problem'),
                                              getPoppinsTextSpanDetails(
                                                  text: mnjcd6.Problem ?? ''),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0, top: 4.0),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text.rich(
                                          TextSpan(
                                            children: [
                                              getPoppinsTextSpanHeading(
                                                  text: 'SubProblem'),
                                              getPoppinsTextSpanDetails(
                                                  text:
                                                  mnjcd6.SubProblem ?? ''),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          getDivider(),
                          Row(
                            children: [
                              Expanded(
                                  child: InkWell(
                                    onTap: () async {
                                      _rowId.text = mnjcd6.RowId.toString();
                                      _section.text = mnjcd6.Section ?? '';
                                      _subSection.text = mnjcd6.SubSection ?? '';
                                      _problem.text = mnjcd6.Problem ?? '';
                                      _subProblem.text = mnjcd6.SubProblem ?? '';
                                    },
                                    child: getPoppinsText(
                                        text: 'Edit',
                                        color: barColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  )),
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
                                                  ProblemDetails.list
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
                                    child: getPoppinsText(
                                        text: 'Delete',
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  )),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
