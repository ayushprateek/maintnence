import 'package:flutter/material.dart';
import 'package:maintenance/Component/CustomFont.dart';
import 'package:maintenance/Sync/SyncModels/MNJCD6.dart';

class ProblemDetails extends StatefulWidget {
  static List<MNJCD6> list = [];

  const ProblemDetails({super.key});

  @override
  State<ProblemDetails> createState() => _ProblemDetailsState();
}

class _ProblemDetailsState extends State<ProblemDetails> {
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
                              // Expanded(
                              //   flex: 8,
                              //   child: Column(
                              //     mainAxisAlignment: MainAxisAlignment.start,
                              //     children: [
                              //       Padding(
                              //         padding: const EdgeInsets.only(
                              //             left: 8.0, right: 8.0, top: 4.0),
                              //         child: Align(
                              //           alignment: Alignment.topLeft,
                              //           child: Text.rich(
                              //             TextSpan(
                              //               children: [
                              //                 getPoppinsTextSpanHeading(
                              //                     text: 'Section'),
                              //                 getPoppinsTextSpanDetails(
                              //                     text: mnjcd6.Section ?? ''),
                              //               ],
                              //             ),
                              //           ),
                              //         ),
                              //       ),
                              //       Padding(
                              //         padding: const EdgeInsets.only(
                              //             left: 8.0, right: 8.0, top: 4.0),
                              //         child: Align(
                              //           alignment: Alignment.topLeft,
                              //           child: Text.rich(
                              //             TextSpan(
                              //               children: [
                              //                 getPoppinsTextSpanHeading(
                              //                     text: 'SubSection'),
                              //                 getPoppinsTextSpanDetails(
                              //                     text:
                              //                         mnjcd6.SubSection ?? ''),
                              //               ],
                              //             ),
                              //           ),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
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
