import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/GetTextField.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/GoodsReceiptNote/Address/AddressLookup.dart';
import 'package:maintenance/GoodsReceiptNote/GeneralData.dart';
import 'package:maintenance/GoodsReceiptNote/GoodsReceiptNote.dart';
import 'package:maintenance/Sync/SyncModels/PRPDN2.dart';
import 'package:maps_launcher/maps_launcher.dart';

class ShippingAddress extends StatefulWidget {
  const ShippingAddress({super.key});

  static bool validate() {
    bool succees = true;
    if (AddCode == "" || AddCode == null) {
      getErrorSnackBar("Invalid Adress Code");
      succees = false;
    } else if (Addres == "" || Addres == null) {
      getErrorSnackBar("Invalid Adress");
      succees = false;
    }
    return succees;
  }

  static bool hasCreated = false, hasUpdated = false;

  static int? RowId;
  static String? Addres,
      CityName,
      StateName,
      CountryName,
      AddCode,
      CityCode,
      StateCode,
      CountryCode,
      RouteCode,
      RouteName;
  static double? Latitude, Longitude;

  static PRPDN2 getShippingAddress() {
    return PRPDN2(
        ID: 0,
        TransId: GeneralData.transId ?? '',
        RowId: RowId,
        AddressCode: AddCode,
        Address: Addres,
        hasCreated: hasCreated,
        hasUpdated: hasUpdated,
        CityCode: CityCode,
        CityName: CityName,
        StateCode: StateCode,
        StateName: StateName,
        CountryCode: CountryCode,
        CountryName: CountryName,
        Latitude: Latitude.toString(),
        Longitude: Longitude.toString(),
        RouteCode: RouteCode,
        RouteName: RouteName);
  }

  @override
  State<ShippingAddress> createState() => _ShippingAddressState();
}

class _ShippingAddressState extends State<ShippingAddress> {
  TextEditingController RouteName = TextEditingController(
      text: ShippingAddress.RouteName == null
          ? ""
          : ShippingAddress.RouteName.toString());
  TextEditingController RouteCode = TextEditingController(
      text: ShippingAddress.RouteCode == null
          ? ""
          : ShippingAddress.RouteCode.toString());
  TextEditingController RowId = TextEditingController(
      text: ShippingAddress.RowId == null
          ? ""
          : ShippingAddress.RowId.toString());
  TextEditingController AddCode = TextEditingController(
      text: ShippingAddress.AddCode == null
          ? ""
          : ShippingAddress.AddCode.toString());
  TextEditingController Addres =
      TextEditingController(text: ShippingAddress.Addres);
  TextEditingController CityName =
      TextEditingController(text: ShippingAddress.CityName);
  TextEditingController CityCode = TextEditingController(
      text: ShippingAddress.CityCode == null
          ? ""
          : ShippingAddress.CityCode.toString());
  TextEditingController CountryName =
      TextEditingController(text: ShippingAddress.CountryName);
  TextEditingController CountryCode = TextEditingController(
      text: ShippingAddress.CountryCode == null
          ? ""
          : ShippingAddress.CountryCode.toString());
  TextEditingController StateName =
      TextEditingController(text: ShippingAddress.StateName);
  TextEditingController StateCode = TextEditingController(
      text: ShippingAddress.StateCode == null
          ? ""
          : ShippingAddress.StateCode.toString());
  TextEditingController Latitude = TextEditingController(
      text: ShippingAddress.Latitude == null
          ? ""
          : ShippingAddress.Latitude.toString());
  TextEditingController Longitude = TextEditingController(
      text: ShippingAddress.Longitude == null
          ? ""
          : ShippingAddress.Longitude.toString());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8, top: 20),
        child: Container(
          decoration: BoxDecoration(
              // color: const Color(0XFFC46253),
              border: Border.all(),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16))),
          child: Column(
            children: [
              SizedBox(
                height: 25,
              ),
              getDisabledTextField(
                  controller: AddCode,
                  labelText: 'Add Code*',
                  onChanged: (value) {
                    ShippingAddress.AddCode = value;
                  },
                  enableLookup: true,
                  onLookupPressed: () {
                    if (isSelectedAndCancelled() ||
                        isSalesQuotationDocClosed()) {
                      getErrorSnackBar(
                          "This Document is already cancelled / closed");
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => AddressLookup(true))));
                    }
                  }),
              Padding(
                padding: const EdgeInsets.only(bottom: 6.0, left: 8, right: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: Addres,
                        onChanged: (value) {
                          ShippingAddress.Addres = value;
                        },
                        readOnly: isSelectedAndCancelled() ||
                            isSalesQuotationDocClosed(),
                        onTap: () {
                          if (isSelectedAndCancelled() ||
                              isSalesQuotationDocClosed()) {
                            getErrorSnackBar(
                                "This Document is already cancelled / closed");
                          }
                        },
                        decoration: new InputDecoration(
                          labelStyle: GoogleFonts.poppins(
                              fontSize: 14, fontWeight: FontWeight.w500),
                          filled: true,
                          labelText: 'Address*',

                          //prefixIconConstraints: BoxConstraints(minWidth: 0,minHeight: 0),
                          fillColor: isSalesQuotationDocClosed()
                              ? Color(0XFFF3ECE7)
                              : Colors.white,
                          disabledBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                            borderSide:
                                new BorderSide(color: barColor, width: 1),
                          ),
                          hoverColor: Colors.red,
                          focusedBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                            borderSide:
                                new BorderSide(color: barColor, width: 1),
                          ),
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                            borderSide:
                                new BorderSide(color: barColor, width: 1),
                          ),
                          //fillColor: Colors.green
                        ),
                        maxLines: 5,
                        //keyboardType: TextInputType.number,
                        style: new TextStyle(
                          fontFamily: "Poppins",
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.location_on,
                        color: barColor,
                      ),
                      onPressed: () {
                        //25.3560873 83.0324322
                        //MapsLauncher.launchCoordinates( 25.356087,83.0324322);
                        if (Latitude.text == null ||
                            Latitude.text == "0.0" ||
                            Latitude.text == "0.0") {
                          getErrorSnackBar(
                              "Cannot launch map, Latitude or Longitude is null");
                        } else
                          MapsLauncher.launchCoordinates(
                            double.parse(Latitude.text),
                            double.parse(Longitude.text),
                          );
                      },
                    )
                  ],
                ),
              ),
              getDisabledTextField(
                controller: RouteCode,
                labelText: 'Route Code',
                onChanged: (value) {
                  ShippingAddress.RouteCode = value;
                },
              ),
              getDisabledTextField(
                controller: RouteName,
                labelText: 'Route',
                onChanged: (value) {
                  ShippingAddress.RouteName = value;
                },
              ),
              getDisabledTextField(
                controller: CityName,
                labelText: 'City Name',
                onChanged: (value) {
                  ShippingAddress.CityName = value;
                },
              ),
              getDisabledTextField(
                controller: StateName,
                labelText: 'State Name',
                onChanged: (value) {
                  ShippingAddress.StateName = value;
                },
              ),
              getDisabledTextField(
                controller: CountryName,
                labelText: 'Country Name',
                onChanged: (value) {
                  ShippingAddress.CountryName = value;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

}
