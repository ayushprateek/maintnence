import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/CustomFont.dart';
import 'package:maintenance/JobCard/view/ServiceDetails/AddServiceItem.dart';
import 'package:maintenance/Sync/SyncModels/MNJCD2.dart';

class ServiceDetails extends StatefulWidget {
  const ServiceDetails({super.key});

  static List<MNJCD2> items = [];

  @override
  State<ServiceDetails> createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 25,),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
            child: Container(
              decoration: ServiceDetails.items.isNotEmpty
                  ? BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16)))
                  : null,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    ListView.builder(
                      itemCount: ServiceDetails.items.length,
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        MNJCD2 mnjcd2 = ServiceDetails.items[index];

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
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 8,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0,
                                            right: 8.0,
                                            top: 4.0),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text.rich(
                                            TextSpan(
                                              children: [
                                                getPoppinsTextSpanHeading(
                                                    text: 'Service Name'),
                                                getPoppinsTextSpanDetails(
                                                    text: mnjcd2
                                                            .ServiceName ??
                                                        ''),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0,
                                            right: 8.0,
                                            top: 4.0),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text.rich(
                                            TextSpan(
                                              children: [
                                                getPoppinsTextSpanHeading(
                                                    text:
                                                        'Supplier'),
                                                getPoppinsTextSpanDetails(
                                                    text: mnjcd2
                                                            .SupplierName ??
                                                        ''),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 8,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0,
                                            right: 8.0,
                                            top: 4.0),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: FittedBox(
                                            fit: BoxFit.contain,
                                            child: Text.rich(
                                              TextSpan(
                                                children: [
                                                  getPoppinsTextSpanHeading(
                                                      text: 'Info Price'),
                                                  getPoppinsTextSpanDetails(
                                                      text: mnjcd2.InfoPrice
                                                              ?.toStringAsFixed(
                                                                  2) ??
                                                          '0.0'),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 4.0, bottom: 4),
                                        child: SizedBox(
                                          height: 20,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Checkbox(
                                                value:
                                                    mnjcd2.IsSendableItem,
                                                onChanged: (bool? value) {

                                                },
                                              ),
                                              Expanded(
                                                  child: getPoppinsText(
                                                      text:
                                                          'Is Sendable Item',
                                                      textAlign: TextAlign
                                                          .start)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 10,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
