import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/CustomFont.dart';
import 'package:maintenance/Component/GetTextField.dart';
import 'package:maintenance/Component/IsNumeric.dart';
import 'package:maintenance/Sync/SyncModels/OPOTRP.dart';

class TripLookup extends StatefulWidget {
  Function(OPOTRP) onSelection;

  TripLookup({super.key, required this.onSelection});

  @override
  State<TripLookup> createState() => _TripLookupState();
}

class _TripLookupState extends State<TripLookup> {
  ScrollController _scrollController = ScrollController();
  final TextEditingController _query = TextEditingController();
  int _currentMax = 15;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
  }

  _getMoreData() {
    _currentMax = _currentMax + 15;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: barColor,
        title: Text(
          "Check List Code Lookup",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Container(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 4.0, bottom: 15, right: 4, top: 15),
              child: Container(
                height: 43,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: getTextFieldWithoutLookup(
                        controller: _query,
                        onChanged: (val) {
                          setState(() {});
                        },
                        labelText: 'Search',
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: barColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _query.clear();
                              _query.text = '';
                            });
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: barColor,
                        ),

                        //keyboardType: TextInputType.number,
                        style: new TextStyle(
                          fontFamily: "Poppins",
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4.0, bottom: 6),
                        child: Material(
                          borderRadius: BorderRadius.circular(10.0),
                          color: barColor,
                          child: MaterialButton(
                            onPressed: () async {
                              setState(() {
                                _query;
                              });
                            },
                            minWidth: MediaQuery.of(context).size.width,
                            child: FittedBox(
                              child: Text(
                                "Search",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            FutureBuilder(
              future: retrieveOPOTRPForDisplay(
                  dbQuery: _query.text, limit: _currentMax),
              builder:
                  (BuildContext context, AsyncSnapshot<List<OPOTRP>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.separated(
                    itemCount: snapshot.data!.length < _currentMax
                        ? snapshot.data!.length
                        : snapshot.data!.length + 1,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      if (index == snapshot.data!.length) {
                        return Container();
                      }
                      if (index > snapshot.data!.length) {
                        return Container(
                          height: 0.0,
                          width: 0.0,
                        );
                      }
                      return InkWell(
                        onDoubleTap: () async {
                          widget.onSelection(snapshot.data![index]);
                          Get.back();
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
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              getPoppinsTextSpanHeading(
                                                  text: 'TransId'),
                                              getPoppinsTextSpanDetails(
                                                  text: snapshot
                                                      .data![index].TransId
                                                      .toString()),
                                            ],
                                          ),
                                        ),
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              getPoppinsTextSpanHeading(
                                                  text: 'DocStatus'),
                                              getPoppinsTextSpanDetails(
                                                  text: snapshot.data![index]
                                                          .DocStatus ??
                                                      ''),
                                            ],
                                          ),
                                        ),
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              getPoppinsTextSpanHeading(
                                                  text: 'ApprovalStatus'),
                                              getPoppinsTextSpanDetails(
                                                  text: displayNumberWithComma(
                                                      snapshot.data![index]
                                                              .ApprovalStatus ??
                                                          '')),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              getPoppinsTextSpanHeading(
                                                  text: 'WhsCode'),
                                              getPoppinsTextSpanDetails(
                                                  text: snapshot
                                                          .data![index].WhsCode
                                                          ?.toString() ??
                                                      ''),
                                            ],
                                          ),
                                        ),
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              getPoppinsTextSpanHeading(
                                                  text: 'PermanentTransId'),
                                              getPoppinsTextSpanDetails(
                                                  text: snapshot.data![index]
                                                          .PermanentTransId ??
                                                      ""),
                                            ],
                                          ),
                                        ),
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              getPoppinsTextSpanHeading(
                                                  text: 'Credit Limit'),
                                              getPoppinsTextSpanDetails(
                                                  text: displayNumberWithComma(
                                                      snapshot.data![index]
                                                              .RouteName ??
                                                          '')),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      if (index == snapshot.data!.length) {
                        return Container();
                      }
                      if (index > snapshot.data!.length) {
                        return Container(
                          height: 0.0,
                          width: 0.0,
                        );
                      }
                      return Divider(
                        thickness: 1.5,
                      );
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
