import 'package:flutter/material.dart';
import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/CustomFont.dart';
import 'package:maintenance/Sync/SyncModels/OTAX.dart';

class TaxCodeLookup extends StatefulWidget {
  Function(String, String) onTaxSelected;

  TaxCodeLookup({required this.onTaxSelected, Key? key}) : super(key: key);

  @override
  State<TaxCodeLookup> createState() => _TaxCodeLookupState();
}

class _TaxCodeLookupState extends State<TaxCodeLookup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: barColor,
        title: Text(
          "Tax Lookup",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _heading(),
          Divider(),
          FutureBuilder(
              future: retrieveOTAXById(context, 'Active = ?', [1]),
              builder: (context, AsyncSnapshot<List<OTAXModel>> snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                return ListView.builder(
                    itemCount: snapshot.data?.length ?? 0,
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemBuilder: (context, index) {
                      return _displayData(otaxModel: snapshot.data![index]);
                    });
              })
        ],
      ),
    );
  }

  Widget _heading() {
    return Container(
      margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 0, top: 10),
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
                              text: "Tax Code ",
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
                              text: "Tax Rate  ",
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
    );
  }

  Widget _displayData({required OTAXModel otaxModel}) {
    return InkWell(
      onDoubleTap: () {
        widget.onTaxSelected(otaxModel.TaxCode, otaxModel.Rate.toString());
        Navigator.pop(context);
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
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: getHeadingText(
                      text: otaxModel.TaxCode.toString(),
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: getSubHeadingText(
                      text: otaxModel.Rate.toString(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
