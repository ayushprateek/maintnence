import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance/CheckListDocument/CheckListDocument.dart';
import 'package:maintenance/CheckListDocument/GeneralData.dart';
import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/CustomFont.dart';
import 'package:maintenance/Component/GetTextField.dart';
import 'package:maintenance/Sync/SyncModels/MNOCLM.dart';

class CheckListCodeLookup extends StatefulWidget {
  Function(MNOCLM) onSelection;
   CheckListCodeLookup({super.key,
  required this.onSelection});

  @override
  State<CheckListCodeLookup> createState() => _CheckListCodeLookupState();
}

class _CheckListCodeLookupState extends State<CheckListCodeLookup> {
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
                future: retrieveMNOCLMForSearch(
                    query: _query.text, limit: _currentMax),
                builder: (context, AsyncSnapshot<List<MNOCLM>> snapshot) {
                  if (!snapshot.hasData) return Container();

                  return Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            left: 15.0, right: 15.0, bottom: 0, top: 10),
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: FittedBox(
                                              fit: BoxFit.contain,
                                              child: getHeadingText(
                                                text: "Code ",
                                              )),
                                        ),
                                        Expanded(
                                          child: Container(),
                                        ),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: FittedBox(
                                              fit: BoxFit.contain,
                                              child: getHeadingText(
                                                text: "Name Description  ",
                                              )),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                flex: 8,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(),
                      ListView.builder(
                          itemCount: snapshot.data!.length < _currentMax
                              ? snapshot.data!.length
                              : snapshot.data!.length + 1,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemBuilder: (context, index) {
                            if (index == snapshot.data!.length) {
                              return Container();
                            }
                            if (index > snapshot.data!.length) {
                              return Container();
                            }
                            return InkWell(
                              onDoubleTap: () {

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
                                      Flexible(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: getHeadingText(
                                              text: snapshot.data![index].Code
                                                          .toString() ==
                                                      ""
                                                  ? "ABC"
                                                  : snapshot.data![index].Code
                                                      .toString(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: getSubHeadingText(
                                              text: snapshot.data![index].Name,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ],
                  );
                }),
          ],
        ),
      ),
    );
  }
}
