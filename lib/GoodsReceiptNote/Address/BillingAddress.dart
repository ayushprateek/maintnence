import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/GetTextField.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/GoodsReceiptNote/Address/AddressLookup.dart';
import 'package:maintenance/Sync/SyncModels/PRPDN3.dart';
import 'package:maintenance/GoodsReceiptNote/GeneralData.dart';
import 'package:maintenance/GoodsReceiptNote/GoodsReceiptNote.dart';
import 'package:maps_launcher/maps_launcher.dart';
class BillingAddress extends StatefulWidget {
  const BillingAddress({super.key});
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

  static int? TransId, RowId, ID;
  static bool hasCreated = false, hasUpdated = false;
  static String? Addres,
      CityName,
      StateName,
      CountryName,
      AddCode,
      CityCode,
      StateCode,
      CountryCode;
  static double? Latitude, Longitude;

  static PRPDN3 getBillingAddress() {
    return PRPDN3(
        ID: 0,
        TransId: GeneralData.transId,
        hasCreated: hasCreated,
        hasUpdated: hasUpdated,
        RowId: RowId,
        AddressCode: AddCode,
        Address: Addres,
        CityCode: CityCode,
        CityName: CityName,
        StateCode: StateCode,
        StateName: StateName,
        CountryCode: CountryCode,
        CountryName: CountryName,
        Latitude: Latitude?.toString() ?? '',
        Longitude: Longitude?.toString() ?? '');
  }

  @override
  State<BillingAddress> createState() => _BillingAddressState();
}

class _BillingAddressState extends State<BillingAddress> {
  TextEditingController TransId = TextEditingController(
      text: BillingAddress.TransId == null
          ? ""
          : BillingAddress.TransId.toString());
  TextEditingController RowId = TextEditingController(
      text:
      BillingAddress.RowId == null ? "" : BillingAddress.RowId.toString());
  TextEditingController AddCode = TextEditingController(
      text: BillingAddress.AddCode == null
          ? ""
          : BillingAddress.AddCode.toString());

  TextEditingController CityName =
  TextEditingController(text: BillingAddress.CityName);
  TextEditingController CityCode = TextEditingController(
      text: BillingAddress.CityCode == null
          ? ""
          : BillingAddress.CityCode.toString());
  TextEditingController CountryName =
  TextEditingController(text: BillingAddress.CountryName);
  TextEditingController CountryCode = TextEditingController(
      text: BillingAddress.CountryCode == null
          ? ""
          : BillingAddress.CountryCode.toString());
  TextEditingController StateName =
  TextEditingController(text: BillingAddress.StateName);
  TextEditingController StateCode = TextEditingController(
      text: BillingAddress.StateCode == null
          ? ""
          : BillingAddress.StateCode.toString());
  TextEditingController Addres =
  TextEditingController(text: BillingAddress.Addres);
  TextEditingController ID = TextEditingController(
      text: BillingAddress.ID == null ? "" : BillingAddress.ID.toString());
  TextEditingController Latitude = TextEditingController(
      text: BillingAddress.Latitude == null
          ? ""
          : BillingAddress.Latitude.toString());
  TextEditingController Longitude = TextEditingController(
      text: BillingAddress.Longitude == null
          ? ""
          : BillingAddress.Longitude.toString());

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  BillingAddress.AddCode = value;
                },
                enableLookup: true,
                onLookupPressed: () {
                  if (isSelectedAndCancelled() || isSalesQuotationDocClosed()) {
                    getErrorSnackBar(
                        "This Document is already cancelled / closed");
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => AddressLookup(false))));
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
                        BillingAddress.Addres = value;
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
                          borderSide: new BorderSide(color: barColor, width: 1),
                        ),
                        hoverColor: Colors.red,
                        focusedBorder: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                          borderSide: new BorderSide(color: barColor, width: 1),
                        ),
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                          borderSide: new BorderSide(color: barColor, width: 1),
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
              controller: CityName,
              labelText: 'City Name',
              onChanged: (value) {
                BillingAddress.CityName = value;
              },
            ),
            getDisabledTextField(
              controller: StateName,
              labelText: 'State Name',
              onChanged: (value) {
                BillingAddress.StateName = value;
              },
            ),
            getDisabledTextField(
              controller: CountryName,
              labelText: 'Country Name',
              onChanged: (value) {
                BillingAddress.CountryName = value;
              },
            ),
          ],
        ),
      ),
    );
  }
}
