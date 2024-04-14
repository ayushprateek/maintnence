import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maintenance/Component/AppConfig.dart';
import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/CustomDrawer.dart';
import 'package:maintenance/Component/GetCurrentLocation.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

class CustomLocationPermission extends StatefulWidget {
  @override
  _CustomLocationPermissionState createState() =>
      _CustomLocationPermissionState();
}

class _CustomLocationPermissionState extends State<CustomLocationPermission> {
  Future getCustomCurrentLocation(BuildContext context) async {
    String path = await getDatabasesPath();

    LocationPermission permission = await Geolocator.requestPermission();
    if (await Permission.locationWhenInUse
        .request()
        .isGranted) if (await Permission.locationAlways.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
    } else {
      Geolocator.openAppSettings();
    }

    bool isPermissionGranted = await Permission.locationAlways.isGranted;

    if (!isPermissionGranted) Geolocator.openAppSettings();
    bool isGranted = await Permission.locationAlways.isGranted;
    if (isGranted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            // backgroundColor: Colors.transparent,
            content: Container(
              height: MediaQuery.of(context).size.height / 20,
              width: MediaQuery.of(context).size.width / 1.5,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        },
      );
      Position pos = await getCurrentLocation();
      Navigator.pop(context);

      if (pos.latitude == 0.0) {
        CustomDrawer.hasEnabledLocation = false;

        getErrorSnackBar("Allow the app to access your location");
        Navigator.pop(context);
      } else if (Platform.isAndroid) {
        CustomDrawer.hasEnabledLocation = true;
        // var methodChannel = MethodChannel("LITSales");
        // String data = await methodChannel.invokeMethod("startService",{"user_id":userModel.Code,"dbPath":path});

        Navigator.pop(context);
      } else {
        if (Platform.isIOS) {
          CustomDrawer.hasEnabledLocation = true;
          // var methodChannel = MethodChannel("LITSales");
          // String data = await methodChannel
          //     .invokeMethod("track_location", {"user_id": "1", "dbPath": path});
          Navigator.pop(context);
        }
      }
    } else {
      getErrorSnackBar("Please Allow Location");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 4,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 60,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    // width: MediaQuery.of(context).size.width/3,
                    // height: MediaQuery.of(context).size.height/15,
                    color: barColor,
                    child: Image.asset(
                      logoPath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Divider(
              color: Colors.grey,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "$appName would like to access your location",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Material(
              borderRadius: BorderRadius.circular(20),
              child: MaterialButton(
                color: barColor,
                child: Text(
                  "OK, I understand",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  localStorage?.setString("seen_location_purpose", "True");
                  getCustomCurrentLocation(context);
                },
              ),
            )
          ],
        ),
      ),
    ));
  }
}
