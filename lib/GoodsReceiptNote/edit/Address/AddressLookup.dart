import 'package:flutter/material.dart';
import 'package:maintenance/Component/AddressModel.dart';
import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/CustomFont.dart';
import 'package:maintenance/Database/DatabaseHandler.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/GoodsReceiptNote/edit/Address/BillingAddress.dart';
import 'package:maintenance/GoodsReceiptNote/edit/Address/ShippingAddress.dart';
import 'package:maintenance/GoodsReceiptNote/edit/GoodsReceiptNote.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:maintenance/GoodsReceiptNote/edit/GeneralData.dart';
class AddressLookup extends StatefulWidget {
  bool shippingAddress = false;

  AddressLookup(bool shippingAddress) {
    this.shippingAddress = shippingAddress;
  }

  @override
  _AddressLookupState createState() => _AddressLookupState();
}

class _AddressLookupState extends State<AddressLookup> {
  Future<List<AddressModel>> retrieveCRD2(BuildContext context) async {
    final Database db = await initializeDB(context);
    final List<Map<String, Object?>> queryResult = await db.query('CRD2',
        where: "Code = ? ", whereArgs: [GeneralData.cardCode]);
    return queryResult.map((e) => AddressModel.fromMap(e)).toList();
  }

  Future<List<AddressModel>> retrieveCRD3(BuildContext context) async {
    final Database db = await initializeDB(context);
    final List<Map<String, Object?>> queryResult = await db.query('CRD3',
        where: "Code = ? ", whereArgs: [GeneralData.cardCode]);
    return queryResult.map((e) => AddressModel.fromMap(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: barColor,
        title: Text(
          "Address",
          style: TextStyle(color: Colors.white, fontFamily: custom_font),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 10,
            ),
            GeneralData.cardCode == null || GeneralData.cardCode == ""
                ? AlertDialog(
                    content: Text("Please select customer to continue..."),
                    title: Text("Error"),
                  )
                : FutureBuilder(
                    future: widget.shippingAddress
                        ? retrieveCRD2(context)
                        : retrieveCRD3(context),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<AddressModel>> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.separated(
                          itemCount: snapshot.data?.length ?? 0,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onDoubleTap: () {
                                if (widget.shippingAddress) {
                                  // ShippingAddress.ID=snapshot.data![index].ID;
                                  ShippingAddress.RouteName =
                                      snapshot.data![index].RouteName;
                                  ShippingAddress.RouteCode =
                                      snapshot.data![index].RouteCode;
                                  ShippingAddress.CityName =
                                      snapshot.data![index].CityName;
                                  ShippingAddress.CityCode =
                                      snapshot.data![index].CityCode;
                                  ShippingAddress.Addres =
                                      snapshot.data![index].Address;
                                  ShippingAddress.CountryName =
                                      snapshot.data![index].CountryName;
                                  ShippingAddress.CountryCode =
                                      snapshot.data![index].CountryCode;
                                  ShippingAddress.StateName =
                                      snapshot.data![index].StateName;
                                  ShippingAddress.StateCode =
                                      snapshot.data![index].StateCode;
                                  ShippingAddress.Latitude =
                                      snapshot.data![index].Latitude;
                                  ShippingAddress.Longitude =
                                      snapshot.data![index].Longitude;
                                  ShippingAddress.Longitude =
                                      snapshot.data![index].Longitude;
                                  // ShippingAddress.TransId=snapshot.data![index].TransId;
                                  ShippingAddress.RowId =
                                      snapshot.data![index].RowId;
                                  ShippingAddress.AddCode =
                                      snapshot.data![index].AddressCode;
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) =>
                                              EditGoodsRecepitNote(2))));
                                } else {
                                  BillingAddress.ID = snapshot.data![index].ID;
                                  BillingAddress.CityName =
                                      snapshot.data![index].CityName;
                                  BillingAddress.CityCode =
                                      snapshot.data![index].CityCode;
                                  BillingAddress.Addres =
                                      snapshot.data![index].Address;
                                  BillingAddress.CountryName =
                                      snapshot.data![index].CountryName;
                                  BillingAddress.CountryCode =
                                      snapshot.data![index].CountryCode;
                                  BillingAddress.StateName =
                                      snapshot.data![index].StateName;
                                  BillingAddress.StateCode =
                                      snapshot.data![index].StateCode;
                                  BillingAddress.Latitude =
                                      snapshot.data![index].Latitude;
                                  BillingAddress.Longitude =
                                      snapshot.data![index].Longitude;

                                  BillingAddress.RowId =
                                      snapshot.data![index].RowId;
                                  BillingAddress.AddCode =
                                      snapshot.data![index].AddressCode;

                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) =>
                                              EditGoodsRecepitNote(3))));
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
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0,
                                                  right: 8.0,
                                                  top: 8.0),
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: FittedBox(
                                                    fit: BoxFit.contain,
                                                    child: getHeadingText(
                                                      text: snapshot
                                                          .data![index].ID
                                                          .toString(),
                                                    )),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0,
                                                  right: 8.0,
                                                  top: 8.0),
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: getSubHeadingText(
                                                  text: snapshot
                                                      .data![index].Address
                                                      .toString(),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0,
                                                  right: 8.0,
                                                  top: 8.0),
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: FittedBox(
                                                    fit: BoxFit.contain,
                                                    child: getSubHeadingText(
                                                      text: snapshot
                                                              .data![index]
                                                              .CityName
                                                              .toString() +
                                                          " " +
                                                          snapshot.data![index]
                                                              .StateName
                                                              .toString() +
                                                          " " +
                                                          snapshot.data![index]
                                                              .CountryName
                                                              .toString(),
                                                    )),
                                              ),
                                            ),
                                          ],
                                        ),
                                        flex: 8,
                                      ),
                                      Expanded(
                                        child: Container(),
                                        flex: 3,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider(
                              thickness: 1.5,
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
