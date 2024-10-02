import 'package:flutter/material.dart';
import 'package:maintenance/Component/CustomFont.dart';
import 'package:maintenance/Component/GetFormattedDate.dart';
import 'package:maintenance/Sync/SyncModels/MNJCD1.dart';

class ItemDetails extends StatefulWidget {
  const ItemDetails({super.key});

  static List<MNJCD1> items = [];

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
            child: Container(
              decoration: ItemDetails.items.isNotEmpty
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
                      itemCount: ItemDetails.items.length,
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        MNJCD1 mnjcd1 = ItemDetails.items[index];

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
                                                    text: 'Item'),
                                                getPoppinsTextSpanDetails(
                                                    text:
                                                        mnjcd1.ItemCode ?? ''),
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
                                                    text: 'Quantity'),
                                                getPoppinsTextSpanDetails(
                                                    text: mnjcd1.Quantity
                                                        ?.toStringAsFixed(2)),
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
                                                    text: 'UOM'),
                                                getPoppinsTextSpanDetails(
                                                    text: mnjcd1.UOM ?? ''),
                                              ],
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
                                                value: mnjcd1.IsFromStock,
                                                onChanged: (bool? value) {},
                                              ),
                                              Expanded(
                                                  child: getPoppinsText(
                                                      text: 'Internal Request',
                                                      textAlign:
                                                          TextAlign.start)),
                                            ],
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
                                                value: mnjcd1.IsConsumption,
                                                onChanged: (bool? value) {},
                                              ),
                                              Expanded(
                                                  child: getPoppinsText(
                                                      text: 'Consumption',
                                                      textAlign:
                                                          TextAlign.start)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 8,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
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
                                                value: mnjcd1.IsRequest,
                                                onChanged: (bool? value) {},
                                              ),
                                              Expanded(
                                                  child: getPoppinsText(
                                                      text: 'Purchase Request',
                                                      textAlign:
                                                          TextAlign.start)),
                                            ],
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
                                                    text: 'Supplier'),
                                                getPoppinsTextSpanDetails(
                                                    text: mnjcd1.SupplierName ??
                                                        ''),
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
                                                    text: 'Required Date'),
                                                getPoppinsTextSpanDetails(
                                                    text: getFormattedDate(
                                                        mnjcd1.RequestDate)),
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
